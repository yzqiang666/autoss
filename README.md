 #删除开头的#启动命令 ：自定义设置 - 脚本 - 自定义 Crontab 定时任务配置
*/10 * * * * [ `nvram get ss_enable` == "1" ] && [ `nvram get ss_internet` != "1" ] && wget -q -O /tmp/autoss.sh --no-check-certificate https://raw.github.com/yzqiang666/autoss/master/autoss.sh && sh /tmp/autoss.sh
13 0,6,12,18 * * *   [ `nvram get ss_enable` == "1" ]  && wget -q -O /tmp/autoss.sh --no-check-certificate https://raw.github.com/yzqiang666/autoss/master/autoss.sh && sh /tmp/autoss.sh



wget -q -O /tmp/autoss.sh https://raw.githubusercontent.com/yzqiang666/autoss/master/autoss.sh
#加入到定时作业，每十分钟检查SS

*/10 * * * * wget -q -O /tmp/autoss.sh --no-check-certificate https://raw.github.com/yzqiang666/autoss/master/autoss.sh ; sh /tmp/autoss.sh



不从github取数


*/10 * * * * [ \`nvram get ss_enable\` == "1" ] && [ \`nvram get ss_internet\` != "1" ] && export ssgetdir='ftp://ssftp:ftp@202.109.226.26/AiCard_02/ftp' && wget -q -O /tmp/autoss.sh --no-check-certificate "$ssgetdir"/autoss.sh && sh /tmp/autoss.sh

读ss.ini中的前后两行
C0=2
C1=3
CC=0
cat ss.ini | while read i  
do
	let CC=CC+1
	if [ $CC eq $C0 ] ; then
	   echo "$CC=$i"
	fi

	if [ $CC eq $C1 ] ; then
	   echo "$CC=$i"	
		break
	fi

done
