package check

import (
	"archive/zip"
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"testing"

	"pqccerts/okwuosa/internal/alg"
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
