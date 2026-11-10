package check

import (
	"bytes"
	"fmt"

	"pqccerts/okwuosa/internal/alg"
	"pqccerts/okwuosa/internal/der"
)

// Private key forms. The CI forces one OpenSSL input format per file type
// (seed-only, priv-only, seed-priv); formAny is what it uses for one of its
// consistency checks, where no format is forced and OpenSSL accepts all three.
const (
	formSeed     = "seed"
	formExpanded = "expandedkey"
	formBoth     = "both"
	formAny      = ""
)

// splitKey parses a PKCS#8 file for a. It requires the file to be exactly the
// wanted form (any form for formAny) and the lengths to be those of the
// algorithm.
func splitKey(data []byte, a alg.Alg, form string, seedLen, expandedLen int) (der.PrivateKey, error) {
	k, err := der.ParsePrivateKey(data)
	if err != nil {
		return k, err
	}
	if k.OID.String() != a.OID {
		return k, fmt.Errorf("key algorithm is %v, want %s", k.OID, a.OID)
	}
	if got := formOf(k.Seed, k.Expanded); form != formAny && got != form {
		return k, fmt.Errorf("file holds the %s form, not the %s form", got, form)
	}
	if k.Seed != nil && len(k.Seed) != seedLen {
		return k, fmt.Errorf("seed is %d bytes, want %d", len(k.Seed), seedLen)
	}
	if k.Expanded != nil && len(k.Expanded) != expandedLen {
		return k, fmt.Errorf("expanded key is %d bytes, want %d", len(k.Expanded), expandedLen)
	}
	return k, nil
}

// strictKey reports what neither the CI nor a row depends on: a version 1 key
// whose attached public key is not the one derived from the private key.
func strictKey(name string, embedded, derived []byte) []Finding {
	if embedded != nil && !bytes.Equal(embedded, derived) {
		return []Finding{{File: name, Check: "strict", Detail: "the public key attached to the private key differs from the derived one"}}
	}
	return nil
}

func formOf(seed, expanded []byte) string {
	switch {
	case seed != nil && expanded != nil:
		return formBoth
	case seed != nil:
		return formSeed
	default:
		return formExpanded
	}
}

// guard runs f and turns a panic into an error, so that no byte sequence in
// someone else's zip can stop the run.
func guard(f func() error) (err error) {
	defer func() {
		if r := recover(); r != nil {
			err = fmt.Errorf("internal error: %v", r)
		}
	}()
	return f()
}
