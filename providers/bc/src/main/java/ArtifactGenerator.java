import java.io.File;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.OutputStream;
import java.math.BigInteger;
import java.security.InvalidKeyException;
import java.security.Key;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.NoSuchProviderException;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.Security;
import java.security.SignatureException;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;
import java.security.spec.ECGenParameterSpec;
import java.util.Date;

import org.bouncycastle.asn1.ASN1Encodable;
import org.bouncycastle.asn1.ASN1Encoding;
import org.bouncycastle.asn1.ASN1ObjectIdentifier;
import org.bouncycastle.asn1.bc.BCObjectIdentifiers;
import org.bouncycastle.asn1.misc.MiscObjectIdentifiers;
import org.bouncycastle.asn1.x500.X500Name;
import org.bouncycastle.asn1.x509.BasicConstraints;
import org.bouncycastle.asn1.x509.CRLReason;
import org.bouncycastle.asn1.x509.Extension;
import org.bouncycastle.asn1.x509.KeyUsage;
import org.bouncycastle.asn1.x509.SubjectAltPublicKeyInfo;
import org.bouncycastle.asn1.x509.SubjectPublicKeyInfo;
import org.bouncycastle.asn1.x9.X9ObjectIdentifiers;
import org.bouncycastle.cert.CertException;
import org.bouncycastle.cert.X509CRLHolder;
import org.bouncycastle.cert.X509CertificateHolder;
import org.bouncycastle.cert.X509v2CRLBuilder;
import org.bouncycastle.cert.X509v3CertificateBuilder;
import org.bouncycastle.cert.jcajce.JcaX509CertificateConverter;
import org.bouncycastle.cert.jcajce.JcaX509v3CertificateBuilder;
import org.bouncycastle.jcajce.CompositePrivateKey;
import org.bouncycastle.jcajce.CompositePublicKey;
import org.bouncycastle.jcajce.spec.CompositeAlgorithmSpec;
import org.bouncycastle.jcajce.spec.EdDSAParameterSpec;
import org.bouncycastle.jce.provider.BouncyCastleProvider;
import org.bouncycastle.openssl.jcajce.JcaPEMWriter;
import org.bouncycastle.operator.ContentSigner;
import org.bouncycastle.operator.ContentVerifierProvider;
import org.bouncycastle.operator.OperatorCreationException;
import org.bouncycastle.operator.jcajce.JcaContentSignerBuilder;
import org.bouncycastle.operator.jcajce.JcaContentVerifierProviderBuilder;
import org.bouncycastle.pkcs.PKCS10CertificationRequest;
import org.bouncycastle.pkcs.PKCS10CertificationRequestBuilder;
import org.bouncycastle.pqc.jcajce.provider.BouncyCastlePQCProvider;
import org.bouncycastle.pqc.jcajce.spec.DilithiumParameterSpec;
import org.bouncycastle.util.Arrays;
import org.bouncycastle.util.Pack;

public class ArtifactGenerator
{
    private static final ASN1ObjectIdentifier[] algorithms =
        {
            BCObjectIdentifiers.dilithium2,
            BCObjectIdentifiers.dilithium3,
            BCObjectIdentifiers.dilithium5,
            BCObjectIdentifiers.falcon_512,
            BCObjectIdentifiers.falcon_1024,
            BCObjectIdentifiers.sphincsPlus_sha2_128f,
            BCObjectIdentifiers.sphincsPlus_sha2_128s,
            BCObjectIdentifiers.sphincsPlus_sha2_192f,
            BCObjectIdentifiers.sphincsPlus_sha2_192s,
            BCObjectIdentifiers.sphincsPlus_sha2_256f,
            BCObjectIdentifiers.sphincsPlus_sha2_256s,
            BCObjectIdentifiers.sphincsPlus_shake_128f,
            BCObjectIdentifiers.sphincsPlus_shake_192f,
            BCObjectIdentifiers.sphincsPlus_shake_256f
        };

    private static final String[] algNames =
        {
            "dilithium2",
            "dilithium3",
            "dilithium5",
            "falcon-512",
            "falcon-1024",
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
            "sphincs+-shake-256s"
//            "sphincs+_sha2_128f_simple",
//            "sphincs+_sha2_128s_simple",
//            "sphincs+_sha2_192f_simple",
//            "sphincs+_sha2_192s_simple",
//            "sphincs+_sha2_256f_simple",
//            "sphincs+_sha2_256s_simple",
//            "sphincs+_shake_128f_simple",
//            "sphincs+_shake_192f_simple",
//            "sphincs+_shake_256f_simple"
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
            new X500Name("CN=BC " + algName + " Test TA"),
            generateSerialNumber(),
            new Date(System.currentTimeMillis() - BEFORE_DELTA),
            new Date(System.currentTimeMillis() + AFTER_DELTA),
            new X500Name("CN=BC " + algName + " Test TA"),
            SubjectPublicKeyInfo.getInstance(taKp.getPublic().getEncoded()));

        crtBld.addExtension(Extension.basicConstraints, true, new BasicConstraints(1));
        crtBld.addExtension(Extension.keyUsage, true, new KeyUsage(KeyUsage.keyCertSign | KeyUsage.cRLSign));

        ContentSigner signer = new JcaContentSignerBuilder(algName).build(taKp.getPrivate());

        return new JcaX509CertificateConverter().getCertificate(crtBld.build(signer));
    }

    private static X509CRLHolder createTACrl(String algName, KeyPair taKp)
        throws Exception
    {
        X509v2CRLBuilder crlBuilder = new X509v2CRLBuilder(
            new X500Name("CN=BC " + algName + " Test TA"),
            new Date(System.currentTimeMillis()));

        crlBuilder.addCRLEntry(BigInteger.ONE, new Date(), CRLReason.cessationOfOperation);

        ContentSigner signer = new JcaContentSignerBuilder(algName).build(taKp.getPrivate());

        return crlBuilder.build(signer);
    }

    private static X509Certificate createCACertificate(String algName, KeyPair taKp, KeyPair caKp)
        throws Exception
    {
        X509v3CertificateBuilder crtBld = new X509v3CertificateBuilder(
            new X500Name("CN=BC " + algName + " Test TA"),
            generateSerialNumber(),
            new Date(System.currentTimeMillis() - BEFORE_DELTA),
            new Date(System.currentTimeMillis() + AFTER_DELTA),
            new X500Name("CN=BC " + algName + " Test CA"),
            SubjectPublicKeyInfo.getInstance(caKp.getPublic().getEncoded()));

        crtBld.addExtension(Extension.basicConstraints, true, new BasicConstraints(0));
        crtBld.addExtension(Extension.keyUsage, true, new KeyUsage(KeyUsage.keyCertSign | KeyUsage.cRLSign));

        ContentSigner signer = new JcaContentSignerBuilder(algName).build(taKp.getPrivate());

        return new JcaX509CertificateConverter().getCertificate(crtBld.build(signer));
    }

    private static X509CRLHolder createCACrl(String algName, KeyPair caKp)
        throws Exception
    {
        X509v2CRLBuilder crlBuilder = new X509v2CRLBuilder(
            new X500Name("CN=BC " + algName + " Test CA"),
            new Date(System.currentTimeMillis()));

        crlBuilder.addCRLEntry(BigInteger.TEN, new Date(), CRLReason.cessationOfOperation);

        ContentSigner signer = new JcaContentSignerBuilder(algName).build(caKp.getPrivate());

        return crlBuilder.build(signer);
    }

    private static X509Certificate createHybridTACertificate(String algName, KeyPair taKp, String altAlgName, KeyPair taAltKp)
        throws Exception
    {
        X509v3CertificateBuilder crtBld = new X509v3CertificateBuilder(
            new X500Name("CN=BC " + algName + " Test TA"),
            generateSerialNumber(),
            new Date(System.currentTimeMillis() - BEFORE_DELTA),
            new Date(System.currentTimeMillis() + AFTER_DELTA),
            new X500Name("CN=BC " + algName + " Test TA"),
            SubjectPublicKeyInfo.getInstance(taKp.getPublic().getEncoded()));

        crtBld.addExtension(Extension.basicConstraints, true, new BasicConstraints(1));
        crtBld.addExtension(Extension.keyUsage, true, new KeyUsage(KeyUsage.keyCertSign | KeyUsage.cRLSign));
        crtBld.addExtension(Extension.subjectAltPublicKeyInfo, true, SubjectAltPublicKeyInfo.getInstance(taAltKp.getPublic().getEncoded()));

        ContentSigner signer = new JcaContentSignerBuilder(algName).build(taKp.getPrivate());
        ContentSigner altSigner = new JcaContentSignerBuilder(altAlgName).build(taAltKp.getPrivate());

        return new JcaX509CertificateConverter().getCertificate(crtBld.build(signer, true, altSigner));
    }

    private static X509CRLHolder createHybridTACrl(String algName, KeyPair taKp, String altAlgName, KeyPair taAltKp)
        throws Exception
    {
        X509v2CRLBuilder crlBuilder = new X509v2CRLBuilder(
            new X500Name("CN=BC " + algName + " Test TA"),
            new Date(System.currentTimeMillis()));

        crlBuilder.addCRLEntry(BigInteger.ONE, new Date(), CRLReason.cessationOfOperation);

        ContentSigner signer = new JcaContentSignerBuilder(algName).build(taKp.getPrivate());
        ContentSigner altSigner = new JcaContentSignerBuilder(altAlgName).build(taAltKp.getPrivate());

        return crlBuilder.build(signer, true, altSigner);
    }

    private static X509Certificate createHybridCACertificate(String algName, KeyPair taKp, KeyPair caKp, String altAlgName, KeyPair altTaKp, KeyPair altCaKp)
        throws Exception
    {
        X509v3CertificateBuilder crtBld = new X509v3CertificateBuilder(
            new X500Name("CN=BC " + algName + " Test TA"),
            generateSerialNumber(),
            new Date(System.currentTimeMillis() - BEFORE_DELTA),
            new Date(System.currentTimeMillis() + AFTER_DELTA),
            new X500Name("CN=BC " + algName + " Test CA"),
            SubjectPublicKeyInfo.getInstance(caKp.getPublic().getEncoded()));

        crtBld.addExtension(Extension.basicConstraints, true, new BasicConstraints(0));
        crtBld.addExtension(Extension.keyUsage, true, new KeyUsage(KeyUsage.keyCertSign | KeyUsage.cRLSign));
        crtBld.addExtension(Extension.subjectAltPublicKeyInfo, true, SubjectAltPublicKeyInfo.getInstance(altCaKp.getPublic().getEncoded()));

        ContentSigner signer = new JcaContentSignerBuilder(algName).build(taKp.getPrivate());
        ContentSigner altSigner = new JcaContentSignerBuilder(altAlgName).build(altTaKp.getPrivate());

        return new JcaX509CertificateConverter().getCertificate(crtBld.build(signer, true, altSigner));
    }

    private static X509CRLHolder createHybridCACrl(String algName, KeyPair caKp, String altAlgName, KeyPair altCaKp)
        throws Exception
    {
        X509v2CRLBuilder crlBuilder = new X509v2CRLBuilder(
            new X500Name("CN=BC " + algName + " Test CA"),
            new Date(System.currentTimeMillis()));

        crlBuilder.addCRLEntry(BigInteger.TEN, new Date(), CRLReason.cessationOfOperation);

        ContentSigner signer = new JcaContentSignerBuilder(algName).build(caKp.getPrivate());
        ContentSigner altSigner = new JcaContentSignerBuilder(altAlgName).build(altCaKp.getPrivate());

        return crlBuilder.build(signer, true, altSigner);
    }

    private static PKCS10CertificationRequest createCACSR(String algName, KeyPair caKp)
        throws Exception
    {
        PKCS10CertificationRequestBuilder csrBld = new PKCS10CertificationRequestBuilder(
            new X500Name("CN=BC " + algName + " Test CA"),
            SubjectPublicKeyInfo.getInstance(caKp.getPublic().getEncoded()));

        ContentSigner signer = new JcaContentSignerBuilder(algName).build(caKp.getPrivate());

        return csrBld.build(signer);
    }

    private static X509Certificate createEECertificate(String algName, KeyPair caKp, KeyPair eeKp)
        throws Exception
    {
        X509v3CertificateBuilder crtBld = new X509v3CertificateBuilder(
            new X500Name("CN=BC " + algName + " Test CA"),
            generateSerialNumber(),
            new Date(System.currentTimeMillis() - BEFORE_DELTA),
            new Date(System.currentTimeMillis() + AFTER_DELTA),
            new X500Name("CN=BC " + algName + " Test EE"),
            SubjectPublicKeyInfo.getInstance(eeKp.getPublic().getEncoded()));

        crtBld.addExtension(Extension.basicConstraints, true, new BasicConstraints(false));
        crtBld.addExtension(Extension.keyUsage, true, new KeyUsage(KeyUsage.digitalSignature));

        ContentSigner signer = new JcaContentSignerBuilder(algName).build(caKp.getPrivate());

        return new JcaX509CertificateConverter().getCertificate(crtBld.build(signer));
    }

    private static PKCS10CertificationRequest createEECSR(String algName, KeyPair eeKp)
        throws Exception
    {
        PKCS10CertificationRequestBuilder csrBld = new PKCS10CertificationRequestBuilder(
            new X500Name("CN=BC " + algName + " Test EE"),
            SubjectPublicKeyInfo.getInstance(eeKp.getPublic().getEncoded()));

        ContentSigner signer = new JcaContentSignerBuilder(algName).build(eeKp.getPrivate());

        return csrBld.build(signer);
    }

    private static X509Certificate createDilithiumECNistP256Composite()
        throws Exception
    {
        //
        // set up the keys
        //
        KeyPairGenerator ecKpg = KeyPairGenerator.getInstance("EC", "BC");

        ecKpg.initialize(new ECGenParameterSpec("P-256"));

        KeyPair ecKp = ecKpg.generateKeyPair();

        PrivateKey ecPriv = ecKp.getPrivate();
        PublicKey ecPub = ecKp.getPublic();

        KeyPairGenerator dilKpg = KeyPairGenerator.getInstance("Dilithium", "BCPQC");

        dilKpg.initialize(DilithiumParameterSpec.dilithium3);

        KeyPair dilKp = dilKpg.generateKeyPair();

        PrivateKey dilPriv = dilKp.getPrivate();
        PublicKey dilPub = dilKp.getPublic();

        //
        // distinguished name table.
        //
        X500Name issuer = new X500Name("CN=BC " + "SHA256-ECDSA(P256)-Dilithium3" + " Test TA");

        //
        // create the certificate - version 3
        //
        CompositeAlgorithmSpec compAlgSpec = new CompositeAlgorithmSpec.Builder()
            .add("SHA256withECDSA")
            .add("Dilithium3")
            .build();
        CompositePublicKey compPub = new CompositePublicKey(ecPub, dilPub);
        CompositePrivateKey compPrivKey = new CompositePrivateKey(ecPriv, dilPriv);

        ContentSigner sigGen = new JcaContentSignerBuilder("COMPOSITE",
            compAlgSpec).build(compPrivKey);

        X509v3CertificateBuilder certGen = new JcaX509v3CertificateBuilder(
            issuer,
            BigInteger.valueOf(1),
            new Date(System.currentTimeMillis() - 50000), new Date(System.currentTimeMillis() + 50000), issuer,
            compPub);

        X509CertificateHolder compCertHldr = certGen.build(sigGen);

        return checkCompositeCertificate(compCertHldr, ecPub, dilPub, compPub);
    }

    private static X509Certificate createDilithiumECBrainPoolComposite()
        throws Exception
    {
        //
        // set up the keys
        //
        KeyPairGenerator ecKpg = KeyPairGenerator.getInstance("EC", "BC");

        ecKpg.initialize(new ECGenParameterSpec("brainpoolP256r1"));

        KeyPair ecKp = ecKpg.generateKeyPair();

        PrivateKey ecPriv = ecKp.getPrivate();
        PublicKey ecPub = ecKp.getPublic();

        KeyPairGenerator dilKpg = KeyPairGenerator.getInstance("Dilithium", "BCPQC");

        dilKpg.initialize(DilithiumParameterSpec.dilithium3);

        KeyPair dilKp = dilKpg.generateKeyPair();

        PrivateKey dilPriv = dilKp.getPrivate();
        PublicKey dilPub = dilKp.getPublic();

        //
        // distinguished name table.
        //
        X500Name issuer = new X500Name("CN=BC " + "SHA256-ECDSA(BrainpoolP256)-Dilithium3" + " Test TA");

        //
        // create the certificate - version 3
        //
        CompositeAlgorithmSpec compAlgSpec = new CompositeAlgorithmSpec.Builder()
            .add("SHA256withECDSA")
            .add("Dilithium3")
            .build();
        CompositePublicKey compPub = new CompositePublicKey(ecPub, dilPub);
        CompositePrivateKey compPrivKey = new CompositePrivateKey(ecPriv, dilPriv);

        ContentSigner sigGen = new JcaContentSignerBuilder("COMPOSITE",
            compAlgSpec).build(compPrivKey);

        X509v3CertificateBuilder certGen = new JcaX509v3CertificateBuilder(
            issuer,
            BigInteger.valueOf(1),
            new Date(System.currentTimeMillis() - 50000), new Date(System.currentTimeMillis() + 50000), issuer,
            compPub);

        X509CertificateHolder compCertHldr = certGen.build(sigGen);

        return checkCompositeCertificate(compCertHldr, ecPub, dilPub, compPub);
    }

    private static X509Certificate createDilithiumEd25519Composite()
        throws Exception
    {
        //
        // set up the keys
        //
        KeyPairGenerator ecKpg = KeyPairGenerator.getInstance("EDDSA", "BC");

        ecKpg.initialize(new EdDSAParameterSpec(EdDSAParameterSpec.Ed25519));

        KeyPair ecKp = ecKpg.generateKeyPair();

        PrivateKey ecPriv = ecKp.getPrivate();
        PublicKey ecPub = ecKp.getPublic();

        KeyPairGenerator dilKpg = KeyPairGenerator.getInstance("Dilithium", "BCPQC");

        dilKpg.initialize(DilithiumParameterSpec.dilithium3);

        KeyPair dilKp = dilKpg.generateKeyPair();

        PrivateKey dilPriv = dilKp.getPrivate();
        PublicKey dilPub = dilKp.getPublic();

        //
        // distinguished name table.
        //
        X500Name issuer = new X500Name("CN=BC " + "ED25519-Dilithium3" + " Test TA");

        //
        // create the certificate - version 3
        //
        CompositeAlgorithmSpec compAlgSpec = new CompositeAlgorithmSpec.Builder()
            .add("Ed25519")
            .add("Dilithium3")
            .build();
        CompositePublicKey compPub = new CompositePublicKey(ecPub, dilPub);
        CompositePrivateKey compPrivKey = new CompositePrivateKey(ecPriv, dilPriv);

        ContentSigner sigGen = new JcaContentSignerBuilder("COMPOSITE",
            compAlgSpec).build(compPrivKey);

        X509v3CertificateBuilder certGen = new JcaX509v3CertificateBuilder(
            issuer,
            BigInteger.valueOf(1),
            new Date(System.currentTimeMillis() - 50000), new Date(System.currentTimeMillis() + 50000), issuer,
            compPub);

        X509CertificateHolder compCertHldr = certGen.build(sigGen);

        return checkCompositeCertificate(compCertHldr, ecPub, dilPub, compPub);
    }

    private static X509Certificate checkCompositeCertificate(X509CertificateHolder compCertHldr, PublicKey ecPub, PublicKey dilPub, CompositePublicKey compPub)
        throws OperatorCreationException, CertException, CertificateException, NoSuchAlgorithmException, InvalidKeyException, NoSuchProviderException, SignatureException
    {
        ContentVerifierProvider vProv = new JcaContentVerifierProviderBuilder().build(compPub);

        if (!compCertHldr.isSignatureValid(vProv))
        {
            throw new IllegalStateException("composite failed to verify");
        }

        vProv = new JcaContentVerifierProviderBuilder().build(ecPub);

        if (!compCertHldr.isSignatureValid(vProv))
        {
            throw new IllegalStateException("classic failed to verify");
        }

        vProv = new JcaContentVerifierProviderBuilder().build(dilPub);

        if (!compCertHldr.isSignatureValid(vProv))
        {
            throw new IllegalStateException("pqc failed to verify");
        }

        X509Certificate cert = new JcaX509CertificateConverter().setProvider("BC").getCertificate(compCertHldr);

        cert.checkValidity(new Date());

        //
        // check verifies in general
        //
        cert.verify(compPub);

        cert.verify(ecPub);      // ec key only

        cert.verify(ecPub, "BC");      // ec key only

        //
        // check verifies with contained key
        //
        cert.verify(cert.getPublicKey());

        return cert;
    }

    private static void derOutput(File parent, String name, ASN1Encodable obj)
        throws Exception
    {
        OutputStream fOut = new FileOutputStream(new File(parent, name));


        fOut.write(obj.toASN1Primitive().getEncoded(ASN1Encoding.DER));
        fOut.close();
    }

    private static void derOutput(File parent, String name, Key obj)
        throws Exception
    {
        OutputStream fOut = new FileOutputStream(new File(parent, name));


        fOut.write(obj.getEncoded());
        fOut.close();
    }

    private static void derOutput(File parent, String name, X509Certificate obj)
        throws Exception
    {
        OutputStream fOut = new FileOutputStream(new File(parent, name));


        fOut.write(obj.getEncoded());
        fOut.close();
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

    public static void main(String[] args)
        throws Exception
    {
        Security.insertProviderAt(new BouncyCastleProvider(), 1);
        Security.insertProviderAt(new BouncyCastlePQCProvider(), 2);

        File aDir = new File("artifacts");

        aDir.mkdir();

        int count = 0;
        for (ASN1ObjectIdentifier oid: algorithms)
        {
            KeyPairGenerator kpGen = KeyPairGenerator.getInstance(oid.getId());

            KeyPair taKp = kpGen.generateKeyPair();
            KeyPair caKp = kpGen.generateKeyPair();
            KeyPair eeKp = kpGen.generateKeyPair();

            X509Certificate taCert = createTACertificate(algNames[count], taKp);
            X509CRLHolder taCrl = createTACrl(algNames[count], taKp);
            PKCS10CertificationRequest caCsr = createCACSR(algNames[count], eeKp);
            X509Certificate caCert = createCACertificate(algNames[count], taKp, caKp);
            X509CRLHolder caCrl = createCACrl(algNames[count], caKp);
            PKCS10CertificationRequest eeCsr = createEECSR(algNames[count], eeKp);
            X509Certificate eeCert = createEECertificate(algNames[count], caKp, eeKp);

            count++;

            File oidDir = new File(aDir, oid.getId());

            oidDir.mkdir();

            File taDir = new File(oidDir, "ta");

            taDir.mkdir();

            pemOutput(taDir, "ta.pem", taCert);
            pemOutput(taDir, "ta_priv.pem", taKp.getPrivate());
            pemOutput(taDir, "ta_pub.pem", taKp.getPublic());
            derOutput(taDir, "ta.der", taCert);
            derOutput(taDir, "ta_priv.der", taKp.getPrivate());
            derOutput(taDir, "ta_pub.der", taKp.getPublic());

            File caDir = new File(oidDir, "ca");

            caDir.mkdir();

            derOutput(caDir, "ca.csr", caCsr.toASN1Structure());
            pemOutput(caDir, "ca.pem", caCert);
            pemOutput(caDir, "ca_priv.pem", caKp.getPrivate());
            pemOutput(caDir, "ca_pub.pem", caKp.getPublic());
            derOutput(caDir, "ca.der", caCert);
            derOutput(caDir, "ca_priv.der", caKp.getPrivate());
            derOutput(caDir, "ca_pub.der", caKp.getPublic());

            File eeDir = new File(oidDir, "ee");

            eeDir.mkdir();

            derOutput(eeDir, "cert.csr", eeCsr.toASN1Structure());
            pemOutput(eeDir, "cert.pem", eeCert);
            pemOutput(eeDir, "cert_priv.pem", eeKp.getPrivate());
            pemOutput(eeDir, "cert_pub.pem", eeKp.getPublic());
            derOutput(eeDir, "cert.der", eeCert);
            derOutput(eeDir, "cert_priv.der", eeKp.getPrivate());
            derOutput(eeDir, "cert_pub.der", eeKp.getPublic());

            File crlDir = new File(oidDir, "crl");

            crlDir.mkdir();

            derOutput(crlDir, "crl_ta.crl", taCrl.toASN1Structure());
            derOutput(crlDir, "crl_ca.crl", caCrl.toASN1Structure());
        }

        File oidDir = new File(aDir, X9ObjectIdentifiers.ecdsa_with_SHA256.getId());

        KeyPairGenerator kpGen = KeyPairGenerator.getInstance("EC");
        KeyPairGenerator altKpGen = KeyPairGenerator.getInstance(BCObjectIdentifiers.dilithium3.getId());

        KeyPair taKp = kpGen.generateKeyPair();
        KeyPair altTaKp = altKpGen.generateKeyPair();

        X509Certificate taCert = createHybridTACertificate("SHA256withECDSA", taKp, "Dilithium3", altTaKp);
        X509CRLHolder taCrl = createHybridTACrl("SHA256withECDSA", taKp, "Dilithium3", altTaKp);

        oidDir.mkdir();

        File taDir = new File(oidDir, "ta");

        taDir.mkdir();

        pemOutput(taDir, "ta.pem", taCert);

        KeyPair caKp = kpGen.generateKeyPair();
        KeyPair altCaKp = altKpGen.generateKeyPair();

        X509Certificate caCert = createHybridCACertificate("SHA256withECDSA", taKp, caKp, "Dilithium3", altTaKp, altCaKp);
        X509CRLHolder caCrl = createHybridCACrl("SHA256withECDSA", caKp, "Dilithium3", altCaKp);

        File caDir = new File(oidDir, "ca");

        caDir.mkdir();

        pemOutput(caDir, "ca.pem", caCert);

        File crlDir = new File(oidDir, "crl");

        crlDir.mkdir();

        derOutput(crlDir, "crl_ta.crl", taCrl.toASN1Structure());
        derOutput(crlDir, "crl_ca.crl", caCrl.toASN1Structure());

        //
        // composite
        //
        oidDir = new File(aDir, MiscObjectIdentifiers.id_composite_key.getId());

        oidDir.mkdir();

        taDir = new File(oidDir, "ta");

        taDir.mkdir();

        taCert = createDilithiumECNistP256Composite();

        pemOutput(taDir, "ta-ecp256Dil3.pem", taCert);

        taCert = createDilithiumECBrainPoolComposite();

        pemOutput(taDir, "ta-ecbrainp256Dil3.pem", taCert);

        taCert = createDilithiumEd25519Composite();

        pemOutput(taDir, "ta-ed25519Dil3.pem", taCert);

        taCert = createDilithiumEd25519Composite();

        pemOutput(taDir, "ta-ed25519Dil3.pem", taCert);
    }
}
