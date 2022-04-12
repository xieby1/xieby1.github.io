<div style="text-align:right; font-size:3em;">2021.09.28</div>

若装好LA的alpine网络不行，则重新执行一下setup-alpine配置成dhpc。



<div style="text-align:right; font-size:3em;">2021.08.27</div>

## 解决替换成ubuntu的内核无法联网

ubuntu的内核中没有内置e1000网卡驱动，
查看`/usr/lib/modules/<VERSION>/modules.builtin`。

e1000模块在内核驱动安装的目录`/usr/lib/modules/<VERSION>/kernel/`中
的`drivers/net/ethernet/intel/e1000/e1000.ko`。

内核模块安装目录位于哪里，用`make -Bn modules_install`可知。

<div style="text-align:right; font-size:3em;">2021.08.18</div>

## module编译环境

和ubuntu不一样`apt-get install build-essential linux-headers-$(uname -r)`

参考[How to build kernel modules in Alpine 3.12](https://unix.stackexchange.com/questions/606073/how-to-build-kernel-modules-in-alpine-3-12)

```
apk add alpine-sdk linux-lts-dev
```

2021.8.28: alpine的apk仓库似乎只会保留最新的alpine-sdk和linux-lts-dev，所以需要升级内核

```shell
apk update
apk upgrade
```

## ssh root

参考[Enable Root Login via SSH In Ubuntu](https://www.liquidweb.com/kb/enable-root-login-via-ssh/#:~:text=Enable%20root%20login%20over%20SSH%201%20Login%20to,server%3A%20systemctl%20restart%20sshd%20or%20service%20sshd%20restart)

```shell
vim /etc/ssh/sshd_config
# 修改PermitRootLogin yes
# 修改PermitEmptyPasswords yes

# systemctl restart sshd
service sshd restart
```

<div style="text-align:right; font-size:3em;">2021.08.17</div>

## QEMU nographic不显示login

如下qemu启动alpine，只显示输出启动过程的内容，登录的内容不显示。

```shell
qemu-system-x86_64 \
    -enable-kvm \
    -hda ./alpine.img \
    -kernel ./vmlinuz-5.4.0-81-generic \
    -append "console=ttyS0 root=/dev/sda3" \
    -nographic \
    -m 512M \
```

参考[alpine wiki: Enable Serial Console on Boot](https://wiki.alpinelinux.org/wiki/Enable_Serial_Console_on_Boot)

alpine在进入login console时会在`/etc/inittab`脚本的指导下，默认使用tty1。
尽管在kernel参数中添加了`console=ttyS0`，在进入login阶段时无法正常显示。
解除`/etc/inittab`中ttyS0所在行的注释即可，结果如下，

```
# Put a getty on the serial port
ttyS0::respawn:/sbin/getty -L ttyS0 115200 vt100
```

