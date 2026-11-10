package der

import (
	"archive/zip"
	"bytes"
	"crypto/x509" // test-only: used to cross-check our hand-built DER
	"encoding/asn1"
	"io"
	"math/big"
	"testing"
	"time"

	"pqccerts/okwuosa/internal/alg"
)

// ossl35Zip is the OpenSSL 3.5 reference artifact set, relative to this package.
const ossl35Zip = "../../../../ossl35/artifacts_certs_r5.zip"

// Expected sizes from the ML-DSA / ML-KEM RFCs (RFC 9881 s6, RFC 9935 s6).
var (
	seedLen     = map[int]int{44: 32, 65: 32, 87: 32, 512: 64, 768: 64, 1024: 64}
	expandedLen = map[int]int{44: 2560, 65: 4032, 87: 4896, 512: 1632, 768: 2400, 1024: 3168}
)

func mustOID(t *testing.T, s string) asn1.ObjectIdentifier {
	t.Helper()
	var oid asn1.ObjectIdentifier
	for _, part := range bytes.Split([]byte(s), []byte(".")) {
		n, ok := new(big.Int).SetString(string(part), 10)
		if !ok {
			t.Fatalf("bad OID %q", s)
		}
		oid = append(oid, int(n.Int64()))
	}
	return oid
}

// loadOssl35 returns every file of the reference zip by base name.
func loadOssl35(t *testing.T) map[string][]byte {
	t.Helper()
	zr, err := zip.OpenReader(ossl35Zip)
	if err != nil {
		t.Fatalf("open reference zip: %v", err)
	}
	defer zr.Close()
	files := map[string][]byte{}
	for _, f := range zr.File {
		rc, err := f.Open()
		if err != nil {
			t.Fatal(err)
		}
		b, err := io.ReadAll(rc)
		rc.Close()
		if err != nil {
			t.Fatal(err)
		}
		files[f.Name] = b
	}
	return files
}

func TestParseOssl35Keys(t *testing.T) {
	files := loadOssl35(t)
	for _, a := range alg.All() {
		for _, suffix := range []string{"_seed_priv.der", "_expandedkey_priv.der", "_both_priv.der"} {
			name := a.FileName(suffix)
			data, ok := files[name]
			if !ok {
				t.Fatalf("%s missing from reference zip", name)
			}
			oid, seed, exp, err := ParsePKCS8(data)
			if err != nil {
				t.Fatalf("%s: %v", name, err)
			}
			if oid.String() != a.OID {
				t.Errorf("%s: OID %v, want %s", name, oid, a.OID)
			}
			wantSeed, wantExp := 0, 0
			if suffix != "_expandedkey_priv.der" {
				wantSeed = seedLen[a.Level]
			}
			if suffix != "_seed_priv.der" {
				wantExp = expandedLen[a.Level]
			}
			if len(seed) != wantSeed || len(exp) != wantExp {
				t.Errorf("%s: seed %d expanded %d, want %d and %d", name, len(seed), len(exp), wantSeed, wantExp)
			}
		}
	}
}

func TestRoundTripMatchesOssl35(t *testing.T) {
	files := loadOssl35(t)
	for _, a := range alg.All() {
		oid := mustOID(t, a.OID)
		_, seed, _, _ := ParsePKCS8(files[a.FileName("_seed_priv.der")])
		_, _, exp, _ := ParsePKCS8(files[a.FileName("_expandedkey_priv.der")])
		cases := []struct {
			suffix string
			got    []byte
		}{
			{"_seed_priv.der", PKCS8Seed(oid, seed)},
			{"_expandedkey_priv.der", PKCS8Expanded(oid, exp)},
			{"_both_priv.der", PKCS8Both(oid, seed, exp)},
		}
		for _, c := range cases {
			if !bytes.Equal(c.got, files[a.FileName(c.suffix)]) {
				t.Errorf("%s: builder output differs from ossl35 file", a.FileName(c.suffix))
			}
		}
		// The "both" file's own parse must agree with the two single-form parses.
		_, bs, be, err := ParsePKCS8(files[a.FileName("_both_priv.der")])
		if err != nil || !bytes.Equal(bs, seed) || !bytes.Equal(be, exp) {
			t.Errorf("%s: both file disagrees with seed/expanded files (err %v)", a.Friendly, err)
		}
	}
}

func TestParsePKCS8RejectsTruncationsAtEveryLength(t *testing.T) {
	files := loadOssl35(t)
	for _, a := range []alg.Alg{alg.MLDSA44, alg.MLKEM512} {
		for _, suffix := range []string{"_seed_priv.der", "_expandedkey_priv.der", "_both_priv.der"} {
			data := files[a.FileName(suffix)]
			for n := 0; n < len(data); n++ {
				if _, _, _, err := ParsePKCS8(data[:n]); err == nil {
					t.Fatalf("%s truncated to %d bytes was accepted", a.FileName(suffix), n)
				}
			}
		}
	}
}

func TestParsePKCS8RejectsMalformed(t *testing.T) {
	oid := mustOID(t, alg.MLDSA44.OID)
	seed := bytes.Repeat([]byte{1}, 32)
	good := PKCS8Seed(oid, seed)
	if _, _, _, err := ParsePKCS8(good); err != nil {
		t.Fatalf("control: %v", err)
	}
	tlv := func(tag byte, parts ...[]byte) []byte {
		return appendTLV(nil, tag, bytes.Join(parts, nil))
	}
	oidDER, _ := asn1.Marshal(oid)
	algID := tlv(0x30, oidDER)
	version0 := []byte{0x02, 0x01, 0x00}
	inner := tlv(0x80, seed)

	cases := map[string][]byte{
		"trailing byte":      append(append([]byte{}, good...), 0),
		"empty":              nil,
		"version 1":          tlv(0x30, []byte{0x02, 0x01, 0x01}, algID, tlv(0x04, inner)),
		"parameters NULL":    tlv(0x30, version0, tlv(0x30, oidDER, []byte{0x05, 0x00}), tlv(0x04, inner)),
		"unknown inner tag":  tlv(0x30, version0, algID, tlv(0x04, tlv(0x81, seed))),
		"empty inner":        tlv(0x30, version0, algID, tlv(0x04)),
		"trailing in inner":  tlv(0x30, version0, algID, tlv(0x04, inner, []byte{0})),
		"both with 1 string": tlv(0x30, version0, algID, tlv(0x04, tlv(0x30, tlv(0x04, seed)))),
		"both wrong order":   tlv(0x30, version0, algID, tlv(0x04, tlv(0x30, tlv(0x04, seed), tlv(0x80, seed)))),
		"attributes present": tlv(0x30, version0, algID, tlv(0x04, inner), tlv(0xa0)),
		"non-minimal length": append([]byte{0x30, 0x81, byte(len(good) - 2)}, good[2:]...),
		"indefinite length":  {0x30, 0x80, 0x00, 0x00},
		"huge length":        {0x30, 0x84, 0xff, 0xff, 0xff, 0xff},
		"not a sequence":     append([]byte{0x31}, good[1:]...),
	}
	for name, data := range cases {
		if _, _, _, err := ParsePKCS8(data); err == nil {
			t.Errorf("%s: accepted", name)
		}
	}
}

func testParams(t *testing.T, isCA bool) CertParams {
	t.Helper()
	p := CertParams{
		Serial:    big.NewInt(0x1234567),
		Issuer:    Name{CN: "ml-dsa-44 TA", O: "okwuosa"},
		Subject:   Name{CN: "ml-dsa-44 TA", O: "okwuosa"},
		NotBefore: time.Date(2026, 11, 9, 12, 0, 0, 0, time.UTC),
		NotAfter:  time.Date(2126, 11, 9, 12, 0, 0, 0, time.UTC),
		SigOID:    mustOID(t, alg.MLDSA44.OID),
		PubOID:    mustOID(t, alg.MLDSA44.OID),
		PublicKey: bytes.Repeat([]byte{7}, 1312),
		IsCA:      isCA,
		KeyUsage:  asn1.BitString{Bytes: []byte{0x06}, BitLength: 7}, // keyCertSign, cRLSign
		SKI:       bytes.Repeat([]byte{0xab}, 20),
	}
	if !isCA {
		p.Subject = Name{CN: "ml-kem-512 EE", O: "okwuosa"}
		p.PubOID = mustOID(t, alg.MLKEM512.OID)
		p.KeyUsage = asn1.BitString{Bytes: []byte{0x20}, BitLength: 3} // keyEncipherment
		p.AKI = bytes.Repeat([]byte{0xcd}, 20)
	}
	return p
}

func buildCert(t *testing.T, p CertParams) []byte {
	t.Helper()
	tbs, err := TBS(p)
	if err != nil {
		t.Fatal(err)
	}
	cert, err := Certificate(tbs, p.SigOID, bytes.Repeat([]byte{9}, 2420))
	if err != nil {
		t.Fatal(err)
	}
	return cert
}

func TestTBSParsesWithStdlib(t *testing.T) {
	for _, isCA := range []bool{true, false} {
		p := testParams(t, isCA)
		cert, err := x509.ParseCertificate(buildCert(t, p))
		if err != nil {
			t.Fatalf("isCA=%v: stdlib rejects our certificate: %v", isCA, err)
		}
		if cert.Version != 3 || cert.SerialNumber.Cmp(p.Serial) != 0 {
			t.Errorf("isCA=%v: version %d serial %v", isCA, cert.Version, cert.SerialNumber)
		}
		if !cert.BasicConstraintsValid || cert.IsCA != isCA {
			t.Errorf("isCA=%v: BasicConstraintsValid=%v IsCA=%v", isCA, cert.BasicConstraintsValid, cert.IsCA)
		}
		wantKU := x509.KeyUsageKeyEncipherment
		if isCA {
			wantKU = x509.KeyUsageCertSign | x509.KeyUsageCRLSign
		}
		if cert.KeyUsage != wantKU {
			t.Errorf("isCA=%v: KeyUsage %v, want %v", isCA, cert.KeyUsage, wantKU)
		}
		if !cert.NotBefore.Equal(p.NotBefore) || !cert.NotAfter.Equal(p.NotAfter) {
			t.Errorf("isCA=%v: validity %v..%v", isCA, cert.NotBefore, cert.NotAfter)
		}
		if !bytes.Equal(cert.SubjectKeyId, p.SKI) || !bytes.Equal(cert.AuthorityKeyId, p.AKI) {
			t.Errorf("isCA=%v: SKI %x AKI %x", isCA, cert.SubjectKeyId, cert.AuthorityKeyId)
		}
		if cert.Subject.CommonName != p.Subject.CN || cert.Issuer.CommonName != p.Issuer.CN ||
			len(cert.Subject.Organization) != 1 || cert.Subject.Organization[0] != "okwuosa" {
			t.Errorf("isCA=%v: subject %v issuer %v", isCA, cert.Subject, cert.Issuer)
		}
		if !bytes.Equal(cert.RawSubjectPublicKeyInfo, spki(p.PubOID, p.PublicKey)) {
			t.Errorf("isCA=%v: SPKI differs", isCA)
		}
		if isCA && cert.AuthorityKeyId != nil {
			t.Error("self-signed certificate must not carry an AKI")
		}
	}
}

func TestExtensionBytesMatchOssl35(t *testing.T) {
	// Extension values taken from the asn1parse of the ossl35 TA and KEM EE.
	if got := basicConstraintsValue(true); !bytes.Equal(got, []byte{0x30, 0x03, 0x01, 0x01, 0xff}) {
		t.Errorf("CA:TRUE value %x", got)
	}
	if got := basicConstraintsValue(false); !bytes.Equal(got, []byte{0x30, 0x00}) {
		t.Errorf("CA:FALSE value %x", got)
	}
	ca := asn1.BitString{Bytes: []byte{0x06}, BitLength: 7}
	if got := bitString(ca); !bytes.Equal(got, []byte{0x03, 0x02, 0x01, 0x06}) {
		t.Errorf("keyCertSign|cRLSign %x", got)
	}
	ee := asn1.BitString{Bytes: []byte{0x20}, BitLength: 3}
	if got := bitString(ee); !bytes.Equal(got, []byte{0x03, 0x02, 0x05, 0x20}) {
		t.Errorf("keyEncipherment %x", got)
	}
	// Untrimmed input is canonicalised to the same minimal form.
	padded := asn1.BitString{Bytes: []byte{0x20, 0x00}, BitLength: 9}
	if got := bitString(padded); !bytes.Equal(got, []byte{0x03, 0x02, 0x05, 0x20}) {
		t.Errorf("padded keyEncipherment %x", got)
	}
	// AKI is SEQUENCE{[0] keyIdentifier}.
	aki := bytes.Repeat([]byte{0xcd}, 20)
	if got := akiValue(aki); !bytes.Equal(got[:4], []byte{0x30, 0x16, 0x80, 0x14}) {
		t.Errorf("AKI value %x", got)
	}
}

func TestExtensionOrderAndCriticality(t *testing.T) {
	for _, isCA := range []bool{true, false} {
		cert, err := x509.ParseCertificate(buildCert(t, testParams(t, isCA)))
		if err != nil {
			t.Fatal(err)
		}
		var ids []string
		crit := map[string]bool{}
		for _, e := range cert.Extensions {
			ids = append(ids, e.Id.String())
			crit[e.Id.String()] = e.Critical
		}
		want := []string{"2.5.29.19", "2.5.29.15", "2.5.29.14"}
		if !isCA {
			want = append(want, "2.5.29.35")
		}
		if len(ids) != len(want) {
			t.Fatalf("isCA=%v: extensions %v, want %v", isCA, ids, want)
		}
		for i := range want {
			if ids[i] != want[i] {
				t.Errorf("isCA=%v: extension %d is %s, want %s", isCA, i, ids[i], want[i])
			}
		}
		if !crit["2.5.29.19"] || !crit["2.5.29.15"] || crit["2.5.29.14"] || crit["2.5.29.35"] {
			t.Errorf("isCA=%v: criticality %v", isCA, crit)
		}
	}
}

func TestTimeEncodingBoundaryAt2050(t *testing.T) {
	cases := []struct {
		when time.Time
		want []byte
	}{
		{time.Date(2049, 12, 31, 23, 59, 59, 0, time.UTC), append([]byte{0x17, 0x0d}, "491231235959Z"...)},
		{time.Date(2050, 1, 1, 0, 0, 0, 0, time.UTC), append([]byte{0x18, 0x0f}, "20500101000000Z"...)},
		{time.Date(1999, 6, 1, 8, 0, 0, 0, time.UTC), append([]byte{0x17, 0x0d}, "990601080000Z"...)},
	}
	for _, c := range cases {
		got, err := encodeTime(c.when)
		if err != nil || !bytes.Equal(got, c.want) {
			t.Errorf("%v: got %x (%v), want %x", c.when, got, err, c.want)
		}
	}
	// Non-UTC input is converted to UTC.
	loc := time.FixedZone("x", 3600)
	got, _ := encodeTime(time.Date(2030, 1, 1, 1, 0, 0, 0, loc))
	if string(got[2:]) != "300101000000Z" {
		t.Errorf("zone conversion: %q", got[2:])
	}
	if _, err := encodeTime(time.Date(1949, 1, 1, 0, 0, 0, 0, time.UTC)); err == nil {
		t.Error("year 1949 accepted")
	}

	// End to end: a TA valid across 2050 has UTCTime NotBefore, GeneralizedTime NotAfter.
	p := testParams(t, true)
	cert, err := x509.ParseCertificate(buildCert(t, p))
	if err != nil {
		t.Fatal(err)
	}
	if cert.NotAfter.Year() != 2126 {
		t.Errorf("NotAfter %v", cert.NotAfter)
	}
	if !bytes.Contains(cert.RawTBSCertificate, append([]byte{0x17, 0x0d}, "261109120000Z"...)) ||
		!bytes.Contains(cert.RawTBSCertificate, append([]byte{0x18, 0x0f}, "21261109120000Z"...)) {
		t.Error("validity not UTCTime + GeneralizedTime")
	}
}

func TestSerialMustBePositiveAndHighBitGetsPadding(t *testing.T) {
	p := testParams(t, true)
	for _, bad := range []*big.Int{nil, big.NewInt(0), big.NewInt(-5)} {
		p.Serial = bad
		if _, err := TBS(p); err == nil {
			t.Errorf("serial %v accepted", bad)
		}
	}
	p.Serial = new(big.Int).SetBytes(append([]byte{0x80}, bytes.Repeat([]byte{1}, 15)...))
	cert, err := x509.ParseCertificate(buildCert(t, p))
	if err != nil {
		t.Fatal(err)
	}
	if cert.SerialNumber.Cmp(p.Serial) != 0 || cert.SerialNumber.Sign() <= 0 {
		t.Errorf("serial %v", cert.SerialNumber)
	}
}

func TestTBSRejectsMissingFields(t *testing.T) {
	mut := map[string]func(*CertParams){
		"no subject CN": func(p *CertParams) { p.Subject.CN = "" },
		"no issuer CN":  func(p *CertParams) { p.Issuer.CN = "" },
		"no public key": func(p *CertParams) { p.PublicKey = nil },
		"no sig OID":    func(p *CertParams) { p.SigOID = nil },
		"no pub OID":    func(p *CertParams) { p.PubOID = nil },
	}
	for name, f := range mut {
		p := testParams(t, true)
		f(&p)
		if _, err := TBS(p); err == nil {
			t.Errorf("%s: accepted", name)
		}
	}
	if _, err := Certificate([]byte{0x31, 0}, mustOID(t, alg.MLDSA44.OID), []byte{1}); err == nil {
		t.Error("non-SEQUENCE TBS accepted")
	}
}
