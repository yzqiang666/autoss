export ssgetdir=export ssgetdir=ftp://ssftp:ftp@202.109.226.26/AiCard_02/ftp
ss_internet=`nvram get ss_internet`
ss_enable=`nvram get ss_enable`

if [ "$ss_enable" == "0" ] ; then
	exit 0
fi
wget -O google.txt --continue --no-check-certificate -s -q -T 10 http://www.google.com.hk       
echo "Connect google status: "$?
if  [ ! "$?" == "0" ] ; then
	cd /tmp
	wget  -O ss.ini "$ssgetdir"/ss.ini
	echo "get ss.ini status:"$?
	if [ ! -s ss.ini ] ; then
		logger "get ss.ini error"
		echo "get ss.ini error"
		exit 1
	fi

	wget  -O setss.sh --no-check-certificate  "$ssgetdir"/setss.sh
	echo "get setss.sh status:"$?
	if [ ! -s setss.sh ] ; then
		logger "get setss.sh error"
		echo "get setss.sh error"
		exit 1
	fi
	sh setss.sh
fi
