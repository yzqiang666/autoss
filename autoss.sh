[ ! "`nvram get ss_enable`" = "1" ]  && exit 1
[ `ps |grep $0|grep -v grep|wc -l ` -gt 2 ] && exit 1


##################### SSR Server ###########
#[  -s /opt/shadowsocksr-manyuser/shadowsocks/run.sh ] \
#&&[ -z "`ps | grep "python server.py a" |grep -v grep`" ] \
#&&  /opt/shadowsocksr-manyuser/shadowsocks/run.sh

url="https://www.youtube.com"

if [ ! "$1" = "refresh" ] ; then
rm /tmp/tmp.txt 2>/dev/null
wget  -q  -O /tmp/tmp.txt  --no-check-certificate   -T 10 $url 2>/dev/null 
[ ! -s /tmp/tmp.txt ] && wget  -q  -O /tmp/tmp.txt  --no-check-certificate   -T 10 $url 2>/dev/null 
[ ! -s /tmp/tmp.txt ] && wget  -q  -O /tmp/tmp.txt  --no-check-certificate   -T 10 $url 2>/dev/null 
[ -s /tmp/tmp.txt ] && exit 0
fi


########################  get from arukas ########################
get_from_arukas()
{
token="e39ed54e-18ee-4eae-b372-41b4e05721f3"
secret="eoZ9cCkTpM0d6Rb7BEtXl5luBcqZyVeiNLZuKUxGjgOFnB1tqTChz3Wr8JKS2kJY"

rm ss.txt > /dev/null 2>&1
wget   -O ss.txt  -T 10 https://$token:$secret@app.arukas.io/api/containers >>ss.log 2>>ss.log
[ ! -s ss.txt ] && wget   -O ss.txt  -T 10 https://$token:$secret@app.arukas.io/api/containers >>ss.log 2>>ss.log
[ ! -s ss.txt ] && wget   -O ss.txt  -T 10 https://$token:$secret@app.arukas.io/api/containers >>ss.log 2>>ss.log
[ ! -s ss.txt ] && wget   -O ss.txt  -T 10 https://$token:$secret@app.arukas.io/api/containers >>ss.log 2>>ss.log
[ ! -s ss.txt ] && wget   -O ss.txt  -T 10 https://$token:$secret@app.arukas.io/api/containers >>ss.log 2>>ss.log

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
 | awk -F"[-.,]" '{print $4"."$5"."$6"."$7":"$2":yzqyzq:rc4-md5"; }' >> ss.ini
 
echo "==========" >> ss.ini 
fi
}

################ 零星收集的SS
get_from_other()
{
rm ss.txt > /dev/null 2>&1
wget   -O ss.txt  -T 10  https://raw.githubusercontent.com/yzqiang666/autoss/master/ss.txt >>ss.log 2>>ss.log 
[ ! -s ss.txt ] && wget   -O ss.txt  -T 10  https://raw.githubusercontent.com/yzqiang666/autoss/master/ss.txt >>ss.log 2>>ss.log 
[ ! -s ss.txt ] && wget   -O ss.txt  -T 10  https://raw.githubusercontent.com/yzqiang666/autoss/master/ss.txt >>ss.log 2>>ss.log 
[ ! -s ss.txt ] && wget   -O ss.txt  -T 10  https://raw.githubusercontent.com/yzqiang666/autoss/master/ss.txt >>ss.log 2>>ss.log 
[ ! -s ss.txt ] && wget   -O ss.txt  -T 10  https://raw.githubusercontent.com/yzqiang666/autoss/master/ss.txt >>ss.log 2>>ss.log 

[  -s ss.txt ] && cat ss.txt >>ss.ini && echo "==========" >> ss.ini 
}

########################  get from ishadowsock ########################
get_from_ishadowsock()
{
iss="http://www.ishadowsocks.org/"
rm ss.txt > /dev/null 2>&1
wget  -O ss.txt  -T 10  $iss >>ss.log 2>>ss.log
[ ! -s ss.txt ] && wget  -O ss.txt  -T 10  $iss >>ss.log 2>>ss.log
[ ! -s ss.txt ] && wget  -O ss.txt  -T 10  $iss >>ss.log 2>>ss.log
[ ! -s ss.txt ] && wget  -O ss.txt  -T 10  $iss >>ss.log 2>>ss.log
[ ! -s ss.txt ] && wget  -O ss.txt  -T 10  $iss >>ss.log 2>>ss.log

if [  -s ss.txt ] ; then
cp /dev/null  ssss.ini
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



if [ ! "$Server" = "" ]  && [ ! "$Port" = "" ]  && [ ! "$Pass" = "" ]  && [ ! "$Method" = "" ]  ; then
    echo $Server:$Port:$Pass:$Method >>ss.ini
    Server=""
    Port=""
    Pass=""
    Method=""
    Other=""

fi

done
echo "==========" >> ss.ini 
fi

}

########################  get from github.com/Alvin9999 不得已才用　########################
get_from_Alvin9999()
{
rm ss.txt > /dev/null 2>&1
iss="https://github.com/Alvin9999/new-pac/wiki/ss%E5%85%8D%E8%B4%B9%E8%B4%A6%E5%8F%B7"
wget  -O ss.txt -T 10 $iss >>ss.log 2>>ss.log
[ ! -s ss.txt ] && wget  -O ss.txt -T 10 $iss >>ss.log 2>>ss.log
[ ! -s ss.txt ] && wget  -O ss.txt -T 10 $iss >>ss.log 2>>ss.log
[ ! -s ss.txt ] && wget  -O ss.txt -T 10 $iss >>ss.log 2>>ss.log
[ ! -s ss.txt ] && wget  -O ss.txt -T 10 $iss >>ss.log 2>>ss.log

if [ -s ss.txt ] ; then
CCC=-1
cat ss.txt |grep 端口：|grep  密码： |sed 's/<[^<>]*>//g' | sed 's/：/:/g'  | sed 's/　/ /g'  \
| tr -s ' ' | tr ' ' ':' | sed 's/ /:/g' \
| sed 's/::/:/g'  | sed 's/256-cfb（/256-cfb:/g' | sed 's/chacha20-life（/chacha20-life:/g' | while read i  
do

  let CCC=$CCC+1
 # [ $CCC -ge 10 ] && echo "==========" >> ss.ini && CCC=0
  var1=`echo $i|awk -F ':' '{print $2}'`
  var2=`echo $i|awk -F ':' '{print $4}'`
  var3=`echo $i|awk -F ':' '{print $6}'`
  var4=`echo $i|awk -F ':' '{print $8}' | tr '[A-Z]' '[a-z]'`  
  echo $var1:$var2:$var3:$var4 >> ss.ini
done
fi
rm ss.txt
echo "==========" >> ss.ini 
}


#########################################

cd /tmp
rm ss.ini > /dev/null 2>&1
get_from_arukas
get_from_ishadowsock
get_from_other
get_from_Alvin9999
[ ! -s ss.ini ] && exit 1

###################### set ss information ####################################
logger "get bestss server"

options1=""
options2=""
ss_usage=""
ss_usage_json=""

nvram set ss_status=1
nvram set ss_enable=0
nvram commit
ss_link_1=`nvram get ss_link_2`
ss_check=`nvram get ss_check`
nvram set ss_check=0
action_port=1090
lan_ipaddr=`nvram get lan_ipaddr`
killall -9  sh_sskeey_k.sh 2>/dev/null
killall -9  ss-redir 2>/dev/null

server1="NONO"
server2="NONO"
time1=999.9
time2=999.9
echo "NONO" >/tmp/server1.tmp
echo "NONO" >/tmp/server2.tmp
echo "999.9" >/tmp/time1.tmp
echo "999.9" >/tmp/time2.tmp
CC=1
CC0=31
[ `date "+%k"` -ge 1 ] && [ `date "+%k"` -le 8 ] && [ "$1" = "refresh" ] && CC0=999

echo "sleep 11" >/tmp/killwget.sh
echo "killall -9 wget  >/dev/null 2>&1" >>/tmp/killwget.sh
chmod a+x /tmp/killwget.sh

cat ss.ini | while read str
do
[ $CC -ge $CC0 ] && break
[ "$str" = "==========" ] && continue 

ss_s1_ip=`echo $str|awk -F ':' '{print $1}'`  
ss_s1_port=`echo $str|awk -F ':' '{print $2}'`  
ss_s1_key=`echo $str|awk -F ':' '{print $3}'`  
ss_s1_method=`echo $str|awk -F ':' '{print $4}'`  

ss_server1=$ss_s1_ip
resolveip=`/usr/bin/resolveip -4 -t 4 $ss_server1 | grep -v : | sed -n '1p'`
[ -z "$resolveip" ] && resolveip=`nslookup $ss_server1 | awk 'NR==5{print $3}'` 
ss_server1=$resolveip
ss_s1_ip=$ss_server1

pidof ss-redir  >/dev/null 2>&1 && killall ss-redir && killall -9 ss-redir 2>/dev/null
/tmp/SSJSON.sh -f /tmp/ss-redir_3.json $ss_usage $ss_usage_json -s $ss_s1_ip -p $ss_s1_port -l 1090 -b 0.0.0.0 -k $ss_s1_key -m $ss_s1_method
ss-redir -c /tmp/ss-redir_3.json $options1 >/dev/null 2>&1 &

ss_s1_ip=$ss_server1
action_ssip=$ss_s1_ip
BP_IP="$action_ssip"
ss-rules -s "$action_ssip" -l "$action_port" -b $BP_IP -d "RETURN" -a "g,$lan_ipaddr" -e '-m multiport --dports 80,443' -o -O

rm /tmp/tmp.txt 2>/dev/null
/tmp/killwget.sh &
PID=`ps|grep killwget.sh|grep -v grep|awk -F" " '{print $1; }'`
PID1=`ps|grep "sleep 11"|grep -v grep|awk -F" " '{print $1; }'`
starttime=$(cat /proc/uptime | cut -d" " -f1)
wget  -q -O /tmp/tmp.txt  --no-check-certificate  -T 8 $url 2>/dev/null
                                #KEY=`echo "" |openssl s_client   -connect www.youtube.com:443 -servername www.youtube.com 2>/dev/null|grep Master-Key|wc -L`
kill -9 $PID $PID1 >/dev/null 2>&1
endtime=$(cat /proc/uptime | cut -d" " -f1)
TIME=`awk -v x=$starttime -v y=$endtime 'BEGIN {printf y-x}'`
if [ -s /tmp/tmp.txt ] ; then
                                ###if [ $KEY -gt 5 ] ; then
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
    echo $str" =====  "$TIME $CC
    logger $str" =====  "$TIME $CC
	RES=`awk -v a=$TIME  'BEGIN { print (a<=10)?1:0'}`
	[ "$RES" = "1"  ] && let CC=$CC+1
else
    echo $str" =====  "$TIME" Fail"
    logger $str" =====  "$TIME" Fail"

fi
done

server1=`cat /tmp/server1.tmp`
server2=`cat /tmp/server2.tmp`
time1=`cat /tmp/time1.tmp`
time2=`cat /tmp/time2.tmp`

echo "The No1 server: "$server1"  "$time1
echo "The No2 server: "$server2"  "$time2
logger "The No1 server: "$server1"  "$time1
logger "The No2 server: "$server2"  "$time2

if [ ! $time1 = "999.9" ]; then
    ssinfo=$server1
    addr0=`echo $ssinfo | awk -F":" '{print $1"\n"; }'`
    port0=`echo $ssinfo | awk -F":" '{print $2"\n"; }'`
    password0=`echo $ssinfo | awk -F":" '{print $3"\n"; }'`
    method0=`echo $ssinfo | awk -F":" '{print $4"\n"; }'`

    nvram set ss_server=$addr0
    nvram set ss_server_port=$port0
    nvram set ss_key=$password0
    nvram set ss_method=$method0
    nvram set ss_server1=$addr0
    nvram set ss_s1_port=$port0
    nvram set ss_s1_key=$password0
    nvram set ss_s1_method=$method0
    nvram commit
fi

if [ ! $time2 = "999.9" ]; then
    ssinfo=$server2
    addr0=`echo $ssinfo | awk -F":" '{print $1"\n"; }'`
    port0=`echo $ssinfo | awk -F":" '{print $2"\n"; }'`
    password0=`echo $ssinfo | awk -F":" '{print $3"\n"; }'`
    method0=`echo $ssinfo | awk -F":" '{print $4"\n"; }'`
		
    nvram set ss_server2=$addr0
    nvram set ss_s2_port=$port0
    nvram set ss_s2_key=$password0
    nvram set ss_s2_method=$method0
    nvram commit
fi


nvram set ss_check=$ss_check
pidof ss-redir  >/dev/null 2>&1 && killall ss-redir  && killall -9 ss-redir 2>/dev/null
killall -9  sh_sskeey_k.sh 2>/dev/null
nvram set ss_status=0
nvram set ss_enable=1
nvram commit
/etc/storage/script/Sh15_ss.sh start >/dev/null  2>/dev/null &


