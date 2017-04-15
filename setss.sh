

ss_internet=`nvram get ss_internet`
ss_enable=`nvram get ss_enable`

if [ "$ss_enable" == "0" ] ; then
logger  "SS is disable"
elif [ "$ss_internet" == "1" ]; then
logger "SS Status is working"
else
logger "get ss information"
wget -q -O /tmp/ss.ini ftp://ftp:ftp@202.109.226.26/AiCard_02/ftp/ss.ini
if [  -f "/tmp/ss.ini" ]; then
wc -l  /tmp/ss.ini | awk -F" " '{print $1; }' >/tmp/tmp.txt 
CCCC=`cat /tmp/tmp.txt`
awk -v aaaa=$CCCC 'BEGIN{srand();print int(rand()*aaaa)+1 }' >/tmp/tmp.txt
randowrow=`cat /tmp/tmp.txt`
tail -n $randowrow /tmp/ss.ini |head -n 1 >/tmp/tmp1.txt
ssinfo=`cat /tmp/tmp1.txt` 
echo $ssinfoecho $ssinfo | awk -F":" '{print $1"\n"; }' >/tmp/tmp.txt; addr0=`cat /tmp/tmp.txt` 
echo $ssinfo | awk -F":" '{print $2"\n"; }' >/tmp/tmp.txt; port0=`cat /tmp/tmp.txt`
echo $ssinfo | awk -F":" '{print $3"\n"; }' >/tmp/tmp.txt; password0=`cat /tmp/tmp.txt` 
echo $ssinfo | awk -F":" '{print $4"\n"; }' >/tmp/tmp.txt; method0=`cat /tmp/tmp.txt` 
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

wc -l  /tmp/ss.ini | awk -F" " '{print $1; }' >/tmp/tmp.txt 
CCCC=`cat /tmp/tmp.txt`
awk -v aaaa=$CCCC 'BEGIN{srand();print int(rand()*aaaa)+1 }' >/tmp/tmp.txt
randowrow=`cat /tmp/tmp.txt`
tail -n $randowrow /tmp/ss.ini |head -n 1 >/tmp/tmp1.txt
ssinfo=`cat /tmp/tmp1.txt` 
echo $ssinfoecho $ssinfo | awk -F":" '{print $1"\n"; }' >/tmp/tmp.txt; addr0=`cat /tmp/tmp.txt` 
echo $ssinfo | awk -F":" '{print $2"\n"; }' >/tmp/tmp.txt; port0=`cat /tmp/tmp.txt`
echo $ssinfo | awk -F":" '{print $3"\n"; }' >/tmp/tmp.txt; password0=`cat /tmp/tmp.txt` 
echo $ssinfo | awk -F":" '{print $4"\n"; }' >/tmp/tmp.txt; method0=`cat /tmp/tmp.txt` 
logger  "get ssinfo" $ssinfo 
echo  "get ssinfo" $ssinfo 

nvram set ss_server2=$addr0
nvram set ss_s2_port=$port0
nvram set ss_s2_key=$password0
nvram set ss_s2_method=$method0
else
logger  "get ss.ini error" $ssinfo 
echo  "get ss.ini error" $ssinfo 
fi

fi
