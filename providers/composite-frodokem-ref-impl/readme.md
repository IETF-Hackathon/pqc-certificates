# Composite FrodoKEM Reference Implementation

Artifacts for the eight Composite FrodoKEM combinations of draft-song-lamps-pq-composite-frodokem and
draft-song-lamps-cms-composite-frodokem, under the prototype OIDs 1.3.6.1.4.1.22554.5.12.1 to 1.3.6.1.4.1.22554.5.12.8
listed in `docs/oid_mapping.md`. They follow the -02 revisions of the drafts, including the -02 KEM Combiner Labels.

They were produced with the Python reference implementation of the drafts:

https://github.com/ligefeiBouncycastle/composite-frodokem-drafts (commit 1eb50e3)

FrodoKEM is implemented there from draft-longa-cfrg-frodokem; the classical algorithms come from the Python
cryptography package.

## artifacts_certs_r5.zip

For each OID, `<name>-<oid>_ee.der` (the certificate), `_priv.der` (the private key, a OneAsymmetricKey),
`_ciphertext.bin` and `_ss.bin` (a ciphertext and the shared secret it decapsulates to). These are the values of
`vectors/testvectors.json` in the repository above, unchanged.

The certificates are issued by the ML-DSA-65 CA included as `ml-dsa-65-2.16.840.1.101.3.4.3.18_ta.der`. The CA's
private key was not kept, so there is no private key artifact for it.

## artifacts_cms_v3.zip

For each OID, the same certificate and private key, and three kinds of message, each with one KEMRecipientInfo
using HKDF-SHA256 and AES-Wrap-256 and encrypted to that certificate:

- `_kemri_id-alg-hkdf-with-sha256.der`: EnvelopedData, AES-256-CBC, no ukm
- `_kemri_ukm.der`: EnvelopedData, AES-256-CBC, with ukm
- `_kemri_auth.der` and `_kemri_auth_id-alg-hkdf-with-sha256.der`: AuthEnvelopedData, AES-256-GCM, no ukm

Every message decrypts to `expected_plaintext.txt`. `ta.der` is the ML-DSA-65 CA above, not an ML-DSA-44 one; it is
not needed to decrypt the messages.

Every artifact was checked with the reference implementation and, independently, with a second implementation of
the drafts: the certificate signatures, the decapsulation of each ciphertext to its shared secret, and the
decryption of every CMS message.
