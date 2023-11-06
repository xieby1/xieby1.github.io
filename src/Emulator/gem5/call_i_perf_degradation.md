* src/arch/x86/decoder.hh

  `updateNPC(...)`会设定指令npc的初始值

* src/arch/x86/insts/microop.cc:

  `X86MicroopBase::branchTarget(...)` 用到了machInst.immediate更新npc

