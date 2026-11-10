package der

import (
	"bytes"
	"encoding/asn1"
	"math/rand"
	"testing"
)

func TestParseCertificateFields(t *testing.T) {
	for _, isCA := range []bool{true, false} {
		p := testParams(t, isCA)
		tbs, err := TBS(p)
		if err != nil {
			t.Fatal(err)
		}
		c, err := ParseCertificate(buildCert(t, p))
		if err != nil {
			t.Fatalf("isCA=%v: %v", isCA, err)
		}
		if !bytes.Equal(c.TBS, tbs) {
			t.Errorf("isCA=%v: TBS bytes differ from the encoded TBS", isCA)
		}
		if !asn1.ObjectIdentifier(c.SigAlg.OID).Equal(p.SigOID) || c.SigAlg.HasParams ||
			!asn1.ObjectIdentifier(c.TBSSigAlg.OID).Equal(p.SigOID) {
			t.Errorf("isCA=%v: signature algorithm %+v / %+v", isCA, c.SigAlg, c.TBSSigAlg)
		}
		if !asn1.ObjectIdentifier(c.PubAlg.OID).Equal(p.PubOID) || c.PubAlg.HasParams {
			t.Errorf("isCA=%v: public key algorithm %+v", isCA, c.PubAlg)
		}
		if !bytes.Equal(c.PublicKey, p.PublicKey) {
			t.Errorf("isCA=%v: public key bytes differ", isCA)
		}
		if !bytes.Equal(c.Signature, bytes.Repeat([]byte{9}, 2420)) {
			t.Errorf("isCA=%v: signature bytes differ", isCA)
		}
		if same := bytes.Equal(c.Issuer, c.Subject); same != isCA {
			t.Errorf("isCA=%v: issuer==subject is %v", isCA, same)
		}
		if c.TrailingBytes != 0 {
			t.Errorf("isCA=%v: trailing %d", isCA, c.TrailingBytes)
		}
	}
}

// v1Cert is a certificate without the [0] version and without extensions.
func v1Cert(t *testing.T, mutateLen bool) []byte {
	t.Helper()
	p := testParams(t, true)
	id, _ := algID(p.SigOID)
	name, _ := encodeName(p.Subject)
	val, _ := encodeValidity(p.NotBefore, p.NotAfter)
	tbs := tlv(tagSequence, encodeSerial(p.Serial), id, name, val, name, spki(p.PubOID, p.PublicKey))
	bits := appendTLV(nil, tagBitString, append([]byte{0}, bytes.Repeat([]byte{9}, 100)...))
	body := append(append(append([]byte{}, tbs...), id...), bits...)
	if mutateLen { // 30 82 xx xx where DER would use the same width; use 83 00 xx xx to be non-minimal
		return append([]byte{tagSequence, 0x83, 0, byte(len(body) >> 8), byte(len(body))}, body...)
	}
	return appendTLV(nil, tagSequence, body)
}

func TestParseCertificateToleratesV1AndBERLengths(t *testing.T) {
	for _, lax := range []bool{false, true} {
		c, err := ParseCertificate(v1Cert(t, lax))
		if err != nil {
			t.Fatalf("lax=%v: %v", lax, err)
		}
		if len(c.PublicKey) != 1312 || len(c.Signature) != 100 {
			t.Errorf("lax=%v: key %d sig %d", lax, len(c.PublicKey), len(c.Signature))
		}
	}
}

func TestParseCertificateReportsParamsAndTrailing(t *testing.T) {
	good := buildCert(t, testParams(t, true))
	c, err := ParseCertificate(append(append([]byte{}, good...), 0, 0, 0))
	if err != nil || c.TrailingBytes != 3 {
		t.Fatalf("trailing: %v %+v", err, c)
	}
	// Add NULL parameters to the outer signature AlgorithmIdentifier.
	p := testParams(t, true)
	tbs, _ := TBS(p)
	o, _ := oidDER(p.SigOID)
	idNull := tlv(tagSequence, o, []byte{0x05, 0x00})
	bits := appendTLV(nil, tagBitString, []byte{0, 1, 2, 3})
	c, err = ParseCertificate(tlv(tagSequence, tbs, idNull, bits))
	if err != nil || !c.SigAlg.HasParams || c.TBSSigAlg.HasParams {
		t.Fatalf("params: %v %+v", err, c)
	}
}

func TestParseCertificateRejectsBytesInsideSequenceAfterSignature(t *testing.T) {
	p := testParams(t, true)
	tbs, _ := TBS(p)
	id, _ := algID(p.SigOID)
	bits := appendTLV(nil, tagBitString, []byte{0, 1, 2, 3})
	if _, err := ParseCertificate(tlv(tagSequence, tbs, id, bits)); err != nil {
		t.Fatalf("control without extra byte: %v", err)
	}
	if _, err := ParseCertificate(tlv(tagSequence, tbs, id, bits, []byte{0x00})); err == nil {
		t.Error("a byte after signatureValue inside the Certificate SEQUENCE was accepted")
	}
}

func TestParseCertificateRejectsBadInput(t *testing.T) {
	good := buildCert(t, testParams(t, true))
	badBits := func() []byte { // signature BIT STRING with 3 unused bits
		b := append([]byte{}, good...)
		i := bytes.LastIndex(b, []byte{tagBitString, 0x82})
		b[i+4] = 3
		return b
	}()
	cases := map[string][]byte{
		"empty":       nil,
		"not a seq":   {0x04, 0x01, 0x00},
		"short":       {0x30, 0x05, 0x01},
		"unused bits": badBits,
		"indefinite":  {0x30, 0x80, 0x00, 0x00},
	}
	for n := 0; n < len(good); n++ {
		cases["truncated"+string(rune('a'+n%26))+string(rune(n))] = good[:n]
	}
	for name, data := range cases {
		if _, err := ParseCertificate(data); err == nil {
			t.Errorf("%q accepted", name)
		}
	}
}

func TestParseCertificateNeverPanicsOnMutations(t *testing.T) {
	good := buildCert(t, testParams(t, false))
	rng := rand.New(rand.NewSource(1))
	for i := 0; i < 5000; i++ {
		b := append([]byte{}, good...)
		for j := 0; j < 1+rng.Intn(4); j++ {
			b[rng.Intn(len(b))] = byte(rng.Intn(256))
		}
		_, _ = ParseCertificate(b[:len(b)-rng.Intn(3)])
	}
}

// corey-digicert ships version 1 keys with the public key attached.
func TestParsePrivateKeyAcceptsVersion1WithPublicKey(t *testing.T) {
	oid := mustOID(t, "2.16.840.1.101.3.4.3.17")
	seed := bytes.Repeat([]byte{3}, 32)
	v0 := PKCS8Seed(oid, seed)
	pub := bytes.Repeat([]byte{5}, 1312)
	body := append([]byte{}, v0[len(v0)-(2+2+32):]...) // privateKey OCTET STRING: 04 22 80 20 seed
	id, _ := algID(oid)
	v1 := tlv(tagSequence, []byte{tagInteger, 1, 1}, id, body, appendTLV(nil, tagCtx1Impl, append([]byte{0}, pub...)))
	k, err := ParsePrivateKey(v1)
	if err != nil {
		t.Fatal(err)
	}
	if k.Version != 1 || !bytes.Equal(k.Seed, seed) || k.Expanded != nil || !bytes.Equal(k.PublicKey, pub) || k.HasAttributes {
		t.Errorf("parsed %+v", k)
	}
	if _, _, _, err := ParsePKCS8(v1); err == nil {
		t.Error("the strict generator-side parser must keep rejecting version 1")
	}
	k, err = ParsePrivateKey(v0)
	if err != nil || k.Version != 0 || k.PublicKey != nil {
		t.Errorf("v0: %v %+v", err, k)
	}
}

func TestParsePrivateKeyRejectsAndNeverPanics(t *testing.T) {
	oid := mustOID(t, "2.16.840.1.101.3.4.3.17")
	good := PKCS8Both(oid, bytes.Repeat([]byte{3}, 32), bytes.Repeat([]byte{4}, 2560))
	for n := 0; n < len(good); n++ {
		if _, err := ParsePrivateKey(good[:n]); err == nil {
			t.Fatalf("truncation to %d accepted", n)
		}
	}
	if _, err := ParsePrivateKey(append(bytes.Clone(good), 0)); err == nil {
		t.Error("trailing byte accepted")
	}
	rng := rand.New(rand.NewSource(2))
	for i := 0; i < 3000; i++ {
		b := bytes.Clone(good)
		b[rng.Intn(len(b))] = byte(rng.Intn(256))
		_, _ = ParsePrivateKey(b)
	}
}
