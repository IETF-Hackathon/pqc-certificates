package der

import (
	"bytes"
	"encoding/asn1"
	"errors"
	"fmt"
)

// tagCtx1Impl is [1] IMPLICIT, primitive: the publicKey of a OneAsymmetricKey.
const tagCtx1Impl = 0x81

// PrivateKey is a parsed OneAsymmetricKey (RFC 5958 section 2) that holds one
// of the three ML-DSA / ML-KEM private key forms.
type PrivateKey struct {
	OID       asn1.ObjectIdentifier
	Seed      []byte // nil unless the seed or both form
	Expanded  []byte // nil unless the expanded or both form
	Version   int    // 0 (v1) or 1 (v2)
	PublicKey []byte // the optional [1] publicKey, without the unused-bits octet
	// HasAttributes is set when the optional [0] attributes are present.
	HasAttributes bool
}

// ParsePrivateKey reads a PKCS#8 file the way OpenSSL does when it loads one:
// unlike ParsePKCS8 it accepts version 1 and the optional [0] attributes and
// [1] publicKey that come with it, and non-minimal long-form lengths in the
// outer structure. It still requires exactly one OID without parameters, one
// of the three CHOICE forms, and no data after the key. It does not check the
// key lengths against the algorithm. It never panics.
func ParsePrivateKey(der []byte) (PrivateKey, error) {
	var k PrivateKey
	tag, body, after, err := readTLVLax(der)
	if err != nil || tag != tagSequence {
		return k, errors.New("PKCS#8 is not a DER SEQUENCE")
	}
	if len(after) != 0 {
		return k, errors.New("PKCS#8: trailing data")
	}
	version, rest, err := laxContent(body, tagInteger, "version")
	if err != nil {
		return k, err
	}
	if len(version) != 1 || version[0] > 1 {
		return k, fmt.Errorf("PKCS#8 version %x, want 0 or 1", version)
	}
	k.Version = int(version[0])
	algorithm, rest, err := laxAlgorithm(rest, "algorithm")
	if err != nil {
		return k, err
	}
	if algorithm.HasParams {
		return k, errors.New("algorithm must be exactly one OID with no parameters")
	}
	k.OID = algorithm.OID
	choice, rest, err := laxContent(rest, tagOctetString, "privateKey")
	if err != nil {
		return k, err
	}
	if k.Seed, k.Expanded, err = parseChoice(choice); err != nil {
		return PrivateKey{}, err
	}
	return k, parseKeyTail(rest, &k)
}

// parseKeyTail reads the optional [0] attributes and [1] publicKey.
func parseKeyTail(rest []byte, k *PrivateKey) error {
	if len(rest) > 0 && rest[0] == tagCtx0Expl {
		var err error
		if _, rest, err = laxContent(rest, tagCtx0Expl, "attributes"); err != nil {
			return err
		}
		k.HasAttributes = true
	}
	if len(rest) > 0 && rest[0] == tagCtx1Impl {
		content, after, err := laxContent(rest, tagCtx1Impl, "publicKey")
		if err != nil {
			return err
		}
		if len(content) == 0 || content[0] != 0 {
			return errors.New("publicKey: BIT STRING is empty or has unused bits")
		}
		k.PublicKey, rest = bytes.Clone(content[1:]), after
	}
	if len(rest) != 0 {
		return errors.New("PKCS#8: unexpected data after the private key")
	}
	return nil
}
