// Package check runs the CI-equivalent checks over a provider's artifact zip.
package check

import (
	"archive/zip"
	"fmt"
	"io"
	"path"
	"strings"

	"pqccerts/okwuosa/internal/alg"
)

const maxEntryBytes = 16 << 20

// ReadZip reads a zip and returns the artifact files keyed by base name.
// Directory prefixes are dropped; names that are not artifacts are ignored.
func ReadZip(zipPath string) (map[string][]byte, error) {
	zr, err := zip.OpenReader(zipPath)
	if err != nil {
		return nil, err
	}
	defer zr.Close()
	files := map[string][]byte{}
	for _, f := range zr.File {
		if f.FileInfo().IsDir() {
			continue
		}
		base := path.Base(strings.ReplaceAll(f.Name, `\`, "/"))
		if _, _, ok := alg.ParseFileName(base); !ok {
			continue
		}
		data, err := readEntry(f)
		if err != nil {
			return nil, fmt.Errorf("%s: %w", f.Name, err)
		}
		files[base] = data
	}
	return files, nil
}

func readEntry(f *zip.File) ([]byte, error) {
	rc, err := f.Open()
	if err != nil {
		return nil, err
	}
	defer rc.Close()
	data, err := io.ReadAll(io.LimitReader(rc, maxEntryBytes+1))
	if err != nil {
		return nil, err
	}
	if len(data) > maxEntryBytes {
		return nil, fmt.Errorf("entry larger than %d bytes", maxEntryBytes)
	}
	return data, nil
}
