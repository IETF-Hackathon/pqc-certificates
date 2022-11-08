import java.io.File;
import java.io.FileWriter;
import java.math.BigInteger;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.MessageDigest;
import java.security.Security;
import java.security.cert.X509CRL;
import java.security.cert.X509Certificate;
import java.util.Date;

import org.bouncycastle.asn1.ASN1ObjectIdentifier;
import org.bouncycastle.asn1.bc.BCObjectIdentifiers;
import org.bouncycastle.asn1.x500.X500Name;
import org.bouncycastle.asn1.x509.BasicConstraints;
import org.bouncycastle.asn1.x509.CRLReason;
import org.bouncycastle.asn1.x509.Extension;
import org.bouncycastle.asn1.x509.KeyUsage;
import org.bouncycastle.asn1.x509.SubjectPublicKeyInfo;
import org.bouncycastle.cert.X509v2CRLBuilder;
import org.bouncycastle.cert.X509v3CertificateBuilder;
import org.bouncycastle.cert.jcajce.JcaX509CRLConverter;
import org.bouncycastle.cert.jcajce.JcaX509CertificateConverter;
import org.bouncycastle.jce.provider.BouncyCastleProvider;
import org.bouncycastle.openssl.jcajce.JcaPEMWriter;
import org.bouncycastle.operator.ContentSigner;
import org.bouncycastle.operator.jcajce.JcaContentSignerBuilder;
import org.bouncycastle.pkcs.PKCS10CertificationRequest;
import org.bouncycastle.pkcs.PKCS10CertificationRequestBuilder;
import org.bouncycastle.pqc.jcajce.provider.BouncyCastlePQCProvider;
import org.bouncycastle.util.Arrays;
import org.bouncycastle.util.Pack;

public class ArtifactGenerator
{
    private static final ASN1ObjectIdentifier[] algorithms =
        {
            BCObjectIdentifiers.dilithium2,
            BCObjectIdentifiers.dilithium3,
            BCObjectIdentifiers.dilithium5,
            BCObjectIdentifiers.dilithium2_aes,
            BCObjectIdentifiers.dilithium3_aes,
            BCObjectIdentifiers.dilithium5_aes,
            BCObjectIdentifiers.falcon_512,
            BCObjectIdentifiers.falcon_1024
        };

    private static final String[] algNames =
        {
            "dilithium2",
            "dilithium3",
            "dilithium5",
            "dilithium2-aes",
            "dilithium3-aes",
            "dilithium5-aes",
            "falcon-512",
            "falcon-1024"
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

    private static X509CRL createTACrl(String algName, KeyPair taKp)
        throws Exception
    {
        X509v2CRLBuilder crlBuilder = new X509v2CRLBuilder(
            new X500Name("CN=BC " + algName + " Test TA"),
            new Date(System.currentTimeMillis()));

        crlBuilder.addCRLEntry(BigInteger.ONE, new Date(), CRLReason.cessationOfOperation);

        ContentSigner signer = new JcaContentSignerBuilder(algName).build(taKp.getPrivate());

        return new JcaX509CRLConverter().getCRL(crlBuilder.build(signer));
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

    private static X509CRL createCACrl(String algName, KeyPair caKp)
        throws Exception
    {
        X509v2CRLBuilder crlBuilder = new X509v2CRLBuilder(
            new X500Name("CN=BC " + algName + " Test CA"),
            new Date(System.currentTimeMillis()));

        crlBuilder.addCRLEntry(BigInteger.TEN, new Date(), CRLReason.cessationOfOperation);

        ContentSigner signer = new JcaContentSignerBuilder(algName).build(caKp.getPrivate());

        return new JcaX509CRLConverter().getCRL(crlBuilder.build(signer));
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
        Security.addProvider(new BouncyCastleProvider());
        Security.addProvider(new BouncyCastlePQCProvider());

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
            X509CRL taCrl = createTACrl(algNames[count], taKp);
            PKCS10CertificationRequest caCsr = createEECSR(algNames[count], eeKp);
            X509Certificate caCert = createCACertificate(algNames[count], taKp, caKp);
            X509CRL caCrl = createCACrl(algNames[count], caKp);
            PKCS10CertificationRequest eeCsr = createEECSR(algNames[count], eeKp);
            X509Certificate eeCert = createEECertificate(algNames[count], caKp, eeKp);

            count++;

            File oidDir = new File(aDir, oid.getId());

            oidDir.mkdir();

            File taDir = new File(oidDir, "ta");

            taDir.mkdir();

            pemOutput(taDir, "ta.der", taCert);
            pemOutput(taDir, "ta_priv.der", taKp.getPrivate());
            pemOutput(taDir, "ta_pub.der", taKp.getPublic());

            File caDir = new File(oidDir, "ca");

            caDir.mkdir();

            pemOutput(caDir, "ca.csr", caCsr);
            pemOutput(caDir, "ca.der", caCert);
            pemOutput(caDir, "ca_priv.der", caKp.getPrivate());
            pemOutput(caDir, "ca_pub.der", caKp.getPublic());

            File eeDir = new File(oidDir, "ee");

            eeDir.mkdir();

            pemOutput(eeDir, "ee.csr", eeCsr);
            pemOutput(eeDir, "ee.der", eeCert);
            pemOutput(eeDir, "ee_priv.der", eeKp.getPrivate());
            pemOutput(eeDir, "ee_pub.der", eeKp.getPublic());

            File crlDir = new File(oidDir, "crl");

            crlDir.mkdir();

            pemOutput(crlDir, "crl_ta.crl", taCrl);
            pemOutput(crlDir, "crl_ca.crl", caCrl);
        }
    }
}
