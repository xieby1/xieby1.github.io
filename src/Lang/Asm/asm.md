<div style="text-align:right; font-size:3em;">2020.09.23</div>

[as官方文档](https://sourceware.org/binutils/docs/as/index.html)关于x86的很详细，但是mips的语焉不详。经过写`test/`关于mips的inline assembly内联汇编，我发现并踩平了许多坑。

针对这些文档不详的体系结构的汇编，最好的老师便是让gcc生成c语言对应的汇编`gcc -S`。

## MIPS的as汇编语法

* 延迟槽，参考[Strange jump in MIPS assembly](https://stackoverflow.com/questions/4115847/strange-jump-in-mips-assembly)

  * `.set noreorder`不会自动添加nop到延迟槽，
  * `.set reorder`（as默认）会自动处理延迟槽，

* 和x86不一样的地方

  * 操作数
    * 顺序不分ATnT和intel格式，和指令手册一致（MIPS为数不多的闪光点，可是这和MIPS架构没啥关系，是ar的MIPS端的闪光点）
    * 立即数直接写不用加`$`，
    * 寄存器前缀是`$`，而不是`%`，
    

<div style="text-align:right; font-size:3em;">2021.01.09</div>

## MIPS宏汇编

参考[X86toMips调研-续.md](../../BT/X86toMips/X86toMips调研-续.md)的2019.10.30和2019.10.31。
宏汇编的文件是`binutils/include/opcode/mips.h`和`binutils/opcodes/mips-opc.c`。