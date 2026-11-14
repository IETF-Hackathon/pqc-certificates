package check

import (
	"bytes"
	"encoding/asn1"
	"math/rand"
	"strings"
	"testing"

	"pqccerts/okwuosa/internal/alg"
	"pqccerts/okwuosa/internal/der"
)

// flip returns data with the byte fromEnd bytes before the end changed
// (fromEnd 1 is the last byte).
func flip(data []byte, fromEnd int) []byte {
	out := bytes.Clone(data)
	out[len(out)-fromEnd] ^= 0x55
	return out
}

func wantRows(t *testing.T, csv string, a alg.Alg, want map[string]string) {
	t.Helper()
	for typ, res := range want {
		if !strings.Contains(csv, row(a, typ, res)) {
			t.Errorf("want %s,%s for %s:\n%s", typ, res, a.Friendly, csv)
		}
	}
}

func TestCorruptSelfSignatureIsN(t *testing.T) {
	files := ownFiles(t)
	name := alg.MLDSA87.FileName("_ta.der")
	files[name] = flip(files[name], 1)
	csv, _ := runFiles(t, files)
	wantRows(t, csv, alg.MLDSA87, map[string]string{"cert": "N", "seed": "Y", "consistent": "Y"})
	wantRows(t, csv, alg.MLDSA44, map[string]string{"cert": "Y"})
}

func TestBothFormWithMismatchedSeedIsN(t *testing.T) {
	files := ownFiles(t)
	for _, a := range []alg.Alg{alg.MLDSA44, alg.MLKEM768} {
		name := a.FileName("_both_priv.der")
		_, seed, _, err := der.ParsePKCS8(files[name])
		if err != nil {
			t.Fatal(err)
		}
		i := bytes.Index(files[name], seed)
		bad := bytes.Clone(files[name])
		bad[i] ^= 0x01
		files[name] = bad
	}
	csv, _ := runFiles(t, files)
	wantRows(t, csv, alg.MLDSA44, map[string]string{"both": "N", "consistent": "N", "seed": "Y"})
	wantRows(t, csv, alg.MLKEM768, map[string]string{"both": "N", "consistent": "N", "seed": "Y"})
}

func TestKeyInTheWrongFormIsN(t *testing.T) {
	files := ownFiles(t)
	for _, a := range []alg.Alg{alg.MLDSA65, alg.MLKEM1024} {
		files[a.FileName("_expandedkey_priv.der")] = files[a.FileName("_seed_priv.der")]
		files[a.FileName("_seed_priv.der")] = files[a.FileName("_both_priv.der")]
	}
	csv, _ := runFiles(t, files)
	for _, a := range []alg.Alg{alg.MLDSA65, alg.MLKEM1024} {
		wantRows(t, csv, a, map[string]string{"seed": "N", "expandedkey": "N", "both": "Y"})
	}
}

func TestKEMArtifactDamage(t *testing.T) {
	a := alg.MLKEM768
	ct, ss, exp, ee := a.FileName("_ciphertext.bin"), a.FileName("_ss.bin"), a.FileName("_expandedkey_priv.der"), a.FileName("_ee.der")
	cases := []struct {
		name   string
		damage func(f map[string][]byte)
		want   map[string]string
	}{
		{"short ciphertext", func(f map[string][]byte) { f[ct] = f[ct][:10] },
			map[string]string{"seed": "N", "expandedkey": "N", "both": "N", "cert": "Y", "consistent": "Y"}},
		{"empty shared secret", func(f map[string][]byte) { f[ss] = nil },
			map[string]string{"seed": "N", "expandedkey": "N", "both": "N"}},
		{"long shared secret", func(f map[string][]byte) { f[ss] = append(f[ss], 0) },
			map[string]string{"seed": "N"}},
		{"wrong shared secret", func(f map[string][]byte) { f[ss] = flip(f[ss], 1) },
			map[string]string{"seed": "N", "cert": "Y"}},
		// OpenSSL rejects an expanded key whose embedded H(ek) is wrong.
		{"expanded key hash broken", func(f map[string][]byte) { f[exp] = flip(f[exp], 40) },
			map[string]string{"expandedkey": "N", "consistent": "N", "seed": "Y"}},
		// z is used only to reject invalid ciphertexts, so a valid one still
		// decapsulates and OpenSSL accepts the key.
		{"expanded key z changed", func(f map[string][]byte) { f[exp] = flip(f[exp], 3) },
			map[string]string{"expandedkey": "Y", "consistent": "Y"}},
		{"EE of another level", func(f map[string][]byte) { f[ee] = f[alg.MLKEM512.FileName("_ee.der")] },
			map[string]string{"cert": "N", "consistent": "N", "seed": "Y"}},
	}
	for _, c := range cases {
		files := ownFiles(t)
		c.damage(files)
		csv, _ := runFiles(t, files)
		t.Run(c.name, func(t *testing.T) { wantRows(t, csv, a, c.want) })
	}
}

func TestKEMWithoutEEOrSecret(t *testing.T) {
	files := ownFiles(t)
	a := alg.MLKEM512
	noEE := cloneFiles(files)
	delete(noEE, a.FileName("_ee.der"))
	csv, fs := runFiles(t, noEE)
	wantRows(t, csv, a, map[string]string{"seed": "Y", "expandedkey": "Y", "both": "Y"})
	if strings.Contains(csv, a.OID+",cert") || strings.Contains(csv, a.OID+",consistent") || countCheck(fs, "cannot-run") != 3 {
		t.Errorf("no-EE csv:\n%s\n%+v", csv, fs)
	}
	noSS := cloneFiles(files)
	delete(noSS, a.FileName("_ss.bin"))
	csv, fs = runFiles(t, noSS)
	wantRows(t, csv, a, map[string]string{"cert": "Y", "consistent": "Y"})
	if strings.Contains(csv, a.OID+",seed") || countCheck(fs, "cannot-run") != 3 {
		t.Errorf("no-ss csv:\n%s\n%+v", csv, fs)
	}
}

// TestRandomDamageNeverPanicsOrAborts mutates random bytes of random files
// and truncates others; Run must finish and write a well-formed CSV.
func TestRandomDamageNeverPanicsOrAborts(t *testing.T) {
	base := ownFiles(t)
	names := make([]string, 0, len(base))
	for n := range base {
		names = append(names, n)
	}
	rng := rand.New(rand.NewSource(7))
	for i := 0; i < 60; i++ {
		files := cloneFiles(base)
		for j := 0; j < 1+rng.Intn(4); j++ {
			n := names[rng.Intn(len(names))]
			b := files[n]
			if len(b) == 0 {
				continue
			}
			switch rng.Intn(3) {
			case 0:
				files[n] = b[:rng.Intn(len(b))]
			default:
				b[rng.Intn(len(b))] = byte(rng.Intn(256))
			}
		}
		csv, _ := runFiles(t, files)
		if !strings.HasPrefix(csv, header) || strings.Contains(csv, "\r") {
			t.Fatalf("round %d: bad CSV %q", i, csv)
		}
	}
}

// v1Key rewrites a key file as a version 1 OneAsymmetricKey with a public key
// attached, as corey-digicert ships them. OpenSSL loads these.
func v1Key(t *testing.T, a alg.Alg, file, pub []byte) []byte {
	t.Helper()
	k, err := der.ParsePrivateKey(file)
	if err != nil {
		t.Fatal(err)
	}
	var choice []byte
	switch {
	case k.Seed != nil && k.Expanded != nil:
		choice, err = asn1.Marshal(struct{ Seed, Expanded []byte }{k.Seed, k.Expanded})
	case k.Seed != nil:
		choice, err = asn1.Marshal(asn1.RawValue{Class: asn1.ClassContextSpecific, Tag: 0, Bytes: k.Seed})
	default:
		choice, err = asn1.Marshal(k.Expanded)
	}
	if err != nil {
		t.Fatal(err)
	}
	oid, _ := asn1.Marshal(k.OID)
	algID := append([]byte{0x30, byte(len(oid))}, oid...)
	pubField := append([]byte{0x81}, append(lenBytes(len(pub)+1), append([]byte{0}, pub...)...)...)
	octet := append([]byte{0x04}, append(lenBytes(len(choice)), choice...)...)
	body := append(append(append([]byte{0x02, 0x01, 0x01}, algID...), octet...), pubField...)
	return append([]byte{0x30}, append(lenBytes(len(body)), body...)...)
}

func lenBytes(n int) []byte {
	if n < 0x80 {
		return []byte{byte(n)}
	}
	if n < 0x100 {
		return []byte{0x81, byte(n)}
	}
	return []byte{0x82, byte(n >> 8), byte(n)}
}

func TestVersion1KeysWithPublicKeyAreAccepted(t *testing.T) {
	files := ownFiles(t)
	for _, a := range []alg.Alg{alg.MLDSA44, alg.MLKEM768} {
		for _, suffix := range []string{"_seed_priv.der", "_expandedkey_priv.der", "_both_priv.der"} {
			pub := bytes.Repeat([]byte{1}, 1312) // wrong on purpose: only a strict finding
			files[a.FileName(suffix)] = v1Key(t, a, files[a.FileName(suffix)], pub)
		}
	}
	csv, fs := runFiles(t, files)
	if csv != allY() {
		t.Errorf("version 1 keys changed the result:\n%s", csv)
	}
	if n := countCheck(fs, "strict"); n != 6 {
		t.Errorf("want 6 strict findings for the wrong attached public keys, got %d: %+v", n, fs)
	}
}
