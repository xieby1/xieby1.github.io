在龙芯平台，用**修改过的qemu-i386**运行**原版wine**，在此基础上运行32位windows程序。

## wine

### 源码

官方版wine-5.0。[官方git仓库](git://source.winehq.org/git/wine.git)

### 编译(**在x86 linux电脑上进行**)

`configure && make && make install`即可，不过为了可以方便的将编译好的wine复制到龙芯机器上可以改变默认安装目录，例如放在`~/wine_install/`里，

```shell
mkdir ~/wine_install
configure --prefix=~/wine_install/
make
make install
```

### 依赖库

将wine所依赖的所有x86-linux的库通过`ldd`命令整理出来。可以使用脚本[ldd-grep.sh](https://github.com/xieby1/scripts/blob/main/ldd-grep.sh)。例如把所有依赖库放入`~/x86root/`文件夹，

```shell
mkdir ~/x86root
ldd-grep.sh -o ~/x86root ~/wine_install
```

最后将wine和wine的依赖库复制到龙芯电脑里，即`~/wine_install/`和`~/x86root/`这两个文件夹。

## qemu

### 源码

以qemu v5.0.0为基础，修改后的版本位于实验室的代码仓库[qemu](http://foxsen.3322.org:33336/xieby1/qemu)的wine-fix-2分支。

### 编译(**在龙芯上电脑上进行**)

```shell
configure --target-list=i386-linux-user --disable-werror
make
make install
```

### x86运行环境

让所有x86程序默认用qemu运行，假设qemu-i386装在`/usr/local/bin/qemu-i386`里，

```shell
su
echo ':i386:M::\x7fELF\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x03:\xff\xff\xff\xff\xff\xfe\xfe\xff\xff\xff\xff\xff\xff\xff\xff\xff\xfa\xff\xff:/usr/local/bin/qemu-i386:' >/proc/sys/fs/binfmt_misc/register
exit
```

让qemu-i386的根目录变为存放x86依赖库的目录`~/x86root`，设置环境变量QEMU_LD_PREFIX（或者qemu运行时参数-L）为`~/x86root`，例如，

```shell
export QEMU_LD_PREFIX="~/x86root"
```

## 运行windows程序

使用命令`~/wine_install/bin/wine <windows-program>`即可，例如

```shell
~/wine_install/bin/wine winemine # 扫雷
~/wine_install/bin/wine cmd # windows cmd
```

**注**：wine创建的windows c盘位于`~/.wine/drive_c/`。

## 相关笔记

参考[龙芯实验室二进制翻译组的笔记仓库关于wine的部分](http://foxsen.3322.org:33336/loongsonlab/notes/blob/master/README.md#wine)。