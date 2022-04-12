<div style="text-align:right; font-size:3em;">2021.06.15</div>

## 用户态MMU？

target/i386/tcg/excp_helper.c: x86_cpu_tlb_fill为啥会有USER（用户态）相关的宏？

牛根说USER宏是为了编译通过。

<div style="text-align:right; font-size:3em;">2021.04.11</div>

## [DONE] QEMU和chroot如何配合

宿主环境配了binfmt，但是跨架构的chroot环境里不用陪binfmt，似乎也能正常运行。应该是QEMU和chroot有配合吧。

2021.11.17

TLDR：binfmt只是一个配置接口，内核内部维护`formats`链表，用于每次执行文件时对比。QEMU和chroot不配合，binfmt和chroot也不需要配合。

`formats`位于`fs/exec.c`

`formats`读者：`fs/exec.c`和exec相关的各种调用

`formats`维护者之一：`fs/binfmt_misc.c`

## [ABORT] QEMU静态编译

想静态编译QEMU-user，但是链接警告，链接出来仍然是动态链接的可以执行文件，众多类似的警告如下，

```shell
/usr/bin/ld: /usr/lib/gcc/x86_64-linux-gnu/9/../../../x86_64-linux-gnu/libglib-2.0.a(gutils.c.o): in function `g_get_user_database_entry':
(.text+0x277): warning: Using 'getpwuid' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
```

可能的解决方案参考[Create statically-linked binary that uses getaddrinfo?](https://stackoverflow.com/questions/2725255/create-statically-linked-binary-that-uses-getaddrinfo)。

2021.11.17: abort, 可以尝试musl库

<div style="text-align:right; font-size:3em;">2020.09.03</div>

## [DONE] ELF的低于segments最低地址的内存不会被使用吗

和ELF相关

见[ELF的QnA](../../ELF/QnA.md)。

<div style="text-align:right; font-size:3em;">2020.08.22</div>

## 32位qemu用户态运行64位程序，如何“折叠”内存

这个问题是8.20问题的延伸。

2021.1.4: 不折叠，当64guest需要内存能够被截断塞入32空间的才行。

<div style="text-align:right; font-size:3em;">2020.08.20</div>

## 用户态，guest虚存空间>=host虚存空间，guest_base如何工作

**详**：gva转hva，用户态不像系统态需要softmmu来进行转换，gva+guest_base=hva就能完成转换。这使得guest内存空间映射到host内存里也是一大段连续的内存空间。当guest虚存空间<host虚存空间时host能轻易地找到合适的大段连续虚存空间容纳guest虚存，但是当guest虚存空间>=host虚存空间，qemu是如何处理的？目前在仅有32和64位架构的情况下包含如下3个情况，

| guest | host |
| :---: | :--: |
|  32   |  32  |
|  64   |  32  |
|  64   |  64  |

<div style="text-align:right; font-size:3em;">2020.08.21</div>

在64位机器上编译32位qemu的过程参考笔记[linux-user-32.md](linux-user-32.md)。

qemu对在32位机器上运行64位程序做了支持，参考`qemu/tcg/README`的4.1) Assumptions，**注**：tcg的target是指的host机器，

> On a 32 bit target, all 64 bit operations are converted to 32 bits. A few specific operations must be implemented to allow it (see add2_i32, sub2_i32, brcond2_i32).

比如上面提及的`add2_i32`被用在`include/tcg/tcg-op.h: tcg_gen_add_i64`（这里也写有注释`/* TCG_TARGET_REG_BITS == 32 */`）里将64位加分解成32位的加（通过`target/i386/translate.c`里的add的指令的翻译可以找到）。

但是，目前在32位机器上运行64位程序有漏洞。