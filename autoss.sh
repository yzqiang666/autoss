cd /tmp
wget -q -O jq --no-check-certificate  https://raw.github.com/yzqiang666/autoss/master/jq
wget -q -O sscfg.sh --no-check-certificate  https://raw.github.com/yzqiang666/autoss/master/sscfg.sh
wget -q -O getss.sh --no-check-certificate  https://raw.github.com/yzqiang666/autoss/master/getss.sh

cp /opt/bin/jq1 jq
#cp /opt/bin/jq /tmp
#cp /opt/bin/sscfg.sh /tmp
#cp /opt/bin/getss.sh /tmp
chmod a+x sscfg.sh
chmod a+x getss.sh
chmod a+x jq
./sscfg.sh

