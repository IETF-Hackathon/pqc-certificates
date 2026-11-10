package check

import (
	"bytes"
	"crypto/mlkem"
	"crypto/x509"
	"crypto/x509/pkix"
	"encoding/asn1"
	"errors"
	"fmt"

	"pqccerts/gocrypto/internal/alg"
)

// The seed-only OneAsymmetricKey is a version 0 PKCS#8 whose privateKey
// OCTET STRING holds a [0] IMPLICIT OCTET STRING of 64 bytes.
const (
	mlkemSeedSize   = 64
	seedTagByte     = 0x80
	seedWrappedSize = 2 + mlkemSeedSize
)

// decapKey is a decapsulation key built from a seed.
type decapKey struct {
	decapsulate func(ciphertext []byte) ([]byte, error)
	ek          []byte // encapsulation key bytes
}

// kemParams are the crypto/mlkem entry points for one parameter set.
type kemParams struct {
	newDecapKey func(seed []byte) (decapKey, error)
	// encapTo accepts an encapsulation key and encapsulates to it.
	encapTo func(ek []byte) error
}

func kemParamsFor(a alg.Alg) (kemParams, bool) {
	switch a.Level {
	case 768:
		return kemParams{
			newDecapKey: func(seed []byte) (decapKey, error) {
				dk, err := mlkem.NewDecapsulationKey768(seed)
				if err != nil {
					return decapKey{}, err
				}
				return decapKey{dk.Decapsulate, dk.EncapsulationKey().Bytes()}, nil
			},
			encapTo: func(ek []byte) error {
				k, err := mlkem.NewEncapsulationKey768(ek)
				if err != nil {
					return err
				}
				return encapsulateOnce(k.Encapsulate)
			},
		}, true
	case 1024:
		return kemParams{
			newDecapKey: func(seed []byte) (decapKey, error) {
				dk, err := mlkem.NewDecapsulationKey1024(seed)
				if err != nil {
					return decapKey{}, err
				}
				return decapKey{dk.Decapsulate, dk.EncapsulationKey().Bytes()}, nil
			},
			encapTo: func(ek []byte) error {
				k, err := mlkem.NewEncapsulationKey1024(ek)
				if err != nil {
					return err
				}
				return encapsulateOnce(k.Encapsulate)
			},
		}, true
	}
	return kemParams{}, false
}

func encapsulateOnce(encapsulate func() ([]byte, []byte)) error {
	ss, ct := encapsulate()
	if len(ss) != mlkem.SharedKeySize || len(ct) == 0 {
		return errors.New("encapsulation produced no usable output")
	}
	return nil
}

// oneAsymKey is the seed-only PKCS#8 structure.
type oneAsymKey struct {
	Version int
	Alg     pkix.AlgorithmIdentifier
	Key     []byte
}

// seedDecapsulator unwraps a seed-only PKCS#8 file for a. Any deviation from
// that exact form is an error.
func seedDecapsulator(der []byte, a alg.Alg) (decapKey, error) {
	p, ok := kemParamsFor(a)
	if !ok {
		return decapKey{}, fmt.Errorf("%s is not supported", a.Friendly)
	}
	var k oneAsymKey
	rest, err := asn1.Unmarshal(der, &k)
	if err != nil {
		return decapKey{}, fmt.Errorf("PKCS#8: %w", err)
	}
	if len(rest) != 0 {
		return decapKey{}, errors.New("PKCS#8: trailing data")
	}
	// Re-encoding catches extra fields (attributes, public key) and any
	// non-canonical encoding that Unmarshal tolerates.
	if again, err := asn1.Marshal(k); err != nil || !bytes.Equal(again, der) {
		return decapKey{}, errors.New("PKCS#8 is not the plain version, algorithm, privateKey form")
	}
	if k.Version != 0 {
		return decapKey{}, fmt.Errorf("PKCS#8 version %d, want 0", k.Version)
	}
	if !hasOID(k.Alg, a) {
		return decapKey{}, fmt.Errorf("algorithm is %v with parameters %x, want %s without parameters", k.Alg.Algorithm, k.Alg.Parameters.FullBytes, a.OID)
	}
	if len(k.Key) != seedWrappedSize || k.Key[0] != seedTagByte || k.Key[1] != mlkemSeedSize {
		return decapKey{}, errors.New("privateKey is not a [0] OCTET STRING of 64 bytes (seed-only form)")
	}
	return p.newDecapKey(k.Key[2:])
}

// hasOID reports whether id names a with the parameters absent.
func hasOID(id pkix.AlgorithmIdentifier, a alg.Alg) bool {
	return id.Algorithm.String() == a.OID && len(id.Parameters.FullBytes) == 0
}

// eeState is the KEM end-entity certificate as far as it could be read.
type eeState struct {
	name    string
	present bool
	cert    *x509.Certificate // nil when absent or unparseable
	ek      []byte            // SubjectPublicKey bytes, when cert parsed
	err     error             // why the cert is not a usable ML-KEM certificate
}

type spki struct {
	Alg pkix.AlgorithmIdentifier
	Key asn1.BitString
}

// loadEE parses the EE and requires its SubjectPublicKeyInfo to be an ML-KEM
// encapsulation key of the parameter set named by a. Go's x509 leaves
// PublicKey nil for ML-KEM, so the SPKI is read directly.
func loadEE(files map[string][]byte, a alg.Alg, p kemParams) eeState {
	name, data, ok := find(files, a, "_ee.der")
	if !ok {
		return eeState{}
	}
	ee := eeState{name: name, present: true}
	cert, err := x509.ParseCertificate(data)
	if err != nil {
		ee.err = err
		return ee
	}
	ee.cert = cert
	ee.ek, ee.err = spkiKey(cert.RawSubjectPublicKeyInfo, a, p)
	return ee
}

func spkiKey(raw []byte, a alg.Alg, p kemParams) ([]byte, error) {
	var s spki
	rest, err := asn1.Unmarshal(raw, &s)
	if err != nil || len(rest) != 0 {
		return nil, errors.New("SubjectPublicKeyInfo does not parse")
	}
	if !hasOID(s.Alg, a) {
		return nil, fmt.Errorf("SPKI algorithm is %v, want %s without parameters", s.Alg.Algorithm, a.OID)
	}
	if s.Key.BitLength%8 != 0 {
		return nil, errors.New("SubjectPublicKey is not a whole number of bytes")
	}
	if err := p.encapTo(s.Key.Bytes); err != nil {
		return nil, err
	}
	return s.Key.Bytes, nil
}

// CheckMLKEM runs the CI-equivalent checks for one ML-KEM algorithm over the
// files that are present. A check Go cannot run produces a Finding, no Row.
// Rows are in the order seed, cert, consistent.
func CheckMLKEM(files map[string][]byte, a alg.Alg) ([]Row, []Finding) {
	p, ok := kemParamsFor(a)
	if !ok {
		return nil, cannotRun(files, a, a.Friendly+" is not in crypto/mlkem",
			"_seed_priv.der", "_expandedkey_priv.der", "_both_priv.der", "_ee.der")
	}
	ee := loadEE(files, a, p)
	seed, consistent, fs := checkSeed(files, a, ee)
	var rows []Row
	if seed != nil {
		rows = append(rows, *seed)
	}
	if ee.present {
		rows = append(rows, Row{a.OID, "cert", ee.err == nil})
		fs = append(fs, strictEE(files, a, ee)...)
	}
	if consistent != nil {
		rows = append(rows, *consistent)
	}
	fs = append(fs, cannotRun(files, a, "Go cannot read this private key form",
		"_expandedkey_priv.der", "_both_priv.der")...)
	return rows, fs
}

// cannotRun notes each present file with one of the suffixes as cannot-run.
func cannotRun(files map[string][]byte, a alg.Alg, why string, suffixes ...string) []Finding {
	var fs []Finding
	for _, s := range suffixes {
		if name, _, ok := find(files, a, s); ok {
			fs = append(fs, Finding{File: name, Check: "cannot-run", Detail: why})
		}
	}
	return fs
}

// checkSeed returns the seed row (nil when it could not run) and the
// consistent row (nil unless a seed key and an EE are both present).
func checkSeed(files map[string][]byte, a alg.Alg, ee eeState) (seed, consistent *Row, fs []Finding) {
	name, data, ok := find(files, a, "_seed_priv.der")
	if !ok {
		return nil, nil, nil
	}
	dk, err := seedDecapsulator(data, a)
	switch ct, ss, have := findCiphertext(files, a); {
	case err != nil:
		seed = &Row{a.OID, "seed", false}
	case have:
		seed = &Row{a.OID, "seed", decapMatches(dk, ct, ss)}
	default:
		fs = append(fs, Finding{File: name, Check: "cannot-run", Detail: "ciphertext or shared secret file is missing"})
	}
	if !ee.present {
		fs = append(fs, Finding{File: name, Check: "cannot-run", Detail: "no EE certificate to compare the public key with"})
		return seed, nil, fs
	}
	same := err == nil && ee.err == nil && bytes.Equal(dk.ek, ee.ek)
	return seed, &Row{a.OID, "consistent", same}, fs
}

func findCiphertext(files map[string][]byte, a alg.Alg) (ct, ss []byte, ok bool) {
	_, ct, okCT := find(files, a, "_ciphertext.bin")
	_, ss, okSS := find(files, a, "_ss.bin")
	return ct, ss, okCT && okSS
}

func decapMatches(dk decapKey, ct, ss []byte) bool {
	got, err := dk.decapsulate(ct)
	return err == nil && bytes.Equal(got, ss)
}

// strictEE verifies the EE signature under the same generator's TA at the same
// level. It never produces a row; the CI does not run it.
func strictEE(files map[string][]byte, a alg.Alg, ee eeState) []Finding {
	if ee.cert == nil {
		return nil
	}
	issuer := alg.IssuerFor(a)
	ta := loadTA(files, issuer)
	var detail string
	switch {
	case !ta.present:
		detail = "no " + issuer.Friendly + " TA to verify the EE signature against"
	case ta.cert == nil:
		detail = "TA " + ta.name + " does not parse"
	default:
		err := ee.cert.CheckSignatureFrom(ta.cert)
		if err == nil {
			return nil
		}
		detail = "EE signature does not verify under " + ta.name + ": " + err.Error()
	}
	return []Finding{{File: ee.name, Check: "strict", Detail: detail}}
}
