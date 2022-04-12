因为在树莓派上安装Box86遇到问题，看到下文，才发现了debootstrap，

[Install Box86 on Arm64 - General chit chat - Armbian forum](https://forum.armbian.com/topic/16584-install-box86-on-arm64/)

<div style="text-align:right; font-size:3em;">2021.04.06</div>

* debootstrap
  * pbuilder

## 关于版本名字（codename）

debian codename来源，https://wiki.debian.org/DebianReleases#Codenames

> Releases of the Debian distribution have both traditional version numbers and codenames based on characters from the Pixar/Disney movie "Toy Story" (1995). Sid, as you may recall, was the evil neighbor kid who broke all the toys. Additionally, the codename for the Experimental repository, RC-Buggy, was Andy's toy car, and is a pun on 'Release Critical' and 'Remote Control.'

[Linux Debian codenames](https://unix.stackexchange.com/questions/222394/linux-debian-codenames)

> special codename [`sid`](http://pixar.wikia.com/wiki/Sid) ([**S**till **I**n **D**evelopment](https://www.debian.org/releases/sid/)) which is symbolic link to codename which is currently *unstable*

这个问题的一个回答很风趣的讨论到Debian不用担心名字用完，到那个时候的可能Debian已经不适合那时候的计算设备了。

获取版本名字的方法，[How to get Debian codename without lsb-release](https://unix.stackexchange.com/questions/180776/how-to-get-debian-codename-without-lsb-release)

* `lsb_release -c`
* 查看文件`/etc/os-release`（可以当作环境变量导入shell）

## debootstrap

通过看网上的例子，分析出来的[是否有比Arch更难安装和运行的Linux发行版？](https://www.zhihu.com/question/406210771/answer/1341626871)

SUITE可以直接写ubuntu的codename
MIRROR写到含有ubuntu的dists/的路径
比如

* https://mirror.tuna.tsinghua.edu.cn/ubuntu/
* https://mirrors.aliyun.com/ubuntu/

SUITE可以直接写ubuntu的codename
MIRROR写到含有ubuntu的dists/的路径
比如

* https://mirror.tuna.tsinghua.edu.cn/ubuntu/
* https://mirrors.aliyun.com/ubuntu/

### 安装例子

```shell
# ubuntu 16.04 i386
sudo debootstrap --arch=i386 xenial ubuntu1604-i386/ https://mirror.tuna.tsinghua.edu.cn/ubuntu/
# ubuntu 20.04 armhf (arm32), add at 2021.04.09
sudo debootstrap --arch=armhf focal u20-armhf/ https://mirror.tuna.tsinghua.edu.cn/ubuntu-ports/
```

[mount dev, proc, sys in a chroot environment?](https://superuser.com/questions/165116/mount-dev-proc-sys-in-a-chroot-environment)

<div style="text-align:right; font-size:3em;">2021.04.07</div>

看bashrc里有debian_chroot觉得有用，在网上找到[What is $debian_chroot in .bashrc?](https://unix.stackexchange.com/questions/3171/what-is-debian-chroot-in-bashrc)，发现似乎很有趣的chroot包装——schroot！

## schroot

使用例子

```shell
sudo schroot -c <chroot-name> -u <user>
```

参考`man schroot.conf`编辑`/etc/schroot/chroot.d/<某个文件>`即可，例如

```ini
# /etc/schroot/chroot.d/compiler
[u16-32]
description=ubuntu 16.04 (xenial) on i386
type=directory
directory=/home/ubuntu1604-i386

[u20-32]
description=ubuntu 20.04 (focal) on i386
type=directory
directory=/home/ubuntu2004-i386
```

<div style="text-align:right; font-size:3em;">2021.04.09</div>

https://kb8ojh.net/elb/musings/jailing_X_with_sound.html

<div style="text-align:right; font-size:3em;">2021.04.10</div>

* man xauth
  * man X

<div style="text-align:right; font-size:3em;">2021.04.11</div>

### 装ARM的chroot

debootstrap创建ARM目录，要加`--foreign`，

```shell
sudo debootstrap --foreign --arch=arm64 focal u20-arm64/ https://mirror.tuna.tsinghua.edu.cn/ubuntu-ports/
# 进入chroot后
/debootstrap/debootstrap --second-stage
```

静态编译qemu，

静态链接总是失败，file发现仍然是动态链接？https://stackoverflow.com/questions/2725255/create-statically-linked-binary-that-uses-getaddrinfo

apt install qemu-user-static就可以。