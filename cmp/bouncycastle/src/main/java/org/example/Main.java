package org.example;

import net.sourceforge.argparse4j.ArgumentParsers;
import net.sourceforge.argparse4j.inf.ArgumentParser;
import net.sourceforge.argparse4j.inf.ArgumentParserException;
import net.sourceforge.argparse4j.inf.Namespace;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.stream.Stream;
import java.util.logging.Logger;

public class Main {
    private static final Logger log = Logger.getLogger("main");
    // taken from https://github.com/bcgit/bc-java/blob/master/prov/src/main/java/org/bouncycastle/pqc/jcajce/provider/BouncyCastlePQCProvider.java#L38
    // and removed some entries that didn't work in practice
    // NOTE: these are still not tested: "LMS", "NH", "CMCE", "Frodo", "SABER", "NTRU", "NTRUPrime", "BIKE",  "HQC", "Rainbow",
    //       "Kyber","Falcon",
    static String[] supportedAlgorithms = {"Dilithium", "XMSS", "SPHINCSPlus", "Picnic"};
    public static void main(String[] args) throws Exception {

        ArgumentParser parser = ArgumentParsers.newFor("Main").build()
                .defaultHelp(true)
                .description("Process CMP requests");

        parser.addArgument("input")
                .help("Path for the input directory with CMP requests")
                .type(String.class);

        parser.addArgument("-a", "--algorithm")
                .help("Algorithm to use when issuing a certificate")
                .choices(supportedAlgorithms).setDefault("Dilithium");

        Namespace res = null;
        try {
            res = parser.parseArgs(args);
        } catch (ArgumentParserException e) {
            parser.handleError(e);
            return;
        }

        Path sourcePath = Paths.get(res.getString("input"));
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

        CmpLogic.init(res.getString("algorithm"));


        int filesProcessed = 0;
        for (Path requestPath : requestPaths) {
            CmpLogic.processCmpRequest(requestPath);
            filesProcessed++;
        }

        log.info("Done! Processed files: " + filesProcessed);
    }

}
