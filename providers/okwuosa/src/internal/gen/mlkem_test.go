package gen

import (
	"bytes"
	"crypto/mlkem"
	"crypto/x509"
	"crypto/x509/pkix"
	"encoding/asn1"
	"math/rand"
	"testing"

	"github.com/cloudflare/circl/kem"
	"github.com/cloudflare/circl/kem/mlkem/mlkem1024"
	"github.com/cloudflare/circl/kem/mlkem/mlkem512"
	"github.com/cloudflare/circl/kem/mlkem/mlkem768"

	"pqccerts/okwuosa/internal/alg"
	"pqccerts/okwuosa/internal/der"
)

func kemLevels() []alg.Alg { return []alg.Alg{alg.MLKEM512, alg.MLKEM768, alg.MLKEM1024} }

// testSchemes is independent of the production table.
var testSchemes = map[int]kem.Scheme{512: mlkem512.Scheme(), 768: mlkem768.Scheme(), 1024: mlkem1024.Scheme()}

// seed, expanded, both, ciphertext, shared secret.
var wantKEMSizes = map[int][5]int{
	512:  {86, 1660, 1730, 768, 32},
	768:  {86, 2428, 2498, 1088, 32},
	1024: {86, 3196, 3266, 1568, 32},
}

var wantDK = map[int]int{512: 1632, 768: 2400, 1024: 3168}

// generateKEM makes the matching TA and then the KEM files in one directory.
func generateKEM(t *testing.T, a alg.Alg, seed int64) (dir string, ta *TA) {
	t.Helper()
	dir = t.TempDir()
	r := rand.New(rand.NewSource(seed))
	ta, err := GenerateMLDSA(dir, alg.IssuerFor(a), r, testNow)
	if err != nil {
		t.Fatal(err)
	}
	if err := GenerateMLKEM(dir, a, ta, r, testNow); err != nil {
		t.Fatalf("%s: %v", a.Friendly, err)
	}
	return dir, ta
}

func TestEEParsesAndChainsToTA(t *testing.T) {
	for _, a := range kemLevels() {
		dir, ta := generateKEM(t, a, 1)
		cert, err := x509.ParseCertificate(read(t, dir, a, "_ee.der"))
		if err != nil {
			t.Fatalf("%s: %v", a.Friendly, err)
		}
		taCert, err := x509.ParseCertificate(ta.Cert)
		if err != nil {
			t.Fatal(err)
		}
		if err := cert.CheckSignatureFrom(taCert); err != nil {
			t.Errorf("%s: %v", a.Friendly, err)
		}
		if !bytes.Equal(cert.AuthorityKeyId, ta.SKI) {
			t.Errorf("%s: AKI != TA SKI", a.Friendly)
		}
		if cert.KeyUsage != x509.KeyUsageKeyEncipherment || cert.IsCA || !cert.BasicConstraintsValid {
			t.Errorf("%s: keyUsage %v isCA %v", a.Friendly, cert.KeyUsage, cert.IsCA)
		}
		if cert.Subject.CommonName != a.Friendly+" EE" || !bytes.Equal(cert.RawIssuer, taCert.RawSubject) {
			t.Errorf("%s: wrong subject or issuer", a.Friendly)
		}
		if !cert.NotBefore.Equal(taCert.NotBefore) || !cert.NotAfter.Equal(taCert.NotAfter) {
			t.Errorf("%s: validity differs from TA", a.Friendly)
		}
		if cert.Subject.Organization[0] != "okwuosa" || cert.SerialNumber.Sign() <= 0 {
			t.Errorf("%s: org or serial", a.Friendly)
		}
	}
}

func TestKEMFileSizes(t *testing.T) {
	suffixes := []string{"_seed_priv.der", "_expandedkey_priv.der", "_both_priv.der", "_ciphertext.bin", "_ss.bin"}
	for _, a := range kemLevels() {
		dir, _ := generateKEM(t, a, 2)
		for i, s := range suffixes {
			if got := len(read(t, dir, a, s)); got != wantKEMSizes[a.Level][i] {
				t.Errorf("%s%s: %d bytes, want %d", a.Friendly, s, got, wantKEMSizes[a.Level][i])
			}
		}
	}
}

// eeKey returns the public key bytes from the EE's SubjectPublicKeyInfo.
func eeKey(t *testing.T, dir string, a alg.Alg) []byte {
	t.Helper()
	cert, err := x509.ParseCertificate(read(t, dir, a, "_ee.der"))
	if err != nil {
		t.Fatal(err)
	}
	var spki struct {
		Alg pkix.AlgorithmIdentifier
		Key asn1.BitString
	}
	if _, err := asn1.Unmarshal(cert.RawSubjectPublicKeyInfo, &spki); err != nil {
		t.Fatal(err)
	}
	return spki.Key.Bytes
}

func TestDecapsulateFromEveryKeyFile(t *testing.T) {
	for _, a := range kemLevels() {
		dir, _ := generateKEM(t, a, 3)
		sc := testSchemes[a.Level]
		ct, ss := read(t, dir, a, "_ciphertext.bin"), read(t, dir, a, "_ss.bin")
		var seeds, dks [][]byte
		for _, s := range []string{"_seed_priv.der", "_expandedkey_priv.der", "_both_priv.der"} {
			o, seed, dk, err := der.ParsePKCS8(read(t, dir, a, s))
			if err != nil || o.String() != a.OID {
				t.Fatalf("%s%s: %v %v", a.Friendly, s, o, err)
			}
			if seed != nil && len(seed) != 64 || dk != nil && len(dk) != wantDK[a.Level] {
				t.Fatalf("%s%s: seed %d dk %d", a.Friendly, s, len(seed), len(dk))
			}
			if seed != nil {
				seeds = append(seeds, seed)
			}
			if dk != nil {
				dks = append(dks, dk)
			}
		}
		if len(seeds) != 2 || len(dks) != 2 || !bytes.Equal(seeds[0], seeds[1]) || !bytes.Equal(dks[0], dks[1]) {
			t.Fatalf("%s: both file disagrees with single-form files", a.Friendly)
		}
		pub, fromSeed := sc.DeriveKeyPair(seeds[0])
		packed, _ := fromSeed.MarshalBinary()
		if !bytes.Equal(packed, dks[0]) {
			t.Errorf("%s: both file seed and expanded key are inconsistent", a.Friendly)
		}
		if pb, _ := pub.MarshalBinary(); !bytes.Equal(pb, eeKey(t, dir, a)) {
			t.Errorf("%s: EE public key is not the seed's", a.Friendly)
		}
		fromDK, err := sc.UnmarshalBinaryPrivateKey(dks[0])
		if err != nil {
			t.Fatal(err)
		}
		for name, sk := range map[string]kem.PrivateKey{"seed": fromSeed, "expanded": fromDK} {
			got, err := sc.Decapsulate(sk, ct)
			if err != nil || !bytes.Equal(got, ss) {
				t.Errorf("%s: decapsulating from the %s form: %v", a.Friendly, name, err)
			}
		}
	}
}

// TestStdlibAgrees checks our files against crypto/mlkem (tests only).
func TestStdlibAgrees(t *testing.T) {
	for _, a := range []alg.Alg{alg.MLKEM768, alg.MLKEM1024} {
		dir, _ := generateKEM(t, a, 4)
		_, seed, _, _ := der.ParsePKCS8(read(t, dir, a, "_seed_priv.der"))
		ct, ss := read(t, dir, a, "_ciphertext.bin"), read(t, dir, a, "_ss.bin")
		var ek, got []byte
		var err error
		if a.Level == 768 {
			var dk *mlkem.DecapsulationKey768
			if dk, err = mlkem.NewDecapsulationKey768(seed); err == nil {
				ek = dk.EncapsulationKey().Bytes()
				got, err = dk.Decapsulate(ct)
			}
		} else {
			var dk *mlkem.DecapsulationKey1024
			if dk, err = mlkem.NewDecapsulationKey1024(seed); err == nil {
				ek = dk.EncapsulationKey().Bytes()
				got, err = dk.Decapsulate(ct)
			}
		}
		if err != nil {
			t.Fatalf("%s: %v", a.Friendly, err)
		}
		if !bytes.Equal(ek, eeKey(t, dir, a)) {
			t.Errorf("%s: stdlib and CIRCL derive different public keys", a.Friendly)
		}
		if !bytes.Equal(got, ss) {
			t.Errorf("%s: stdlib decapsulation gives a different shared secret", a.Friendly)
		}
	}
}

func TestMLKEMRejectsWrongInput(t *testing.T) {
	dir := t.TempDir()
	r := rand.New(rand.NewSource(5))
	ta, err := GenerateMLDSA(dir, alg.MLDSA65, r, testNow)
	if err != nil {
		t.Fatal(err)
	}
	if GenerateMLKEM(dir, alg.MLDSA65, ta, r, testNow) == nil {
		t.Error("accepted an ML-DSA algorithm")
	}
	if GenerateMLKEM(dir, alg.MLKEM512, ta, r, testNow) == nil {
		t.Error("accepted an issuer of the wrong level")
	}
	if GenerateMLKEM(dir, alg.MLKEM768, nil, r, testNow) == nil {
		t.Error("accepted a nil issuer")
	}
}
