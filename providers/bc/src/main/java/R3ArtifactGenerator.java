import java.io.File;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.math.BigInteger;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.MessageDigest;
import java.security.PrivateKey;
import java.security.Security;
import java.security.cert.CertificateEncodingException;
import java.security.cert.X509Certificate;
import java.security.spec.ECGenParameterSpec;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.bouncycastle.asn1.ASN1ObjectIdentifier;
import org.bouncycastle.asn1.DERNull;
import org.bouncycastle.asn1.bc.BCObjectIdentifiers;
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
import org.bouncycastle.jcajce.CompositePrivateKey;
import org.bouncycastle.jcajce.CompositePublicKey;
import org.bouncycastle.jcajce.spec.CompositeAlgorithmSpec;
import org.bouncycastle.jce.provider.BouncyCastleProvider;
import org.bouncycastle.openssl.jcajce.JcaPEMWriter;
import org.bouncycastle.operator.ContentSigner;
import org.bouncycastle.operator.DigestCalculatorProvider;
import org.bouncycastle.operator.OperatorCreationException;
import org.bouncycastle.operator.jcajce.JcaContentSignerBuilder;
import org.bouncycastle.operator.jcajce.JcaDigestCalculatorProviderBuilder;
import org.bouncycastle.pqc.jcajce.provider.BouncyCastlePQCProvider;
import org.bouncycastle.pqc.jcajce.spec.NTRUParameterSpec;
import org.bouncycastle.util.Arrays;
import org.bouncycastle.util.Pack;
import org.bouncycastle.util.Store;
import org.bouncycastle.util.Strings;

public class R3ArtifactGenerator
{
    private static final ASN1ObjectIdentifier[] sigAlgorithms =
        {
            BCObjectIdentifiers.dilithium2,
            BCObjectIdentifiers.dilithium3,
            BCObjectIdentifiers.dilithium5,
            BCObjectIdentifiers.sphincsPlus_sha2_128f,
            BCObjectIdentifiers.sphincsPlus_sha2_128s,
            BCObjectIdentifiers.sphincsPlus_sha2_192f,
            BCObjectIdentifiers.sphincsPlus_sha2_192s,
            BCObjectIdentifiers.sphincsPlus_sha2_256f,
            BCObjectIdentifiers.sphincsPlus_sha2_256s,
            BCObjectIdentifiers.sphincsPlus_shake_128f,
            BCObjectIdentifiers.sphincsPlus_shake_128s,
            BCObjectIdentifiers.sphincsPlus_shake_192f,
            BCObjectIdentifiers.sphincsPlus_shake_192s,
            BCObjectIdentifiers.sphincsPlus_shake_256f,
            BCObjectIdentifiers.sphincsPlus_shake_256s,
            BCObjectIdentifiers.falcon_512,
            BCObjectIdentifiers.falcon_1024,
            MiscObjectIdentifiers.id_MLDSA44_RSA2048_PSS_SHA256,
            MiscObjectIdentifiers.id_MLDSA44_RSA2048_PKCS15_SHA256,
            MiscObjectIdentifiers.id_MLDSA44_Ed25519_SHA512,
            MiscObjectIdentifiers.id_MLDSA44_ECDSA_P256_SHA256,
            MiscObjectIdentifiers.id_MLDSA44_ECDSA_brainpoolP256r1_SHA256,
            MiscObjectIdentifiers.id_MLDSA65_RSA3072_PSS_SHA512,
            MiscObjectIdentifiers.id_MLDSA65_RSA3072_PKCS15_SHA512,
            MiscObjectIdentifiers.id_MLDSA65_ECDSA_P256_SHA512,
            MiscObjectIdentifiers.id_MLDSA65_ECDSA_brainpoolP256r1_SHA512,
            MiscObjectIdentifiers.id_MLDSA65_Ed25519_SHA512,
            MiscObjectIdentifiers.id_MLDSA87_ECDSA_P384_SHA512,
            MiscObjectIdentifiers.id_MLDSA87_ECDSA_brainpoolP384r1_SHA512,
            MiscObjectIdentifiers.id_MLDSA87_Ed448_SHA512,
            MiscObjectIdentifiers.id_Falcon512_ECDSA_P256_SHA256,
            MiscObjectIdentifiers.id_Falcon512_ECDSA_brainpoolP256r1_SHA256,
            MiscObjectIdentifiers.id_Falcon512_Ed25519_SHA512
        };


    private static final String[] sigAlgNames =
        {
            "dilithium2",
            "dilithium3",
            "dilithium5",
            "sphincs+-sha2-128f",
            "sphincs+-sha2-128s",
            "sphincs+-sha2-192f",
            "sphincs+-sha2-192s",
            "sphincs+-sha2-256f",
            "sphincs+-sha2-256s",
            "sphincs+-shake-128f",
            "sphincs+-shake-128s",
            "sphincs+-shake-192f",
            "sphincs+-shake-192s",
            "sphincs+-shake-256f",
            "sphincs+-shake-256s",
            "falcon-512",
            "falcon-1024",
            "MLDSA44-RSA2048-PSS-SHA256",
            "MLDSA44-RSA2048-PKCS15-SHA256",
            "MLDSA44-Ed25519-SHA512",
            "MLDSA44-ECDSA-P256-SHA256",
            "MLDSA44-ECDSA-brainpoolP256r1-SHA256",
            "MLDSA65-RSA3072-PSS-SHA512",
            "MLDSA65-RSA3072-PKCS15-SHA512",
            "MLDSA65-ECDSA-P256-SHA512",
            "MLDSA65-ECDSA-brainpoolP256r1-SHA512",
            "MLDSA65-Ed25519-SHA512",
            "MLDSA87-ECDSA-P384-SHA512",
            "MLDSA87-ECDSA-brainpoolP384r1-SHA512",
            "MLDSA87-Ed448-SHA512",
            "Falcon512-ECDSA-P256-SHA256",
            "Falcon512-ECDSA-brainpoolP256r1-SHA256",
            "Falcon512-Ed25519-SHA512",
        };
    private static File aDir = new File("artifacts_certs_r3");

    private static final ASN1ObjectIdentifier[] kemAlgorithms =
        {
            BCObjectIdentifiers.kyber512,
            BCObjectIdentifiers.kyber768,
            BCObjectIdentifiers.kyber1024
        };

    private static final String[] kemAlgNames =
        {
            "kyber512",
            "kyber768",
            "kyber1024"
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

        return new JcaX509CertificateConverter().getCertificate(crtBld.build(signer, true, altSigner));
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

        if (kemAlg.on(BCObjectIdentifiers.pqc_kem_ntru)) {
            kpGen = KeyPairGenerator.getInstance("NTRU", "BC");
            NTRUParameterSpec ntrusp = NTRUParameterSpec.fromName(kemAlgName);
            kpGen.initialize(ntrusp);
        } else {
            kpGen = KeyPairGenerator.getInstance(kemAlg.getId());
        }

        KeyPair eeKp = kpGen.generateKeyPair();
        X509Certificate eeCert = createEECertificate(sigAlgName, taPair, kemAlgName, eeKp);

        pemOutput(aDir, kemAlg + "_ee.pem", eeCert);
        
        return new PKIXPair(eeKp.getPrivate(), eeCert);
    }

    public static void main(String[] args)
        throws Exception
    {
        Security.insertProviderAt(new BouncyCastleProvider(), 1);
        Security.insertProviderAt(new BouncyCastlePQCProvider(), 2);

        File aDir = new File("artifacts_certs_r3");

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

            //derOutput(aDir, sigAlgorithms[alg] + "_ta.der", taCert);
            pemOutput(aDir, sigAlgorithms[alg] + "_ta.pem", taCert);

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

            pemOutput(aDir, kemAlgorithms[alg] + "_ee.pem", eeCert);

            kemParams.put(kemAlgNames[alg], new PKIXPair(eeKp.getPrivate(), eeCert));
        }
	    PKIXPair pkixpair = createKEMEEcertificate("kyber512", BCObjectIdentifiers.kyber512, "dilithium2", BCObjectIdentifiers.dilithium2, sigParams);
        kemParams.put("kyber512", pkixpair);
        pkixpair = createKEMEEcertificate("kyber768", BCObjectIdentifiers.kyber768, "dilithium3", BCObjectIdentifiers.dilithium3, sigParams);
        kemParams.put("kyber768", pkixpair);
        pkixpair = createKEMEEcertificate("kyber1024", BCObjectIdentifiers.kyber1024, "dilithium5", BCObjectIdentifiers.dilithium5, sigParams);
        kemParams.put("kyber1024", pkixpair);
        pkixpair = createKEMEEcertificate("ntruhps2048677", BCObjectIdentifiers.ntruhps2048677, "dilithium2", BCObjectIdentifiers.dilithium2, sigParams);
        kemParams.put("ntruhps2048677", pkixpair);
        pkixpair = createKEMEEcertificate("ntruhps4096821", BCObjectIdentifiers.ntruhps4096821, "dilithium3", BCObjectIdentifiers.dilithium3, sigParams);
        kemParams.put("ntruhps4096821", pkixpair);
        pkixpair = createKEMEEcertificate("ntruhrss701", BCObjectIdentifiers.ntruhrss701, "dilithium2", BCObjectIdentifiers.dilithium2, sigParams);
        kemParams.put("ntruhrss701", pkixpair);
																									 

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

        X509Certificate hybridCert = createCatalystHybridTACertificate("SHA256withRSA", rsaKp, "Dilithium2", sigParams.get("dilithium2"));
        pemOutput(aDir, "catalyst_" + PKCSObjectIdentifiers.sha256WithRSAEncryption + "_with_" + BCObjectIdentifiers.dilithium2 + "_ta.pem", hybridCert);
        hybridCert = createCatalystHybridTACertificate("SHA256withECDSA", p256Kp, "Dilithium2", sigParams.get("dilithium2"));
        pemOutput(aDir, "catalyst_" + X9ObjectIdentifiers.ecdsa_with_SHA256 + "_with_" + BCObjectIdentifiers.dilithium2 + "_ta.pem", hybridCert);
        hybridCert = createCatalystHybridTACertificate("SHA512withECDSA", p521Kp, "Dilithium5", sigParams.get("dilithium5"));
        pemOutput(aDir, "catalyst_" + X9ObjectIdentifiers.ecdsa_with_SHA512 + "_with_" + BCObjectIdentifiers.dilithium5 + "_ta.pem", hybridCert);

        hybridCert = createCompositeHybridTACertificate("SHA256withRSA", rsaKp, "Dilithium2", sigParams.get("dilithium2"));
        pemOutput(aDir, "composite_" + PKCSObjectIdentifiers.sha256WithRSAEncryption + "_with_" + BCObjectIdentifiers.dilithium2 + "_ta.pem", hybridCert);
        hybridCert = createCompositeHybridTACertificate("SHA256withECDSA", p256Kp, "Dilithium2", sigParams.get("dilithium2"));
        pemOutput(aDir, "composite_" + X9ObjectIdentifiers.ecdsa_with_SHA256 + "_with_" + BCObjectIdentifiers.dilithium2 + "_ta.pem", hybridCert);
        hybridCert = createCompositeHybridTACertificate("SHA512withECDSA", p521Kp, "Dilithium5", sigParams.get("dilithium5"));
        pemOutput(aDir, "composite_" + X9ObjectIdentifiers.ecdsa_with_SHA512 + "_with_" + BCObjectIdentifiers.dilithium5 + "_ta.pem", hybridCert);

        hybridCert = createChameleonHybridTACertificate("SHA256withRSA", rsaKp, "Dilithium2", sigParams.get("dilithium2"));
        pemOutput(aDir, "chameleon_" + PKCSObjectIdentifiers.sha256WithRSAEncryption + "_with_" + BCObjectIdentifiers.dilithium2 + "_ta.pem", hybridCert);
        hybridCert = createChameleonHybridTACertificate("SHA256withECDSA", p256Kp, "Dilithium2", sigParams.get("dilithium2"));
        pemOutput(aDir, "chameleon_" + X9ObjectIdentifiers.ecdsa_with_SHA256 + "_with_" + BCObjectIdentifiers.dilithium2 + "_ta.pem", hybridCert);
        hybridCert = createChameleonHybridTACertificate("SHA512withECDSA", p521Kp, "Dilithium5", sigParams.get("dilithium5"));
        pemOutput(aDir, "chameleon_" + X9ObjectIdentifiers.ecdsa_with_SHA512 + "_with_" + BCObjectIdentifiers.dilithium5 + "_ta.pem", hybridCert);

        aDir = new File("artifacts_cms_r3");

        aDir.mkdir();

        CMSSignedData s = getCmsSignedData("DILITHIUM2", sigParams.get("dilithium2"));
        pemOutput(aDir, "signed_data_" + BCObjectIdentifiers.dilithium2 + ".pem", s.toASN1Structure());
        s = getCmsSignedData("DILITHIUM3", sigParams.get("dilithium3"));
        pemOutput(aDir, "signed_data_" + BCObjectIdentifiers.dilithium3 + ".pem", s.toASN1Structure());
        s = getCmsSignedData("DILITHIUM5", sigParams.get("dilithium5"));
        pemOutput(aDir, "signed_data_" + BCObjectIdentifiers.dilithium5 + ".pem", s.toASN1Structure());

        CMSEnvelopedData ed = getCmsEnvelopedData(kemParams.get("kyber512"));
        pemOutput(aDir, "enveloped_data_" + BCObjectIdentifiers.kyber512 + ".pem", ed.toASN1Structure());
        pemOutput(aDir, "priv_key_" + BCObjectIdentifiers.kyber512 + ".pem", kemParams.get("kyber512").priv);
        ed = getCmsEnvelopedData(kemParams.get("kyber768"));
        pemOutput(aDir, "enveloped_data_" + BCObjectIdentifiers.kyber768 + ".pem", ed.toASN1Structure());
        pemOutput(aDir, "priv_key_" + BCObjectIdentifiers.kyber768 + ".pem", kemParams.get("kyber768").priv);
        ed = getCmsEnvelopedData(kemParams.get("kyber1024"));
        pemOutput(aDir, "enveloped_data_" + BCObjectIdentifiers.kyber1024 + ".pem", ed.toASN1Structure());
        pemOutput(aDir, "priv_key_" + BCObjectIdentifiers.kyber1024 + ".pem", kemParams.get("kyber1024").priv);
		ed = getCmsEnvelopedData(kemParams.get("ntruhps2048677"));
        pemOutput(aDir, "enveloped_data_" + BCObjectIdentifiers.ntruhps2048677 + ".pem", ed.toASN1Structure());
        pemOutput(aDir, "priv_key_" + BCObjectIdentifiers.ntruhps2048677 + ".pem", kemParams.get("ntruhps2048677").priv);
        ed = getCmsEnvelopedData(kemParams.get("ntruhps4096821"));
        pemOutput(aDir, "enveloped_data_" + BCObjectIdentifiers.ntruhps4096821 + ".pem", ed.toASN1Structure());
        pemOutput(aDir, "priv_key_" + BCObjectIdentifiers.ntruhps4096821 + ".pem", kemParams.get("ntruhps4096821").priv);
        ed = getCmsEnvelopedData(kemParams.get("ntruhrss701"));
        pemOutput(aDir, "enveloped_data_" + BCObjectIdentifiers.ntruhrss701 + ".pem", ed.toASN1Structure());
        pemOutput(aDir, "priv_key_" + BCObjectIdentifiers.ntruhrss701 + ".pem", kemParams.get("ntruhrss701").priv);
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
