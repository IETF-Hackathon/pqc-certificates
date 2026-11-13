package check

import (
	"bytes"
	"fmt"

	frodo "github.com/kuking/go-frodokem"

	"pqccerts/okwuosa/internal/alg"
	"pqccerts/okwuosa/internal/der"
)

// privSuffix is the single private key file of a FrodoKEM artifact set. There
// is no seed form: the PKCS#8 privateKey holds the secret key in an OCTET
// STRING, which the parser reports as the expanded form.
const privSuffix = "_priv.der"

// frodoScheme returns the library's parameter set for one of the eFrodoKEM
// algorithms. The library implements FrodoKEM as submitted to NIST round 3,
// which is what the ISO OIDs call eFrodoKEM; it has no salted FrodoKEM.
func frodoScheme(a alg.Alg) (frodo.FrodoKEM, bool) {
	switch a {
	case alg.EFrodoKEM976SHAKE:
		return frodo.Frodo976SHAKE(), true
	case alg.EFrodoKEM1344SHAKE:
		return frodo.Frodo1344SHAKE(), true
	case alg.EFrodoKEM976AES:
		return frodo.Frodo976AES(), true
	case alg.EFrodoKEM1344AES:
		return frodo.Frodo1344AES(), true
	}
	return frodo.FrodoKEM{}, false
}

// frodoKey is a secret key of the right length, with the public key it holds.
type frodoKey struct {
	scheme frodo.FrodoKEM
	sk     []byte
	pub    []byte
}

// loadFrodoKey reads the private key file. The secret key is
// s || seedA || b || S^T || pkh, where s is as long as the shared secret, so
// the public key seedA || b is read out of it rather than derived.
func loadFrodoKey(data []byte, a alg.Alg) (frodoKey, error) {
	s, ok := frodoScheme(a)
	if !ok {
		return frodoKey{}, fmt.Errorf("%s is not an eFrodoKEM algorithm", a.Friendly)
	}
	pk, err := splitKey(data, a, formExpanded, 0, s.SecretKeyLen())
	if err != nil {
		return frodoKey{}, err
	}
	sk := pk.Expanded
	start := s.SharedSecretLen()
	return frodoKey{scheme: s, sk: sk, pub: sk[start : start+s.PublicKeyLen()]}, nil
}

// decapsulates decapsulates the ciphertext and compares the result with the
// shared secret file in full.
func (k frodoKey) decapsulates(ct, ss []byte) bool {
	if k.sk == nil || len(ct) != k.scheme.CipherTextLen() {
		return false
	}
	var got []byte
	err := guard(func() (e error) { got, e = k.scheme.Dencapsulate(k.sk, ct); return })
	return err == nil && bytes.Equal(got, ss)
}

// loadFrodoEE parses the EE and requires its SubjectPublicKeyInfo to name a
// and to hold a public key of the right length to which an encapsulation
// succeeds.
func loadFrodoEE(files map[string][]byte, a alg.Alg) eeState {
	name, data, ok := find(files, a, "_ee.der")
	if !ok {
		return eeState{}
	}
	ee := eeState{name: name, present: true}
	if ee.cert, ee.err = der.ParseCertificate(data); ee.err != nil {
		return ee
	}
	ee.err = guard(func() error { return checkFrodoPublicKey(ee.cert, a) })
	if ee.err == nil {
		ee.pub = ee.cert.PublicKey
	}
	return ee
}

func checkFrodoPublicKey(c *der.ParsedCert, a alg.Alg) error {
	if got := c.PubAlg.OID.String(); got != a.OID {
		return fmt.Errorf("SubjectPublicKeyInfo algorithm is %s, want %s", got, a.OID)
	}
	s, _ := frodoScheme(a)
	if len(c.PublicKey) != s.PublicKeyLen() {
		return fmt.Errorf("public key is %d bytes, want %d", len(c.PublicKey), s.PublicKeyLen())
	}
	_, _, err := s.Encapsulate(c.PublicKey)
	return err
}

// CheckEFrodoKEM checks one eFrodoKEM algorithm over the files that are
// present. Rows are in the order priv, cert, consistent; a check that cannot
// run produces a Finding and no Row.
func CheckEFrodoKEM(files map[string][]byte, a alg.Alg) ([]Row, []Finding) {
	ee := loadFrodoEE(files, a)
	var rows []Row
	var fs []Finding
	cons := consistency{}
	if name, data, ok := find(files, a, privSuffix); ok {
		key, kerr := loadFrodoKey(data, a)
		if kerr != nil {
			fs = append(fs, Finding{File: name, Check: "failed", Detail: kerr.Error()})
		}
		if ct, ss, haveSecret := findCiphertext(files, a); haveSecret {
			ok := kerr == nil && key.decapsulates(ct, ss)
			rows = append(rows, Row{a.OID, "priv", ok})
			if kerr == nil && !ok {
				fs = append(fs, Finding{File: name, Check: "failed", Detail: "decapsulating the ciphertext does not give the shared secret"})
			}
		} else {
			fs = append(fs, Finding{File: name, Check: "cannot-run", Detail: "ciphertext or shared secret file is missing"})
		}
		if ee.present {
			cons.add(kerr == nil && ee.err == nil && bytes.Equal(key.pub, ee.pub))
		} else {
			fs = append(fs, Finding{File: name, Check: "cannot-run", Detail: "no EE certificate to compare the public key with"})
		}
	}
	if ee.present {
		rows = append(rows, Row{a.OID, "cert", ee.err == nil})
		fs = append(fs, frodoEEFindings(files, ee)...)
	}
	if r, ok := cons.row(a); ok {
		rows = append(rows, r)
	}
	return rows, fs
}

// frodoEEFindings explains a failed `cert` row and adds the strict check of
// the EE signature. The issuer is taken from the certificate's signature
// algorithm, since no ML-DSA level is tied to a FrodoKEM parameter set.
func frodoEEFindings(files map[string][]byte, ee eeState) []Finding {
	if ee.cert == nil {
		return []Finding{{File: ee.name, Check: "failed", Detail: ee.err.Error()}}
	}
	var fs []Finding
	if ee.err != nil {
		fs = append(fs, Finding{File: ee.name, Check: "failed", Detail: ee.err.Error()})
	}
	fs = append(fs, strictCert(ee.name, ee.cert)...)
	sigOID := ee.cert.SigAlg.OID.String()
	issuer, ok := alg.ByOID(sigOID)
	if !ok || issuer.IsKEM {
		detail := "the EE is signed with " + sigOID + "; its signature was not checked"
		return append(fs, Finding{File: ee.name, Check: "strict", Detail: detail})
	}
	return append(fs, issuerFindings(files, ee, issuer)...)
}

// saltedFrodoFindings reports each salted FrodoKEM private key or certificate
// in the zip: those algorithms are recognised but not checked.
func saltedFrodoFindings(files map[string][]byte) []Finding {
	var fs []Finding
	for _, a := range alg.SaltedFrodoKEM() {
		for _, suffix := range []string{privSuffix, "_ee.der"} {
			if name, _, ok := find(files, a, suffix); ok {
				fs = append(fs, Finding{File: name, Check: "cannot-run", Detail: "salted FrodoKEM is not implemented by the library in use; only eFrodoKEM is checked"})
				break
			}
		}
	}
	return fs
}
