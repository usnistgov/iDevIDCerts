#!/bin/bash
alias echo="echo -e"

#!/bin/bash
   export flgport=0
   export flgprotocol=0
   export flgdomain=0
   export flgusage=0
   export flgselector=0
   export flgmatching=0
   export flgcert=0
   export port=""
   export protocol=""
   export domain=""
   export usage=""
   export selector=""
   export matching=""
   export cert=""


   for arg in "$@"
	do
	   if [ "$flgport" == 1 ]; then
		port=$arg
		flgport=0
	   fi
	   if [ "$flgdomain" == 1 ]; then
			domain=$arg
			flgdomain=0
	   fi
	   if [ "$flgusage" == 1 ]; then
			usage=$arg
			flgusage=0
	   fi
	   if [ "$flgselector" == 1 ]; then
			selector=$arg
			flgselector=0
	   fi

	   if [ "$flgmatching" == 1 ]; then
		matching=$arg
		flgmatching=0
	   fi
	   if [ "$flgcert" == 1 ]; then
		cert=$arg
		flgcert=0
	   fi

	   if [ "$arg" == "--device" ] || [ "$arg" == "-device" ];    then
		flgport=1
	   fi
	   if [ "$arg" == "--domain" ] || [ "$arg" == "-domain" ];    then
			flgdomain=1
           fi
	   if [ "$arg" == "--usage" ] || [ "$arg" == "-usage" ];    then
			flgusage=1
           fi
	   if [ "$arg" == "--selector" ] || [ "$arg" == "-selector" ];    then
		flgselector=1
	   fi
	   if [ "$arg" == "--matching" ] || [ "$arg" == "-matching" ];    then
		flgmatching=1
	   fi
	   if [ "$arg" == "--cert" ] || [ "$arg" == "-cert" ];    then
		flgcert=1
	   fi
   done	

 export label="_device"
 export usagecode=0
 export selectorcode=0
 export matchingTypecode=0

	
	if [ "$usage" == "PKIX-TA" ] ;    then
		usagecode=0
	elif [ "$usage" == "PKIX-EE" ]; then
		usagecode=1
	elif [ "$usage" == "DANE-TA" ]; then
		usagecode=2
	else [ "$usage" == "DANE-EE" ];
		usagecode=3
	fi




	if [ "$selector" == "full-cert" ] || [ "$selector" == "cert" ] ;    then
		selectorcode=0
		if [ "$matching" == "sha256" ] ;    then
			matchingTypecode=1
			passtest=$(openssl x509 -noout -fingerprint -sha256 -inform pem -in $cert) 
			arrdgst509=(${passtest//=/ })
			dgst=${arrdgst509[2]//:}
			printf $port.$label.$domain.${empty_space}$' IN TLSA (\n'$usagecode$' '$selectorcode$' '$matchingTypecode$' '$dgst$' )\n'
			
	        fi
		if [ "$matching" == "sha512" ] ;    then
			matchingTypecode=2
			passtest=$(openssl x509 -noout -fingerprint -sha512 -inform pem -in $cert) 
			arrdgst509=(${passtest//=/ })
			dgst=${arrdgst509[2]//:}			
			printf $port.$label.$domain.${empty_space}$' IN TLSA (\n'$usagecode$' '$selectorcode$' '$matchingTypecode$' '$dgst$' )\n'			
			
	        fi
		if [ "$matching" == "no-hash" ] ;    then
			matchingTypecode=0
			passtest=$(openssl x509 -in $cert | openssl enc -base64 -d > temp.der) 
			der=$(xxd -p temp.der)
			printf -v der '%s' $der
			rm temp.der
			printf $port.$label.$domain.${empty_space}$' IN TLSA (\n'$usagecode$' '$selectorcode$' '$matchingTypecode$' '$der$' )\n'
			
	        fi		


	   fi




	   if [ "$selector" == "subject-public-key" ] || [ "$selector" == "spk" ] ;    then
		selectorcode=1
		passtest=$(openssl x509 -in test/iDevID/certs/DevID.cert.pem -pubkey -noout | openssl enc -base64 -d > temppubkey.der)
		if [ "$matching" == "no-hash" ] ;    then
			matchingTypecode=0
			der=$(xxd -p temppubkey.der)
			dernws=${der// }
			printf -v der '%s' $der
			printf $port.$label.$domain.${empty_space}$' IN TLSA (\n'$usagecode$' '$selectorcode$' '$matchingTypecode$' '$der$' )\n'
			
	        fi	
		if [ "$matching" == "sha256" ] ;    then
			matchingTypecode=1
			passtest=$(openssl dgst -sha256 temppubkey.der) 
			arrdgst509=(${passtest//=/ })
			printf     $port.$label.$domain.${empty_space}$' IN TLSA (\n'$usagecode$' '$selectorcode$' '$matchingTypecode$' '${arrdgst509[1]}$' )\n'			
			
	        fi
		if [ "$matching" == "sha512" ] ;    then
			matchingTypecode=2
			passtest=$(openssl dgst -sha512 temppubkey.der) 
			arrdgst509=(${passtest//=/ })
			printf $port.$label.$domain.${empty_space}$' IN TLSA (\n'$usagecode$' '$selectorcode$' '$matchingTypecode$' '${arrdgst509[1]}$' )\n'
			
	        fi
			rm temppubkey.der


	   fi






   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
