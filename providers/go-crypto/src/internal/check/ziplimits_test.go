package check

import (
	"archive/zip"
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"testing"

	"pqccerts/gocrypto/internal/alg"
)

type zipEntry struct {
	name string
	data []byte
}

func buildZip(t *testing.T, entries []zipEntry) string {
	t.Helper()
	p := filepath.Join(t.TempDir(), "in.zip")
	f, err := os.Create(p)
	if err != nil {
		t.Fatal(err)
	}
	zw := zip.NewWriter(f)
	for _, e := range entries {
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
	if err := f.Close(); err != nil {
		t.Fatal(err)
	}
	return p
}

// TestReadZipLimits: someone else's zip cannot make ReadZip hold more than
// maxTotalBytes, and files that are not artifacts of a known algorithm are
// never read.
func TestReadZipLimits(t *testing.T) {
	ta := alg.MLDSA44.FileName("_ta.der")
	atCap := make([]byte, maxEntryBytes)
	overCap := make([]byte, maxEntryBytes+1)
	var overBudget []zipEntry
	for i := 0; i <= maxTotalBytes/maxEntryBytes; i++ {
		overBudget = append(overBudget, zipEntry{fmt.Sprintf("f%d-%s_ta.der", i, alg.MLDSA44.OID), atCap})
	}
	cases := []struct {
		name     string
		entries  []zipEntry
		wantErr  string
		wantKeys int
	}{
		{"entry at the cap is read", []zipEntry{{ta, atCap}}, "", 1},
		{"entry over the cap is refused", []zipEntry{{"\x1b[2J-" + alg.MLDSA44.OID + "_ta.der", overCap}}, "larger than", 0},
		{"total over the budget is refused", overBudget, "in total", 0},
		{"unknown OID is not read", []zipEntry{{"a-1.2.3_ss.bin", overCap}, {ta, []byte{1}}}, "", 1},
		{"same base name, same bytes", []zipEntry{{"a/" + ta, []byte{1}}, {"b/" + ta, []byte{1}}}, "", 1},
		{"same base name, different bytes", []zipEntry{{"a/" + ta, []byte{1}}, {"b/" + ta, []byte{2}}}, "base name", 0},
	}
	for _, c := range cases {
		t.Run(c.name, func(t *testing.T) {
			files, err := ReadZip(buildZip(t, c.entries))
			if c.wantErr == "" {
				if err != nil || len(files) != c.wantKeys {
					t.Fatalf("got %d files, err %v; want %d files, no error", len(files), err, c.wantKeys)
				}
				return
			}
			if err == nil || !strings.Contains(err.Error(), c.wantErr) {
				t.Fatalf("err = %v, want one containing %q", err, c.wantErr)
			}
			if strings.ContainsRune(err.Error(), '\x1b') {
				t.Errorf("error text carries a raw control character: %q", err.Error())
			}
		})
	}
}

// TestCheckAlgSurvivesPanic: a panic inside a check becomes a finding with no
// rows, so one zip cannot stop a cross-verify run.
func TestCheckAlgSurvivesPanic(t *testing.T) {
	rows, fs := recovered(alg.MLDSA44, func() ([]Row, []Finding) { panic("boom") })
	if rows != nil || len(fs) != 1 || fs[0].Check != "internal-error" || !strings.Contains(fs[0].Detail, "boom") {
		t.Fatalf("rows = %v, findings = %+v; want no rows and one internal-error finding", rows, fs)
	}
}

// TestReadZipBoundsTheZipItself: the number of entries and the size of the
// file are checked before any entry is read, so a zip of very many empty
// entries, or a very large one, is refused outright.
func TestReadZipBoundsTheZipItself(t *testing.T) {
	ta := alg.MLDSA44.FileName("_ta.der")
	filler := func(n int) []zipEntry {
		entries := []zipEntry{{ta, []byte{1}}}
		for i := 1; i < n; i++ {
			entries = append(entries, zipEntry{fmt.Sprintf("f%d-%s_ta.der", i, alg.MLDSA44.OID), nil})
		}
		return entries
	}
	t.Run("entries at the cap are read", func(t *testing.T) {
		files, err := ReadZip(buildZip(t, filler(maxEntries)))
		if err != nil || len(files) != maxEntries {
			t.Fatalf("got %d files, err %v", len(files), err)
		}
	})
	t.Run("one entry over the cap is refused", func(t *testing.T) {
		_, err := ReadZip(buildZip(t, filler(maxEntries+1)))
		if err == nil || !strings.Contains(err.Error(), "entries") {
			t.Fatalf("err = %v, want one about the number of entries", err)
		}
	})
	t.Run("a file over the size cap is refused unopened", func(t *testing.T) {
		p := filepath.Join(t.TempDir(), "big.zip")
		f, err := os.Create(p)
		if err != nil {
			t.Fatal(err)
		}
		// Not a zip at all: the size must be what is reported.
		if err := f.Truncate(maxZipBytes + 1); err != nil {
			t.Fatal(err)
		}
		f.Close()
		_, err = ReadZip(p)
		if err == nil || !strings.Contains(err.Error(), "zip file is") {
			t.Fatalf("err = %v, want one about the size of the zip file", err)
		}
	})
}
