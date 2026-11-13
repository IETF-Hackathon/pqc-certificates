// Package alg is the ML-DSA / ML-KEM algorithm table and artifact naming.
package alg

import "strings"

// Alg describes one algorithm.
type Alg struct {
	Friendly string
	OID      string
	Level    int
	IsKEM    bool
}

var (
	MLDSA44   = Alg{"ml-dsa-44", "2.16.840.1.101.3.4.3.17", 44, false}
	MLDSA65   = Alg{"ml-dsa-65", "2.16.840.1.101.3.4.3.18", 65, false}
	MLDSA87   = Alg{"ml-dsa-87", "2.16.840.1.101.3.4.3.19", 87, false}
	MLKEM512  = Alg{"ml-kem-512", "2.16.840.1.101.3.4.4.1", 512, true}
	MLKEM768  = Alg{"ml-kem-768", "2.16.840.1.101.3.4.4.2", 768, true}
	MLKEM1024 = Alg{"ml-kem-1024", "2.16.840.1.101.3.4.4.3", 1024, true}
)

// FrodoKEM (ISO/IEC 18033-2 OIDs). The checker verifies the four eFrodoKEM
// parameter sets only; nothing is generated for them. Level is the matrix
// dimension n.
var (
	EFrodoKEM976SHAKE  = Alg{"efrodokem976-shake", "1.0.18033.2.2.7.3", 976, true}
	EFrodoKEM1344SHAKE = Alg{"efrodokem1344-shake", "1.0.18033.2.2.7.4", 1344, true}
	EFrodoKEM976AES    = Alg{"efrodokem976-aes", "1.0.18033.2.2.7.7", 976, true}
	EFrodoKEM1344AES   = Alg{"efrodokem1344-aes", "1.0.18033.2.2.7.8", 1344, true}

	FrodoKEM976SHAKE  = Alg{"frodokem976-shake", "1.0.18033.2.2.7.1", 976, true}
	FrodoKEM1344SHAKE = Alg{"frodokem1344-shake", "1.0.18033.2.2.7.2", 1344, true}
	FrodoKEM976AES    = Alg{"frodokem976-aes", "1.0.18033.2.2.7.5", 976, true}
	FrodoKEM1344AES   = Alg{"frodokem1344-aes", "1.0.18033.2.2.7.6", 1344, true}
)

// Suffixes recognised in artifact names. _ta.pem and _ee.pem are recognised
// only so callers can skip them.
var suffixes = []string{
	"_ta.der", "_seed_priv.der", "_expandedkey_priv.der", "_both_priv.der",
	"_ee.der", "_ciphertext.bin", "_ss.bin", "_ta.pem", "_ee.pem",
	// Last, so that the three more specific private key suffixes match first.
	"_priv.der",
}

// All returns the six algorithms in table order.
func All() []Alg {
	return []Alg{MLDSA44, MLDSA65, MLDSA87, MLKEM512, MLKEM768, MLKEM1024}
}

// EFrodoKEM returns the four eFrodoKEM parameter sets the checker verifies.
func EFrodoKEM() []Alg {
	return []Alg{EFrodoKEM976SHAKE, EFrodoKEM1344SHAKE, EFrodoKEM976AES, EFrodoKEM1344AES}
}

// SaltedFrodoKEM returns the four salted FrodoKEM parameter sets. They are
// recognised so that their presence can be reported; they are not checked.
func SaltedFrodoKEM() []Alg {
	return []Alg{FrodoKEM976SHAKE, FrodoKEM1344SHAKE, FrodoKEM976AES, FrodoKEM1344AES}
}

// IsEFrodoKEM reports whether a is one of the eFrodoKEM parameter sets.
func IsEFrodoKEM(a Alg) bool {
	return contains(EFrodoKEM(), a.OID)
}

// Reads reports whether the checker uses the file with this OID and suffix,
// so that nothing else is read from a zip. For ML-DSA and ML-KEM that is
// every recognised suffix except the generic _priv.der; for eFrodoKEM the four
// files of a set; for salted FrodoKEM only the two files whose presence is
// reported.
func Reads(oid, suffix string) bool {
	switch {
	case contains(All(), oid):
		return suffix != "_priv.der"
	case contains(EFrodoKEM(), oid):
		return suffix == "_priv.der" || suffix == "_ee.der" || suffix == "_ciphertext.bin" || suffix == "_ss.bin"
	case contains(SaltedFrodoKEM(), oid):
		return suffix == "_priv.der" || suffix == "_ee.der"
	}
	return false
}

func contains(algs []Alg, oid string) bool {
	for _, a := range algs {
		if a.OID == oid {
			return true
		}
	}
	return false
}

// ByOID looks one of the six ML-DSA / ML-KEM algorithms up by dotted OID.
func ByOID(oid string) (Alg, bool) {
	for _, a := range All() {
		if a.OID == oid {
			return a, true
		}
	}
	return Alg{}, false
}

// FileName returns "<friendly>-<oid><suffix>".
func (a Alg) FileName(suffix string) string {
	return a.Friendly + "-" + a.OID + suffix
}

// ParseFileName extracts the OID (last '-' field of the base name before the
// suffix) and the lower-case suffix. Any directory prefix is ignored.
func ParseFileName(name string) (oid, suffix string, ok bool) {
	if i := strings.LastIndexAny(name, `/\`); i >= 0 {
		name = name[i+1:]
	}
	lower := strings.ToLower(name)
	for _, s := range suffixes {
		if !strings.HasSuffix(lower, s) {
			continue
		}
		stem := name[:len(name)-len(s)]
		j := strings.LastIndex(stem, "-")
		if j < 0 || j == len(stem)-1 {
			return "", "", false
		}
		return stem[j+1:], s, true
	}
	return "", "", false
}

// IssuerFor returns the ML-DSA algorithm at the same level as a KEM.
func IssuerFor(kem Alg) Alg {
	switch kem.Level {
	case 512:
		return MLDSA44
	case 768:
		return MLDSA65
	default:
		return MLDSA87
	}
}
