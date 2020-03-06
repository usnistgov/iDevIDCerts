#!/bin/bash
  export flg=0
  export flgcn=0
  export cnfg=""
  export flgout=0
  export out=""
  export cn=""
   
   for arg in "$@"
	do
	   if [ "$flg" == 1 ]; then
		cnfg=$arg
		flg=0
	fi
	if [ "$flgout" == 1 ]; then
		out=$arg
		flgout=0
	fi
	if [ "$flgcn" == 1 ]; then
			cn=$arg
			flgcn=0
	fi

	if [ "$arg" == "--config" ] || [ "$arg" == "-config" ];    then
		flg=1
	fi
	if [ "$arg" == "--cn" ] || [ "$arg" == "-cn" ];    then
			flgcn=1
        fi
	if [ "$arg" == "--out" ] || [ "$arg" == "-out" ];    then
		flgout=1
	fi
   done

   export rt=$out
   mkdir -p $rt
   export cadir=${cadir-$rt/ca}
   mkdir -p $cadir
   export rootca=${cadir}
   export cfgdir=config
   export format=pem
   mkdir -p $cadir/certs
   mkdir -p $cadir/newcerts
   mkdir -p $cadir/private
   mkdir -p $cadir/csr
   touch $cadir/index.txt $cadir/index.txt.attr
   if [ ! -f $cadir/serial ]; then echo 50 >$cadir/serial; fi
   
   source $cnfg
   export commonName="/CN="$cn
   DN=$countryName$stateOrProvinceName$localityName
   DN=$DN$organizationName$organizationalUnitName$commonName
  
   
	if [ ! -f $cadir/private/$cn.key.$format ]; then
		#Without encryption		
		openssl genpkey -algorithm ec -pkeyopt ec_paramgen_curve:prime256v1 -outform $format -pkeyopt ec_param_enc:named_curve -out $cadir/private/$cn.key.$format
		chmod 400 $cadir/private/$cn.key.$format
		#Without encryption
		openssl pkey -inform $format -in $cadir/private/$cn.key.$format -text -noout
	fi

		#signing without encryptioned private key
		openssl req -config $cfgdir/openssl-root.cnf -keyform $format -outform $format -key $cadir/private/$cn.key.$format -subj "$DN" -new -x509 -days $default_crl_days -sha256 -extensions v3_ca -out $cadir/certs/$cn.cert.$format
		openssl x509 -inform $format -in $cadir/certs/$cn.cert.$format -text -noout
		openssl x509 -purpose -inform $format -in $cadir/certs/$cn.cert.$format -inform $format
   
