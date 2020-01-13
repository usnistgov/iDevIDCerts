#!/bin/bash

  export flgin=0
  export flgfiletype=0
  export flgout=0
  export out=""
  export in=""
  export filetype=""

   
   for arg in "$@"
	do
	   if [ "$flgfiletype" == 1 ]; then
		filetype=$arg
		flgfiletype=0
	fi
	if [ "$flgout" == 1 ]; then
		out=$arg
		flgout=0
	fi
	if [ "$flgin" == 1 ]; then
			in=$arg
			flgin=0
	fi

	if [ "$arg" == "--filetype" ] || [ "$arg" == "-filetype" ];    then
		flgfiletype=1
	fi
	if [ "$arg" == "--in" ] || [ "$arg" == "-in" ];    then
			flgin=1
        fi
	if [ "$arg" == "--out" ] || [ "$arg" == "-out" ];    then
		flgout=1
	fi
   done


	if [ "$filetype" == "key" ] || [ "$filetype" == "KEY" ]; then
		openssl ec -in $in -outform DER -out $out
	fi

	if [ "$filetype" == "cert" ] || [ "$filetype" == "CERT" ] || [ "$filetype" == "certificate" ] || [ "$filetype" == "CERTIFICATE" ]; then
		openssl x509 -outform der -in $in -out $out
	fi
	

	if [ "$filetype" != "key" ] && [ "$filetype" != "KEY" ] && [ "$filetype" != "cert" ] && [ "$filetype" != "CERT" ] && [ "$filetype" != "certificate" ] && [ "$filetype" != "CERTIFICATE" ]; then
		echo Please specify filetype : key/cert !!
	fi
  
   
     
   
   
