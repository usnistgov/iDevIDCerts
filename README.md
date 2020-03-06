# 802.1AR Device Certificate Generation scripts

Edit the config following files and change fields as appropriate:

      config/config_iDevID.conf  
      config/config_Intermediate.conf  
      config/config_Root.conf 

To generate root CA use following command:

      ./RootID.sh -config "config file" -cn "Common Name" -out "output Folder Name" 

Example: 

      ./RootID.sh -config config/config_Root.conf -out test -cn root 

Check the ca directory. The root certificate has the name test/ca/certs/root.cert.pem. The common name is used to name the root certificate.

Next, (optionally) generate intermediate certificates.To generate Intermediate CA use following command:

       ./IntermediateCert.sh -config config_Intermediate.conf -cacert "root ca cert" -caprivate "root ca private key" -cn "Common Name" -out "output Folder Name" 

example: 

       ./IntermediateCert.sh -config config/config_Intermediate.conf -cacert test/ca/certs/root.cert.pem -caprivate test/ca/private/root.key.pem -cn Intrmdt -out test

Finally generate the  iDevUD using the following command:

       ./iDevIDcert.sh -config config_iDevID.conf -cacert "ca cert" -caprivate "ca private key" -cachain "ca chain cert" -cn "Common Name" -out "output Folder Name" 

Example: 

      ./iDevIDcert.sh -config config/config_iDevID.conf -cacert test/Intermediate/certs/Intrmdt.cert.pem -caprivate test/Intermediate/private/Intrmdt.key.pem -cachain test/Intermediate/certs/Intrmdt.chain.cert.pem -out test -cn DevID


You can use the root cert directly if you do not want intermediate certificates. For example:


      ./iDevIDcert.sh -config config/config_iDevID.conf -cacert test/ca/certs/root.cert.pem -caprivate test/ca/private/root.key.pem  -out test -cn DevID


In order to convert key or cert from pem to der use the following command:

       ./pemTOder.sh -filetype "key/cert" -in "input pem key path" -out "output der key path"

Example: 

       ./pemTOder.sh -filetype key -in test/iDevID/private/DevID.key.pem -out test/iDevID/private/DevID.key.der

       ./pemTOder.sh -filetype cert -in test/iDevID/certs/DevID.cert.pem -out test/iDevID/certs/DevID.cert.der

Demo Scripts that do the above steps and clean up unncessary files:
 
       rm -rf test1
       sh gencerts-example.sh

The following works with intermediate certificates:

       rm -rf test2
       sh gencerts-example1.sh



# Acknowledgement

The scripts in this repository were obtained from 

[Moskowitz et al. "Guide for building an ECC pki draft-moskowitz-ecdsa-pki-05" *IETF Draft.* March 11, 2019.](https://tools.ietf.org/html/draft-moskowitz-ecdsa-pki-05)

# Disclaimers

The following disclaimer applies to all code that was written by employees of the National Institute of Standards and Technology.

This software was developed by employees of the National Institute of Standards and Technology (NIST), an agency of the Federal Government and is being made available as a public service. Pursuant to title 17 United States Code Section 105, works of NIST employees are not subject to copyright protection in the United States. This software may be subject to foreign copyright. Permission in the United States and in foreign countries, to the extent that NIST may hold copyright, to use, copy, modify, create derivative works, and distribute this software and its documentation without fee is hereby granted on a non-exclusive basis, provided that this notice and disclaimer of warranty appears in all copies.

THE SOFTWARE IS PROVIDED 'AS IS' WITHOUT ANY WARRANTY OF ANY KIND, EITHER EXPRESSED, IMPLIED, OR STATUTORY, INCLUDING, BUT NOT LIMITED TO, ANY WARRANTY THAT THE SOFTWARE WILL CONFORM TO SPECIFICATIONS, ANY IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND FREEDOM FROM INFRINGEMENT, AND ANY WARRANTY THAT THE DOCUMENTATION WILL CONFORM TO THE SOFTWARE, OR ANY WARRANTY THAT THE SOFTWARE WILL BE ERROR FREE. IN NO EVENT SHALL NIST BE LIABLE FOR ANY DAMAGES, INCLUDING, BUT NOT LIMITED TO, DIRECT, INDIRECT, SPECIAL OR CONSEQUENTIAL DAMAGES, ARISING OUT OF, RESULTING FROM, OR IN ANY WAY CONNECTED WITH THIS SOFTWARE, WHETHER OR NOT BASED UPON WARRANTY, CONTRACT, TORT, OR OTHERWISE, WHETHER OR NOT INJURY WAS SUSTAINED BY PERSONS OR PROPERTY OR OTHERWISE, AND WHETHER OR NOT LOSS WAS SUSTAINED FROM, OR AROSE OUT OF THE RESULTS OF, OR USE OF, THE SOFTWARE OR SERVICES PROVIDED HEREUNDER.


