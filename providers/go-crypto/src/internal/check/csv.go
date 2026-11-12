package check

import (
	"bytes"
	"io"
)

// Row is one compatibility-matrix cell.
type Row struct {
	OID, Type string
	OK        bool
}

// Finding is a strict-check failure or a "cannot run" note.
type Finding struct {
	Generator string `json:"generator"`
	File      string `json:"file"`
	Check     string `json:"check"`
	Detail    string `json:"detail"`
}

const csvHeader = "key_algorithm_oid,type,test_result\n"

// WriteCSV writes the header and one line per row, with LF line endings.
func WriteCSV(w io.Writer, rows []Row) error {
	var b bytes.Buffer
	b.WriteString(csvHeader)
	for _, r := range rows {
		res := "N"
		if r.OK {
			res = "Y"
		}
		b.WriteString(r.OID + "," + r.Type + "," + res + "\n")
	}
	_, err := w.Write(b.Bytes())
	return err
}
