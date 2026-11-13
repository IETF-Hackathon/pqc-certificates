package check

import (
	"encoding/asn1"
	"path/filepath"
	"strings"
	"testing"

	"pqccerts/okwuosa/internal/alg"
	"pqccerts/okwuosa/internal/der"
)

// Repo zips that hold FrodoKEM artifacts, relative to this package.
var (
	bcZip         = filepath.Join("..", "..", "..", "..", "bc", "artifacts_certs_r5.zip")
	cryptonextZip = filepath.Join("..", "..", "..", "..", "cryptonext", "artifacts_certs_r5.zip")
)

func frodoRows(a alg.Alg, priv, cert, consistent string) string {
	return row(a, "priv", priv) + row(a, "cert", cert) + row(a, "consistent", consistent)
}

func rowsCSV(rows []Row) string {
	var b strings.Builder
	for _, r := range rows {
		res := "N"
		if r.OK {
			res = "Y"
		}
		b.WriteString(r.OID + "," + r.Type + "," + res + "\n")
	}
	return b.String()
}

func readRepoZip(t *testing.T, path string) map[string][]byte {
	t.Helper()
	files, err := ReadZip(path)
	if err != nil {
		t.Fatal(err)
	}
	return files
}

// frodoFiles returns bc's four artifacts for a, keyed by suffix as well as by
// name, so a test can replace or delete one.
func frodoFiles(t *testing.T, a alg.Alg) (files map[string][]byte, names map[string]string) {
	t.Helper()
	all := readRepoZip(t, bcZip)
	files, names = map[string][]byte{}, map[string]string{}
	for _, suffix := range []string{"_priv.der", "_ee.der", "_ciphertext.bin", "_ss.bin"} {
		name, data, ok := find(all, a, suffix)
		if !ok {
			t.Fatalf("bc has no %s file for %s", suffix, a.Friendly)
		}
		files[name], names[suffix] = append([]byte(nil), data...), name
	}
	return files, names
}

func TestEFrodoKEMReferenceZipsAreAllY(t *testing.T) {
	for _, zip := range []string{bcZip, cryptonextZip} {
		files := readRepoZip(t, zip)
		for _, a := range alg.EFrodoKEM() {
			rows, fs := CheckEFrodoKEM(files, a)
			if got, want := rowsCSV(rows), frodoRows(a, "Y", "Y", "Y"); got != want {
				t.Errorf("%s %s:\ngot\n%swant\n%s", zip, a.Friendly, got, want)
			}
			if n := countCheck(fs, "failed") + countCheck(fs, "cannot-run"); n != 0 {
				t.Errorf("%s %s: unexpected findings %+v", zip, a.Friendly, fs)
			}
		}
	}
}

func TestEFrodoKEMDamagedArtifacts(t *testing.T) {
	a := alg.EFrodoKEM976SHAKE
	flipLast := func(b []byte) []byte { b[len(b)-1] ^= 1; return b }
	cases := []struct {
		name   string
		damage func(files map[string][]byte, names map[string]string)
		want   string
	}{
		{"shared secret differs", func(f map[string][]byte, n map[string]string) {
			flipLast(f[n["_ss.bin"]])
		}, frodoRows(a, "N", "Y", "Y")},
		{"ciphertext truncated", func(f map[string][]byte, n map[string]string) {
			f[n["_ciphertext.bin"]] = f[n["_ciphertext.bin"]][:100]
		}, frodoRows(a, "N", "Y", "Y")},
		{"private key truncated", func(f map[string][]byte, n map[string]string) {
			f[n["_priv.der"]] = f[n["_priv.der"]][:200]
		}, frodoRows(a, "N", "Y", "N")},
		{"private key is not DER", func(f map[string][]byte, n map[string]string) {
			f[n["_priv.der"]] = []byte("not a key")
		}, frodoRows(a, "N", "Y", "N")},
		{"certificate is not DER", func(f map[string][]byte, n map[string]string) {
			f[n["_ee.der"]] = []byte("not a certificate")
		}, frodoRows(a, "Y", "N", "N")},
	}
	for _, c := range cases {
		t.Run(c.name, func(t *testing.T) {
			files, names := frodoFiles(t, a)
			c.damage(files, names)
			rows, fs := CheckEFrodoKEM(files, a)
			if got := rowsCSV(rows); got != c.want {
				t.Errorf("got\n%swant\n%s", got, c.want)
			}
			if countCheck(fs, "failed") == 0 {
				t.Error("an N row must be explained by a failed finding")
			}
		})
	}
}

func TestEFrodoKEMPublicKeyInKeyDiffersFromCertificate(t *testing.T) {
	a := alg.EFrodoKEM976SHAKE
	files, names := frodoFiles(t, a)
	// The public key seedA || b follows the 24-byte value s at the start of
	// the 31296-byte secret key, which is the tail of the file.
	key := files[names["_priv.der"]]
	key[len(key)-31296+24+100] ^= 1
	rows, _ := CheckEFrodoKEM(files, a)
	if got := rowsCSV(rows); !strings.Contains(got, row(a, "consistent", "N")) {
		t.Errorf("want consistent,N, got\n%s", got)
	}
}

func TestEFrodoKEMKeyOfAnotherParameterSet(t *testing.T) {
	a, other := alg.EFrodoKEM976SHAKE, alg.EFrodoKEM976AES
	files, names := frodoFiles(t, a)
	otherFiles, otherNames := frodoFiles(t, other)
	files[names["_priv.der"]] = otherFiles[otherNames["_priv.der"]]
	rows, _ := CheckEFrodoKEM(files, a)
	if got, want := rowsCSV(rows), frodoRows(a, "N", "Y", "N"); got != want {
		t.Errorf("got\n%swant\n%s", got, want)
	}
}

func TestEFrodoKEMMissingFilesGiveNoRow(t *testing.T) {
	a := alg.EFrodoKEM976SHAKE
	t.Run("no ciphertext", func(t *testing.T) {
		files, names := frodoFiles(t, a)
		delete(files, names["_ciphertext.bin"])
		rows, fs := CheckEFrodoKEM(files, a)
		want := row(a, "cert", "Y") + row(a, "consistent", "Y")
		if got := rowsCSV(rows); got != want {
			t.Errorf("got\n%swant\n%s", got, want)
		}
		if countCheck(fs, "cannot-run") != 1 {
			t.Errorf("want one cannot-run finding, got %+v", fs)
		}
	})
	t.Run("no certificate", func(t *testing.T) {
		files, names := frodoFiles(t, a)
		delete(files, names["_ee.der"])
		rows, fs := CheckEFrodoKEM(files, a)
		if got, want := rowsCSV(rows), row(a, "priv", "Y"); got != want {
			t.Errorf("got\n%swant\n%s", got, want)
		}
		if countCheck(fs, "cannot-run") != 1 {
			t.Errorf("want one cannot-run finding, got %+v", fs)
		}
	})
	t.Run("nothing", func(t *testing.T) {
		rows, fs := CheckEFrodoKEM(map[string][]byte{}, a)
		if len(rows) != 0 || len(fs) != 0 {
			t.Errorf("want nothing, got %v %v", rows, fs)
		}
	})
}

func TestRunAddsEFrodoKEMRowsAndReportsSaltedFrodoKEM(t *testing.T) {
	csv, fs := runZip(t, refZip(t, bcZip))
	for _, a := range alg.EFrodoKEM() {
		if !strings.Contains(csv, frodoRows(a, "Y", "Y", "Y")) {
			t.Errorf("CSV lacks the three Y rows for %s", a.Friendly)
		}
	}
	for _, a := range alg.SaltedFrodoKEM() {
		if strings.Contains(csv, a.OID+",") {
			t.Errorf("CSV has a row for salted %s, which is not checked", a.Friendly)
		}
		found := false
		for _, f := range fs {
			if f.Check == "cannot-run" && strings.Contains(f.File, a.OID) {
				found = true
			}
		}
		if !found {
			t.Errorf("no cannot-run finding for salted %s", a.Friendly)
		}
	}
}

func TestOwnZipHasNoFrodoKEMRows(t *testing.T) {
	csv, _ := runFiles(t, ownFiles(t))
	if csv != allY() {
		t.Errorf("our own CSV changed:\n%s", csv)
	}
}

// BenchmarkEFrodoKEMCheck times the three rows of one algorithm over bc's
// artifacts: one decapsulation, one encapsulation and the parsing.
func BenchmarkEFrodoKEMCheck(b *testing.B) {
	files, err := ReadZip(bcZip)
	if err != nil {
		b.Fatal(err)
	}
	for _, a := range alg.EFrodoKEM() {
		b.Run(a.Friendly, func(b *testing.B) {
			for i := 0; i < b.N; i++ {
				if rows, _ := CheckEFrodoKEM(files, a); len(rows) != 3 {
					b.Fatalf("got %d rows", len(rows))
				}
			}
		})
	}
}

func TestEFrodoKEMStrictSignatureCheckNeverMakesARow(t *testing.T) {
	a := alg.EFrodoKEM976SHAKE
	hasStrict := func(fs []Finding) bool { return countCheck(fs, "strict") > 0 }

	// In bc's zip the EE is signed by the ML-DSA-65 TA of the same zip.
	if _, fs := CheckEFrodoKEM(readRepoZip(t, bcZip), a); hasStrict(fs) {
		t.Errorf("signature verifies under the TA, yet: %+v", fs)
	}
	// Without the TA the signature cannot be checked: a finding, same rows.
	files, _ := frodoFiles(t, a)
	rows, fs := CheckEFrodoKEM(files, a)
	if got, want := rowsCSV(rows), frodoRows(a, "Y", "Y", "Y"); got != want {
		t.Errorf("got\n%swant\n%s", got, want)
	}
	if !hasStrict(fs) {
		t.Error("want a strict finding when the issuing TA is not in the zip")
	}
}

func TestEFrodoKEMCertificateOfAnotherParameterSet(t *testing.T) {
	a, other := alg.EFrodoKEM976SHAKE, alg.EFrodoKEM976AES
	files, names := frodoFiles(t, a)
	otherFiles, otherNames := frodoFiles(t, other)
	files[names["_ee.der"]] = otherFiles[otherNames["_ee.der"]]
	rows, _ := CheckEFrodoKEM(files, a)
	// A certificate that is not usable for a also makes `consistent` N.
	if got, want := rowsCSV(rows), frodoRows(a, "Y", "N", "N"); got != want {
		t.Errorf("got\n%swant\n%s", got, want)
	}
}

func TestEFrodoKEMKeyOfAnotherSizeOrForm(t *testing.T) {
	a := alg.EFrodoKEM976SHAKE
	oid := asn1.ObjectIdentifier{1, 0, 18033, 2, 2, 7, 3}
	bigFiles, bigNames := frodoFiles(t, alg.EFrodoKEM1344SHAKE)
	cases := map[string][]byte{
		"a 1344 key":     bigFiles[bigNames["_priv.der"]],
		"seed form":      der.PKCS8Seed(oid, make([]byte, 32)),
		"both form":      der.PKCS8Both(oid, make([]byte, 32), make([]byte, 31296)),
		"expanded short": der.PKCS8Expanded(oid, make([]byte, 31295)),
	}
	for name, key := range cases {
		t.Run(name, func(t *testing.T) {
			files, names := frodoFiles(t, a)
			files[names["_priv.der"]] = key
			rows, fs := CheckEFrodoKEM(files, a)
			if got, want := rowsCSV(rows), frodoRows(a, "N", "Y", "N"); got != want {
				t.Errorf("got\n%swant\n%s", got, want)
			}
			if countCheck(fs, "failed") == 0 {
				t.Error("no failed finding")
			}
		})
	}
}

func TestEFrodoKEM1344PublicKeyOffset(t *testing.T) {
	a := alg.EFrodoKEM1344AES
	files, names := frodoFiles(t, a)
	// For 1344 the value s before the public key is 32 bytes.
	key := files[names["_priv.der"]]
	key[len(key)-43088+32+100] ^= 1
	rows, _ := CheckEFrodoKEM(files, a)
	if got := rowsCSV(rows); !strings.Contains(got, row(a, "consistent", "N")) {
		t.Errorf("want consistent,N, got\n%s", got)
	}
}

func TestEFrodoKEMWrongLengthCiphertextIsExplained(t *testing.T) {
	a := alg.EFrodoKEM976SHAKE
	files, names := frodoFiles(t, a)
	files[names["_ciphertext.bin"]] = files[names["_ciphertext.bin"]][:100]
	_, fs := CheckEFrodoKEM(files, a)
	for _, f := range fs {
		if f.Check == "failed" && strings.Contains(f.Detail, "ciphertext is 100 bytes") {
			return
		}
	}
	t.Errorf("no finding names the ciphertext length: %+v", fs)
}

func TestIsArtifactAdmitsOnlyFilesThatAreUsed(t *testing.T) {
	cases := map[string]bool{
		// ML-DSA and ML-KEM: as before, the generic _priv.der is not read.
		"ml-kem-768-2.16.840.1.101.3.4.4.2_seed_priv.der": true,
		"ml-kem-768-2.16.840.1.101.3.4.4.2_ee.der":        true,
		"ml-kem-768-2.16.840.1.101.3.4.4.2_priv.der":      false,
		"ml-dsa-65-2.16.840.1.101.3.4.3.18_priv.der":      false,
		// eFrodoKEM: the four files of a set and nothing else.
		"x-1.0.18033.2.2.7.3_priv.der":       true,
		"x-1.0.18033.2.2.7.3_ee.der":         true,
		"x-1.0.18033.2.2.7.3_ciphertext.bin": true,
		"x-1.0.18033.2.2.7.3_ss.bin":         true,
		"x-1.0.18033.2.2.7.3_ta.der":         false,
		"x-1.0.18033.2.2.7.3_seed_priv.der":  false,
		// Salted FrodoKEM: only what is needed to report its presence.
		"x-1.0.18033.2.2.7.1_priv.der":       true,
		"x-1.0.18033.2.2.7.1_ee.der":         true,
		"x-1.0.18033.2.2.7.1_ciphertext.bin": false,
		"x-1.0.18033.2.2.7.1_ss.bin":         false,
		"x-1.2.3_priv.der":                   false,
	}
	for name, want := range cases {
		if got := isArtifact(name); got != want {
			t.Errorf("isArtifact(%q) = %v, want %v", name, got, want)
		}
	}
}
