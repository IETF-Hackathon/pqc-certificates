package check

import (
	"bytes"
	"errors"
	"fmt"

	"github.com/cloudflare/circl/sign"

	"pqccerts/okwuosa/internal/alg"
	"pqccerts/okwuosa/internal/der"
	"pqccerts/okwuosa/internal/pqc"
)

// errNotMLDSA marks a public key of another algorithm, which we cannot verify with.
var errNotMLDSA = errors.New("public key algorithm is not ML-DSA")

// taState is a trust anchor as far as it could be read.
type taState struct {
	name    string
	present bool
	cert    *der.ParsedCert // nil when absent or unparseable
	err     error           // why cert is nil, when present
}

func loadTA(files map[string][]byte, a alg.Alg) taState {
	name, data, ok := find(files, a, "_ta.der")
	if !ok {
		return taState{}
	}
	c, err := der.ParseCertificate(data)
	return taState{name: name, present: true, cert: c, err: err}
}

// dsaPublic is an ML-DSA public key taken from a certificate.
type dsaPublic struct {
	scheme sign.Scheme
	key    sign.PublicKey
	bytes  []byte
	oid    string
}

// publicKeyOf reads the SubjectPublicKeyInfo of c as an ML-DSA public key.
func publicKeyOf(c *der.ParsedCert) (dsaPublic, error) {
	oid := c.PubAlg.OID.String()
	a, ok := alg.ByOID(oid)
	if !ok || a.IsKEM {
		return dsaPublic{}, fmt.Errorf("%w: %s", errNotMLDSA, oid)
	}
	s, _ := pqc.DSAScheme(a.Level)
	if len(c.PublicKey) != s.PublicKeySize() {
		return dsaPublic{}, fmt.Errorf("public key is %d bytes, want %d", len(c.PublicKey), s.PublicKeySize())
	}
	var key sign.PublicKey
	err := guard(func() (e error) { key, e = s.UnmarshalBinaryPublicKey(c.PublicKey); return })
	if err != nil {
		return dsaPublic{}, err
	}
	return dsaPublic{scheme: s, key: key, bytes: c.PublicKey, oid: oid}, nil
}

// verifies reports whether sig is a valid pure ML-DSA signature (empty
// context) of msg under the key. A wrong-length signature is not valid.
func (p dsaPublic) verifies(msg, sig []byte) bool {
	if len(sig) != p.scheme.SignatureSize() {
		return false
	}
	ok := false
	if guard(func() error { ok = p.scheme.Verify(p.key, msg, sig, nil); return nil }) != nil {
		return false
	}
	return ok
}

// checkSelfSigned is the `cert` row of a TA, as `openssl verify -no_check_time
// -check_ss_sig -CAfile TA TA` sees it: the certificate is self-issued, its
// signature algorithm is the one of its own key and the same in the TBS, and
// its signature verifies under that key. It does not look at CA or key-usage
// flags. In our test with OpenSSL 3.5.9, `openssl verify -check_ss_sig`
// rejected a self-signed CA certificate whose keyUsage was digitalSignature
// only; this function would not.
func checkSelfSigned(c *der.ParsedCert) error {
	pub, err := publicKeyOf(c)
	if err != nil {
		return err
	}
	if err := sigAlgMatches(c, pub.oid); err != nil {
		return err
	}
	if !bytes.Equal(c.Issuer, c.Subject) {
		return errors.New("issuer and subject differ")
	}
	if !pub.verifies(c.TBS, c.Signature) {
		return errors.New("self-signature does not verify")
	}
	return nil
}

// sigAlgMatches requires the outer and TBS signature algorithms to agree and
// to name the signing key's algorithm.
func sigAlgMatches(c *der.ParsedCert, signerOID string) error {
	if c.SigAlg.OID.String() != signerOID {
		return fmt.Errorf("signature algorithm %v is not the signing key's %s", c.SigAlg.OID, signerOID)
	}
	if !c.SigAlg.OID.Equal(c.TBSSigAlg.OID) || c.SigAlg.HasParams != c.TBSSigAlg.HasParams {
		return errors.New("signature algorithm differs between the TBS and the certificate")
	}
	return nil
}

// checkIssuedBy verifies the signature of c under the public key of ta. It is
// a strict check only: the CI does not verify EE signatures.
func checkIssuedBy(c *der.ParsedCert, ta *der.ParsedCert) error {
	pub, err := publicKeyOf(ta)
	if err != nil {
		return fmt.Errorf("TA: %w", err)
	}
	if err := sigAlgMatches(c, pub.oid); err != nil {
		return err
	}
	if !pub.verifies(c.TBS, c.Signature) {
		return errors.New("signature does not verify")
	}
	return nil
}

// strictCert reports oddities that neither the CI nor a row depends on.
func strictCert(name string, c *der.ParsedCert) []Finding {
	var fs []Finding
	if c.TrailingBytes != 0 {
		fs = append(fs, Finding{File: name, Check: "strict", Detail: fmt.Sprintf("%d bytes after the certificate", c.TrailingBytes)})
	}
	if c.SigAlg.HasParams {
		fs = append(fs, Finding{File: name, Check: "strict", Detail: "signature algorithm has parameters"})
	}
	return fs
}
