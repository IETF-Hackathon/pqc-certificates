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

// Suffixes recognised in artifact names. _ta.pem and _ee.pem are recognised
// only so callers can skip them.
var suffixes = []string{
	"_ta.der", "_seed_priv.der", "_expandedkey_priv.der", "_both_priv.der",
	"_ee.der", "_ciphertext.bin", "_ss.bin", "_ta.pem", "_ee.pem",
}

// All returns the six algorithms in table order.
func All() []Alg {
	return []Alg{MLDSA44, MLDSA65, MLDSA87, MLKEM512, MLKEM768, MLKEM1024}
}

// ByOID looks an algorithm up by dotted OID.
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
