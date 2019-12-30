#!/bin/bash


	export flg=0
        export flgcrt=0
	export flgprvt=0
	export flgchain=0
	export flgcn=0
        export cnfg=""
        export cacert=""
        export caprvt=""
        export cachain=""
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

		   if [ "$flgchain" == 1 ]; then
			cachain=$arg
			flgchain=0
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
		  if [ "$arg" == "--cachain" ] || [ "$arg" == "-cachain" ];    then
			flgchain=1
		  fi
		  if [ "$arg" == "--cn" ] || [ "$arg" == "-cn" ];    then
			flgcn=1
	          fi
		  if [ "$arg" == "--out" ] || [ "$arg" == "-out" ];    then
			flgout=1
		   fi
		
        done	



   export rt=$out
   export intrdir=${cadir-$rt/Intermediate}
   export cfgdir=config
   export cadir=${cadir-$rt/ca}
   export rootca=$cadir
   export devIDdir=${devIDdir-$rt/iDevID}
   mkdir -p $devIDdir
   export dir=$cadir
   export intdir=${cadir}/intermediate
   export int1ardir=${cadir}/inter_1ar
   export format=pem
   mkdir -p $devIDdir/certs
   mkdir -p $devIDdir/newcerts
   mkdir -p $devIDdir/private
   mkdir -p $devIDdir/csr   
   sn=8


   export default_crl_days=2048
	source $cnfg
	export commonName="/CN="$cn
	DevID=$cn
	
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

	if [ ! -f $devIDdir/private/$DevID.key.$format ]; then
		openssl genpkey -algorithm ec -pkeyopt ec_paramgen_curve:prime256v1\
				-pkeyopt ec_param_enc:named_curve\
				-out $devIDdir/private/$DevID.key.$format
		chmod 400 $devIDdir/private/$DevID.key.$format
	fi


	openssl pkey -in $devIDdir/private/$DevID.key.$format -text -noout
	

	openssl req -config $cfgdir/openssl-8021ARintermediate.cnf\
		-key $devIDdir/private/$DevID.key.$format \
		-subj "$DN" -new -sha256 -out $devIDdir/csr/$DevID.csr.$format


	openssl req -text -noout -verify\
		-in $devIDdir/csr/$DevID.csr.$format
	

	openssl rand -hex $sn > $devIDdir/serial # hex 8 is minimum, 19 is maximum
	# Note 'openssl ca' does not support DER format
	echo ca -config $cfgdir/openssl-8021ARintermediate.cnf -days 375 -extensions 8021ar_idevid -notext -md sha256 -in $devIDdir/csr/$DevID.csr.$format -out $devIDdir/certs/$DevID.cert.$format
	openssl ca -config $cfgdir/openssl-8021ARintermediate.cnf -days 375\
		-extensions 8021ar_idevid -notext -md sha256 \
		-in $devIDdir/csr/$DevID.csr.$format\
		-out $devIDdir/certs/$DevID.cert.$format
	chmod 444 $devIDdir/certs/$DevID.cert.$format

	openssl verify -CAfile cachain\
		 $devIDdir/certs/$DevID.cert.$format
	openssl x509 -noout -text -in $devIDdir/certs/$DevID.cert.$format
	



   
   
   
   
 
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
