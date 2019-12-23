#!/bin/bash
# edit directory here, or override
   #export cadir=${rt}/ca
   #mkdir $cadir
   sq=45
   export rt=IDevIDModule
   mkdir -p $rt
   
   export cadir=${cadir-$rt/ca}
   mkdir -p $cadir
   export rootca=${cadir}
   export cfgdir=$rt
   export format=pem
   export default_crl_days=65

   mkdir -p $cadir/certs
   mkdir -p $cadir/newcerts
   mkdir -p $cadir/private
   mkdir -p $cadir/csr


   touch $cadir/index.txt $cadir/index.txt.attr
   if [ ! -f $cadir/serial ]; then echo 00 >$cadir/serial; fi

   


   sn=8
   
 
  export flg=0
  export cnfg=""
   
   for arg in "$@"
	do
	   if [ "$flg" == 1 ]; then
		cnfg=$arg
		flg=0
		
	fi
	   if [ "$arg" == "--config" ] || [ "$arg" == "-config" ];    then
		flg=1
	    fi
   done	

  
   
   source $cnfg
   
   DN=$countryName$stateOrProvinceName$localityName
   DN=$DN$organizationName$organizationalUnitName$commonName

   
   export subjectAltName=email:postmaster@htt-consult.com

   export default_crl_days=2048
   
   ##########################################rootcert###################################################
   
   
   
        #export pass=pass:
	#export passin=pass:

	# Create passworded keypair file

	if [ ! -f $cadir/private/ca.key.$format ]; then
		echo GENERATING KEY
		#With encryption and passphrase		
		#openssl genpkey -pass $pass -aes256 -algorithm ec -pkeyopt ec_paramgen_curve:prime256v1 -outform $format -pkeyopt ec_param_enc:named_curve -out $cadir/private/ca.key.$format

		#Without encryption		
		openssl genpkey -algorithm ec -pkeyopt ec_paramgen_curve:prime256v1 -outform $format -pkeyopt ec_param_enc:named_curve -out $cadir/private/ca.key.$format

		chmod 400 $cadir/private/ca.key.$format
		#With encryption	
		#openssl pkey -passin $passin -inform $format -in $cadir/private/ca.key.$format -text -noout

		#Without encryption
		openssl pkey -inform $format -in $cadir/private/ca.key.$format -text -noout

		#openssl pkey -passin $passin -inform pem -in ca.key.pem -text -noout

	fi

	
		#echo GENERATING and SIGNING REQ
		#signing with encryptioned private key
		#openssl req -config $rt/openssl-root.cnf -passin $passin -set_serial 0x$(openssl rand -hex $sn) -keyform $format -outform $format -key $cadir/private/ca.key.$format -subj "$DN" -new -x509 -days 7300 -sha256 -extensions v3_ca -out $cadir/certs/ca.cert.$format


		#signing without encryptioned private key
		openssl req -config $rt/openssl-root.cnf -set_serial 0x$(openssl rand -hex $sn) -keyform $format -outform $format -key $cadir/private/ca.key.$format -subj "$DN" -new -x509 -days 7300 -sha256 -extensions v3_ca -out $cadir/certs/ca.cert.$format


		openssl x509 -inform $format -in $cadir/certs/ca.cert.$format -text -noout
		openssl x509 -purpose -inform $format -in $cadir/certs/ca.cert.$format -inform $format
   
   
   
   

 
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
