<div style="text-align:right; font-size:3em;">2020.08.20</div>

**前言**：为什么要想编译32位的x86_64-linux-user，因为想知道[QnA.md#用户态，guest虚存空间>=host虚存空间，guest_base如何工作](QnA.md#用户态，guest虚存空间>=host虚存空间，guest_base如何工作)。

下面是在x86_64位linux (ubuntu20)里编译32位qemu的过程，

```shell
export PKG_CONFIG_LIBDIR /usr/lib/pkgconfig/

# 需要安装参考：https://github.com/Cisco-Talos/pyrebox/issues/41，其内容复制粘贴如下
# apt-get install build-essential zlib1g-dev pkg-config libglib2.0-dev binutils-dev libboost-all-dev autoconf libtool libssl-dev libpixman-1-dev libpython-dev python-pip python-capstone virtualenv
# 我运行时去掉了报错，去掉了不必要的包，将用脚本加上:i386，如下
sudo apt install zlib1g-dev:i386 pkg-config:i386 libglib2.0-dev:i386 libboost-all-dev:i386 libssl-dev:i386 libpixman-1-dev:i386 libpython-dev:i386

# 下面两个configure都可，即把-m32作为cc/cxx的一部分或者作为flags都可
## -m32作为cc/cxx的一部分
./configure --target-list="x86_64-linux-user i386-linux-user" --extra-cflags="-march=i686" --extra-cxxflags="-march=i686" --cpu=i386 --cc="gcc -m32" --cxx="g++ -m32" --disable-werror --enable-debug
## -m32作为flags
./configure --target-list="x86_64-linux-user i386-linux-user" --extra-cflags="-m32" --extra-cxxflags="-m32" --cpu=i386 --disable-werror --enable-debug

make

# 装好后可能需要重启。

# 以下测试都是一定概率能够运行
## hellowordx64，正常输出
## printf打印unsigned long(-1)，正常输出
## printf打印变量的指针，只能打印出32位的数，不正常
```

