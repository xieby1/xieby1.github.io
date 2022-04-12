<div style="text-align:right; font-size:3em;">2021.04.20</div>

## test中的ok()宏的含义和用法

不满足条件就输出。

<div style="text-align:right; font-size:3em;">2021.01.14</div>

## [ABORT] winegcc的c库和c++库来源

**背景**：
用winemaker能够正常在Linux平台编译windows平台的[bitmap打印程序](https://www.dreamincode.net/forums/topic/261009-bitmap-printing-tutorial-in-c-win32/)。
bitmap打印程序的用到了Windows头文件（commdlg.h和winspool.h）和c++库头文件（fstream）。
Windows头文件和相关的库由WINE提供，分别在`<prefix>/include/wine/`和`<prefix>/lib/wine/`里，**注**：`<prefix>`默认为`/usr/local`，
C++库头文件和库由Linux原生的库提供吗？
我的ycm跳转功能保存C++库头文件缺少，
~~且winedbg显示main.cpp的源代码行数比实际执行函数大17~~（我clang-format了main.cpp）。

<div style="text-align:right; font-size:3em;">2021.01.11</div>

## [ABORT] 为什么要把通用gdi函数包装进wineps.drv

比如GetTextExtentExPoint(W/A)会去调用实际由wineps.drv提供的函数。

<div style="text-align:right; font-size:3em;">2020.10.09</div>

## WINEDEBUG channel有哪些

参考[Debug Channels](https://wiki.winehq.org/Debug_Channels)，

```shell
grep -r --include='*.c' --include='*.h' 'WINE_\(DEFAULT\|DECLARE\)_DEBUG_CHANNEL' dlls/ programs/
```

或者更漂亮的列表，

```bash
for modname in $(find dlls/ programs/ -mindepth 1 -type d | sort); do
  echo $(grep -rE --include='*.[ch]' '^WINE_(DEFAULT|DECLARE)_DEBUG_CHANNEL' $modname \
         | awk -F "[()]" '{print $2}' | sort | uniq) \
         | awk -v modname=$modname '{if (NF>0) printf("%-*s%s\n", 26, modname": ", $0)}';
done
```

<div style="text-align:right; font-size:3em;">2020.09.01</div>

## WINE如何打印多进程的信息的

**详细**：WINE提供的`TRACE`, `WARN`, `FIXME`, `ERR`这些宏，能够把多进程输出到stderr的信息都显示到当前运行wine的终端上。如何做到的？

**结论**：重定向进程的`fd/2`。

2021.05.18: 参考`man 7 credentials`有提到termios的TOSTOP控制终端是否允许后台任务输出到终端。

仅仅只看了`ERR`的源码，最终还是调用的`dlls/ntdll/unix/debug.c: __wine_dbg_output: write`到2（stderr）的系统调用。

合理的猜测是fd2被重定向到了当前终端接受信息的文件。

做个简单的实验会发现，直接在终端运行的进程的`fd/1`, `fd/2`, `fd/3`都映射到的`/dev/pts/6`。没有连接到终端的那些进程的stderr（即/proc/xxx/fd/2）也被映射到了`/dev/pts/6`。也就是说`/dev/pts/6`就是终端用来接受信息的文件。

相关测试见test仓库：`test/lib/fd.f/redirect_stderr_in_multi-proc*`

DONE：

* 但是为什么直接`fprintf(stderr, ...)`就无效呢？应该是WINE的`ERR`做了处理！大概是因为是windows程序（我改的是`programs/wineboot/wineboot.c`）？在wineserver里fprintf stderr可以！
* `/dev/pts/NUM`的原理。
  * 参考[What is stored in /dev/pts files and can we open them?](https://unix.stackexchange.com/questions/93531/what-is-stored-in-dev-pts-files-and-can-we-open-them)。

## WINE的unix_funcs里的函数的定义

**详细**：在`dll/ntdll/unix/loader.c`里**定义**了unix_funcs，其中这些函数定义有两份，一份在`dll/ntdll/thread.c`里，一份在`dlls/ntdll/unix/`的各个对应的文件里。

**结论**：这个应该是YouCompleteMe跳转错误。unix_funcs里的函数的定义在`dll/ntdll/unix/`里。

| 源码路径          | 编译出的so     | unix_funcs类型                        |
| ----------------- | -------------- | ------------------------------------- |
| `dll/ntdll/unix/` | `ntdll.so`     | `static struct unix_funcs unix_funcs` |
| `dll/ntdll/`      | `ntdll.dll.so` | `const struct unix_funcs *unix_funcs` |

即`ntdll.dll.so`所需的`unix_funcs`函数是`ntdll.so`提供的。运行时，`ntdll.so`通过动态获取`ntdll.dll.so`的函数`__wine_set_unix_funcs`来向`ntdll.dll.so`提供`unix_funcs`。

所以`unix_funcs`包含的众多函数的定义应该在`ntdll.so`里，即对应源码在`dll/ntdll/unix/`里。

<div style="text-align:right; font-size:3em;">2020.8.10前</div>

## WINE如何捕获Windows所有的调用

首先Windows的系统调用可以通过调用dll提供函数来实现间接的调用系统调用，这无非就是`call`指令，在加载通过got和plt便能实现；然后Windows里能不能直接用`int`或`syscall`之类的指令，调用系统调用？答案是能，详细见[Windows应用程序里存在`int`和`syscall`之类的系统调用指令吗](#Windows应用程序里存在`int`和`syscall`之类的系统调用指令吗)。

**结论**：目前WINE还不能不会直接调用NT内核的系统调用。

绘制下图以明晰WINE涉及的各类调用，

![wine_arch-formatted](pictures/wine_arch-formatted.svg)

<div style="text-align:right; font-size:3em;">2020.8.10</div>

## Windows应用程序里存在`int`和`syscall`之类的系统调用指令吗

**结论**：不是不能存在，而是不稳定，没有必要存在。但是现在的windows应用程序中有逐渐变多的趋势。

**参考1**：[System Calls in windows & Native API?](https://stackoverflow.com/questions/2489889/system-calls-in-windows-native-api) 简单地说Windows的系统调用的各个属性一直在变，不像linux那样十分稳定。通过NTDLL.dll来提供的函数来提供稳定的系统调用。

**参考2**：上述问答Stewart回答补充里提到的Windows 2000通过INT指令进行系统调用的方法[The system call dispatcher on x86](http://www.nynaeve.net/?p=48)，是`int 0x2e`！

**参考3**：LWN June 25, 2020的关于WINE的文章[Emulating Windows system calls in Linux](https://lwn.net/Articles/824380/)，提到了在Linux中添加特性——在指定内存范围能/不能执行系统调用[[PATCH RFC] seccomp: Implement syscall isolation based on memory areas](https://lwn.net/ml/linux-kernel/20200530055953.817666-1-krisman@collabora.com/)，这是因为*Modern Windows applications are executing system call instructions directly from the application's code without going through the WinAPI.*

**参考4**：参考3的文章的续篇，[Emulating Windows system calls, take 2](https://lwn.net/Articles/826313/)

<div style="text-align:right; font-size:3em;">2020.08.13</div>

## [ABORT] WINE启动过程的运行win进程的作用

包括：wineserver，wineboot.exe，services.exe，plugplay.exe，winedevice.exe

* wineserver：wine模拟的win内核，参考qemu-wine-logs.md 2020.7.14的记录
* wineboot.exe：初始化wineprefix默认即~/.wine，其他功能为深究，参考`wineboot.exe -h`

## [ABORT] WINE的view

比如`dlls/ntdll/unix/virtual.c: map_view`函数。

## winedbg如何对windows程序进行Debug的

2021.1.4:

在Windows里的两个有代表性的工具windbg和gdb，

微软的工具链（windbg）使用的debug信息是独立的pdb文件，

GNU的工具链（gdb）使用的debug信息是附加在PE文件中的，格式叫dwarf。

二者互不通用，不过有转换工具，但不一定完美，比如[cv2pdb](https://github.com/rainers/cv2pdb)。

winedbg从逻辑上讲是一边用wine运行windows的程序，一边用gdb的debug信息即可。

## WINE的多进程同一终端同步输出运行信息如何实现

诸如`ERR()`这些宏函数。多进程软件里直接printf不会除了霸占了终端的那个进程，其他进程都没法输出到终端（有待测试）？
