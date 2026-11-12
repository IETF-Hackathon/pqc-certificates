package check

import (
	"archive/zip"
	"os"
	"path/filepath"
	"testing"

	"pqccerts/gocrypto/internal/alg"
)

// TestReadZipFolderAndJunk: a zip with a top-level folder, a directory entry,
// a readme and a foreign algorithm. Only the ML-DSA-44 file under its base name
// counts, and CheckMLDSA yields rows for .17 only.
func TestReadZipFolderAndJunk(t *testing.T) {
	own, err := ReadZip(ownZip(t))
	if err != nil {
		t.Fatal(err)
	}
	ta44 := alg.MLDSA44.FileName("_ta.der")
	slh := "slh-dsa-sha2-128s-2.16.840.1.101.3.4.3.20_ta.der"
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
		{slh, []byte("zz")},
	} {
		w, err := zw.Create(e.name)
		if err != nil {
			t.Fatal(err)
		}
		if _, err := w.Write(e.data); err != nil {
			t.Fatal(err)
		}
	}
	if err := zw.Close(); err != nil {
		t.Fatal(err)
	}
	f.Close()

	files, err := ReadZip(z)
	if err != nil {
		t.Fatal(err)
	}
	_, hasReadme := files["readme.txt"]
	_, hasDir := files["artifacts_certs_r5"]
	if len(files[ta44]) == 0 || hasReadme || hasDir {
		t.Fatalf("ReadZip keys = %v, want %s and no readme or folder", keys(files), ta44)
	}
	var got []Row
	for _, a := range alg.All() {
		r, _ := checkAlg(files, a)
		got = append(got, r...)
	}
	if len(got) != 1 || got[0] != (Row{alg.MLDSA44.OID, "cert", true}) {
		t.Errorf("rows = %+v, want one cert row for .17", got)
	}
}

func keys(m map[string][]byte) []string {
	var ks []string
	for k := range m {
		ks = append(ks, k)
	}
	return ks
}
