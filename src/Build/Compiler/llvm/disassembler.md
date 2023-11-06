<div style="text-align:right; font-size:3em;">2023.09.05</div>

libllvm中的LLVM Disaasembler目前暂不能用来作为反汇编器，因为opcode的枚举变量没有暴露出来。

需要像MCTOLL一样在LLVM源码树中构建才行。

LLVM的opcode枚举变量位于`build/lib/Target/X86/X86GenInstrInfo.inc`。

反汇编得到opcode的大致流程

* getInstruction(...)
  * getInstructionID(&Insn, MII.get())
    * instructionID = decode(insn->opcodeType, insnCtx, insn->opcode, insn->modRM);
      * 查表

所以反汇编还得借助capstone，这一类的库
