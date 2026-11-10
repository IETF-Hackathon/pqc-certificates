package check

import (
	"bytes"
	"errors"
	"fmt"

	"github.com/cloudflare/circl/kem"

	"pqccerts/okwuosa/internal/alg"
	"pqccerts/okwuosa/internal/der"
	"pqccerts/okwuosa/internal/pqc"
)

// kemKey is a decapsulation key that loaded, with the encapsulation key it derives.
type kemKey struct {
	scheme   kem.Scheme
	sk       kem.PrivateKey
	pub      []byte
	embedded []byte // the public key attached to the private key, if any
}

// loadKEMKey reads a private key file of the wanted form. As OpenSSL does, the
// both form must have a seed that regenerates the expanded key, and an
// expanded key must pass FIPS 203's checks: the embedded encapsulation key is
// well formed, its hash matches, and an encapsulation to it decapsulates to
// the same secret.
func loadKEMKey(data []byte, a alg.Alg, form string) (k kemKey, err error) {
	s, ok := pqc.KEMScheme(a.Level)
	if !ok {
		return k, fmt.Errorf("%s is not an ML-KEM algorithm", a.Friendly)
	}
	pk, err := splitKey(data, a, form, s.SeedSize(), s.PrivateKeySize())
	if err != nil {
		return k, err
	}
	err = guard(func() error {
		var e error
		if k.sk, e = buildKEMKey(s, pk.Seed, pk.Expanded); e != nil {
			return e
		}
		k.scheme, k.embedded = s, pk.PublicKey
		if k.pub, e = k.sk.Public().MarshalBinary(); e != nil {
			return e
		}
		if pk.Seed == nil {
			return pairwiseTest(s, k, pk.Expanded)
		}
		return nil
	})
	return k, err
}

func buildKEMKey(s kem.Scheme, seed, expanded []byte) (kem.PrivateKey, error) {
	if seed == nil {
		return s.UnmarshalBinaryPrivateKey(expanded)
	}
	_, sk := s.DeriveKeyPair(seed)
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

// pairwiseTest checks an expanded decapsulation key dk = dkPKE || ek || H(ek) || z.
func pairwiseTest(s kem.Scheme, k kemKey, dk []byte) error {
	const tail = 64 // H(ek) and z
	ek := dk[len(dk)-tail-s.PublicKeySize() : len(dk)-tail]
	pub, err := s.UnmarshalBinaryPublicKey(ek)
	if err != nil {
		return fmt.Errorf("embedded encapsulation key: %w", err)
	}
	ct, ss, err := s.Encapsulate(pub)
	if err != nil {
		return err
	}
	got, err := s.Decapsulate(k.sk, ct)
	if err != nil || !bytes.Equal(got, ss) {
		return errors.New("an encapsulation to the embedded key does not decapsulate to the same secret")
	}
	return nil
}

// decapsulates is the CI's KEM key check: decapsulate the ciphertext and
// compare the result with the shared secret file in full.
func (k kemKey) decapsulates(ct, ss []byte) bool {
	if k.scheme == nil || len(ct) != k.scheme.CiphertextSize() {
		return false
	}
	var got []byte
	if guard(func() (e error) { got, e = k.scheme.Decapsulate(k.sk, ct); return }) != nil {
		return false
	}
	return bytes.Equal(got, ss)
}

// eeState is the KEM end-entity certificate as far as it could be read.
type eeState struct {
	name    string
	present bool
	cert    *der.ParsedCert // nil when absent or unparseable
	pub     []byte          // the encapsulation key, when usable
	err     error           // why the certificate is not a usable ML-KEM certificate
}

// loadEE parses the EE and requires its SubjectPublicKeyInfo to be a usable
// encapsulation key of the parameter set named by a, as `openssl pkeyutl
// -encap` needs: the key is well formed and an encapsulation to it succeeds.
func loadEE(files map[string][]byte, a alg.Alg) eeState {
	name, data, ok := find(files, a, "_ee.der")
	if !ok {
		return eeState{}
	}
	ee := eeState{name: name, present: true}
	if ee.cert, ee.err = der.ParseCertificate(data); ee.err != nil {
		return ee
	}
	ee.err = guard(func() error { return checkEncapsulationKey(ee.cert, a) })
	if ee.err == nil {
		ee.pub = ee.cert.PublicKey
	}
	return ee
}

func checkEncapsulationKey(c *der.ParsedCert, a alg.Alg) error {
	if got := c.PubAlg.OID.String(); got != a.OID {
		return fmt.Errorf("SubjectPublicKeyInfo algorithm is %s, want %s", got, a.OID)
	}
	s, _ := pqc.KEMScheme(a.Level)
	pk, err := s.UnmarshalBinaryPublicKey(c.PublicKey)
	if err != nil {
		return fmt.Errorf("encapsulation key: %w", err)
	}
	_, _, err = s.Encapsulate(pk)
	return err
}

// CheckMLKEM runs the CI-equivalent checks for one ML-KEM algorithm over the
// files that are present. A check we cannot run produces a Finding, no Row.
// Rows are in the order seed, expandedkey, both, cert, consistent.
func CheckMLKEM(files map[string][]byte, a alg.Alg) ([]Row, []Finding) {
	ee := loadEE(files, a)
	ct, ss, haveSecret := findCiphertext(files, a)
	var rows []Row
	var fs []Finding
	cons := consistency{}
	for _, kt := range keyTypes {
		name, data, ok := find(files, a, kt.suffix)
		if !ok {
			continue
		}
		key, kerr := loadKEMKey(data, a, kt.typ)
		if kerr != nil {
			fs = append(fs, Finding{File: name, Check: "failed", Detail: kerr.Error()})
		}
		fs = append(fs, strictKey(name, key.embedded, key.pub)...)
		if haveSecret {
			rows = append(rows, Row{a.OID, kt.typ, kerr == nil && key.decapsulates(ct, ss)})
		} else {
			fs = append(fs, Finding{File: name, Check: "cannot-run", Detail: "ciphertext or shared secret file is missing"})
		}
		if !ee.present {
			fs = append(fs, Finding{File: name, Check: "cannot-run", Detail: "no EE certificate to compare the public key with"})
			continue
		}
		cons.add(kerr == nil && ee.err == nil && bytes.Equal(key.pub, ee.pub))
	}
	if ee.present {
		rows = append(rows, Row{a.OID, "cert", ee.err == nil})
		fs = append(fs, eeFindings(files, a, ee)...)
	}
	if r, ok := cons.row(a); ok {
		rows = append(rows, r)
	}
	return rows, fs
}

func findCiphertext(files map[string][]byte, a alg.Alg) (ct, ss []byte, ok bool) {
	_, ct, okCT := find(files, a, "_ciphertext.bin")
	_, ss, okSS := find(files, a, "_ss.bin")
	return ct, ss, okCT && okSS
}

// eeFindings explains a failed `cert` row and adds the strict check of the EE
// signature against the same generator's TA at the same level, which never
// makes a row because the CI does not run it.
func eeFindings(files map[string][]byte, a alg.Alg, ee eeState) []Finding {
	if ee.cert == nil {
		return []Finding{{File: ee.name, Check: "failed", Detail: ee.err.Error()}}
	}
	var fs []Finding
	if ee.err != nil {
		fs = append(fs, Finding{File: ee.name, Check: "failed", Detail: ee.err.Error()})
	}
	fs = append(fs, strictCert(ee.name, ee.cert)...)
	issuer := alg.IssuerFor(a)
	ta := loadTA(files, issuer)
	var detail string
	switch {
	case !ta.present:
		detail = "no " + issuer.Friendly + " TA to verify the EE signature against"
	case ta.cert == nil:
		detail = "TA " + ta.name + " does not parse"
	default:
		err := checkIssuedBy(ee.cert, ta.cert)
		if err == nil {
			return fs
		}
		detail = "EE signature does not verify under " + ta.name + ": " + err.Error()
	}
	return append(fs, Finding{File: ee.name, Check: "strict", Detail: detail})
}
