<div style="text-align:right; font-size:3em;">2021.08.31</div>

linux v5.14-rc7 x86-64

以mmap为例

TLDR: 系统调用表是`sys_call_table`，
系统调用实现是`SYSCALL_DEFINE6(mmap)`。
两者的符号名不同，
连接两者的桥梁是一系列宏。

详细：

系统调用表&调用表中的函数定义

```c
@arch/x86/entry/syscall_64.c

/// __x64_sys_mmap，在/proc/kallsyms中可见

#define __SYSCALL(nr, sym) extern long __x64_##sym(const struct pt_regs *);
#include <asm/syscalls_64.h>
#undef __SYSCALL

#define __SYSCALL(nr, sym) __x64_##sym
sys_call_table[] = {
#include <asm/syscalls_64.h>
/// inclue展开包含
__SYSCALL(9, sys_mmap)
};
```

系统调用的实现

```c
@arch/x86/kernel/sys_x86_64.c

/// 6表示该系统调用的参数数目为6
SYSCALL_DEFINE6(mmap, ...){...}

/// SYSCALL_DEFINEx展开为多个套壳函数的
/// 声明和定义，如下
@include/linux/syscalls.h
/// 下者override上者的__SYSCALL_DEFINEx宏，见
/// syscalls.h: 97 include syscall_wrapper.h
@arch/x86/include/asm/syscall_wrapper.h
/// se指符号扩展，参考：
/// arch/x86/include/asm/syscall_wrapper.h
__se_sys_mmap(...);
__do_sys_mmap(...);
__x64_sys_mmap(...);
__x64_sys_mmap(...){__se_sys_mmap(...);}
__se_sys_mmap(...){...
    __do_sys_mmap(...);
...}
__do_sys_mmap(...)
/// 后接上面的SYSCALL_DEFINE6具体实现

/// include/linux/syscalls.h: 89-98
/// 因为CONFIG_ARCH_HAS_SYSCALL_WRAPPER开启
/// 将不会生成sys_mmap()函数。
/// 若没有开启，syscalls.h生成sys_mmap过程如下
sys_mmap(...)
    __attribute__((alias "__se_sys_mmap"));
/// alias为gcc语法，
/// 用于之前已声明的同类型符号的别名
```

