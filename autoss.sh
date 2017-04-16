export ssgetdir=export ssgetdir=ftp://ftp:ftp@202.109.226.26/AiCard_02/ftp
ss_internet=`nvram get ss_internet`
ss_enable=`nvram get ss_enable`

if [ "$ss_enable" == "0" ] ; then
 exit 0
fi
wget -O google.txt --continue --no-check-certificate -s -q -T 10 http://www.google.com.hk       
echo "Connect google status: "$?
if  [ ! "$?" == "0" ] ; then

cd /tmp
#sh ss.sh stop                       
#sleep 5   
#wget -q -O jq.tar.gz --no-check-certificate  https://github.com/yzqiang666/autoss/releases/download/jq/jq.tar.gz
#wget -q -O sscfg.sh --no-check-certificate  https://raw.github.com/yzqiang666/autoss/master/sscfg.sh
#wget -q -O getss.sh --no-check-certificate  https://raw.github.com/yzqiang666/autoss/master/getss.sh

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
#wget -q -O jq ftp://ftp:ftp@202.109.226.26/AiCard_02/ftp/jq
#oldpath=$PATH
#export PATH=$oldpath:/tmp


#tar xvzf jq.tar.gz

#cp /opt/bin/jq1 jq
#cp /opt/bin/jq /tmp
#cp /opt/bin/sscfg.sh /tmp
#cp /opt/bin/getss.sh /tmp
#chmod a+x sscfg.sh
#chmod a+x getss.sh
chmod a+x setss.sh
#chmod a+x jq
#./sscfg.sh
./setss.sh
#export PATH=$oldpath
#sh ss.sh start
#/tmp/ss.sh update
fi
