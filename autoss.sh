url="http://"`nvram get ss_link_2`

if [ ! "$1" = "refresh" ] ; then
rm /tmp/tmp.txt 2>/dev/null
wget  -q -O /tmp/tmp.txt --continue --no-check-certificate   -T 10 $url
[ -s /tmp/tmp.txt ] && exit 0
fi

nvram set ss_status=1
nvram set ss_enable=0
nvram commit
/etc/storage/script/Sh15_ss.sh stop &
ss-rules -f
pidof ss-redir  >/dev/null 2>&1 && killall ss-redir && killall -9 ss-redir 2>/dev/null
sleep 2

rm ss.ini > /dev/null 2>&1

########################  get from arukas ########################
token="e39ed54e-18ee-4eae-b372-41b4e05721f3"
secret="eoZ9cCkTpM0d6Rb7BEtXl5luBcqZyVeiNLZuKUxGjgOFnB1tqTChz3Wr8JKS2kJY"

rm ss.txt > /dev/null 2>&1
wget -q -O ss.txt -tries=10 https://$token:$secret@app.arukas.io/api/containers
[ ! -s ss.txt ] && wget  -q -O ss.txt -tries=10 https://$token:$secret@app.arukas.io/api/containers
[ ! -s ss.txt ] && wget  -q -O ss.txt -tries=10 https://$token:$secret@app.arukas.io/api/containers
[ ! -s ss.txt ] && wget  -q -O ss.txt -tries=10 https://$token:$secret@app.arukas.io/api/containers
[ ! -s ss.txt ] && wget  -q -O ss.txt -tries=10 https://$token:$secret@app.arukas.io/api/containers

if [  -s ss.txt ] ; then
sed 's/{"container_port"/\n{"container_port"/g' ss.txt \
 | sed 's/}/}\n/g' \
 | grep container_port \
 | grep -v '"container_port":22,' \
 | sed 's/"container_port"://g' \
 | sed 's/"service_port"://g'  \
 | sed 's/"host"://g' \
 | sed 's/{//g' \
 | sed 's/}//g' \
 | sed 's/"//g' \
 | awk -F"[-.,]" '{print $4"."$5"."$6"."$7":"$2":yzqyzq:rc4-md5::"; }' >> ss.ini
fi

########################  get from ishadowsock ########################
#iss="http://go.ishadow.online/"
iss="http://www.ishadowsocks.org/"
rm ss.txt > /dev/null 2>&1
wget  -q -O ss.txt -tries=10 $iss
[ ! -s ss.txt ] && wget  -q -O ssss.txt -tries=10 $iss
[ ! -s ss.txt ] && wget  -q -O ssss.txt -tries=10 $iss
[ ! -s ss.txt ] && wget  -q -O ssss.txt -tries=10 $iss
[ ! -s ss.txt ] && wget  -q -O ssss.txt -tries=10 $iss


cp /dev/null ssss.ini
Server=""
Port=""
Pass=""
Method=""
Other=""

cat ss.txt |grep -E "<h4>IP Address|<h4>Port|<h4>Password|<h4>Method|<h4>auth_" | sed 's/<[^<>]*>//g' | sed 's/：/:/g' | sed 's/IP Address/Server/g'| sed 's/ //g' |sed 's/\r//g' | while read i  
do
var1=`echo $i|awk -F ':' '{print $1}'`
var2=`echo $i|awk -F ':' '{print $2}'`
case $var1 in
    Server)  Server="$var2"
    ;;
    Port)  Port="$var2"
    ;;
    Password)  Pass="$var2"
    ;;
    Method)  Method="$var2"
    ;;
    *)  Other="$var1"
    ;;

esac



if [ ! "$Server" = "" ]  && [ ! "$Port" = "" ]  && [ ! "$Pass" = "" ]  && [ ! "$Method" = "" ] && [ "$Other" = "" ] ; then
    echo $Server:$Port:$Pass:$Method:: >>ssss.ini
        Server=""
        Port=""
        Pass=""
        Method=""
        Other=""

fi

done

sed -i '$d' ssss.ini
head -n 9  ssss.ini >>ss.ini
rm ssss.*


########################  get from github.com/Alvin9999 ########################
rm ss.txt > /dev/null 2>&1
iss="https://github.com/Alvin9999/new-pac/wiki/ss%E5%85%8D%E8%B4%B9%E8%B4%A6%E5%8F%B7"

wget  -q -O ss.txt -tries=10 $iss
[ ! -s ss.txt ] && wget  -q -O ssss.txt -tries=10 $iss
[ ! -s ss.txt ] && wget  -q -O ssss.txt -tries=10 $iss
[ ! -s ss.txt ] && wget  -q -O ssss.txt -tries=10 $iss
[ ! -s ss.txt ] && wget  -q -O ssss.txt -tries=10 $iss
cat ss.txt |grep 端口：|grep  密码： |sed 's/<[^<>]*>//g' | sed 's/：/:/g' | sed 's/ /:/g'  | sed 's/　/:/g' | sed 's/::/:/g'  | sed 's/（/:/g' |head -n 9 | while read i  
do
  var1=`echo $i|awk -F ':' '{print $2}'`
  var2=`echo $i|awk -F ':' '{print $4}'`
  var3=`echo $i|awk -F ':' '{print $6}'`
  var4=`echo $i|awk -F ':' '{print $8}'`
  echo $var1:$var2:$var3:$var4 >> ss.ini
done

rm ss.txt



###################### set ss information ####################################

logger "get bestss server"


options1=""
options2=""
ss_usage=""
ss_usage_json=""

ss_link_1=`nvram get ss_link_2`
ss_check=`nvram get ss_check`
nvram set ss_check=0
pidof ss-redir  >/dev/null 2>&1 && killall ss-redir && killall -9 ss-redir 2>/dev/null

action_port=1092
lan_ipaddr=`nvram get lan_ipaddr`

server1="NONO"
server2="NONO"
time1=999.9
time2=999.9
echo "NONO" >/tmp/server1.tmp
echo "NONO" >/tmp/server2.tmp
echo "999.9" >/tmp/time1.tmp
echo "999.9" >/tmp/time2.tmp

cat ss.ini | while read str
do
#echo "begin process ===========   "$str
ss_s1_ip=`echo $str|awk -F ':' '{print $1}'`  
ss_s1_port=`echo $str|awk -F ':' '{print $2}'`  
ss_s1_key=`echo $str|awk -F ':' '{print $3}'`  
ss_s1_method=`echo $str|awk -F ':' '{print $4}'`  


ss-rules -f
ss_server1=$ss_s1_ip
resolveip=`/usr/bin/resolveip -4 -t 4 $ss_server1 | grep -v : | sed -n '1p'`
[ -z "$resolveip" ] && resolveip=`nslookup $ss_server1 | awk 'NR==5{print $3}'` 


pidof ss-redir  >/dev/null 2>&1 && killall ss-redir && killall -9 ss-redir 2>/dev/null
/tmp/SSJSON.sh -f /tmp/ss-redir_3.json $ss_usage $ss_usage_json -s $ss_s1_ip -p $ss_s1_port -l 1092 -b 0.0.0.0 -k $ss_s1_key -m $ss_s1_method
ss-redir -c /tmp/ss-redir_3.json $options1 >/dev/null 2>&1 &

ss_s1_ip=$ss_server1
action_ssip=$ss_s1_ip
BP_IP="$action_ssip"

ss-rules -s "$action_ssip" -l "$action_port" -b $BP_IP -d "RETURN" -a "g,$lan_ipaddr" -e '-m multiport --dports 80' -o -O
#sleep 1

starttime=$(cat /proc/uptime | cut -d" " -f1)
rm /tmp/tmp.txt 2>/dev/null
#wget -q -O /tmp/tmp.txt --continue --no-check-certificate   -T 10 http://www.google.com.hk/  2>/dev/null
wget -q -O /tmp/tmp.txt --continue --no-check-certificate   -T 10 $url

if [ -s /tmp/tmp.txt ] ; then
	endtime=$(cat /proc/uptime | cut -d" " -f1)
    TIME=`awk -v x=$starttime -v y=$endtime 'BEGIN {printf y-x}'`
	RES=`awk -v a=$TIME -v b=$time1  'BEGIN { print (a<=b)?1:0'}`
    if [ "$RES" = "1"  ] ; then
        server2=$server1
        time2=$time1
        server1=$str
        time1=$TIME

        mv /tmp/server1.tmp /tmp/server2.tmp
        mv /tmp/time1.tmp /tmp/time2.tmp
        echo $str >/tmp/server1.tmp
        echo $TIME >/tmp/time1.tmp
    else
        RES=`awk -v a=$TIME -v b=$time2  'BEGIN { print (a<=b)?"1":"0"'}`
        if [ "$RES" = "1"  ] ; then
            server2=$str
            time2=$TIME
            echo $str >/tmp/server2.tmp
            echo $TIME >/tmp/time2.tmp
        fi
	
    fi
    echo $str" =====  "$TIME
else
    echo $str" =====  Fail"

fi
done

server1=`cat /tmp/server1.tmp`
server2=`cat /tmp/server2.tmp`
time1=`cat /tmp/time1.tmp`
time2=`cat /tmp/time2.tmp`

echo "The No1 server: "$server1":"$time1
echo "The No2 server: "$server2":"$time2
logger "The No1 server: "$server1":"$time1
logger "The No2 server: "$server2":"$time2

nvram set ss_check=$ss_check

logger "set ss information"
if [ ! $time1 = "999.9" ]; then
	ssinfo=$server1
	addr0=`echo $ssinfo | awk -F":" '{print $1"\n"; }'`
	port0=`echo $ssinfo | awk -F":" '{print $2"\n"; }'`
	password0=`echo $ssinfo | awk -F":" '{print $3"\n"; }'`
	method0=`echo $ssinfo | awk -F":" '{print $4"\n"; }'`
	logger  "get ssinfo" $ssinfo 
	echo  "get ssinfo" $ssinfo 
	nvram set ss_server=$addr0
	nvram set ss_server_port=$port0
	nvram set ss_key=$password0
	nvram set ss_method=$method0
	nvram set ss_server1=$addr0
	nvram set ss_s1_port=$port0
	nvram set ss_s1_key=$password0
	nvram set ss_s1_method=$method0
fi

if [ ! $time2 = "999.9" ]; then
	ssinfo=$server2
	addr0=`echo $ssinfoecho $ssinfo | awk -F":" '{print $1"\n"; }'`
	port0=`echo $ssinfo | awk -F":" '{print $2"\n"; }'`
	password0=`echo $ssinfo | awk -F":" '{print $3"\n"; }'`
	method0=`echo $ssinfo | awk -F":" '{print $4"\n"; }'`
	logger  "get ssinfo" $ssinfo 
	echo  "get ssinfo" $ssinfo 
	nvram set ss_server2=$addr0
	nvram set ss_s2_port=$port0
	nvram set ss_s2_key=$password0
	nvram set ss_s2_method=$method0
fi
ss-rules -f
nvram set ss_enable=1



sleep 2

nvram set ss_status=0
nvram set ss_enable=1
nvram commit
/etc/storage/script/Sh15_ss.sh start


