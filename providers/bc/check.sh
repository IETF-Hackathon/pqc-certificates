#!/bin/bash

betas=https://downloads.bouncycastle.org/betas

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

cp=classes:lib/bcprov-${base}.jar:lib/bcutil-${base}.jar:lib/bcpkix-${base}.jar

if [ "$1" != "" ]
then
    java -cp ${cp} R5ArtifactParser bc $1
else
    #
    # verify the certificate artifacts
    #
    if [ -d artifacts ]
    then
        java -cp ${cp} R5ArtifactParser bc artifacts
    else
        java -cp ${cp} R5ArtifactParser bc java-artifacts/artifacts.zip
    fi

    #
    # verify the CMS artifacts (if present)
    #
    if [ -d artifacts_cms_v3 ]
    then
        java -cp ${cp} R5ArtifactParser bc-cms artifacts_cms_v3
    elif [ -f artifacts_cms_v3.zip ]
    then
        java -cp ${cp} R5ArtifactParser bc-cms artifacts_cms_v3.zip
    fi
fi
