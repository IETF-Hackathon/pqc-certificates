// Command gen writes the go-crypto artifact zip.
package main

import (
	"crypto/rand"
	"flag"
	"fmt"
	"os"
	"time"

	"pqccerts/gocrypto/internal/alg"
	"pqccerts/gocrypto/internal/gen"
)

func main() {
	out := flag.String("out", "../artifacts_certs_r5.zip", "path of the zip to write")
	flag.Parse()
	if err := run(*out); err != nil {
		fmt.Fprintln(os.Stderr, "gen:", err)
		os.Exit(1)
	}
}

func run(out string) error {
	dir, err := os.MkdirTemp("", "gocrypto-gen-*")
	if err != nil {
		return err
	}
	defer os.RemoveAll(dir)
	now := time.Now().UTC().Truncate(time.Second)
	for _, a := range []alg.Alg{alg.MLDSA44, alg.MLDSA65, alg.MLDSA87} {
		if err := gen.GenerateMLDSA(dir, a, rand.Reader, now); err != nil {
			return err
		}
	}
	return gen.WriteZip(dir, out)
}
