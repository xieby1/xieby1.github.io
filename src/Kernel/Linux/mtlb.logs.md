<div style="text-align:right; font-size:3em;">2021.10.21</div>

MIPS和LA的双TLB序号不一样，

* LA是先STLB然后MTLB，参考`2021.la_1.ocr.pdf`对TLBSRCH指令的说明
* MIPS是先VTLB然后FTLB，参考`2014.mips64_3.pdf`的A.3.2 Programming Interface

mips的vtlb小测试移植完成，没有LA上的奇怪的问题。已经反映给了曾路。

<div style="text-align:right; font-size:3em;">2021.10.20</div>

在`linux-4.19-loongson： btmmu`中搜索tlbwr，搜索到asm_i_tlbwr

arch/mips/include/asm/uasm.h

* `Ip_0(_tlbwr);`
  * `#define Ip_0(op) void uasm_i##op(u32 **buf)`

arch/mips/mm/uasm.c

* `I_0(_tlbwr)`

  * ```c
    #define I_0(op) \
    Ip_0(op) \
    { \
        build_insn(buf, insn##op); \
    } \
    UASM_EXPORT_SYMBOL(uasm_i##op);
    ```

寄存器相关操作定义在`arch/mips/include/asm/mipsregs.h`

<div style="text-align:right; font-size:3em;">2021.10.19</div>

移植到3a4000上，读mips手册`2005.mips64_3.pdf`。

手册4.11提到要避免TLB execption loop，我从来没考虑过，这是什么问题？需要在何时考虑？

突然想到tlb中有不同的虚拟地址映射到物理地址会有问题吗？

读完了4.11才发现没有vtlb，看dual_tlb的论文发现vtlb是2009年才在mips上实装。

从李亚伟那里要来`2014.mips64_3.pdf`。

vtlb的本意是做大页映射，节省ftlb表项，见A.3.2，引用如下

> The existence of a VTLB retains the capability of using large pages to map large sections of physical memory without consuming a large number of entries in the FTLB.

<div style="text-align:right; font-size:3em;">2021.10.09</div>

并非tlb被清除，

gdb提示`Gist/lkm/mtlb/test/fill`失败在`/lib/loongarch64-linux-gnu/libc.so.6`

情况1，地址似乎相同

```
*** stack smashing detected ***: <unknown> terminated
Program received signal SIGABRT, Aborted.
0x000000fff7e7c8b8 in raise () from /lib/loongarch64-linux-gnu/libc.so.6
```

情况2，地址似乎相同

```
sigsegv: pc fff7f13a80
sigsegv: access (nil)
Program received signal SIGSEGV, Segmentation fault.
0x000000fff7f13a80 in open64 () from /lib/loongarch64-linux-gnu/libc.so.6
```

```
sigsegv: pc b4
sigsegv: access 0xb4
Program received signal SIGSEGV, Segmentation fault.
```

情况3

```
Program received signal SIGBUS, Bus error.
0x000000fff7eb808c in ?? () from /lib/loongarch64-linux-gnu/libc.so.6
```



<div style="text-align:right; font-size:3em;">2021.09.27</div>

`Gist/lkm/mtlb/test/fill`成功了一次，但大多失败，猜测是进程换入换出把tlb清除了。

<div style="text-align:right; font-size:3em;">2021.09.13</div>

物理页分配采用buddy分配器，参考[kernel.org gorman: Physical Page Allocation](https://www.kernel.org/doc/gorman/html/understand/understand009.html)

<div style="text-align:right; font-size:3em;">2021.09.10</div>

`.tmp_cpu-probe.cmd`或者`compile_command.json`中有编译参数，预编译cpu-probe.c，可知`__dcsrrd`会变成`__builtin_loongarch_dcsrrd`。这个命名法可以确定是gcc提供的函数。

和徐成华交流得知，github上有不含向量的LA gcc：https://github.com/loongson/gcc

la gcc内置函数见`gcc/config/loongarch/larchintrin.h`

内核包装过的csr函数见`arch/loongarch/include/asm/loongarchregs.h`

tlb函数见`arch/loongarch/include/asm/tlb.h`

<div style="text-align:right; font-size:3em;">2021.09.09</div>

可以直接用，但是`arch/loongarch/include/asm/loongarchregs.h`的__dcsrrd/wr在哪里定义？

<div style="text-align:right; font-size:3em;">2021.09.08</div>

linux-4.19-loongson

:cs f g搜索`.*MTLB.*`和`.*mtlb.*`之发现了`arch/loongarch/kernel/cpu-probe.c`有读取mtlb的大小放入`tlbsizemtlb`，然后就没有别的了。