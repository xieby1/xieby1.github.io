<div style="text-align:right; font-size:3em;">2021.04.11</div>

```shell
apt install musl musl-tools musl-dev
```

musl-gcc的原理还不太清楚，不知道会不会用glibc的inlcude头文件。musl的include头文件（/usr/include/x86_64-linux-musl）里没有futex.h，所以没办法编译qemu。

看musl源码也没有futex.h。