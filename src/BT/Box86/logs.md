<div style="text-align:right; font-size:3em;">2021.04.05</div>

## 安装

按照指南安装后才发现运行不了，直接表现是

```shell
-bash: /usr/local/bin/box86: No such file or directory
```

实际原因是没有找到动态链接器`/lib/ld-linux-armhf.so.3`。

需要chroot进入进入32位环境才行。在apt包`libc6-armhf-cross`里，存放在/usr/arm-linux-gnueabihf。

看到https://forum.armbian.com/topic/16584-install-box86-on-arm64/用debootstrap来搞chroot（突然发现似乎可以用这个来做32位编译环境！）

下次接着来继续搞吧。

<div style="text-align:right; font-size:3em;">2021.04.09</div>

使用debootstrap+schroot成功运行wine helloworld-win.exe。

<div style="text-align:right; font-size:3em;">2021.04.09</div>

```shell
# Wine提示安装
sudo apt install libpng16-16
sudo apt install libfreetype6

# 解决winex11.drv.so找不到的问题
sudo apt install libx11-6 libxext6

# 安装X client
sudo apt install xauth
```

在chroot里用X11可能可以参考：https://kb8ojh.net/elb/musings/jailing_X_with_sound.html

<div style="text-align:right; font-size:3em;">2021.04.12</div>

现在原生环境运行一下图形程序，比如gedit，然后该终端的$DISPLAY有效。

* 可以正常运行恶魔之星（有点卡）

* photoshop8.0安装程序无法运行，原生WINE可以正常运行
  * 打包`Program Files/Adobe/Photoshop CS`进入界面会报错
  * 因为安装ps涉及了很多目录，尝试samba将~/.wine32/分享给树莓派，测试ps，仍然运行不起来
    * samba server搭建：https://ubuntu.com/tutorials/install-and-configure-samba
    * samba client连接：
      * https://tecadmin.net/mounting-samba-share-on-ubuntu/#:~:text=%20Mounting%20Samba%20Share%20on%20Unix%20and%20Linux,using%20dot%20%28.%29%20for%20security%20purpose.%20More%20
      * https://askubuntu.com/questions/890579/cifs-mounting-all-files-as-root-owner
      * sudo mount -t cifs -o rw,vers=3.0,username=xieby1,password=wjxby,uid=xieby1,gid=xieby1 //192.168.1.103/wine32share .wine32_y50_70/
* 