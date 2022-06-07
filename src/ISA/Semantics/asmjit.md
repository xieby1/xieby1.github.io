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

<div style="text-align:right; font-size:3em;">2022.05.26</div>

## 覆盖指令编码

cmn操作没有覆盖shift类型，很多指令都没有覆盖shift类型。

希望使用asmjit覆盖aarch64的指令编码应该不是简单能完成的。
比如cmn指令的extend和shift的reg编码，
不是在a64instdb.cpp的_instInfoTable里完成的，
而是在a64assembler.cpp的Assembler::_emit大一统的函数里的case InstDB::kEncodingBaseCmpCmn里实现的。
这样的设计并不能很方便的遍历指令编码。

x86的指令指令编码看起来都在x86instdb.cpp的几个Table里，很适合程序遍历。
