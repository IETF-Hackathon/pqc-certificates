# Bouncy Castle Trial Artifacts and Validation Tool

## Building

Both generator (in src/main/java) and the validating parser can be built using the latest beta of Bouncy Castle. which can be found at https://www.bouncycastle.org/betas

You will need the jars starting with bcprov-jdk18on, bcpkix-jdk18on, and bcutil-jdk18on to be present in your class path for compiling and running the two utilities.

## ArtifactGenerator

Generates a hierachy in the the current working directory under the directory "artifacts". The tool will create artifacts if it is not present.

## ArtifactParser

Will parse a zip file created from a hierarchy laid out in by the ArtifactGenerator, confirm what signatures it can for certificates, certification requests, and CRLs as well as validating public keys. Note at the moment the tool only checks Falcon and Dilithium.
