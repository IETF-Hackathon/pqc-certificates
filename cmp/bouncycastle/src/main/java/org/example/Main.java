package org.example;

import org.bouncycastle.asn1.ASN1Encodable;
import org.bouncycastle.asn1.ASN1Integer;
import org.bouncycastle.asn1.cmp.*;
import org.bouncycastle.asn1.crmf.CertTemplate;
import org.bouncycastle.asn1.crmf.SubsequentMessage;
import org.bouncycastle.asn1.nist.NISTObjectIdentifiers;
import org.bouncycastle.asn1.pkcs.CertificationRequest;
import org.bouncycastle.asn1.pkcs.CertificationRequestInfo;
import org.bouncycastle.asn1.util.ASN1Dump;
import org.bouncycastle.asn1.x500.X500Name;
import org.bouncycastle.asn1.x509.*;
import org.bouncycastle.asn1.x509.Certificate;
import org.bouncycastle.cert.CertException;
import org.bouncycastle.cert.CertIOException;
import org.bouncycastle.cert.X509CertificateHolder;
import org.bouncycastle.cert.X509v3CertificateBuilder;
import org.bouncycastle.cert.cmp.*;
import org.bouncycastle.cert.crmf.*;
import org.bouncycastle.cert.crmf.jcajce.JcaCertificateRequestMessageBuilder;
import org.bouncycastle.cert.jcajce.JcaX509CertificateConverter;
import org.bouncycastle.cert.jcajce.JcaX509v3CertificateBuilder;
import org.bouncycastle.cms.*;
import org.bouncycastle.cms.jcajce.JceCMSContentEncryptorBuilder;
import org.bouncycastle.cms.jcajce.JceKEMEnvelopedRecipient;
import org.bouncycastle.cms.jcajce.JceKEMRecipientInfoGenerator;
import org.bouncycastle.jce.provider.BouncyCastleProvider;
import org.bouncycastle.operator.*;
import org.bouncycastle.operator.jcajce.JcaContentSignerBuilder;
import org.bouncycastle.operator.jcajce.JcaContentVerifierProviderBuilder;
import org.bouncycastle.operator.jcajce.JcaDigestCalculatorProviderBuilder;
import org.bouncycastle.pkcs.PKCS10CertificationRequest;
import org.bouncycastle.pkcs.jcajce.JcePBMac1CalculatorBuilder;
import org.bouncycastle.pkcs.jcajce.JcePBMac1CalculatorProviderBuilder;
import org.bouncycastle.pqc.jcajce.spec.DilithiumParameterSpec;
import org.bouncycastle.pqc.jcajce.spec.KyberParameterSpec;
import org.bouncycastle.util.BigIntegers;
import org.bouncycastle.pqc.jcajce.provider.BouncyCastlePQCProvider;
import org.bouncycastle.util.io.Streams;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.math.BigInteger;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.security.*;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.stream.Stream;


public class Main {
    //    char[] senderMacPassword = "secret".toCharArray();
    static GeneralName issuerName = new GeneralName(new X500Name("CN=Dilithium Issuer"));
    static String SignAlgorithmName = "Dilithium";

    private static KeyPair dilKp;  // issuer's key

    private static ContentSigner signer;

    private static X509CertificateHolder caCert;


//    private static Map<int, int> reqRepMap = Map.of()


    public static void main(String[] args) throws Exception {
        if (args.length < 1) {
            System.out.println("You must provide a path for the input directory");
            return;
        }

        Path sourcePath = Paths.get(args[0]);
        if (!Files.isDirectory(sourcePath)) {
            throw new IllegalArgumentException("Path must be a directory!");
        }

        List<Path> requestPaths = null;
        try (Stream<Path> paths = Files.walk(sourcePath)) {
            requestPaths = paths
                    .filter(Files::isRegularFile)
                    .filter(entry -> entry.toString().contains("req"))
                    .filter(entry -> entry.toString().endsWith(".pkimessage"))
                    .toList();

        } catch (IOException e) {
            e.printStackTrace();
        }
        if (requestPaths == null || requestPaths.isEmpty()) {
            throw new IllegalArgumentException("Path does not seem to contain any CMP requests");
        }

        // initialize BouncyCastle Providers for classic and post-quantum crypto
        Security.addProvider(new BouncyCastlePQCProvider());
        Security.addProvider(new BouncyCastleProvider());


        // generate key-pairs
        KeyPairGenerator dilKpGen = KeyPairGenerator.getInstance(SignAlgorithmName, "BCPQC");
        dilKpGen.initialize(DilithiumParameterSpec.dilithium2);
        dilKp = dilKpGen.generateKeyPair();

        signer = new JcaContentSignerBuilder(SignAlgorithmName).setProvider("BCPQC").build(dilKp.getPrivate());

        caCert = makeV3Certificate("CN=Dilithium Issuer", dilKp);

        int filesProcessed = 0;
        for (Path requestPath : requestPaths) {
            processCmpRequest(requestPath);
            filesProcessed++;
        }


        System.out.printf("Done! %d files", filesProcessed);

    }

    private static void processCmpRequest(Path path) throws Exception {
        System.out.printf("Processing %s", path.toString());
        byte[] data = Streams.readAll(new FileInputStream(path.toString()));

        ProtectedPKIMessage pkiMessage = issueWithDilithiumCA(data);



        String signAlgorithmOid = signer.getAlgorithmIdentifier().getAlgorithm().getId();
        String signAlgorithmName = signer.getAlgorithmIdentifier().toString();


        // req-ir-prot_none-pop_sig.pkimessage
        Path originalName = path.getFileName();
        String modifiedName = originalName.toString().replace("req-ir", "resp-ip");
        String signatureNameSuffix = String.format("-sig_%s_%s.pkimessage", signAlgorithmOid, SignAlgorithmName);
        modifiedName = modifiedName.replace(".pkimessage", signatureNameSuffix);
        Path parentDir = path.getParent();



        // Write the PKIMessage answer that would've been sent to the client
        FileOutputStream resp = new FileOutputStream(parentDir.resolve(modifiedName).toString());
        resp.write(pkiMessage.toASN1Structure().getEncoded());
        resp.close();

        // optional check
//        result.verify(new JcaContentVerifierProviderBuilder().build(caCert));


        // take certificate from response
        CertificateRepMessage certRepMessage = CertificateRepMessage.fromPKIBody(pkiMessage.getBody());
        CertificateResponse certResp = certRepMessage.getResponses()[0];
        Certificate cert = certResp.getCertificate().getX509v3PKCert();


//        CMPCertificate receivedEnvelope = certResp.getCertificate();
//        Certificate recipients = receivedEnvelope.getX509v3PKCert();


        String certName = String.format("issued-cert-sig_%s.crt", SignAlgorithmName);


        FileOutputStream certWriter = new FileOutputStream(parentDir.resolve(certName).toString());
        certWriter.write(cert.getEncoded());
        certWriter.close();



//        System.err.println(ASN1Dump.dumpAsString(recipients.toASN1Primitive(), true));
    }

    private static X509CertificateHolder makeV3Certificate(String _subDN, KeyPair issKP)
            throws OperatorCreationException, CertException, CertIOException {
        PrivateKey issPriv = issKP.getPrivate();
        PublicKey issPub = issKP.getPublic();

        X509v3CertificateBuilder certGen = new JcaX509v3CertificateBuilder(
                new X500Name(_subDN),
                BigInteger.valueOf(System.currentTimeMillis()),
                new Date(System.currentTimeMillis()),
                new Date(System.currentTimeMillis() + (1000L * 60 * 60 * 24 * 100)),
                new X500Name(_subDN),
                issKP.getPublic());

        certGen.addExtension(Extension.basicConstraints, true, new BasicConstraints(0));

//        ContentSigner signer = new JcaContentSignerBuilder(SignAlgorithmName).build(issPriv);

        X509CertificateHolder certHolder = certGen.build(signer);

        ContentVerifierProvider verifier = new JcaContentVerifierProviderBuilder().build(issPub);

//        assertTrue(certHolder.isSignatureValid(verifier));

        return certHolder;
    }

    private static X509CertificateHolder makeV3Certificate(SubjectPublicKeyInfo pubKey, X500Name _subDN, KeyPair issKP, String _issDN)
            throws OperatorCreationException, CertException, CertIOException {
        PrivateKey issPriv = issKP.getPrivate();
        PublicKey issPub = issKP.getPublic();

        X509v3CertificateBuilder certGen = new JcaX509v3CertificateBuilder(
                new X500Name(_issDN),
                BigInteger.valueOf(System.currentTimeMillis()),
                new Date(System.currentTimeMillis()),
                new Date(System.currentTimeMillis() + (1000L * 60 * 60 * 24 * 100)),
                _subDN,
                pubKey);

        certGen.addExtension(Extension.basicConstraints, true, new BasicConstraints(false));

//        ContentSigner signer = new JcaContentSignerBuilder(SignAlgorithmName).build(issPriv);

        X509CertificateHolder certHolder = certGen.build(signer);

        ContentVerifierProvider verifier = new JcaContentVerifierProviderBuilder().build(issPub);

//        assertTrue(certHolder.isSignatureValid(verifier));

        return certHolder;
    }

    public static ProtectedPKIMessage issueWithDilithiumCA(byte[] rawRequest)
            throws Exception {
        PKIMessage initMessage = PKIMessage.getInstance(rawRequest);


        X509CertificateHolder cert;
        X500Name subject = null;
        ASN1Integer requestId = new ASN1Integer(1); //
        if (initMessage.getBody().getType() == PKIBody.TYPE_P10_CERT_REQ) {
            System.out.println("here");
//            byte[] content = initMessage.getBody().getEncoded();
//            CertificationRequestInfo cri = initMessage.getCertReqMsg().getCertReq().getCertReqInfo();

//            PKCS10CertificationRequest csr = new PKCS10CertificationRequest(content);
//            PKCS10CertificationRequest csr = new PKCS10CertificationRequest(initMessage.getBody().getEncoded());
//            subject = csr.getSubject();
//            CertTemplate certTemplate2 = csr.
//            X500Name subject = csr.getSubject();
            CertificationRequest csr = (CertificationRequest) initMessage.getBody().getContent();
            CertificationRequestInfo requestInfo = csr.getCertificationRequestInfo();
            subject =  requestInfo.getSubject();
//            ((CertificationRequest) initMessage.body.body).reqInfo.subjectPKInfo
            cert = makeV3Certificate(requestInfo.getSubjectPublicKeyInfo(), subject, dilKp, issuerName.getName().toString());

        } else {

//        System.out.printf("CMP request type %i", initMessage.getBody().getType());
//        assertEquals(PKIBody.TYPE_INIT_REQ, initMessage.getBody().getType());

            CertificateReqMessages requestMessages = CertificateReqMessages.fromPKIBody(initMessage.getBody());
            // TODO consider adding test cases of inputs with multiple requests in a payload
            CertificateRequestMessage senderReqMessage = requestMessages.getRequests()[0];
            CertTemplate certTemplate = senderReqMessage.getCertTemplate();
            subject = certTemplate.getSubject();

            requestId = senderReqMessage.getCertReqId();

            cert = makeV3Certificate(certTemplate.getPublicKey(), certTemplate.getSubject(), dilKp, issuerName.getName().toString());
        }

        // response generation
        CertificateResponseBuilder certRespBuilder = new CertificateResponseBuilder(requestId, new PKIStatusInfo(PKIStatus.granted));
        certRespBuilder.withCertificate(cert);
        CertificateRepMessageBuilder repMessageBuilder = new CertificateRepMessageBuilder(caCert);
        repMessageBuilder.addCertificateResponse(certRespBuilder.build());

        // sign response
        CertificateRepMessage repMessage = repMessageBuilder.build();
        GeneralName sender = new GeneralName(subject);

        return new ProtectedPKIMessageBuilder(sender, issuerName)
                .setBody(PKIBody.TYPE_CERT_REP, repMessage)
                .build(signer);
    }

}
