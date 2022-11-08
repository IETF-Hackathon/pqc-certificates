import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.security.GeneralSecurityException;
import java.security.KeyFactory;
import java.security.PublicKey;
import java.security.Security;
import java.security.cert.CertificateFactory;
import java.security.cert.X509CRL;
import java.security.cert.X509Certificate;
import java.security.spec.X509EncodedKeySpec;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

import org.bouncycastle.cert.X509CRLHolder;
import org.bouncycastle.jce.provider.BouncyCastleProvider;
import org.bouncycastle.operator.jcajce.JcaContentVerifierProviderBuilder;
import org.bouncycastle.pkcs.PKCS10CertificationRequest;
import org.bouncycastle.pkcs.jcajce.JcaPKCS10CertificationRequest;
import org.bouncycastle.pqc.jcajce.provider.BouncyCastlePQCProvider;
import org.bouncycastle.util.io.Streams;
import org.bouncycastle.util.io.pem.PemReader;

public class ArtifactParser
{
    private static Map<String, Map<String, ZipEntry>> algEntries = new HashMap<>();

    private static boolean checkCertificate(String entryName, X509Certificate subject, X509Certificate signingCert)
    {
        try
        {
            subject.verify(signingCert.getPublicKey());

            return true;
        }
        catch (GeneralSecurityException e)
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

            return true;
        }
        catch (GeneralSecurityException e)
        {
            System.err.println("Entry " + entryName + " failed to verify: " + e);
            return false;
        }
    }

    private static void checkCSR(ZipFile zipFile, ZipEntry zipEntry, Set<String> passed)
        throws IOException
    {
        byte[] enc = Streams.readAll(zipFile.getInputStream(zipEntry));
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
                passed.add(zipEntry.getName());
            }
            else
            {
                System.err.println("Entry " + zipEntry.getName() + " failed to verify");
            }
        }
        catch (Exception e)
        {
            System.err.println("Entry " + zipEntry.getName() + " failed to parse: " + e.getMessage());
        }
    }

    private static Set<String> getMatching(Set<String> ignored, String entry)
    {
        Set<String> thisIgnored = new HashSet<>();
        for (String ignoredEntry : ignored)
        {
            if (ignoredEntry.contains(entry))
            {
                thisIgnored.add(ignoredEntry);
            }
        }
        return thisIgnored;
    }

    private static boolean isRecognizedEncoding(String name)
    {
        return name.endsWith(".pem") || name.endsWith("der");
    }

    public static void main(String[] args)
        throws Exception
    {
        if (args.length != 1)
        {
            System.err.println("usage: ArtifactParser artifacts.zip");
            System.exit(1);
        }

        Security.addProvider(new BouncyCastleProvider());
        Security.addProvider(new BouncyCastlePQCProvider());

        ZipFile zipFile = new ZipFile(args[0]);

        for (Enumeration<? extends ZipEntry> en = zipFile.entries(); en.hasMoreElements();)
        {
            ZipEntry entry = en.nextElement();
            String[] entryTokens = entry.getName().split("/");
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
            // ignore SPHINCS+ for now
            if (oid.startsWith("1.3.9999.6"))
            {
                for (ZipEntry ze : algEntry.values())
                {
                    ignored.add(ze.getName());
                }
                continue;
            }
            for (String name: algEntry.keySet())
            {
                ZipEntry zipEntry = algEntry.get(name);
                if (name.startsWith("ca/"))
                {
                    if (name.contains("pub") && isRecognizedEncoding(name))
                    {
                        PemReader pemReader = new PemReader(new InputStreamReader(zipFile.getInputStream(zipEntry)));
                        taPub = KeyFactory.getInstance(oid).generatePublic(new X509EncodedKeySpec(pemReader.readPemObject().getContent()));
                        if (taPub != null)
                        {
                            passed.add(zipEntry.getName());
                        }
                    }
                    else if (!name.contains("priv") && isRecognizedEncoding(name))
                    {
                        caName = zipEntry.getName();
                        caCert = (X509Certificate)certFact.generateCertificate(zipFile.getInputStream(zipEntry));
                    }
                    else if (name.endsWith("csr"))
                    {
                        checkCSR(zipFile, zipEntry, passed);
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
                        PemReader pemReader = new PemReader(new InputStreamReader(zipFile.getInputStream(zipEntry)));
                        taPub = KeyFactory.getInstance(oid).generatePublic(new X509EncodedKeySpec(pemReader.readPemObject().getContent()));
                        if (taPub != null)
                        {
                            passed.add(zipEntry.getName());
                        }
                    }
                    else if (!name.contains("priv") && isRecognizedEncoding(name))
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
                        checkCSR(zipFile, zipEntry, passed);
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
                        eePub = KeyFactory.getInstance(oid).generatePublic(new X509EncodedKeySpec(pemReader.readPemObject().getContent()));
                        if (eePub != null)
                        {
                            passed.add(zipEntry.getName());
                        }
                    }
                    else if (!name.contains("priv") && isRecognizedEncoding(name))
                    {
                        eeName = zipEntry.getName();
                        eeCert = (X509Certificate)certFact.generateCertificate(zipFile.getInputStream(zipEntry));
                    }
                    else if (name.endsWith("csr"))
                    {
                        checkCSR(zipFile, zipEntry, passed);
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
                    passed.add(eeName);
                }
            }
            if (caCrl != null && caCert != null)
            {
                if (checkCRL(caCrlName, caCrl, caCert))
                {
                    passed.add(eeName);
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
    }
}
