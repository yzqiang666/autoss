while getopts "a:o:O:g:G:s:p:b:l:k:m:f:h:v:" arg; do
case "$arg" in
a)
a="$OPTARG"
;;
o)
obfs="$OPTARG"
;;
O)
protocol="$OPTARG"
;;
g)
obfs_param="$OPTARG"
[ "$a" = 1 ] && obfs_param="`nvram get $OPTARG`"
;;
G)
protocol_param="$OPTARG"
[ "$a" = 2 ] && protocol_param="`nvram get $OPTARG`"
;;
s)
server="$OPTARG"
;;
p)
server_port="$OPTARG"
;;
b)
local_address="$OPTARG"
;;
l)
local_port="$OPTARG"
;;
k)
password="$OPTARG"
[ "$a" = 3 ] && password="`nvram get $OPTARG`"
;;
m)
method="$OPTARG"
;;
f)
config_file="$OPTARG"
;;
h)
obfs_plugin="`nvram get $OPTARG`"
;;
v)
plugin_c="`nvram get $OPTARG`"
;;
esac
done
cat > "$config_file" <<-SSJSON
{
"server": "$server",
"server_port": "$server_port",
"local_address": "$local_address",
"local_port": "$local_port",
"password": "$password",
"timeout": "180",
"method": "$method",
"protocol": "$protocol",
"protocol_param": "$protocol_param",
"obfs": "$obfs",
"obfs_param": "$obfs_param",
"plugin": "$plugin_c",
"plugin_opts": "$obfs_plugin"
}
SSJSON

