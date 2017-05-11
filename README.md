 #删除开头的#启动命令 ：自定义设置 - 脚本 - 自定义 Crontab 定时任务配置
 
*/10 * * * * [ `nvram get ss_enable` == "1" ] && [ `nvram get ss_internet` != "1" ] && wget -q -O /tmp/autoss.sh --no-check-certificate https://raw.github.com/yzqiang666/autoss/master/autoss.sh && sh /tmp/autoss.sh

13 0,6,12,18 * * *   [ `nvram get ss_enable` == "1" ]  && wget -q -O /tmp/autoss.sh --no-check-certificate https://raw.github.com/yzqiang666/autoss/master/autoss.sh && sh /tmp/autoss.sh



wget -q -O /tmp/autoss.sh https://raw.githubusercontent.com/yzqiang666/autoss/master/autoss.sh
#加入到定时作业，每十分钟检查SS

*/10 * * * * wget -q -O /tmp/autoss.sh --no-check-certificate https://raw.github.com/yzqiang666/autoss/master/autoss.sh ; sh /tmp/autoss.sh






以下地址不走SS

WAN!raw.githubusercontent.com
WAN!github.com
WAN!202.109.226.26
WAN!ishadow.online
WAN!www.ishadowsocks.org
WAN-153.125.0.0/16
WAN!raw.github.com
WAN!ss.404da.com
WAN!app.arukas.io


raw.githubusercontent.com
github.com
202.109.226.26
ishadow.online
www.ishadowsocks.org
153.125.0.0/16
raw.github.com
ss.404da.com
app.arukas.io

