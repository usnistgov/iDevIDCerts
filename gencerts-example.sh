#!/bin/bash
# Example to generate certificates without intermediate certs.
./RootID.sh -config config/config_Root.conf -out test -cn root
./iDevIDcert.sh -config config/config_iDevID.conf -cacert test/ca/certs/root.cert.pem -caprivate test/ca/private/root.key.pem  -out test -cn DevID -sn 5000
./pemTOder.sh -filetype key -in test/iDevID/private/DevID.key.pem -out test/iDevID/private/DevID.key.der
rm -f test/ca/index.*
rm -f test/ca/serial*
rm -rf test/ca/newcerts
rm -rf test/ca/csr
rm -rf test/iDevID/serial*
rm -rf test/iDevID/newcerts
rm -rf test/iDevID/csr
