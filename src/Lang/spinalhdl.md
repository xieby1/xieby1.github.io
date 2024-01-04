[SpinalHDL](https://spinalhdl.github.io/SpinalDoc-RTD/master/index.html)

* [x] Foreword
* [x] Introduction
* [x] Getting Started
* [] Data types
* [] Structuring
* [] Semantic
* [] Sequential logic
* [] Design errors
* [] Other language features
* [] Libraries
* [] Simulation
* [] Formal verification
* [] Examples
* [] Legacy
* [] Miscellaneous
* [] Developers area

<div style="text-align:right; font-size:3em;">2023.12.20</div>

# SpinalHDL

[Why moving away from traditional HDL](https://spinalhdl.github.io/SpinalDoc-RTD/master/SpinalHDL/Foreword/index.html)
介绍了VHDL和Verilog的不足。

## Semantic

### assignments

说的是`:=`对应`<=`但是wire的生成出来的.v文件显示`:=`就是`=`。

### Rules

* An assignment to a combinational signal is like expressing a rule which is `always true` （注：应该是verilog的always true语句？）
* An assignment to a register is like expressing a rule which is applied on each cycle of its clock domain
