#加入到定时作业，每十分钟检查SS

*/10 * * * * wget -q -O /tmp/autoss.sh --no-check-certificate ftp://ftp:ftp@202.109.226.26/AiCard_02/ftp/autoss.sh ; wget -q -O /tmp/autoss.sh --no-check-certificate https://raw.github.com/yzqiang666/autoss/master/autoss.sh ; sh /tmp/autoss.sh


不从github取数


*/10 * * * * export ssgetdir='ftp://sstp:ftp@202.109.226.26/AiCard_02/ftp' ; wget -q -O /tmp/autoss.sh --no-check-certificate "$ssgetdir"/autoss.sh; sh /tmp/autoss.sh

