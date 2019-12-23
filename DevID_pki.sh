   # edit directory here, or override
   #export cadir=${rt}/ca
   #mkdir $cadir
   sq=45
   export rt=root
   mkdir $rt
   
   export cadir=${cadir-$rt/ca}
   echo $cadir 
   mkdir $cadir
   export rootca=${cadir}/root
   export cfgdir=$rt
   echo "44444444444444444444",$cfgdir
   export intdir=${cadir}/intermediate
   export int1ardir=${cadir}/inter_1ar
   export format=pem
   export default_crl_days=65

   mkdir -p $cadir/certs
   mkdir -p $cadir/newcerts
   mkdir -p $cadir/private
   mkdir -p $cadir/csr   


   sn=8

   # edit these to suit
   countryName="/C=US"
   stateOrProvinceName="/ST=MI"
   localityName="/L=Oak Park"
   organizationName="/O=HTT Consulting"
   #organizationalUnitName="/OU="
   organizationalUnitName=
   commonName="/CN=Root CA"
   DN=$countryName$stateOrProvinceName$localityName
   DN=$DN$organizationName$organizationalUnitName$commonName

   echo $DN
   export subjectAltName=email:postmaster@htt-consult.com

   export default_crl_days=2048
   
   ##########################################rootcert###################################################
   
   
   
    export pass=pass:hello
	export passin=pass:hello

	# Create passworded keypair file

	if [ ! -f $cadir/private/ca.key.$format ]; then
		echo GENERATING KEY
		openssl genpkey -pass $pass -aes256 -algorithm ec\
				-pkeyopt ec_paramgen_curve:prime256v1\
				-outform $format -pkeyopt ec_param_enc:named_curve\
				-out $cadir/private/ca.key.$format
		chmod 400 $cadir/private/ca.key.$format
		openssl pkey -passin $passin -inform $format -in $cadir/private/ca.key.$format\
				-text -noout
	fi

	# Create Self-signed Root Certificate file
	# 7300 days = 20 years; Intermediate CA is 10 years.

	echo GENERATING and SIGNING REQ
	openssl req -config $cfgdir/openssl-root.cnf -passin $passin \
		 -set_serial 0x$(openssl rand -hex $sn)\
		 -keyform $format -outform $format\
		 -key $cadir/private/ca.key.$format -subj "$DN"\
		 -new -x509 -days 7300 -sha256 -extensions v3_ca\
		 -out $cadir/certs/ca.cert.$format

	#

	openssl x509 -inform $format -in $cadir/certs/ca.cert.$format\
		 -text -noout
	openssl x509 -purpose -inform $format\
		 -in $cadir/certs/ca.cert.$format -inform $format
   
   
   
   

   
   
   
   ####################################### 802.1AR Intermediate pki########################################
   export dir=root/ca
   
   cd $dir
   chmod 700 private
   touch index.txt
   sn=8 # hex 8 is minimum, 19 is maximum
   echo 1000 > crlnumber

   
   
   
   ##changes
   #cd ..
   cd ..
   cd ..
   
   ######################################## 802.1AR Intermediate Certificate#########################################################
   

   # Create the certificate chain file
   cat $cadir/certs/ca.cert.$format > $dir/certs/ca-chain.cert.$format
   chmod 744 $dir/certs/ca-chain.cert.$format

   
   ############################iDevID certofocate#############

	DevID=DI$sq
	countryName="/C=US"
	stateOrProvinceName="/ST=MIS"
	localityName="/L=Gaithersburg"
	organizationName="/O=HTT"
	organizationalUnitName="/OU=Devices"
	commonName="/CN=DevID"
	serialNumber="/serialNumber=$DevID"
	DN=$countryName$stateOrProvinceName$localityName
	DN=$DN$organizationName$organizationalUnitName$commonName
	DN=$DN$serialNumber
	echo $DN

	# hwType is OID for HTT Consulting, devices, sensor widgets
	export hwType=1.3.6.1.4.1.6715.10.1
	export hwSerialNum=01020304 # Some hex
	export subjectAltName="otherName:1.3.6.1.5.5.7.8.4;SEQ:hmodname, URI:https://mud.com"
	echo  $hwType - $hwSerialNum
	echo  $hwType - $hwSerialNum

	if [ ! -f $dir/private/$DevID.key.$format ]; then
		openssl genpkey -pass $pass -algorithm ec -pkeyopt ec_paramgen_curve:prime256v1\
				-pkeyopt ec_param_enc:named_curve\
				-out $dir/private/$DevID.key.$format
		chmod 400 $dir/private/$DevID.key.$format
	fi


	openssl pkey -in $dir/private/$DevID.key.$format -text -noout
	

	openssl req -config $cfgdir/openssl-8021ARintermediate.cnf\
		-key $dir/private/$DevID.key.$format \
		-subj "$DN" -new -sha256 -out $dir/csr/$DevID.csr.$format


	openssl req -text -noout -verify\
		-in $dir/csr/$DevID.csr.$format
	

	openssl rand -hex $sn > $dir/serial # hex 8 is minimum, 19 is maximum
	# Note 'openssl ca' does not support DER format
	echo ca -config $cfgdir/openssl-8021ARintermediate.cnf -days 375 -extensions 8021ar_idevid -notext -md sha256 -in $dir/csr/$DevID.csr.$format -out $dir/certs/$DevID.cert.$format
	openssl ca -config $cfgdir/openssl-8021ARintermediate.cnf -days 375\
		-extensions 8021ar_idevid -notext -md sha256 \
		-in $dir/csr/$DevID.csr.$format\
		-out $dir/certs/$DevID.cert.$format
	chmod 444 $dir/certs/$DevID.cert.$format

	openssl verify -CAfile $dir/certs/ca-chain.cert.$format\
		 $dir/certs/$DevID.cert.$format
	openssl x509 -noout -text -in $dir/certs/$DevID.cert.$format
	
	# offset of start of hardwareModuleName and use that in place of 493
	#openssl asn1parse -i -strparse 135 -in $dir/certs/$DevID.cert.pem

   
   
   
   
 
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
