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
using System;
using System.Collections;
using System.Formats.Asn1;
using System.IO;
using System.Text;
using System.Security.Cryptography;

class Program
{
    static byte[] GenerateTbsCertificate(string alg, byte[] pk_raw)
    {
        // create an AsnWriter with DER for tbsCertificate
        var tbsCertWriter = new System.Formats.Asn1.AsnWriter(System.Formats.Asn1.AsnEncodingRules.DER);
        // begin tbscCertificate
        tbsCertWriter.PushSequence();
        // version
        tbsCertWriter.WriteEncodedValue(new byte[] {0xA0, 0x03, 0x02, 0x01, 0x02});
        // serial number
        tbsCertWriter.WriteInteger(49587);
        // signature algorithm identifier
        tbsCertWriter.PushSequence();
        tbsCertWriter.WriteObjectIdentifier(alg);
        tbsCertWriter.PopSequence();
        // begin issuer
        tbsCertWriter.PushSequence();
        tbsCertWriter.PushSetOf();
        // issuer name
        tbsCertWriter.PushSequence();
        tbsCertWriter.WriteObjectIdentifier("2.5.4.3");
        tbsCertWriter.WriteCharacterString(System.Formats.Asn1.UniversalTagNumber.UTF8String, "ACVTS Test TA");
        tbsCertWriter.PopSequence();
        // end issuer
        tbsCertWriter.PopSetOf();
        tbsCertWriter.PopSequence();
        // validity
        tbsCertWriter.PushSequence();
        var dateOffset = System.DateTimeOffset.UtcNow;
        tbsCertWriter.WriteUtcTime(dateOffset, 2049);
        tbsCertWriter.WriteUtcTime(dateOffset + new System.TimeSpan(365, 0, 0, 0), 2049);
        tbsCertWriter.PopSequence();
        // begin subject
        tbsCertWriter.PushSequence();
        tbsCertWriter.PushSetOf();
        // subject name
        tbsCertWriter.PushSequence();
        tbsCertWriter.WriteObjectIdentifier("2.5.4.3");
        tbsCertWriter.WriteCharacterString(System.Formats.Asn1.UniversalTagNumber.UTF8String, "ACVTS Test TA");
        tbsCertWriter.PopSequence();
        // end subject
        tbsCertWriter.PopSetOf();
        tbsCertWriter.PopSequence();
        // begin subject pk info
        tbsCertWriter.PushSequence();
        // algorithm identifier
        tbsCertWriter.PushSequence();
        tbsCertWriter.WriteObjectIdentifier(alg);
        tbsCertWriter.PopSequence();
        // public key 
        tbsCertWriter.WriteBitString(pk_raw);
        // end pk info
        tbsCertWriter.PopSequence();
        // end tbsCertificate
        tbsCertWriter.PopSequence();
        // encode tbsCertificate as message to be signed
        return tbsCertWriter.Encode();
    }
    static byte[] GenerateX509CertMLDSA(string alg)
    {
        DilithiumParameterSet param;
        // Switch on algorithm oid to determine parameter set
        switch (alg)
        {
            case "2.16.840.1.101.3.4.3.17":
                Console.WriteLine("MLDSA parameter set: ML_DSA_44");
                param = DilithiumParameterSet.ML_DSA_44;
                break;
            case "2.16.840.1.101.3.4.3.18":
                Console.WriteLine("MLDSA parameter set: ML_DSA_65");
                param = DilithiumParameterSet.ML_DSA_65;
                break;
            case "2.16.840.1.101.3.4.3.19":
                Console.WriteLine("MLDSA parameter set: ML_DSA_87");
                param = DilithiumParameterSet.ML_DSA_87;
                break;
            default:
                Console.WriteLine("Unrecognized OID, so default MLDSA parameter set: ML_DSA_44");
                param = DilithiumParameterSet.ML_DSA_44;;
                break;
        }
        // initialize MLDSA
        var seed = new BitString("0000000000000000000000000000000000000000000000000000000000000000").Bits;
        var dilithium = new Dilithium(
            new DilithiumParameters(param), 
            new NativeShaFactory(), 
            new EntropyProvider(new Random800_90())
        );
        var key = dilithium.GenerateKey(seed);
        // generate tbsCertificate for signing
        var message = GenerateTbsCertificate(alg, key.pk);
        // sign message
        var signature = dilithium.Sign(key.sk, new BitArray(message), true);
        // verify
        bool success = dilithium.Verify(key.pk, signature, new BitArray(message));
        if (success) Console.WriteLine("TBSCERT & SIGNATURE GENERATED AND INTERNALLY VERIFIED!!");
        // now for certificate structure
        var writer = new System.Formats.Asn1.AsnWriter(System.Formats.Asn1.AsnEncodingRules.DER);
        // begin cert sequence
        writer.PushSequence();
        // der-encoded tbsCertificate
        writer.WriteEncodedValue(message);
        // signature algorithm
        writer.PushSequence();
        writer.WriteObjectIdentifier(alg);
        writer.PopSequence();
        // signature value
        writer.WriteBitString(signature);
        // end cert sequence
        writer.PopSequence();
        // Return!
        return writer.Encode();        
    }
    static byte[] GenerateX509CertSLHDSA(string alg)
    {
        SlhdsaParameterSet param;
        // Switch on algorithm oid to determine parameter set
        switch (alg)
        {
            case "2.16.840.1.101.3.4.3.20":
                Console.WriteLine("SLHDSA parameter set: SLH_DSA_SHA2_128s");
                param = SlhdsaParameterSet.SLH_DSA_SHA2_128s;
                break;
            case "2.16.840.1.101.3.4.3.21":
                Console.WriteLine("SLHDSA parameter set: SLH_DSA_SHA2_128f");
                param = SlhdsaParameterSet.SLH_DSA_SHA2_128f;
                break;
            case "2.16.840.1.101.3.4.3.22":
                Console.WriteLine("SLHDSA parameter set: SLH_DSA_SHA2_192s");
                param = SlhdsaParameterSet.SLH_DSA_SHA2_192s;
                break;
            case "2.16.840.1.101.3.4.3.23":
                Console.WriteLine("SLHDSA parameter set: SLH_DSA_SHA2_192f");
                param = SlhdsaParameterSet.SLH_DSA_SHA2_192f;
                break;
            case "2.16.840.1.101.3.4.3.24":
                Console.WriteLine("SLHDSA parameter set: SLH_DSA_SHA2_256s");
                param = SlhdsaParameterSet.SLH_DSA_SHA2_256s;
                break;
            case "2.16.840.1.101.3.4.3.25":
                Console.WriteLine("SLHDSA parameter set: SLH_DSA_SHA2_256f");
                param = SlhdsaParameterSet.SLH_DSA_SHA2_256f;
                break;
            case "2.16.840.1.101.3.4.3.26":
                Console.WriteLine("SLHDSA parameter set: SLH_DSA_SHAKE_128s");
                param = SlhdsaParameterSet.SLH_DSA_SHAKE_128s;
                break;
            case "2.16.840.1.101.3.4.3.27":
                Console.WriteLine("SLHDSA parameter set: SLH_DSA_SHAKE_128f");
                param = SlhdsaParameterSet.SLH_DSA_SHAKE_128f;
                break;
            case "2.16.840.1.101.3.4.3.28":
                Console.WriteLine("SLHDSA parameter set: SLH_DSA_SHAKE_192s");
                param = SlhdsaParameterSet.SLH_DSA_SHAKE_192s;
                break;
            case "2.16.840.1.101.3.4.3.29":
                Console.WriteLine("SLHDSA parameter set: SLH_DSA_SHAKE_192f");
                param = SlhdsaParameterSet.SLH_DSA_SHAKE_192f;
                break;
            case "2.16.840.1.101.3.4.3.30":
                Console.WriteLine("SLHDSA parameter set: SLH_DSA_SHAKE_256s");
                param = SlhdsaParameterSet.SLH_DSA_SHAKE_256s;
                break;
            case "2.16.840.1.101.3.4.3.31":
                Console.WriteLine("SLHDSA parameter set: SLH_DSA_SHAKE_256f");
                param = SlhdsaParameterSet.SLH_DSA_SHAKE_256f;
                break;
            default:
                Console.WriteLine("Unrecognized OID, so default SLHDSA parameter set: SLH_DSA_SHA2_128s");
                param = SlhdsaParameterSet.SLH_DSA_SHA2_128s;
                break;
        }
        // Initialize SLHDSA objects
        var shaFactory = new NativeShaFactory();
        var wots = new Wots(shaFactory);
        var xmss = new Xmss(shaFactory, wots);
        var hypertree = new Hypertree(xmss);
        var fors = new Fors(shaFactory);
        var subject = new Slhdsa(shaFactory, xmss, hypertree, fors);
        // Grab all the values associated w/ the selected parameter set
        SlhdsaParameterSetAttributes slhdsaParameterSetAttributes = AttributesHelper.GetParameterSetAttribute(param);
        // Build the inputs to SlhdsaKeyGen
        byte[] nRandomBytesForSkSeed = new byte[slhdsaParameterSetAttributes.N];
        byte[] nRandomBytesForSkPrf = new byte[slhdsaParameterSetAttributes.N];
        byte[] nRandomBytesForPkSeed = new byte[slhdsaParameterSetAttributes.N];
        for (int i = 0; i < slhdsaParameterSetAttributes.N; i++)
        {
            nRandomBytesForSkSeed[i] = 0x1f;
            nRandomBytesForSkPrf[i] = 0x2e;
            nRandomBytesForPkSeed[i] = 0x3d;
        }
        // Create the key pair
        var keyPair = subject.SlhKeyGen(nRandomBytesForSkSeed, nRandomBytesForSkPrf, nRandomBytesForPkSeed,
            slhdsaParameterSetAttributes);
        // generate tbsCertificate for signing
        var message = GenerateTbsCertificate(alg, keyPair.PublicKey.GetBytes());
        // calculate the slhdsa signature of message
        var signature = subject.SlhSignDeterministic(message, keyPair.PrivateKey, slhdsaParameterSetAttributes);
        // verify
        var result = subject.SlhVerify(message, signature, keyPair.PublicKey, slhdsaParameterSetAttributes);
        if (result.Success) Console.WriteLine("TBSCERT & SIGNATURE GENERATED AND INTERNALLY VERIFIED!!");
        // now for certificate structure
        var writer = new System.Formats.Asn1.AsnWriter(System.Formats.Asn1.AsnEncodingRules.DER);
        // begin cert sequence
        writer.PushSequence();
        // der-encoded tbsCertificate
        writer.WriteEncodedValue(message);
        // signature algorithm
        writer.PushSequence();
        writer.WriteObjectIdentifier(alg);
        writer.PopSequence();
        // signature value
        writer.WriteBitString(signature);
        // end cert sequence
        writer.PopSequence();
        // Return!
        return writer.Encode();
    }
    static byte[] GenerateX509Cert(string alg)
    {
        // Switch on algorithm oid to determine which function to call
        switch (alg)
        {
            // MLDSA?
            case "2.16.840.1.101.3.4.3.17":
            case "2.16.840.1.101.3.4.3.18":
            case "2.16.840.1.101.3.4.3.19":
                return GenerateX509CertMLDSA(alg);
                break;
            // SLHDSA
            case "2.16.840.1.101.3.4.3.20":
            case "2.16.840.1.101.3.4.3.21":
            case "2.16.840.1.101.3.4.3.22":
            case "2.16.840.1.101.3.4.3.23":
            case "2.16.840.1.101.3.4.3.24":
            case "2.16.840.1.101.3.4.3.25":
            case "2.16.840.1.101.3.4.3.26":
            case "2.16.840.1.101.3.4.3.27":
            case "2.16.840.1.101.3.4.3.28":
            case "2.16.840.1.101.3.4.3.29":
            case "2.16.840.1.101.3.4.3.30":
            case "2.16.840.1.101.3.4.3.31":
                return GenerateX509CertSLHDSA(alg);
                break;
            // Return obviously incorrect bytestring on unrecognized OID?
            default:
                return new byte[1];
        }
    }
    static int Main(string[] args)
    {
        // Validate command line arguments
        if (args.Length != 2)
        {
            Console.WriteLine("Usage: dotnet run <prefix-for-generated-files> <oid>");
            return 1; // Return non-zero exit code on failure
        }
        // Path to the PEM file from command line argument
        string filePathPrefix = args[0];
        string alg = args[1];
        Console.WriteLine("Algorithm OID from command line: " + alg);
        // Generate X.509 cert, DER-encoded
        byte[] derContent = GenerateX509Cert(alg);
        // Try write to file
        try
        {
            // Write to file, depending on certificate file format
            // true = assume file is PEM-formatted; false = assume file is raw DER
            if (true)
            {
                Console.WriteLine("Encoding to generate: PEM");
                // Encode DER bytes as PEM
                Span<char> pemContent = System.Security.Cryptography.PemEncoding.Write("CERTIFICATE", derContent);
                string filePath = filePathPrefix + alg + "_ta.pem";
                Console.WriteLine("File to write: " + filePath);
                // Write file
                File.WriteAllText(filePath, new string(pemContent));

            }
            else
            {
                Console.WriteLine("Encoding to generate: DER");
                // Write raw DER
                string filePath = filePathPrefix + alg + "_ta.der";
                Console.WriteLine("File to write: " + filePath);
                // Write file
                File.WriteAllBytes(filePath, derContent);
            }
            // Done!
            Console.WriteLine("PROGRAM SUCCESS!");
            return 0;
        }
        catch (Exception ex)
        {
            Console.WriteLine("An error occurred: " + ex.Message);
            return 1;
        }
    }
}