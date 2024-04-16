# Root 

## Create Root Certifcate
* `touch index.txt`
* `echo "01" > serial.txt`
* `openssl req -x509 -config openssl-ca.cnf -days 1000 -newkey rsa:4096 -sha256 -nodes -out rootCA.pem -outform PEM`