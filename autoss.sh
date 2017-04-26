########################  get from arukas ########################
token="e39ed54e-18ee-4eae-b372-41b4e05721f3"
secret="eoZ9cCkTpM0d6Rb7BEtXl5luBcqZyVeiNLZuKUxGjgOFnB1tqTChz3Wr8JKS2kJY"


cp /dev/null ss.ini

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
 | awk -F"[-.,]" '{print $4"."$5"."$6"."$7":"$2":yzqyzq:rc4-md5::"; }' \
 | head -9 >> ss.ini
fi

########################  get from ishadowsock ########################
iss="http://go.ishadow.online/"
rm ssss.txt > /dev/null 2>&1
wget  -q -O ssss.txt -tries=10 $iss
[ ! -s ssss.txt ] && wget  -q -O ssss.txt -tries=10 $iss
[ ! -s ssss.txt ] && wget  -q -O ssss.txt -tries=10 $iss
[ ! -s ssss.txt ] && wget  -q -O ssss.txt -tries=10 $iss
[ ! -s ssss.txt ] && wget  -q -O ssss.txt -tries=10 $iss

if [  -s ssss.txt ] ; then

cp /dev/null ssss.ini
Server=""
Port=""
Pass=""
Method=""
Other=""

cat ssss.txt |grep -E "<h4>IP Address|<h4>Port|<h4>Password|<h4>Method|<h4>auth_" | sed 's/<[^<>]*>//g' | sed 's/：/:/g' | sed 's/IP Address/Server/g'| sed 's/ //g' |sed 's/\r//g' | while read i  
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

else
########################  get from github.com/Alvin9999 ########################
rm ssss.txt > /dev/null 2>&1
iss="https://github.com/Alvin9999/new-pac/wiki/ss%E5%85%8D%E8%B4%B9%E8%B4%A6%E5%8F%B7"

wget  -q -O ssss.txt -tries=10 $iss
[ ! -s ssss.txt ] && wget  -q -O ssss.txt -tries=10 $iss
[ ! -s ssss.txt ] && wget  -q -O ssss.txt -tries=10 $iss
[ ! -s ssss.txt ] && wget  -q -O ssss.txt -tries=10 $iss
[ ! -s ssss.txt ] && wget  -q -O ssss.txt -tries=10 $iss
cat ssss.txt |grep 端口：|grep  密码： |sed 's/<[^<>]*>//g' | sed 's/：/:/g' | sed 's/ /:/g'  | sed 's/　/:/g' | sed 's/::/:/g'  | sed 's/（/:/g' |head -n 9 | while read i  
do
  var1=`echo $i|awk -F ':' '{print $2}'`
  var2=`echo $i|awk -F ':' '{print $4}'`
  var3=`echo $i|awk -F ':' '{print $6}'`
  var4=`echo $i|awk -F ':' '{print $8}'`
  echo $var1:$var2:$var3:$var4 >> ss.ini
done

rm ssss.txt
fi




###################### set ss information ####################################

logger "get ss information"

if [  -f "ss.ini" ]; then
CCCC=`wc -l  ss.ini | awk -F" " '{print $1; }'`
let C0=$CCCC/2+1
let C1=$CCCC-$C0
randowrow=`awk -v aaaa=$C0 'BEGIN{srand();print int(rand()*aaaa)+1 }'`
ssinfo=`sed -n "$randowrow"p ss.ini`
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
sleep 1
randowrow=`awk -v aaaa=$C1  'BEGIN{srand();print int(rand()*aaaa)+1}'`
let randowrow=$rowdowrow+$C0
ssinfo=`sed -n "$randowrow"p ss.ini`
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
/etc/storage/script/Sh15_ss.sh start
else
logger  "get ss.ini error" $ssinfo 
echo  "get ss.ini error" $ssinfo 
fi
