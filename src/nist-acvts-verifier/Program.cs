using NIST.CVP.ACVTS.Libraries.Crypto.Common.Hash.ShaWrapper;
using NIST.CVP.ACVTS.Libraries.Crypto.Common.PQC.Dilithium;
using NIST.CVP.ACVTS.Libraries.Crypto.Common.PQC.SLHDSA;
using NIST.CVP.ACVTS.Libraries.Crypto.Common.PQC.SLHDSA.Enums;
using NIST.CVP.ACVTS.Libraries.Crypto.Common.PQC.SLHDSA.Helpers;
using NIST.CVP.ACVTS.Libraries.Crypto.Dilithium;
using NIST.CVP.ACVTS.Libraries.Crypto.SHA.NativeFastSha;
using NIST.CVP.ACVTS.Libraries.Crypto.SLHDSA;
using NIST.CVP.ACVTS.Libraries.Math;
using NIST.CVP.ACVTS.Libraries.Math.Entropy;
using NIST.CVP.ACVTS.Libraries.Math.Helpers;
using Org.BouncyCastle.X509;
using System;
using System.Collections;
using System.Formats.Asn1;
using System.IO;
using System.Text;
using System.Security.Cryptography;

class Program
{
    static bool VerifyMLDSA(byte[] m, byte[] sig, byte[] pk, DilithiumParameterSet param) {
        // initialize MLDSA
        var seed = new BitString("0000000000000000000000000000000000000000000000000000000000000000").Bits;
        var dilithium = new Dilithium(
            new DilithiumParameters(param), 
            new NativeShaFactory(), 
            new EntropyProvider(new Random800_90())
        );
        // verify!
        return dilithium.Verify(
            pk, 
            sig, 
            new BitArray(m)
        );
    }
    static bool VerifySLHDSA(byte[] m, byte[] sig, PublicKey pk, SlhdsaParameterSet param) {
        // Initialize SLHDSA objects
        var shaFactory = new NativeShaFactory();
        var wots = new Wots(shaFactory);
        var xmss = new Xmss(shaFactory, wots);
        var hypertree = new Hypertree(xmss);
        var fors = new Fors(shaFactory);
        var subject = new Slhdsa(shaFactory, xmss, hypertree, fors);
        // verify!
        return subject.SlhVerify(
            m, 
            sig, 
            pk,
            AttributesHelper.GetParameterSetAttribute(param)
        ).Success;
    }
    static int Main(string[] args)
    {
        // Validate command line arguments
        if (args.Length != 1)
        {
            Console.WriteLine("Usage: dotnet run <path-to-der-file>");
            return 1; // Return non-zero exit code on failure
        }
        // Path to the file from command line argument
        string filePath = args[0];
        Console.WriteLine("File to read: " + filePath);
        try
        {
            // Get DER bytes, depending on certificate file format
            // true = assume file is PEM-formatted; false = assume file is raw DER
            byte[] derContent;
            if (true)
            {
                Console.WriteLine("Encoding to expect: PEM");
                // Read the PEM file content
                string pemContent = File.ReadAllText(filePath);
                int start = pemContent.IndexOf("-----BEGIN CERTIFICATE-----", StringComparison.Ordinal) + 27;
                int end = pemContent.IndexOf("-----END CERTIFICATE-----", start, StringComparison.Ordinal);
                string base64 = pemContent.Substring(start, end - start).Replace("\n", "").Replace("\r", "");
                Console.WriteLine("Base64 from PEM: " + base64);
                derContent = Convert.FromBase64String(base64);
            } 
            else 
            {
                Console.WriteLine("Encoding to expect: DER");
                // Read the DER file content
                derContent = File.ReadAllBytes(filePath);
            }
            // Parse ASN.1 using BouncyCastle
            X509CertificateParser parser = new X509CertificateParser();
            X509Certificate certificate = parser.ReadCertificate(derContent);
            // Get signature
            byte[] sig = certificate.GetSignature();
            // Get tbsCertificate as "message"
            byte[] m = certificate.GetTbsCertificate();
            // Get public key (raw bytes)
            Span<byte> pk_raw = certificate.SubjectPublicKeyInfo.PublicKey.GetBytes();
            Console.WriteLine("Public key size: " + pk_raw.Length + " bytes");
            // Get algorithm OID
            string alg = certificate.SigAlgOid;
            Console.WriteLine("Algorithm OID in certificate: " + alg);
            // Switch on signature algorithm, get public key, and verify!
            bool verified = false;
            switch (alg)
            {
                case "2.16.840.1.101.3.4.3.17":
                    Console.WriteLine("MLDSA parameter set: ML_DSA_44");
                    // Verify!
                    verified = VerifyMLDSA(
                        m, 
                        sig, 
                        pk_raw.ToArray(),
                        DilithiumParameterSet.ML_DSA_44
                    );
                    break;
                case "2.16.840.1.101.3.4.3.18":
                    Console.WriteLine("MLDSA parameter set: ML_DSA_65");
                    // Verify!
                    verified = VerifyMLDSA(
                        m, 
                        sig, 
                        pk_raw.ToArray(),
                        DilithiumParameterSet.ML_DSA_65
                    );
                    break;
                case "2.16.840.1.101.3.4.3.19":
                    Console.WriteLine("MLDSA parameter set: ML_DSA_87");
                    // Verify!
                    verified = VerifyMLDSA(
                        m, 
                        sig, 
                        pk_raw.ToArray(),
                        DilithiumParameterSet.ML_DSA_87
                    );
                    break;
                case "2.16.840.1.101.3.4.3.20":
                    Console.WriteLine("SLHDSA parameter set: SLH_DSA_SHA2_128s");
                    // Verify!
                    verified = VerifySLHDSA(
                        m, 
                        sig, 
                        new PublicKey(pk_raw[0..16].ToArray(), pk_raw[16..32].ToArray()),
                        SlhdsaParameterSet.SLH_DSA_SHA2_128s
                    );
                    break;
                case "2.16.840.1.101.3.4.3.21":
                    Console.WriteLine("SLHDSA parameter set: SLH_DSA_SHA2_128f");
                    // Verify!
                    verified = VerifySLHDSA(
                        m, 
                        sig, 
                        new PublicKey(pk_raw[0..16].ToArray(), pk_raw[16..32].ToArray()),
                        SlhdsaParameterSet.SLH_DSA_SHA2_128f
                    );
                    break;
                case "2.16.840.1.101.3.4.3.22":
                    Console.WriteLine("SLHDSA parameter set: SLH_DSA_SHA2_192s");
                    // Verify!
                    verified = VerifySLHDSA(
                        m, 
                        sig, 
                        new PublicKey(pk_raw[0..24].ToArray(), pk_raw[24..48].ToArray()),
                        SlhdsaParameterSet.SLH_DSA_SHA2_192s
                    );
                    break;
                case "2.16.840.1.101.3.4.3.23":
                    Console.WriteLine("SLHDSA parameter set: SLH_DSA_SHA2_192f");
                    // Verify!
                    verified = VerifySLHDSA(
                        m, 
                        sig, 
                        new PublicKey(pk_raw[0..24].ToArray(), pk_raw[24..48].ToArray()),
                        SlhdsaParameterSet.SLH_DSA_SHA2_192f
                    );
                    break;
                case "2.16.840.1.101.3.4.3.24":
                    Console.WriteLine("SLHDSA parameter set: SLH_DSA_SHA2_256s");
                    // Verify!
                    verified = VerifySLHDSA(
                        m, 
                        sig, 
                        new PublicKey(pk_raw[0..32].ToArray(), pk_raw[32..64].ToArray()),
                        SlhdsaParameterSet.SLH_DSA_SHA2_256s
                    );
                    break;
                case "2.16.840.1.101.3.4.3.25":
                    Console.WriteLine("SLHDSA parameter set: SLH_DSA_SHA2_256f");
                    // Verify!
                    verified = VerifySLHDSA(
                        m, 
                        sig, 
                        new PublicKey(pk_raw[0..32].ToArray(), pk_raw[32..64].ToArray()),
                        SlhdsaParameterSet.SLH_DSA_SHA2_256f
                    );
                    break;
                case "2.16.840.1.101.3.4.3.26":
                    Console.WriteLine("SLHDSA parameter set: SLH_DSA_SHAKE_128s");
                    // Verify!
                    verified = VerifySLHDSA(
                        m, 
                        sig, 
                        new PublicKey(pk_raw[0..16].ToArray(), pk_raw[16..32].ToArray()),
                        SlhdsaParameterSet.SLH_DSA_SHAKE_128s
                    );
                    break;
                case "2.16.840.1.101.3.4.3.27":
                    Console.WriteLine("SLHDSA parameter set: SLH_DSA_SHAKE_128f");
                    // Verify!
                    verified = VerifySLHDSA(
                        m, 
                        sig, 
                        new PublicKey(pk_raw[0..16].ToArray(), pk_raw[16..32].ToArray()),
                        SlhdsaParameterSet.SLH_DSA_SHAKE_128f
                    );
                    break;
                case "2.16.840.1.101.3.4.3.28":
                    Console.WriteLine("SLHDSA parameter set: SLH_DSA_SHAKE_192s");
                    // Verify!
                    verified = VerifySLHDSA(
                        m, 
                        sig, 
                        new PublicKey(pk_raw[0..24].ToArray(), pk_raw[24..48].ToArray()),
                        SlhdsaParameterSet.SLH_DSA_SHAKE_192s
                    );
                    break;
                case "2.16.840.1.101.3.4.3.29":
                    Console.WriteLine("SLHDSA parameter set: SLH_DSA_SHAKE_192f");
                    // Verify!
                    verified = VerifySLHDSA(
                        m, 
                        sig, 
                        new PublicKey(pk_raw[0..24].ToArray(), pk_raw[24..48].ToArray()),
                        SlhdsaParameterSet.SLH_DSA_SHAKE_192f
                    );
                    break;
                case "2.16.840.1.101.3.4.3.30":
                    Console.WriteLine("SLHDSA parameter set: SLH_DSA_SHAKE_256s");
                    // Verify!
                    verified = VerifySLHDSA(
                        m, 
                        sig, 
                        new PublicKey(pk_raw[0..32].ToArray(), pk_raw[32..64].ToArray()),
                        SlhdsaParameterSet.SLH_DSA_SHAKE_256s
                    );
                    break;
                case "2.16.840.1.101.3.4.3.31":
                    Console.WriteLine("SLHDSA parameter set: SLH_DSA_SHAKE_256f");
                    // Verify!
                    verified = VerifySLHDSA(
                        m, 
                        sig, 
                        new PublicKey(pk_raw[0..32].ToArray(), pk_raw[32..64].ToArray()),
                        SlhdsaParameterSet.SLH_DSA_SHAKE_256f
                    );
                    break;
                default:
                    verified = false;
                    break;
            }
            // Done!
            if (verified) Console.WriteLine("CERTIFICATE VERIFIED!!!");
            Console.WriteLine("PROGRAM SUCCESS!");
            return Convert.ToInt32(!verified);
        }
        catch (Exception ex)
        {
            Console.WriteLine("An error occurred: " + ex.Message);
            return 1;
        }
    }
}