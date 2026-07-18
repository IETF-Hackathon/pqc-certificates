#!/bin/bash

betas=https://www.bouncycastle.org/betas

(
  cd lib

  rm -f *.ver

  wget ${betas}/beta.ver
)

base=`cat lib/beta.ver`

(
  cd lib

  if [ \! -f bcprov-${base}.jar ]
  then
  	rm -f *.jar
  	wget ${betas}/bcprov-${base}.jar
  fi

  if [ \! -f bcpkix-${base}.jar ]
  then
  	wget ${betas}/bcpkix-${base}.jar
  fi

  if [ \! -f bcutil-${base}.jar ]
  then
  	wget ${betas}/bcutil-${base}.jar
  fi
)

javac -d classes -cp lib/bcprov-${base}.jar:lib/bcutil-${base}.jar:lib/bcpkix-${base}.jar src/main/java/*.java

#
# regenerate the artifacts, removing any output from a previous run first
#
rm -rf artifacts artifacts_certs_r5 artifacts_cms_v3

java -cp classes:lib/bcprov-${base}.jar:lib/bcutil-${base}.jar:lib/bcpkix-${base}.jar R5ArtifactGenerator

#
# package the artifacts:
#   - certificates under a top-level "artifacts/" directory (also read by check.sh)
#   - CMS artifacts under a top-level "artifacts_cms_v3/" directory
#
mv artifacts_certs_r5 artifacts

rm -f artifacts_certs_r5.zip artifacts_cms_v3.zip

zip -rqX artifacts_certs_r5.zip artifacts
zip -rqX artifacts_cms_v3.zip artifacts_cms_v3
