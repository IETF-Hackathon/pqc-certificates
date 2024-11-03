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

java -cp classes:lib/bcprov-${base}.jar:lib/bcutil-${base}.jar:lib/bcpkix-${base}.jar R3ArtifactGenerator
