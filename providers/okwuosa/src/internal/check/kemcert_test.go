package check

import (
	"path/filepath"
	"strings"
	"testing"

	"pqccerts/okwuosa/internal/alg"
)

var seventhsenseZip = filepath.Join("..", "..", "..", "..", "seventhsense.ai", "artifacts_certs_r5.zip")

// The `cert` row of an ML-KEM EE is the one docs/compat_matrix_instructions.md
// defines: a valid signature by the ML-DSA TA of the same level in the zip.
func TestKEMCertNeedsTheSignatureOfItsTA(t *testing.T) {
	a := alg.MLKEM768
	ee, ta := a.FileName("_ee.der"), alg.IssuerFor(a).FileName("_ta.der")
	t.Run("EE signed by a key that is not the TA", func(t *testing.T) {
		files := ownFiles(t)
		files[ta] = ownFiles(t)[ta] // same level, another key
		csv, fs := runFiles(t, files)
		wantRows(t, csv, a, map[string]string{"seed": "Y", "cert": "N", "consistent": "Y"})
		if !hasFinding(fs, ee, "failed", "does not verify under "+ta) {
			t.Errorf("no finding explains the N: %+v", fs)
		}
	})
	t.Run("EE signature changed", func(t *testing.T) {
		files := ownFiles(t)
		files[ee] = flip(files[ee], 1)
		csv, fs := runFiles(t, files)
		wantRows(t, csv, a, map[string]string{"cert": "N", "consistent": "Y"})
		if !hasFinding(fs, ee, "failed", "does not verify under "+ta) {
			t.Errorf("no finding explains the N: %+v", fs)
		}
	})
	t.Run("TA does not parse", func(t *testing.T) {
		files := ownFiles(t)
		files[ta] = files[ta][:100]
		csv, fs := runFiles(t, files)
		wantRows(t, csv, a, map[string]string{"cert": "N", "consistent": "Y"})
		if !hasFinding(fs, ee, "failed", "does not parse") {
			t.Errorf("no finding explains the N: %+v", fs)
		}
	})
	t.Run("no TA in the zip: the check cannot run, so no row", func(t *testing.T) {
		files := ownFiles(t)
		delete(files, ta)
		csv, fs := runFiles(t, files)
		wantRows(t, csv, a, map[string]string{"seed": "Y", "consistent": "Y"})
		if strings.Contains(csv, a.OID+",cert") {
			t.Errorf("a cert row was written without a TA:\n%s", csv)
		}
		if !hasFinding(fs, ee, "cannot-run", "TA to verify the EE signature against") {
			t.Errorf("no cannot-run finding: %+v", fs)
		}
	})
	t.Run("unusable key and no TA is still N", func(t *testing.T) {
		files := ownFiles(t)
		delete(files, ta)
		files[ee] = files[alg.MLKEM512.FileName("_ee.der")]
		csv, fs := runFiles(t, files)
		wantRows(t, csv, a, map[string]string{"cert": "N", "consistent": "N"})
		if !hasFinding(fs, ee, "failed", "SubjectPublicKeyInfo algorithm") {
			t.Errorf("no finding explains the N: %+v", fs)
		}
	})
	t.Run("TA with a key that is not ML-DSA", func(t *testing.T) {
		files := ownFiles(t)
		files[ta] = files[ee]
		csv, fs := runFiles(t, files)
		wantRows(t, csv, a, map[string]string{"cert": "N", "consistent": "Y"})
		if !hasFinding(fs, ee, "failed", "does not verify under "+ta) {
			t.Errorf("no finding explains the N: %+v", fs)
		}
	})
}

// seventhsense.ai's ML-KEM EEs are signed by keys that are not in its zip.
func TestSeventhsenseKEMCertsAreN(t *testing.T) {
	csv, fs := runZip(t, seventhsenseZip)
	for _, a := range kemAlgs {
		wantRows(t, csv, a, map[string]string{"cert": "N"})
		if !hasFinding(fs, a.OID+"_ee.der", "failed", "does not verify under") {
			t.Errorf("%s: no finding explains the N", a.Friendly)
		}
	}
}

func hasFinding(fs []Finding, file, check, detail string) bool {
	for _, f := range fs {
		if strings.HasSuffix(f.File, file) && f.Check == check && strings.Contains(f.Detail, detail) {
			return true
		}
	}
	return false
}
