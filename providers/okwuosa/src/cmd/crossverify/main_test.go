package main

import (
	"archive/zip"
	"bytes"
	"os"
	"path/filepath"
	"strings"
	"testing"
)

func mkZip(t *testing.T, path string, files map[string][]byte) {
	t.Helper()
	if err := os.MkdirAll(filepath.Dir(path), 0o755); err != nil {
		t.Fatal(err)
	}
	f, err := os.Create(path)
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
	zw.Close()
	f.Close()
}

func TestCrossVerifySkipsSelfEmptyAndBadZips(t *testing.T) {
	root := t.TempDir()
	const zname = "artifacts_certs_r5.zip"
	// A truncated key is an N row, so this generator gets a CSV.
	mkZip(t, filepath.Join(root, "theirs", zname),
		map[string][]byte{"d/ml-dsa-44-2.16.840.1.101.3.4.3.17_ta.der": []byte("junk")})
	// Only foreign files: zero rows, so no CSV file.
	mkZip(t, filepath.Join(root, "foreign", zname),
		map[string][]byte{"slh-dsa-sha2-128s-2.16.840.1.101.3.4.3.20_ta.der": []byte("zz")})
	// Not a zip.
	bad := filepath.Join(root, "broken", zname)
	os.MkdirAll(filepath.Dir(bad), 0o755)
	os.WriteFile(bad, []byte("not a zip"), 0o644)
	// Our own zip must be skipped.
	mkZip(t, filepath.Join(root, "me", zname),
		map[string][]byte{"ml-dsa-44-2.16.840.1.101.3.4.3.17_ta.der": []byte("junk")})
	// A directory without a zip.
	os.MkdirAll(filepath.Join(root, "nozip"), 0o755)

	// Output left by an earlier run must not survive a skipped generator.
	stale := filepath.Join(root, "me", "compatMatrices", "artifacts_certs_r5")
	os.MkdirAll(stale, 0o755)
	for _, n := range []string{"foreign_me.csv", "broken_me.csv"} {
		os.WriteFile(filepath.Join(stale, n), []byte("key_algorithm_oid,type,test_result\nold,cert,Y\n"), 0o644)
	}

	var fb, lb bytes.Buffer
	if err := crossVerify(root, "me", &fb, &lb); err != nil {
		t.Fatal(err)
	}
	dir := filepath.Join(root, "me", "compatMatrices", "artifacts_certs_r5")
	got, err := os.ReadFile(filepath.Join(dir, "theirs_me.csv"))
	if err != nil {
		t.Fatal(err)
	}
	if want := "key_algorithm_oid,type,test_result\n2.16.840.1.101.3.4.3.17,cert,N\n"; string(got) != want {
		t.Errorf("theirs csv = %q, want %q", got, want)
	}
	ents, _ := os.ReadDir(dir)
	if len(ents) != 1 {
		t.Errorf("CSV files = %v, want only theirs_me.csv", ents)
	}
	if !strings.Contains(lb.String(), "broken") || !strings.Contains(lb.String(), "skipped") {
		t.Errorf("log does not mention skipped broken zip: %q", lb.String())
	}
}
