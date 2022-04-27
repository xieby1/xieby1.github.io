<div style="text-align:right; font-size:3em;">2022.04.25</div>

# AsmJit

https://asmjit.com/

```bash
cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -DASMJIT_TEST=1 ..
```

## Doc Reading

https://asmjit.com/doc

* Core
  * CodeHolder
    * ...
    * CodeBuffer
    * ...
  * BaseEmitter
  * Others
* Assembler: directly into CodeBuffer
* Builder: emit into Nodes, max compatible with Assembler
  * InstNode
  * AlignNode: alignment directive (.align)
  * LabelNode
  * ...
* Compiler: high-level, on top of Builder
  * FuncNode
  * FuncRetNode
  * InvokeNode
  * ...

<div style="text-align:right; font-size:3em;">2022.04.26</div>

## tests

`asmjit_test_assembler_x86.cpp`

并没能完全覆盖所有编码(encoding)，
比如内存地址计算，
`ptr( , , , )`这个函数，
offset(base, index, scale)，
并没有包含所有scale。

