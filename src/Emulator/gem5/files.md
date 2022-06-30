<div style="text-align:right; font-size:3em;">2022.06.25</div>

# gem5 files

Use syntax of `ls -F`.

* (G)build/
* build_opts/
* build_tools/
* CODE-OF-CONDUCT.md
* configs/
    * boot/
    * common/
    * dist/
    * dram/
    * example/
        * */
        * *.py
        * hmc_tgen.cfg
        * se.py Syscall Emulation
        * fs.py Full System emulation
        * learning_gem5/ whose online guide is out of date
        * network/
        * nvm/
        * ruby/
        * splash2/
        * topologies/
* CONTRIBUTING.md
* COPYING
* ext/
* include/
* LICENSE
* MAINTAINERS.yaml
* README
* RELEASE-NOTES.md
* SConstruct*
* site_scons/
* src/
  * arch/
    * arm/
    * generic/
    * isa_parser/
    * mips/
    * null/
    * power/
    * riscv/
    * sparc/
    * x86/
      * insts/
      * isa/
        * formats/
        * insts/ uasm files (a DSL, I name it usam), uasm describes macroop => microops
        * microops/ microops' definition generator
        * decoder/
        * *.isa
      * kvm/
      * linux/
      * regs/
      * bios/
      * SConscript
      * SConsopts
      * *.cc
      * *.hh
      * *.py
    * amdgpu/
    * micro_asm.py
    * SConscript
    * SConsopts
  * base/
  * cpu/
    * checker/
    * kvm/
    * minor/
    * o3/
    * pred/
    * simple/
    * testers/
    * trace/
    * *.cc
    * *.hh
    * *.py
    * SConsopts
    * SConscript
  * dev/
  * doc/
  * doxygen/
  * gpu-compute/
  * kern/
  * learning_gem5/
  * mem/
  * proto/
  * python/
  * sim/
  * sst/
  * systemc/
  * Doxyfile
  * SConscript
* system/
* TESTING.md
* tests/
* util/

