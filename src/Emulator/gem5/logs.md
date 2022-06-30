gem5
version: 21.2.1.1,
commit: e4fae58da6c044b6efec62392ff99f343ce67947


## how gem5 decode a x86 inst

test: ~/Gist/hello/hello.s

```asm
#hello.s
.section .data
>---output:>.ascii  "Hello World\n"
.section .text
.globl _start
_start:
/* output  like printf */
    movl $4, %eax
    movl $1, %ebx
    movl $output, %ecx
    movl $12, %edx
    int $0x80
/* exit */
    movl $1, %eax
    movl $0, %ebx
    int $0x80
```

<div style="text-align:right; font-size:3em;">2022.06.24</div>

## How `x86_macroop::MOV_R_I::MOV_R_I`'s `microops[0] =...` is generated?

### Try1

Inheritage

* src/arch/x86/isa/macroop.isa:

  `X86Macroop`

  * src/arch/micro_asm.py:

    `Combinational_Macroop`

    * `Micro_Container`

      * `Object`

### Try2

src/arch/x86/isa/macroop.isa:

```cpp
def template MacroConstructor {{
  x86_macroop::%(class_name)s::%(class_name)s(...)
  {
    ...
    /// This one generates microops[0] =...
    %(alloc_microops)s
  }
}};
```

src/arch/x86/isa/macroop.isa:

```python
class X86Macroop(Combinational_Macroop):
  def getDefinition(self, env):
    ...
    for op in self.microops:
      ...
      allocMicroops += \
        "microops[%d] = %s;\n" % \
        (micropc, op.getAllocator(flags))
```

<div style="text-align:right; font-size:3em;">2022.06.23</div>

src/arch/x86/isa/microops/limmop.isa:

```python
class LimmOp(X86Microop):
  ...
  def getAllocator(self, microFlags):
    allocString = '''
      (%(dataSize)s >= 4) ?
        ...
    ...
    '''
microopClasses["limm"] = LimmOp
```

src/arch/x86/isa/microasm.isa:

```python
assembler = MicroAssembler(X86Macroop, microopClasses, mainRom, Rom_Macroop)
```

### Overview

* src/arch/x86/isa/decoder/one_byte_opcodes.isa:

  A huge C-like switch case

  opcode(binary) => `MOV(Bv, Iv)`

  maybe it generates build/X86/arch/x86/generated/decode-method.cc.inc

* src/arch/x86/isa/insts/general_purpose/data_transfer/move.py:

  ```
  /// [TODO] what language is this?
  def macroop MOV_R_I {
    limm reg, imm
  };
  ```

* src/arch/x86/isa/macroop.isa:

  `def template MacroConstructor {{...}}`: [TODO]what =>
  build/X86/arch/x86/generated/decoder-ns.cc.inc:

  ```cpp
  x86_macroop::MOV_R_I::MOV_R_I(...) {
  ...
  microops[0] = (env.dataSize >= 4) ? ...LimmBig... : ...Limm...;
  }
  ```

* src/arch/x86/isa/microops/limmop.isa:

  limmop.isa generates the declaration and execution of `class LimmBig`

  `MicroLimmOpDeclare.subst(InstObjParams(...))` =>
  build/X86/arch/x86/generated/decoder-ns.hh.inc:

  ```cpp
  class LimmBig : ... {...};
  ```

  `MicroLimmOpExecute.subst(InstObjParams(...))` =>
  build/X86/arch/x86/generated/exec-ns.cc.inc:

  ```cpp
  Fault LimmBig::execute(...) {...}
  ```

### [TODO]decoder isa

one_byte_opcodes.isa

How `MOV(Bb, Ib)` work?
What does `Bb`, `Ib` mean?

<div style="text-align:right; font-size:3em;">2022.06.22</div>

### DPRINT `mov imm, reg`

* build/X86/arch/x86/generated/decoder-ns.hh.inc:

  ```cpp
  class Limm : public X86ISA::RegOpT<X86ISA::FoldedDestOp, X86ISA::Imm64Op> {
    Limm(ExtMachInst mach_inst, ...):
    ...
    X86ISA::RegOpT<X86ISA::FoldedDestOp, X86ISA::Imm64Op>(mach_inst, "limm", ...) {}
  }
  ```

  * src/arch/x86/insts/microregop.hh:

    ```cpp
    /// Operands are X86ISA::FoldedDestOp, X86ISA::Imm64Op
    template <typename ...Operands>
    using RegOpT = InstOperands<RegOpBase, Operands...>;
    ```
    * src/arch/x86/insts/microop_args.hh:

      ```cpp
      /// Base is RegOpBase
      /// Operands are X86ISA::FoldedDestOp, X86ISA::Imm64Op
      template <typename Base, typename ...Operands>
      class InstOperands : public Base, public Operands...
      ```

example: MOV指令，借助gdb打断点

```bash
gdb build/X86/gem5.debug
(gdb) r --debug-flags ExecAll configs/example/se.py -c ~/Gist/hello/hello
```

* build/X86/sim/simulate.cc:

  `simulate`

  * `doSimLoop(EventQueue *eventq)`
    * src/sim/eventq.cc:

      `eventq->serviceOne()`

      * override `Event::process()` function in src/sim/eventq.hh:

        `EventFunctionWrapper::process() { callback(); }`

        * src/cpu/simple/atomic.cc:

          `AtomicSimpleCPU::tick()`

          * `preExecute()`
            * `decoder->moreBytes(pc_state, fetch_pc)`

              * src/arch/x86/decoder.hh:

                ```cpp
                void
                moreBytes(const PCStateBase &pc, Addr fetchPC) override
                ```

                * src/arch/x86/decoder.cc:

                  This is a decode state machine.

                  ```cpp
                  void Decoder::process() {
                    switch (state) {
                      case PrefixState:
                      ...
                    }
                  }
                  ```

            * `decoder->decode(pc_state) /// InstDecoder::decode()`
              * function override src/arch/x86/decoder.cc:

              ```cpp
              X86ISA::Decoder : public InstDecoder {...};
              X86ISA::Decoder::decode(PCStateBase &next_pc)
              ```

                * `X86ISA::Decoder::decode(ExtMachInst mach_inst, Addr addr)`
                  * build/X86/arch/x86/generated/decode-method.cc.inc:

                    ```cpp
                    /// a HUGE switch case
                    X86ISA::Decoder::decodeInst(X86ISA::ExtMachInst)
                    ```

                    * build/X86/arch/x86/generated/decoder-ns.cc.inc:

                      ```cpp
                      x86_macroop::MOV_R_I::MOV_R_I(ExtMachInst machInst, EmulEnv _env)
                        : Macroop("mov", machInst, 1, _env) {...}
                      ```

                      * build/X86/arch/x86/generated/decoder-ns.hh.inc:

                        ```cpp
                        LimmBig::LimmBig(ExtMachInst mach_inst, const char *inst_mnem,
                                         uint64_t set_flags, Dest _dest,
                                         uint64_t _imm, uint8_t data_size)
                          : X86ISA::RegOpT<...>(...) {...}
                        ```

解码部分每个架构不同，使用.isa语言生成。
.isa语言生成的内容位于generated/文件夹。


<div style="text-align:right; font-size:3em;">2022.06.09</div>

## isa

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
