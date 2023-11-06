# decoding in gem5

<div style="text-align:right; font-size:3em;">2022.07.14</div>

## Overview

* src/cpu/o3/fetch.cc;

  ```cpp
  void Fetch::fetch(bool &status_change) {
    ...
    while (numInst < fetchWidth && fetchQueue[tid].size() < fetchQueueSize
      && !predictedBranch && !quiesce) {
      ...
      dec_ptr->needMoreBytes()
      ...
      staticInst = dec_ptr->decode(this_pc);
      ...
    }
    ...
  }
  ```

  * src/arch/x86/decoder.hh:

    ```cpp
    void moreBytes(const PCStateBase &pc, Addr fetchPC) override
    {
      ...
      process();
    }
    ```

    * src/arch/x86/decoder.cc:

      ```cpp
      void Decoder::process() {...}
      ```

      `process()` actually use a state machine to decode.
      The decoded info will be stored in class `Docoder`'s member variable `ExtMachInst emi`.
      `process()` only decode format, opcode decode will be done in `Decoder::decode(...)` later.

  * src/arch/x86/decoder.cc:

    ```cpp
    StaticInstPtr Decoder::decode(PCStateBase &next_pc)
    {
      ...
      si = decode(emi, origPC);
      return si;
    }
    ```

    * src/arch/x86/decoder.cc:

      ```cpp
      StaticInstPtr
      Decoder::decode(ExtMachInst mach_inst, Addr addr)
      {
        ...
        si = decodeInst(mach_inst);
        ...
        return si;
      }
      ```

      * build/X86/arch/x86/generated/decode-method.cc.inc:

        ```cpp
        StaticInstPtr
        X86ISA::Decoder::decodeInst(X86ISA::ExtMachInst) {
          using namespace X86ISAInst;
          switch (LEGACY_LOCK) {
            case 0x0:
            switch (OPCODE_TYPE) {
              case X86ISA::OneByteOpcode:
              switch (OPCODE_OP_TOP5) {
                ...
                case 0x17:
                return new x86_macroop::MOV_R_I(machInst,
                  EmulEnv(
                    (OPCODE_OP_BOTTOM3 | (REX_B << 3)),
                    0, OPSIZE, ADDRSIZE, STACKSIZE
                ));
                break;
                ...
        }...}...}...}
        ```

        * build/X86/arch/x86/generated/decoder-ns.cc.inc:

          ```cpp
          x86_macroop::MOV_R_I::MOV_R_I(ExtMachInst machInst, EmulEnv _env)
            : Macroop("mov", machInst, 1, _env)
          {
            ...
            microops[0] = (StaticInstPtr)(new Xamovi(machInst,
              macrocodeBlock, (1ULL << StaticInst::IsMicroop) |
                (1ULL << StaticInst::IsFirstMicroop) |
                (1ULL << StaticInst::IsLastMicroop),
              X86ISA::GpRegIndex(env.reg), adjustedImm, env.dataSize));
          }
          ```

<div style="text-align:right; font-size:3em;">2022.07.03</div>

## fold

Take `Inst::MOV(['Eb', 'Gb'],{})` for an example.

* build/X86/arch/x86/generated/decode-method.cc.inc

  ```cpp
  return new x86_macroop::MOV_R_R(machInst, EmulEnv((MODRM_RM | (REX_B << 3)),
    (MODRM_REG | (REX_R << 3)),
    1,
    ADDRSIZE,
    STACKSIZE));
  ```

  * src/arch/x86/emulenv.hh:

    ```cpp
    EmulEnv(RegIndex _reg, RegIndex _regm,
        int _dataSize, int _addressSize, int _stackSize) :
      reg(_reg), regm(_regm), seg(SEGMENT_REG_DS),
      scale(0), index(INTREG_T0),
      base(INTREG_T0),
      dataSize(_dataSize), addressSize(_addressSize),
      stackSize(_stackSize)
    {;}
    ```

  Here `EmulEnv._reg` and `EmulEnv._regm` is assigned with 4-bit reg index,
  which is pure, is directly decode from x86 inst.

  * build/X86/arch/x86/generated/decoder-ns.cc.inc:

    ```cpp
    x86_macroop::MOV_R_R::MOV_R_R(...):...
    {
    microops[0] = new Mov(machInst, macrocodeBlock,
                (1ULL << StaticInst::IsMicroop) | (1ULL << StaticInst::IsFirstMicroop) | (1ULL << StaticInst::IsLastMicroop), env.dataSize, 0, X86ISA::GpRegIndex(env.reg), X86ISA::GpRegIndex(env.reg), X86ISA::GpRegIndex(env.regm));
    }
    ```

    Here `Mov(...)` receives 4-bit reg index as `args` without any modification.

    * build/X86/arch/x86/generated/decoder-ns.hh.inc:

      ```cpp
      template <typename ...Args>
      Mov(ExtMachInst mach_inst, const char *inst_mnem,
              uint64_t set_flags, uint8_t data_size, uint16_t _ext,
              Args... args) :
          X86ISA::RegOpT<X86ISA::FoldedDestOp, X86ISA::FoldedSrc1Op, X86ISA::FoldedSrc2Op>(mach_inst, "mov", inst_mnem, set_flags,
                  IntAluOp, { args... }, data_size, _ext)
      ```

      * src/arch/x86/insts/microregop.hh:

        ```cpp
        using RegOpT = InstOperands<RegOpBase, Operands...>;
        ```

        Therefore, constructor of `RegOpT` actually calls `InstOperands`,

      * src/arch/x86/insts/microop_args.hh:

        ```cpp
        template <typename Base, typename ...Operands>
        class InstOperands : public Base, public Operands...
        {
          ...
          template <std::size_t ...I, typename ...CTorArgs>
          InstOperands(std::index_sequence<I...>, ExtMachInst mach_inst,
                  const char *mnem, const char *inst_mnem, uint64_t set_flags,
                  OpClass op_class, [[maybe_unused]] ArgTuple args,
                  CTorArgs... ctor_args) :
              Base(mach_inst, mnem, inst_mnem, set_flags, op_class, ctor_args...),
              Operands(this, std::get<I>(args))...
          {}
          ...
        };
        ```

        Here, `Base` is `RegOpBase`,
        `Operands` are `FoldedDestOp`, `FoldedSrc1Op`, `FoldedSrc2Op`.
        All of their constructor are called.

        * src/arch/x86/insts/microregop.hh:

          ```cpp
          class RegOpBase : public X86MicroopBase
          {
            ...
             RegOpBase(ExtMachInst mach_inst, const char *mnem, const char *inst_mnem,
                     uint64_t set_flags, OpClass op_class, uint8_t data_size,
                     uint16_t _ext) :
                 X86MicroopBase(mach_inst, mnem, inst_mnem, set_flags, op_class),
                 ext(_ext), dataSize(data_size),
                 foldOBit((data_size == 1 && !mach_inst.rex.present) ? 1 << 6 : 0)
             {}
             ...
          };
          ```

          `foldOBit` is initialized for every potential a/b/c/dh registers.
          TODO: why not determine a/b/c/dh registers here?

        * src/arch/x86/insts/microop_args.hh:

          ```cpp
          using FoldedDestOp = FoldedOp<DestOp>;
          ```

          `FoldedDestOp` derives from `FoldedOp`.

          ```cpp
          template <class Base>
          struct FoldedOp : public Base
          {
              ...
              template <class InstType>
              FoldedOp(InstType *inst, ArgType idx) :
                  Base(INTREG_FOLDED(idx.index, inst->foldOBit), inst->dataSize)
              {}
              ...
          };
          ```

          `Base` is `DestOp`.
          The reg index passed to `DestOp` is modified by `INTREG_FOLDED`.

          * src/arch/x86/regs/int.hh:

            ```cpp
            inline static IntRegIndex
            INTREG_FOLDED(int index, int foldBit)
            {
                if ((index & 0x1C) == 4 && foldBit)
                    index = (index - 4) | foldBit;
                return (IntRegIndex)index;
            }
            ```

            According to 2020.amd64.pdf: Table 1-10
            a/b/c/dh is decoded as `0b1xx`.

            Therefore, `INTREG_FOLDED` transform a/b/c/dh reg index to `0b10000xx`.
            `0bxx` is the unified with ra/b/c/dx encoding.

