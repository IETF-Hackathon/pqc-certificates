# Artifacts generated using NIST ACVTS

X.509 certificate artifacts generated using C# standard ASN.1 writing routines, using PQC public key algorithms implemented as part of the NIST ACVTS, signed by PQC DSA algorithms.

## Notes

### 20240720

- PQ algorithms not officially supported
  - Evidenced by lack of official documentation at https://csrc.nist.rip/projects/cryptographic-algorithm-validation-program
  - Per Quynh (sorry for butchering spelling), presumably since final FIPS standards have not been published
  - However, there are ACVP server implementations
    - https://github.com/usnistgov/ACVP-Server/tree/master/gen-val/src/crypto/src/NIST.CVP.ACVTS.Libraries.Crypto/Kyber
    - https://github.com/usnistgov/ACVP-Server/tree/master/gen-val/src/crypto/src/NIST.CVP.ACVTS.Libraries.Crypto/Dilithium
    - etc
  - How do I know this codebase is correct?
  - Anyway, breakdown tasks to:
    1. Run local instance of ACVP-Server
    2. Build tbsCertificates
    3. Get ACVP-Server to sign tbsCertificates
    4. Build complete certificates

### 20240721

- Have ASN.1/DER-compliant artifacts for Dilithium and SLH-DSA
- Here's how I accomplished the tasks set out yesterday:
  1. Successfully ran unit tests on Dilithium and SLH-DSA modules
  2. Added additional unit test for each module that does the following:
     1. Initialize algorithm
     2. Generate keypair
     3. Construct tbsCertificate (with generated public key)
     4. Sign tbsCertificate using algorithm and private key
     5. Verify signature; assert that signature is verified
     5. Construct completed certificate
     6. Write PEM-encoded certificate to console
  3. Copied/paste each certificate into its respective .pem file
- Forked ACVP-Server code located at https://github.com/josephlukefahr/ACVP-Server
- After following ACVP-Server quick start instructions, I ran the following tests:
```bash
cd ~/Downloads/ACVP-Server
rm Directory.Build.props
rm Directory.Packages.props
ln -s ./_config/Directory.Build.props
ln -s ./_config/Directory.Packages.props
cd gen-val/src/crypto/test
cd NIST.CVP.ACVTS.Libraries.Crypto.Dilithium.Tests/
dotnet test NIST.CVP.ACVTS.Libraries.Crypto.Dilithium.Tests.csproj > ~/Downloads/pqc-certificates/providers/nist-acvts-test/dilithium.log
cd ..
cd NIST.CVP.ACVTS.Libraries.Crypto.SLHDSA.Tests/
dotnet test NIST.CVP.ACVTS.Libraries.Crypto.SLHDSA.Tests.csproj > ~/Downloads/pqc-certificates/providers/nist-acvts-test/slhdsa.log
```
- Unit test logs included as dilithium.log and slh-dsa.log
- NIST code seems to interchange "ML-DSA" and "Dilithium"; not sure which algorithm is actually implemented; could this be causing the issues with those certificates?
- Big disadvantage to this approach -- I cannot assert any claims related to the NIST code (not even sure which algorithm is implemented!); a NIST engineer who is familiar with the code should generate and contribute the artifacts