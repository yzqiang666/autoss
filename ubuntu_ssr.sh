
#Ubuntu安装步骤
apt-get install python-pip
apt-get install git

git clone -b  manyuser https://github.com/breakwa11/shadowsocks.git
cd shadowsocks
cat > config.json <<-\EOF
{
    "server": "0.0.0.0",
    "server_port": 8888,
    "local_address": "127.0.0.1",
    "local_port": 1080,
    "password": "yzqyzq",
    "timeout": 120,
    "udp_timeout": 60,
    "method": "rc4-md5",
    "protocol": "auth_sha1_compatible",
    "protocol_param": "",
    "obfs": "http_simple_compatible",
    "obfs_param": "",
    "dns_ipv6": false,
    "connect_verbose_info": 0,
    "redirect": "",
    "fast_open": false
}

EOF
bash initcfg.sh
cd shadowsocks
./run.sh

####结束



