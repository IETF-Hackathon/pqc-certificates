package gen

import (
	"crypto/sha1"
	"encoding/asn1"
	"fmt"
	"io"
	"os"
	"path/filepath"
	"time"

	"github.com/cloudflare/circl/kem"

	"pqccerts/okwuosa/internal/alg"
	"pqccerts/okwuosa/internal/der"
	"pqccerts/okwuosa/internal/pqc"
)

// eeKeyUsage is keyEncipherment (bit 2).
var eeKeyUsage = asn1.BitString{Bytes: []byte{0x20}, BitLength: 3}

// The generic kem.Scheme (pqc.KEMScheme) gives the same calls for all three
// parameter sets:
//   - DeriveKeyPair takes the 64-byte seed d||z (FIPS 203 KeyGen_internal)
//     and returns keys whose MarshalBinary is the FIPS 203 encapsulation key
//     and decapsulation key (800/1184/1568 and 1632/2400/3168 bytes);
//   - EncapsulateDeterministically takes the 32-byte randomness m.

// GenerateMLKEM writes the end-entity certificate (signed by issuer, the trust
// anchor of the matching ML-DSA level), the seed, expanded and both PKCS#8
// private keys, and a ciphertext with its shared secret for a into dir. The
// key seed, serial and encapsulation randomness come from rand and the times
// from now. The certificate signature comes from issuer.Sign, which CIRCL
// randomizes internally, so it is not reproducible from rand.
func GenerateMLKEM(dir string, a alg.Alg, issuer *TA, rand io.Reader, now time.Time) error {
	sc, ok := pqc.KEMScheme(a.Level)
	if !ok || !a.IsKEM {
		return fmt.Errorf("%s is not an ML-KEM algorithm", a.Friendly)
	}
	if issuer == nil || issuer.Alg != alg.IssuerFor(a) {
		return fmt.Errorf("%s needs a %s trust anchor", a.Friendly, alg.IssuerFor(a).Friendly)
	}
	oid, err := parseOID(a.OID)
	if err != nil {
		return err
	}
	seed := make([]byte, sc.SeedSize())
	if _, err := io.ReadFull(rand, seed); err != nil {
		return fmt.Errorf("reading seed: %w", err)
	}
	pk, sk := sc.DeriveKeyPair(seed)
	pub, dk, err := marshalKeys(pk, sk)
	if err != nil {
		return fmt.Errorf("%s: %w", a.Friendly, err)
	}
	ct, ss, err := encapsulate(sc, pk, rand)
	if err != nil {
		return fmt.Errorf("%s: %w", a.Friendly, err)
	}
	cert, err := eeCertificate(a, issuer, oid, pub, rand, now)
	if err != nil {
		return err
	}
	return writeFiles(dir, a, map[string][]byte{
		"_ee.der":               cert,
		"_seed_priv.der":        der.PKCS8Seed(oid, seed),
		"_expandedkey_priv.der": der.PKCS8Expanded(oid, dk),
		"_both_priv.der":        der.PKCS8Both(oid, seed, dk),
		"_ciphertext.bin":       ct,
		"_ss.bin":               ss,
	})
}

func marshalKeys(pk kem.PublicKey, sk kem.PrivateKey) (pub, dk []byte, err error) {
	if pub, err = pk.MarshalBinary(); err != nil {
		return nil, nil, err
	}
	if dk, err = sk.MarshalBinary(); err != nil {
		return nil, nil, err
	}
	return pub, dk, nil
}

// encapsulate reads the 32-byte encapsulation randomness from rand.
func encapsulate(sc kem.Scheme, pk kem.PublicKey, rand io.Reader) (ct, ss []byte, err error) {
	m := make([]byte, sc.EncapsulationSeedSize())
	if _, err := io.ReadFull(rand, m); err != nil {
		return nil, nil, fmt.Errorf("reading encapsulation randomness: %w", err)
	}
	return sc.EncapsulateDeterministically(pk, m)
}

// eeCertificate builds the end-entity certificate for pub and signs its TBS
// with the issuer; validity equals the trust anchor's (same now).
func eeCertificate(a alg.Alg, issuer *TA, oid asn1.ObjectIdentifier, pub []byte, rand io.Reader, now time.Time) ([]byte, error) {
	sigOID, err := parseOID(issuer.Alg.OID)
	if err != nil {
		return nil, err
	}
	sn, err := serial(rand)
	if err != nil {
		return nil, fmt.Errorf("serial: %w", err)
	}
	ski := sha1.Sum(pub)
	tbs, err := der.TBS(der.CertParams{
		Serial:    sn,
		Issuer:    der.Name{CN: issuer.Alg.Friendly + " TA", O: org},
		Subject:   der.Name{CN: a.Friendly + " EE", O: org},
		NotBefore: now, NotAfter: now.Add(validityDays * 24 * time.Hour),
		SigOID: sigOID, PubOID: oid, PublicKey: pub,
		KeyUsage: eeKeyUsage, SKI: ski[:], AKI: issuer.SKI,
	})
	if err != nil {
		return nil, fmt.Errorf("%s EE: %w", a.Friendly, err)
	}
	sig, err := issuer.Sign(tbs)
	if err != nil {
		return nil, fmt.Errorf("%s EE signature: %w", a.Friendly, err)
	}
	cert, err := der.Certificate(tbs, sigOID, sig)
	if err != nil {
		return nil, fmt.Errorf("%s EE: %w", a.Friendly, err)
	}
	return cert, nil
}

func writeFiles(dir string, a alg.Alg, files map[string][]byte) error {
	for suffix, data := range files {
		if err := os.WriteFile(filepath.Join(dir, a.FileName(suffix)), data, 0o644); err != nil {
			return err
		}
	}
	return nil
}
