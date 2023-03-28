$INDIR=$args[0] + ".\artifacts"

$compatMatrixFile = "compatMatrix.csv"
Remove-Item $compatMatrixFile -ErrorAction SilentlyContinue


Expand-Archive -Force -Path "$INDIR.zip" -DestinationPath $INDIR

foreach ($oiddir in Get-ChildItem -Directory $INDIR ) {

    $oid = $oiddir.FullName.split('\')[-1]
    $compatMatrixEntry =[pscustomobject]@{
        'key_algorithm_oid' = $oid
        'ta' = ''
        'ca' = ''
        'ee' = ''
        'crl_ta' = ''
        'crl_ca' = ''
    }


    "" | Write-Output # newline to cluster OID groups
    foreach ($dir in Get-ChildItem -Directory $oiddir.FullName) {

        $fullDir = $dir.FullName
        $basedir = $fullDir.Split('\')[-1]
        switch ($baseDir)
        {
            "ta" {
                $stdout = (.\pqutil.bat verify -certchain "$fullDir\ta.der") | Out-String

                if ($stdout.Contains("Certificate Chain Verified!")) {
                    "Passed: $oid TA Certificate" | Write-Output
                    $compatMatrixEntry.ta = 'Y'

                } else {
                    "FAILED: $oid TA Certificate." | Write-Output
                    $compatMatrixEntry.ta = 'N'
                }
            }

            "ca" {
                $stdout = (.\pqutil.bat verify -certchain "$fullDir\ca.der" -certchain "$fullDir\..\ta\ta.der") | Out-String
                
                if ($stdout.Contains("Certificate Chain Verified!")) {
                    "Passed: $oid CA Certificate." | Write-Output
                    $compatMatrixEntry.ca = 'Y'

                } else {
                    "FAILED: $oid CA Certificate." | Write-Output
                    $compatMatrixEntry.ca = 'N'
                }
            }
            "ee" {
                # check the EE CSR
                # TODO: this one's broken. 
                # .\pqutil.bat verify -csr "$fullDir\ee.csr"

                # check the EE cert
                $stdout = (.\pqutil.bat verify -cer "$fullDir\cert.der" -certchain "$fullDir\..\ta\ta.der" -certchain "$fullDir\..\ca\ca.der") | Out-String

                if ($stdout.Contains("Certificate Chain Verified!")) {
                    "Passed: $oid EE Certificate Chain." | Write-Output
                    $compatMatrixEntry.ee = 'Y'

                } else {
                    "FAILED: $oid EE Certificate Chain." | Write-Output
                    $compatMatrixEntry.ee = 'N'
                }
            }
            "crl" {
                # verify TA crl
                $stdout = (.\pqutil.bat verify -crl "$fullDir\crl_ta.crl" -certchain "$fullDir\..\ta\ta.der") | Out-String

                if ($stdout.Contains("Certificate Chain Verified!")) {
                    "Passed: $oid TA CRL." | Write-Output
                    $compatMatrixEntry.crl_ta = 'Y'

                } else {
                    "FAILED: $oid TA CRL." | Write-Output
                    $compatMatrixEntry.crl_ta = 'N'
                }


                # # verify CA CRL
                $stdout = (.\pqutil.bat verify -crl "$fullDir\crl_ca.crl" -certchain "$fullDir\..\ta\ta.der" -certchain "$fullDir\..\ca\ca.der") | Out-String

                if ($stdout.Contains("Certificate Chain Verified!")) {
                    "Passed: $oid CA CRL." | Write-Output
                    $compatMatrixEntry.crl_ca = 'Y'

                } else {
                    "FAILED: $oid CA CRL." | Write-Output
                    $compatMatrixEntry.crl_ca = 'N'
                }
            }
            "ocsp" {echo "It's OCSP. ... not implemented yet."}
        }
    }
    $compatMatrixEntry | Export-CSV $compatMatrixFile -Append -NoTypeInformation
}

