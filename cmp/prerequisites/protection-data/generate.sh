# You can also run it as `bash readme.md`
# For the CA
openssl ecparam -name secp256k1 -genkey -noout -out ca-priv_key.pem
openssl req -out ca-csr.pem -new -key ca-priv_key.pem -nodes -subj "/CN=Issuing CAsig"
openssl x509 -signkey ca-priv_key.pem -in ca-csr.pem -req -days 3650 -out ca.crt


# For the EE
openssl ecparam -name secp256k1 -genkey -noout -out ee-priv_key.pem
openssl req -out ee-csr.pem -new -key ee-priv_key.pem -nodes -subj "/CN=End Entity demo"
openssl x509 -signkey ee-priv_key.pem -in ee-csr.pem -req -days 1850 -out ee.crt
