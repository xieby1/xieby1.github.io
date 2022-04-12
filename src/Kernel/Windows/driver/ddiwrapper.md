<div style="text-align:right; font-size:3em;">2020.12.09</div>

来源软件所前辈推荐：https://www.openprinting.org/download/ddiwrapper/

<div style="text-align:right; font-size:3em;">2020.12.10</div>

| SLOC  | Directory | SLOC-by-Language (Sorted) | Remarks               |
| ----- | --------- | ------------------------- | --------------------- |
| 11826 | include   | ansic=11826               | 来自mingw项目的w32api |
| 947   | top_dir   | ansic=947                 |                       |
| 462   | winspool  | ansic=462                 |                       |
| 269   | gdi32     | ansic=269                 |                       |
| 245   | tools     | sh=128,ansic=117          |                       |
| 0     | dlls      | (none)                    |                       |
| 0     | doc       | (none)                    |                       |

## 编译

稍微修注释掉一些头文件中的重复定义，Makefile里添加-m32编译参数便能顺利编译。

剩下的安装、配置、运行参考README。

目前还没能找到一模一样的驱动，没能正常运行起来。

<div style="text-align:right; font-size:3em;">2020.12.11</div>

## 运行流程

* `doc/ddiwrapper.ppd`（编译生成）FoomaticRIPCommandLine带参数（驱动路径和打印参数）调用ps2ddi；
* `tools/ps2ddi`
  * 接受stdin，**注**：从ps2ddi源码28行是cat能明显看出，
  * 调用gs即Ghostscript，将stdin的内容转换成bmp格式的文件，并将bmp文件输入ddiwrapper的stdin，**注**：gs的man页面说gs能够接受ps（PostScript）文件和pdf文件，所以这里应该是接受的ps文件，
  * 接受来自stdin的bmp文件，带参数（驱动路径和打印参数）调用ddiwrapper；
* `tools/ddiwrapper`带参数（驱动路径和打印参数）调用wine启动`ddiwrapper.exe.so`调用打印机驱动。**注**：按照`ddiwrapper -h`的说明是将bmp通过打印驱动转换成打印机数据，默认输出到stdout；
* cups将stdout重定向到打印机，可能是网络、可能是usb、可能是文件。这个根据cups的设置。**猜测**：README里提到的添加打印机的命令是`lpadmin -p ddiwrapper -v usb:/dev/usblp0 -P doc/ddiwrapper.ppd -E`，其中`-v`指定的路径就是将FoomaticRIPCommandLine的输出重定向的目标地址。若省略`-v`参数，则会变为`file:///dev/null`。在[cups管理打印机的页面](http://localhost:631/printers/?)可以看到路径。

## 实现

打印机驱动分为两部分：

1. graphics dll
2. interface dll

该项目实现了部分graphics dll的调用，而没有实现interface dll的调用。

### inferface dll

`DrvDocumentPropertySheets`函数是打印机提供的设置页面，是interface dll重要的一个函数。根据这个函数找打了，`ddiwrapper/load.c: 100~109`的注释，即该项目没有并没有实现interface dll的功能。之所是用Canon打印机，是因为不设置打印机就可以运行，原文为“*Canon printer drivers seem to be happy with a zero-initialized device mode structure*”。

## 测试

### debug信息

#### gdb的debug信息

gdb参数：参考wine的compile_commands.json关于notepad编译参数，除了`-g`还需要添加`-gdwarf-2 -gstrict-dwarf`。

#### 运行打印信息

隐藏参数，加一个`-v`就会提高一个DEBUG等级，最高4级即可打印所有DEBUG消息。

```shell
ddiwrapper `cat /usr/share/ddiwrapper/drivers/default/parms` --input ~/Desktop/Untitled.bmp --PrintQuality medium --Duplex simplex --Color color --MediaType standard --PaperSize a4 > ~/Desktop/ddiwrapper_output
# parms文件的内容：--DriverPrefix=/usr/share/ddiwrapper/drivers/default --DriverPath=CNMDR61.DLL --ConfigPath=CNMUI61.DLL --DataPath=CNMCP61.DLL
# 即实际参数为：--DriverPrefix=/usr/share/ddiwrapper/drivers/default --DriverPath=CNMDR61.DLL --ConfigPath=CNMUI61.DLL --DataPath=CNMCP61.DLL --input ~/Desktop/Untitled.bmp --PrintQuality medium --Duplex simplex --Color color --MediaType standard --PaperSize a4
# 打印出来的内容：DrvEnablePDEV failed
```

gdb

```shell
WINEDLLPATH=/usr/share/ddiwrapper/dlls WINEPREFIX=$HOME/.ddiwrapper winedbg --gdb /usr/bin/ddiwrapper.exe.so --DriverPrefix=/usr/share/ddiwrapper/drivers/default --DriverPath=CNMDR61.DLL --ConfigPath=CNMUI61.DLL --DataPath=CNMCP61.DLL --input ~/Desktop/Untitled.bmp --PrintQuality medium --Duplex simplex --Color color --MediaType standard --PaperSize a4
```

<div style="text-align:right; font-size:3em;">2020.12.14</div>

佳能驱动欧版和美版似乎不同，见ddiwrapper的README的63和64行。以型号开头的驱动是美版的，以b开头的是欧版的。

<div style="text-align:right; font-size:3em;">2020.12.21</div>

将wine的安装目录的`winspool.drv.so`和`gdi32.dll.so`替换为ddiwrapper编译出来的这俩文件，就可以正常运行。