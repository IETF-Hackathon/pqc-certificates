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

	"pqccerts/gocrypto/internal/alg"
	"pqccerts/gocrypto/internal/gen"
)

var mldsaAlgs = []alg.Alg{alg.MLDSA44, alg.MLDSA65, alg.MLDSA87}

const header = "key_algorithm_oid,type,test_result\n"

func row(a alg.Alg, typ, res string) string {
	return a.OID + "," + typ + "," + res + "\n"
}

func fullCSV() string {
	var b strings.Builder
	b.WriteString(header)
	for _, a := range mldsaAlgs {
		b.WriteString(row(a, "seed", "Y") + row(a, "cert", "Y") + row(a, "consistent", "Y"))
	}
	return b.String()
}

// ownZip generates the go-crypto artifacts and zips them.
func ownZip(t *testing.T) string {
	t.Helper()
	dir := t.TempDir()
	for _, a := range mldsaAlgs {
		if err := gen.GenerateMLDSA(dir, a, rand.Reader, time.Now().UTC().Truncate(time.Second)); err != nil {
			t.Fatal(err)
		}
	}
	z := filepath.Join(t.TempDir(), "own.zip")
	if err := gen.WriteZip(dir, z); err != nil {
		t.Fatal(err)
	}
	return z
}

// writeZip writes files as a flat zip.
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

func TestCheckOwnArtifacts(t *testing.T) {
	csv, fs := runZip(t, ownZip(t))
	if csv != fullCSV() {
		t.Errorf("CSV mismatch:\n%q\nwant\n%q", csv, fullCSV())
	}
	if strings.Contains(csv, "\r") || strings.HasSuffix(csv, "\n\n") {
		t.Error("bad line endings")
	}
	if len(fs) != 0 {
		t.Errorf("findings: %+v", fs)
	}
}

func TestTruncatedTA(t *testing.T) {
	files, err := ReadZip(ownZip(t))
	if err != nil {
		t.Fatal(err)
	}
	name := alg.MLDSA65.FileName("_ta.der")
	files[name] = files[name][:100]
	csv, _ := runZip(t, writeZip(t, files))
	want := header +
		row(alg.MLDSA44, "seed", "Y") + row(alg.MLDSA44, "cert", "Y") + row(alg.MLDSA44, "consistent", "Y") +
		row(alg.MLDSA65, "seed", "N") + row(alg.MLDSA65, "cert", "N") + row(alg.MLDSA65, "consistent", "N") +
		row(alg.MLDSA87, "seed", "Y") + row(alg.MLDSA87, "cert", "Y") + row(alg.MLDSA87, "consistent", "Y")
	if csv != want {
		t.Errorf("CSV:\n%s\nwant\n%s", csv, want)
	}
}

func TestMalformedKey(t *testing.T) {
	files, _ := ReadZip(ownZip(t))
	files[alg.MLDSA44.FileName("_seed_priv.der")] = []byte{0x30, 0x03, 0x01}
	csv, _ := runZip(t, writeZip(t, files))
	if !strings.Contains(csv, row(alg.MLDSA44, "seed", "N")) || strings.Contains(csv, row(alg.MLDSA44, "consistent", "Y")) {
		t.Errorf("malformed key not N:\n%s", csv)
	}
}

func TestMissingPieces(t *testing.T) {
	files, _ := ReadZip(ownZip(t))
	a := alg.MLDSA44
	seedOnly := map[string][]byte{a.FileName("_seed_priv.der"): files[a.FileName("_seed_priv.der")]}
	csv, fs := runZip(t, writeZip(t, seedOnly))
	if csv != header {
		t.Errorf("seed only: %q", csv)
	}
	if len(fs) != 1 || fs[0].Check != "cannot-run" || !strings.Contains(fs[0].Detail, "no TA") {
		t.Errorf("seed only findings: %+v", fs)
	}
	taOnly := map[string][]byte{a.FileName("_ta.der"): files[a.FileName("_ta.der")]}
	csv, _ = runZip(t, writeZip(t, taOnly))
	if csv != header+row(a, "cert", "Y") {
		t.Errorf("TA only: %q", csv)
	}
}

func TestIgnoresFoldersAndJunk(t *testing.T) {
	files, _ := ReadZip(ownZip(t))
	nested := map[string][]byte{"junk.txt": []byte("x"), "d/slh-dsa-sha2-128s-2.16.840.1.101.3.4.3.20_ta.der": []byte("zz")}
	for n, d := range files {
		nested["top/"+n] = d
	}
	csv, fs := runZip(t, writeZip(t, nested))
	if csv != fullCSV() || len(fs) != 0 {
		t.Errorf("csv %q findings %+v", csv, fs)
	}
}

func TestOssl35Expanded(t *testing.T) {
	src, err := os.ReadFile(filepath.Join("..", "..", "..", "..", "ossl35", "artifacts_certs_r5.zip"))
	if err != nil {
		t.Fatal(err)
	}
	z := filepath.Join(t.TempDir(), "ossl35.zip")
	if err := os.WriteFile(z, src, 0o644); err != nil {
		t.Fatal(err)
	}
	csv, fs := runZip(t, z)
	for _, typ := range []string{"seed", "cert", "consistent"} {
		if !strings.Contains(csv, row(alg.MLDSA44, typ, "Y")) {
			t.Errorf("missing %s,Y for .17:\n%s", typ, csv)
		}
	}
	if strings.Contains(csv, "expandedkey") || strings.Contains(csv, "both") || strings.Contains(csv, ",N\n") {
		t.Errorf("unexpected rows:\n%s", csv)
	}
	n := 0
	for _, f := range fs {
		if f.Check == "cannot-run" && strings.Contains(f.File, alg.MLDSA44.OID) {
			n++
		}
	}
	if n != 2 {
		t.Errorf("cannot-run findings for .17 = %d, want 2: %+v", n, fs)
	}
}
