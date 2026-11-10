// Command check runs the CI-equivalent checks over an artifact zip.
package main

import (
	"flag"
	"fmt"
	"os"

	"pqccerts/gocrypto/internal/check"
)

func main() {
	zipPath := flag.String("zip", "", "artifact zip to check (required)")
	generator := flag.String("generator", "", "generator name recorded in findings (required)")
	out := flag.String("out", "", "results CSV to write (required)")
	findings := flag.String("findings", "", "file for JSON-lines findings (default: stderr)")
	flag.Parse()
	if *zipPath == "" || *generator == "" || *out == "" {
		flag.Usage()
		os.Exit(2)
	}
	if err := run(*zipPath, *generator, *out, *findings); err != nil {
		fmt.Fprintln(os.Stderr, "check:", err)
		os.Exit(1)
	}
}

func run(zipPath, generator, out, findings string) error {
	w := os.Stderr
	if findings != "" {
		f, err := os.Create(findings)
		if err != nil {
			return err
		}
		defer f.Close()
		w = f
	}
	return check.Run(zipPath, generator, out, w)
}
