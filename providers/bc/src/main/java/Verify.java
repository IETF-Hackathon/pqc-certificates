import java.io.ByteArrayInputStream;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.security.KeyFactory;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.SecureRandom;
import java.security.Security;
import java.security.cert.CertificateException;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;
import java.security.spec.PKCS8EncodedKeySpec;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

import javax.crypto.KeyGenerator;

import org.bouncycastle.asn1.pkcs.PrivateKeyInfo;
import org.bouncycastle.asn1.x509.AuthorityKeyIdentifier;
import org.bouncycastle.asn1.x509.Certificate;
import org.bouncycastle.asn1.x509.Extensions;
import org.bouncycastle.asn1.x509.SubjectKeyIdentifier;
import org.bouncycastle.asn1.x509.SubjectPublicKeyInfo;
import org.bouncycastle.cert.X509CertificateHolder;
import org.bouncycastle.crypto.EncapsulatedSecretExtractor;
import org.bouncycastle.crypto.EncapsulatedSecretGenerator;
import org.bouncycastle.crypto.SecretWithEncapsulation;
import org.bouncycastle.crypto.kems.CMCEKEMExtractor;
import org.bouncycastle.crypto.kems.CMCEKEMGenerator;
import org.bouncycastle.crypto.kems.FrodoKEMExtractor;
import org.bouncycastle.crypto.kems.FrodoKEMGenerator;
import org.bouncycastle.crypto.kems.MLKEMExtractor;
import org.bouncycastle.crypto.kems.MLKEMGenerator;
import org.bouncycastle.crypto.params.AsymmetricKeyParameter;
import org.bouncycastle.crypto.params.CMCEPrivateKeyParameters;
import org.bouncycastle.crypto.params.CMCEPublicKeyParameters;
import org.bouncycastle.crypto.params.FrodoKEMPrivateKeyParameters;
import org.bouncycastle.crypto.params.FrodoKEMPublicKeyParameters;
import org.bouncycastle.crypto.params.MLKEMPrivateKeyParameters;
import org.bouncycastle.crypto.params.MLKEMPublicKeyParameters;
import org.bouncycastle.jcajce.CompositePrivateKey;
import org.bouncycastle.jcajce.CompositePublicKey;
import org.bouncycastle.jcajce.SecretKeyWithEncapsulation;
import org.bouncycastle.jcajce.spec.KEMExtractSpec;
import org.bouncycastle.jcajce.spec.KEMGenerateSpec;
import org.bouncycastle.jce.provider.BouncyCastleProvider;
import org.bouncycastle.openssl.PEMParser;
import org.bouncycastle.pqc.crypto.ntru.NTRUKEMExtractor;
import org.bouncycastle.pqc.crypto.ntru.NTRUKEMGenerator;
import org.bouncycastle.pqc.crypto.ntru.NTRUPrivateKeyParameters;
import org.bouncycastle.pqc.crypto.ntru.NTRUPublicKeyParameters;
import org.bouncycastle.util.Arrays;
import org.bouncycastle.util.io.Streams;

/**
 * Automated verifier used by the CI "bc_validation" job (see src/test_certs_r5.sh).
 * <p>
 * Results are printed to stdout as CSV rows in the R5 format, "oid,type,Y|N"; see
 * docs/compat_matrix_instructions.md for the meaning of each type. Diagnostics go to stderr.
 * <p>
 * For a zip file it checks:
 * <ul>
 * <li>every self-signed trust anchor ("_ta"): the "cert" self-signature check.</li>
 * <li>every KEM end-entity certificate ("_ee.der"): the "cert" signature check against its trust
 * anchor and, if BC supports the KEM, a check of each private key form ("priv", "seed",
 * "expandedkey", "both") against the supplied ciphertext and shared secret, plus "consistent".</li>
 * </ul>
 */
public class Verify
{
    private static final String[] KEM_KEY_FORMS = { "priv", "seed", "expandedkey", "both" };

    private static final SecureRandom random = new SecureRandom();

    public static void main(String[] args)
        throws Exception
    {
        Security.addProvider(new BouncyCastleProvider());

        CertificateFactory certFact = CertificateFactory.getInstance("X.509", "BC");

        if (args.length != 2)
        {
            System.out.println("usage: " + "Verify self-signed <certfile>");
            System.exit(1);
        }
        else if (args[0].equals("self-signed"))
        {
            if (args[1].endsWith(".pem") || args[1].endsWith(".der"))
            {
                FileInputStream input = new FileInputStream(args[1]);
                checkTrustAnchor(certFact, args[1], input, null);
                input.close();
            }
            else if (args[1].endsWith(".zip"))
            {
                ZipFile zipFile = new ZipFile(args[1]);

                // trust anchors first, they are also the issuers for the KEM end-entity certificates.
                List<X509Certificate> trustAnchors = new ArrayList<X509Certificate>();
                Set<String> trustAnchorOids = new HashSet<String>();
                for (Enumeration<? extends ZipEntry> en = zipFile.entries(); en.hasMoreElements(); )
                {
                    ZipEntry entry = en.nextElement();
                    String zipName = entry.getName();
                    if (isOldName(zipName))
                    {
                        continue;
                    }

                    if (zipName.contains("_ta") && (zipName.endsWith(".pem") || zipName.endsWith(".der")))
                    {
                        String oid = checkTrustAnchor(certFact, zipName, zipFile.getInputStream(entry), trustAnchors);
                        if (oid != null)
                        {
                            trustAnchorOids.add(oid);
                        }
                    }
                }

                for (Enumeration<? extends ZipEntry> en = zipFile.entries(); en.hasMoreElements(); )
                {
                    ZipEntry entry = en.nextElement();
                    String zipName = entry.getName();
                    if (isOldName(zipName) || baseName(zipName).startsWith("external_"))
                    {
                        continue;       // "external_" certificates only carry a reference to the public key
                    }

                    if (zipName.endsWith("_ee.der"))
                    {
                        try
                        {
                            checkKemEndEntity(certFact, zipFile, zipName, trustAnchors, trustAnchorOids);
                        }
                        catch (Exception e)
                        {
                            System.err.println(zipName + ": cannot read the KEM artifacts: " + e);
                        }
                    }
                }
                zipFile.close();
            }
            else
            {
                System.out.println("unknown file: " + args[1]);
                System.exit(1);
            }
        }
        else
        {
            System.out.println("unknown command: " + args[0]);
            System.exit(1);
        }

        System.exit(0);
    }

    private static boolean isOldName(String zipName)
    {
        return zipName.contains("chameleon")
            || zipName.contains("catalyst")
            || zipName.contains("composite");     // filter out old names
    }

    private static String baseName(String zipName)
    {
        return zipName.substring(zipName.lastIndexOf('/') + 1);
    }

    private static String createResultName(String fileName)
    {
        String oid = fileName.substring(fileName.lastIndexOf('-') + 1);
        oid = oid.substring(0, oid.indexOf("_"));
        return oid;
    }

    private static void report(String oid, String type, boolean passed)
    {
        System.out.println(oid + "," + type + "," + (passed ? "Y" : "N"));
    }

    private static void reportFailure(String oid, String type, String fileName, String reason)
    {
        System.err.println(fileName + ": " + type + " check failed: " + reason);
        report(oid, type, false);
    }

    private static X509Certificate readCertificate(CertificateFactory certFact, String fileName, InputStream input)
        throws IOException, CertificateException
    {
        byte[] data;
        if (fileName.endsWith(".pem"))
        {
            PEMParser pemPrs = new PEMParser(new InputStreamReader(input));

            X509CertificateHolder hld = (X509CertificateHolder)pemPrs.readObject();

            pemPrs.close();

            if (hld == null)
            {
                throw new CertificateException("no certificate found in PEM file");
            }
            data = hld.getEncoded();
        }
        else
        {
            data = Streams.readAll(input);
        }

        return (X509Certificate)certFact.generateCertificate(new ByteArrayInputStream(data));
    }

    // Check the self-signature of a trust anchor. If trustAnchors is not null a parsed certificate is added to it.
    // Returns the OID reported, or null if the file name has none.
    private static String checkTrustAnchor(CertificateFactory certFact, String fileName, InputStream input, List<X509Certificate> trustAnchors)
    {
        String oid;
        try
        {
            oid = createResultName(fileName);
        }
        catch (RuntimeException e)
        {
            System.err.println(fileName + ": no OID in file name, skipped");
            return null;
        }

        X509Certificate cert;
        try
        {
            cert = readCertificate(certFact, fileName, input);
        }
        catch (Exception e)
        {
            reportFailure(oid, "cert", fileName, "cannot parse certificate: " + e);
            return oid;
        }

        if (trustAnchors != null)
        {
            trustAnchors.add(cert);
        }

        try
        {
            cert.verify(cert.getPublicKey());

            report(oid, "cert", true);
        }
        catch (Exception e)
        {
            report(oid, "cert", false);
        }

        return oid;
    }

    // Check a KEM end-entity certificate and, where present, its private keys, ciphertext and shared secret.
    private static void checkKemEndEntity(CertificateFactory certFact, ZipFile zipFile, String eeName,
                                          List<X509Certificate> trustAnchors, Set<String> trustAnchorOids)
        throws IOException
    {
        String oid;
        try
        {
            oid = createResultName(eeName);
        }
        catch (RuntimeException e)
        {
            System.err.println(eeName + ": no OID in file name, skipped");
            return;
        }

        if (trustAnchorOids.contains(oid))
        {
            // a second "cert" row for the OID would conflict with the trust anchor's.
            System.err.println(eeName + ": the zip also has a trust anchor for " + oid + ", skipped");
            return;
        }

        String base = eeName.substring(0, eeName.length() - "_ee.der".length());

        X509Certificate ee;
        try
        {
            ee = readCertificate(certFact, eeName, zipFile.getInputStream(zipFile.getEntry(eeName)));
        }
        catch (Exception e)
        {
            reportFailure(oid, "cert", eeName, "cannot parse certificate: " + e);
            return;
        }

        // cert: the end-entity certificate is signed by its trust anchor, which should be in the zip.
        Boolean issuedByTrustAnchor = checkIssuedByTrustAnchor(ee, trustAnchors);
        if (issuedByTrustAnchor == null)
        {
            System.err.println(eeName + ": no trust anchor in the zip matches the issuer " + ee.getIssuerX500Principal() + ", cert check skipped");
        }
        else if (issuedByTrustAnchor.booleanValue())
        {
            report(oid, "cert", true);
        }
        else
        {
            reportFailure(oid, "cert", eeName, "signature does not verify with the issuing trust anchor");
        }

        Kem kem;
        try
        {
            kem = Kem.forCertificate(ee);
        }
        catch (Exception e)
        {
            kem = null;
        }

        if (kem == null)
        {
            // not a KEM BC can drive here: a result would say nothing about the artifact, so leave it out.
            System.err.println(eeName + ": KEM not supported, private key checks skipped");
            return;
        }

        byte[] ciphertext = readEntry(zipFile, base + "_ciphertext.bin");
        byte[] sharedSecret = readEntry(zipFile, base + "_ss.bin");

        List<Object> privateKeys = new ArrayList<Object>();
        boolean allKeysLoaded = true;
        for (int i = 0; i != KEM_KEY_FORMS.length; i++)
        {
            String form = KEM_KEY_FORMS[i];
            String keyName = form.equals("priv") ? base + "_priv.der" : base + "_" + form + "_priv.der";
            byte[] privDer = readEntry(zipFile, keyName);
            if (privDer == null)
            {
                continue;
            }

            // the private key form is well formed and, if they were supplied, decapsulates
            // the ciphertext to the shared secret.
            Object privateKey;
            try
            {
                privateKey = kem.loadPrivateKey(privDer);
                privateKeys.add(privateKey);
            }
            catch (Exception e)
            {
                allKeysLoaded = false;
                reportFailure(oid, form, keyName, "cannot load private key: " + e);
                continue;
            }

            if (ciphertext == null || sharedSecret == null)
            {
                report(oid, form, true);
                continue;
            }

            try
            {
                if (Arrays.areEqual(sharedSecret, kem.decapsulate(privateKey, ciphertext)))
                {
                    report(oid, form, true);
                }
                else
                {
                    reportFailure(oid, form, keyName, "decapsulated secret does not match " + base + "_ss.bin");
                }
            }
            catch (Exception e)
            {
                reportFailure(oid, form, keyName, "decapsulation failed: " + e);
            }
        }

        // consistent: every private key form belongs to the certificate's public key. Checked by
        // encapsulating to the certificate's public key and decapsulating with each private key form.
        if (privateKeys.isEmpty() && allKeysLoaded)
        {
            return;     // only a certificate, nothing to compare it with.
        }

        if (!allKeysLoaded)
        {
            reportFailure(oid, "consistent", eeName, "not every private key form could be loaded");
            return;
        }

        try
        {
            byte[][] secretAndEncapsulation = kem.encapsulate();
            for (int i = 0; i != privateKeys.size(); i++)
            {
                if (!Arrays.areEqual(secretAndEncapsulation[0], kem.decapsulate(privateKeys.get(i), secretAndEncapsulation[1])))
                {
                    reportFailure(oid, "consistent", eeName, "a private key form does not match the certificate's public key");
                    return;
                }
            }
            report(oid, "consistent", true);
        }
        catch (Exception e)
        {
            reportFailure(oid, "consistent", eeName, "encapsulation round trip failed: " + e);
        }
    }

    // returns true if ee is signed by a candidate issuer, false if no candidate issuer verifies it, and
    // null if the zip has no candidate issuer. A trust anchor is a candidate issuer if its subject matches
    // the issuer of ee, or its subject key identifier matches the authority key identifier of ee (some
    // artifacts name one trust anchor as the issuer but are signed by another).
    private static Boolean checkIssuedByTrustAnchor(X509Certificate ee, List<X509Certificate> trustAnchors)
    {
        byte[] authorityKeyId = keyIdentifier(ee, true);

        boolean issuerFound = false;
        for (int i = 0; i != trustAnchors.size(); i++)
        {
            X509Certificate ta = trustAnchors.get(i);
            boolean subjectMatches = ta.getSubjectX500Principal().equals(ee.getIssuerX500Principal());
            boolean keyIdMatches = authorityKeyId != null && Arrays.areEqual(authorityKeyId, keyIdentifier(ta, false));

            if (!subjectMatches && !keyIdMatches)
            {
                continue;
            }

            issuerFound = true;
            try
            {
                ee.verify(ta.getPublicKey());
                return Boolean.TRUE;
            }
            catch (Exception e)
            {
                // the zip may hold several trust anchors with the same subject, try the next one.
            }
        }

        return issuerFound ? Boolean.FALSE : null;
    }

    // the authority (or subject) key identifier of cert, null if it has none or it cannot be read.
    private static byte[] keyIdentifier(X509Certificate cert, boolean authority)
    {
        try
        {
            Extensions extensions = Certificate.getInstance(cert.getEncoded()).getTBSCertificate().getExtensions();
            if (extensions == null)
            {
                return null;
            }

            if (authority)
            {
                AuthorityKeyIdentifier aki = AuthorityKeyIdentifier.fromExtensions(extensions);
                return aki == null ? null : aki.getKeyIdentifier();
            }

            SubjectKeyIdentifier ski = SubjectKeyIdentifier.fromExtensions(extensions);
            return ski == null ? null : ski.getKeyIdentifier();
        }
        catch (Exception e)
        {
            return null;
        }
    }

    private static byte[] readEntry(ZipFile zipFile, String name)
        throws IOException
    {
        ZipEntry entry = zipFile.getEntry(name);
        if (entry == null)
        {
            return null;
        }

        InputStream input = zipFile.getInputStream(entry);
        byte[] data = Streams.readAll(input);
        input.close();

        return data;
    }

    /**
     * The KEM operations the checks need for one certificate's public key: ML-KEM, FrodoKEM, NTRU and
     * Classic McEliece through their low-level classes, composite ML-KEM through the JCA KEM API.
     */
    private static abstract class Kem
    {
        // returns null if BC has no KEM for the certificate's public key.
        static Kem forCertificate(X509Certificate cert)
            throws Exception
        {
            PublicKey publicKey;
            try
            {
                publicKey = cert.getPublicKey();
            }
            catch (RuntimeException e)
            {
                publicKey = null;
            }

            SubjectPublicKeyInfo keyInfo = Certificate.getInstance(cert.getEncoded()).getSubjectPublicKeyInfo();

            if (publicKey instanceof CompositePublicKey)
            {
                return new CompositeKem(publicKey, keyInfo.getAlgorithm().getAlgorithm().getId());
            }

            AsymmetricKeyParameter publicKeyParameters = createPublicKeyParameters(keyInfo);
            EncapsulatedSecretGenerator generator = createGenerator(publicKeyParameters);
            if (generator == null)
            {
                return null;
            }

            return new LowLevelKem(publicKeyParameters, generator);
        }

        // load an encoded (PKCS#8) private key, throws if it is malformed or for a different KEM.
        abstract Object loadPrivateKey(byte[] privDer)
            throws Exception;

        abstract byte[] decapsulate(Object privateKey, byte[] encapsulation)
            throws Exception;

        // returns { shared secret, encapsulation } for the certificate's public key.
        abstract byte[][] encapsulate()
            throws Exception;
    }

    private static class LowLevelKem
        extends Kem
    {
        private final AsymmetricKeyParameter publicKey;
        private final EncapsulatedSecretGenerator generator;

        LowLevelKem(AsymmetricKeyParameter publicKey, EncapsulatedSecretGenerator generator)
        {
            this.publicKey = publicKey;
            this.generator = generator;
        }

        Object loadPrivateKey(byte[] privDer)
            throws Exception
        {
            AsymmetricKeyParameter privateKey = createPrivateKeyParameters(privDer);
            if (createExtractor(privateKey) == null || !kemName(privateKey).equals(kemName(publicKey)))
            {
                throw new IllegalArgumentException("not a private key for this KEM: " + privateKey.getClass().getName());
            }
            return privateKey;
        }

        byte[] decapsulate(Object privateKey, byte[] encapsulation)
            throws Exception
        {
            return createExtractor((AsymmetricKeyParameter)privateKey).extractSecret(encapsulation);
        }

        byte[][] encapsulate()
            throws Exception
        {
            SecretWithEncapsulation secret = generator.generateEncapsulated(publicKey);
            return new byte[][]{ secret.getSecret(), secret.getEncapsulation() };
        }
    }

    private static class CompositeKem
        extends Kem
    {
        private final PublicKey publicKey;
        private final String algorithm;

        CompositeKem(PublicKey publicKey, String algorithm)
        {
            this.publicKey = publicKey;
            this.algorithm = algorithm;
        }

        Object loadPrivateKey(byte[] privDer)
            throws Exception
        {
            String keyAlg = PrivateKeyInfo.getInstance(privDer).getPrivateKeyAlgorithm().getAlgorithm().getId();
            PrivateKey privateKey = KeyFactory.getInstance(keyAlg, "BC").generatePrivate(new PKCS8EncodedKeySpec(privDer));
            if (!(privateKey instanceof CompositePrivateKey))
            {
                throw new IllegalArgumentException("not a composite private key: " + privateKey.getClass().getName());
            }
            return privateKey;
        }

        byte[] decapsulate(Object privateKey, byte[] encapsulation)
            throws Exception
        {
            KeyGenerator extractor = KeyGenerator.getInstance(algorithm, "BC");
            extractor.init(new KEMExtractSpec.Builder((PrivateKey)privateKey, encapsulation, "AES", 256).withNoKdf().build());
            return ((SecretKeyWithEncapsulation)extractor.generateKey()).getEncoded();
        }

        byte[][] encapsulate()
            throws Exception
        {
            KeyGenerator generator = KeyGenerator.getInstance(algorithm, "BC");
            generator.init(new KEMGenerateSpec.Builder(publicKey, "AES", 256).withNoKdf().build(), random);
            SecretKeyWithEncapsulation secret = (SecretKeyWithEncapsulation)generator.generateKey();
            return new byte[][]{ secret.getEncoded(), secret.getEncapsulation() };
        }
    }

    private static AsymmetricKeyParameter createPublicKeyParameters(SubjectPublicKeyInfo keyInfo)
        throws IOException
    {
        try
        {
            return org.bouncycastle.crypto.util.PublicKeyFactory.createKey(keyInfo);
        }
        catch (Exception e)
        {
            return org.bouncycastle.pqc.crypto.util.PublicKeyFactory.createKey(keyInfo);
        }
    }

    private static AsymmetricKeyParameter createPrivateKeyParameters(byte[] privDer)
        throws IOException
    {
        try
        {
            return org.bouncycastle.crypto.util.PrivateKeyFactory.createKey(privDer);
        }
        catch (Exception e)
        {
            return org.bouncycastle.pqc.crypto.util.PrivateKeyFactory.createKey(privDer);
        }
    }

    // the KEM a low-level key belongs to, or null if the checks do not support it.
    private static String kemName(AsymmetricKeyParameter key)
    {
        if (key instanceof MLKEMPublicKeyParameters || key instanceof MLKEMPrivateKeyParameters)
        {
            return "ML-KEM";
        }
        if (key instanceof FrodoKEMPublicKeyParameters || key instanceof FrodoKEMPrivateKeyParameters)
        {
            return "FrodoKEM";
        }
        if (key instanceof NTRUPublicKeyParameters || key instanceof NTRUPrivateKeyParameters)
        {
            return "NTRU";
        }
        if (key instanceof CMCEPublicKeyParameters || key instanceof CMCEPrivateKeyParameters)
        {
            return "Classic McEliece";
        }
        return null;
    }

    private static EncapsulatedSecretGenerator createGenerator(AsymmetricKeyParameter publicKey)
    {
        if (publicKey instanceof MLKEMPublicKeyParameters)
        {
            return new MLKEMGenerator(random);
        }
        if (publicKey instanceof FrodoKEMPublicKeyParameters)
        {
            return new FrodoKEMGenerator(random);
        }
        if (publicKey instanceof NTRUPublicKeyParameters)
        {
            return new NTRUKEMGenerator(random);
        }
        if (publicKey instanceof CMCEPublicKeyParameters)
        {
            return new CMCEKEMGenerator(random);
        }
        return null;
    }

    private static EncapsulatedSecretExtractor createExtractor(AsymmetricKeyParameter privateKey)
    {
        if (privateKey instanceof MLKEMPrivateKeyParameters)
        {
            return new MLKEMExtractor((MLKEMPrivateKeyParameters)privateKey);
        }
        if (privateKey instanceof FrodoKEMPrivateKeyParameters)
        {
            return new FrodoKEMExtractor((FrodoKEMPrivateKeyParameters)privateKey);
        }
        if (privateKey instanceof NTRUPrivateKeyParameters)
        {
            return new NTRUKEMExtractor((NTRUPrivateKeyParameters)privateKey);
        }
        if (privateKey instanceof CMCEPrivateKeyParameters)
        {
            return new CMCEKEMExtractor((CMCEPrivateKeyParameters)privateKey);
        }
        return null;
    }
}
