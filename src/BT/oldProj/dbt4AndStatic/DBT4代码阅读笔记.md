# DBT4代码阅读笔记

<div style="font-size:3em; text-align:right;">2020.3.2</div>
**注**：`configure; make`的结果就是编译出了一个普通qemu而已（从cpu-exec.c的include就能看出）。要编译出dbt4的话需要有`__mips__`的宏定义，然而没有找到有地方定义这个宏。

从`linux-user/main.c: main: loader_exec`开始看，可以很清楚的发现，DBT4在运行前已经以某种方式的到了目标二进制文件、需要的共享库文件（.so）、动态链接器（ld）的静态翻译好的文件。这些静态翻译好的文件在DBT4运行时以so的方式动态链接的方式加载到内存。

🤔：s2d文件格式的用途与定义？

**答**：定义在`target-i386/loader/s2d_header.h`头文件里。