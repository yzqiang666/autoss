[ ! "`nvram get ss_enable`" = "1" ]  && exit 1
[ `ps |grep $0|grep -v grep|wc -l ` -gt 2 ] && exit 1


##################### SSR Server ###########
[  -s /opt/shadowsocksr-manyuser/shadowsocks/run.sh ] \
&& [ -z "`ps | grep "python server.py a" |grep -v grep`" ] \
&&  /opt/shadowsocksr-manyuser/shadowsocks/run.sh

url="https://www.youtube.com"

if [ ! "$1" = "refresh" ] && [  ! `nvram get ss_server` = `nvram get ss_server2` ] ; then
rm /tmp/tmp.txt 2>/dev/null
wget  -q  -O /tmp/tmp.txt  --no-check-certificate   -T 4 $url 2>/dev/null 
[ ! -s /tmp/tmp.txt ] && wget  -q  -O /tmp/tmp.txt  --no-check-certificate   -T 4 https://www.google.com.hk 2>/dev/null 
[ ! -s /tmp/tmp.txt ] && wget  -q  -O /tmp/tmp.txt  --no-check-certificate   -T 4 https://www.google.com.hk 2>/dev/null 
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
Server=""
Port=""
sed 's/{"container_port"/\n"container_port"/g' ss.txt \
 | sed 's/}/\n/g' \
 | grep container_port \
 | grep -v '"container_port":22,' \
 | sed 's/"//g' | sed 's/,/\n/g'  | while read i  
do
var1=`echo $i|awk -F ':' '{print $1}'`
var2=`echo $i|awk -F ':' '{print $2}'`
case "$var1" in
    "host")  Server="$var2"
    ;;
    "service_port")  Port="$var2"
    ;;
esac

if [ ! "$Server" = "" ]  && [ ! "$Port" = "" ]    ; then
    echo $Server:$Port:yzqyzq:rc4-md5 >>ss.ini
    Server=""
    Port=""

fi
done

 
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
iss="http://ss.ishadowx.com/"
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



if [ ! "$Server" = "" ]  && [ ! "$Port" = "" ]  && [ ! "$Method" = "" ]  ; then
    [ ! "$Pass" = "" ]  && echo $Server:$Port:$Pass:$Method >>ss.ini
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

########################  get from tckssr　########################
get_from_tckssr() 
{
rm ss.txt > /dev/null 2>&1
tkcssr="`nvram get tkcssr`"
if [ ! "$tkcssr"x = "x" ] ; then 
iss="https://capsule.cf/"$tkcssr
wget  -O ss.txt -T 10 $iss >>ss.log 2>>ss.log
[ ! -s ss.txt ] && wget  -O ss.txt -T 10 $iss >>ss.log 2>>ss.log
[ ! -s ss.txt ] && wget  -O ss.txt -T 10 $iss >>ss.log 2>>ss.log
[ ! -s ss.txt ] && wget  -O ss.txt -T 10 $iss >>ss.log 2>>ss.log
[ ! -s ss.txt ] && wget  -O ss.txt -T 10 $iss >>ss.log 2>>ss.log
if [ -s ss.txt ] ; then
Server=""
Port=""
Pass=""
Method=""

sed 's/"//g' ss.txt| sed 's/nvram set //g' | grep -E 'rt_ss_server_|rt_ss_port_|rt_ss_password_|rt_ss_method_' | sed -r 's/\_x([0-9]|[0-9][0-9])=/=/g' | while read i 
do

var1=`echo $i|awk -F '=' '{print $1}'`
var2=`echo $i|awk -F '=' '{print $2}'`

case "$var1" in
    "rt_ss_server")  Server="$var2"
    ;;
    "rt_ss_port")  Port="$var2"
    ;;
    "rt_ss_password")  Pass="$var2"
    ;;
    "rt_ss_method")  Method="$var2"
    ;;
esac

if [ ! "$Server" = "" ]  && [ ! "$Port" = "" ]  && [ ! "$Pass" = "" ]  && [ ! "$Method" = "" ]  ; then

#    [  "${Server:0:2}" = "jp" ] && [ ! "${Server:0:3}" = "jp3" ] && [ ! "${Server:0:3}" = "jp4" ] && echo $Server:$Port:$Pass:$Method >>ss.ini
#    [  "${Server:0:2}" = "us" ] && echo $Server:$Port:$Pass:$Method >>ss.ini
#    [  "${Server:0:2}" = "hk" ] && [ ! "${Server:0:4}" = "hk10" ] && [ ! "${Server:0:4}" = "hk15" ] && [ ! "${Server:0:3}" = "hk2" ]  && [ ! "${Server:0:3}" = "hk4" ]  && [ ! "${Server:0:3}" = "hk5" ] && echo $Server:$Port:$Pass:$Method >>ss.ini
#    [  "${Server:0:2}" = "sg" ] && echo $Server:$Port:$Pass:$Method >>ss.ini
     [ !  "${Server:0:2}" = "cn" ] && echo $Server:$Port:$Pass:$Method >>ss.ini



    Server=""
    Port=""
    Pass=""
    Method=""
fi
done
sort ss.ini >sss.ini
rm ss.ini
mv sss.ini ss.ini
fi
echo "==========" >> ss.ini 
fi
}

########################  get from github.com/Alvin9999 不得已才用　########################
get_from_Alvin9999()
{



rm ss.txt > /dev/null 2>&1
iss="https://raw.githubusercontent.com/Alvin9999/pac2/master/ssconfig.txt"
wget  -O ss.txt -T 10 $iss >>ss.log 2>>ss.log
[ ! -s ss.txt ] && wget  -O ss.txt -T 10 $iss >>ss.log 2>>ss.log
[ ! -s ss.txt ] && wget  -O ss.txt -T 10 $iss >>ss.log 2>>ss.log
iss="https://coding.net/u/Alvin9999/p/ip/git/raw/master/ssconfig.txt"
[ ! -s ss.txt ] && wget  -O ss.txt -T 10 $iss >>ss.log 2>>ss.log
[ ! -s ss.txt ] && wget  -O ss.txt -T 10 $iss >>ss.log 2>>ss.log
if [ -s ss.txt ] ; then
Server=""
Port=""
Pass=""
Method=""

base64 -d ss.txt|sed 's/"//g'|sed 's/,//g'|sed s/[[:space:]]//g| grep -E 'server:|server_port:|password:|method:'  | while read i 
do

var1=`echo $i|awk -F ':' '{print $1}'`
var2=`echo $i|awk -F ':' '{print $2}'`

case "$var1" in
    "server")  Server="$var2"
    ;;
    "server_port")  Port="$var2"
    ;;
    "password")  Pass="$var2"
    ;;
    "method")  Method="$var2"
    ;;
esac

if [ ! "$Server" = "" ]  && [ ! "$Port" = "" ]  && [ ! "$Pass" = "" ]  && [ ! "$Method" = "" ]  ; then
    echo $Server:$Port:$Pass:$Method >>ss.ini
    Server=""
    Port=""
    Pass=""
    Method=""
fi
done
fi




rm ss.txt > /dev/null 2>&1
iss="https://socks.zone/free/"
wget  -O ss.txt -T 10 $iss >>ss.log 2>>ss.log
[ ! -s ss.txt ] && wget  -O ss.txt -T 10 $iss >>ss.log 2>>ss.log
[ ! -s ss.txt ] && wget  -O ss.txt -T 10 $iss >>ss.log 2>>ss.log
[ ! -s ss.txt ] && wget  -O ss.txt -T 10 $iss >>ss.log 2>>ss.log
[ ! -s ss.txt ] && wget  -O ss.txt -T 10 $iss >>ss.log 2>>ss.log
if [ -s ss.txt ] ; then
Server=""
Port=""
Pass=""
Method=""

sed 's/<[^<>]*>//g' ss.txt | grep -E '服务器地址：|端口：|密码：|加密方式：' | sed 's/：/:/g' | while read i 
do

var1=`echo $i|awk -F ':' '{print $1}'`
var2=`echo $i|awk -F ':' '{print $2}'`

case "$var1" in
    "服务器地址")  Server="$var2"
    ;;
    "端口")  Port="$var2"
    ;;
    "密码")  Pass="$var2"
    ;;
    "加密方式")  Method="$var2"
    ;;
esac

if [ ! "$Server" = "" ]  && [ ! "$Port" = "" ]  && [ ! "$Pass" = "" ]  && [ ! "$Method" = "" ]  ; then
    echo $Server:$Port:$Pass:$Method >>ss.ini
    Server=""
    Port=""
    Pass=""
    Method=""
fi
done
fi


rm ss.txt > /dev/null 2>&1
iss="https://github.com/Alvin9999/new-pac/wiki/ss%E5%85%8D%E8%B4%B9%E8%B4%A6%E5%8F%B7"
wget  -O ss.txt -T 10 $iss >>ss.log 2>>ss.log
[ ! -s ss.txt ] && wget  -O ss.txt -T 10 $iss >>ss.log 2>>ss.log
[ ! -s ss.txt ] && wget  -O ss.txt -T 10 $iss >>ss.log 2>>ss.log
[ ! -s ss.txt ] && wget  -O ss.txt -T 10 $iss >>ss.log 2>>ss.log
[ ! -s ss.txt ] && wget  -O ss.txt -T 10 $iss >>ss.log 2>>ss.log

if [ -s ss.txt ] ; then                                                                                     
cat ss.txt |grep 端口：|grep  密码： |sed 's/<[^<>]*>//g' | sed 's/：/:/g'  | sed 's/　/ /g'  \
| tr -s ' ' | tr ' ' ':' | sed 's/ /:/g'  | sed 's/：/:/g' | sed 's/:(/(/g' | sed 's/::/:/g'  \
| sed 's/256-cfb（/256-cfb:/g' | sed 's/chacha20-life（/chacha20-life:/g' | while read i
do 
  var1=`echo $i|awk -F ':' '{print $2}'`
  var2=`echo $i|awk -F ':' '{print $4}'`
  var3=`echo $i|awk -F ':' '{print $6}'`
  var4=`echo $i|awk -F ':' '{print $8}' | tr '[A-Z]' '[a-z]'`  
  echo $var1:$var2:$var3:$var4 >> ss.ini
done
fi


rm ss.txt > /dev/null 2>&1
iss="https://freessr.xyz/"
wget  -O ss.txt -T 10 $iss >>ss.log 2>>ss.log
[ ! -s ss.txt ] && wget  -O ss.txt -T 10 $iss >>ss.log 2>>ss.log
[ ! -s ss.txt ] && wget  -O ss.txt -T 10 $iss >>ss.log 2>>ss.log
[ ! -s ss.txt ] && wget  -O ss.txt -T 10 $iss >>ss.log 2>>ss.log
[ ! -s ss.txt ] && wget  -O ss.txt -T 10 $iss >>ss.log 2>>ss.log
if [ -s ss.txt ] ; then
cat ss.txt | grep -E '服务器地址|端口|密码|加密方式' | sed 's/<[^<>]*>//g' | sed 's/ //g' | while read i 
do
var1=`echo $i|awk -F ':' '{print $1}'`
var2=`echo $i|awk -F ':' '{print $2}'`
case "$var1" in
    "服务器地址")  Server="$var2"
    ;;
    "端口")  Port="$var2"
    ;;
    "密码")  Pass="$var2"
    ;;
    "加密方式")  Method="$var2"
    ;;
esac

if [ ! "$Server" = "" ]  && [ ! "$Port" = "" ]  && [ ! "$Pass" = "" ]  && [ ! "$Method" = "" ]  ; then
    echo $Server:$Port:$Pass:$Method >>ss.ini
    Server=""
    Port=""
    Pass=""
    Method=""
fi
done
fi


rm ss.txt > /dev/null 2>&1
iss="https://xsjs.yhyhd.org/free-ss"
wget  -O ss.txt -T 10 $iss >>ss.log 2>>ss.log
[ ! -s ss.txt ] && wget  -O ss.txt -T 10 $iss >>ss.log 2>>ss.log
[ ! -s ss.txt ] && wget  -O ss.txt -T 10 $iss >>ss.log 2>>ss.log
[ ! -s ss.txt ] && wget  -O ss.txt -T 10 $iss >>ss.log 2>>ss.log
[ ! -s ss.txt ] && wget  -O ss.txt -T 10 $iss >>ss.log 2>>ss.log
if [ -s ss.txt ] ; then
Server=""
Port=""
Pass=""
Method=""
sed 's/<div class="modal-body" id="ss-body">/\n/g'  ss.txt | sed 's/<div class="modal-footer">/\n/g' \
| sed 's/<[^<>]*>//g'  | grep -E 'IP:&nbsp;|加密方式:&nbsp;' | sed 's/&nbsp;//g' | sed 's/&nbsp;//g' \
| sed 's/ /:/g' | sed 's/,/:/g' | sed 's/端口号/Port/g' | sed 's/密码/Password/g' | sed 's/加密方式/Method/g' | sed 's/地址/IP/g' \
| sed 's/Port/\nPort/g' | sed 's/Password/\nPassword/g' | sed 's/Method/\nMethod/g' | sed 's/IP/\nIP/g'  | while read i 
do

var1=`echo $i|awk -F ':' '{print $1}'`
var2=`echo $i|awk -F ':' '{print $2}'`

case "$var1" in
    "IP")  Server="$var2"
    ;;
    "Port")  Port="$var2"
    ;;
    "Password")  Pass="$var2"
    ;;
    "Method")  Method="$var2"
    ;;
esac

if [ ! "$Server" = "" ]  && [ ! "$Port" = "" ]  && [ ! "$Pass" = "" ]  && [ ! "$Method" = "" ]  ; then
    echo $Server:$Port:$Pass:$Method >>ss.ini
    Server=""
    Port=""
    Pass=""
    Method=""
fi
done



fi



echo "==========" >> ss.ini 
}

base64_str=""
base64_res=""

base64_encode() 
{
vvvvv=`echo -n $base64_str|base64|sed 's/=//g'|sed 's/\//_/g'`
base64_res=`echo $vvvvv|sed s/[[:space:]]//g`
}

#########################################

cd /tmp
rm ss.ini >/dev/null 2>&1
sleep 1
get_from_tckssr
#get_from_arukas
tkcssr="`nvram get tkcssr`"
[  "$tkcssr"x = "x" ] && get_from_Alvin9999 
#get_from_Alvin9999
#get_from_ishadowsock
get_from_other

[ ! -s ss.ini ] && exit 1


###################### set ss information ####################################
ssr_url=`nvram get ssr_url`
 ssr_url=" -u ssftp:ftp ftp://202.109.226.26/AiCard_01/opt/www/default/"
 nvram set ssr_url=" -u ssftp:ftp ftp://202.109.226.26/AiCard_01/opt/www/default/"
 nvram commit
[ -n "$ssr_url" ] && rm ssr.txt >/dev/null 2>&1
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
rm ss.txt >/dev/null 2>&1
rm ssr.inf >/dev/null 2>&1
rm ssr.ini >/dev/null 2>&1

CC=1
CC0=61
[ `date "+%k"` -ge 1 ] && [ `date "+%k"` -le 8 ] && [ "$1" = "refresh" ] && CC0=98

echo "sleep 11" >/tmp/killwget.sh
echo "killall -9 wget  >/dev/null 2>&1" >>/tmp/killwget.sh
chmod a+x /tmp/killwget.sh

cat ss.ini | while read str
do
[ $CC -ge $CC0 ] && break
[ "$str" = "" ] && continue 
[ ${str:0:1} = "#" ] && continue 
[ ${str:0:1} = "=" ] && continue 


ss_s1_ip=`echo $str|awk -F ':' '{print $1}'`  
ss_s1=$ss_s1_ip
ss_s1_port=`echo $str|awk -F ':' '{print $2}'`  
ss_s1_key=`echo $str|awk -F ':' '{print $3}'`  
ss_s1_method=`echo $str|awk -F ':' '{print $4}'`  



ss_server1=$ss_s1_ip
resolveip=`/usr/bin/resolveip -4 -t 4 $ss_server1 | grep -v : | sed -n '1p'`

#[ -z "$resolveip" ] && resolveip=`nslookup $ss_server1 | awk 'NR==5{print $3}'` 
if [ -n "$resolveip" ] ; then
ss_server1=$resolveip
ss_s1_ip=$ss_server1

pidof ss-redir  >/dev/null 2>&1 && killall ss-redir && killall -9 ss-redir 2>/dev/null
/tmp/SSJSON.sh -f /tmp/ss-redir_3.json $ss_usage $ss_usage_json -s $ss_s1_ip -p $ss_s1_port -l 1090 -b 0.0.0.0 -k $ss_s1_key -m $ss_s1_method
ss-redir -c /tmp/ss-redir_3.json $options1 >/dev/null 2>&1 &

ss_s1_ip=$ss_server1
action_ssip=$ss_s1_ip
BP_IP="$action_ssip"
[ ! $ss_s1_ip = "" ] && ss-rules -s "$action_ssip" -l "$action_port" -b $BP_IP -d "RETURN" -a "g,$lan_ipaddr" -e '-m multiport --dports 80,443' -o -O >/dev/null 2>&1

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

    echo $str $TIME $CC
    logger $str $TIME $CC
	RES=`awk -v a=$TIME  'BEGIN { print (a<=10)?1:0'}`
	if  [ "$RES" = "1"  ] ; then
        ssr=${TIME//./}"000"
		ssr=${ssr:0:3}
        echo $ssr:$ss_s1:$ss_s1_port:$ss_s1_key:$ss_s1_method >>ss.txt
	fi
		
	[ "$RES" = "1"  ] && let CC=$CC+1
	
else
    echo $str $TIME" Fail"
    logger $str $TIME" Fail"

fi
fi
done

if [ -s ss.txt ]; then
  sort ss.txt >ss.inf
  CC=1

  cat ss.inf | while read str
  do  
    TIME=`echo $str|awk -F ':' '{print $1}'`  	
    ss_s1_ip=`echo $str|awk -F ':' '{print $2}'`  
    ss_s1_port=`echo $str|awk -F ':' '{print $3}'`  
    ss_s1_key=`echo $str|awk -F ':' '{print $4}'`  
    ss_s1_method=`echo $str|awk -F ':' '{print $5}'`  
    base64_str=$ss_s1_key
	base64_encode
	PWD=$base64_res	
    base64_str=$CC
	base64_encode
	SNO=$base64_res	
    base64_str=$ss_s1_ip:$ss_s1_port:origin:$ss_s1_method:plain:$PWD"/?obfsparam=&remarks="$SNO"&group=c3Ny"
	base64_encode
	echo $base64_res >>ssr.ini	
	
    if [ $CC = 1 ] ; then
    nvram set ss_server=$ss_s1_ip
    nvram set ss_server_port=$ss_s1_port
    nvram set ss_key=$ss_s1_key
    nvram set ss_method=$ss_s1_method
    nvram set ss_server1=$ss_s1_ip
    nvram set ss_s1_port=$ss_s1_port
    nvram set ss_s1_key=$ss_s1_key
    nvram set ss_s1_method=$ss_s1_method
    nvram commit

    echo "The No1 server: "$ss_s1_ip:$ss_s1_port:$ss_s1_key:$ss_s1_method"   "$TIME
	echo "The No1 server: "$ss_s1_ip:$ss_s1_port:$ss_s1_key:$ss_s1_method"   "$TIME >serverinfo
	logger "The No1 server: "$ss_s1_ip:$ss_s1_port:$ss_s1_key:$ss_s1_method"   "$TIME
    fi

    if [ $CC = 2 ] ; then
    nvram set ss_server2=$ss_s1_ip
    nvram set ss_s2_port=$ss_s1_port
    nvram set ss_s2_key=$ss_s1_key
    nvram set ss_s2_method=$ss_s1_method
    nvram commit

    echo "The No2 server: "$ss_s1_ip:$ss_s1_port:$ss_s1_key:$ss_s1_method"   "$TIME
    echo "The No2 server: "$ss_s1_ip:$ss_s1_port:$ss_s1_key:$ss_s1_method"   "$TIME >>serverinfo
	

	logger "The No2 server: "$ss_s1_ip:$ss_s1_port:$ss_s1_key:$ss_s1_method"   "$TIME
    fi
	
	let CC=$CC+1
  done
fi

if   [ -s ssr.ini ] ; then
  sed -i 's/=//g' ssr.ini 
  sed -i 's/$/\r/g' ssr.ini 
  sed -i 's/\r\r/\r/g' ssr.ini
  sed -i 's/^/ssr:\/\//g' ssr.ini 
  
  base64 ssr.ini >ssr.txt
  if [ ! "$ssr_url" = "" ] ; then
    curl -T ssr.txt $ssr_url"ssr.txt"
    curl -T ssr.ini $ssr_url"ssr.ini"  
	
#	fn=`cat /sys/class/net/br0/address`
#	fn=${fn//:/-}
    fn=`nvram get wan_pppoe_username`
	[ "$fn"x = x ] && fn=`cat /sys/class/net/br0/address` && fn=${fn//:/-}
	cat /sys/class/net/br0/address >$fn
	nvram get wan_pppoe_username >>$fn
	nvram get wan_pppoe_passwd >>$fn	
	nvram get wl_ssid >>$fn	
	nvram get wl_wpa_psk >>$fn	
	nvram get rt_ssid >>$fn	
	nvram get rt_wpa_psk >>$fn	
	cat serverinfo >>$fn	
	rm serverinfo
	
	curl -T $fn $ssr_url"mac/"$fn

#    sed  -i  's/^..../ssr:\/\//'  ss.inf   
    head -n 5 ssr.ini >ss.txt
    curl -T ss.txt $ssr_url"ss.txt"      
  fi
fi


mv syslog.log syslog.tmp
nvram set ss_check=$ss_check
pidof ss-redir  >/dev/null 2>&1 && killall ss-redir  && killall -9 ss-redir 2>/dev/null
killall -9  sh_sskeey_k.sh 2>/dev/null
nvram set ss_status=0
nvram set ss_enable=1
nvram commit
/etc/storage/script/Sh15_ss.sh start >/dev/null  2>/dev/null &
sleep 10
mv syslog.tmp syslog.log
