
ss_internet=`nvram get ss_internet`
ss_enable=`nvram get ss_enable`

if [ "$ss_enable" == "00" ] ; then
logger  "SS is disable"
elif [ "$ss_internet" == "11" ]; then
logger "SS Status is working"
else

cd /tmp
#wget -q -O jq.tar.gz --no-check-certificate  https://github.com/yzqiang666/autoss/releases/download/jq/jq.tar.gz
#wget -q -O sscfg.sh --no-check-certificate  https://raw.github.com/yzqiang666/autoss/master/sscfg.sh
#wget -q -O getss.sh --no-check-certificate  https://raw.github.com/yzqiang666/autoss/master/getss.sh

wget -q -O ss.ini ftp://ftp:ftp@202.109.226.26/AiCard_02/ftp/ss.ini
wget -q -O setss.sh --no-check-certificate  https://raw.github.com/yzqiang666/autoss/master/setss.sh
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

fi


