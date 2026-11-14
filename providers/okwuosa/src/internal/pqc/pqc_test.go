package pqc

import (
	"testing"

	"pqccerts/okwuosa/internal/alg"
)

func TestSchemesMatchAlgTable(t *testing.T) {
	for _, a := range alg.All() {
		var name string
		if a.IsKEM {
			s, ok := KEMScheme(a.Level)
			if !ok {
				t.Fatalf("%s: no KEM scheme", a.Friendly)
			}
			name = s.Name()
		} else {
			s, ok := DSAScheme(a.Level)
			if !ok {
				t.Fatalf("%s: no DSA scheme", a.Friendly)
			}
			name = s.Name()
		}
		if want := upper(a.Friendly); name != want {
			t.Errorf("name %q, want %q", name, want)
		}
	}
	if _, ok := DSAScheme(512); ok {
		t.Error("DSAScheme(512) should not exist")
	}
	if _, ok := KEMScheme(44); ok {
		t.Error("KEMScheme(44) should not exist")
	}
}

func upper(s string) string {
	b := []byte(s)
	for i, c := range b {
		if c >= 'a' && c <= 'z' {
			b[i] = c - 'a' + 'A'
		}
	}
	return string(b)
}
