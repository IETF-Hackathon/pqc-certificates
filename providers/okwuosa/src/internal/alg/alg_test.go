package alg

import "testing"

func TestFileName(t *testing.T) {
	got := MLDSA44.FileName("_ta.der")
	want := "ml-dsa-44-2.16.840.1.101.3.4.3.17_ta.der"
	if got != want {
		t.Fatalf("got %q want %q", got, want)
	}
}

func TestParseFileName(t *testing.T) {
	for _, in := range []string{
		"x/ML-KEM-768-2.16.840.1.101.3.4.4.2_seed_priv.der",
		"ml-kem-768-2.16.840.1.101.3.4.4.2_seed_priv.der",
	} {
		oid, suffix, ok := ParseFileName(in)
		if !ok || oid != "2.16.840.1.101.3.4.4.2" || suffix != "_seed_priv.der" {
			t.Errorf("%q: got (%q,%q,%v)", in, oid, suffix, ok)
		}
	}
	if _, _, ok := ParseFileName("readme.txt"); ok {
		t.Error("readme.txt should not parse")
	}
}

func TestIssuerFor(t *testing.T) {
	cases := map[string]Alg{
		MLKEM512.OID: MLDSA44, MLKEM768.OID: MLDSA65, MLKEM1024.OID: MLDSA87,
	}
	for _, k := range []Alg{MLKEM512, MLKEM768, MLKEM1024} {
		if got := IssuerFor(k); got != cases[k.OID] {
			t.Errorf("%s: got %s", k.Friendly, got.Friendly)
		}
	}
}

func TestAllAndByOID(t *testing.T) {
	if len(All()) != 6 {
		t.Fatal("want 6 algs")
	}
	for _, a := range All() {
		got, ok := ByOID(a.OID)
		if !ok || got != a {
			t.Errorf("ByOID(%s)", a.OID)
		}
	}
	if _, ok := ByOID("1.2.3"); ok {
		t.Error("unknown OID found")
	}
}

func TestParseFileNamePlainPriv(t *testing.T) {
	oid, suffix, ok := ParseFileName("artifacts/efrodokem976shake-1.0.18033.2.2.7.3_priv.der")
	if !ok || oid != "1.0.18033.2.2.7.3" || suffix != "_priv.der" {
		t.Errorf("got (%q,%q,%v)", oid, suffix, ok)
	}
	// The more specific suffixes still win.
	if _, suffix, _ := ParseFileName("ml-kem-768-2.16.840.1.101.3.4.4.2_both_priv.der"); suffix != "_both_priv.der" {
		t.Errorf("suffix = %q", suffix)
	}
}

func TestFrodoKEMTables(t *testing.T) {
	if len(EFrodoKEM()) != 4 || len(SaltedFrodoKEM()) != 4 {
		t.Fatal("want 4 eFrodoKEM and 4 salted FrodoKEM parameter sets")
	}
	for _, a := range EFrodoKEM() {
		if !IsEFrodoKEM(a) || !Known(a.OID) {
			t.Errorf("%s: IsEFrodoKEM or Known is false", a.Friendly)
		}
		if _, ok := ByOID(a.OID); ok {
			t.Errorf("%s: ByOID must stay limited to ML-DSA and ML-KEM", a.Friendly)
		}
	}
	for _, a := range SaltedFrodoKEM() {
		if IsEFrodoKEM(a) || !Known(a.OID) {
			t.Errorf("%s: salted set misclassified", a.Friendly)
		}
	}
	if !Known(MLDSA44.OID) || Known("1.2.3") {
		t.Error("Known is wrong for ML-DSA-44 or for an unknown OID")
	}
}
