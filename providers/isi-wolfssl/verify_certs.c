/* falcon_certverify.c
 *
 * Copyright (C) 2021 wolfSSL Inc.
 *
 * This file is part of wolfSSL.
 *
 * wolfSSL is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * wolfSSL is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1335, USA
 */

/*
 * Modified for the IETF 117 "PQ in X.509, Signatures, KEMs and protocols" Hackathon by
 * George Tasopoulos (Industrial Systems Institute / ATHENA R.C.) at 22-23 July 2023.
 */


#include <stdio.h>
#include <wolfssl/options.h>
#include <wolfssl/ssl.h>
#include <wolfssl/wolfcrypt/error-crypt.h>
#include <wolfssl/test.h>



int main(int argc, char **argv)
{
    int ret = -1;
    WOLFSSL_CERT_MANAGER* cm = NULL;

    const char* ta_cert = "";
    const char* ca_cert = "";
    const char* ee_cert = "";

    if (argc == 3) {
        ta_cert = argv[1];
        ca_cert = argv[2];
    } 
    else if (argc == 4) {
        ta_cert = argv[1];
        ca_cert = argv[2];
        ee_cert = argv[3];
    } 
    else {
        printf("usage: %s [<TA Cert> <CA Cert> <Entity Cert>]\n", argv[0]);
        return 0;
    }

    wolfSSL_Init();

    cm = wolfSSL_CertManagerNew();
    if (cm == NULL) {
        printf("wolfSSL_CertManagerNew() failed\n");
        return -1;
    }


    // Load the self-signed Trust Anchor into CertManager
    ret = wolfSSL_CertManagerLoadCA(cm, ta_cert, NULL);
    if (ret != WOLFSSL_SUCCESS) {

        if (argc == 3) {
            printf("N,N,,,\n");
        }
        else if (argc == 4) {
            printf("N,N,N,,\n");
        }
        goto exit;
    }

    // Verify the TA, signed by itself
    ret = wolfSSL_CertManagerVerify(cm, ta_cert, WOLFSSL_FILETYPE_PEM);
    if (ret != WOLFSSL_SUCCESS) {

        if (argc == 3) {
            printf("N,N,,,\n");
        }
        else if (argc == 4) {
            printf("N,N,N,,\n");
        }        

        goto exit;
    }
    else {
        // Write to Y to csv
        printf("Y,");
    }

    // Verify the Certificate Authority, signed by the TA
    ret = wolfSSL_CertManagerVerify(cm, ca_cert, WOLFSSL_FILETYPE_PEM);
    if (ret != WOLFSSL_SUCCESS) {


        if (argc == 3) {
            printf("N,,,\n");
        }
        else if (argc == 4) {
            printf("N,N,,\n");
        }   

        goto exit;
    }
    else {
        // Write Y to csv
        if (argc == 3) {
            printf("Y,,,\n");
        }
        else if (argc == 4) {
            printf("Y,");
        }   

    }

    if (XSTRCMP(ee_cert, "") != 0) {

        // Load the Certificate Authority as a verifier into CertManager
        ret = wolfSSL_CertManagerLoadCA(cm, ca_cert, NULL);
        if (ret != WOLFSSL_SUCCESS) {

        goto exit;
    }

        // Verify the End Entity certificate
        ret = wolfSSL_CertManagerVerify(cm, ee_cert, WOLFSSL_FILETYPE_PEM);
        if (ret != WOLFSSL_SUCCESS) {

            printf("N,,\n");

            goto exit;
        }
        else {
            // Write Y to csv
            printf("Y,,\n");
        }
    }

exit:
    wolfSSL_CertManagerFree(cm);
    wolfSSL_Cleanup();


    return ret;
}
