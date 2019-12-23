1. To generate root CA use following command:
./RootID.sh -config "config file"

2. To generate Intermediate CA use following command:
./IntermediateCert.sh -config config_Intermediate.conf -cacert "root ca cert" -caprivate "root ca private key"

3. To generate iDevUD use following command:
iDevIDcert.sh -config config_iDevID.conf -cacert "ca cert" -caprivate "ca private key" -cachain "ca chain cert"


