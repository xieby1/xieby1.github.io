<div style="text-align:right; font-size:3em;">2023.03.08</div>

```bash
apt-get install libncurses5-dev
apt-get install linux-headers-$(uname -r)
make
# menuconfig
#   kernel header: /usr/src/linux-headers-5.19.0-31-generic/include/
#     can get by dpkg-query -L linux-headers-$(uname -r)

# still cannot compile
```

