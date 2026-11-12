package check

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"os"
	"path/filepath"

	"pqccerts/gocrypto/internal/alg"
)

// checkAlg dispatches on the algorithm family.
func checkAlg(files map[string][]byte, a alg.Alg) ([]Row, []Finding) {
	return recovered(a, func() ([]Row, []Finding) {
		if a.IsKEM {
			return CheckMLKEM(files, a)
		}
		return CheckMLDSA(files, a)
	})
}

// recovered runs check. A panic inside it, which no input should cause, is
// reported as a finding and gives no rows for that algorithm, so one odd zip
// cannot stop the run.
func recovered(a alg.Alg, check func() ([]Row, []Finding)) (rows []Row, fs []Finding) {
	defer func() {
		if r := recover(); r != nil {
			rows = nil
			fs = []Finding{{Check: "internal-error", Detail: fmt.Sprintf("%s: %v", a.Friendly, r)}}
		}
	}()
	return check()
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
