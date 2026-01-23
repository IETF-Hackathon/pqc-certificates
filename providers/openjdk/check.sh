#! /bin/bash

# If no arg, check openjdk; otherwise, another provider name
java --add-exports java.base/sun.security.pkcs=ALL-UNNAMED \
	--add-exports java.base/sun.security.tools.keytool=ALL-UNNAMED \
	--add-exports java.base/sun.security.x509=ALL-UNNAMED \
	Test.java check $1
