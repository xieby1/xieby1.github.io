本文档和[QEMU/qemu-wine.md](../QEMU/qemu-wine.md)共同记录用qemu用户态运行wine的笔记。本文档记录wine的部分。主要参考wine版本5.12。

<div style="text-align:right; font-size:3em;">2020.7.7</div>

## 编译

32位需要装32位的依赖，大概格式如下：

```shell
sudo apt install libx11-dev:i386
sudo apt install libfreetype-dev:i386
```

2020.9.23

安装mono，参考官网[winehq-mono](https://wiki.winehq.org/Mono)，

下载对应版本msi

```shell
wine uninstaller # remove "Wine Mono Runtime" and "Wine Mono Windows Support"
wine msiexec /i path/to/wine-mono.msi
```

## 环境

### 动态链接库的配置

运行的参数：

```shell
qemu-i386 -L X86_ROOT_PATH ... 
```

**注0**：在x86 linux上运行动态链接的程序完全没有问题。

**注1**：v4.1.0版本的qemu在运行动态链接的二进制文件会报错segment fault。v5.0.0版本可以运行`helloworld`，但是`execle`还有问题。因为execle没有调用qemu而出错。

**注2**：用`ldd`指令将程序所需的动态链接库列出，然后用脚本将这些库复制到龙芯电脑里的`X86_ROOT_PATH`。`X86_ROOT_PATH`等于虚拟的一个`/`即里边需要有`lib`, `lib32`, `lib64`等目录。

### binfmt的配置（自动用qemu执行x86-linux程序）

修改binfmt_misc让i386程序自动由qemu-i386运行（包括exec系统调用），参考：

* https://forum.winehq.org/viewtopic.php?f=2&t=17701
* https://www.kernel.org/doc/html/latest/admin-guide/binfmt-misc.html

总结来说就是，

```shell
echo ':i386:M::\x7fELF\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x03:\xff\xff\xff\xff\xff\xfe\xfe\xff\xff\xff\xff\xff\xff\xff\xff\xff\xfa\xff\xff:/usr/bin/qemu-i386:' >/proc/sys/fs/binfmt_misc/register
```

即可默认用qemu-i386去运行魔数为上面那一长串的程序。添加到自动启动脚本比日`rc.local`就可以开机自动添加。

<div style="text-align:right; font-size:3em;">2020.7.8</div>

## Debug的准备

### gdb符号信息

动态链接库的符号信息需要手动让gdb读取，需要知道动态链接库被加载到guest程序的内存地址。暂时还没找如何输出qemu运行的guest程序的内存maps，目前想到办法就是用qemu的内存maps地址减去`guest_base`得到guest的内存maps。

先找出`guest_base`，由qemu进程的`/proc/xxx/maps`可以知道guest的内存分布。

```shell
(gdb) add-symbol-file libs/wine/libwine.so.1.0 -o 0xff630000
```

<div style="text-align:right; font-size:3em;">2020.7.9</div>


诸多动态库的位置是固定的！https://wiki.winehq.org/Debugging_Hints，根据我的观察有如下

|                                                  | mips-qemu-i386    | x86                 | Extra tips                                                   |
| ------------------------------------------------ | ----------------- | ------------------- | ------------------------------------------------------------ |
| dlls/ntdll/ ntdll.so                             | FF35C000-FF3D4000 |                     |                                                              |
| dlls/ntdll/ ntdll.so                             | FF35C000-FF3D4000 | F7B72000-F7BE9000   | 第二次执行wine                                               |
| libs/wine/ libwine.so.1.0                        | FF630000-FF7A8000 |                     | 应该是属于Wine DLL，上面的网页说的Wine DLL从80000000开始往下分配 |
| dlls/ntdll/ ntdll.dll.so                         | 332C000           | 无offset (7bc2b050) | 在x86里add-symbol-file dlls/ntdll/ntdll.dll.so 0x7bc2b050即可添加符号 在mips-qemu-i386里add-symbol-file dlls/ntdll/ntdll.dll.so -o 0x332C000即可添加符号 |
| dlls/kernel32/ kernel32.dll.so                   | 31FC000           |                     | 采用`dlopen`打开可能每次不一样，但是目前看起来是一样的。`dlopen`打开/proc/XXX/maps里没有？什么情况下才会在/proc/XXX/maps里有？🤔 |
| programs/wineboot/ wineboot.exe.so               | 7E6EC000          |                     | 入口：mainCRTStartup                                         |
| programs/winemenubuilder/ winemenubuilder.exe.so | 7E6DC000          |                     | 入口：__wine_spec_exe_wentry@22059                           |

### WinNT内核相关资料

在找wine的err code的含义时在wine wiki [Developer Hints](https://wiki.winehq.org/Developer_Hints#Debug_messages)里找到了有趣的东西，

- Win32 API documentation on MSDN: http://msdn.microsoft.com/
- Analyse by Geoff Chappell: http://www.geoffchappell.com/
- http://www.sonic.net/~undoc/bookstore.html
- ~~http://www.geocities.com/SiliconValley/4942/~~
- Undocumented Windows 2000 Secrets : ~~http://undocumented.rawol.com/~~
- In 1993 Dr. Dobbs Journal published a column called "Undocumented Corner".
- http://msdn2.microsoft.com/en-us/library/cc230273.aspx - Windows Data Types

### Wine提供的debug信息

可以通过设置环境变量来输出wine的trace，参考https://wiki.winehq.org/FAQ#How_can_I_get_a_debugging_log_.28a.k.a._terminal_output.29.3F

```shell
WINEDEBUG=+service wine your_program.exe >> /tmp/output.txt 2>&1 
```

[Debug Channels](https://wiki.winehq.org/Debug_Channels)的用法！可以输出wine运行过程的诸多信息！

<div style="text-align:right; font-size:3em;">2020.7.10</div>

### qemu调试多进程gdb端口占用

通过在wine里添加`stdlib.h`里的`setenv/unsetenv`函数，来控制各个wine进程是否开启qemu的gdb端口。
