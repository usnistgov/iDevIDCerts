   #!/bin/bash

   export flg=0
   export flgcrt=0
   export flgcn=0
   export cnfg=""
   export cacert=""
   export caprvt=""
   export cn=""
   export flgout=0
   export out=""


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

	   if [ "$flgcn" == 1 ]; then
			cn=$arg
			flgcn=0
	   fi
	   if [ "$flgout" == 1 ]; then
		out=$arg
		flgout=0
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

	   if [ "$arg" == "--cn" ] || [ "$arg" == "-cn" ];    then
			flgcn=1
           fi
	   if [ "$arg" == "--out" ] || [ "$arg" == "-out" ];    then
		flgout=1
	   fi
   done	




   #sq=54
   export rt=$out
   mkdir -p $rt
   export intrdir=${cadir-$rt/Intermediate}
   export cfgdir=config
   export cadir=${cadir-$rt/ca}
   export rootca=$cadir
   export dir=$intrdir
   export sn=9


   # edit these to suit

   echo $DN
   export subjectAltName=email:postmaster@htt-consult.com
   #export default_crl_days=2048
   export format=pem
   #export default_crl_days=65

   #crl=intermediate.crl.pem
   #crlurl=www.htt-consult.com/pki/$crl
   #export crlDP="URI:http://$crlurl"
   #export default_crl_days=30
   export ocspIAI=
   
   ####################################### 802.1AR Intermediate pki########################################

   mkdir -p $intrdir
   #cd $dir    
   mkdir -p $intrdir/certs $intrdir/crl $intrdir/csr $intrdir/newcerts $intrdir/private
   chmod 700 $intrdir/private
   #touch index.txt
   #sn=8 # hex 8 is minimum, 19 is maximum
   #echo 1000 > crlnumber

   
   


   source $cnfg




  export commonName="/CN="$cn

  
   DN=$countryName$stateOrProvinceName$localityName$organizationName
   DN=$DN$organizationalUnitName$commonName
   
   export subjectAltName=email:postmaster@htt-consult.com


   #export rootCertPath=

   ######################################## 802.1AR Intermediate Certificate#########################################################
   
   # Create passworded keypair file
   openssl genpkey -algorithm ec -pkeyopt ec_paramgen_curve:prime256v1 -outform $format -pkeyopt ec_param_enc:named_curve -out $intrdir/private/$cn.key.$format
   #changes below  
   chmod 700 $intrdir/private/$cn.key.$format
   openssl pkey -inform $format -in $intrdir/private/$cn.key.$format -text -noout
   
   # Create the CSR
   openssl req -config $cfgdir/openssl-intermediate.cnf -key $intrdir/private/$cn.key.$format -keyform $format -outform $format -subj "$DN" -new -sha256 -out $intrdir/csr/$cn.csr.$format
   openssl req -text -noout -verify -inform $format -in $intrdir/csr/$cn.csr.$format
   
   #openssl rand -hex $sn > $intrdir/serial # hex 8 is minimum, 19 is maximum
   openssl ca -config $cfgdir/openssl-intermediate.cnf -days 3650 -extensions v3_intermediate_ca -notext -md sha256 -in $intrdir/csr/$cn.csr.$format -out $intrdir/certs/$cn.cert.pem

   chmod 444 $intrdir/certs/$cn.cert.$format
   openssl verify -CAfile $cacert $intrdir/certs/$cn.cert.$format
   openssl x509 -noout -text -in $intrdir/certs/$cn.cert.$format

   # Create the certificate chain file
   cat $intrdir/certs/$cn.cert.$format $cacert > $intrdir/certs/$cn.chain.cert.$format
   chmod 444 $intrdir/certs/$cn.chain.cert.$format

   
   
   
   
   
