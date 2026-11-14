package gen

import (
	"archive/zip"
	"os"
	"path/filepath"
	"sort"
	"time"
)

// zipEpoch is a valid, fixed DOS timestamp so the zip carries no zero date.
var zipEpoch = time.Date(1980, 1, 1, 0, 0, 0, 0, time.UTC)

// WriteZip zips the regular files of srcDir into zipPath: flat, sorted by
// name, no directory entries. An existing zipPath is replaced.
func WriteZip(srcDir, zipPath string) error {
	entries, err := os.ReadDir(srcDir)
	if err != nil {
		return err
	}
	var names []string
	for _, e := range entries {
		if e.Type().IsRegular() {
			names = append(names, e.Name())
		}
	}
	sort.Strings(names)

	tmp, err := os.CreateTemp(filepath.Dir(zipPath), ".zip-*")
	if err != nil {
		return err
	}
	defer os.Remove(tmp.Name())
	zw := zip.NewWriter(tmp)
	for _, n := range names {
		data, err := os.ReadFile(filepath.Join(srcDir, n))
		if err != nil {
			tmp.Close()
			return err
		}
		w, err := zw.CreateHeader(&zip.FileHeader{Name: n, Method: zip.Deflate, Modified: zipEpoch})
		if err == nil {
			_, err = w.Write(data)
		}
		if err != nil {
			tmp.Close()
			return err
		}
	}
	if err := zw.Close(); err != nil {
		tmp.Close()
		return err
	}
	if err := tmp.Close(); err != nil {
		return err
	}
	if err := os.Chmod(tmp.Name(), 0o644); err != nil {
		return err
	}
	return os.Rename(tmp.Name(), zipPath)
}
