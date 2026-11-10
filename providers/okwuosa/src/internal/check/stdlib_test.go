package check

import (
	"archive/zip"
	"bytes"
	"crypto/mldsa"
	"crypto/rand"
	"crypto/x509"
	"crypto/x509/pkix"
	"math/big"
	"os"
	"path/filepath"
	"testing"
	"time"

	"pqccerts/okwuosa/internal/alg"
)

// stdTA makes a self-signed ML-DSA-44 certificate with Go's crypto/x509
// (test-only), from a template the caller may adjust.
func stdTA(t *testing.T, adjust func(*x509.Certificate)) []byte {
	t.Helper()
	key, err := mldsa.GenerateKey(mldsa.MLDSA44())
	if err != nil {
		t.Fatal(err)
	}
	now := time.Now()
	tmpl := &x509.Certificate{
		SerialNumber: big.NewInt(7),
		Subject:      pkix.Name{CommonName: "no ca flags"},
		NotBefore:    now,
		NotAfter:     now.Add(24 * time.Hour),
	}
	if adjust != nil {
		adjust(tmpl)
	}
	der, err := x509.CreateCertificate(rand.Reader, tmpl, tmpl, key.PublicKey(), key)
	if err != nil {
		t.Fatal(err)
	}
	return der
}

// OpenSSL's `verify -check_ss_sig` accepts a TA whose self-signature is valid
// even if it is not marked CA or keyCertSign (composite-sigs-ref-impl ships
// such TAs and the CI says Y). The cert row asks only whether the
// self-signature verifies.
func TestSelfSignedWithoutCAFlagsIsY(t *testing.T) {
	a := alg.MLDSA44
	csv, _ := runFiles(t, map[string][]byte{a.FileName("_ta.der"): stdTA(t, nil)})
	if csv != csvOf(row(a, "cert", "Y")) {
		t.Errorf("csv = %q, want cert Y", csv)
	}
}

func TestStdlibTAWithExtensionsIsY(t *testing.T) {
	a := alg.MLDSA44
	der := stdTA(t, func(c *x509.Certificate) {
		c.IsCA, c.BasicConstraintsValid = true, true
		c.KeyUsage = x509.KeyUsageCertSign | x509.KeyUsageCRLSign
	})
	csv, _ := runFiles(t, map[string][]byte{a.FileName("_ta.der"): der})
	if csv != csvOf(row(a, "cert", "Y")) {
		t.Errorf("csv = %q", csv)
	}
}

func TestIssuerDifferentFromSubjectIsN(t *testing.T) {
	a := alg.MLDSA44
	key, _ := mldsa.GenerateKey(mldsa.MLDSA44())
	now := time.Now()
	tmpl := &x509.Certificate{SerialNumber: big.NewInt(1), Subject: pkix.Name{CommonName: "child"}, NotBefore: now, NotAfter: now.Add(time.Hour)}
	parent := &x509.Certificate{SerialNumber: big.NewInt(2), Subject: pkix.Name{CommonName: "parent"}, NotBefore: now, NotAfter: now.Add(time.Hour)}
	der, err := x509.CreateCertificate(rand.Reader, tmpl, parent, key.PublicKey(), key)
	if err != nil {
		t.Fatal(err)
	}
	csv, _ := runFiles(t, map[string][]byte{a.FileName("_ta.der"): der})
	if csv != csvOf(row(a, "cert", "N")) {
		t.Errorf("csv = %q, want cert N", csv)
	}
}

// TestReadZipFolderAndJunk: a zip with a top-level folder, a directory entry,
// a readme and a foreign algorithm. Only the ML-DSA-44 file under its base
// name counts.
func TestReadZipFolderAndJunk(t *testing.T) {
	own := ownFiles(t)
	ta44 := alg.MLDSA44.FileName("_ta.der")
	z := filepath.Join(t.TempDir(), "folder.zip")
	f, err := os.Create(z)
	if err != nil {
		t.Fatal(err)
	}
	zw := zip.NewWriter(f)
	for _, e := range []struct {
		name string
		data []byte
	}{
		{"artifacts_certs_r5/", nil},
		{"artifacts_certs_r5/" + ta44, own[ta44]},
		{"readme.txt", []byte("hello")},
		{"slh-dsa-sha2-128s-2.16.840.1.101.3.4.3.20_ta.der", []byte("zz")},
		{`win\dir\` + alg.MLDSA65.FileName("_ta.pem"), []byte("pem")},
	} {
		w, err := zw.Create(e.name)
		if err != nil {
			t.Fatal(err)
		}
		w.Write(e.data)
	}
	zw.Close()
	f.Close()

	files, err := ReadZip(z)
	if err != nil {
		t.Fatal(err)
	}
	if _, junk := files["readme.txt"]; !bytes.Equal(files[ta44], own[ta44]) || junk || len(files) > 3 {
		t.Fatalf("ReadZip returned %d files, want the ML-DSA-44 TA and at most the recognised foreign names", len(files))
	}
	var got []Row
	for _, a := range alg.All() {
		r, _ := checkAlg(files, a)
		got = append(got, r...)
	}
	if len(got) != 1 || got[0] != (Row{alg.MLDSA44.OID, "cert", true}) {
		t.Errorf("rows = %+v, want one cert row for ML-DSA-44", got)
	}
}

func TestWriteCSVFormat(t *testing.T) {
	var b bytes.Buffer
	if err := WriteCSV(&b, []Row{{"1.2", "seed", true}, {"1.2", "cert", false}}); err != nil {
		t.Fatal(err)
	}
	if want := "key_algorithm_oid,type,test_result\n1.2,seed,Y\n1.2,cert,N\n"; b.String() != want {
		t.Errorf("got %q", b.String())
	}
	b.Reset()
	WriteCSV(&b, nil)
	if b.String() != "key_algorithm_oid,type,test_result\n" {
		t.Errorf("empty CSV = %q", b.String())
	}
}
