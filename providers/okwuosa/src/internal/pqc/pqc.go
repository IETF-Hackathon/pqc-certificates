// Package pqc maps an algorithm's parameter-set level to its CIRCL scheme.
// The three ML-DSA packages and the three ML-KEM packages have the same shape
// but distinct types, so CIRCL's generic sign.Scheme and kem.Scheme interfaces
// are used for everything that does not need a package-specific call.
package pqc

import (
	"github.com/cloudflare/circl/kem"
	"github.com/cloudflare/circl/kem/mlkem/mlkem1024"
	"github.com/cloudflare/circl/kem/mlkem/mlkem512"
	"github.com/cloudflare/circl/kem/mlkem/mlkem768"
	"github.com/cloudflare/circl/sign"
	"github.com/cloudflare/circl/sign/mldsa/mldsa44"
	"github.com/cloudflare/circl/sign/mldsa/mldsa65"
	"github.com/cloudflare/circl/sign/mldsa/mldsa87"
)

// DSAScheme returns the ML-DSA scheme for level 44, 65 or 87.
func DSAScheme(level int) (sign.Scheme, bool) {
	switch level {
	case 44:
		return mldsa44.Scheme(), true
	case 65:
		return mldsa65.Scheme(), true
	case 87:
		return mldsa87.Scheme(), true
	}
	return nil, false
}

// KEMScheme returns the ML-KEM scheme for level 512, 768 or 1024. Its
// DeriveKeyPair takes the 64-byte seed d||z (FIPS 203 KeyGen_internal) and
// its MarshalBinary gives the FIPS 203 encapsulation and decapsulation keys.
func KEMScheme(level int) (kem.Scheme, bool) {
	switch level {
	case 512:
		return mlkem512.Scheme(), true
	case 768:
		return mlkem768.Scheme(), true
	case 1024:
		return mlkem1024.Scheme(), true
	}
	return nil, false
}
