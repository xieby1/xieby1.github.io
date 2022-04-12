<div style="text-align:right; font-size:3em;">2020.3.16</div>

* dumpinput

* DumpObject

* DisassemleObject

* `llvm-mctoll.cpp:1375 getInstruction(...)` Disassemble a real instruction or a data
  * x86的话`llvm/lib/Target/X86/Disassembler/X86Disassembler.cpp:1700 getInstruction(...)`
    * `:1713getInstrctionID(...)`指令的操作码，`INSTRUCTIONS_SYM`可能要编译时才生成吧
    * `:2295 translateInstruction(...)`
  
* `llvm-mctoll.cpp:1441 runMachineFunctionPasses() `
  
  `llvm/tools/llvm-mctoll/MachineFunctionRaiser.cpp`
  
  * Build CFG
    * `MCInst`转`MachineInstr`在`MCInstRaiser::RaiseMCInst(...)`中完成。在mctoll的MCInstRaiser.cpp文件里
  * Construct function prototype
  * `MachineFunctionRaiser::runRaiserPasses()`
    * x86的话`llvm/tools/llvm-mctoll/X86/X86MachineInstructionRaiser.cpp: 425 X86MachineInstructionRaiser::raise()`
      * `X86MachineInstructionRaiser::raiseMachineFunction()`Raise MachineInstr in MachineFunction to MachineInstruction
        * `raiseMachineInstr(MachineInstr)`其中`MachineInstr是LLVM的类`，但是有mctoll定义的内容
          * `raiseMemRefMachineInstr(MachineInstr)`
          * `raiseReturnMachineInstr(MachineInstr)`
          * `raiseGenericMachineInstr(MachineInstr)`
            * `raiseBinaryOpImmToRegMachineInstr（MachineInstr）`
              * `BinaryOperator::CreateAdd()`
  
* 输出文件

<div style="text-align:right; font-size:3em;">2020.3.20</div>

**注**：BinaryOperator *CreateXXX的定义在`include/llvm/IR/InstrTypes.h`里，通过同名宏`HANDLE_BINARY_INST`的3次定义3次“调用”`llvm/IR/Instruction.def`完成了统一函数名的不同签名的声明+定义。十分巧妙！最终是调用了`BinaryOperator::Create(...)`

想要搞清楚的问题：

* 类型信息在哪个阶段获取的？

  **注**：MachineInstr是LLVM描述机器语言类，Value是LLVM IR的操作数类。

  raise指令时，比如`X86MachineInstructionRaiser::raiseBinaryOpImmToRegMachineInstr(MachineInstr)`生成了Value类型的操作数，其中就包含了类型，通过寄存器、原操作数、目的操作数的信息来判断类型。（当然有必要的话会生产类型转换的代码）。
  
* 在哪个地方用x86汇编生成的LLVM IR？

  同上，利用`BinaryOperator::CreateXXX()`函数生成LLVM IR，然后添加到`RaisedBB->getInstList()`里。同时在这里处理了EFLAGS。

