package check

import (
	"archive/zip"
	"bytes"
	"crypto/rand"
	"encoding/json"
	"os"
	"path/filepath"
	"strings"
	"testing"
	"time"

	"pqccerts/okwuosa/internal/alg"
	"pqccerts/okwuosa/internal/gen"
)

const header = "key_algorithm_oid,type,test_result\n"

var (
	dsaAlgs = []alg.Alg{alg.MLDSA44, alg.MLDSA65, alg.MLDSA87}
	kemAlgs = []alg.Alg{alg.MLKEM512, alg.MLKEM768, alg.MLKEM1024}
	// Repo reference zips, relative to this package.
	ossl35Zip   = filepath.Join("..", "..", "..", "..", "ossl35", "artifacts_certs_r5.zip")
	goCryptoZip = filepath.Join("..", "..", "..", "..", "go-crypto", "artifacts_certs_r5.zip")
	keyRowTypes = []string{"seed", "expandedkey", "both"}
	allRowTypes = []string{"seed", "expandedkey", "both", "cert", "consistent"}
)

func row(a alg.Alg, typ, res string) string {
	return a.OID + "," + typ + "," + res + "\n"
}

// csvOf builds the expected CSV from rows made by row.
func csvOf(rows ...string) string { return header + strings.Join(rows, "") }

// allY is the CSV where every one of the five rows is Y for every algorithm.
func allY() string {
	var rows []string
	for _, a := range alg.All() {
		for _, typ := range allRowTypes {
			rows = append(rows, row(a, typ, "Y"))
		}
	}
	return csvOf(rows...)
}

// ownFiles generates the okwuosa artifacts and returns them by name.
func ownFiles(t *testing.T) map[string][]byte {
	t.Helper()
	dir := t.TempDir()
	now := time.Now().UTC().Truncate(time.Second)
	tas := map[alg.Alg]*gen.TA{}
	for _, a := range dsaAlgs {
		ta, err := gen.GenerateMLDSA(dir, a, rand.Reader, now)
		if err != nil {
			t.Fatal(err)
		}
		tas[a] = ta
	}
	for _, a := range kemAlgs {
		if err := gen.GenerateMLKEM(dir, a, tas[alg.IssuerFor(a)], rand.Reader, now); err != nil {
			t.Fatal(err)
		}
	}
	z := filepath.Join(t.TempDir(), "own.zip")
	if err := gen.WriteZip(dir, z); err != nil {
		t.Fatal(err)
	}
	files, err := ReadZip(z)
	if err != nil {
		t.Fatal(err)
	}
	return files
}

// cloneFiles copies the map so a test can damage one file.
func cloneFiles(files map[string][]byte) map[string][]byte {
	out := make(map[string][]byte, len(files))
	for k, v := range files {
		out[k] = bytes.Clone(v)
	}
	return out
}

func writeZip(t *testing.T, files map[string][]byte) string {
	t.Helper()
	z := filepath.Join(t.TempDir(), "in.zip")
	f, err := os.Create(z)
	if err != nil {
		t.Fatal(err)
	}
	zw := zip.NewWriter(f)
	for n, d := range files {
		w, err := zw.Create(n)
		if err != nil {
			t.Fatal(err)
		}
		w.Write(d)
	}
	if err := zw.Close(); err != nil {
		t.Fatal(err)
	}
	f.Close()
	return z
}

func runZip(t *testing.T, zipPath string) (string, []Finding) {
	t.Helper()
	out := filepath.Join(t.TempDir(), "sub", "out.csv")
	var fb bytes.Buffer
	if err := Run(zipPath, "tester", out, &fb); err != nil {
		t.Fatal(err)
	}
	csv, err := os.ReadFile(out)
	if err != nil {
		t.Fatal(err)
	}
	var fs []Finding
	for _, l := range strings.Split(strings.TrimSpace(fb.String()), "\n") {
		if l == "" {
			continue
		}
		var f Finding
		if err := json.Unmarshal([]byte(l), &f); err != nil {
			t.Fatalf("finding line %q: %v", l, err)
		}
		if f.Generator != "tester" {
			t.Errorf("Generator = %q", f.Generator)
		}
		fs = append(fs, f)
	}
	return string(csv), fs
}

func runFiles(t *testing.T, files map[string][]byte) (string, []Finding) {
	t.Helper()
	return runZip(t, writeZip(t, files))
}

func countCheck(fs []Finding, check string) int {
	n := 0
	for _, f := range fs {
		if f.Check == check {
			n++
		}
	}
	return n
}

// refZip copies a repo zip into a temp dir; the test fails if it is missing.
func refZip(t *testing.T, path string) string {
	t.Helper()
	src, err := os.ReadFile(path)
	if err != nil {
		t.Fatal(err)
	}
	z := filepath.Join(t.TempDir(), "ref.zip")
	if err := os.WriteFile(z, src, 0o644); err != nil {
		t.Fatal(err)
	}
	return z
}
