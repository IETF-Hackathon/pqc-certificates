#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
set -e


cd $SCRIPT_DIR

base=`cat lib/beta.ver`

javac -d classes -cp lib/bcprov-${base}.jar:lib/bcutil-${base}.jar:lib/bcpkix-${base}.jar src/main/java/*.java

java -cp classes:lib/bcprov-${base}.jar:lib/bcutil-${base}.jar:lib/bcpkix-${base}.jar Verify self-signed $1
