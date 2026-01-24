import sun.security.pkcs.NamedPKCS8Key;
import sun.security.tools.keytool.CertAndKeyGen;
import sun.security.x509.X500Name;

import javax.crypto.KEM;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.security.KeyFactory;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.SecureRandom;
import java.security.cert.Certificate;
import java.security.cert.CertificateFactory;
import java.security.spec.NamedParameterSpec;
import java.security.spec.PKCS8EncodedKeySpec;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeSet;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;
import java.util.zip.ZipOutputStream;

public class Test {

    // Mapping from KEM certs to their signer algorithms
    static final Map<String, String> KEM_2_DSA = Map.of(
            "2.16.840.1.101.3.4.4.1", "2.16.840.1.101.3.4.3.17",
            "2.16.840.1.101.3.4.4.2", "2.16.840.1.101.3.4.3.18",
            "2.16.840.1.101.3.4.4.3", "2.16.840.1.101.3.4.3.19");

    static final Map<String,String> OID_2_NAME = Map.of(
            "2.16.840.1.101.3.4.3.17", "ml-dsa-44",
            "2.16.840.1.101.3.4.3.18", "ml-dsa-65",
            "2.16.840.1.101.3.4.3.19", "ml-dsa-87",
            "2.16.840.1.101.3.4.4.1", "ml-kem-512",
            "2.16.840.1.101.3.4.4.2", "ml-kem-768",
            "2.16.840.1.101.3.4.4.3", "ml-kem-1024");

    public static void main(String[] args) throws Exception {
        if (args.length == 0) {
            // By default, it generates artifact and check on it.
            gen();
            check("openjdk");
        } else if (args[0].equals("check")) {
            // Check on artifact (in ../args[1]) and write report
            check(args.length > 1 ? args[1] : "openjdk");
        } else if (args[0].equals("gen")) {
            // Generate artifact in the current directory
            gen();
        }
    }

    static void check(String provider) throws Exception {

        var passed = new TreeSet<String>();
        var failed = new TreeSet<String>();
        var allss = new HashMap<String,byte[]>();
        var allct = new HashMap<String,byte[]>();
        var allcerts = new HashMap<String, Certificate>();
        var allkeys = new HashMap<String, NamedPKCS8Key>();

        var filename = "../" + provider + "/artifacts_certs_r5.zip";
        if (!new File(filename).exists()) {
            return;
        }
        try (var fis = new FileInputStream(filename);
                var zis = new ZipInputStream(fis)) {
            var cf = CertificateFactory.getInstance("X.509");
            while (true) {
                var ze = zis.getNextEntry();
                if (ze == null) break;
                var zname = ze.getName();
                var pos = zname.indexOf("2.16.");
                if (pos < 0) {
                    System.out.println("unknown alg: " + zname);
                    continue;
                }
                var name = zname.substring(pos);
                var oid = name.substring(0, name.indexOf('_'));
                var type = name.substring(name.indexOf('_') + 1);
                KeyFactory kf;
                try {
                    kf = KeyFactory.getInstance(oid);
                } catch (Exception e) {
                    System.out.println("no factory: " + zname + ", I tried " + oid);
                    continue;
                }
                var bytes = zis.readAllBytes();
                switch (type) {
                    case "priv.der", "seed_priv.der", "expandedkey_priv.der", "both_priv.der" -> {
                        var label = switch (type) {
                            case "seed_priv.der" -> "seed";
                            case "expandedkey_priv.der" -> "expandedkey";
                            case "both_priv.der" -> "both";
                            default -> null;
                        };
                        try {
                            var sk = (NamedPKCS8Key) kf.generatePrivate(new PKCS8EncodedKeySpec(bytes));
                            var old = allkeys.get(oid);
                            if (old != null) {
                                if (!Arrays.equals(old.getExpanded(), sk.getExpanded())) {
                                    System.out.println("different key: " + zname);
                                    failed.add(oid + ",consistent");
                                }
                            } else {
                                allkeys.put(oid, sk);
                            }
                            if (label != null) {
                                passed.add(oid + "," + label);
                                passed.add(oid + ",consistent"); // no problem, failed always overwrite passed
                            }
                        } catch (Exception e) {
                            System.out.println("cannot parse file: " + zname + ": " + e);
                            if (label != null) {
                                failed.add(oid + "," + label);
                            }
                        }
                    }
                    case "ss.bin" -> {
                        allss.put(oid, bytes);
                    }
                    case "ciphertext.bin" -> {
                        allct.put(oid, bytes);
                    }
                    case "ta.der", "ee.der" -> {
                        try {
                            allcerts.put(oid, cf.generateCertificate(new ByteArrayInputStream(bytes)));
                        } catch (Exception e) {
                            System.out.println("cannot parse cert: " + zname + ": " + e);
                            failed.add(oid);
                        }
                    }
                    default -> {
                        System.out.println("unknown file type: " + zname);
                    }
                }
            }
        }
        for (var oid : allct.keySet()) {
            try {
                var kem = KEM.getInstance(oid);
                var e = kem.newDecapsulator(allkeys.get(oid));
                if (!Arrays.equals(e.decapsulate(allct.get(oid)).getEncoded(), allss.get(oid))) {
                    System.out.println("decapsulation failure: " + oid);
                    failed.add(oid + ",cert");
                } else {
                    passed.add(oid + ",cert");
                }
            } catch (Exception e) {
                System.out.println("cannot decapsulate: " + e);
                failed.add(oid);
            }
        }
        for (var oid : allcerts.keySet()) {
            try {
                var pk = KEM_2_DSA.containsKey(oid)
                        ? allcerts.get(KEM_2_DSA.get(oid))
                        : allcerts.get(oid);
                if (pk != null) {
                    allcerts.get(oid).verify(pk.getPublicKey());
                    passed.add(oid + ",cert");
                }
            } catch (Exception e) {
                System.out.println("unverified certs: " + oid);
                failed.add(oid + ",cert");
            }
        }
        var dir = Files.createDirectories(Path.of("compatMatrices", "artifacts_certs_r5"));
        try (var w = Files.newBufferedWriter(dir.resolve(provider + "_openjdk.csv"))) {
            w.write("key_algorithm_oid,test_result\n");
            for (var key : passed) {
                if (failed.contains(key)) {
                    w.write(key + ",N\n");
                    failed.remove(key);
                } else {
                    w.write(key + ",Y\n");
                }
            }
            for (var oid : failed) {
                w.write(oid + ",N\n");
            }
        }
    }

    static void gen() throws Exception {
        var seed = new byte[64];
        new SecureRandom().nextBytes(seed);
        var random = new SecureRandom() {
            @Override
            public void nextBytes(byte[] bytes) {
                assert bytes.length < 65;
                System.arraycopy(seed, 0, bytes, 0, bytes.length);
            }
        };
        try (var fos = new FileOutputStream("artifacts_certs_r5.zip");
                var zos = new ZipOutputStream(fos)) {
            for (var oidAndName : OID_2_NAME.entrySet()) {
                var oid = oidAndName.getKey();
                var name = oidAndName.getValue();
                var g = KeyPairGenerator.getInstance(name);
                g.initialize(new NamedParameterSpec(name), random);
                KeyPair kp = null;
                for (var format : List.of("seed", "expandedkey", "both")) {
                    System.setProperty("jdk.ml" + name.substring(3, 6) + ".pkcs8.encoding", format);
                    kp = g.generateKeyPair();
                    byte[] bytes = kp.getPrivate().getEncoded();
                    zos.putNextEntry(new ZipEntry(name + "-" + oid + "_" + format + "_priv.der"));
                    zos.write(bytes);
                }
                if (oidAndName.getValue().startsWith("ml-kem")) {
                    var kem = KEM.getInstance("ML-KEM");
                    var e = kem.newEncapsulator(kp.getPublic());
                    var enc = e.encapsulate();
                    byte[] bytes1 = enc.encapsulation();
                    zos.putNextEntry(new ZipEntry(name + "-" + oid + "_ciphertext.bin"));
                    zos.write(bytes1);
                    byte[] bytes = enc.key().getEncoded();
                    zos.putNextEntry(new ZipEntry(name + "-" + oid + "_ss.bin"));
                    zos.write(bytes);
                }
            }
            for (var nn : KEM_2_DSA.entrySet()) {
                var koid = nn.getKey();
                var kname = OID_2_NAME.get(koid);
                var doid = nn.getValue();
                var dname = OID_2_NAME.get(doid);
                var g1 = new CertAndKeyGen(dname, dname);
                g1.generate(dname);
                var c1 = g1.getSelfCertificate(new X500Name("CN=" + dname), 100 * 365 * 86400L);
                var g2 = new CertAndKeyGen(kname, dname, null, g1.getPrivateKey(), new X500Name("CN=" + dname));
                g2.generate(kname);
                // The getSelfCertificate name could be misleading. It can also generate certs signed by others.
                var c2 = g2.getSelfCertificate(new X500Name("CN=" + kname), 100 * 365 * 86400L);
                byte[] bytes1 = c1.getEncoded();
                zos.putNextEntry(new ZipEntry(dname + "-" + doid + "_ta.der"));
                zos.write(bytes1);
                byte[] bytes = c2.getEncoded();
                zos.putNextEntry(new ZipEntry(kname + "-" + koid + "_ee.der"));
                zos.write(bytes);
            }
        }
    }

    public static void red(String s) {
        System.err.println("\u001b[1;37;41m" + s + "\u001b[m");
    }
}

