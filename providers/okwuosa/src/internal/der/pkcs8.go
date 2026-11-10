package der

import (
	"bytes"
	"encoding/asn1"
	"errors"
	"fmt"
)

// The private key is a PKCS#8 OneAsymmetricKey (RFC 5958 section 2; version 0 = v1) whose privateKey
// OCTET STRING holds a DER CHOICE of three forms:
//
//	ML-DSA: RFC 9881 section 6      ML-KEM: RFC 9935 section 6
//
//	XX-PrivateKey ::= CHOICE {
//	  seed        [0] OCTET STRING,            -- 32 bytes (DSA) / 64 bytes (KEM)
//	  expandedKey OCTET STRING,
//	  both        SEQUENCE { seed OCTET STRING, expandedKey OCTET STRING } }
//
// The outer OneAsymmetricKey is SEQUENCE { version INTEGER 0,
// AlgorithmIdentifier { OID }, privateKey OCTET STRING }.

// pkcs8 wraps the already-encoded CHOICE in the OneAsymmetricKey SEQUENCE.
// Callers pass well-formed OIDs; an invalid one is a programming error.
func pkcs8(oid asn1.ObjectIdentifier, choice []byte) []byte {
	id, err := algID(oid)
	if err != nil {
		panic(err)
	}
	version := []byte{tagInteger, 0x01, 0x00}
	return tlv(tagSequence, version, id, appendTLV(nil, tagOctetString, choice))
}

// PKCS8Seed encodes the seed form: privateKey = [0] IMPLICIT OCTET STRING
// (tag 0x80). RFC 9881 section 6, RFC 9935 section 6.
func PKCS8Seed(oid asn1.ObjectIdentifier, seed []byte) []byte {
	return pkcs8(oid, appendTLV(nil, tagCtx0Impl, seed))
}

// PKCS8Expanded encodes the expandedKey form: privateKey = OCTET STRING
// (tag 0x04) holding the expanded secret key. RFC 9881 section 6, RFC 9935
// section 6.
func PKCS8Expanded(oid asn1.ObjectIdentifier, sk []byte) []byte {
	return pkcs8(oid, appendTLV(nil, tagOctetString, sk))
}

// PKCS8Both encodes the both form: privateKey = SEQUENCE { OCTET STRING seed,
// OCTET STRING expandedKey } (tag 0x30). RFC 9881 section 6, RFC 9935
// section 6.
func PKCS8Both(oid asn1.ObjectIdentifier, seed, sk []byte) []byte {
	pair := tlv(tagSequence, appendTLV(nil, tagOctetString, seed), appendTLV(nil, tagOctetString, sk))
	return pkcs8(oid, pair)
}

// readTLV reads one single-byte-tag DER element from b and returns its tag,
// content, and the bytes after it. Lengths must be definite and minimal, as
// DER requires; anything else is an error. It never panics.
func readTLV(b []byte) (tag byte, content, rest []byte, err error) {
	return parseTLV(b, true)
}

// readTLVLax is readTLV for other people's certificates: a long-form length
// need not be minimal (as in BER, which OpenSSL accepts). Indefinite lengths
// and multi-byte tags are still errors.
func readTLVLax(b []byte) (tag byte, content, rest []byte, err error) {
	return parseTLV(b, false)
}

func parseTLV(b []byte, strict bool) (tag byte, content, rest []byte, err error) {
	if len(b) < 2 {
		return 0, nil, nil, errors.New("der: truncated header")
	}
	tag = b[0]
	if tag&0x1f == 0x1f {
		return 0, nil, nil, errors.New("der: multi-byte tags are not used here")
	}
	n, hdr := int(b[1]), 2
	if n >= 0x80 {
		nLen := n & 0x7f
		if nLen == 0 || nLen > 4 || len(b) < 2+nLen {
			return 0, nil, nil, errors.New("der: bad length encoding")
		}
		n = 0
		for _, c := range b[2 : 2+nLen] {
			n = n<<8 | int(c)
		}
		if strict && (b[2] == 0 || n < 0x80) {
			return 0, nil, nil, errors.New("der: non-minimal length")
		}
		hdr = 2 + nLen
	}
	if n < 0 || n > len(b)-hdr {
		return 0, nil, nil, errors.New("der: length exceeds data")
	}
	return tag, b[hdr : hdr+n], b[hdr+n:], nil
}

// readExact reads one element with the wanted tag and no bytes after it.
func readExact(b []byte, want byte, what string) ([]byte, error) {
	tag, content, rest, err := readTLV(b)
	if err != nil {
		return nil, fmt.Errorf("%s: %w", what, err)
	}
	if tag != want || len(rest) != 0 {
		return nil, fmt.Errorf("%s: want a lone element with tag %#02x", what, want)
	}
	return content, nil
}

// ParsePKCS8 parses a PKCS#8 file holding exactly one of the three private key
// forms. Seed-only returns expanded == nil; expanded-only returns seed == nil.
// It rejects trailing data, a version other than 0, algorithm parameters,
// attributes, and any other CHOICE. The returned slices are copies. It does
// not check the seed or key lengths against the algorithm; the caller must.
func ParsePKCS8(der []byte) (oid asn1.ObjectIdentifier, seed, expanded []byte, err error) {
	outer, err := readExact(der, tagSequence, "PKCS#8")
	if err != nil {
		return nil, nil, nil, err
	}
	version, rest, err := takeElement(outer, tagInteger, "version")
	if err != nil {
		return nil, nil, nil, err
	}
	if !bytes.Equal(version, []byte{0x00}) {
		return nil, nil, nil, errors.New("der: PKCS#8 version must be 0")
	}
	algBody, rest, err := takeElement(rest, tagSequence, "algorithm")
	if err != nil {
		return nil, nil, nil, err
	}
	// asn1.Unmarshal leaves unread bytes in rest; any (e.g. parameters) is an error.
	if left, uerr := asn1.Unmarshal(algBody, &oid); uerr != nil || len(left) != 0 {
		return nil, nil, nil, errors.New("der: algorithm must be exactly one OID with no parameters")
	}
	choice, err := readExact(rest, tagOctetString, "privateKey")
	if err != nil {
		return nil, nil, nil, err
	}
	seed, expanded, err = parseChoice(choice)
	if err != nil {
		return nil, nil, nil, err
	}
	return oid, seed, expanded, nil
}

// takeElement reads one element with the wanted tag and returns its content
// and the bytes after it.
func takeElement(b []byte, want byte, what string) (content, rest []byte, err error) {
	tag, content, rest, err := readTLV(b)
	if err != nil {
		return nil, nil, fmt.Errorf("%s: %w", what, err)
	}
	if tag != want {
		return nil, nil, fmt.Errorf("%s: unexpected tag %#02x", what, tag)
	}
	return content, rest, nil
}

// parseChoice decodes the CHOICE inside the privateKey OCTET STRING, selecting
// the variant by its tag (RFC 9881 section 6), never by length.
func parseChoice(b []byte) (seed, expanded []byte, err error) {
	tag, content, rest, err := readTLV(b)
	if err != nil {
		return nil, nil, fmt.Errorf("private key choice: %w", err)
	}
	if len(rest) != 0 {
		return nil, nil, errors.New("der: trailing data after private key choice")
	}
	if len(content) == 0 {
		return nil, nil, errors.New("der: empty private key value")
	}
	switch tag {
	case tagCtx0Impl:
		return bytes.Clone(content), nil, nil
	case tagOctetString:
		return nil, bytes.Clone(content), nil
	case tagSequence:
		return parseBoth(content)
	}
	return nil, nil, fmt.Errorf("der: unknown private key choice tag %#02x", tag)
}

// parseBoth decodes SEQUENCE { OCTET STRING seed, OCTET STRING expandedKey }.
func parseBoth(content []byte) (seed, expanded []byte, err error) {
	seed, rest, err := takeElement(content, tagOctetString, "both.seed")
	if err != nil {
		return nil, nil, err
	}
	expanded, err = readExact(rest, tagOctetString, "both.expandedKey")
	if err != nil {
		return nil, nil, err
	}
	if len(seed) == 0 || len(expanded) == 0 {
		return nil, nil, errors.New("der: empty seed or expandedKey")
	}
	return bytes.Clone(seed), bytes.Clone(expanded), nil
}
