// Package gen builds the go-crypto artifacts using only the Go standard library.
package gen

import (
	"archive/zip"
	"crypto/mldsa"
	"crypto/x509"
	"crypto/x509/pkix"
	"fmt"
	"io"
	"math/big"
	"os"
	"path/filepath"
	"sort"
	"time"

	"pqccerts/gocrypto/internal/alg"
)

const (
	org          = "go-crypto"
	validityDays = 36524
	serialLen    = 16
	seedLen      = mldsa.PrivateKeySize
)

// zipEpoch is a valid, fixed DOS timestamp so the zip carries no zero date.
var zipEpoch = time.Date(1980, 1, 1, 0, 0, 0, 0, time.UTC)

func params(a alg.Alg) (mldsa.Parameters, error) {
	switch a.Level {
	case 44:
		return mldsa.MLDSA44(), nil
	case 65:
		return mldsa.MLDSA65(), nil
	case 87:
		return mldsa.MLDSA87(), nil
	}
	return mldsa.Parameters{}, fmt.Errorf("%s is not an ML-DSA algorithm", a.Friendly)
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

// GenerateMLDSA writes the self-signed trust anchor and the seed-form PKCS#8
// private key for a into dir. All randomness comes from rand and all times
// from now.
func GenerateMLDSA(dir string, a alg.Alg, rand io.Reader, now time.Time) error {
	p, err := params(a)
	if err != nil {
		return err
	}
	seed := make([]byte, seedLen)
	if _, err := io.ReadFull(rand, seed); err != nil {
		return fmt.Errorf("reading seed: %w", err)
	}
	key, err := mldsa.NewPrivateKey(p, seed)
	if err != nil {
		return fmt.Errorf("%s key: %w", a.Friendly, err)
	}
	sn, err := serial(rand)
	if err != nil {
		return fmt.Errorf("serial: %w", err)
	}
	tmpl := &x509.Certificate{
		SerialNumber:          sn,
		Subject:               pkix.Name{CommonName: a.Friendly + " TA", Organization: []string{org}},
		NotBefore:             now,
		NotAfter:              now.Add(validityDays * 24 * time.Hour),
		IsCA:                  true,
		BasicConstraintsValid: true,
		KeyUsage:              x509.KeyUsageCertSign | x509.KeyUsageCRLSign,
	}
	ta, err := x509.CreateCertificate(rand, tmpl, tmpl, key.PublicKey(), key)
	if err != nil {
		return fmt.Errorf("%s TA: %w", a.Friendly, err)
	}
	der, err := x509.MarshalPKCS8PrivateKey(key)
	if err != nil {
		return fmt.Errorf("%s PKCS#8: %w", a.Friendly, err)
	}
	if err := os.WriteFile(filepath.Join(dir, a.FileName("_ta.der")), ta, 0o644); err != nil {
		return err
	}
	return os.WriteFile(filepath.Join(dir, a.FileName("_seed_priv.der")), der, 0o600)
}

// WriteZip zips the regular files of srcDir into zipPath: flat, sorted by
// name, no directory entries. An existing zipPath is replaced.
func WriteZip(srcDir, zipPath string) error {
	entries, err := os.ReadDir(srcDir)
	if err != nil {
		return err
	}
	var names []string
	for _, e := range entries {
		if e.Type().IsRegular() {
			names = append(names, e.Name())
		}
	}
	sort.Strings(names)

	tmp, err := os.CreateTemp(filepath.Dir(zipPath), ".zip-*")
	if err != nil {
		return err
	}
	defer os.Remove(tmp.Name())
	zw := zip.NewWriter(tmp)
	for _, n := range names {
		data, err := os.ReadFile(filepath.Join(srcDir, n))
		if err != nil {
			tmp.Close()
			return err
		}
		w, err := zw.CreateHeader(&zip.FileHeader{Name: n, Method: zip.Deflate, Modified: zipEpoch})
		if err == nil {
			_, err = w.Write(data)
		}
		if err != nil {
			tmp.Close()
			return err
		}
	}
	if err := zw.Close(); err != nil {
		tmp.Close()
		return err
	}
	if err := tmp.Close(); err != nil {
		return err
	}
	if err := os.Chmod(tmp.Name(), 0o644); err != nil {
		return err
	}
	return os.Rename(tmp.Name(), zipPath)
}
