// Package check runs the CI-equivalent checks over a provider's artifact zip.
package check

import (
	"archive/zip"
	"bytes"
	"fmt"
	"io"
	"path"
	"strings"

	"pqccerts/gocrypto/internal/alg"
)

// Limits on what is kept from one zip, which may be someone else's. The
// largest artifact in the repository is under 10 kB and the largest zip holds
// under 100 kB of them.
const (
	maxEntryBytes = 1 << 20
	maxTotalBytes = 16 << 20
)

// ReadZip reads a zip and returns the artifact files keyed by base name.
// Directory prefixes are dropped. Only files named like an artifact of an
// algorithm in the table are read; everything else is ignored unread.
func ReadZip(zipPath string) (map[string][]byte, error) {
	zr, err := zip.OpenReader(zipPath)
	if err != nil {
		return nil, err
	}
	defer zr.Close()
	files := map[string][]byte{}
	total := 0
	for _, f := range zr.File {
		if f.FileInfo().IsDir() {
			continue
		}
		base := path.Base(strings.ReplaceAll(f.Name, `\`, "/"))
		if !isArtifact(base) {
			continue
		}
		data, err := readEntry(f)
		if err != nil {
			return nil, fmt.Errorf("%q: %w", f.Name, err)
		}
		if old, seen := files[base]; seen && !bytes.Equal(old, data) {
			return nil, fmt.Errorf("%q: another entry has the base name %q and different contents", f.Name, base)
		}
		if total += len(data); total > maxTotalBytes {
			return nil, fmt.Errorf("artifacts are larger than %d bytes in total", maxTotalBytes)
		}
		files[base] = data
	}
	return files, nil
}

// isArtifact reports whether base is named like an artifact of one of the
// algorithms in the table.
func isArtifact(base string) bool {
	oid, _, ok := alg.ParseFileName(base)
	if !ok {
		return false
	}
	_, known := alg.ByOID(oid)
	return known
}

// readEntry returns the contents of f, or an error if they exceed
// maxEntryBytes. The size in the zip header is checked first so that an
// oversized entry is not decompressed at all; the read is capped as well.
func readEntry(f *zip.File) ([]byte, error) {
	if f.UncompressedSize64 > maxEntryBytes {
		return nil, fmt.Errorf("entry larger than %d bytes", maxEntryBytes)
	}
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
