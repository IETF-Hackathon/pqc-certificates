package check

import (
	"crypto/mldsa"
	"crypto/rand"
	"crypto/x509"
	"errors"
	"fmt"
	"strings"
	"time"

	"pqccerts/gocrypto/internal/alg"
)

const testMessage = "This is a test of signature data\n"

var keyTypes = []struct{ typ, suffix string }{
	{"seed", "_seed_priv.der"},
	{"expandedkey", "_expandedkey_priv.der"},
	{"both", "_both_priv.der"},
}

// hybridPrefixes mark hybrid certificates, which the CI skips by name.
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
// Hybrid-prefixed files are skipped, as the CI skips them; of several
// remaining candidates the first by name is used, so the result is stable.
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

// taState is the trust anchor as far as it could be read.
type taState struct {
	name    string
	present bool
	cert    *x509.Certificate // nil when absent or unparseable
}

// CheckMLDSA runs the CI-equivalent checks for one ML-DSA algorithm over the
// files that are present. A check Go cannot run produces a Finding, no Row.
func CheckMLDSA(files map[string][]byte, a alg.Alg) ([]Row, []Finding) {
	ta := loadTA(files, a)
	rows, fs, parsed := checkKeys(files, a, ta)
	if ta.present {
		rows = append(rows, Row{a.OID, "cert", selfSigned(ta.cert)})
		if ta.cert != nil {
			fs = append(fs, strictFindings(ta)...)
		}
	}
	if parsed != nil && ta.present {
		rows = append(rows, Row{a.OID, "consistent", ta.cert != nil && parsed.PublicKey().Equal(ta.cert.PublicKey)})
	}
	return rows, fs
}

func loadTA(files map[string][]byte, a alg.Alg) taState {
	name, data, ok := find(files, a, "_ta.der")
	if !ok {
		return taState{}
	}
	cert, err := x509.ParseCertificate(data)
	if err != nil {
		return taState{name: name, present: true}
	}
	return taState{name: name, present: true, cert: cert}
}

// checkKeys handles seed, expandedkey and both. It also returns the first key
// that parsed, for the consistency check.
func checkKeys(files map[string][]byte, a alg.Alg, ta taState) ([]Row, []Finding, *mldsa.PrivateKey) {
	var rows []Row
	var fs []Finding
	var first *mldsa.PrivateKey
	for _, kt := range keyTypes {
		name, data, ok := find(files, a, kt.suffix)
		if !ok {
			continue
		}
		key, err := parseKey(data)
		switch {
		case err != nil && strings.Contains(err.Error(), "not supported"):
			fs = append(fs, Finding{File: name, Check: "cannot-run", Detail: err.Error()})
			continue
		case err != nil:
			rows = append(rows, Row{a.OID, kt.typ, false})
			continue
		case !ta.present:
			fs = append(fs, Finding{File: name, Check: "cannot-run", Detail: "no TA was present to verify the signature against"})
		default:
			rows = append(rows, Row{a.OID, kt.typ, signVerifies(key, ta.cert)})
		}
		if first == nil {
			first = key
		}
	}
	return rows, fs, first
}

func parseKey(der []byte) (*mldsa.PrivateKey, error) {
	k, err := x509.ParsePKCS8PrivateKey(der)
	if err != nil {
		return nil, err
	}
	key, ok := k.(*mldsa.PrivateKey)
	if !ok {
		return nil, fmt.Errorf("PKCS#8 key is %T, not ML-DSA", k)
	}
	return key, nil
}

// signVerifies signs a test message with key and verifies it with the public
// key of the TA. An unreadable TA fails the check.
func signVerifies(key *mldsa.PrivateKey, ta *x509.Certificate) bool {
	if ta == nil {
		return false
	}
	pub, ok := ta.PublicKey.(*mldsa.PublicKey)
	if !ok {
		return false
	}
	opts := &mldsa.Options{}
	sig, err := key.Sign(rand.Reader, []byte(testMessage), opts)
	if err != nil {
		return false
	}
	return mldsa.Verify(pub, []byte(testMessage), sig, opts) == nil
}

// strictFindings are the checks that never produce a row: a full chain verify
// at NotBefore+1h and the CA / keyCertSign flags.
func strictFindings(ta taState) []Finding {
	c := ta.cert
	var errs []error
	if !c.IsCA {
		errs = append(errs, errors.New("IsCA is false"))
	}
	if c.KeyUsage&x509.KeyUsageCertSign == 0 {
		errs = append(errs, errors.New("keyUsage lacks keyCertSign"))
	}
	pool := x509.NewCertPool()
	pool.AddCert(c)
	_, err := c.Verify(x509.VerifyOptions{
		Roots:       pool,
		CurrentTime: c.NotBefore.Add(time.Hour),
		KeyUsages:   []x509.ExtKeyUsage{x509.ExtKeyUsageAny},
	})
	if err != nil {
		errs = append(errs, fmt.Errorf("verify: %w", err))
	}
	var fs []Finding
	for _, e := range errs {
		fs = append(fs, Finding{File: ta.name, Check: "strict", Detail: e.Error()})
	}
	return fs
}

// selfSigned reports whether c's signature verifies under its own public key.
// Like `openssl verify -check_ss_sig`, it does not look at CA or key-usage
// flags; those are reported as strict findings instead.
func selfSigned(c *x509.Certificate) bool {
	return c != nil && c.CheckSignature(c.SignatureAlgorithm, c.RawTBSCertificate, c.Signature) == nil
}
