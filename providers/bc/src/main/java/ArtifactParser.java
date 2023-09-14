import java.io.BufferedWriter;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.security.GeneralSecurityException;
import java.security.KeyFactory;
import java.security.PublicKey;
import java.security.Security;
import java.security.cert.CertificateFactory;
import java.security.cert.X509CRL;
import java.security.cert.X509Certificate;
import java.security.spec.X509EncodedKeySpec;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

import org.bouncycastle.asn1.x509.Extension;
import org.bouncycastle.asn1.x509.Extensions;
import org.bouncycastle.asn1.x509.SubjectPublicKeyInfo;
import org.bouncycastle.cert.CertException;
import org.bouncycastle.cert.X509CRLHolder;
import org.bouncycastle.cert.X509CertificateHolder;
import org.bouncycastle.jce.provider.BouncyCastleProvider;
import org.bouncycastle.operator.ContentVerifierProvider;
import org.bouncycastle.operator.OperatorCreationException;
import org.bouncycastle.operator.jcajce.JcaContentVerifierProviderBuilder;
import org.bouncycastle.pkcs.PKCS10CertificationRequest;
import org.bouncycastle.pkcs.jcajce.JcaPKCS10CertificationRequest;
import org.bouncycastle.pqc.jcajce.provider.BouncyCastlePQCProvider;
import org.bouncycastle.util.io.Streams;
import org.bouncycastle.util.io.pem.PemReader;

public class ArtifactParser
{
    private static Map<String, Map<String, ZipEntry>> algEntries = new HashMap<>();
    private static Map<String, Map<String, File>> fileAlgEntries = new HashMap<>();

    private static String header = "key_algorithm_oid,ta,ca,ee,crl_ta,crl_ca";
    private static String[] entries = new String[] { "ta/ta.der", "ca/ca.der", "ee/cert.der", "crl/crl_ta.crl", "crl/crl_ca.crl" };

    private static boolean checkCertificate(String entryName, X509Certificate subject, X509Certificate signingCert)
    {
        try
        {
            subject.verify(signingCert.getPublicKey());

            X509CertificateHolder certHolder = new X509CertificateHolder(subject.getEncoded());
            if (certHolder.hasExtensions())
            {
                Extensions exts = certHolder.getExtensions();
                Extension  ext = exts.getExtension(Extension.altSignatureAlgorithm);

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

    private static boolean checkCRL(String entryName, X509CRL subject, X509Certificate signingCert)
    {
        try
        {
            subject.verify(signingCert.getPublicKey());
            X509CRLHolder crlHolder = new X509CRLHolder(subject.getEncoded());
            if (crlHolder.hasExtensions())
            {
                Extensions exts = crlHolder.getExtensions();
                Extension  ext = exts.getExtension(Extension.altSignatureAlgorithm);

                if (ext != null)
                {
                    X509CertificateHolder sigHolder = new X509CertificateHolder(signingCert.getEncoded());
                    ContentVerifierProvider vProv = new JcaContentVerifierProviderBuilder().build(
                                            SubjectPublicKeyInfo.getInstance(sigHolder.getExtension(Extension.subjectAltPublicKeyInfo).getParsedValue()));
                    if (!crlHolder.isAlternativeSignatureValid(vProv))
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

    private static void checkCSR(String csrName, InputStream csrStream, Set<String> passed)
        throws IOException
    {
        byte[] enc = Streams.readAll(csrStream);
        if (enc[0] != 0x30)
        {
            PemReader pemReader = new PemReader(new InputStreamReader(new ByteArrayInputStream(enc)));

            enc = pemReader.readPemObject().getContent();
        }

        try
        {
            PKCS10CertificationRequest certRequest = new JcaPKCS10CertificationRequest(enc);
            if (certRequest.isSignatureValid(new JcaContentVerifierProviderBuilder().build(certRequest.getSubjectPublicKeyInfo())))
            {
                passed.add(csrName);
            }
            else
            {
                System.err.println("Entry " + csrName + " failed to verify");
            }
        }
        catch (Exception e)
        {
            System.err.println("Entry " + csrName + " failed to parse: " + e.getMessage());
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

    private static String getStatus(String entry, String[] statusElements, Set passed, Set ignored)
    {
        StringBuilder statusLine = new StringBuilder();

        for (String inputEntry : statusElements)
        {
            inputEntry = "artifacts/" + entry + "/" + inputEntry;
            if (statusLine.length() > 0)
            {
                statusLine.append(",");
            }
            if (passed.contains(inputEntry))
            {
                statusLine.append("Y");
            }
            else if (!ignored.contains(inputEntry))
            {
                statusLine.append("F");
            }
        }
        return statusLine.toString();
    }

    private static boolean isRecognizedEncoding(String name)
    {
        return name.endsWith(".pem") || name.endsWith("der");
    }

    public static void processZipArtifacts(String producer, String zipName)
        throws Exception
    {
        ZipFile zipFile = new ZipFile(zipName);

        for (Enumeration<? extends ZipEntry> en = zipFile.entries(); en.hasMoreElements(); )
        {
            ZipEntry entry = en.nextElement();
            String[] entryTokens = entry.getName().contains("\\") ? entry.getName().split("\\\\") : entry.getName().split("/");
            if (entryTokens.length == 4)
            {
                Map<String, ZipEntry> algEntry = algEntries.get(entryTokens[1]);
                if (algEntry == null)
                {
                    algEntry = new HashMap<>();
                    algEntries.put(entryTokens[1], algEntry);
                }

                algEntry.put(entryTokens[2] + "/" + entryTokens[3], entry);
            }
            // some zips missing the artifacts directory
            else if (!entryTokens[0].equals("artifacts") && entryTokens.length == 3)
            {
                Map<String, ZipEntry> algEntry = algEntries.get(entryTokens[0]);
                if (algEntry == null)
                {
                    algEntry = new HashMap<>();
                    algEntries.put(entryTokens[0], algEntry);
                }

                algEntry.put(entryTokens[1] + "/" + entryTokens[2], entry);
            }
        }

        Set<String> entriesChecked = new HashSet<>();
        Set<String> ignored = new HashSet<>();
        Set<String> passed = new HashSet<>();

        String taName = null;
        X509Certificate taCert = null;
        PublicKey taPub = null;
        String caName = null;
        X509Certificate caCert = null;
        PublicKey caPub = null;
        String eeName = null;
        X509Certificate eeCert = null;
        PublicKey eePub = null;
        String taCrlName = null;
        X509CRL taCrl = null;
        String caCrlName = null;
        X509CRL caCrl = null;
        CertificateFactory certFact = CertificateFactory.getInstance("X.509", "BC");

        for (String oid : algEntries.keySet())
        {
            taName = null;
            taCert = null;
            taPub = null;
            caName = null;
            caCert = null;
            caPub = null;
            eeName = null;
            eeCert = null;
            eePub = null;
            taCrl = null;
            taCrlName = null;
            caCrl = null;
            caCrlName = null;

            Map<String, ZipEntry> algEntry = algEntries.get(oid);
            for (String name : algEntry.keySet())
            {
                ZipEntry zipEntry = algEntry.get(name);
                if (name.startsWith("ca/"))
                {
                    if (name.contains("pub") && isRecognizedEncoding(name))
                    {
                        if (name.endsWith("pem"))
                        {
                            PemReader pemReader = new PemReader(new InputStreamReader(zipFile.getInputStream(zipEntry)));
                            caPub = KeyFactory.getInstance(oid).generatePublic(new X509EncodedKeySpec(pemReader.readPemObject().getContent()));
                        }
                        else
                        {
                            try
                            {
                                caPub = KeyFactory.getInstance(oid).generatePublic(new X509EncodedKeySpec(Streams.readAll(zipFile.getInputStream(zipEntry))));
                            }
                            catch (Exception e)
                            {
                                ignored.add(zipName);
                            }
                        }
                        if (caPub != null)
                        {
                            passed.add(zipEntry.getName());
                        }
                    }
                    else if (!name.contains("priv") && isRecognizedEncoding(name))
                    {
                        caName = zipEntry.getName();
                        try
                        {
                            caCert = (X509Certificate)certFact.generateCertificate(zipFile.getInputStream(zipEntry));
                        }
                        catch (Exception e)
                        {
                            ignored.add(caName);  // possibly bad data
                        }
                    }
                    else if (name.endsWith("csr"))
                    {
                        checkCSR(zipEntry.getName(), zipFile.getInputStream(zipEntry), passed);
                    }
                    else
                    {
                        ignored.add(zipEntry.getName());
                    }
                }
                else if (name.startsWith("ta/"))
                {
                    if (name.contains("pub") && isRecognizedEncoding(name))
                    {
                        if (name.endsWith("pem"))
                        {
                            PemReader pemReader = new PemReader(new InputStreamReader(zipFile.getInputStream(zipEntry)));
                            taPub = KeyFactory.getInstance(oid).generatePublic(new X509EncodedKeySpec(pemReader.readPemObject().getContent()));
                        }
                        else
                        {
                            try
                            {
                                taPub = KeyFactory.getInstance(oid).generatePublic(new X509EncodedKeySpec(Streams.readAll(zipFile.getInputStream(zipEntry))));
                            }
                            catch (Exception e)
                            {
                                ignored.add(zipName);
                            }
                        }
                        if (taPub != null)
                        {
                            passed.add(zipEntry.getName());
                        }
                    }
                    else if (!name.contains("_key") && !name.contains("priv") && isRecognizedEncoding(name))
                    {
                        try
                        {
                            taName = zipEntry.getName();
                            taCert = (X509Certificate)certFact.generateCertificate(zipFile.getInputStream(zipEntry));
                        }
                        catch (Exception e)
                        {
                            System.err.println("exception parsing " + zipEntry.getName() + " :" + e.getMessage());
                        }
                    }
                    else if (name.endsWith("csr"))
                    {
                        checkCSR(zipEntry.getName(), zipFile.getInputStream(zipEntry), passed);
                    }
                    else
                    {
                        ignored.add(zipEntry.getName());
                    }
                }
                else if (name.startsWith("ee/"))
                {
                    if (name.contains("pub") && isRecognizedEncoding(name))
                    {
                        PemReader pemReader = new PemReader(new InputStreamReader(zipFile.getInputStream(zipEntry)));
                        if (name.endsWith("pem"))
                        {
                            eePub = KeyFactory.getInstance(oid).generatePublic(new X509EncodedKeySpec(pemReader.readPemObject().getContent()));
                        }
                        else
                        {
                            try
                            {
                                eePub = KeyFactory.getInstance(oid).generatePublic(new X509EncodedKeySpec(Streams.readAll(zipFile.getInputStream(zipEntry))));
                            }
                            catch (Exception e)
                            {
                                ignored.add(zipName);
                            }
                        }
                        if (eePub != null)
                        {
                            passed.add(zipEntry.getName());
                        }
                    }
                    else if (!name.contains("_key") && !name.contains("priv") && isRecognizedEncoding(name))
                    {
                        try
                        {
                            eeName = zipEntry.getName();
                            eeCert = (X509Certificate)certFact.generateCertificate(zipFile.getInputStream(zipEntry));
                        }
                        catch (Exception e)
                        {
                            ignored.add(eeName);
                        }
                    }
                    else if (name.endsWith("csr"))
                    {
                        checkCSR(zipEntry.getName(), zipFile.getInputStream(zipEntry), passed);
                    }
                    else
                    {
                        ignored.add(zipEntry.getName());
                    }
                }
                else if (name.startsWith("crl/"))
                {
                    if (name.contains("crl_ta"))
                    {
                        try
                        {
                            taCrlName = zipEntry.getName();
                            taCrl = (X509CRL)certFact.generateCRL(zipFile.getInputStream(zipEntry));
                        }
                        catch (Exception e)
                        {
                            System.err.println("exception parsing " + zipEntry.getName() + " :" + e.getMessage());
                        }
                    }
                    else if (name.contains("crl_ca"))
                    {
                        try
                        {
                            caCrlName = zipEntry.getName();
                            caCrl = (X509CRL)certFact.generateCRL(zipFile.getInputStream(zipEntry));
                        }
                        catch (Exception e)
                        {
                            System.err.println("exception parsing " + zipEntry.getName() + " :" + e.getMessage());
                        }
                    }
                    else
                    {
                        ignored.add(zipEntry.getName());
                    }
                }
            }

            if (taCert != null)
            {
                if (checkCertificate(taName, taCert, taCert))
                {
                    passed.add(taName);
                }
            }
            if (caCert != null && taCert != null)
            {
                if (checkCertificate(caName, caCert, taCert))
                {
                    passed.add(caName);
                }
            }
            if (eeCert != null && caCert != null)
            {
                if (checkCertificate(eeName, eeCert, caCert))
                {
                    passed.add(eeName);
                }
            }
            if (taCrl != null && taCert != null)
            {
                if (checkCRL(taCrlName, taCrl, taCert))
                {
                    passed.add(taCrlName);
                }
            }
            if (caCrl != null && caCert != null)
            {
                if (checkCRL(caCrlName, caCrl, caCert))
                {
                    passed.add(caCrlName);
                }
            }

            entriesChecked.add(oid);
        }

        for (String entry : entriesChecked)
        {
            System.out.println("Checked: " + entry);
            System.out.println("    Passed : " + getMatching(passed, entry));
            System.out.println("    Ignored: " + getMatching(ignored, entry));
        }

        outputCSV(producer, entriesChecked, ignored, passed);
    }

    public static void processArtifacts(String producer, String dirName)
        throws Exception
    {
        File artDir = new File(dirName);
        if (!artDir.isDirectory())
        {
            throw new IllegalStateException("artifact argument must point to a directory");
        }

        for (File f : getLeafs(artDir.listFiles()))
        {
            String[] entryTokens = canonicalise(artDir, f).split("/");
            if (entryTokens.length == 3)
            {
                Map<String, File> algEntry = fileAlgEntries.get(entryTokens[0]);
                if (algEntry == null)
                {
                    algEntry = new HashMap<>();
                    fileAlgEntries.put(entryTokens[0], algEntry);
                }
                algEntry.put(entryTokens[1] + "/" + entryTokens[2], f);
            }
            // some zips missing the artifacts directory
            else if (entryTokens.length == 2)
            {
                Map<String, File> algEntry = fileAlgEntries.get(entryTokens[0]);
                if (algEntry == null)
                {
                    algEntry = new HashMap<>();
                    fileAlgEntries.put(entryTokens[0], algEntry);
                }

                algEntry.put(entryTokens[0] + "/" + entryTokens[1], f);
            }
        }

        Set<String> entriesChecked = new HashSet<>();
        Set<String> ignored = new HashSet<>();
        Set<String> passed = new HashSet<>();

        String taName = null;
        X509Certificate taCert = null;
        PublicKey taPub = null;
        String caName = null;
        X509Certificate caCert = null;
        PublicKey caPub = null;
        String eeName = null;
        X509Certificate eeCert = null;
        PublicKey eePub = null;
        String taCrlName = null;
        X509CRL taCrl = null;
        String caCrlName = null;
        X509CRL caCrl = null;
        CertificateFactory certFact = CertificateFactory.getInstance("X.509", "BC");

        for (String oid : fileAlgEntries.keySet())
        {
            taName = null;
            taCert = null;
            taPub = null;
            caName = null;
            caCert = null;
            caPub = null;
            eeName = null;
            eeCert = null;
            eePub = null;
            taCrl = null;
            taCrlName = null;
            caCrl = null;
            caCrlName = null;

            Map<String, File> algEntry = fileAlgEntries.get(oid);
            // ignore SPHINCS+ for now
            if (oid.startsWith("1.3.9999.6"))
            {
                for (File fe : algEntry.values())
                {
                    ignored.add(canonicalise(artDir, fe));
                }
                continue;
            }
            for (String name : algEntry.keySet())
            {
                File fileEntry = algEntry.get(name);
                if (name.startsWith("ca/"))
                {
                    if (name.contains("pub") && isRecognizedEncoding(name))
                    {
                        if (name.endsWith("pem"))
                        {
                            PemReader pemReader = new PemReader(new InputStreamReader(new FileInputStream(fileEntry)));
                            caPub = KeyFactory.getInstance(oid).generatePublic(new X509EncodedKeySpec(pemReader.readPemObject().getContent()));
                        }
                        else
                        {
                            caPub = KeyFactory.getInstance(oid).generatePublic(new X509EncodedKeySpec(Streams.readAll(new FileInputStream(fileEntry))));
                        }
                        if (caPub != null)
                        {
                            passed.add(canonicalise(artDir, fileEntry));
                        }
                    }
                    else if (!name.contains("priv") && isRecognizedEncoding(name))
                    {        System.err.println(fileEntry);
                        caName = canonicalise(artDir, fileEntry);
                        caCert = (X509Certificate)certFact.generateCertificate(new FileInputStream(fileEntry));
                    }
                    else if (name.endsWith("csr"))
                    {
                        checkCSR(canonicalise(artDir, fileEntry), new FileInputStream(fileEntry), passed);
                    }
                    else
                    {
                        ignored.add(canonicalise(artDir, fileEntry));
                    }
                }
                else if (name.startsWith("ta/"))
                {
                    if (name.contains("pub") && isRecognizedEncoding(name))
                    {
                        if (name.endsWith("pem"))
                        {
                            PemReader pemReader = new PemReader(new InputStreamReader(new FileInputStream(fileEntry)));
                            taPub = KeyFactory.getInstance(oid).generatePublic(new X509EncodedKeySpec(pemReader.readPemObject().getContent()));
                        }
                        else
                        {
                            taPub = KeyFactory.getInstance(oid).generatePublic(new X509EncodedKeySpec(Streams.readAll(new FileInputStream(fileEntry))));
                        }
                        if (taPub != null)
                        {
                            passed.add(canonicalise(artDir, fileEntry));
                        }
                    }
                    else if (!name.contains("priv") && isRecognizedEncoding(name))
                    {
                        try
                        {
                            taName = canonicalise(artDir, fileEntry);
                            taCert = (X509Certificate)certFact.generateCertificate(new FileInputStream(fileEntry));
                        }
                        catch (Exception e)
                        {
                            System.err.println("exception parsing " + canonicalise(artDir, fileEntry) + " :" + e.getMessage());
                        }
                    }
                    else if (name.endsWith("csr"))
                    {
                        checkCSR(canonicalise(artDir, fileEntry), new FileInputStream(fileEntry), passed);
                    }
                    else
                    {
                        ignored.add(canonicalise(artDir, fileEntry));
                    }
                }
                else if (name.startsWith("ee/"))
                {
                    if (name.contains("pub") && isRecognizedEncoding(name))
                    {
                        if (name.endsWith("pem"))
                        {
                            PemReader pemReader = new PemReader(new InputStreamReader(new FileInputStream(fileEntry)));
                            eePub = KeyFactory.getInstance(oid).generatePublic(new X509EncodedKeySpec(pemReader.readPemObject().getContent()));
                        }
                        else
                        {
                            eePub = KeyFactory.getInstance(oid).generatePublic(new X509EncodedKeySpec(Streams.readAll(new FileInputStream(fileEntry))));
                        }
                        if (eePub != null)
                        {
                            passed.add(canonicalise(artDir, fileEntry));
                        }
                    }
                    else if (!name.contains("priv") && isRecognizedEncoding(name))
                    {
                        eeName = canonicalise(artDir, fileEntry);
                        eeCert = (X509Certificate)certFact.generateCertificate(new FileInputStream(fileEntry));
                    }
                    else if (name.endsWith("csr"))
                    {
                        checkCSR(canonicalise(artDir, fileEntry), new FileInputStream(fileEntry), passed);
                    }
                    else
                    {
                        ignored.add(canonicalise(artDir, fileEntry));
                    }
                }
                else if (name.startsWith("crl/"))
                {
                    if (name.contains("crl_ta"))
                    {
                        try
                        {
                            taCrlName = canonicalise(artDir, fileEntry);
                            taCrl = (X509CRL)certFact.generateCRL(new FileInputStream(fileEntry));
                        }
                        catch (Exception e)
                        {
                            System.err.println("exception parsing " + canonicalise(artDir, fileEntry) + " :" + e.getMessage());
                        }
                    }
                    else if (name.contains("crl_ca"))
                    {
                        try
                        {
                            caCrlName = canonicalise(artDir, fileEntry);
                            caCrl = (X509CRL)certFact.generateCRL(new FileInputStream(fileEntry));
                        }
                        catch (Exception e)
                        {
                            System.err.println("exception parsing " + canonicalise(artDir, fileEntry) + " :" + e.getMessage());
                        }
                    }
                    else
                    {
                        ignored.add(canonicalise(artDir, fileEntry));
                    }
                }
            }

            if (taCert != null)
            {
                if (checkCertificate(taName, taCert, taCert))
                {
                    passed.add(taName);
                }
            }
            if (caCert != null && taCert != null)
            {
                if (checkCertificate(caName, caCert, taCert))
                {
                    passed.add(caName);
                }
            }
            if (eeCert != null && caCert != null)
            {
                if (checkCertificate(eeName, eeCert, caCert))
                {
                    passed.add(eeName);
                }
            }
            if (taCrl != null && taCert != null)
            {
                if (checkCRL(taCrlName, taCrl, taCert))
                {
                    passed.add(taCrlName);
                }
            }
            if (caCrl != null && caCert != null)
            {
                if (checkCRL(caCrlName, caCrl, caCert))
                {
                    passed.add(caCrlName);
                }
            }

            entriesChecked.add(oid);
        }

        for (String entry : entriesChecked)
        {
            System.out.println("Checked: " + entry);
            System.out.println("    Passed : " + getMatching(passed, entry));
            System.out.println("    Ignored: " + getMatching(ignored, entry));
        }

        outputCSV(producer, entriesChecked, ignored, passed);
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

    private static void outputCSV(String producer, Set<String> entriesChecked, Set<String> ignored, Set<String> passed)
        throws IOException
    {
        FileWriter fWrt = new FileWriter(producer + "_bc.csv");
        BufferedWriter bWrt = new BufferedWriter(fWrt);

        bWrt.write(header);
        bWrt.newLine();
        for (String entry : entriesChecked)
        {
            bWrt.write(entry + "," + getStatus(entry, entries, passed, ignored));
            bWrt.newLine();
        }

        bWrt.close();
    }

    public static void main(String[] args)
        throws Exception
    {
        if (args.length != 2)
        {
            System.err.println("usage: ArtifactParser producer_name [artifacts.zip|artifacts_dir]");
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
