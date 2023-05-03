<div style="text-align:right; font-size:3em;">2023.02.14</div>

## C extension

> VC was designed under the constraint that each RVC instruction expands into a single 32-bit
> instruction in either the base ISA (RV32I/E, RV64I, or RV128I) or the F and D standard extensions
> where present. Adopting this constraint has two main benefits:

设计宗旨：可以轻松扩展成32位指令

设计优势

* 位架构改动小
* 编译器可以不用关系（若要考虑代码膨胀率更好），可以完全交给汇编器和连接器
