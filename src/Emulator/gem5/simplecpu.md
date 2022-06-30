<div style="text-align:right; font-size:3em;">2022.06.28</div>

# Simple CPU in Gem5

AtomicSimpleCPU

## Execute

* src/cpu/simple/atomic.cc:

  `gem5::AtomicSimpleCPU::tick`

  * build/X86/arch/x86/generated/exec-ns.cc.inc:

    `gem5::X86ISAInst::LimmBig::execute`
