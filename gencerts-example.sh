#!/bin/bash
# Example to generate certificates without intermediate certs.
CERT_DIR=test1
CA_CERT_DIR=test1
./RootID.sh -config config/config_Root.conf -out $CERT_DIR -cn root
./iDevIDcert.sh -config config/config_iDevID.conf -cacert $CA_CERT_DIR/ca/certs/root.cert.pem -caprivate $CERT_DIR/ca/private/root.key.pem  -out $CERT_DIR -cn DevID -sn 5000
./pemTOder.sh -filetype key -in $CERT_DIR/iDevID/private/DevID.key.pem -out $CERT_DIR/iDevID/private/DevID.key.der
rm -f $CA_CERT_DIR/ca/index.*
rm -f $CA_CERT_DIR/ca/serial*
rm -rf $CA_CERT_DIR/ca/newcerts
rm -rf $CERT_DIR/ca/csr
rm -rf $CERT_DIR/iDevID/serial*
rm -rf $CERT_DIR/iDevID/newcerts
rm -rf $CERT_DIR/iDevID/csr
