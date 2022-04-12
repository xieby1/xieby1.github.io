<div style="font-size: 3em; text-align: right;">2019.9.9</div>
# 背景

目前龙芯电脑能否胜任地方政府办公，目前两个关键问题是，

1. 能不能运行IE；
2. 能不能用打印机。

第1个问题归结起来是微软的系统库的问题，Wine大概能很好的解决？第2个问题归结起来是驱动的问题，Wine能否解决呢？

# 着手调研

因为调研Wine的时候观察到存在名叫“winedevice.exe”的进程，所以第一反应是Wine应该在设备驱动上有做出工作的。所以想着就从这个“winedevice.exe”着手吧。首先在wine源代码根目录下搜索带device的文件，

```bash
find . -name "*device*"
```

名字带有device的文件分布在，

* programs/winedevice/
* server/
* dlls/好几个文件夹/
* include/

看了这些还是没头绪。按照`programs/winedevice/device.c`（winedevice.exe的源码）开头的注释“Service process to load a kernel driver”，感觉winedevice.exe应该是个wine写的windows的服务程序，是比较高层次的对设备的抽象。

[Wine官方手册-Multimedia](https://wiki.winehq.org/Wine_Developer's_Guide/Wine_and_Multimedia)虽然有讲到驱动，不过都是声音画面设备的驱动。

<div style="font-size: 3em; text-align: right;">2019.9.10</div>
## Windows和Linux设备驱动的异同

想看看Windows和Linux对设备驱动不同的处理方式，找到[Linux vs. Windows device driver model: architecture, APIs and build environment comparison](http://xmodulo.com/linux-vs-windows-device-driver-model.html)这篇文章，在Device Driver APIs这篇提到了内核的`module_init`函数，索性去用grep搜索了一下Wine的源码，没找到。去网上找到了`init_module`于是在试试这个函数，找到了！在`dlls/kernel32/module.c`里。好像没什么。

搜索`DriverObject`，看到了有趣的文件，

* `include/ddk/wdm.h`这个应该是Windows Device Model定义的文件，
* 还有很多调用了`DriverObject`的文件。

## [Windows驱动编程教程](https://docs.microsoft.com/en-us/windows-hardware/drivers/gettingstarted/)

开始看之前，想要搞明白的事，

1. kernel只是提供一个driver的API，那实际的driver的源码在哪里？
2. 程序是如何知道当前系统是否存在某个driver的？若有，程序如何知道这个driver的调用方式？

### [什么是驱动](https://docs.microsoft.com/en-us/windows-hardware/drivers/gettingstarted/what-is-a-driver-)

> ... a driver is a software component that lets the operating system and a device communicate with each other. ...

* 并不是所有的驱动都是厂商写的，有些驱动是根据某些硬件标准来写的；
* 驱动也有层次结构。

#### Software driver

Windows里有软件驱动的概念，即一个程序的在内核的部分。

#### Bus driver

To understand bus drivers, you need to understand device nodes and the device tree. For information about device trees, device nodes, and bus drivers, see [Device Nodes and Device Stacks](https://docs.microsoft.com/en-us/windows-hardware/drivers/gettingstarted/device-nodes-and-device-stacks).

Plug and Play（PnP）树在`dlls/ntoskrnl.exe/ntoskrnl.c`。

> If your point of reference is the PCI bus, then Pci.sys is the function driver. But if your point of reference is the Proseware Gizmo device, then Pci.sys is the bus driver.

#### Function driver

### [Windows内置的驱动列表](https://docs.microsoft.com/en-us/windows-hardware/drivers/gettingstarted/do-you-need-to-write-a-driver-)

<div style="font-size:3em; text-align: right">2019.9.11</div>
想知道如何高校的debug，所以去看看WineDBG的功能，

## [WineDBG](https://wiki.winehq.org/Wine_Developer's_Guide/Debugging_Wine)

### Wine中的process和thread

“W”表示Windows，“U”表示Unix。

> A `W-process` is made of one or several `W-threads`. Each `W-thread` is mapped to one and only one `U-process`. All `U-processes` of a same `W-process` share the same address space.

### WineDBG原理

WineDBG调用Windows的`kernel32.dll`和`dgbhelp.dll`来对Windows原生程序和Winelib程序和Wine自身进行debug。

### 尝试用WineDBG调试Helloworld.exe

`b main`总是break到了loader的main上去，难道是因为编译`-g3`的问题。所以在R730-1服务器上直接apt装winehp-stable试试看还有没有这样的问题。**注**：服务器是ubuntu16.04的系统所以，

```bash
sudo apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ xenial main'
```

<div style="font-size:2em; text-align: right">Linux下编译Windows程序</div>
前几天做了一点调用，但是好像是忘记记下来了，所以现在补充在这里。参考[Compile C Programs for Windows and Linux](https://prognotes.net/2015/04/compile-c-programs-for-windows-and-linux/)，

```bash
# 32位
i686-w64-mingw32-gcc -o hello.exe hello.c
# 64位
x86_64-w64-mingw32-gcc -o hello.exe hello.c
```

winedbg报错（FIXME）说找不到符号，很是烦人。索性换个版本试试。"fixme:dbghelp:elf_search_auxv can't find symbol in module"

在服务器里新clone了一个wine最新的仓库，

```bash
git checkout wine-4.0
```

<div style="font-size:3em; text-align:right;">2019.9.12</div>

为什么想要改一个内存里的值都改不了？？？

想要把while的循环条件改掉，

```bash
set 0xf61dec = 0
# 没有报任何异常，但就是没有变化。。。
```



# 术语对应表

| 简   | 全                       | 注                                                           |
| ---- | ------------------------ | ------------------------------------------------------------ |
| PDO  | Physical Device Object   | 第一次出现[Windows device stack](https://docs.microsoft.com/en-us/windows-hardware/drivers/gettingstarted/device-nodes-and-device-stacks) |
| FDO  | Functional Device Object | 同上                                                         |

