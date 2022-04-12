<div style="text-align:right; font-size:3em;">2020.09.03</div>

* 将wine-server编译成对应平台的可执行二进制文件，而不是用qemu运行x86版的。
  * 龙芯上启动Windows内核+应用程序（扫雷或者notepad）需要大概20秒
  * 龙芯上启动应用程序（Windows内核已经启动好的情况下）需要大概2-3秒