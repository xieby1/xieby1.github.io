<div style="text-align:right; font-size:3em;">2022.06.06</div>

## gem5 microops何时出现的？

gem5/src/arch/x86/isa/microops/base.isa最早始于2007年4月5日。

## gem5如何计算X86 flags？是扩展了位宽吗？

以Add为例

* gem5/src/arch/x86/isa/microops/regop.isa: class Add(FlagRegOp)
  * class FlagRegOp(BasicRegOp)
    * gem5/src/arch/x86/insts/microregop.cc: genFlags

