   #!/bin/bash

   sq=53
   export rt=IDevIDModule
   mkdir -p $rt
   export intrdir=${cadir-$rt/Intermediate}
   export cfgdir=$rt
   export cadir=${cadir-$rt/ca}
   export rootca=$cadir
   export dir=$intrdir
   export sn=8


   # edit these to suit

   echo $DN
   export subjectAltName=email:postmaster@htt-consult.com
   export default_crl_days=2048
   export format=pem
   export default_crl_days=65
   
   ####################################### 802.1AR Intermediate pki########################################

   mkdir -p $intrdir
   #cd $dir    
   mkdir -p $intrdir/certs $intrdir/crl $intrdir/csr $intrdir/newcerts $intrdir/private
   chmod 700 private
   touch index.txt
   sn=8 # hex 8 is minimum, 19 is maximum
   echo 1000 > crlnumber

   crl=intermediate.crl.pem
   crlurl=www.htt-consult.com/pki/$crl
   export crlDP="URI:http://$crlurl"
   export default_crl_days=30
   export ocspIAI=
   export flg=0
   export flgcrt=0
   export cnfg=""
   export cacert=""
   export caprvt=""
   
   for arg in "$@"
	do
	   if [ "$flg" == 1 ]; then
		cnfg=$arg
		flg=0
	   fi

	   if [ "$flgcrt" == 1 ]; then
		cacert=$arg
		flgcrt=0
	   fi

	   if [ "$flgprvt" == 1 ]; then
			caprvt=$arg
			flgprvt=0
	   fi

	   if [ "$arg" == "--config" ] || [ "$arg" == "-config" ];    then
		flg=1
	    fi

	   if [ "$arg" == "--cacert" ] || [ "$arg" == "-cacert" ];    then
		flgcrt=1
	    fi

	   if [ "$arg" == "--caprivate" ] || [ "$arg" == "-caprivate" ];    then
			flgprvt=1
           fi
   done	

   source $cnfg
   commonName=$commonName$sq
   DN=$countryName$stateOrProvinceName$localityName$organizationName
   DN=$DN$organizationalUnitName$commonName
   
   export subjectAltName=email:postmaster@htt-consult.com


   export rootCertPath=

   ######################################## 802.1AR Intermediate Certificate#########################################################
   
   # Create passworded keypair file
   openssl genpkey -algorithm ec -pkeyopt ec_paramgen_curve:prime256v1 -outform $format -pkeyopt ec_param_enc:named_curve -out $intrdir/private/intermediate.key.$format
   #changes below  
   chmod 700 $intrdir/private/intermediate.key.$format
   openssl pkey -inform $format -in $intrdir/private/intermediate.key.$format -text -noout
   
   # Create the CSR
   openssl req -config $cfgdir/openssl-intermediate.cnf -key $intrdir/private/intermediate.key.$format -keyform $format -outform $format -subj "$DN" -new -sha256 -out $intrdir/csr/intermediate.csr.$format
   openssl req -text -noout -verify -inform $format -in $intrdir/csr/intermediate.csr.$format
   
   openssl rand -hex $sn > $intrdir/serial # hex 8 is minimum, 19 is maximum
   # Note 'openssl ca' does not support DER format
   #echo ca -config $cfgdir/openssl-root.cnf -days 3650 -extensions v3_intermediate_ca -notext -md sha256 -in $intrdir/csr/intermediate.csr.$format -out $intrdir/certs/intermediate.cert.pem
   openssl ca -config $cfgdir/openssl-intermediate.cnf -days 3650 -extensions v3_intermediate_ca -notext -md sha256 -in $intrdir/csr/intermediate.csr.$format -out $intrdir/certs/intermediate.cert.pem

   chmod 444 $intrdir/certs/intermediate.cert.$format
   #echo openssl verify -CAfile $rootca/certs/ca.cert.$format $intrdir/certs/intermediate.cert.$format
   #openssl verify -CAfile $rootca/certs/ca.cert.$format $intrdir/certs/intermediate.cert.$format
   openssl verify -CAfile $cacert $intrdir/certs/intermediate.cert.$format
   openssl x509 -noout -text -in $intrdir/certs/intermediate.cert.$format

   # Create the certificate chain file
   #cat $intrdir/certs/intermediate.cert.$format $rootca/certs/ca.cert.$format > $intrdir/certs/ca-chain.cert.$format
   cat $intrdir/certs/intermediate.cert.$format $cacert > $intrdir/certs/ca-chain.cert.$format
   chmod 444 $intrdir/certs/ca-chain.cert.$format

   
   
   
   
   
