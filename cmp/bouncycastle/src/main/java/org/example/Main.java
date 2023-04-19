package org.example;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.stream.Stream;


public class Main {
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

        CmpLogic.init();


        int filesProcessed = 0;
        for (Path requestPath : requestPaths) {
            CmpLogic.processCmpRequest(requestPath);
            filesProcessed++;
        }

        System.out.printf("Done! %d files", filesProcessed);
    }

}
