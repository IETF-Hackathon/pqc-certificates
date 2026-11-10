package der

import (
	"encoding/asn1"
	"errors"
	"fmt"
)

// Algorithm is an AlgorithmIdentifier as found in a certificate.
type Algorithm struct {
	OID       asn1.ObjectIdentifier
	HasParams bool
}

// ParsedCert holds the parts of a parsed X.509 certificate that a signature
// check needs. The slices alias the input.
type ParsedCert struct {
	TBS       []byte // the TBSCertificate exactly as it appears, header included
	Issuer    []byte // the issuer Name as it appears, header included
	Subject   []byte // the subject Name as it appears, header included
	TBSSigAlg Algorithm
	SigAlg    Algorithm
	PubAlg    Algorithm
	Signature []byte // the signature BIT STRING content, without the unused-bits octet
	PublicKey []byte // the subjectPublicKey BIT STRING content, likewise
	// TrailingBytes counts bytes after the Certificate SEQUENCE.
	TrailingBytes int
}

// ParseCertificate reads the structure of RFC 5280 section 4.1 by walking
// TLVs: Certificate ::= SEQUENCE { tbsCertificate, signatureAlgorithm,
// signatureValue }. Inside the TBS it skips the optional [0] version and reads
// the serial number, signature algorithm, issuer, validity, subject and
// SubjectPublicKeyInfo; everything after that (extensions) is not looked at.
// Long-form lengths need not be minimal, as in BER. It never panics.
func ParseCertificate(der []byte) (*ParsedCert, error) {
	tag, body, after, err := readTLVLax(der)
	if err != nil || tag != tagSequence {
		return nil, errors.New("certificate is not a DER SEQUENCE")
	}
	tbs, rest, err := laxRaw(body, tagSequence, "tbsCertificate")
	if err != nil {
		return nil, err
	}
	c := &ParsedCert{TBS: tbs, TrailingBytes: len(after)}
	if c.SigAlg, rest, err = laxAlgorithm(rest, "signatureAlgorithm"); err != nil {
		return nil, err
	}
	// Anything after the signature inside the SEQUENCE is ignored.
	if c.Signature, _, err = laxBitString(rest, "signatureValue"); err != nil {
		return nil, err
	}
	if err := parseTBS(tbs, c); err != nil {
		return nil, err
	}
	return c, nil
}

func parseTBS(tbsRaw []byte, c *ParsedCert) error {
	tbs, _, err := laxContent(tbsRaw, tagSequence, "tbsCertificate")
	if err != nil {
		return err
	}
	if len(tbs) > 0 && tbs[0] == tagCtx0Expl { // optional [0] version
		if _, tbs, err = laxContent(tbs, tagCtx0Expl, "version"); err != nil {
			return err
		}
	}
	if _, tbs, err = laxContent(tbs, tagInteger, "serialNumber"); err != nil {
		return err
	}
	if c.TBSSigAlg, tbs, err = laxAlgorithm(tbs, "signature"); err != nil {
		return err
	}
	if c.Issuer, tbs, err = laxRaw(tbs, tagSequence, "issuer"); err != nil {
		return err
	}
	if _, tbs, err = laxContent(tbs, tagSequence, "validity"); err != nil {
		return err
	}
	if c.Subject, tbs, err = laxRaw(tbs, tagSequence, "subject"); err != nil {
		return err
	}
	info, _, err := laxContent(tbs, tagSequence, "subjectPublicKeyInfo")
	if err != nil {
		return err
	}
	if c.PubAlg, info, err = laxAlgorithm(info, "subjectPublicKeyInfo algorithm"); err != nil {
		return err
	}
	c.PublicKey, _, err = laxBitString(info, "subjectPublicKey")
	return err
}

// laxContent reads one element with the wanted tag and returns its content and
// the bytes after it.
func laxContent(b []byte, want byte, what string) (content, rest []byte, err error) {
	tag, content, rest, err := readTLVLax(b)
	if err != nil {
		return nil, nil, fmt.Errorf("%s: %w", what, err)
	}
	if tag != want {
		return nil, nil, fmt.Errorf("%s: unexpected tag %#02x", what, tag)
	}
	return content, rest, nil
}

// laxRaw is laxContent but returns the element whole, header included.
func laxRaw(b []byte, want byte, what string) (raw, rest []byte, err error) {
	_, rest, err = laxContent(b, want, what)
	if err != nil {
		return nil, nil, err
	}
	return b[:len(b)-len(rest)], rest, nil
}

// laxAlgorithm reads AlgorithmIdentifier ::= SEQUENCE { algorithm OID,
// parameters ANY OPTIONAL }; it records only whether parameters are present.
func laxAlgorithm(b []byte, what string) (Algorithm, []byte, error) {
	body, rest, err := laxContent(b, tagSequence, what)
	if err != nil {
		return Algorithm{}, nil, err
	}
	oidRaw, params, err := laxRaw(body, tagOID, what+" OID")
	if err != nil {
		return Algorithm{}, nil, err
	}
	var oid asn1.ObjectIdentifier
	if _, err := asn1.Unmarshal(oidRaw, &oid); err != nil {
		return Algorithm{}, nil, fmt.Errorf("%s OID: %w", what, err)
	}
	return Algorithm{OID: oid, HasParams: len(params) > 0}, rest, nil
}

// laxBitString reads a BIT STRING that holds whole bytes (no unused bits) and
// returns the bytes without the leading unused-bits octet.
func laxBitString(b []byte, what string) (bits, rest []byte, err error) {
	content, rest, err := laxContent(b, tagBitString, what)
	if err != nil {
		return nil, nil, err
	}
	if len(content) == 0 || content[0] != 0 {
		return nil, nil, fmt.Errorf("%s: BIT STRING is empty or has unused bits", what)
	}
	return content[1:], rest, nil
}
