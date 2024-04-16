# Local cert

# Create cert
* `openssl req -config openssl-server.cnf -newkey rsa:2048 -sha256 -nodes -out local.csr -outform PEM`
* `openssl ca -config ../rootCA/openssl-ca.cnf -policy signing_policy -extensions signing_req -out local.cert.pem -infiles local.csr`
