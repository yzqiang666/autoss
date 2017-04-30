[ ! "`nvram get shadowsocks_enable`" = "1" ] && exit 1
##################### SSR Server ###########

[  -s /opt/shadowsocksr-manyuser/shadowsocks/run.sh ] \
&& [ `ps | grep python |wc | awk '{ print $1; }'` = 1 ] \
&&  /opt/shadowsocksr-manyuser/shadowsocks/run.sh

#########################################
url="http://www.google.com.hk"


if [ ! "$1" = "refresh" ] ; then
rm /tmp/tmp.txt 2>/dev/null
wget  -q  -O /tmp/tmp.txt --continue --no-check-certificate   -T 10 $url 2>/dev/null 
[ -s /tmp/tmp.txt ] && exit 0
fi
cd /tmp

rm ss.ini > /dev/null 2>&1
/etc/storage/shadowsocks_script.sh stop

########################  get from arukas ########################
token="e39ed54e-18ee-4eae-b372-41b4e05721f3"
secret="eoZ9cCkTpM0d6Rb7BEtXl5luBcqZyVeiNLZuKUxGjgOFnB1tqTChz3Wr8JKS2kJY"

rm ss.txt > /dev/null 2>&1
wget -q  -O ss.txt -tries=10 https://$token:$secret@app.arukas.io/api/containers
[ ! -s ss.txt ] && wget  -q  -O ss.txt -tries=10 https://$token:$secret@app.arukas.io/api/containers
[ ! -s ss.txt ] && wget  -q  -O ss.txt -tries=10 https://$token:$secret@app.arukas.io/api/containers
[ ! -s ss.txt ] && wget  -q  -O ss.txt -tries=10 https://$token:$secret@app.arukas.io/api/containers
[ ! -s ss.txt ] && wget  -q  -O ss.txt -tries=10 https://$token:$secret@app.arukas.io/api/containers

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
 
echo "==========" >> ss.ini 
fi

#######################  加入存放在github中的零星收集的SS Server
wget  -q  -O sss.txt -tries=10 https://raw.githubusercontent.com/yzqiang666/autoss/master/ss.txt
[ -s sss.txt ]  && cat sss.txt >> ss.ini && echo "==========" >> ss.ini  

########################  get from ishadowsock ########################
#iss="http://go.ishadow.online/"
iss="http://www.ishadowsocks.org/"
rm ss.txt > /dev/null 2>&1
wget  -q  -O ss.txt -tries=10 $iss
[ ! -s ss.txt ] && wget  -q  -O ssss.txt -tries=10 $iss
[ ! -s ss.txt ] && wget  -q  -O ssss.txt -tries=10 $iss
[ ! -s ss.txt ] && wget  -q  -O ssss.txt -tries=10 $iss
[ ! -s ss.txt ] && wget  -q  -O ssss.txt -tries=10 $iss


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
####head -n 9  ssss.ini >>ss.ini
rm ssss.*
echo "==========" >> ss.ini 

########################  get from github.com/Alvin9999 不得已才用　########################
####if [ ! -s ss.ini ] ; then
rm ss.txt > /dev/null 2>&1
iss="https://github.com/Alvin9999/new-pac/wiki/ss%E5%85%8D%E8%B4%B9%E8%B4%A6%E5%8F%B7"

wget  -q  -O ss.txt -tries=10 $iss
[ ! -s ss.txt ] && wget  -q  -O ssss.txt -tries=10 $iss
[ ! -s ss.txt ] && wget  -q  -O ssss.txt -tries=10 $iss
[ ! -s ss.txt ] && wget  -q  -O ssss.txt -tries=10 $iss
[ ! -s ss.txt ] && wget  -q  -O ssss.txt -tries=10 $iss
if [ -s ss.txt ] ; then
cat ss.txt |grep 端口：|grep  密码： |sed 's/<[^<>]*>//g' | sed 's/：/:/g'  | sed 's/　/ /g'  \
| sed 's/  / /g' | sed 's/  / /g' | sed 's/  / /g' | sed 's/  / /g' | sed 's/  / /g' | sed 's/ /:/g' \
| sed 's/::/:/g'  | sed 's/（/:/g' | head -n 18 | while read i  
do
  var1=`echo $i|awk -F ':' '{print $2}'`
  var2=`echo $i|awk -F ':' '{print $4}'`
  var3=`echo $i|awk -F ':' '{print $6}'`
  var4=`echo $i|awk -F ':' '{print $8}'`
  echo $var1:$var2:$var3:$var4 >> ss.ini
done
fi
rm ss.txt
echo "==========" >> ss.ini 
####fi





if [ -s ss.ini ] ; then
Method_value=0
Method_Str=""


getmethod()
{
case $Method_Str in  
 table  )  Method_value=1       ;;
 rc4  )  Method_value=2 ;;  
 rc4-md5 )  Method_value=3      ;;   
 aes-128-cfb  ) Method_value=4  ;;
 aes-192-cfb  ) Method_value=5  ;;
 aes-256-cfb  ) Method_value=6  ;;
 aes-128-ctr  ) Method_value=7  ;;
 aes-192-ctr  ) Method_value=8  ;;
 aes-256-ctr  ) Method_value=9  ;;
 bf-cfb  ) Method_value=10      ;;
 camellia-128-cfb  ) Method_value=11    ;;
 camellia-192-cfb  ) Method_value=12    ;;
 camellia-256-cfb  ) Method_value=13    ;;
 cast5-cfb  ) Method_value=14   ;;
 des-cfb  ) Method_value=15     ;;
 idea-cfb  ) Method_value=16    ;;
 rc2-cfb  ) Method_value=17     ;;
 seed-cfb  ) Method_value=18    ;;
 salsa20  ) Method_value=19     ;;
 chacha20  ) Method_value=20    ;;
 chacha20-ietf  ) Method_value=21       ;;
 chacha20-ietf-poly1305  ) Method_value=22      ;;
 aes-128-gcm  ) Method_value=23 ;;
 aes-192-gcm  ) Method_value=24 ;;
 aes-256-gcm  ) Method_value=25 ;;

 *  ) Method_value=3 ;; 
esac
}


logger "get bestss server"
server1="NONO"
server2="NONO"
time1=999.9
time2=999.9
echo "NONO" >/tmp/server1.tmp
echo "NONO" >/tmp/server2.tmp
echo "999.9" >/tmp/time1.tmp
echo "999.9" >/tmp/time2.tmp
watchdog=`nvram get shadowsocks_watchdog_enable`
nvram set shadowsocks_watchdog_enable=0
nvram set ss_node_num_x=3
nvram set shadowsocks_master_config=2
nvram set shadowsocks_second_config=2
killall -9 watchdog >/dev/null 2>/dev/null 
str="153.125.233.236:31731:yzqyzq:rc4-md5::"
CC=0
cat ss.ini | while read str
do
#echo "begin process ===========   "$str
if [ "$str" = "==========" ] ; then
	if [ $CC -ge 100 ] ; then
		break
	else
		continue
	fi
fi
ss_s1_ip=`echo $str|awk -F ':' '{print $1}'`  
ss_s1_port=`echo $str|awk -F ':' '{print $2}'`  
ss_s1_key=`echo $str|awk -F ':' '{print $3}'`  
ss_s1_method=`echo $str|awk -F ':' '{print $4}'`  

Method_Str=$ss_s1_method
getmethod
nvram set ss_node_server_addr_x2=$ss_s1_ip
nvram set ss_node_server_port_x2=$ss_s1_port
nvram set ss_node_password_x2=$ss_s1_key
#nvram set ss_node_method_x2=$ss_s1_method
nvram set ss_node_method_x2=$Method_value
nvram commit
restart_ss
#killall ss-redir 2>/dev/null  
#killall -9 ss-redir 2>/dev/null
############/usr/sbin/ss-redir -b 0.0.0.0 -c /tmp/shadowsocks.json  >/dev/null 2>&1 &
#sleep 1
##########先测试一次，以启动SS
#wget  -q -T 2 -O  /tmp/aa.txt http://www.google.com.hk/ 2>/dev/null

min=1
max=30
while [ $min -le $max ]
do
    PID=`pidof shadowsocks_script.sh`
    [  ! "$PID" > "1" ] && break
    min=`expr $min + 1`
    sleep 1
done  
sleep 1

#wget  -q -T 2 -O  /tmp/aa.txt http://www.google.com.hk/ 2>/dev/null
#########正式测试时间
starttime=$(cat /proc/uptime | cut -d" " -f1)
rm /tmp/tmp.txt 2>/dev/null
wget  -q -O /tmp/tmp.txt --continue --no-check-certificate   -T 3  http://www.google.com.hk/ 2>/dev/null
#wget  -q -O /tmp/tmp.txt --continue --no-check-certificate   -T 3  http://www.google.co.jp/ 2>/dev/null
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
    echo $str" =====  "$TIME $min $CC
    logger $str" =====  "$TIME $min
	RES=`awk -v a=$TIME  'BEGIN { print (a<=1)?1:0'}`
	[ "$RES" = "1"  ] && let CC=$CC+1
else
    echo $str" =====  Fail" $min
    logger $str" =====  Fail" $min

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


str=$server1
ss_s1_ip=`echo $str|awk -F ':' '{print $1}'`  
ss_s1_port=`echo $str|awk -F ':' '{print $2}'`  
ss_s1_key=`echo $str|awk -F ':' '{print $3}'`  
ss_s1_method=`echo $str|awk -F ':' '{print $4}'`  

Method_Str=$ss_s1_method                          
getmethod
nvram set ss_node_server_addr_x0=$ss_s1_ip
nvram set ss_node_server_port_x0=$ss_s1_port
nvram set ss_node_password_x0=$ss_s1_key
nvram set ss_node_method_x0=$Method_value

str=$server2
ss_s1_ip=`echo $str|awk -F ':' '{print $1}'`  
ss_s1_port=`echo $str|awk -F ':' '{print $2}'`  
ss_s1_key=`echo $str|awk -F ':' '{print $3}'`  
ss_s1_method=`echo $str|awk -F ':' '{print $4}'`  

Method_Str=$ss_s1_method                                                                                
getmethod 
nvram set ss_node_server_addr_x1=$ss_s1_ip
nvram set ss_node_server_port_x1=$ss_s1_port
nvram set ss_node_password_x1=$ss_s1_key
nvram set ss_node_method_x1=$Method_value


nvram set shadowsocks_master_config=0
nvram set shadowsocks_second_config=1
nvram set shadowsocks_watchdog_enable=$watchdog
nvram commit
killall -9 watchdog >/dev/null 2>/dev/null 
watchdog
restart_ss

fi
