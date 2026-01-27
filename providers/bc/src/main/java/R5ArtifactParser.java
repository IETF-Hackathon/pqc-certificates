import java.io.BufferedWriter;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.security.GeneralSecurityException;
import java.security.KeyFactory;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.Security;
import java.security.Signature;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

import javax.security.auth.x500.X500Principal;

import org.bouncycastle.asn1.ASN1ObjectIdentifier;
import org.bouncycastle.asn1.misc.MiscObjectIdentifiers;
import org.bouncycastle.asn1.pkcs.PKCSObjectIdentifiers;
import org.bouncycastle.asn1.pkcs.PrivateKeyInfo;
import org.bouncycastle.asn1.x509.Extension;
import org.bouncycastle.asn1.x509.Extensions;
import org.bouncycastle.asn1.x509.SubjectPublicKeyInfo;
import org.bouncycastle.cert.CertException;
import org.bouncycastle.cert.DeltaCertificateTool;
import org.bouncycastle.cert.X509CertificateHolder;
import org.bouncycastle.cert.jcajce.JcaX509CertificateHolder;
import org.bouncycastle.jcajce.interfaces.MLDSAPrivateKey;
import org.bouncycastle.jcajce.interfaces.SLHDSAPrivateKey;
import org.bouncycastle.jce.provider.BouncyCastleProvider;
import org.bouncycastle.operator.ContentVerifierProvider;
import org.bouncycastle.operator.OperatorCreationException;
import org.bouncycastle.operator.jcajce.JcaContentVerifierProviderBuilder;
import org.bouncycastle.pqc.crypto.mlkem.MLKEMExtractor;
import org.bouncycastle.pqc.crypto.mlkem.MLKEMPrivateKeyParameters;
import org.bouncycastle.pqc.crypto.util.PrivateKeyFactory;
import org.bouncycastle.pqc.jcajce.provider.BouncyCastlePQCProvider;
import org.bouncycastle.util.Strings;
import org.bouncycastle.util.io.Streams;
import org.bouncycastle.util.io.pem.PemReader;

public class R5ArtifactParser
{
    private static Map<String, Map<String, ZipEntry>> algEntries = new HashMap<>();
    private static Map<String, Map<String, File>> fileAlgEntries = new HashMap<>();

    private static String header = "key_algorithm_oid,test_result";

    private static boolean checkCertificate(String entryName, X509Certificate subject, X509Certificate signingCert)
    {
        try
        {
            subject.verify(signingCert.getPublicKey());

            X509CertificateHolder certHolder = new X509CertificateHolder(subject.getEncoded());
            if (certHolder.hasExtensions())
            {
                Extensions exts = certHolder.getExtensions();
                Extension ext = exts.getExtension(Extension.altSignatureAlgorithm);

                if (ext != null)
                {
                    X509CertificateHolder sigHolder = new X509CertificateHolder(signingCert.getEncoded());
                    ContentVerifierProvider vProv = new JcaContentVerifierProviderBuilder().build(
                        SubjectPublicKeyInfo.getInstance(sigHolder.getExtension(Extension.subjectAltPublicKeyInfo).getParsedValue()));
                    if (!certHolder.isAlternativeSignatureValid(vProv))
                    {
                        System.err.println("Entry " + entryName + " failed to verify alt signature");
                    }
                }
            }
            return true;
        }
        catch (GeneralSecurityException | IOException | CertException | OperatorCreationException e)
        {
            System.err.println("Entry " + entryName + " failed to verify: " + e);
            return false;
        }
    }

    private static Set<String> getMatching(Set<String> inputSet, String entry)
    {
        Set<String> thisMatching = new HashSet<>();
        for (String inputEntry : inputSet)
        {
            if (inputEntry.contains(entry))
            {
                thisMatching.add(inputEntry);
            }
        }
        return thisMatching;
    }

    private static boolean isRecognizedEncoding(String name)
    {
        return name.endsWith(".pem") || name.endsWith("der");
    }

    private static boolean checkCertificate(Map<X500Principal, X509Certificate> tas, X509Certificate cert)
    {
        try
        {
            // this also covers checking for hybrid composite
            if (cert.getIssuerX500Principal().equals(cert.getSubjectX500Principal()))
            {
                cert.verify(cert.getPublicKey());
            }
            else
            {
                X500Principal signingPrincipal = cert.getIssuerX500Principal();
                X509Certificate ta = tas.get(signingPrincipal);

                cert.verify(ta.getPublicKey());
            }

            X509CertificateHolder x509CertHolder = new JcaX509CertificateHolder(cert);
            Extensions exts = x509CertHolder.getExtensions();

            if (x509CertHolder.getSignatureAlgorithm().getParameters() != null)
            {
                ASN1ObjectIdentifier sigOid = x509CertHolder.getSignatureAlgorithm().getAlgorithm();
                if (!(MiscObjectIdentifiers.id_alg_composite.equals(sigOid)
                    || PKCSObjectIdentifiers.sha256WithRSAEncryption.equals(sigOid)))
                {
                    System.err.println("warning: non-absent parameters detected in certificate signature for: "
                        + sigOid);
                }
            }

            if (exts != null)
            {
                // check catalyst
                Extension ext = exts.getExtension(Extension.altSignatureAlgorithm);

                if (ext != null)
                {
                    ContentVerifierProvider vProv = new JcaContentVerifierProviderBuilder().build(
                        SubjectPublicKeyInfo.getInstance(x509CertHolder.getExtension(Extension.subjectAltPublicKeyInfo).getParsedValue()));
                    if (!x509CertHolder.isAlternativeSignatureValid(vProv))
                    {
                        return false;
                    }
                }

                // check chameleon
                ext = exts.getExtension(new ASN1ObjectIdentifier("2.16.840.1.114027.80.6.1"));
                if (ext != null)
                {
                    X509CertificateHolder exDeltaCert = DeltaCertificateTool.extractDeltaCertificate(x509CertHolder);
                    ContentVerifierProvider verifier = new JcaContentVerifierProviderBuilder().setProvider("BC").build(exDeltaCert.getSubjectPublicKeyInfo());

                    if (!exDeltaCert.isSignatureValid(verifier))
                    {
                        return false;
                    }
                }
            }

            return true;
        }
        catch (Exception e)
        {
            return false;
        }
    }

    public static void processZipArtifacts(String producer, String zipFileName)
        throws Exception
    {
        ZipFile zipFile = new ZipFile(zipFileName);

        CertificateFactory certFact = CertificateFactory.getInstance("X.509", "BC");
        Map<String, X509Certificate> certificates = new TreeMap<>();
        Map<String, PublicKey> publicKeys = new TreeMap<>();
        Map<String, PrivateKey> privateKeys = new TreeMap<>();
        Map<String, String> cipherTexts = new TreeMap<>();
        Set<String> ignored = new HashSet<>();

        for (Enumeration<? extends ZipEntry> en = zipFile.entries(); en.hasMoreElements(); )
        {
            ZipEntry entry = en.nextElement();
            String zipName = entry.getName();

            if (zipName.endsWith(".pem"))
            {
                PemReader pemReader = new PemReader(new InputStreamReader(zipFile.getInputStream(entry)));

                X509Certificate cert = null;
                try
                {
                    cert = (X509Certificate)certFact.generateCertificate(new ByteArrayInputStream(pemReader.readPemObject().getContent()));
                    certificates.put(zipName, cert);
                }
                catch (Exception e)
                {
                    ignored.add(zipName);
                }
            }
            else if (zipName.endsWith(".der"))
            {
                byte[] derData = Streams.readAll(zipFile.getInputStream(entry));

                if (zipName.endsWith("public.der"))
                {
                    PublicKey publicKey = null;
                    try
                    {
                        SubjectPublicKeyInfo pubInfo = SubjectPublicKeyInfo.getInstance(derData);

                        KeyFactory keyFact = KeyFactory.getInstance(pubInfo.getAlgorithm().getAlgorithm().getId());

                        publicKey = (PublicKey)keyFact.generatePublic(new X509EncodedKeySpec(derData));
                        publicKeys.put(zipName, publicKey);
                    }
                    catch (Exception e)
                    {
                        ignored.add(zipName);
                    }
                }
                else if (zipName.endsWith("_priv.der"))
                {
                    PrivateKey privateKey = null;
                    try
                    {
                        PrivateKeyInfo privInfo = PrivateKeyInfo.getInstance(derData);

                        KeyFactory keyFact = KeyFactory.getInstance(privInfo.getPrivateKeyAlgorithm().getAlgorithm().getId());

                        privateKey = (PrivateKey)keyFact.generatePrivate(new PKCS8EncodedKeySpec(derData));
                        privateKeys.put(zipName, privateKey);

                        if (privateKey instanceof SLHDSAPrivateKey || privateKey instanceof MLDSAPrivateKey)
                        {
                            doSigCheck(privateKey);
                        }
                    }
                    catch (Exception e)
                    {
                        ignored.add(zipName);
                    }
                }
                else
                {
                    X509Certificate cert = null;
                    try
                    {
                        cert = (X509Certificate)certFact.generateCertificate(new ByteArrayInputStream(derData));
                        certificates.put(zipName, cert);
                    }
                    catch (Exception e)
                    {
                        ignored.add(zipName);
                    }
                }
            }
            else if (zipName.endsWith("_ss.bin"))
            {
                String baseName = zipName.substring(0, zipName.length() - "_ss.bin".length());
                try
                {
                    checkKem(zipFile, baseName);
                    cipherTexts.put(baseName + "_ciphertext.bin", baseName + "_ss.bin");
                }
                catch (Exception e)
                {
                    ignored.add(zipName);
                }
            }
            else if (zipName.endsWith("_ciphertext.bin"))
            {
                String baseName = zipName.substring(0, zipName.length() - "_ciphertext.bin".length());
                try
                {
                    checkKem(zipFile, baseName);
                    cipherTexts.put(baseName + "_ciphertext.bin", baseName + "_ss.bin");
                }
                catch (Exception e)
                {
                    ignored.add(zipName);
                }
            }
            else
            {
                if (!entry.isDirectory())
                {
                    System.err.println("non-pem entry " + zipName + " ignored");
                }
                continue;
            }
        }

        checkCertificates(producer, certificates, ignored, privateKeys, cipherTexts);
    }

    public static void doSigCheck(PrivateKey privKey)
        throws Exception
    {
        Signature sig = Signature.getInstance(privKey.getAlgorithm(), "BC");

        sig.initSign(privKey);

        sig.update(Strings.toByteArray("abc"));

        byte[] genSig = sig.sign();

        if (privKey instanceof MLDSAPrivateKey)
        {
            sig.initVerify(((MLDSAPrivateKey)privKey).getPublicKey());
        }
        else
        {
            sig.initVerify(((SLHDSAPrivateKey)privKey).getPublicKey());
        }

        sig.update(Strings.toByteArray("abc"));

        if (!sig.verify(genSig))
        {
            throw new IllegalStateException("sig failed to verify");
        }
    }

    public static void processArtifacts(String producer, String dirName)
        throws Exception
    {
        CertificateFactory certFact = CertificateFactory.getInstance("X.509", "BC");
        Map<String, X509Certificate> certificates = new TreeMap<>();
        Map<String, PublicKey> publicKeys = new TreeMap<>();
        Map<String, PrivateKey> privateKeys = new TreeMap<>();
        Map<String, String> cipherTexts = new TreeMap<>();
        Set<String> ignored = new HashSet<>();

        File artDir = new File(dirName);
        if (!artDir.isDirectory())
        {
            throw new IllegalStateException("artifact argument must point to a directory");
        }

        for (File f : getLeafs(artDir.listFiles()))
        {
            String fileName = f.getName();

            if (fileName.endsWith(".pem"))
            {
                PemReader pemReader = new PemReader(new FileReader(f));

                X509Certificate cert = null;
                try
                {
                    cert = (X509Certificate)certFact.generateCertificate(new ByteArrayInputStream(pemReader.readPemObject().getContent()));

                    certificates.put(fileName, cert);
                }
                catch (Exception e)
                {
                    ignored.add(fileName);
                }
            }
            else if (fileName.endsWith(".der"))
            {
                if (fileName.endsWith("public.der"))
                {
                    PublicKey publicKey = null;
                    try
                    {
                        byte[] derData = Streams.readAll(new FileInputStream(f));
                        SubjectPublicKeyInfo pubInfo = SubjectPublicKeyInfo.getInstance(derData);

                        KeyFactory keyFact = KeyFactory.getInstance(pubInfo.getAlgorithm().getAlgorithm().getId());

                        publicKey = (PublicKey)keyFact.generatePublic(new X509EncodedKeySpec(derData));
                        publicKeys.put(fileName, publicKey);
                    }
                    catch (Exception e)
                    {
                        ignored.add(fileName);
                    }
                }
                else if (fileName.endsWith("_priv.der"))
                {
                    PrivateKey privateKey = null;
                    try
                    {
                        byte[] derData = Streams.readAll(new FileInputStream(f));
                        PrivateKeyInfo privInfo = PrivateKeyInfo.getInstance(derData);

                        KeyFactory keyFact = KeyFactory.getInstance(privInfo.getPrivateKeyAlgorithm().getAlgorithm().getId());

                        privateKey = (PrivateKey)keyFact.generatePrivate(new PKCS8EncodedKeySpec(derData));
                        privateKeys.put(fileName, privateKey);

                        if (privateKey instanceof SLHDSAPrivateKey || privateKey instanceof MLDSAPrivateKey)
                        {
                            doSigCheck(privateKey);
                        }
                    }
                    catch (Exception e)
                    {
                        ignored.add(fileName);
                    }
                }
                else
                {
                    X509Certificate cert = null;
                    try
                    {
                        cert = (X509Certificate)certFact.generateCertificate(new ByteArrayInputStream(Streams.readAll(new FileInputStream(f))));

                        certificates.put(fileName, cert);
                    }
                    catch (Exception e)
                    {
                        ignored.add(fileName);
                    }
                }
            }
            else if (fileName.endsWith("_ss.bin"))
            {
                String baseName = fileName.substring(0, fileName.length() - "_ss.bin".length());
                try
                {
                    checkKem(f.getParentFile(), baseName);
                    cipherTexts.put(baseName + "_ciphertext.bin", baseName + "_ss.bin");
                }
                catch (Exception e)
                {
                    ignored.add(fileName);
                }
            }
            else if (fileName.endsWith("_ciphertext.bin"))
            {
                String baseName = fileName.substring(0, fileName.length() - "_ciphertext.bin".length());
                try
                {
                    checkKem(f.getParentFile(), baseName);
                    cipherTexts.put(baseName + "_ciphertext.bin", baseName + "_ss.bin");
                }
                catch (Exception e)
                {
                    ignored.add(fileName);
                }
            }
            else
            {
                System.err.println("non-pem entry " + fileName + " ignored");
                continue;
            }
        }

        checkCertificates(producer, certificates, ignored, privateKeys, cipherTexts);
    }

    private static void checkKem(ZipFile parent, String baseName)
        throws Exception
    {
        String ssFileName = baseName + "_ss.bin";
        String encapFileName = baseName + "_ciphertext.bin";

        InputStream inStr = parent.getInputStream(new ZipEntry(encapFileName));
        byte[] encapsulation = Streams.readAll(inStr);
        inStr.close();

        inStr = parent.getInputStream(new ZipEntry(ssFileName));
        byte[] encSecret = Streams.readAll(inStr);
        inStr.close();

        inStr = parent.getInputStream(new ZipEntry(baseName + "_priv.der"));
        byte[] privKey = Streams.readAll(inStr);
        inStr.close();

        // Extract secret from encapsulation
        MLKEMPrivateKeyParameters kemPrivKey = (MLKEMPrivateKeyParameters)PrivateKeyFactory.createKey(privKey);

        MLKEMExtractor extractor = new MLKEMExtractor(kemPrivKey);

        byte[] decSecret = extractor.extractSecret(encapsulation);

        if (!org.bouncycastle.util.Arrays.areEqual(decSecret, encSecret))
        {
            throw new IllegalStateException("mismatch in KEM secrets!!!");
        }
    }

    private static void checkKem(File parent, String baseName)
        throws Exception
    {
        String ssFileName = baseName + "_ss.bin";
        String encapFileName = baseName + "_ciphertext.bin";

        FileInputStream inStr = new FileInputStream(new File(parent, encapFileName));
        byte[] encapsulation = Streams.readAll(inStr);
        inStr.close();

        inStr = new FileInputStream(new File(parent, ssFileName));
        byte[] encSecret = Streams.readAll(inStr);
        inStr.close();

        inStr = new FileInputStream(new File(parent, baseName + "_priv.der"));
        byte[] privKey = Streams.readAll(inStr);
        inStr.close();

        // Extract secret from encapsulation
        MLKEMPrivateKeyParameters kemPrivKey = (MLKEMPrivateKeyParameters)PrivateKeyFactory.createKey(privKey);

        MLKEMExtractor extractor = new MLKEMExtractor(kemPrivKey);

        byte[] decSecret = extractor.extractSecret(encapsulation);

        if (!org.bouncycastle.util.Arrays.areEqual(decSecret, encSecret))
        {
            throw new IllegalStateException("mismatch in KEM secrets!!!");
        }
    }

    private static void checkCertificates(String producer, Map<String, X509Certificate> certificates,
                                          Set<String> ignored, Map<String, PrivateKey> privateKeys, Map<String, String> cipherTexts)
        throws IOException
    {
        Set<String> passed = new HashSet<>();
        Set<String> failed = new HashSet<>();
        Map<X500Principal, X509Certificate> tas = new HashMap<>();

        for (X509Certificate cert : certificates.values())
        {
            if (cert.getIssuerX500Principal().equals(cert.getSubjectX500Principal()))
            {
                tas.put(cert.getIssuerX500Principal(), cert);
            }
        }

        for (String entry : certificates.keySet())
        {
            if (checkCertificate(tas, certificates.get(entry)))
            {
                passed.add(entry);
            }
            else
            {
                failed.add(entry);
            }
        }

        for (String entry : privateKeys.keySet())
        {
            passed.add(entry);
        }

        for (String entry : cipherTexts.keySet())
        {
            passed.add(entry);
        }

        System.err.println("passed: " + passed);
        System.err.println("failed: " + failed);
        System.err.println("ignored: " + ignored);

        outputCSV(producer, certificates, passed);
    }

    private static String canonicalise(File artDir, File f)
    {
        return f.getPath().substring(artDir.getPath().length() + 1).replace('\\', '/');
    }

    private static File[] getLeafs(File[] listFiles)
    {
        List<File> fs = new ArrayList<>();
        for (File f : listFiles)
        {
            if (f.isDirectory())
            {
                fs.addAll(Arrays.asList(getLeafs(f.listFiles())));
            }
            else
            {
                fs.add(f);
            }
        }
        return fs.toArray(new File[0]);
    }

    private static void outputCSV(String
                                      producer, Map<String, X509Certificate> entriesChecked, Set<String> passed)
        throws IOException
    {
        FileWriter fWrt = new FileWriter(producer + "_bc.csv");
        BufferedWriter bWrt = new BufferedWriter(fWrt);

        bWrt.write(header);
        bWrt.newLine();
        for (String entry : entriesChecked.keySet())
        {
            String label = entry;
            int ind = label.lastIndexOf('_');
            label = label.substring(0, ind);
            if (label.contains("_") || label.contains("2.16.840.1.114027.80.8.1"))      // hybrid
            {
                label = label.replace("_with_", ",");
                label = label.replace("_", "(");
                label = "hybrid[" + label + ")]";
            }
            bWrt.write(label + "," + (passed.contains(entry) ? "Y" : "N"));
            bWrt.newLine();
        }

        bWrt.close();
    }

    public static void main(String[] args)
        throws Exception
    {
        if (args.length != 2)
        {
            System.err.println("usage: R3ArtifactParser producer_name [artifacts.zip|artifacts_dir]");
            System.exit(1);
        }

        Security.insertProviderAt(new BouncyCastleProvider(), 2);
        Security.insertProviderAt(new BouncyCastlePQCProvider(), 3);

        String producer = args[0];
        if (args[1].endsWith(".zip"))
        {
            processZipArtifacts(producer, args[1]);
        }
        else
        {
            processArtifacts(producer, args[1]);
        }
    }
}
