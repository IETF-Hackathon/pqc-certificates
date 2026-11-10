package check

import (
	"path/filepath"
	"strings"
	"testing"

	"pqccerts/gocrypto/internal/alg"
)

var kemAlgs = []alg.Alg{alg.MLKEM768, alg.MLKEM1024}

// ossl35Files returns a copy of ossl35's artifacts, which the CI accepts.
func ossl35Files(t *testing.T) map[string][]byte {
	t.Helper()
	files, err := ReadZip(filepath.Join("..", "..", "..", "..", "ossl35", "artifacts_certs_r5.zip"))
	if err != nil {
		t.Fatal(err)
	}
	return files
}

func rowString(rows []Row) string {
	var b strings.Builder
	for _, r := range rows {
		res := "N"
		if r.OK {
			res = "Y"
		}
		b.WriteString(r.OID + " " + r.Type + " " + res + "\n")
	}
	return b.String()
}

func wantRows(a alg.Alg, results ...string) string {
	var b strings.Builder
	for i := 0; i < len(results); i += 2 {
		b.WriteString(a.OID + " " + results[i] + " " + results[i+1] + "\n")
	}
	return b.String()
}

func countFindings(fs []Finding, check string) int {
	n := 0
	for _, f := range fs {
		if f.Check == check {
			n++
		}
	}
	return n
}

func TestMLKEMOssl35(t *testing.T) {
	files := ossl35Files(t)
	for _, a := range kemAlgs {
		rows, fs := CheckMLKEM(files, a)
		if got, want := rowString(rows), wantRows(a, "seed", "Y", "cert", "Y", "consistent", "Y"); got != want {
			t.Errorf("%s rows:\n%s\nwant\n%s", a.Friendly, got, want)
		}
		if countFindings(fs, "cannot-run") != 2 || len(fs) != 2 {
			t.Errorf("%s findings: %+v", a.Friendly, fs)
		}
	}
}

func TestMLKEM512HasNoRows(t *testing.T) {
	rows, fs := CheckMLKEM(ossl35Files(t), alg.MLKEM512)
	if len(rows) != 0 {
		t.Errorf("rows: %+v", rows)
	}
	// seed, expandedkey, both and the EE certificate
	if countFindings(fs, "cannot-run") != 4 || len(fs) != 4 {
		t.Errorf("findings: %+v", fs)
	}
}

func TestMLKEMFlippedSharedSecret(t *testing.T) {
	files := ossl35Files(t)
	name := alg.MLKEM768.FileName("_ss.bin")
	files[name][0] ^= 1
	rows, _ := CheckMLKEM(files, alg.MLKEM768)
	want := wantRows(alg.MLKEM768, "seed", "N", "cert", "Y", "consistent", "Y")
	if got := rowString(rows); got != want {
		t.Errorf("rows:\n%s\nwant\n%s", got, want)
	}
}

func TestMLKEMSeedFileNotSeedOnly(t *testing.T) {
	a := alg.MLKEM768
	files := ossl35Files(t)
	files[a.FileName("_seed_priv.der")] = files[a.FileName("_both_priv.der")]
	rows, _ := CheckMLKEM(files, a)
	want := wantRows(a, "seed", "N", "cert", "Y", "consistent", "N")
	if got := rowString(rows); got != want {
		t.Errorf("rows:\n%s\nwant\n%s", got, want)
	}
}

func TestMLKEMSeedFormStrictness(t *testing.T) {
	a := alg.MLKEM768
	good := ossl35Files(t)[a.FileName("_seed_priv.der")]
	cases := map[string][]byte{
		"trailing byte":   append(append([]byte(nil), good...), 0),
		"empty":           {},
		"wrong tag":       withByte(good, 20, 0x04),
		"wrong seed len":  withByte(good, 21, 0x3f),
		"wrong OID":       withByte(good, 17, 0x03),
		"nonzero version": withByte(good, 4, 1),
		"null params":     withNullParams(good),
	}
	for name, der := range cases {
		if _, err := seedDecapsulator(der, a); err == nil {
			t.Errorf("%s: accepted", name)
		}
	}
	if _, err := seedDecapsulator(good, a); err != nil {
		t.Errorf("good seed rejected: %v", err)
	}
}

func withByte(b []byte, i int, v byte) []byte {
	c := append([]byte(nil), b...)
	c[i] = v
	return c
}

// withNullParams inserts NULL parameters into the AlgorithmIdentifier and
// fixes the two enclosing lengths, so only the parameters are wrong.
func withNullParams(good []byte) []byte {
	c := append(append(append([]byte(nil), good[:18]...), 0x05, 0x00), good[18:]...)
	c[1] += 2
	c[6] += 2
	return c
}

func TestMLKEMBadEEIsN(t *testing.T) {
	a := alg.MLKEM768
	files := ossl35Files(t)
	ee := a.FileName("_ee.der")
	files[ee] = files[ee][:len(files[ee])-40]
	rows, _ := CheckMLKEM(files, a)
	want := wantRows(a, "seed", "Y", "cert", "N", "consistent", "N")
	if got := rowString(rows); got != want {
		t.Errorf("rows:\n%s\nwant\n%s", got, want)
	}
}

func TestMLKEMEEOfOtherParameterSetIsN(t *testing.T) {
	files := ossl35Files(t)
	files[alg.MLKEM1024.FileName("_ee.der")] = files[alg.MLKEM768.FileName("_ee.der")]
	rows, _ := CheckMLKEM(files, alg.MLKEM1024)
	want := wantRows(alg.MLKEM1024, "seed", "Y", "cert", "N", "consistent", "N")
	if got := rowString(rows); got != want {
		t.Errorf("rows:\n%s\nwant\n%s", got, want)
	}
}

func TestMLKEMMissingPieces(t *testing.T) {
	a := alg.MLKEM768
	t.Run("no ciphertext", func(t *testing.T) {
		files := ossl35Files(t)
		delete(files, a.FileName("_ciphertext.bin"))
		rows, fs := CheckMLKEM(files, a)
		if got, want := rowString(rows), wantRows(a, "cert", "Y", "consistent", "Y"); got != want {
			t.Errorf("rows:\n%s", got)
		}
		if countFindings(fs, "cannot-run") != 3 {
			t.Errorf("findings: %+v", fs)
		}
	})
	t.Run("no EE", func(t *testing.T) {
		files := ossl35Files(t)
		delete(files, a.FileName("_ee.der"))
		rows, _ := CheckMLKEM(files, a)
		if got, want := rowString(rows), wantRows(a, "seed", "Y"); got != want {
			t.Errorf("rows:\n%s", got)
		}
	})
	t.Run("no key", func(t *testing.T) {
		files := ossl35Files(t)
		delete(files, a.FileName("_seed_priv.der"))
		rows, _ := CheckMLKEM(files, a)
		if got, want := rowString(rows), wantRows(a, "cert", "Y"); got != want {
			t.Errorf("rows:\n%s", got)
		}
	})
	t.Run("no TA is a strict finding only", func(t *testing.T) {
		files := ossl35Files(t)
		delete(files, alg.MLDSA65.FileName("_ta.der"))
		rows, fs := CheckMLKEM(files, a)
		if got, want := rowString(rows), wantRows(a, "seed", "Y", "cert", "Y", "consistent", "Y"); got != want {
			t.Errorf("rows:\n%s", got)
		}
		if countFindings(fs, "strict") != 1 {
			t.Errorf("findings: %+v", fs)
		}
	})
}

func TestMLKEMWrongTAIsStrictFindingOnly(t *testing.T) {
	a := alg.MLKEM768
	files := ossl35Files(t)
	files[alg.MLDSA65.FileName("_ta.der")] = files[alg.MLDSA87.FileName("_ta.der")]
	rows, fs := CheckMLKEM(files, a)
	if got, want := rowString(rows), wantRows(a, "seed", "Y", "cert", "Y", "consistent", "Y"); got != want {
		t.Errorf("rows:\n%s", got)
	}
	if countFindings(fs, "strict") != 1 {
		t.Errorf("findings: %+v", fs)
	}
}

// TestMLKEMTruncationsNeverPanic cuts every artifact at every length.
func TestMLKEMTruncationsNeverPanic(t *testing.T) {
	for _, a := range kemAlgs {
		for _, suffix := range []string{"_seed_priv.der", "_ee.der", "_ciphertext.bin", "_ss.bin", "_ta.der"} {
			name := a.FileName(suffix)
			if suffix == "_ta.der" {
				name = alg.IssuerFor(a).FileName(suffix)
			}
			files := ossl35Files(t)
			full := files[name]
			step := 1
			if len(full) > 200 {
				step = 37
			}
			for n := 0; n < len(full); n += step {
				files[name] = full[:n]
				CheckMLKEM(files, a)
			}
		}
	}
}

func TestRunOssl35IncludesKEMRows(t *testing.T) {
	z := filepath.Join("..", "..", "..", "..", "ossl35", "artifacts_certs_r5.zip")
	csv, _ := runZip(t, z)
	want := ""
	for _, a := range kemAlgs {
		want += row(a, "seed", "Y") + row(a, "cert", "Y") + row(a, "consistent", "Y")
	}
	if !strings.HasSuffix(csv, want) || strings.Contains(csv, alg.MLKEM512.OID) {
		t.Errorf("CSV:\n%s", csv)
	}
}

// TestHybridPrefixedFilesAreIgnored: bc ships external_ml-kem-768-<oid>_ee.der
// next to the plain EE. The checker ignores external_, catalyst_ and chameleon_
// files, so it must not pick one of them by map order.
func TestHybridPrefixedFilesAreIgnored(t *testing.T) {
	a := alg.MLKEM768
	files := ossl35Files(t)
	files["external_"+a.FileName("_ee.der")] = []byte("not a certificate")
	for i := 0; i < 50; i++ {
		rows, _ := CheckMLKEM(files, a)
		if got, want := rowString(rows), wantRows(a, "seed", "Y", "cert", "Y", "consistent", "Y"); got != want {
			t.Fatalf("run %d rows:\n%s", i, got)
		}
	}
}
