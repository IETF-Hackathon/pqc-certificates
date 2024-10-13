/*
* This is a simple HTTP wrapper around the CMP logic. It exposes an endpoint at /pkix, where it expects CMP requests
* to arrive in the form described in RFC 6712.
* It is not production-ready, it is not scalable, it is only suitable for a development server to test against.
* */

package org.example;

import java.io.*;
import java.net.InetSocketAddress;

import com.sun.net.httpserver.Headers;
import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import com.sun.net.httpserver.HttpServer;
import org.bouncycastle.cert.cmp.ProtectedPKIMessage;

public class MainCmpHttp {
    public static void main(String[] args) throws Exception {
        HttpServer server = HttpServer.create(new InetSocketAddress(8000), 0);
        server.createContext("/pkix", new CmpHandler());
        server.setExecutor(null);

        CmpLogic.init("Dilithium");
        System.out.println("Starting HTTP server");
        server.start();
    }

    static class CmpHandler implements HttpHandler {
        public void returnError(HttpExchange t, String error) throws IOException {
            t.sendResponseHeaders(400, error.getBytes().length);
            OutputStream os = t.getResponseBody();
            os.write(error.getBytes());
            os.close();

        }

        @Override
        public void handle(HttpExchange t) throws IOException {

            if (! t.getRequestMethod().equalsIgnoreCase("POST")) {
                returnError(t, "Only POST requests are supported");
                return;
            }

            Headers requestHeaders = t.getRequestHeaders();

            if (! "application/pkixcmp".equalsIgnoreCase(requestHeaders.getFirst("content-type"))) {
                returnError(t, "Content-Type should be `application/pkixcmp`");
                return;
            }


            InputStream requestBody = t.getRequestBody();
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            byte[] buffer = new byte[1024*640]; // ought to be enough for anybody; but think about the size of average PQ keys
            int len;
            while ((len = requestBody.read(buffer)) != -1) {
                baos.write(buffer, 0, len);
            }
            byte[] requestBodyBytes = baos.toByteArray();
            System.out.println("Got request: " + requestBodyBytes.length);
            try {
                ProtectedPKIMessage cmpResponse = CmpLogic.issueCertificate(requestBodyBytes);
                System.out.println("Issued cert");
                // Send response headers
                Headers responseHeaders = t.getResponseHeaders();
                responseHeaders.set("Content-Type", "application/pkixcmp");
                t.sendResponseHeaders(200, 0);

                byte[] encodedResponse = cmpResponse.toASN1Structure().getEncoded();
                // Send response body
                OutputStream responseBody = t.getResponseBody();
                responseBody.write(encodedResponse);
                responseBody.close();

                System.out.println("Sent response: " +  encodedResponse.length);
            } catch (Exception e) {
                returnError(t, "Could not parse your payload, is it a valid PKIMessage?");
                throw new RuntimeException(e);
            }
            System.out.println("Done!");
        }
    }

}