// Command crossverify runs the go-crypto checker over every other provider's
// artifact zip and writes one results CSV per provider into our own directory.
package main

import (
	"flag"
	"fmt"
	"io"
	"os"
	"path/filepath"
	"sort"
	"strings"

	"pqccerts/gocrypto/internal/check"
)

const (
	zipName = "artifacts_certs_r5.zip"
	csvDir  = "compatMatrices/artifacts_certs_r5"
)

func main() {
	providers := flag.String("providers", "../..", "directory that holds the providers/* directories")
	me := flag.String("me", "go-crypto", "name of our provider directory (skipped, and the consumer in CSV names)")
	findings := flag.String("findings", "", "file for JSON-lines findings (default: stderr)")
	flag.Parse()
	if err := run(*providers, *me, *findings); err != nil {
		fmt.Fprintln(os.Stderr, "crossverify:", err)
		os.Exit(1)
	}
}

func run(providers, me, findings string) error {
	w := io.Writer(os.Stderr)
	if findings != "" {
		f, err := os.Create(findings)
		if err != nil {
			return err
		}
		defer f.Close()
		w = f
	}
	return crossVerify(providers, me, w, os.Stdout)
}

// crossVerify checks every providers/*/artifacts_certs_r5.zip except our own.
// A generator with no rows gets no CSV; an unreadable zip is logged and
// skipped. Either way an output file left by an earlier run is removed.
func crossVerify(providers, me string, findings, log io.Writer) error {
	entries, err := os.ReadDir(providers)
	if err != nil {
		return err
	}
	names := make([]string, 0, len(entries))
	for _, e := range entries {
		names = append(names, e.Name())
	}
	sort.Strings(names)
	for _, name := range names {
		if name == me {
			continue
		}
		zip := filepath.Join(providers, name, zipName)
		if _, err := os.Stat(zip); err != nil {
			continue
		}
		out := filepath.Join(providers, me, csvDir, name+"_"+me+".csv")
		if err := verifyOne(zip, name, out, findings, log); err != nil {
			return err
		}
	}
	return nil
}

func verifyOne(zip, name, out string, findings, log io.Writer) error {
	if err := check.Run(zip, name, out, findings); err != nil {
		fmt.Fprintf(log, "%s: skipped: %v\n", name, err)
		return removeStale(out)
	}
	data, err := os.ReadFile(out)
	if err != nil {
		return err
	}
	lines := strings.Split(strings.TrimSpace(string(data)), "\n")[1:]
	if len(lines) == 0 {
		fmt.Fprintf(log, "%s: no rows, no CSV\n", name)
		return removeStale(out)
	}
	y := strings.Count(string(data), ",Y\n")
	fmt.Fprintf(log, "%s: rows=%d Y=%d N=%d\n", name, len(lines), y, len(lines)-y)
	return nil
}

// removeStale deletes an output file from an earlier run; a missing file is fine.
func removeStale(out string) error {
	if err := os.Remove(out); err != nil && !os.IsNotExist(err) {
		return err
	}
	return nil
}
