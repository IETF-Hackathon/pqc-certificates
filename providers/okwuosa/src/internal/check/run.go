package check

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"os"
	"path/filepath"

	"pqccerts/okwuosa/internal/alg"
)

// checkAlg dispatches on the algorithm family. A panic inside a check, which
// no input should cause, is reported as a finding and gives no rows for that
// algorithm, so one odd zip cannot stop the run.
func checkAlg(files map[string][]byte, a alg.Alg) (rows []Row, fs []Finding) {
	defer func() {
		if r := recover(); r != nil {
			rows = nil
			fs = []Finding{{Check: "internal-error", Detail: fmt.Sprintf("%s: %v", a.Friendly, r)}}
		}
	}()
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
