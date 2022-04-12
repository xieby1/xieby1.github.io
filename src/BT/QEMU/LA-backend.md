ssh loongson@10.90.50.199

ssh loongson@192.168.2.7

<div style="text-align:right; font-size:3em;">2021.04.07</div>

## 张福新老师提示需要注意的点

主要目标是（在用户模式下即可测试运行）：

* 看tcg翻译到LA的边界范围，看Assert
* 看翻译出的LA有没有更优的序列

曾路主导做的LA后端。

* tcg-pool.inc.c，常量池，用来拼接常量？弄清其作用和使用方法。ARM大量使用参考ARM。
* ABI相较MIPS发生变化
  * 寄存器没有GP，通过PC相对寻址查GOT
  * 寄存器V0、V1不存在，返回值复用A0、A1
  * 寄存器TP指Thread Point (Thread Local)
* QEMU约束，告诉QEMU后端生产指令的能力范围
  * S12有符号12位，N12取反的有符号12位。用于（TCG的还是LA的）SUB指令，所以需要取反然后加。范围不同开闭区间：S12`[-2^12, 2^12)`和N12`(-2^12, 2^12]`。
  * P2M1是指Power 2 Minus 1即`2^N - 1`，用于TCG的ANDI指令超出12位支持。LA的ANDI只支持12位，但P2M1模式可用LA的EXT指令。详细看TCG的and_i32翻译
  * r (reg), z (zero), k (z^n-1)？
* 特殊TCG指令goto_tb和exit_tb

---

对着看RISCV和MIPS的TCG翻译。

## tcg-pool

顺序链表。用作relocation。tcg-pool打入的标签似乎和链接器的relocation类型是一个意思。

## 代码阅读

### tcg_out_[instr]

* movi
  * 32位即以下：trivial
  * 64位：OPC_AUIPC配合PADDI是PC+si32，先写的+0

### tcg_out_opc_[type]

* upper手册上没有这类1RI20

  opcode7 i20 rd5

* imm即2RI12

  opcode10 i12 rj5 rd5

