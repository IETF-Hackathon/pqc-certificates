package check

import (
	"strings"

	"pqccerts/okwuosa/internal/alg"
)

// hybridPrefixes mark hybrid certificates. The CI skips them for TAs; its skip
// for KEM EE files tests the name after the friendly prefix is stripped, so it
// does not take effect there. Both are left out here.
var hybridPrefixes = []string{"external_", "catalyst_", "chameleon_"}

func isHybrid(name string) bool {
	for _, p := range hybridPrefixes {
		if strings.HasPrefix(name, p) {
			return true
		}
	}
	return false
}

// find returns the name and bytes of the artifact for a with the given suffix.
// Hybrid-prefixed files are skipped; of several remaining candidates the first
// by name is used, so the result is stable.
func find(files map[string][]byte, a alg.Alg, suffix string) (string, []byte, bool) {
	best := ""
	for name := range files {
		oid, s, ok := alg.ParseFileName(name)
		if ok && oid == a.OID && s == suffix && !isHybrid(name) && (best == "" || name < best) {
			best = name
		}
	}
	if best == "" {
		return "", nil, false
	}
	return best, files[best], true
}

// keyTypes are the private key forms, in row order.
var keyTypes = []struct{ typ, suffix string }{
	{"seed", "_seed_priv.der"},
	{"expandedkey", "_expandedkey_priv.der"},
	{"both", "_both_priv.der"},
}

// testMessage is what the CI signs (`echo` adds the newline).
const testMessage = "This is a test of signature data\n"
