package check

import (
	"bytes"
	"encoding/json"
	"io"
	"os"
	"path/filepath"

	"pqccerts/gocrypto/internal/alg"
)

// checkAlg dispatches on the algorithm family.
func checkAlg(files map[string][]byte, a alg.Alg) ([]Row, []Finding) {
	if a.IsKEM {
		return CheckMLKEM(files, a)
	}
	return CheckMLDSA(files, a)
}

// Run reads zipPath, checks every algorithm in table order, writes the CSV to
// outCSV and the findings, tagged with generator, to findings as JSON lines.
func Run(zipPath, generator, outCSV string, findings io.Writer) error {
	files, err := ReadZip(zipPath)
	if err != nil {
		return err
	}
	var rows []Row
	var all []Finding
	for _, a := range alg.All() {
		r, f := checkAlg(files, a)
		rows, all = append(rows, r...), append(all, f...)
	}
	var csv bytes.Buffer
	if err := WriteCSV(&csv, rows); err != nil {
		return err
	}
	if err := os.MkdirAll(filepath.Dir(outCSV), 0o755); err != nil {
		return err
	}
	if err := os.WriteFile(outCSV, csv.Bytes(), 0o644); err != nil {
		return err
	}
	return writeFindings(findings, generator, all)
}

func writeFindings(w io.Writer, generator string, fs []Finding) error {
	if w == nil {
		return nil
	}
	enc := json.NewEncoder(w)
	for _, f := range fs {
		f.Generator = generator
		if err := enc.Encode(f); err != nil {
			return err
		}
	}
	return nil
}
