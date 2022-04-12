<div style="text-align:right; font-size:3em;">2021.05.11</div>

## [ABORT] NtCurrentTeb()如何访问TLS

```c
static FORCEINLINE struct _TEB * WINAPI NtCurrentTeb(void)
{
    struct _TEB *teb;
    __asm__(".byte 0x64\n\tmovl (0x18),%0" : "=r" (teb));
    return teb;
}
```

没有显式的使用fs段寄存器。原理在于`.byte 0x64`就是使用`fs`的指令前缀。前缀参考http://www.c-jump.com/CIS77/CPU/x86/X77_0240_prefix.htm。

即

```c
".byte 0x64\n\tmovl (0x18),%0"
```

等价于

```c
"movl %fs:(0x18),%0"
```

但为什么不直接写`fs:`呢？

`./arch/x86/include/asm/segment.h`有提到Wine使用`fs:`。

## [ABORT] 服务的入口

advapi32_test.exe有main函数，但是源码里没有。源码有`service_main(DWORD argc, char **argv)`十分像main。

<div style="text-align:right; font-size:3em;">2021.04.20</div>

## 如何安装服务

**起因**：qemu-i386 (x86-64版) wine winetest/advapi32_test.exe service失败。所以来学习Windows的服务（service）。

* 服务管理器（Service Manager）位于WinXP->开始->管理工具->服务。
* 服务的注册表路径`HKEY_LOCAL_MACHINE\ SYSTEM\ CurrentControlSet\ Services\`。
* advapi32_test.exe源码`wine/dlls/advapi32/tests/service.c`。

创建服务使用[CreateServiceA函数](https://docs.microsoft.com/en-us/windows/win32/api/winsvc/nf-winsvc-createservicea):

```c++
SC_HANDLE CreateServiceA(
  SC_HANDLE hSCManager, // Service Control Manager
  LPCSTR    lpServiceName, // 注册表的文件夹名
  LPCSTR    lpDisplayName, // 对应DisplayName，描述
  DWORD     dwDesiredAccess,
  DWORD     dwServiceType,
  DWORD     dwStartType,
  DWORD     dwErrorControl,
  LPCSTR    lpBinaryPathName,
  LPCSTR    lpLoadOrderGroup,
  LPDWORD   lpdwTagId,
  LPCSTR    lpDependencies,
  LPCSTR    lpServiceStartName,
  LPCSTR    lpPassword
);
```

ChangeServiceConfigA

<div style="text-align:right; font-size:3em;">2020.12.14</div>

## Windows动态链接中为什么需要.lib

**起因**：

问题起源于《Windows核心编程（第5版）》19.2纵观全局。动态链接库在编译时需要.lib和.h、运行时需要.dll。.lib列出了所有被导出的函数和变量的符号名。

windows调用动态链接库编译时需要.h、运行时需要.dll我能理解，但是为什么编译时还需要.lib暴露出函数和变量的符号名，这点让我十分不理解。

**简答**：可以不用.lib，比如用gnu的ld进行链接。windows的链接器其实做的都是静态链接，“动态链接”的是动态加载动态执行的跳板函数。

**探索**：

[How to See the Contents of Windows library (*.lib)](https://stackoverflow.com/questions/305287/how-to-see-the-contents-of-windows-library-lib)

提到了windows里的.lib有两种（参考官方文档[.Lib Files as Linker Input](https://docs.microsoft.com/en-us/cpp/build/reference/dot-lib-files-as-linker-input?view=msvc-160)），

1. static library，用`dumpbin /symbols`查看
2. import library，用`dumpbin /exports`查看

在linux里用`ar t xxx.lib`和在windows里用`lib /list xxx.lib`等价，只显示obj文件不显示符号，stackoverflow的原文为*will (only) show the obj files; it will not show the functions and data in the obj files.*

**解决**：

[Why are LIB files beasts of such a duplicitous nature?](https://stackoverflow.com/questions/6421693/why-are-lib-files-beasts-of-such-a-duplicitous-nature)，这个提问者有和我相同的疑惑，他自己做了很多调研，回答的很不错的，

* 可以不用.lib文件进行动态链接，参考gnu的ld的win32的说明，
  * BTW, [MinGW/GCC supports linking directly against the DLL](http://sources.redhat.com/binutils/docs-2.21/ld/WIN32.html): "The cygwin/mingw ports of ld support the direct linking, including data symbols, to a dll without the usage of any import libraries. This is much faster and uses much less memory than does the traditional import library method, especially when linking large libraries or applications. ... Linking directly to a dll uses no extra command-line switches other than `-L' and `-l' ... one might justifiably wonder why import libraries are used at all. There are three reasons: ..." – [Lumi](https://stackoverflow.com/users/269126/lumi) [Jul 2 '11 at 19:00](https://stackoverflow.com/questions/6421693/why-are-lib-files-beasts-of-such-a-duplicitous-nature#comment7730143_6421693)
* 静态链接的.lib和动态链接的.lib是一个文件类型，其实Windows编译器的动态链接就是静态链接上了跳板函数，
  * Hmm, but DLLs are also libraries, which did not hinder MS from endowing them with a dedicated  extension. But, I hear you say, they are different beasts. Well, but what then about **static** libraries (containing code) and **import** libraries (containing pointers to code)? What's so similar about them that it was practical to give them the same name? And why are import libraries needed for code to be bound against DLLs when Linux does not require any? Maybe these questions appear stupid when you've known that stuff for ages, but if you're new to it, I think you have reason to wonder. – [Lumi](https://stackoverflow.com/users/269126/lumi) [Jun 21 '11 at 17:29](https://stackoverflow.com/questions/6421693/why-are-lib-files-beasts-of-such-a-duplicitous-nature#comment7544087_6427158)
  * That's what I'm talking about, static and import libraries. Import libraries aren't anything magical, certainly not "pointers to code", they contain normal code calling `LoadLibrary` and `GetProcAddress` to load the function pointers for you. – [Blindy](https://stackoverflow.com/users/108796/blindy) [Jun 21 '11 at 18:49](https://stackoverflow.com/questions/6421693/why-are-lib-files-beasts-of-such-a-duplicitous-nature#comment7545442_6427158)

<div style="text-align:right; font-size:3em;">2020.10.26</div>

## [ABORT] 如何判断程序是否需要运行在内核空间

这里的程序指exe, dll。

2020.11.30

dll：sys结尾的是内核的，dll是用户空间的。

## windows xp的编译系统

### [ABORT] 编译内核的编译系统

makefil0是啥，makefile.inc是什么？

2020.10.27

### [ABORT] 编译程序的编译系统

这里留简介明了的答案。之前的内容迁移到了[logs.md](driver/logs.md)的2020.10.26编译程序。

## DLL之间的依赖关系

通过`readpe`看两个有依赖关系的dll（比如`gdi32.dll`和`winspool.dll`）导入/导出的函数并没有发现依赖，莫否还有其他机制调用？

* 莫非是RPC（Remote Procedure Call）？有看到导入`RPCRT4.dll`库的dll（比如`spoolsv.exe`），Windows平台RPC是怎么实现的？
* gdi32full.dll导入的`api-ms-win-core-libraryloader-l1-2`莫非是动态加载某些库？

2020.12.14：

winxp的winspool.drv可以看到gdi32.dll，win10的winspool.drv看不到gdi32.dll。
不过win10的版本里出现了`api-ms-win-core-delayload-l1-1-0.dll`和`api-ms-win-core-libraryloader-l1-2-1.dll`，看名字应该就是动态加载吧。
详细参考《Windows核心编程（第5章）》20.1DLL模块的显示载入和符号链接。
用的就是`LoadLibrary`这个函数。