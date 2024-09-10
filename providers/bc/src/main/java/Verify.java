import java.io.ByteArrayInputStream;
import java.io.FileInputStream;
import java.io.FileReader;
import java.security.Security;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;

import org.bouncycastle.cert.X509CertificateHolder;
import org.bouncycastle.jcajce.provider.asymmetric.X509;
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
                PEMParser pemPrs = new PEMParser(new FileReader(args[1]));

                X509CertificateHolder hld = (X509CertificateHolder)pemPrs.readObject();

                pemPrs.close();

                data = hld.getEncoded();
            }
            else if (args[1].endsWith(".der"))
            {
                FileInputStream fIn = new FileInputStream((args[1]));

                data = Streams.readAll(fIn);

                fIn.close();
            }
            else
            {
                System.out.println("unknown file: " + args[1]);
                System.exit(1);
            }

            X509Certificate cert = (X509Certificate)certFact.generateCertificate(new ByteArrayInputStream(data));

            try
            {
                cert.verify(cert.getPublicKey());

                System.out.println(args[1] + " verified");
                System.exit(0);
            }
            catch (Exception e)
            {
                System.out.println(args[1] + " failed verification");
                System.exit(1);
            }
        }
        else
        {
            System.out.println("unknown command: " + args[0]);
        }

        System.exit(1);
    }
}

