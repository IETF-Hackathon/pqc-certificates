$OUTDIR=".\artifacts"




Function Create-TA([string] $OUTDIR, [string] $KEYALG, [string] $SIGALG) {
    mkdir -Force $OUTDIR\ta
    .\pqutil.bat keygen -alg $KEYALG -pubout "$OUTDIR\ta\ta_pub.der" -privout "$OUTDIR\ta\ta_priv.der"
    .\pqutil.bat newcsr -pubkey "$OUTDIR\ta\ta_pub.der" -privkey "$OUTDIR\ta\ta_priv.der" -csrout "$OUTDIR\ta\ta.csr" -sigalg $SIGALG.Split(" ")
    .\pqutil.bat newca -capubkey "$OUTDIR\ta\ta_pub.der" -caprivkey "$OUTDIR\ta\ta_priv.der" -certout "$OUTDIR\ta\ta.der" -sigalg $SIGALG
}


Function Create-CA([string] $OUTDIR, [string] $KEYALG, [string] $SIGALG) {
    mkdir -Force $OUTDIR\ca
    .\pqutil.bat keygen -alg $KEYALG -pubout "$OUTDIR\ca\ca_pub.der" -privout "$OUTDIR\ca\ca_priv.der"
    .\pqutil.bat newcsr -pubkey "$OUTDIR\ca\ca_pub.der" -privkey "$OUTDIR\ca\ca_priv.der" -csrout "$OUTDIR\ca\ca.csr" -sigalg $SIGALG.Split(" ")
    .\pqutil.bat issue -csr "$OUTDIR\ca\ca.csr.der" -caprivkey "$OUTDIR\ta\ta_priv.der" -certout "$OUTDIR\ca\ca.der" -sigalg $SIGALG.Split(" ") -subca
}

Function Create-EE([string] $OUTDIR, [string] $KEYALG, [string] $SIGALG) {
    mkdir -Force $OUTDIR\ee
    .\pqutil.bat keygen -alg $KEYALG -pubout "$OUTDIR\ee\cert_pub.der" -privout "$OUTDIR\ee\cert_priv.der"
    .\pqutil.bat newcsr -pubkey "$OUTDIR\ee\cert_pub.der" -privkey "$OUTDIR\ee\cert_priv.der" -csrout "$OUTDIR\ee\cert.csr" -sigalg $SIGALG.Split(" ")
    .\pqutil.bat issue -csr "$OUTDIR\ee\cert.csr.der" -caprivkey "$OUTDIR\ca\ca_priv.der" -certout "$OUTDIR\ee\cert.der" -sigalg $SIGALG.Split(" ")
}

Function Create-CRLs([string] $OUTDIR, [string] $SIGALG) {
    mkdir -Force $OUTDIR\crl

    # CRL for TA
    .\pqutil.bat issuecrl -cacert "$OUTDIR\ta\ta.der" -caprivkey "$OUTDIR\ta\ta_priv.der" -crlfile "$OUTDIR\crl\crl_ta.crl" -createnew -sigalg $SIGALG.Split(" ")

    # Create an EE to revoke
    .\pqutil.bat issue -csr "$OUTDIR\ee\cert.csr.der" -caprivkey "$OUTDIR\ca\ca_priv.der" -certout "$OUTDIR\crl\revoked.der" -sigalg $SIGALG.Split(" ")

    # CRL for CA
    .\pqutil.bat issuecrl -cacert "$OUTDIR\ca\ca.der" -caprivkey "$OUTDIR\ca\ca_priv.der" -crlfile "$OUTDIR\crl\crl_ca.crl.der" -createnew -addrevocation "$OUTDIR\crl\revoked.der" -sigalg $SIGALG

}

Function Create([string] $OUTDIR, [string] $KEYALG, [string] $SIGALG) {
    Create-TA -OUTDIR $OUTDIR -KEYALG $KEYALG -SIGALG $SIGALG
    Create-CA -OUTDIR $OUTDIR -KEYALG $KEYALG -SIGALG $SIGALG
    Create-EE -OUTDIR $OUTDIR -KEYALG $KEYALG -SIGALG $SIGALG
    Create-CRLs -OUTDIR $OUTDIR -SIGALG $SIGALG
}



Function Create-Composite-TA([string] $OUTDIR, [string] $KEYALG1, [string] $KEYALG2, [string] $SIGALG1, [string] $SIGALG2) {
    mkdir -Force $OUTDIR\ta
    .\pqutil.bat keygen -alg $KEYALG1.Split(" ") -alg $KEYALG2.Split(" ") -pubout "$OUTDIR\ta\ta_pub.der" -privout "$OUTDIR\ta\ta_priv.der"
    .\pqutil.bat newcsr -pubkey "$OUTDIR\ta\ta_pub.der" -privkey "$OUTDIR\ta\ta_priv.der" -csrout "$OUTDIR\ta\ta.csr" -sigalg $SIGALG1.Split(" ") -sigalg $SIGALG2.Split(" ")
    .\pqutil.bat newca -capubkey "$OUTDIR\ta\ta_pub.der" -caprivkey "$OUTDIR\ta\ta_priv.der" -certout "$OUTDIR\ta\ta.der" -sigalg $SIGALG1.Split(" ") -sigalg $SIGALG2.Split(" ")
}


Function Create-Composite-CA([string] $OUTDIR, [string] $KEYALG1, [string] $KEYALG2, [string] $SIGALG1, [string] $SIGALG2) {
    mkdir -Force $OUTDIR\ca
    .\pqutil.bat keygen -alg $KEYALG1.Split(" ").Split(" ") -alg $KEYALG2.Split(" ") -pubout "$OUTDIR\ca\ca_pub.der" -privout "$OUTDIR\ca\ca_priv.der"
    .\pqutil.bat newcsr -pubkey "$OUTDIR\ca\ca_pub.der" -privkey "$OUTDIR\ca\ca_priv.der" -csrout "$OUTDIR\ca\ca.csr.der" -sigalg $SIGALG1.Split(" ") -sigalg $SIGALG2.Split(" ")
    .\pqutil.bat issue -csr "$OUTDIR\ca\ca.csr.der" -caprivkey "$OUTDIR\ta\ta_priv.der" -certout "$OUTDIR\ca\ca.der" -sigalg $SIGALG1.Split(" ") -sigalg $SIGALG2.Split(" ") -subca
}

Function Create-Composite-EE([string] $OUTDIR, [string] $KEYALG1, [string] $KEYALG2, [string] $SIGALG1, [string] $SIGALG2) {
    mkdir -Force $OUTDIR\ee
    .\pqutil.bat keygen -alg $KEYALG1.Split(" ") -alg $KEYALG2.Split(" ") -pubout "$OUTDIR\ee\cert_pub.der" -privout "$OUTDIR\ee\cert_priv.der"
    .\pqutil.bat newcsr -pubkey "$OUTDIR\ee\cert_pub.der" -privkey "$OUTDIR\ee\cert_priv.der" -csrout "$OUTDIR\ee\cert.csr.der" -sigalg $SIGALG1.Split(" ") -sigalg $SIGALG2.Split(" ")
    .\pqutil.bat issue -csr "$OUTDIR\ee\cert.csr.der" -caprivkey "$OUTDIR\ca\ca_priv.der" -certout "$OUTDIR\ee\cert.der" -sigalg $SIGALG1.Split(" ") -sigalg $SIGALG2.Split(" ")
}

Function Create-Composite-CRLs([string] $OUTDIR, [string] $SIGALG1, [string] $SIGALG2) {
    mkdir -Force $OUTDIR\crl

    # CRL for TA
    .\pqutil.bat issuecrl -cacert "$OUTDIR\ta\ta.der" -caprivkey "$OUTDIR\ta\ta_priv.der" -crlfile "$OUTDIR\crl\crl_ta.crl.der" -createnew -sigalg $SIGALG1.Split(" ") -sigalg $SIGALG2.Split(" ")

    # Create an EE to revoke
    .\pqutil.bat issue -csr "$OUTDIR\ee\cert.csr.der" -caprivkey "$OUTDIR\ca\ca_priv.der" -certout "$OUTDIR\crl\revoked.der" -sigalg $SIGALG1.Split(" ") -sigalg $SIGALG2.Split(" ")

    # CRL for CA
    .\pqutil.bat issuecrl -cacert "$OUTDIR\ca\ca.der" -caprivkey "$OUTDIR\ca\ca_priv.der" -crlfile "$OUTDIR\crl\crl_ca.crl.der" -createnew -addrevocation "$OUTDIR\crl\revoked.der" -sigalg $SIGALG1.Split(" ") -sigalg $SIGALG2.Split(" ")

}

Function Create-Composite([string] $OUTDIR, [string] $KEYALG1, [string] $KEYALG2, [string] $SIGALG1, [string] $SIGALG2) {
    Create-Composite-TA -OUTDIR $OUTDIR -KEYALG1 $KEYALG1 -KEYALG2 $KEYALG2 -SIGALG1 $SIGALG1 -SIGALG2 $SIGALG2
    Create-Composite-CA -OUTDIR $OUTDIR -KEYALG1 $KEYALG1 -KEYALG2 $KEYALG2 -SIGALG1 $SIGALG1 -SIGALG2 $SIGALG2
    Create-Composite-EE -OUTDIR $OUTDIR -KEYALG1 $KEYALG1 -KEYALG2 $KEYALG2 -SIGALG1 $SIGALG1 -SIGALG2 $SIGALG2
    Create-Composite-CRLs -OUTDIR $OUTDIR -SIGALG1 $SIGALG1 -SIGALG2 $SIGALG2
}




#Create -OUTDIR $OUTDIR\"1.3.6.1.4.1.2.267.7.4.4" -KEYALG "Dilithium2" -SIGALG "Dilithium2"
#Create -OUTDIR $OUTDIR\"1.3.6.1.4.1.2.267.7.6.5" -KEYALG "Dilithium3" -SIGALG "Dilithium3"
#Create -OUTDIR $OUTDIR\"1.3.6.1.4.1.2.267.7.8.7" -KEYALG "Dilithium5" -SIGALG "Dilithium5"
#Create -OUTDIR $OUTDIR\"1.3.6.1.4.1.2.267.11.4.4" -KEYALG "Dilithium2-AES" -SIGALG "Dilithium2-AES"
#Create -OUTDIR $OUTDIR\"1.3.6.1.4.1.2.267.11.6.5" -KEYALG "Dilithium3-AES" -SIGALG "Dilithium3-AES"
#Create -OUTDIR $OUTDIR\"1.3.6.1.4.1.2.267.11.8.7" -KEYALG "Dilithium5-AES" -SIGALG "Dilithium5-AES"
#Create -OUTDIR $OUTDIR\"1.3.9999.3.1" -KEYALG "Falcon-512" -SIGALG "Falcon-512"
#Create -OUTDIR $OUTDIR\"1.3.9999.3.4" -KEYALG "Falcon-1024" -SIGALG "Falcon-1024"

# @John -- these ones throw an error in the toolkit about key length. You'll need to debug that.
# Create -OUTDIR $OUTDIR\"1.3.9999.6.4.1" -KEYALG "SPHINCS+-SHA256-128f-robust" -SIGALG "SPHINCS+-SHA256-128f-robust"
# Create -OUTDIR $OUTDIR\"1.3.9999.6.4.4" -KEYALG "SPHINCS+-SHA256-128f-simple" -SIGALG "SPHINCS+-SHA256-128f-simple"
# Create -OUTDIR $OUTDIR\"1.3.9999.6.4.7" -KEYALG "SPHINCS+-SHA256-128s-robust" -SIGALG "SPHINCS+-SHA256-128s-robust"
# Create -OUTDIR $OUTDIR\"1.3.9999.6.4.10" -KEYALG "SPHINCS+-SHA256-128s-simple" -SIGALG "SPHINCS+-SHA256-128s-simple"
# Create -OUTDIR $OUTDIR\"1.3.9999.6.5.1" -KEYALG "SPHINCS+-SHA256-192f-robust" -SIGALG "SPHINCS+-SHA256-192f-robust"
# Create -OUTDIR $OUTDIR\"1.3.9999.6.5.3" -KEYALG "SPHINCS+-SHA256-192f-simple" -SIGALG "SPHINCS+-SHA256-192f-simple"
# Create -OUTDIR $OUTDIR\"1.3.9999.6.5.5" -KEYALG "SPHINCS+-SHA256-192s-robust" -SIGALG "SPHINCS+-SHA256-192s-robust"
# Create -OUTDIR $OUTDIR\"1.3.9999.6.5.7" -KEYALG "SPHINCS+-SHA256-192s-simple" -SIGALG "SPHINCS+-SHA256-192s-simple"
# Create -OUTDIR $OUTDIR\"1.3.9999.6.6.1" -KEYALG "SPHINCS+-SHA256-256f-robust" -SIGALG "SPHINCS+-SHA256-256f-robust"
# Create -OUTDIR $OUTDIR\"1.3.9999.6.6.3" -KEYALG "SPHINCS+-SHA256-256f-simple" -SIGALG "SPHINCS+-SHA256-256f-simple"
# Create -OUTDIR $OUTDIR\"1.3.9999.6.6.5" -KEYALG "SPHINCS+-SHA256-256s-robust" -SIGALG "SPHINCS+-SHA256-256s-robust"
# Create -OUTDIR $OUTDIR\"1.3.9999.6.6.7" -KEYALG "SPHINCS+-SHA256-256s-simple" -SIGALG "SPHINCS+-SHA256-256s-simple"


Create-Composite -OUTDIR $OUTDIR\"2.16.840.1.114027.80.4.1" -KEYALG1 "Dilithium3" -KEYALG2 "ECDSA P-256" -SIGALG1 "Dilithium3" -SIGALG2 "SHA256withECDSA"

# TODO: @John add explicit composites


# zip it up
Compress-Archive -Force -Path "$OUTDIR\*" -DestinationPath "$OUTDIR.zip"