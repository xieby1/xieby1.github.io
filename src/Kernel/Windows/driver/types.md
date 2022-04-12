<div style="text-align:right; font-size:3em;">2020.12.18</div>

* PLDC (Pointer of Local Device Context): `srv03rtm/windows/core/ntgdi/client/local.h: 276~309`
* DC refers to [Device Context Types](https://docs.microsoft.com/en-us/windows/win32/gdi/device-context-types)，有4种DC：Display、Printer、Memory、Information，下面的代码能够明显地看到Display和Printer，
  * Client即用户态：`CreateDCW`包装`bCreateDCA`包装`hdcCreateDCW`都位于`windows/core/ntgdi/client/object.c`。
    * 函数`hdcCreateDCW`。注释写的Client side stub.  Allocates a client side LDC as well.
  * Server即内核：上面的函数会调用系统调用`NtGdiOpenDCW@windows/core/ntgdi/gre/ntgdi.c: 4846~4931`。
    * 若是Printer则调用`hdcOpenDCW@windows/core/ntgdi/gre/opendc.cxx: 554`
      * `GreCreateDisplayDC@windows/core/ntgdi/gre/opendc.cxx: 23`，这里能够看到Memory类型的DC，**注**：[PDEV Initialization and Cleanup](https://docs.microsoft.com/en-us/windows-hardware/drivers/display/pdev-initialization-and-cleanup)看出PDEV大概是Physical DEVice的缩写。

DC类定义在`windows/core/ntgdi/gre/dcobj.hxx: 263~1318`。PDC是指向它的指针1320行。XDCOBJ是DCOBJ的父类，包含的hdc()方法是执行PDC的hGet()方法