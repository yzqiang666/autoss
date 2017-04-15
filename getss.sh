#!/bin/bash

if [ $# -le 4 ] ; then 
	echo "USAGE: $0 Token:Secret Arukas_Endpoint Arukas_Port Local_Port" 
	echo " e.g.: $0 Token:Secret endpoint.arukascloud.io 8388 password rc4-md5 auth_sha1 http_simple" 
	exit 1
fi 

#wget -O ss.txt -q https://e39ed54e-18ee-4eae-b372-41b4e05721f3:eoZ9cCkTpM0d6Rb7BEtXl5luBcqZyVeiNLZuKUxGjgOFnB1tqTChz3Wr8JKS2kJY@app.arukas.io/api/containers
rawJson=`/tmp/jq '.data' <ss.txt`
length=`echo $rawJson | jq "lengt
let "length-=1"
addr="lost"
port="0"
aimAddr="\"$2\""
aimPort=$3
port_rules="port=$4"
for i in $(seq 0 $length) ; do
	endP=`echo $rawJson | jq ".[$i].attributes.end_point"`
        for k in $(seq 0 9) ; do
	if [ "$endP" = "$aimAddr" ] ; then
		portMapping=`echo $rawJson | /tmp/jq ".[$i].attributes.port_mappings|.[$k]"`
		portMappingLength=`echo $portMapping | jq "length"`
                let "portMappingLength-=1"
		for j in $(seq 0 $portMappingLength) ; do
			cPortJson=`echo $portMapping |  ".[$j]"`
			cPort=`echo $cPortJson | jq ".container_port"`
			if [ "$cPort" = "$aimPort" ] ; then
				port=`echo $cPortJson | jq ".service_port"`
				addr=`echo $cPortJson | jq ".host" | awk -F '"' '{printf $2}'`
                                echo $addr | awk -F"[-.]" '{print $2"."$3"."$4"."$5; }' >tmp.txt 
                                addr=`cat tmp.txt`
                                echo "$addr:$port:$4:$5:$6:$7"
			fi
		done
	fi
	done
done



