import java.io.File;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.math.BigInteger;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.MessageDigest;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.SecureRandom;
import java.security.Security;
import java.security.cert.CertificateEncodingException;
import java.security.cert.X509Certificate;
import java.security.spec.ECGenParameterSpec;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.bouncycastle.asn1.ASN1ObjectIdentifier;
import org.bouncycastle.asn1.DERNull;
import org.bouncycastle.asn1.bc.BCObjectIdentifiers;
import org.bouncycastle.asn1.cms.ContentInfo;
import org.bouncycastle.asn1.misc.MiscObjectIdentifiers;
import org.bouncycastle.asn1.nist.NISTObjectIdentifiers;
import org.bouncycastle.asn1.oiw.OIWObjectIdentifiers;
import org.bouncycastle.asn1.pkcs.PKCSObjectIdentifiers;
import org.bouncycastle.asn1.x500.X500Name;
import org.bouncycastle.asn1.x509.AlgorithmIdentifier;
import org.bouncycastle.asn1.x509.BasicConstraints;
import org.bouncycastle.asn1.x509.Extension;
import org.bouncycastle.asn1.x509.KeyUsage;
import org.bouncycastle.asn1.x509.SubjectAltPublicKeyInfo;
import org.bouncycastle.asn1.x509.SubjectPublicKeyInfo;
import org.bouncycastle.asn1.x9.X9ObjectIdentifiers;
import org.bouncycastle.cert.DeltaCertificateTool;
import org.bouncycastle.cert.X509CertificateHolder;
import org.bouncycastle.cert.X509v3CertificateBuilder;
import org.bouncycastle.cert.jcajce.JcaCertStore;
import org.bouncycastle.cert.jcajce.JcaX509CertificateConverter;
import org.bouncycastle.cert.jcajce.JcaX509ExtensionUtils;
import org.bouncycastle.cms.CMSAlgorithm;
import org.bouncycastle.cms.CMSEnvelopedData;
import org.bouncycastle.cms.CMSEnvelopedDataGenerator;
import org.bouncycastle.cms.CMSException;
import org.bouncycastle.cms.CMSProcessableByteArray;
import org.bouncycastle.cms.CMSSignedData;
import org.bouncycastle.cms.CMSSignedDataGenerator;
import org.bouncycastle.cms.CMSTypedData;
import org.bouncycastle.cms.SignerInformation;
import org.bouncycastle.cms.jcajce.JcaSignerId;
import org.bouncycastle.cms.jcajce.JcaSignerInfoGeneratorBuilder;
import org.bouncycastle.cms.jcajce.JcaSimpleSignerInfoVerifierBuilder;
import org.bouncycastle.cms.jcajce.JceCMSContentEncryptorBuilder;
import org.bouncycastle.cms.jcajce.JceKEMRecipientInfoGenerator;
import org.bouncycastle.crypto.AsymmetricCipherKeyPair;
import org.bouncycastle.crypto.SecretWithEncapsulation;
import org.bouncycastle.jcajce.CompositePrivateKey;
import org.bouncycastle.jcajce.CompositePublicKey;
import org.bouncycastle.jcajce.interfaces.MLDSAPrivateKey;
import org.bouncycastle.jcajce.interfaces.MLKEMPrivateKey;
import org.bouncycastle.jcajce.spec.CompositeAlgorithmSpec;
import org.bouncycastle.jce.provider.BouncyCastleProvider;
import org.bouncycastle.openssl.jcajce.JcaPEMWriter;
import org.bouncycastle.operator.ContentSigner;
import org.bouncycastle.operator.DigestCalculatorProvider;
import org.bouncycastle.operator.OperatorCreationException;
import org.bouncycastle.operator.jcajce.JcaContentSignerBuilder;
import org.bouncycastle.operator.jcajce.JcaDigestCalculatorProviderBuilder;
import org.bouncycastle.pqc.crypto.mlkem.MLKEMExtractor;
import org.bouncycastle.pqc.crypto.mlkem.MLKEMGenerator;
import org.bouncycastle.pqc.crypto.mlkem.MLKEMKeyGenerationParameters;
import org.bouncycastle.pqc.crypto.mlkem.MLKEMKeyPairGenerator;
import org.bouncycastle.pqc.crypto.mlkem.MLKEMParameters;
import org.bouncycastle.pqc.crypto.mlkem.MLKEMPrivateKeyParameters;
import org.bouncycastle.pqc.crypto.mlkem.MLKEMPublicKeyParameters;
import org.bouncycastle.pqc.crypto.util.PrivateKeyFactory;
import org.bouncycastle.pqc.crypto.util.PublicKeyFactory;
import org.bouncycastle.pqc.jcajce.provider.BouncyCastlePQCProvider;
import org.bouncycastle.pqc.jcajce.spec.NTRUParameterSpec;
import org.bouncycastle.util.Arrays;
import org.bouncycastle.util.Pack;
import org.bouncycastle.util.Store;
import org.bouncycastle.util.Strings;

public class R5ArtifactGenerator
{
    private static final ASN1ObjectIdentifier[] sigAlgorithms =
        {
            NISTObjectIdentifiers.id_ml_dsa_44,
            NISTObjectIdentifiers.id_ml_dsa_65,
            NISTObjectIdentifiers.id_ml_dsa_87,
            NISTObjectIdentifiers.id_hash_ml_dsa_44_with_sha512,
            NISTObjectIdentifiers.id_hash_ml_dsa_65_with_sha512,
            NISTObjectIdentifiers.id_hash_ml_dsa_87_with_sha512,
            BCObjectIdentifiers.falcon_512,
            BCObjectIdentifiers.falcon_1024,
            NISTObjectIdentifiers.id_slh_dsa_sha2_128f,
            NISTObjectIdentifiers.id_slh_dsa_sha2_128s,
            NISTObjectIdentifiers.id_slh_dsa_sha2_192f,
            NISTObjectIdentifiers.id_slh_dsa_sha2_192s,
            NISTObjectIdentifiers.id_slh_dsa_sha2_256f,
            NISTObjectIdentifiers.id_slh_dsa_sha2_256s,
            NISTObjectIdentifiers.id_slh_dsa_shake_128f,
            NISTObjectIdentifiers.id_slh_dsa_shake_128s,
            NISTObjectIdentifiers.id_slh_dsa_shake_192f,
            NISTObjectIdentifiers.id_slh_dsa_shake_192s,
            NISTObjectIdentifiers.id_slh_dsa_shake_256f,
            NISTObjectIdentifiers.id_slh_dsa_shake_256s,
            NISTObjectIdentifiers.id_hash_slh_dsa_sha2_128f_with_sha256,
            NISTObjectIdentifiers.id_hash_slh_dsa_sha2_128s_with_sha256,
            NISTObjectIdentifiers.id_hash_slh_dsa_sha2_192f_with_sha512,
            NISTObjectIdentifiers.id_hash_slh_dsa_sha2_192s_with_sha512,
            NISTObjectIdentifiers.id_hash_slh_dsa_sha2_256f_with_sha512,
            NISTObjectIdentifiers.id_hash_slh_dsa_sha2_256s_with_sha512,
            NISTObjectIdentifiers.id_hash_slh_dsa_shake_128f_with_shake128,
            NISTObjectIdentifiers.id_hash_slh_dsa_shake_128s_with_shake128,
            NISTObjectIdentifiers.id_hash_slh_dsa_shake_192f_with_shake256,
            NISTObjectIdentifiers.id_hash_slh_dsa_shake_192s_with_shake256,
            NISTObjectIdentifiers.id_hash_slh_dsa_shake_256f_with_shake256,
            NISTObjectIdentifiers.id_hash_slh_dsa_shake_256s_with_shake256,
            MiscObjectIdentifiers.id_MLDSA44_RSA2048_PSS_SHA256 ,
            MiscObjectIdentifiers.id_MLDSA44_RSA2048_PKCS15_SHA256 ,
            MiscObjectIdentifiers.id_MLDSA44_Ed25519_SHA512 ,
            MiscObjectIdentifiers.id_MLDSA44_ECDSA_P256_SHA256 ,
            MiscObjectIdentifiers.id_MLDSA65_RSA3072_PSS_SHA256 ,
            MiscObjectIdentifiers.id_MLDSA65_RSA3072_PKCS15_SHA256 ,
            MiscObjectIdentifiers.id_MLDSA65_RSA4096_PSS_SHA384 ,
            MiscObjectIdentifiers.id_MLDSA65_RSA4096_PKCS15_SHA384 ,
            MiscObjectIdentifiers.id_MLDSA65_ECDSA_P384_SHA384 ,
            MiscObjectIdentifiers.id_MLDSA65_ECDSA_brainpoolP256r1_SHA256 ,
            MiscObjectIdentifiers.id_MLDSA65_Ed25519_SHA512 ,
            MiscObjectIdentifiers.id_MLDSA87_ECDSA_P384_SHA384 ,
            MiscObjectIdentifiers.id_MLDSA87_ECDSA_brainpoolP384r1_SHA384 ,
            MiscObjectIdentifiers.id_MLDSA87_Ed448_SHA512 ,
        
            MiscObjectIdentifiers.id_HashMLDSA44_RSA2048_PSS_SHA256 ,
            MiscObjectIdentifiers.id_HashMLDSA44_RSA2048_PKCS15_SHA256 ,
            MiscObjectIdentifiers.id_HashMLDSA44_Ed25519_SHA512 ,
            MiscObjectIdentifiers.id_HashMLDSA44_ECDSA_P256_SHA256 ,
            MiscObjectIdentifiers.id_HashMLDSA65_RSA3072_PSS_SHA512 ,
            MiscObjectIdentifiers.id_HashMLDSA65_RSA3072_PKCS15_SHA512 ,
            MiscObjectIdentifiers.id_HashMLDSA65_RSA4096_PSS_SHA512 ,
            MiscObjectIdentifiers.id_HashMLDSA65_RSA4096_PKCS15_SHA512 ,
            MiscObjectIdentifiers.id_HashMLDSA65_ECDSA_P384_SHA512 ,
            MiscObjectIdentifiers.id_HashMLDSA65_ECDSA_brainpoolP256r1_SHA512 ,
            MiscObjectIdentifiers.id_HashMLDSA65_Ed25519_SHA512 ,
            MiscObjectIdentifiers.id_HashMLDSA87_ECDSA_P384_SHA512 ,
            MiscObjectIdentifiers.id_HashMLDSA87_ECDSA_brainpoolP384r1_SHA512 ,
            MiscObjectIdentifiers.id_HashMLDSA87_Ed448_SHA512
        };


    private static final String[] sigAlgNames =
        {
            "ml-dsa-44",
            "ml-dsa-65",
            "ml-dsa-87",
            "ml-dsa-44-with-sha512",
            "ml-dsa-65-with-sha512",
            "ml-dsa-87-with-sha512",
            "falcon-512",
            "falcon-1024",
            "slh-dsa-sha2-128f",
            "slh-dsa-sha2-128s",
            "slh-dsa-sha2-192f",
            "slh-dsa-sha2-192s",
            "slh-dsa-sha2-256f",
            "slh-dsa-sha2-256s",
            "slh-dsa-shake-128f",
            "slh-dsa-shake-128s",
            "slh-dsa-shake-192f",
            "slh-dsa-shake-192s",
            "slh-dsa-shake-256f",
            "slh-dsa-shake-256s",
            "slh-dsa-sha2-128f-with-sha256",
            "slh-dsa-sha2-128s-with-sha256",
            "slh-dsa-sha2-192f-with-sha512",
            "slh-dsa-sha2-192s-with-sha512",
            "slh-dsa-sha2-256f-with-sha512",
            "slh-dsa-sha2-256s-with-sha512",
            "slh-dsa-shake-128f-with-shake128",
            "slh-dsa-shake-128s-with-shake128",
            "slh-dsa-shake-192f-with-shake256",
            "slh-dsa-shake-192s-with-shake256",
            "slh-dsa-shake-256f-with-shake256",
            "slh-dsa-shake-256s-with-shake256",
             "MLDSA44-RSA2048-PSS-SHA256",
             "MLDSA44-RSA2048-PKCS15-SHA256",
             "MLDSA44-Ed25519-SHA512",
             "MLDSA44-ECDSA-P256-SHA256",
             "MLDSA65-RSA3072-PSS-SHA256",
             "MLDSA65-RSA3072-PKCS15-SHA256",
             "MLDSA65-RSA4096-PSS-SHA384",
             "MLDSA65-RSA4096-PKCS15-SHA384",
             "MLDSA65-ECDSA-P384-SHA384",
             "MLDSA65-ECDSA-brainpoolP256r1-SHA256",
             "MLDSA65-Ed25519-SHA512",
             "MLDSA87-ECDSA-P384-SHA384",
             "MLDSA87-ECDSA-brainpoolP384r1-SHA384",
             "MLDSA87-Ed448-SHA512",
             "HashMLDSA44-RSA2048-PSS-SHA256",
             "HashMLDSA44-RSA2048-PKCS15-SHA256",
             "HashMLDSA44-Ed25519-SHA512",
             "HashMLDSA44-ECDSA-P256-SHA256",
             "HashMLDSA65-RSA3072-PSS-SHA512",
             "HashMLDSA65-RSA3072-PKCS15-SHA512",
             "HashMLDSA65-RSA4096-PSS-SHA512",
             "HashMLDSA65-RSA4096-PKCS15-SHA512",
             "HashMLDSA65-ECDSA-P384-SHA512",
             "HashMLDSA65-ECDSA-brainpoolP256r1-SHA512",
             "HashMLDSA65-Ed25519-SHA512",
             "HashMLDSA87-ECDSA-P384-SHA512",
             "HashMLDSA87-ECDSA-brainpoolP384r1-SHA512",
             "HashMLDSA87-Ed448-SHA512"
        };
    
    private static File aDir = new File("artifacts_certs_r4");

    private static final ASN1ObjectIdentifier[] kemAlgorithms =
        {
            NISTObjectIdentifiers.id_alg_ml_kem_512,
            NISTObjectIdentifiers.id_alg_ml_kem_768,
            NISTObjectIdentifiers.id_alg_ml_kem_1024
        };

    private static final String[] kemAlgNames =
        {
            "ml-kem-512",
            "ml-kem-768",
            "ml-kem-1024"
        };

    private static final long BEFORE_DELTA = 60 * 1000L;
    private static final long AFTER_DELTA = 365L * 24 * 60 * 60 * 1000L;

    private static int certCount = 1;

    private static final BigInteger generateSerialNumber()
        throws Exception
    {
        MessageDigest dig = MessageDigest.getInstance("SHA1");

        byte[] sn = dig.digest(Arrays.concatenate(Pack.intToBigEndian(certCount), Pack.longToBigEndian(System.currentTimeMillis())));

        sn[0] = (byte)((sn[0] & 0x7f) | 0x40);

        return new BigInteger(sn);
    }

    private static X509Certificate createTACertificate(String algName, KeyPair taKp)
        throws Exception
    {
        X509v3CertificateBuilder crtBld = new X509v3CertificateBuilder(
            new X500Name("CN=BC " + algName.replace("+", "Plus") + " Test TA"),
            generateSerialNumber(),
            new Date(System.currentTimeMillis() - BEFORE_DELTA),
            new Date(System.currentTimeMillis() + AFTER_DELTA),
            new X500Name("CN=BC " + algName.replace("+", "Plus") + " Test TA"),
            SubjectPublicKeyInfo.getInstance(taKp.getPublic().getEncoded()));

        crtBld.addExtension(Extension.basicConstraints, true, new BasicConstraints(1));
        crtBld.addExtension(Extension.keyUsage, true, new KeyUsage(KeyUsage.keyCertSign | KeyUsage.cRLSign));

        ContentSigner signer = new JcaContentSignerBuilder(algName).build(taKp.getPrivate());

        return new JcaX509CertificateConverter().getCertificate(crtBld.build(signer));
    }

    private static X509Certificate createEECertificate(String taAlgName, PKIXPair taPair, String eeAlgName, KeyPair eeKp)
        throws Exception
    {
        X509v3CertificateBuilder crtBld = new X509v3CertificateBuilder(
            new X500Name("CN=BC " + taAlgName + " Test TA"),
            generateSerialNumber(),
            new Date(System.currentTimeMillis() - BEFORE_DELTA),
            new Date(System.currentTimeMillis() + AFTER_DELTA),
            new X500Name("CN=BC " + eeAlgName + " Test EE"),
            SubjectPublicKeyInfo.getInstance(eeKp.getPublic().getEncoded()));

        JcaX509ExtensionUtils extUtils = new JcaX509ExtensionUtils(
            new JcaDigestCalculatorProviderBuilder().build().get(
                new AlgorithmIdentifier(OIWObjectIdentifiers.idSHA1, DERNull.INSTANCE)));

        crtBld.addExtension(Extension.basicConstraints, true, new BasicConstraints(false));
        crtBld.addExtension(Extension.keyUsage, true, new KeyUsage(KeyUsage.keyEncipherment));
        crtBld.addExtension(Extension.subjectKeyIdentifier, false, extUtils.createSubjectKeyIdentifier(eeKp.getPublic()));
        crtBld.addExtension(Extension.authorityKeyIdentifier, false, extUtils.createAuthorityKeyIdentifier(taPair.cert));

        ContentSigner signer = new JcaContentSignerBuilder(taAlgName).build(taPair.priv);

        return new JcaX509CertificateConverter().getCertificate(crtBld.build(signer));
    }

    private static X509Certificate createCatalystHybridTACertificate(String algName, KeyPair taKp, String altAlgName, PKIXPair altTaKp)
        throws Exception
    {
        X509v3CertificateBuilder crtBld = new X509v3CertificateBuilder(
            new X500Name("CN=BC " + algName + " with " + altAlgName + " Test TA"),
            generateSerialNumber(),
            new Date(System.currentTimeMillis() - BEFORE_DELTA),
            new Date(System.currentTimeMillis() + AFTER_DELTA),
            new X500Name("CN=BC " + algName + " with " + altAlgName + " Test TA"),
            SubjectPublicKeyInfo.getInstance(taKp.getPublic().getEncoded()));

        crtBld.addExtension(Extension.basicConstraints, true, new BasicConstraints(0));
        crtBld.addExtension(Extension.keyUsage, true, new KeyUsage(KeyUsage.keyCertSign | KeyUsage.cRLSign));
        crtBld.addExtension(Extension.subjectAltPublicKeyInfo, true, SubjectAltPublicKeyInfo.getInstance(altTaKp.cert.getPublicKey().getEncoded()));

        ContentSigner signer = new JcaContentSignerBuilder(algName).build(taKp.getPrivate());
        ContentSigner altSigner = new JcaContentSignerBuilder(altAlgName).build(altTaKp.priv);

        return new JcaX509CertificateConverter().getCertificate(crtBld.build(signer, false, altSigner));
    }

    private static X509Certificate createCompositeHybridTACertificate(String algName, KeyPair taKp, String altAlgName, PKIXPair altTaKp)
        throws Exception
    {
        CompositeAlgorithmSpec compAlgSpec = new CompositeAlgorithmSpec.Builder()
            .add(algName)
            .add(altAlgName)
            .build();

        CompositePublicKey compPub = new CompositePublicKey(taKp.getPublic(), altTaKp.cert.getPublicKey());
        CompositePrivateKey compPrivKey = new CompositePrivateKey(taKp.getPrivate(), altTaKp.priv);

        ContentSigner signer = new JcaContentSignerBuilder("COMPOSITE", compAlgSpec).build(compPrivKey);

        X509v3CertificateBuilder crtBld = new X509v3CertificateBuilder(
            new X500Name("CN=BC " + algName + " with " + altAlgName + " Test TA"),
            generateSerialNumber(),
            new Date(System.currentTimeMillis() - BEFORE_DELTA),
            new Date(System.currentTimeMillis() + AFTER_DELTA),
            new X500Name("CN=BC " + algName + " with " + altAlgName + " Test TA"),
            SubjectPublicKeyInfo.getInstance(compPub.getEncoded()));

        crtBld.addExtension(Extension.basicConstraints, true, new BasicConstraints(0));
        crtBld.addExtension(Extension.keyUsage, true, new KeyUsage(KeyUsage.keyCertSign | KeyUsage.cRLSign));

        return new JcaX509CertificateConverter().getCertificate(crtBld.build(signer));
    }

    private static X509Certificate createChameleonHybridTACertificate(String algName, KeyPair taKp, String altAlgName, PKIXPair altTaKp)
        throws Exception
    {
        long now = System.currentTimeMillis();
        X509v3CertificateBuilder crtBld = new X509v3CertificateBuilder(
            new X500Name("CN=BC " + algName + " Test Chameleon Outer TA"),
            generateSerialNumber(),
            new Date(now - BEFORE_DELTA),
            new Date(now + AFTER_DELTA),
            new X500Name("CN=BC " + algName + " Test Chameleon Outer TA"),
            SubjectPublicKeyInfo.getInstance(taKp.getPublic().getEncoded()));

        crtBld.addExtension(Extension.basicConstraints, true, new BasicConstraints(0));
        crtBld.addExtension(Extension.keyUsage, true, new KeyUsage(KeyUsage.keyCertSign | KeyUsage.cRLSign));

        X509v3CertificateBuilder altCrtBld = new X509v3CertificateBuilder(
            new X500Name("CN=BC " + altAlgName + " Test Chameleon Inner TA"),
            generateSerialNumber(),
            new Date(now - BEFORE_DELTA),
            new Date(now + AFTER_DELTA),
            new X500Name("CN=BC " + altAlgName + " Test Chameleon Inner TA"),
            SubjectPublicKeyInfo.getInstance(altTaKp.cert.getPublicKey().getEncoded()));

        altCrtBld.addExtension(Extension.basicConstraints, true, new BasicConstraints(0));
        altCrtBld.addExtension(Extension.keyUsage, true, new KeyUsage(KeyUsage.keyCertSign | KeyUsage.cRLSign));

        ContentSigner altSigner = new JcaContentSignerBuilder(altAlgName).build(altTaKp.priv);
        X509CertificateHolder deltaCert = altCrtBld.build(altSigner);

        Extension deltaExt = DeltaCertificateTool.makeDeltaCertificateExtension(
            false,
            deltaCert);
        crtBld.addExtension(deltaExt);

        ContentSigner signer = new JcaContentSignerBuilder(algName).build(taKp.getPrivate());

        X509CertificateHolder chameleonCert = crtBld.build(signer);
        X509CertificateHolder exDeltaCert = DeltaCertificateTool.extractDeltaCertificate(chameleonCert);

        return new JcaX509CertificateConverter().getCertificate(chameleonCert);
    }

    private static void kemSampleOutput(File parent, String name, KeyPair kemKp)
        throws Exception
    {
        // Generate secret and encapsulation
        MLKEMPublicKeyParameters kemPubKey = (MLKEMPublicKeyParameters)PublicKeyFactory.createKey(kemKp.getPublic().getEncoded());

        MLKEMGenerator generator = new MLKEMGenerator(new SecureRandom());
        SecretWithEncapsulation secWenc = generator.generateEncapsulated(kemPubKey);

        byte[] encapsulation = secWenc.getEncapsulation();
        byte[] encSecret = secWenc.getSecret();

        // Extract secret from encapsulation
        MLKEMPrivateKeyParameters kemPrivKey = (MLKEMPrivateKeyParameters)PrivateKeyFactory.createKey(kemKp.getPrivate().getEncoded());

        MLKEMExtractor extractor = new MLKEMExtractor(kemPrivKey);

        byte[] decSecret = extractor.extractSecret(encapsulation);

        if (!Arrays.areEqual(decSecret, encSecret))
        {
            throw new IllegalStateException("mismatch in KEM secrets!!!");
        }

        FileOutputStream fWrt = new FileOutputStream(new File(parent, name + "_ciphertext.bin"));

        fWrt.write(encapsulation);

        fWrt.close();
        
        fWrt = new FileOutputStream(new File(parent, name + "_ss.bin"));

        fWrt.write(encSecret);

        fWrt.close();
    }

    private static void derOutput(File parent, String name, PrivateKey key)
        throws Exception
    {
        FileOutputStream fWrt = new FileOutputStream(new File(parent, name));

        fWrt.write(key.getEncoded());

        fWrt.close();
    }

    private static void derOutput(File parent, String name, PublicKey key)
        throws Exception
    {
        FileOutputStream fWrt = new FileOutputStream(new File(parent, name));

        fWrt.write(key.getEncoded());

        fWrt.close();
    }

    private static void derOutput(File parent, String name, ContentInfo contentInfo)
        throws Exception
    {
        FileOutputStream fWrt = new FileOutputStream(new File(parent, name));

        fWrt.write(contentInfo.getEncoded());

        fWrt.close();
    }

    private static void derOutput(File parent, String name, X509Certificate cert)
        throws Exception
    {
        FileOutputStream fWrt = new FileOutputStream(new File(parent, name));

        fWrt.write(cert.getEncoded());

        fWrt.close();
    }

    private static void pemOutput(File parent, String name, Object obj)
        throws Exception
    {
        FileWriter fWrt = new FileWriter(new File(parent, name));
        JcaPEMWriter pemWriter = new JcaPEMWriter(fWrt);

        pemWriter.writeObject(obj);

        pemWriter.close();
        fWrt.close();
    }

    private static PKIXPair createKEMEEcertificate(String kemAlgName, ASN1ObjectIdentifier kemAlg, String sigAlgName, ASN1ObjectIdentifier sigAlg, Map<String, PKIXPair> sigParams)
        throws Exception
    {
        PKIXPair taPair = sigParams.get(sigAlgName);
        KeyPairGenerator kpGen;

        if (kemAlg.on(BCObjectIdentifiers.pqc_kem_ntru))
        {
            kpGen = KeyPairGenerator.getInstance("NTRU", "BC");
            NTRUParameterSpec ntrusp = NTRUParameterSpec.fromName(kemAlgName);
            kpGen.initialize(ntrusp);
        }
        else
        {
            kpGen = KeyPairGenerator.getInstance(kemAlg.getId());
        }

        KeyPair eeKp = kpGen.generateKeyPair();
        X509Certificate eeCert = createEECertificate(sigAlgName, taPair, kemAlgName, eeKp);

        derOutput(aDir, kemAlgName + "-" + kemAlg + "_ee.der", eeCert);
//        pemOutput(aDir, kemAlg + "_ee.pem", eeCert);

        return new PKIXPair(eeKp.getPrivate(), eeCert);
    }

    private static PKIXPair createExternalEEcertificate(String kemAlgName, ASN1ObjectIdentifier kemAlg, String sigAlgName, ASN1ObjectIdentifier sigAlg, Map<String, PKIXPair> sigParams)
        throws Exception
    {
        PKIXPair taPair = sigParams.get(sigAlgName);
        KeyPairGenerator kpGen;

        if (kemAlg.on(BCObjectIdentifiers.pqc_kem_ntru))
        {
            kpGen = KeyPairGenerator.getInstance("NTRU", "BC");
            NTRUParameterSpec ntrusp = NTRUParameterSpec.fromName(kemAlgName);
            kpGen.initialize(ntrusp);
        }
        else
        {
            kpGen = KeyPairGenerator.getInstance(kemAlg.getId());
        }

        KeyPair eeKp = kpGen.generateKeyPair();
        X509Certificate eeCert = createEECertificate(sigAlgName, taPair, kemAlgName, eeKp);

        derOutput(aDir, "external_" + kemAlgName + "-" + kemAlg + "_ee.der", eeCert);
        derOutput(aDir, "external_" + kemAlgName + "-" + kemAlg + "_public.der", eeKp.getPublic());
//        pemOutput(aDir, kemAlg + "_ee.pem", eeCert);

        return new PKIXPair(eeKp.getPrivate(), eeCert);
    }

    public static void main(String[] args)
        throws Exception
    {
        Security.insertProviderAt(new BouncyCastleProvider(), 1);
        Security.insertProviderAt(new BouncyCastlePQCProvider(), 2);

        File aDir = new File("artifacts_certs_r5");

        aDir.mkdir();

        //
        // Build TA certificates
        //
        Map<String, PKIXPair> sigParams = new HashMap<String, PKIXPair>();
        for (int alg = 0; alg != sigAlgorithms.length; alg++)
        {
            KeyPairGenerator kpGen = KeyPairGenerator.getInstance(sigAlgorithms[alg].getId());

            KeyPair taKp = kpGen.generateKeyPair();

            X509Certificate taCert = createTACertificate(sigAlgNames[alg], taKp);

            derOutput(aDir, sigAlgNames[alg] + "-" + sigAlgorithms[alg] + "_ta.der", taCert);
//            pemOutput(aDir, sigAlgorithms[alg] + "_ta.pem", taCert);

            if (taKp.getPrivate() instanceof MLDSAPrivateKey)
            {
                derOutput(aDir, sigAlgNames[alg] + "-" + sigAlgorithms[alg] + "_seed_priv.der", ((MLDSAPrivateKey)taKp.getPrivate()).getPrivateKey(true));
                derOutput(aDir, sigAlgNames[alg] + "-" + sigAlgorithms[alg] + "_expandedkey_priv.der",  ((MLDSAPrivateKey)taKp.getPrivate()).getPrivateKey(false));
            }

            derOutput(aDir, sigAlgNames[alg] + "-" + sigAlgorithms[alg] + "_priv.der", taKp.getPrivate());

            sigParams.put(sigAlgNames[alg], new PKIXPair(taKp.getPrivate(), taCert));
        }

        //
        // Build KEM EE certificates
        //
        Map<String, PKIXPair> kemParams = new HashMap<String, PKIXPair>();
        for (int alg = 0; alg != kemAlgorithms.length; alg++)
        {
            PKIXPair taPair = sigParams.get(sigAlgNames[alg]);
            KeyPairGenerator kpGen = KeyPairGenerator.getInstance(kemAlgorithms[alg].getId());

            KeyPair eeKp = kpGen.generateKeyPair();

            X509Certificate eeCert = createEECertificate(sigAlgNames[alg], taPair, kemAlgNames[alg], eeKp);

            derOutput(aDir, kemAlgNames[alg] + "-" + kemAlgorithms[alg] + "_ee.der", eeCert);
            //pemOutput(aDir, kemAlgorithms[alg] + "_ee.pem", eeCert);

            if (eeKp.getPrivate() instanceof MLKEMPrivateKey)
            {
                derOutput(aDir, kemAlgNames[alg].toLowerCase(Locale.ROOT) + "-" + kemAlgorithms[alg] + "_seed_priv.der", ((MLKEMPrivateKey)eeKp.getPrivate()).getPrivateKey(true));
                derOutput(aDir, kemAlgNames[alg].toLowerCase(Locale.ROOT) + "-" + kemAlgorithms[alg] + "_expandedkey_priv.der",  ((MLKEMPrivateKey)eeKp.getPrivate()).getPrivateKey(false));
            }
   
            derOutput(aDir, kemAlgNames[alg].toLowerCase(Locale.ROOT) + "-" + kemAlgorithms[alg] + "_priv.der", eeKp.getPrivate());

            kemSampleOutput(aDir, kemAlgNames[alg].toLowerCase(Locale.ROOT) + "-" + kemAlgorithms[alg], eeKp);

            kemParams.put(kemAlgNames[alg], new PKIXPair(eeKp.getPrivate(), eeCert));
        }

        PKIXPair pkixpair = createKEMEEcertificate("ml-kem-512", NISTObjectIdentifiers.id_alg_ml_kem_512, "ml-dsa-44", NISTObjectIdentifiers.id_ml_dsa_44, sigParams);
        kemParams.put("ML-KEM-512", pkixpair);
        pkixpair = createKEMEEcertificate("ml-kem-768", NISTObjectIdentifiers.id_alg_ml_kem_768, "ml-dsa-65", NISTObjectIdentifiers.id_ml_dsa_65, sigParams);
        kemParams.put("ML-KEM-768", pkixpair);
        pkixpair = createKEMEEcertificate("ml-kem-1024", NISTObjectIdentifiers.id_alg_ml_kem_1024, "ml-dsa-87", NISTObjectIdentifiers.id_ml_dsa_87, sigParams);
        kemParams.put("ML-KEM-1024", pkixpair);
        pkixpair = createKEMEEcertificate("ntruhps2048677", BCObjectIdentifiers.ntruhps2048677, "ml-dsa-44", NISTObjectIdentifiers.id_ml_dsa_44, sigParams);
        kemParams.put("ntruhps2048677", pkixpair);
        pkixpair = createKEMEEcertificate("ntruhps4096821", BCObjectIdentifiers.ntruhps4096821, "ml-dsa-65", NISTObjectIdentifiers.id_ml_dsa_65, sigParams);
        kemParams.put("ntruhps4096821", pkixpair);
        pkixpair = createKEMEEcertificate("ntruhrss701", BCObjectIdentifiers.ntruhrss701, "ml-dsa-44", NISTObjectIdentifiers.id_ml_dsa_44, sigParams);
        kemParams.put("ntruhrss701", pkixpair);

        pkixpair = createExternalEEcertificate("ml-kem-512", NISTObjectIdentifiers.id_alg_ml_kem_512, "ml-dsa-44", NISTObjectIdentifiers.id_ml_dsa_44, sigParams);
        kemParams.put("EXTERNAL-ML-KEM-512", pkixpair);
        pkixpair = createExternalEEcertificate("ml-kem-768", NISTObjectIdentifiers.id_alg_ml_kem_768, "ml-dsa-65", NISTObjectIdentifiers.id_ml_dsa_65, sigParams);
        kemParams.put("EXTERNAL-ML-KEM-768", pkixpair);
        pkixpair = createExternalEEcertificate("ml-kem-1024", NISTObjectIdentifiers.id_alg_ml_kem_1024, "ml-dsa-87", NISTObjectIdentifiers.id_ml_dsa_87, sigParams);
        kemParams.put("EXTERNAL-ML-KEM-1024", pkixpair);
        //
        // Build Hybrid certificates
        //
        KeyPairGenerator rsaKpg = KeyPairGenerator.getInstance("RSA", "BC");
        rsaKpg.initialize(3072);
        KeyPair rsaKp = rsaKpg.generateKeyPair();

        KeyPairGenerator p256Kpg = KeyPairGenerator.getInstance("EC", "BC");
        p256Kpg.initialize(new ECGenParameterSpec("P-256"));
        KeyPair p256Kp = p256Kpg.generateKeyPair();

        KeyPairGenerator p521Kpg = KeyPairGenerator.getInstance("EC", "BC");
        p521Kpg.initialize(new ECGenParameterSpec("P-521"));
        KeyPair p521Kp = p521Kpg.generateKeyPair();

        X509Certificate hybridCert = createCatalystHybridTACertificate("SHA256withRSA", rsaKp, "ML-DSA-44", sigParams.get("ml-dsa-44"));
        derOutput(aDir, "catalyst_" + PKCSObjectIdentifiers.sha256WithRSAEncryption + "_with_" + NISTObjectIdentifiers.id_ml_dsa_44 + "_ta.der", hybridCert);
        hybridCert = createCatalystHybridTACertificate("SHA256withECDSA", p256Kp, "ML-DSA-44", sigParams.get("ml-dsa-44"));
        derOutput(aDir, "catalyst_" + X9ObjectIdentifiers.ecdsa_with_SHA256 + "_with_" + NISTObjectIdentifiers.id_ml_dsa_44 + "_ta.der", hybridCert);
        hybridCert = createCatalystHybridTACertificate("SHA512withECDSA", p521Kp, "ML-DSA-87", sigParams.get("ml-dsa-87"));
        derOutput(aDir, "catalyst_" + X9ObjectIdentifiers.ecdsa_with_SHA512 + "_with_" + NISTObjectIdentifiers.id_ml_dsa_87 + "_ta.der", hybridCert);

        hybridCert = createCompositeHybridTACertificate("SHA256withRSA", rsaKp, "ML-DSA-44", sigParams.get("ml-dsa-44"));
        derOutput(aDir, "composite_" + PKCSObjectIdentifiers.sha256WithRSAEncryption + "_with_" + NISTObjectIdentifiers.id_ml_dsa_44 + "_ta.der", hybridCert);
        hybridCert = createCompositeHybridTACertificate("SHA256withECDSA", p256Kp, "ML-DSA-44", sigParams.get("ml-dsa-44"));
        derOutput(aDir, "composite_" + X9ObjectIdentifiers.ecdsa_with_SHA256 + "_with_" + NISTObjectIdentifiers.id_ml_dsa_44 + "_ta.der", hybridCert);
        hybridCert = createCompositeHybridTACertificate("SHA512withECDSA", p521Kp, "ML-DSA-87", sigParams.get("ml-dsa-87"));
        derOutput(aDir, "composite_" + X9ObjectIdentifiers.ecdsa_with_SHA512 + "_with_" + NISTObjectIdentifiers.id_ml_dsa_87 + "_ta.der", hybridCert);

        hybridCert = createChameleonHybridTACertificate("SHA256withRSA", rsaKp, "ML-DSA-44", sigParams.get("ml-dsa-44"));
        derOutput(aDir, "chameleon_" + PKCSObjectIdentifiers.sha256WithRSAEncryption + "_with_" + NISTObjectIdentifiers.id_ml_dsa_44 + "_ta.der", hybridCert);
        hybridCert = createChameleonHybridTACertificate("SHA256withECDSA", p256Kp, "ML-DSA-44", sigParams.get("ml-dsa-44"));
        derOutput(aDir, "chameleon_" + X9ObjectIdentifiers.ecdsa_with_SHA256 + "_with_" + NISTObjectIdentifiers.id_ml_dsa_44 + "_ta.der", hybridCert);
        hybridCert = createChameleonHybridTACertificate("SHA512withECDSA", p521Kp, "ML-DSA-87", sigParams.get("ml-dsa-87"));
        derOutput(aDir, "chameleon_" + X9ObjectIdentifiers.ecdsa_with_SHA512 + "_with_" + NISTObjectIdentifiers.id_ml_dsa_87 + "_ta.der", hybridCert);

        aDir = new File("artifacts_cms_r4");

        aDir.mkdir();

        CMSSignedData s = getCmsSignedData("ML-DSA-44", sigParams.get("ml-dsa-44"));
        derOutput(aDir, "signed_data_" + NISTObjectIdentifiers.id_ml_dsa_44 + ".der", s.toASN1Structure());
        s = getCmsSignedData("ML-DSA-65", sigParams.get("ml-dsa-65"));
        derOutput(aDir, "signed_data_" + NISTObjectIdentifiers.id_ml_dsa_65 + ".der", s.toASN1Structure());
        s = getCmsSignedData("ML-DSA-87", sigParams.get("ml-dsa-87"));
        derOutput(aDir, "signed_data_" + NISTObjectIdentifiers.id_ml_dsa_87 + ".der", s.toASN1Structure());

        CMSEnvelopedData ed = getCmsEnvelopedData(kemParams.get("ML-KEM-512"));
        derOutput(aDir, "enveloped_data_" + NISTObjectIdentifiers.id_alg_ml_kem_512 + ".der", ed.toASN1Structure());
        derOutput(aDir, "priv_key_" + NISTObjectIdentifiers.id_alg_ml_kem_512 + ".der", kemParams.get("ML-KEM-512").priv);
        ed = getCmsEnvelopedData(kemParams.get("ML-KEM-768"));
        derOutput(aDir, "enveloped_data_" + NISTObjectIdentifiers.id_alg_ml_kem_768 + ".der", ed.toASN1Structure());
        derOutput(aDir, "priv_key_" + NISTObjectIdentifiers.id_alg_ml_kem_768 + ".der", kemParams.get("ML-KEM-768").priv);
        ed = getCmsEnvelopedData(kemParams.get("ML-KEM-1024"));
        derOutput(aDir, "enveloped_data_" + NISTObjectIdentifiers.id_alg_ml_kem_1024 + ".der", ed.toASN1Structure());
        derOutput(aDir, "priv_key_" + NISTObjectIdentifiers.id_alg_ml_kem_1024 + ".der", kemParams.get("ML-KEM-1024").priv);
        ed = getCmsEnvelopedData(kemParams.get("ntruhps2048677"));
        derOutput(aDir, "enveloped_data_" + BCObjectIdentifiers.ntruhps2048677 + ".der", ed.toASN1Structure());
        derOutput(aDir, "priv_key_" + BCObjectIdentifiers.ntruhps2048677 + ".der", kemParams.get("ntruhps2048677").priv);
        ed = getCmsEnvelopedData(kemParams.get("ntruhps4096821"));
        derOutput(aDir, "enveloped_data_" + BCObjectIdentifiers.ntruhps4096821 + ".der", ed.toASN1Structure());
        derOutput(aDir, "priv_key_" + BCObjectIdentifiers.ntruhps4096821 + ".der", kemParams.get("ntruhps4096821").priv);
        ed = getCmsEnvelopedData(kemParams.get("ntruhrss701"));
        derOutput(aDir, "enveloped_data_" + BCObjectIdentifiers.ntruhrss701 + ".der", ed.toASN1Structure());
        derOutput(aDir, "priv_key_" + BCObjectIdentifiers.ntruhrss701 + ".der", kemParams.get("ntruhrss701").priv);
    }

    private static CMSSignedData getCmsSignedData(String algorithm, PKIXPair sigPair)
        throws CertificateEncodingException, OperatorCreationException, CMSException
    {
        byte[] msg = Strings.toByteArray("Hello, World!");
        List certList = new ArrayList();
        CMSTypedData cmsMsg = new CMSProcessableByteArray(msg);

        certList.add(sigPair.cert);

        Store certs = new JcaCertStore(certList);

        CMSSignedDataGenerator gen = new CMSSignedDataGenerator();

        DigestCalculatorProvider digCalcProv = new JcaDigestCalculatorProviderBuilder().setProvider("BC").build();

        gen.addSignerInfoGenerator(new JcaSignerInfoGeneratorBuilder(digCalcProv).build(new JcaContentSignerBuilder(algorithm).setProvider("BC").build(sigPair.priv), sigPair.cert));

        gen.addCertificates(certs);

        CMSSignedData s = gen.generate(cmsMsg, true);

        SignerInformation si = s.getSignerInfos().get(new JcaSignerId(sigPair.cert));

        if (!si.verify(new JcaSimpleSignerInfoVerifierBuilder().build(sigPair.cert)))
        {
            throw new IllegalStateException("can't verify signedData!");
        }

        return s;
    }

    private static CMSEnvelopedData getCmsEnvelopedData(PKIXPair kemPair)
        throws CertificateEncodingException, OperatorCreationException, CMSException
    {
        byte[] msg = Strings.toByteArray("Hello, World!");
        // Send response with encrypted certificate
        CMSEnvelopedDataGenerator edGen = new CMSEnvelopedDataGenerator();

        // note: use cert req ID as key ID, don't want to use issuer/serial in this case!

        edGen.addRecipientInfoGenerator(new JceKEMRecipientInfoGenerator(kemPair.cert, CMSAlgorithm.AES256_WRAP).setKDF(
            new AlgorithmIdentifier(NISTObjectIdentifiers.id_shake256)));

        return edGen.generate(
            new CMSProcessableByteArray(msg),
            new JceCMSContentEncryptorBuilder(CMSAlgorithm.AES128_CBC).setProvider("BC").build());
    }

    private static class PKIXPair
    {
        final PrivateKey priv;
        final X509Certificate cert;

        PKIXPair(PrivateKey priv, X509Certificate cert)
        {
            this.priv = priv;
            this.cert = cert;
        }
    }
}
