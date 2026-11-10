// Package gen builds the okwuosa artifacts: CIRCL does the ML-DSA math and the
// der package lays out every certificate and key file by hand.
package gen

import (
	"crypto/sha1"
	"encoding/asn1"
	"fmt"
	"io"
	"math/big"
	"os"
	"path/filepath"
	"strconv"
	"strings"
	"time"

	"github.com/cloudflare/circl/sign/mldsa/mldsa44"
	"github.com/cloudflare/circl/sign/mldsa/mldsa65"
	"github.com/cloudflare/circl/sign/mldsa/mldsa87"

	"pqccerts/okwuosa/internal/alg"
	"pqccerts/okwuosa/internal/der"
)

const (
	org          = "okwuosa"
	validityDays = 36524
	serialLen    = 16
	seedLen      = 32
)

// keyUsage is keyCertSign (bit 5) and cRLSign (bit 6).
var keyUsage = asn1.BitString{Bytes: []byte{0x06}, BitLength: 7}

// TA is a generated trust anchor. Sign signs with its private key (pure
// ML-DSA, empty context, randomized).
type TA struct {
	Alg  alg.Alg
	Cert []byte
	SKI  []byte
	Sign func(msg []byte) ([]byte, error)
}

// scheme adapts one CIRCL parameter set: from a 32-byte seed it returns the
// packed public key, the packed (FIPS 204) private key and a signing function.
type scheme struct {
	fromSeed func(seed []byte) (pub, sk []byte, sign func(msg []byte) ([]byte, error))
}

// schemes is keyed by alg.Alg.Level. The three CIRCL packages have the same
// shape but distinct types, so each needs its own short adapter.
var schemes = map[int]scheme{
	44: {func(seed []byte) ([]byte, []byte, func([]byte) ([]byte, error)) {
		pk, sk := mldsa44.NewKeyFromSeed((*[mldsa44.SeedSize]byte)(seed))
		return pk.Bytes(), sk.Bytes(), func(m []byte) ([]byte, error) {
			sig := make([]byte, mldsa44.SignatureSize)
			return sig, mldsa44.SignTo(sk, m, nil, true, sig)
		}
	}},
	65: {func(seed []byte) ([]byte, []byte, func([]byte) ([]byte, error)) {
		pk, sk := mldsa65.NewKeyFromSeed((*[mldsa65.SeedSize]byte)(seed))
		return pk.Bytes(), sk.Bytes(), func(m []byte) ([]byte, error) {
			sig := make([]byte, mldsa65.SignatureSize)
			return sig, mldsa65.SignTo(sk, m, nil, true, sig)
		}
	}},
	87: {func(seed []byte) ([]byte, []byte, func([]byte) ([]byte, error)) {
		pk, sk := mldsa87.NewKeyFromSeed((*[mldsa87.SeedSize]byte)(seed))
		return pk.Bytes(), sk.Bytes(), func(m []byte) ([]byte, error) {
			sig := make([]byte, mldsa87.SignatureSize)
			return sig, mldsa87.SignTo(sk, m, nil, true, sig)
		}
	}},
}

// serial returns a random positive 16-byte serial number with the top bit cleared.
func serial(rand io.Reader) (*big.Int, error) {
	b := make([]byte, serialLen)
	if _, err := io.ReadFull(rand, b); err != nil {
		return nil, err
	}
	b[0] &= 0x7f
	n := new(big.Int).SetBytes(b)
	if n.Sign() == 0 {
		n.SetInt64(1)
	}
	return n, nil
}

func parseOID(s string) (asn1.ObjectIdentifier, error) {
	var oid asn1.ObjectIdentifier
	for _, part := range strings.Split(s, ".") {
		n, err := strconv.Atoi(part)
		if err != nil {
			return nil, fmt.Errorf("bad OID %q: %w", s, err)
		}
		oid = append(oid, n)
	}
	return oid, nil
}

// GenerateMLDSA writes the self-signed trust anchor and the seed, expanded and
// both PKCS#8 private keys for a into dir. The seed and serial come from rand
// and the times from now. CIRCL's SignTo takes only a "randomized" bool and
// reads crypto/rand itself, so the TA signature bytes are not reproducible
// from rand (they verify, but differ between runs).
func GenerateMLDSA(dir string, a alg.Alg, rand io.Reader, now time.Time) (*TA, error) {
	sc, ok := schemes[a.Level]
	if !ok || a.IsKEM {
		return nil, fmt.Errorf("%s is not an ML-DSA algorithm", a.Friendly)
	}
	oid, err := parseOID(a.OID)
	if err != nil {
		return nil, err
	}
	seed := make([]byte, seedLen)
	if _, err := io.ReadFull(rand, seed); err != nil {
		return nil, fmt.Errorf("reading seed: %w", err)
	}
	sn, err := serial(rand)
	if err != nil {
		return nil, fmt.Errorf("serial: %w", err)
	}
	pub, sk, sign := sc.fromSeed(seed)
	ski := sha1.Sum(pub)
	name := der.Name{CN: a.Friendly + " TA", O: org}
	tbs, err := der.TBS(der.CertParams{
		Serial: sn, Issuer: name, Subject: name,
		NotBefore: now, NotAfter: now.Add(validityDays * 24 * time.Hour),
		SigOID: oid, PubOID: oid, PublicKey: pub,
		IsCA: true, KeyUsage: keyUsage, SKI: ski[:],
	})
	if err != nil {
		return nil, fmt.Errorf("%s TA: %w", a.Friendly, err)
	}
	sig, err := sign(tbs)
	if err != nil {
		return nil, fmt.Errorf("%s TA signature: %w", a.Friendly, err)
	}
	cert, err := der.Certificate(tbs, oid, sig)
	if err != nil {
		return nil, fmt.Errorf("%s TA: %w", a.Friendly, err)
	}
	files := map[string][]byte{
		"_ta.der":               cert,
		"_seed_priv.der":        der.PKCS8Seed(oid, seed),
		"_expandedkey_priv.der": der.PKCS8Expanded(oid, sk),
		"_both_priv.der":        der.PKCS8Both(oid, seed, sk),
	}
	for suffix, data := range files {
		if err := os.WriteFile(filepath.Join(dir, a.FileName(suffix)), data, 0o644); err != nil {
			return nil, err
		}
	}
	return &TA{Alg: a, Cert: cert, SKI: ski[:], Sign: sign}, nil
}
