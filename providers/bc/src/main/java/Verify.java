import java.io.ByteArrayInputStream;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.security.Security;
import java.security.cert.CertificateException;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;
import java.util.Enumeration;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

import org.bouncycastle.cert.X509CertificateHolder;
import org.bouncycastle.jce.provider.BouncyCastleProvider;
import org.bouncycastle.openssl.PEMParser;
import org.bouncycastle.util.io.Streams;

public class Verify
{
    public static void main(String[] args)
        throws Exception
    {
        Security.addProvider(new BouncyCastleProvider());

        CertificateFactory certFact = CertificateFactory.getInstance("X.509", "BC");

        if (args.length != 2)
        {
            System.out.println("usage: " + "Verify self-signed <certfile>");
        }
        else if (args[0].equals("self-signed"))
        {
            byte[] data = null;
            if (args[1].endsWith(".pem"))
            {
                FileInputStream input = new FileInputStream(args[1]);
                parsePem(certFact, args[1], input);
                input.close();
            }
            else if (args[1].endsWith(".der"))
            {
                FileInputStream input = new FileInputStream(args[1]);
                parseDer(certFact, args[1], input);
                input.close();
            }
            else if (args[1].endsWith(".zip"))
            {
                ZipFile zipFile = new ZipFile(args[1]);
                for (Enumeration<? extends ZipEntry> en = zipFile.entries(); en.hasMoreElements(); )
                {
                    ZipEntry entry = en.nextElement();
                    String zipName = entry.getName();
                    if (zipName.contains("chameleon")
                        || zipName.contains("catalyst")
                        || zipName.contains("composite"))     // filter out old names
                    {
                        continue;
                    }
                    
                    if (zipName.contains("_ta") && zipName.endsWith(".pem"))
                    {
                        parsePem(certFact, zipName, zipFile.getInputStream(entry));
                    }
                    else if (zipName.contains("_ta") && zipName.endsWith(".der"))
                    {
                        parseDer(certFact, zipName, zipFile.getInputStream(entry));
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

    private static String createResultName(String fileName)
    {
        String oid = fileName.substring(fileName.lastIndexOf('-') + 1);
        oid = oid.substring(0, oid.indexOf("_"));
        return oid;
    }

    private static void parsePem(CertificateFactory certFact, String arg, InputStream input)
        throws IOException, CertificateException
    {
        PEMParser pemPrs = new PEMParser(new InputStreamReader(input));

        X509CertificateHolder hld = (X509CertificateHolder)pemPrs.readObject();

        pemPrs.close();

        byte[] data = hld.getEncoded();

        X509Certificate cert = (X509Certificate)certFact.generateCertificate(new ByteArrayInputStream(data));

        String oid = createResultName(arg);
        try
        {
            cert.verify(cert.getPublicKey());

            System.out.println(oid + ",cert,Y");
        }
        catch (Exception e)
        {
            System.out.println(oid + ",cert,N");
        }
    }

    private static void parseDer(CertificateFactory certFact, String arg, InputStream input)
        throws IOException, CertificateException
    {
        byte[] data = Streams.readAll(input);

        X509Certificate cert = (X509Certificate)certFact.generateCertificate(new ByteArrayInputStream(data));
        String oid = createResultName(arg);
        try
        {
            cert.verify(cert.getPublicKey());

            System.out.println(oid + ",cert,Y");
        }
        catch (Exception e)
        {
            System.out.println(oid + ",cert,N");
        }
    }
}

