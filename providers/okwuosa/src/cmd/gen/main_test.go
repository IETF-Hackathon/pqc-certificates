package main

import (
	"archive/zip"
	"path/filepath"
	"reflect"
	"strings"
	"testing"
)

func listZip(t *testing.T, path string) []string {
	t.Helper()
	zr, err := zip.OpenReader(path)
	if err != nil {
		t.Fatal(err)
	}
	defer zr.Close()
	var names []string
	for _, f := range zr.File {
		if strings.HasSuffix(f.Name, "/") {
			t.Errorf("directory entry %q", f.Name)
		}
		names = append(names, f.Name)
	}
	return names
}

func TestRunTwiceGivesSameListing(t *testing.T) {
	out := filepath.Join(t.TempDir(), "a.zip")
	if err := run(out); err != nil {
		t.Fatal(err)
	}
	first := listZip(t, out)
	if err := run(out); err != nil {
		t.Fatal(err)
	}
	if second := listZip(t, out); !reflect.DeepEqual(first, second) || len(first) != 30 {
		t.Errorf("listings differ or not 30 names: %v vs %v", first, second)
	}
}
