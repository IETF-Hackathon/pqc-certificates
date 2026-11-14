// Command gen writes the okwuosa artifact zip.
package main

import (
	"crypto/rand"
	"flag"
	"fmt"
	"os"
	"time"

	"pqccerts/okwuosa/internal/alg"
	"pqccerts/okwuosa/internal/gen"
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
	dir, err := os.MkdirTemp("", "okwuosa-gen-*")
	if err != nil {
		return err
	}
	defer os.RemoveAll(dir)
	now := time.Now().UTC().Truncate(time.Second)
	tas := map[alg.Alg]*gen.TA{}
	for _, a := range []alg.Alg{alg.MLDSA44, alg.MLDSA65, alg.MLDSA87} {
		ta, err := gen.GenerateMLDSA(dir, a, rand.Reader, now)
		if err != nil {
			return err
		}
		tas[a] = ta
	}
	for _, a := range []alg.Alg{alg.MLKEM512, alg.MLKEM768, alg.MLKEM1024} {
		if err := gen.GenerateMLKEM(dir, a, tas[alg.IssuerFor(a)], rand.Reader, now); err != nil {
			return err
		}
	}
	return gen.WriteZip(dir, out)
}
