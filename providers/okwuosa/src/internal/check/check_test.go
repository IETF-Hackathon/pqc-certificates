package check

import (
	"strings"
	"testing"

	"pqccerts/okwuosa/internal/alg"
)

func TestCheckOwnArtifacts(t *testing.T) {
	csv, fs := runFiles(t, ownFiles(t))
	if csv != allY() {
		t.Errorf("CSV mismatch:\n%s\nwant\n%s", csv, allY())
	}
	if strings.Contains(csv, "\r") || strings.HasSuffix(csv, "\n\n") || strings.HasPrefix(csv, "\ufeff") {
		t.Error("bad line endings or BOM")
	}
	if len(fs) != 0 {
		t.Errorf("findings: %+v", fs)
	}
}

func TestCheckOssl35AllY(t *testing.T) {
	csv, fs := runZip(t, refZip(t, ossl35Zip))
	if csv != allY() {
		t.Errorf("ossl35 CSV:\n%s", csv)
	}
	if n := countCheck(fs, "failed") + countCheck(fs, "cannot-run"); n != 0 {
		t.Errorf("findings: %+v", fs)
	}
}

func TestCheckGoCryptoZip(t *testing.T) {
	csv, _ := runZip(t, refZip(t, goCryptoZip))
	var rows []string
	for _, a := range dsaAlgs {
		rows = append(rows, row(a, "seed", "Y"), row(a, "cert", "Y"), row(a, "consistent", "Y"))
	}
	if csv != csvOf(rows...) {
		t.Errorf("go-crypto CSV:\n%s", csv)
	}
}

func TestTruncatedEE(t *testing.T) {
	files := ownFiles(t)
	a := alg.MLKEM768
	files[a.FileName("_ee.der")] = files[a.FileName("_ee.der")][:200]
	csv, fs := runFiles(t, files)
	for _, typ := range keyRowTypes {
		if !strings.Contains(csv, row(a, typ, "Y")) {
			t.Errorf("%s row should still be Y:\n%s", typ, csv)
		}
	}
	for _, typ := range []string{"cert", "consistent"} {
		if !strings.Contains(csv, row(a, typ, "N")) {
			t.Errorf("%s should be N:\n%s", typ, csv)
		}
	}
	if countCheck(fs, "failed") == 0 {
		t.Error("no finding explains the N")
	}
}

func TestTruncatedTA(t *testing.T) {
	files := ownFiles(t)
	a := alg.MLDSA65
	files[a.FileName("_ta.der")] = files[a.FileName("_ta.der")][:100]
	csv, _ := runFiles(t, files)
	for _, typ := range allRowTypes {
		if !strings.Contains(csv, row(a, typ, "N")) {
			t.Errorf("%s should be N:\n%s", typ, csv)
		}
		if !strings.Contains(csv, row(alg.MLDSA44, typ, "Y")) || !strings.Contains(csv, row(alg.MLDSA87, typ, "Y")) {
			t.Errorf("other levels must be unaffected for %s", typ)
		}
	}
}

func TestMalformedKeyIsNAndOthersSurvive(t *testing.T) {
	files := ownFiles(t)
	a := alg.MLDSA44
	files[a.FileName("_seed_priv.der")] = []byte{0x30, 0x03, 0x01}
	csv, _ := runFiles(t, files)
	wantRows(t, csv, a, map[string]string{"seed": "N", "consistent": "N", "both": "Y", "cert": "Y"})
}

func TestMissingPieces(t *testing.T) {
	files := ownFiles(t)
	a := alg.MLDSA44
	only := func(names ...string) map[string][]byte {
		m := map[string][]byte{}
		for _, n := range names {
			m[a.FileName(n)] = files[a.FileName(n)]
		}
		return m
	}
	csv, fs := runFiles(t, only("_seed_priv.der"))
	if csv != header || countCheck(fs, "cannot-run") != 1 || !strings.Contains(fs[0].Detail, "no TA") {
		t.Errorf("seed only: %q %+v", csv, fs)
	}
	csv, _ = runFiles(t, only("_ta.der"))
	if csv != csvOf(row(a, "cert", "Y")) {
		t.Errorf("TA only: %q", csv)
	}
}

func TestIgnoresFoldersJunkAndForeignAlgorithms(t *testing.T) {
	nested := map[string][]byte{
		"junk.txt": []byte("x"),
		"d/slh-dsa-sha2-128s-2.16.840.1.101.3.4.3.20_ta.der": []byte("zz"),
	}
	for n, d := range ownFiles(t) {
		nested["top/sub/"+n] = d
	}
	csv, fs := runFiles(t, nested)
	if csv != allY() || len(fs) != 0 {
		t.Errorf("csv %q findings %+v", csv, fs)
	}
}

func TestHybridPrefixedFilesAreIgnored(t *testing.T) {
	files := ownFiles(t)
	a := alg.MLKEM768
	for _, p := range []string{"external_", "catalyst_", "chameleon_"} {
		files[p+a.FileName("_ee.der")] = []byte("not a certificate")
		files[p+alg.MLDSA44.FileName("_ta.der")] = []byte("not a certificate")
	}
	if csv, _ := runFiles(t, files); csv != allY() {
		t.Errorf("hybrid-prefixed files changed the result:\n%s", csv)
	}
}
