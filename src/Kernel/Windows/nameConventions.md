<div style="text-align:right; font-size:3em;">2021.01.07</div>

# Windows命名风格

参考《2010.Windows内核原理与实现.潘爱民》2.3.2WRK源代码说明，

## 函数

### 内核

| 前缀   | 全称                                                   |
| ------ | ------------------------------------------------------ |
| Cc     | Cache 缓存管理器                                       |
| Cm     | Configuration Manager 配置管理器（即注册表）           |
| Dbg/Kd | Debug/Kernel debug 调试支持函数                        |
| Ex     | Execution 执行体函数                                   |
| FsRtl  | File system Runtime library 文件系统驱动程序运行函数库 |
| Fstub  | File system stub 文件系统引导接口函数                  |
| Hal    | Hardware abstract layer 硬件抽象层提供的接口函数       |
| Io     | IO 输入输出管理器                                      |
| Ke     | Kernel 内核函数                                        |
| Lpc    | Local procedure call 本地过程调用函数                  |

**注**：LPC只局限与一个机器的跨进程调用。RPC（Remote Procedure Call）分狭义和广义，狭义仅指跨机器的函数调用，广义当然包括把RPC相同的机制也用到了本地上，比如之前学习的D-BUS就虽然只在一个机器上运作，但也自称RPC，来源[wikipedia: D-Bus](https://en.wikipedia.org/wiki/D-Bus)，

> In [computing](https://en.wikipedia.org/wiki/Computing), **D-Bus** (short for "**Desktop Bus**"[[4\]](https://en.wikipedia.org/wiki/D-Bus#cite_note-4)) is a [software bus](https://en.wikipedia.org/wiki/Software_bus), [inter-process communication](https://en.wikipedia.org/wiki/Inter-process_communication) (IPC), and [remote procedure call](https://en.wikipedia.org/wiki/Remote_procedure_call) (RPC) mechanism that allows communication between multiple [processes](https://en.wikipedia.org/wiki/Process_(computing)) running concurrently on the same machine.[[5\]](https://en.wikipedia.org/wiki/D-Bus#cite_note-intro_dbus-5)[[6\]](https://en.wikipedia.org/wiki/D-Bus#cite_note-Cocagne_2012-6)

注意下面的最后一句话，已画下划线强调，

> D-Bus was conceived as a generic, high-level inter-process communication system. To accomplish such goals, D-Bus communications are based on the exchange of *messages* between processes instead of "raw bytes".[[5\]](https://en.wikipedia.org/wiki/D-Bus#cite_note-intro_dbus-5)[[16\]](https://en.wikipedia.org/wiki/D-Bus#cite_note-dbus_tut-16) D-Bus messages are high-level discrete items that a process can send through the bus to another connected process. Messages have a well-defined structure (even the types of the data carried in their payload are defined), allowing the bus to validate them and to reject any ill-formed message. <u>In this regard, D-Bus is closer to an [RPC](https://en.wikipedia.org/wiki/Remote_procedure_call) mechanism than to a classic IPC mechanism, with its own type definition system and its own [marshaling](https://en.wikipedia.org/wiki/Marshalling_(computer_science)).[[5\]](https://en.wikipedia.org/wiki/D-Bus#cite_note-intro_dbus-5)</u>

| 前缀 | 全称 |
| ---- | ---- |
| Mm | Memory 内存管理器 |
| Nt | Win New Technoloy WinNT系统服务 |
| Ob | Object 对象管理器 |
| Perf | Perfermance 日志记录函数 |
| Po | Power 电源管理 |
| Pp | Plug and Play 即插即用管理器 |
| Ps | Process 进程/线程 |
| Raw | Raw文件系统的函数 |
| Rtl | Runtime Library 内核运行库函数 |
| Se | Security 安全函数 |
| Vf | Verify 驱动程序检验器 |
| Wmi | Win Management ？ Win管理规范 |
| Zw | 与Nt前缀同名的一套函数，省去了参数验证的步骤，其他逻辑相同，可以认为以Nt前缀为名称的函数针对用户模式的调用者，以Zw前缀为名称的函数针对内核模式调用者。 |

## 变量

srv03rtm/printscan/print/spooler/localspl/init.c有诸多sz开头的字符串

参考[注册表支持的变量类型](https://docs.microsoft.com/en-us/windows/win32/sysinfo/registry-value-types)，

REG_SZ：A null-terminated string. This will be either a Unicode or an ANSI string, depending on whether you use the Unicode or ANSI functions

所以sz大概是String Zero。

## 类型

### 字符串

下述简称的互斥、联合关系：<span style="font-size:2em;">`[N/L][P][C][W/T](CH/STR)`</span>

**注**：参考的之前添加到浏览器收藏夹learning.kernel.windows.[CSDN：字符串类型](https://blog.csdn.net/w343051232/article/details/7083276)（加入到本md后，这个收藏链接便可删掉了）

| 简写 | 含义                                                  |
| ---- | ----------------------------------------------------- |
| N    | Near 在16位系统中代表16位的段内地址                   |
| L    | Long(far) 在16位系统中代表16位的段地址+16位的偏移地址 |

在32位系统中 N和L已经没有作用，只是为了向前兼容（兼容16位机器）才保留这些定义。

**注**：16位系统即现在x86中的实模式，该系统/模式下的唯一寻址方式是```segment << 4 + offset```。关于16位系统/实模式寻址，参考[What are the segment and offset in real mode memory addressing?](https://stackoverflow.com/questions/4119504/what-are-the-segment-and-offset-in-real-mode-memory-addressing)和回答指向的一篇文章[Real-Mode Memory Management](https://kajouni.net/info/eng/realmode.htm)。

| 简写 | 含义                                                         |
| ---- | ------------------------------------------------------------ |
| P    | Pointer 指针                                                 |
| C    | Constant 常数                                                |
| W    | Wide 2字节的                                                 |
| T    | 自适应位宽，在UNICODE编译环境下采用2字节，在ASCII环境下采用1字节 |
| CH   | char 字符                                                    |
| STR  | string 字符串                                                |

