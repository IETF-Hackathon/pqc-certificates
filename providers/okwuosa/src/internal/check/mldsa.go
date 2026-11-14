package check

import (
	"bytes"
	"errors"
	"fmt"

	"github.com/cloudflare/circl/sign"

	"pqccerts/okwuosa/internal/alg"
	"pqccerts/okwuosa/internal/pqc"
)

// dsaKey is a private key that loaded, with the public key it derives.
type dsaKey struct {
	scheme   sign.Scheme
	sk       sign.PrivateKey
	pub      []byte
	embedded []byte // the public key attached to the private key, if any
}

// loadDSAKey reads a private key file of the wanted form. As OpenSSL does,
// the both form must have a seed that regenerates the expanded key, and an
// expanded key must be internally consistent (here: it signs a message that
// verifies under the public key derived from it).
func loadDSAKey(data []byte, a alg.Alg, form string) (k dsaKey, err error) {
	s, ok := pqc.DSAScheme(a.Level)
	if !ok {
		return k, fmt.Errorf("%s is not an ML-DSA algorithm", a.Friendly)
	}
	pk, err := splitKey(data, a, form, s.SeedSize(), s.PrivateKeySize())
	if err != nil {
		return k, err
	}
	err = guard(func() error {
		var e error
		if k.sk, e = buildDSAKey(s, pk.Seed, pk.Expanded); e != nil {
			return e
		}
		k.scheme, k.embedded = s, pk.PublicKey
		pub, ok := k.sk.Public().(sign.PublicKey)
		if !ok {
			return errors.New("no public key")
		}
		if k.pub, e = pub.MarshalBinary(); e != nil {
			return e
		}
		if pk.Seed == nil {
			return selfTest(s, k)
		}
		return nil
	})
	return k, err
}

func buildDSAKey(s sign.Scheme, seed, expanded []byte) (sign.PrivateKey, error) {
	if seed == nil {
		return s.UnmarshalBinaryPrivateKey(expanded)
	}
	_, sk := s.DeriveKey(seed)
	if expanded == nil {
		return sk, nil
	}
	packed, err := sk.MarshalBinary()
	if err != nil {
		return nil, err
	}
	if !bytes.Equal(packed, expanded) {
		return nil, errors.New("the seed does not regenerate the expanded key")
	}
	return sk, nil
}

// selfTest signs with the key and verifies under the public key derived from it.
func selfTest(s sign.Scheme, k dsaKey) error {
	pub, err := s.UnmarshalBinaryPublicKey(k.pub)
	if err != nil {
		return err
	}
	sig := s.Sign(k.sk, []byte(testMessage), nil)
	if !s.Verify(pub, []byte(testMessage), sig, nil) {
		return errors.New("expanded key does not sign consistently with its own public key")
	}
	return nil
}

// signsUnder is the CI's sig check: sign the test message with the key and
// verify with the TA's public key.
func (k dsaKey) signsUnder(ta dsaPublic) (ok bool) {
	var sig []byte
	if guard(func() error { sig = k.scheme.Sign(k.sk, []byte(testMessage), nil); return nil }) != nil {
		return false
	}
	return ta.verifies([]byte(testMessage), sig)
}

// CheckMLDSA runs the CI-equivalent checks for one ML-DSA algorithm over the
// files that are present. A check we cannot run produces a Finding, no Row.
// Rows are in the order seed, expandedkey, both, cert, consistent.
func CheckMLDSA(files map[string][]byte, a alg.Alg) ([]Row, []Finding) {
	ta := loadTA(files, a)
	var rows []Row
	var fs []Finding
	var pub dsaPublic
	var pubErr error
	if ta.cert != nil {
		pub, pubErr = publicKeyOf(ta.cert)
	} else {
		pubErr = ta.err
	}
	cons := consistency{}
	for _, kt := range keyTypes {
		name, data, ok := find(files, a, kt.suffix)
		if !ok {
			continue
		}
		if !ta.present {
			fs = append(fs, Finding{File: name, Check: "cannot-run", Detail: "no TA was present to verify the signature against"})
			continue
		}
		key, kerr := loadDSAKey(data, a, kt.typ)
		rows = append(rows, Row{a.OID, kt.typ, kerr == nil && pubErr == nil && key.signsUnder(pub)})
		fs = append(fs, strictKey(name, key.embedded, key.pub)...)
		if kerr != nil {
			fs = append(fs, Finding{File: name, Check: "failed", Detail: kerr.Error()})
		}
		cons.add(consistentDSA(data, a, kt.typ, pub, pubErr))
	}
	if ta.present {
		row, f := taRow(a, ta)
		rows, fs = append(rows, row...), append(fs, f...)
	}
	if r, ok := cons.row(a); ok {
		rows = append(rows, r)
	}
	return rows, fs
}

// consistentDSA is one key's consistency check. For the expanded file the CI
// forces no input format, so any form loads.
func consistentDSA(data []byte, a alg.Alg, typ string, pub dsaPublic, pubErr error) bool {
	form := typ
	if typ == formExpanded {
		form = formAny
	}
	key, err := loadDSAKey(data, a, form)
	return err == nil && pubErr == nil && pub.oid == a.OID && bytes.Equal(key.pub, pub.bytes)
}

// taRow is the `cert` row, plus findings: a TA we cannot verify (its key is
// not ML-DSA) gives no row.
func taRow(a alg.Alg, ta taState) ([]Row, []Finding) {
	if ta.cert == nil {
		return []Row{{a.OID, "cert", false}}, []Finding{{File: ta.name, Check: "failed", Detail: ta.err.Error()}}
	}
	fs := strictCert(ta.name, ta.cert)
	if _, err := publicKeyOf(ta.cert); errors.Is(err, errNotMLDSA) {
		return nil, append(fs, Finding{File: ta.name, Check: "cannot-run", Detail: err.Error()})
	}
	err := checkSelfSigned(ta.cert)
	if err != nil {
		fs = append(fs, Finding{File: ta.name, Check: "failed", Detail: err.Error()})
	}
	return []Row{{a.OID, "cert", err == nil}}, fs
}

// consistency folds the per-key results into the CI's single `consistent`
// row: N if any key failed, Y if at least one passed and none failed.
type consistency struct{ pass, fail int }

func (c *consistency) add(ok bool) {
	if ok {
		c.pass++
	} else {
		c.fail++
	}
}

func (c consistency) row(a alg.Alg) (Row, bool) {
	if c.pass+c.fail == 0 {
		return Row{}, false
	}
	return Row{a.OID, "consistent", c.fail == 0}, true
}
