package gen

import (
	"archive/zip"
	"bytes"
	"crypto/mldsa"
	"crypto/x509"
	"math/rand"
	"os"
	"path/filepath"
	"reflect"
	"strings"
	"testing"
	"time"

	"pqccerts/okwuosa/internal/alg"
	"pqccerts/okwuosa/internal/der"
)

var testNow = time.Date(2026, 11, 9, 12, 0, 0, 0, time.UTC)

// sizes: seed file, expanded file, both file, expanded key bytes, seed bytes.
var wantSizes = map[int][3]int{44: {54, 2588, 2626}, 65: {54, 4060, 4098}, 87: {54, 4924, 4962}}
var wantSK = map[int]int{44: 2560, 65: 4032, 87: 4896}

func levels() []alg.Alg { return []alg.Alg{alg.MLDSA44, alg.MLDSA65, alg.MLDSA87} }

func generate(t *testing.T, a alg.Alg, seed int64) (string, *TA) {
	t.Helper()
	dir := t.TempDir()
	ta, err := GenerateMLDSA(dir, a, rand.New(rand.NewSource(seed)), testNow)
	if err != nil {
		t.Fatalf("%s: %v", a.Friendly, err)
	}
	return dir, ta
}

func read(t *testing.T, dir string, a alg.Alg, suffix string) []byte {
	t.Helper()
	b, err := os.ReadFile(filepath.Join(dir, a.FileName(suffix)))
	if err != nil {
		t.Fatal(err)
	}
	return b
}

func TestTAParsesAndSelfSigns(t *testing.T) {
	for _, a := range levels() {
		dir, ta := generate(t, a, 1)
		der := read(t, dir, a, "_ta.der")
		if !bytes.Equal(der, ta.Cert) {
			t.Fatalf("%s: TA.Cert differs from file", a.Friendly)
		}
		cert, err := x509.ParseCertificate(der)
		if err != nil {
			t.Fatalf("%s: %v", a.Friendly, err)
		}
		if err := cert.CheckSignatureFrom(cert); err != nil {
			t.Errorf("%s: self-signature: %v", a.Friendly, err)
		}
		if !cert.IsCA || cert.Subject.CommonName != a.Friendly+" TA" || !bytes.Equal(cert.SubjectKeyId, ta.SKI) {
			t.Errorf("%s: wrong CA flag, name or SKI", a.Friendly)
		}
		if len(cert.AuthorityKeyId) != 0 {
			t.Errorf("%s: self-signed TA must have no AKI", a.Friendly)
		}
	}
}

func TestKeyFilesSizesAndRoundTrip(t *testing.T) {
	for _, a := range levels() {
		dir, _ := generate(t, a, 2)
		files := [3][]byte{read(t, dir, a, "_seed_priv.der"), read(t, dir, a, "_expandedkey_priv.der"), read(t, dir, a, "_both_priv.der")}
		for i, f := range files {
			if len(f) != wantSizes[a.Level][i] {
				t.Errorf("%s file %d: %d bytes, want %d", a.Friendly, i, len(f), wantSizes[a.Level][i])
			}
			o, seed, sk, err := der.ParsePKCS8(f)
			if err != nil {
				t.Fatalf("%s file %d: %v", a.Friendly, i, err)
			}
			if o.String() != a.OID {
				t.Errorf("%s file %d: oid %v", a.Friendly, i, o)
			}
			if i != 1 && len(seed) != 32 || i == 1 && seed != nil {
				t.Errorf("%s file %d: seed length %d", a.Friendly, i, len(seed))
			}
			if i != 0 && len(sk) != wantSK[a.Level] || i == 0 && sk != nil {
				t.Errorf("%s file %d: expanded length %d", a.Friendly, i, len(sk))
			}
		}
	}
}

func TestExpandedMatchesSeedAndStdlib(t *testing.T) {
	for _, a := range levels() {
		dir, ta := generate(t, a, 3)
		_, seed, _, _ := der.ParsePKCS8(read(t, dir, a, "_seed_priv.der"))
		_, _, sk, _ := der.ParsePKCS8(read(t, dir, a, "_expandedkey_priv.der"))
		_, bseed, bsk, _ := der.ParsePKCS8(read(t, dir, a, "_both_priv.der"))
		if !bytes.Equal(seed, bseed) || !bytes.Equal(sk, bsk) {
			t.Errorf("%s: both file disagrees with the single-form files", a.Friendly)
		}
		sc, ok := schemes[a.Level]
		if !ok {
			t.Fatalf("no scheme for %d", a.Level)
		}
		_, packed, _ := sc.fromSeed(seed)
		if !bytes.Equal(packed, sk) {
			t.Errorf("%s: expanded key differs from NewKeyFromSeed packed key", a.Friendly)
		}
		// Cross-check against the standard library (tests only).
		k, err := x509.ParsePKCS8PrivateKey(read(t, dir, a, "_seed_priv.der"))
		if err != nil {
			t.Fatalf("%s: stdlib parse: %v", a.Friendly, err)
		}
		cert, _ := x509.ParseCertificate(ta.Cert)
		if !reflect.DeepEqual(k.(*mldsa.PrivateKey).PublicKey().Bytes(), cert.PublicKey.(*mldsa.PublicKey).Bytes()) {
			t.Errorf("%s: stdlib and CIRCL derive different public keys", a.Friendly)
		}
	}
}

func TestTASign(t *testing.T) {
	for _, a := range levels() {
		_, ta := generate(t, a, 4)
		cert, _ := x509.ParseCertificate(ta.Cert)
		msg := []byte("hello")
		sig, err := ta.Sign(msg)
		if err != nil {
			t.Fatal(err)
		}
		if err := cert.CheckSignature(cert.SignatureAlgorithm, msg, sig); err != nil {
			t.Errorf("%s: TA.Sign signature does not verify: %v", a.Friendly, err)
		}
	}
}

func TestRejectsKEM(t *testing.T) {
	if _, err := GenerateMLDSA(t.TempDir(), alg.MLKEM512, rand.New(rand.NewSource(1)), testNow); err == nil {
		t.Fatal("want error for a KEM algorithm")
	}
}

func TestValidityAndSerial(t *testing.T) {
	_, ta := generate(t, alg.MLDSA44, 5)
	cert, _ := x509.ParseCertificate(ta.Cert)
	if !cert.NotBefore.Equal(testNow) || cert.NotAfter.Sub(cert.NotBefore) != 36524*24*time.Hour {
		t.Errorf("validity %v..%v", cert.NotBefore, cert.NotAfter)
	}
	if cert.SerialNumber.Sign() <= 0 || cert.SerialNumber.BitLen() > 127 {
		t.Errorf("serial %v", cert.SerialNumber)
	}
}

func TestWriteZipFlatSorted(t *testing.T) {
	src := t.TempDir()
	for _, n := range []string{"b.der", "a.der"} {
		os.WriteFile(filepath.Join(src, n), []byte(n), 0o644)
	}
	os.Mkdir(filepath.Join(src, "sub"), 0o755)
	out := filepath.Join(t.TempDir(), "z.zip")
	if err := WriteZip(src, out); err != nil {
		t.Fatal(err)
	}
	zr, err := zip.OpenReader(out)
	if err != nil {
		t.Fatal(err)
	}
	defer zr.Close()
	var names []string
	for _, f := range zr.File {
		names = append(names, f.Name)
		if strings.HasSuffix(f.Name, "/") || f.Modified.Year() != 1980 {
			t.Errorf("bad entry %q %v", f.Name, f.Modified)
		}
	}
	if !reflect.DeepEqual(names, []string{"a.der", "b.der"}) {
		t.Errorf("names %v", names)
	}
}
