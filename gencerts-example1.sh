#!/bin/bash
# Example to generate certificates without intermediate certs.
CERT_DIR=test2
CA_CERT_DIR=test2
./RootID.sh -config config/config_Root.conf -out $CERT_DIR -cn root
./IntermediateCert.sh -config config/config_Intermediate.conf -cacert $CERT_DIR/ca/certs/root.cert.pem -caprivate $CERT_DIR/ca/private/root.key.pem -cn Intrmdt -out $CERT_DIR
./iDevIDcert.sh -config config/config_iDevID.conf -cacert $CERT_DIR/Intermediate/certs/Intrmdt.cert.pem -caprivate $CERT_DIR/Intermediate/private/Intrmdt.key.pem -cachain $CERT_DIR/Intermediate/certs/Intrmdt.chain.cert.pem -out $CERT_DIR -cn DevID -sn 500
./pemTOder.sh -filetype key -in $CERT_DIR/iDevID/private/DevID.key.pem -out $CERT_DIR/iDevID/private/DevID.key.der
rm -f $CA_CERT_DIR/ca/index.*
rm -f $CA_CERT_DIR/ca/serial*
rm -rf $CA_CERT_DIR/ca/newcerts
rm -rf $CERT_DIR/ca/csr
rm -rf $CERT_DIR/iDevID/serial*
rm -rf $CERT_DIR/iDevID/newcerts
rm -rf $CERT_DIR/iDevID/csr
rm -rf $CERT_DIR/Intermediate/csr
rm -rf $CERT_DIR/Intermediate/crl
rm -rf $CERT_DIR/Intermediate/newcerts

