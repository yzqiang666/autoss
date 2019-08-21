###www.tkc.im######
###zcssr.com#####
ssrurl="https://zcssr.com"
logger "================ 开始自动登录并签到 =================="
cat >/tmp/t.txt <<-ABCDEF
url=https://78ssr.club
yzqiang6@sina.com
url=https://www.fqssr.tw
yzqiang6@sina.com
url=https://yangjuan.cc
yzqiang6@sina.com
url=https://fljsr.com
yzqiang6@sina.com
url=https://zhs.icu
yzqiang6@sina.com
url=https://zcssr.best
3197190@qq.com
1398098441@qq.com
yzqiang6@sina.com
yzqiang6@gmail.com
yzqiang@21cn.com
ABCDEF

cd /tmp
cat /tmp/t.txt | while read str
do  
[  "$str" = "" ] && continue
if [ ${str:0:4} = "url=" ] ; then
ssrurl=${str:4:400}
echo "======== "${str:4:400} " 开始自动签到 ============="
logger "======== "${str:4:400} " 开始自动签到 ============"
passwd="yzqyzq1234"
continue
fi
email=`echo $str|awk -F "|" '{print $1}'`
p1=`echo $str|awk -F "|" '{print $2}'`
[ ! "$p1" = ""  ] && passwd=$p1
##str="1398098441@qq.com"
rm tmp0.txt 2>/dev/null
rm c.txt 2>/dev/null
sleep 1
curl   -s -o tmp0.txt  -k  -c /tmp/c.txt  -X POST  -H "Connection: keep-alive" \
 -H "Accept: application/json, text/javascript, */*; q=0.01" \
 -H "Referer: $ssrurl/auth/login" \
 -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.119 Safari/537.36" \
 -H "Accept-Encoding: gzip, deflate, br" -H "Accept-Language: zh-CN,zh;q=0.9,en;q=0.8" -d "email=$email&passwd=$passwd&code=&remember_me=" \
 $ssrurl/auth/login
if [  -s c.txt  ] && [ ! "`cat /tmp/c.txt|grep email`" =  "" ] ; then
  sleep 1
  curl  -s -o tmp0.txt  -k  -b /tmp/c.txt -X POST -H "Connection: keep-alive" \
  -H "Accept: application/json, text/javascript, */*; q=0.01" \
  -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.119 Safari/537.36" \
  -H "Accept-Encoding: gzip, deflate, br" -H "Accept-Language: zh-CN,zh;q=0.9,en;q=0.8" \
  $ssrurl/user/checkin  
  if [ ! "`cat tmp0.txt|awk -F " " '{print($2)}'`" =  "" ]; then
    S1=`cat tmp0.txt|awk -F " " '{print($2)}'`"MB"
    echo $email" 本次获得: "$S1
    logger $email" 本次获得: "$S1
  else
    if [ ! "`grep ... tmp0.txt`" = "" ]; then
      echo $email" 已经签到过了"
      logger $email" 已经签到过了"
    else
      echo $email" 未知错误"
      logger $email" 未知错误"
    fi
  fi 
else
  echo $email" 登录失败"
  logger $email" 登录失败"
fi
done
logger "======================================================"

exit

url=https://78ss.club
yzqiang6@sina.com
yzqiang6@gmail.com
3197190@qq.com
url=https://www.pussr.com
yzqiang6@sina.com
yzqiang6@gmail.com
3197190@qq.com
url=https://staryun.me
1398098441@qq.com
yzqiang@21cn.com
yzqiang6@sina.com
yzqiang6@gmail.com
yzqiang5@gmail.com
3197190@qq.com
url=https://www.tkc.im
yzqiang6@sina.com
yzqiang@21cn.com
