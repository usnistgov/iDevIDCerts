1. To generate root CA use following command:\n
./RootID.sh -config "config file" -cn "Common Name" -out "output Folder Name" \n
Example: \n
./RootID.sh -config config/config_Root.conf -out test -cn root \n

2. To generate Intermediate CA use following command:\n
./IntermediateCert.sh -config config_Intermediate.conf -cacert "root ca cert" -caprivate "root ca private key" -cn "Common Name" -out "output Folder Name" \n
example: \n
bash IntermediateCert.sh -config config/config_Intermediate.conf -cacert test/ca/certs/root.cert.pem -caprivate test/ca/private/root.key.pem -cn Intrmdt -out test\n

3. To generate iDevUD use following command:\n
iDevIDcert.sh -config config_iDevID.conf -cacert "ca cert" -caprivate "ca private key" -cachain "ca chain cert" -cn "Common Name" -out "output Folder Name" \n
Example: \n
bash iDevIDcert.sh -config config/config_iDevID.conf -cacert test/Intermediate/certs/Intrmdt.cert.pem -caprivate test/Intermediate/private/Intrmdt.key.pem -cachain test/Intermediate/certs/Intrmdt.chain.cert.pem -out test -cn DevID


