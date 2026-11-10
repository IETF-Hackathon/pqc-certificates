// Package der builds X.509 certificates and PKCS#8 private keys byte by byte.
//
// It uses no crypto/x509 and no signing code: the caller passes in the
// public key bytes and the signature, and this package only lays them out
// as DER. Every function says which ASN.1 structure it emits.
package der

import (
	"encoding/asn1"
	"errors"
	"fmt"
	"math/big"
	"time"
)

// DER tag bytes used in this package.
const (
	tagBoolean     = 0x01
	tagInteger     = 0x02
	tagBitString   = 0x03
	tagOctetString = 0x04
	tagOID         = 0x06
	tagUTF8String  = 0x0c
	tagUTCTime     = 0x17
	tagGenTime     = 0x18
	tagSequence    = 0x30
	tagSet         = 0x31
	tagCtx0Impl    = 0x80 // [0] IMPLICIT, primitive
	tagCtx0Expl    = 0xa0 // [0] EXPLICIT, constructed
	tagCtx3Expl    = 0xa3 // [3] EXPLICIT, constructed
)

// Object identifiers (RFC 5280: extensions in section 4.2.1.x, attribute types in appendix A).
var (
	oidCommonName   = asn1.ObjectIdentifier{2, 5, 4, 3}
	oidOrganization = asn1.ObjectIdentifier{2, 5, 4, 10}
	oidSKI          = asn1.ObjectIdentifier{2, 5, 29, 14}
	oidKeyUsage     = asn1.ObjectIdentifier{2, 5, 29, 15}
	oidBasicCons    = asn1.ObjectIdentifier{2, 5, 29, 19}
	oidAKI          = asn1.ObjectIdentifier{2, 5, 29, 35}
)

// utcTimeLastYear is the last year RFC 5280 section 4.1.2.5 encodes as a
// UTCTime; dates in 2050 or later MUST be GeneralizedTime. The first year a
// UTCTime can hold is 1950: section 4.1.2.5.1 reads two-digit years 50..99 as
// 19xx and 00..49 as 20xx.
const (
	utcTimeFirstYear = 1950
	utcTimeLastYear  = 2049
	maxYear          = 9999
)

// Name is the subject or issuer. CN is required; O is omitted when empty.
type Name struct{ CN, O string }

// CertParams is everything TBS needs to lay out a v3 TBSCertificate.
type CertParams struct {
	Serial          *big.Int
	Issuer, Subject Name
	NotBefore       time.Time
	NotAfter        time.Time
	SigOID, PubOID  asn1.ObjectIdentifier
	PublicKey       []byte
	IsCA            bool
	KeyUsage        asn1.BitString
	SKI, AKI        []byte // AKI nil for a self-signed certificate
}

// appendTLV appends tag, a DER definite length, and content to dst.
func appendTLV(dst []byte, tag byte, content []byte) []byte {
	dst = append(dst, tag)
	n := len(content)
	switch {
	case n < 0x80:
		dst = append(dst, byte(n))
	case n < 0x100:
		dst = append(dst, 0x81, byte(n))
	case n < 0x10000:
		dst = append(dst, 0x82, byte(n>>8), byte(n))
	case n < 0x1000000:
		dst = append(dst, 0x83, byte(n>>16), byte(n>>8), byte(n))
	default:
		dst = append(dst, 0x84, byte(n>>24), byte(n>>16), byte(n>>8), byte(n))
	}
	return append(dst, content...)
}

// tlv is appendTLV on a fresh slice, with the content given as several parts.
func tlv(tag byte, parts ...[]byte) []byte {
	var content []byte
	for _, p := range parts {
		content = append(content, p...)
	}
	return appendTLV(nil, tag, content)
}

// oidDER encodes an OBJECT IDENTIFIER (tag 06).
func oidDER(oid asn1.ObjectIdentifier) ([]byte, error) {
	if len(oid) < 2 {
		return nil, fmt.Errorf("der: invalid OID %v", oid)
	}
	return asn1.Marshal(oid)
}

// algID encodes AlgorithmIdentifier ::= SEQUENCE { algorithm OID } with the
// parameters field absent, as RFC 9881 section 2 and RFC 9935 section 3 require.
func algID(oid asn1.ObjectIdentifier) ([]byte, error) {
	o, err := oidDER(oid)
	if err != nil {
		return nil, err
	}
	return tlv(tagSequence, o), nil
}

// bitString encodes a BIT STRING in minimal DER form: the unused-bits octet
// counts only trailing zero bits that were trimmed, so a value with no set
// bits is 03 01 00. Zero bits at the end of bs are dropped, as DER requires
// for named-bit lists such as KeyUsage (ITU-T X.690 (02/2021) clause 11.2.2).
func bitString(bs asn1.BitString) []byte {
	last := -1 // index of the last set bit
	for i := 0; i < bs.BitLength && i/8 < len(bs.Bytes); i++ {
		if bs.Bytes[i/8]&(0x80>>(i%8)) != 0 {
			last = i
		}
	}
	if last < 0 {
		return []byte{tagBitString, 0x01, 0x00}
	}
	nBytes := last/8 + 1
	unused := byte(nBytes*8 - (last + 1))
	content := append([]byte{unused}, bs.Bytes[:nBytes]...)
	content[nBytes] &= 0xff << unused // clear any stray bits past the last set one
	return appendTLV(nil, tagBitString, content)
}

// encodeTime encodes a Time as UTCTime (years 1950..2049) or GeneralizedTime
// (2050 onwards), always in UTC with whole seconds, per RFC 5280 sections 4.1.2.5 and 4.1.2.5.1.
func encodeTime(t time.Time) ([]byte, error) {
	t = t.UTC()
	switch y := t.Year(); {
	case y < utcTimeFirstYear || y > maxYear:
		return nil, fmt.Errorf("der: year %d is outside 1950..9999", y)
	case y <= utcTimeLastYear:
		return appendTLV(nil, tagUTCTime, []byte(t.Format("060102150405Z"))), nil
	default:
		return appendTLV(nil, tagGenTime, []byte(t.Format("20060102150405Z"))), nil
	}
}

// encodeName encodes Name ::= SEQUENCE OF RelativeDistinguishedName with one
// attribute per RDN: O first (when present), then CN, both as UTF8String.
// This is the same order Go's crypto/x509 uses for the go-crypto provider.
func encodeName(n Name) ([]byte, error) {
	if n.CN == "" {
		return nil, errors.New("der: Name needs a CN")
	}
	var rdns []byte
	if n.O != "" {
		rdns = append(rdns, rdn(oidOrganization, n.O)...)
	}
	rdns = append(rdns, rdn(oidCommonName, n.CN)...)
	return tlv(tagSequence, rdns), nil
}

// rdn encodes SET { SEQUENCE { attributeType OID, attributeValue UTF8String } }.
func rdn(oid asn1.ObjectIdentifier, value string) []byte {
	o, _ := oidDER(oid) // package constants, always valid
	return tlv(tagSet, tlv(tagSequence, o, appendTLV(nil, tagUTF8String, []byte(value))))
}

// encodeValidity encodes Validity ::= SEQUENCE { notBefore Time, notAfter Time }.
func encodeValidity(notBefore, notAfter time.Time) ([]byte, error) {
	if notAfter.Before(notBefore) {
		return nil, errors.New("der: NotAfter is before NotBefore")
	}
	nb, err := encodeTime(notBefore)
	if err != nil {
		return nil, err
	}
	na, err := encodeTime(notAfter)
	if err != nil {
		return nil, err
	}
	return tlv(tagSequence, nb, na), nil
}

// spki encodes SubjectPublicKeyInfo ::= SEQUENCE { AlgorithmIdentifier,
// subjectPublicKey BIT STRING } with the raw key as the BIT STRING content.
func spki(oid asn1.ObjectIdentifier, key []byte) []byte {
	id, err := algID(oid)
	if err != nil {
		return nil
	}
	bits := appendTLV(nil, tagBitString, append([]byte{0x00}, key...))
	return tlv(tagSequence, id, bits)
}

// extension encodes Extension ::= SEQUENCE { extnID OID, critical BOOLEAN
// DEFAULT FALSE, extnValue OCTET STRING }. DER omits critical when FALSE.
func extension(oid asn1.ObjectIdentifier, critical bool, value []byte) []byte {
	o, _ := oidDER(oid)
	parts := [][]byte{o}
	if critical {
		parts = append(parts, []byte{tagBoolean, 0x01, 0xff})
	}
	parts = append(parts, appendTLV(nil, tagOctetString, value))
	return tlv(tagSequence, parts...)
}

// basicConstraintsValue encodes BasicConstraints ::= SEQUENCE { cA BOOLEAN
// DEFAULT FALSE }. CA:TRUE is SEQUENCE{BOOLEAN TRUE}; CA:FALSE is the default,
// so DER leaves it out and the SEQUENCE is empty.
func basicConstraintsValue(isCA bool) []byte {
	if isCA {
		return tlv(tagSequence, []byte{tagBoolean, 0x01, 0xff})
	}
	return tlv(tagSequence)
}

// akiValue encodes AuthorityKeyIdentifier ::= SEQUENCE { keyIdentifier [0]
// IMPLICIT OCTET STRING }.
func akiValue(keyID []byte) []byte {
	return tlv(tagSequence, appendTLV(nil, tagCtx0Impl, keyID))
}

// encodeExtensions encodes [3] EXPLICIT Extensions in the order basicConstraints
// (critical), keyUsage (critical), subjectKeyIdentifier, authorityKeyIdentifier.
// SKI and AKI are left out when nil.
func encodeExtensions(p CertParams) []byte {
	exts := extension(oidBasicCons, true, basicConstraintsValue(p.IsCA))
	exts = append(exts, extension(oidKeyUsage, true, bitString(p.KeyUsage))...)
	if p.SKI != nil {
		exts = append(exts, extension(oidSKI, false, appendTLV(nil, tagOctetString, p.SKI))...)
	}
	if p.AKI != nil {
		exts = append(exts, extension(oidAKI, false, akiValue(p.AKI))...)
	}
	return tlv(tagCtx3Expl, tlv(tagSequence, exts))
}

// validate checks the fields TBS cannot do without.
func (p CertParams) validate() error {
	switch {
	case p.Serial == nil || p.Serial.Sign() <= 0:
		return errors.New("der: serial must be a positive integer")
	case len(p.PublicKey) == 0:
		return errors.New("der: empty public key")
	}
	return nil
}

// TBS returns the DER TBSCertificate (RFC 5280 section 4.1):
//
//	SEQUENCE {
//	  [0] EXPLICIT INTEGER 2          -- version v3
//	  INTEGER                         -- serialNumber
//	  AlgorithmIdentifier             -- signature (parameters absent)
//	  Name                            -- issuer
//	  Validity
//	  Name                            -- subject
//	  SubjectPublicKeyInfo
//	  [3] EXPLICIT Extensions
//	}
func TBS(p CertParams) ([]byte, error) {
	if err := p.validate(); err != nil {
		return nil, err
	}
	sigAlg, err := algID(p.SigOID)
	if err != nil {
		return nil, fmt.Errorf("signature algorithm: %w", err)
	}
	if _, err := oidDER(p.PubOID); err != nil {
		return nil, fmt.Errorf("public key algorithm: %w", err)
	}
	issuer, err := encodeName(p.Issuer)
	if err != nil {
		return nil, fmt.Errorf("issuer: %w", err)
	}
	subject, err := encodeName(p.Subject)
	if err != nil {
		return nil, fmt.Errorf("subject: %w", err)
	}
	validity, err := encodeValidity(p.NotBefore, p.NotAfter)
	if err != nil {
		return nil, err
	}
	version := tlv(tagCtx0Expl, []byte{tagInteger, 0x01, 0x02})
	return tlv(tagSequence, version, encodeSerial(p.Serial), sigAlg, issuer,
		validity, subject, spki(p.PubOID, p.PublicKey), encodeExtensions(p)), nil
}

// encodeSerial encodes a positive INTEGER. big.Int.Bytes() is the unsigned
// magnitude, so a 0x00 is prepended when the top bit is set to keep it positive.
func encodeSerial(n *big.Int) []byte {
	b := n.Bytes()
	if b[0]&0x80 != 0 {
		b = append([]byte{0x00}, b...)
	}
	return appendTLV(nil, tagInteger, b)
}

// Certificate wraps a TBSCertificate and its signature (RFC 5280 section 4.1):
//
//	SEQUENCE { tbsCertificate, signatureAlgorithm AlgorithmIdentifier,
//	           signatureValue BIT STRING }
//
// sigOID must be the same OID that was put in the TBS signature field.
func Certificate(tbs []byte, sigOID asn1.ObjectIdentifier, sig []byte) ([]byte, error) {
	if len(tbs) == 0 || tbs[0] != tagSequence {
		return nil, errors.New("der: tbs is not a DER SEQUENCE")
	}
	if len(sig) == 0 {
		return nil, errors.New("der: empty signature")
	}
	id, err := algID(sigOID)
	if err != nil {
		return nil, err
	}
	bits := appendTLV(nil, tagBitString, append([]byte{0x00}, sig...))
	return tlv(tagSequence, tbs, id, bits), nil
}
