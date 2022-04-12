<div style="text-align:right; font-size:3em;">2021.01.25</div>

## 《Windows internals》russinovich， chap.2，

看了Environment Subsystem and Subsystem DLLs

61页提及POSIX应用不能直接运行，而是由Posix.exe启动，

> The POSIX image itself isn’t run directly—instead, a special support image called
> Posix.exe is launched, which in turn creates a child process to run the POSIX application.

posix.exe源码在`winxp_sp1/base/subsys/posix/programs/psxses/posix.c`里。

## 《Windows内核原理与实现》潘爱民，9.2章节

只是粗略的扫了下，相比《Windows internals》这本书更偏向源码。