rm ss.ini 2>/dev/null

# get ss info from arukas
wget -O ss.txt -q https://e39ed54e-18ee-4eae-b372-41b4e05721f3:eoZ9cCkTpM0d6Rb7BEtXl5luBcqZyVeiNLZuKUxGjgOFnB1tqTChz3Wr8JKS2kJY@app.arukas.io/api/containers

# from ss.txt to ss.ini
getss.sh token:secret adoring-yalow-3951.arukascloud.io 8989 yzqyzq rc4-md5 auth_sha1 http_simple >>ss.ini
getss.sh token:secret dreamy-stonebraker-6002.arukascloud.io 8888 yzqyzq rc4-md5 auth_sha1 http_simple >>ss.ini
getss.sh token:secret silly-keller-4692.arukascloud.io 8080 yzqyzq rc4-md5 >>ss.ini

#rnd=`awk 'BEGIN{srand();print int(rand()*10)+1 }'`
#echo $rnd >>ss.ini
