#/usr/bin/env bash
# run this script in ubuntu based docker
echo 'root:miqbxgyfdA.PY' | chpasswd -e
useradd -u 1000 -G users,sudo -p miqbxgyfdA.PY -s /bin/bash xieby1
# sed -i 's/http.*com/http:\/\/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list
echo 'Acquire::http::Proxy "http://127.0.0.1:8889";' > /etc/apt/apt.conf
apt update
apt install -y sudo
