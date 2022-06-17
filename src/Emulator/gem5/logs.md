gem5
version: 21.2.1.1,
commit: e4fae58da6c044b6efec62392ff99f343ce67947

<div style="text-align:right; font-size:3em;">2022.06.09</div>

lyw：负责处理isa文件

gem5/src/arch/isa_parser/isa_parser.py

<div style="text-align:right; font-size:3em;">2022.06.06</div>

## gem5 microops何时出现的？

gem5/src/arch/x86/isa/microops/base.isa最早始于2007年4月5日。

## gem5如何计算X86 flags？是扩展了位宽吗？

以Add为例

* gem5/src/arch/x86/isa/microops/regop.isa: class Add(FlagRegOp)
  * class FlagRegOp(BasicRegOp)
    * gem5/src/arch/x86/insts/microregop.cc: genFlags

<div style="text-align:right; font-size:3em;">2022.06.16</div>

https://www.gem5.org/documentation/learning_gem5/part2/parameters/

> C++ objects are not created until m5.instantiate() is called

## Memory Object

https://www.gem5.org/documentation/learning_gem5/part2/memoryobject/

callchain?
retry can be a single call stack?
