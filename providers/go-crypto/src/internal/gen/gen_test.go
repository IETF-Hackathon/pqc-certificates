package gen

import (
	"archive/zip"
	"crypto/mldsa"
	"crypto/x509"
	"math/rand"
	"os"
	"path/filepath"
	"sort"
	"strings"
	"testing"
	"time"

	"pqccerts/gocrypto/internal/alg"
)

var fixedNow = time.Date(2026, 11, 9, 12, 0, 0, 0, time.UTC)

func TestGenerateMLDSA(t *testing.T) {
	for _, a := range []alg.Alg{alg.MLDSA44, alg.MLDSA65, alg.MLDSA87} {
		t.Run(a.Friendly, func(t *testing.T) {
			dir := t.TempDir()
			if err := GenerateMLDSA(dir, a, rand.New(rand.NewSource(1)), fixedNow); err != nil {
				t.Fatal(err)
			}
			taDER, err := os.ReadFile(filepath.Join(dir, a.FileName("_ta.der")))
			if err != nil {
				t.Fatal(err)
			}
			cert, err := x509.ParseCertificate(taDER)
			if err != nil {
				t.Fatal(err)
			}
			if err := cert.CheckSignatureFrom(cert); err != nil {
				t.Errorf("self-signature: %v", err)
			}
			if !cert.IsCA {
				t.Error("IsCA false")
			}
			if cert.KeyUsage != x509.KeyUsageCertSign|x509.KeyUsageCRLSign {
				t.Errorf("KeyUsage = %v", cert.KeyUsage)
			}
			if got := cert.NotAfter.Sub(cert.NotBefore); got != 36524*24*time.Hour {
				t.Errorf("validity = %v", got)
			}
			if cert.Subject.CommonName != a.Friendly+" TA" || len(cert.Subject.Organization) != 1 || cert.Subject.Organization[0] != "go-crypto" {
				t.Errorf("subject = %v", cert.Subject)
			}
			if len(cert.SubjectKeyId) == 0 {
				t.Error("no SKI")
			}
			if cert.SerialNumber.Sign() <= 0 || cert.SerialNumber.BitLen() > 128 {
				t.Errorf("serial = %v", cert.SerialNumber)
			}
			seed, err := os.ReadFile(filepath.Join(dir, a.FileName("_seed_priv.der")))
			if err != nil {
				t.Fatal(err)
			}
			if len(seed) != 54 {
				t.Errorf("seed key is %d bytes, want 54", len(seed))
			}
			key, err := x509.ParsePKCS8PrivateKey(seed)
			if err != nil {
				t.Fatal(err)
			}
			priv, ok := key.(*mldsa.PrivateKey)
			if !ok {
				t.Fatalf("seed key parsed as %T", key)
			}
			if !priv.PublicKey().Equal(cert.PublicKey) {
				t.Error("seed key public key differs from TA public key")
			}
		})
	}
}

func TestWriteZipFlatAndFresh(t *testing.T) {
	zipPath := filepath.Join(t.TempDir(), "out.zip")
	var first []string
	for i := 0; i < 2; i++ {
		src := t.TempDir()
		for _, a := range []alg.Alg{alg.MLDSA44, alg.MLDSA65, alg.MLDSA87} {
			if err := GenerateMLDSA(src, a, rand.New(rand.NewSource(int64(i))), fixedNow); err != nil {
				t.Fatal(err)
			}
		}
		if err := WriteZip(src, zipPath); err != nil {
			t.Fatal(err)
		}
		names := listZip(t, zipPath)
		if i == 0 {
			first = names
			continue
		}
		if strings.Join(names, ",") != strings.Join(first, ",") {
			t.Errorf("second run %v != first %v", names, first)
		}
	}
	if len(first) != 6 {
		t.Errorf("got %d names, want 6: %v", len(first), first)
	}
	for _, n := range first {
		if strings.HasSuffix(n, "/") || strings.Contains(n, "/") {
			t.Errorf("not flat: %q", n)
		}
	}
	if !sort.StringsAreSorted(first) {
		t.Errorf("names not sorted: %v", first)
	}
}

func listZip(t *testing.T, p string) []string {
	t.Helper()
	r, err := zip.OpenReader(p)
	if err != nil {
		t.Fatal(err)
	}
	defer r.Close()
	var names []string
	for _, f := range r.File {
		names = append(names, f.Name)
	}
	return names
}
