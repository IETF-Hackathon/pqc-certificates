/*
* Basic example of CMP request processing with post-quantum signature algorithms, derived from prototype built at
* the IETF116 hackathon.
* */

package org.example;

import org.bouncycastle.asn1.ASN1Integer;
import org.bouncycastle.asn1.cmp.PKIBody;
import org.bouncycastle.asn1.cmp.PKIMessage;
import org.bouncycastle.asn1.cmp.PKIStatus;
import org.bouncycastle.asn1.cmp.PKIStatusInfo;
import org.bouncycastle.asn1.crmf.CertTemplate;
import org.bouncycastle.asn1.pkcs.CertificationRequest;
import org.bouncycastle.asn1.pkcs.CertificationRequestInfo;
import org.bouncycastle.asn1.x500.X500Name;
import org.bouncycastle.asn1.x509.*;
import org.bouncycastle.cert.CertException;
import org.bouncycastle.cert.CertIOException;
import org.bouncycastle.cert.X509CertificateHolder;
import org.bouncycastle.cert.X509v3CertificateBuilder;
import org.bouncycastle.cert.cmp.ProtectedPKIMessage;
import org.bouncycastle.cert.cmp.ProtectedPKIMessageBuilder;
import org.bouncycastle.cert.crmf.*;
import org.bouncycastle.cert.jcajce.JcaX509v3CertificateBuilder;
import org.bouncycastle.jce.provider.BouncyCastleProvider;
import org.bouncycastle.operator.ContentSigner;
import org.bouncycastle.operator.OperatorCreationException;
import org.bouncycastle.operator.jcajce.JcaContentSignerBuilder;
import org.bouncycastle.pqc.jcajce.provider.BouncyCastlePQCProvider;
import org.bouncycastle.pqc.jcajce.spec.*;
import org.bouncycastle.util.io.Streams;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.math.BigInteger;
import java.nio.file.Path;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.Security;
import java.security.Signature;
import java.security.spec.AlgorithmParameterSpec;
import java.util.Date;
import java.util.Map;
import java.util.logging.Logger;

import static java.util.Map.entry;


public class CmpLogic {
    private static final Logger log = Logger.getLogger("cmp");
    private static GeneralName issuerName = null;
    private static String signAlgorithmName = null;

    private static ContentSigner signer;

    private static X509CertificateHolder caCert;

    // parameters are hardcoded for now; only tested with a few algorithms - others need to be reviewed
    private static final Map<String, AlgorithmParameterSpec> keyParameters = Map.ofEntries(
            entry("Dilithium", DilithiumParameterSpec.dilithium2),
//            entry("Kyber", KyberParameterSpec.kyber512),
//            entry("NTRU", NTRUParameterSpec.ntruhps2048509),
//            entry("Falcon", FalconParameterSpec.falcon_512),
//            entry("NTRUPrime", SNTRUPrimeParameterSpec.sntrup653),
//            entry("Rainbow", RainbowParameterSpec.rainbowIIIclassic),
            entry("Picnic", PicnicParameterSpec.picnic3l1),
//            entry("BIKE", BIKEParameterSpec.bike128),
//            entry("HQC", HQCParameterSpec.hqc128),
            entry("XMSS", XMSSParameterSpec.SHA2_10_256),
//            entry("Frodo", FrodoParameterSpec.frodokem640aes),
//            entry("CMCE", CMCEParameterSpec.mceliece348864),
            entry("SPHINCSPlus", SPHINCSPlusParameterSpec.haraka_128f)

//            entry("NH", ),
//            entry("SPHINCS", SPHINCSKeyParameters.SHA3_256),
//            entry("LMS", LMS, -> this requires more effort, e.g. handling the key index
//            entry("SABER", SABERParameterSpec.),
            );

    public static void init(String algorithm) throws Exception {
        // initialize BouncyCastle Providers for classic and post-quantum crypto
        Security.addProvider(new BouncyCastlePQCProvider());
        Security.addProvider(new BouncyCastleProvider());

        signAlgorithmName = algorithm;
        String rawIssuerName = String.format("CN=%s Issuer", algorithm);
        issuerName = new GeneralName(new X500Name(rawIssuerName));

        // generate key-pairs
        log.info("Generating key pair for algorithm: " + signAlgorithmName);
        KeyPairGenerator kpGen = KeyPairGenerator.getInstance(signAlgorithmName, "BCPQC");

        AlgorithmParameterSpec algorithmParameters = keyParameters.get(algorithm);
        kpGen.initialize(algorithmParameters);
        KeyPair issuerKeypair = kpGen.generateKeyPair();

        signer = new JcaContentSignerBuilder(signAlgorithmName).setProvider("BCPQC").build(issuerKeypair.getPrivate());

        log.info("Creating issuer certifcate for: " + rawIssuerName);
        caCert = makeV3Certificate(rawIssuerName, issuerKeypair);

    }

    public static void processCmpRequest(Path path) throws Exception {
        log.info("Processing " + path.toString());
        byte[] data = Streams.readAll(new FileInputStream(path.toString()));

        ProtectedPKIMessage pkiMessage = issueCertificate(data);
        if (pkiMessage == null) return;
        String signAlgorithmOid = signer.getAlgorithmIdentifier().getAlgorithm().getId();

        // req-ir-prot_none-pop_sig.pkimessage
        Path originalName = path.getFileName();
        String modifiedName = originalName.toString().replace("req-", "resp-");
        String signatureNameSuffix = String.format("-sig_%s_%s.pkimessage", signAlgorithmOid, signAlgorithmName);
        modifiedName = modifiedName.replace(".pkimessage", signatureNameSuffix);
        Path parentDir = path.getParent();

        // Write the PKIMessage answer that would've been sent to the client
        FileOutputStream resp = new FileOutputStream(parentDir.resolve(modifiedName).toString());
        resp.write(pkiMessage.toASN1Structure().getEncoded());
        resp.close();

        // take certificate from response
        CertificateRepMessage certRepMessage = CertificateRepMessage.fromPKIBody(pkiMessage.getBody());
        CertificateResponse certResp = certRepMessage.getResponses()[0];
        Certificate cert = certResp.getCertificate().getX509v3PKCert();

        String certName = String.format("issued-cert-sig_%s.crt", signAlgorithmName);


        FileOutputStream certWriter = new FileOutputStream(parentDir.resolve(certName).toString());
        certWriter.write(cert.getEncoded());
        certWriter.close();
    }

    //    Used for issuing the self-signed certificate
    private static X509CertificateHolder makeV3Certificate(String _subDN, KeyPair issKP)
            throws OperatorCreationException, CertException, CertIOException {
        X509v3CertificateBuilder certGen = new JcaX509v3CertificateBuilder(
                new X500Name(_subDN),
                BigInteger.valueOf(System.currentTimeMillis()),
                new Date(System.currentTimeMillis()),
                new Date(System.currentTimeMillis() + (1000L * 60 * 60 * 24 * 100)),
                new X500Name(_subDN),
                issKP.getPublic());

        certGen.addExtension(Extension.basicConstraints, true, new BasicConstraints(0));

        X509CertificateHolder certHolder = certGen.build(signer);
        return certHolder;
    }

    private static X509CertificateHolder makeV3Certificate(SubjectPublicKeyInfo pubKey, X500Name _subDN, String _issDN)
            throws OperatorCreationException, CertException, CertIOException {

        log.info("Issuing cert for: " + _subDN);
        X509v3CertificateBuilder certGen = new JcaX509v3CertificateBuilder(
                new X500Name(_issDN),
                BigInteger.valueOf(System.currentTimeMillis()),
                new Date(System.currentTimeMillis()),
                new Date(System.currentTimeMillis() + (1000L * 60 * 60 * 24 * 100)),
                _subDN,
                pubKey);

        certGen.addExtension(Extension.basicConstraints, true, new BasicConstraints(false));
        X509CertificateHolder certHolder = certGen.build(signer);
        return certHolder;
    }

    public static ProtectedPKIMessage issueCertificate(byte[] rawRequest)
            throws Exception {
        PKIMessage initMessage = PKIMessage.getInstance(rawRequest);


        X509CertificateHolder cert;
        X500Name subject = null;
        ASN1Integer requestId = new ASN1Integer(1);

        // TODO: check the signature before issuing the cert

        if (initMessage.getBody().getType() == PKIBody.TYPE_P10_CERT_REQ) {
            CertificationRequest csr = (CertificationRequest) initMessage.getBody().getContent();
            CertificationRequestInfo requestInfo = csr.getCertificationRequestInfo();
            subject = requestInfo.getSubject();
            cert = makeV3Certificate(requestInfo.getSubjectPublicKeyInfo(), subject, issuerName.getName().toString());

        } else if (initMessage.getBody().getType() == PKIBody.TYPE_INIT_REQ) {
            CertificateReqMessages requestMessages = CertificateReqMessages.fromPKIBody(initMessage.getBody());
            // TODO consider adding test cases of inputs with multiple requests in a payload
            CertificateRequestMessage senderReqMessage = requestMessages.getRequests()[0];
            CertTemplate certTemplate = senderReqMessage.getCertTemplate();
            subject = certTemplate.getSubject();

            requestId = senderReqMessage.getCertReqId();

            cert = makeV3Certificate(certTemplate.getPublicKey(), certTemplate.getSubject(), issuerName.getName().toString());
        } else {
            log.warning("Ignoring unsupported request type " + initMessage.getBody().getType());
            return null;
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
