<div style="text-align:right; font-size:3em;">2022.07.02</div>

# Specialize in Gem5

## Problem to solve

```
decoder/one_byte_opcodes.isa => build/X86/arch/x86/generated/decode-method.cc.inc
MOV(Bv, Iv)                  => x86_macroop::MOV_R_I(...)
```

decoder/one_byte_opcodes.isa:

```isa
'X86ISA::OneByteOpcode': decode OPCODE_OP_TOP5 {
  format Inst {
    0x17: MOV(Bv,Iv);
}}
```

`format Inst` is defined in src/arch/x86/isa/formats/multi.isa:

```isa
def format Inst(*opTypeSet) {{
    blocks = specializeInst(Name, list(opTypeSet), EmulEnv())
    (header_output, decoder_output,
     decode_block, exec_output) = blocks.makeList()
}};
```

`specializeInst` is defined in src/arch/x86/isa/specialize.isa:

```isa
def specializeInst(Name, opTypes, env):
  ...
```

Here `Name = "MOV"`, `opTypes = ("Bv", "Iv")`.

`r` prefixed opType is reg, others are tag.
Tag specialization are listed as below.

Note: '_P' means RIP relative addressing

| tag | meaning                                | size | suffix     |
|-----|----------------------------------------|------|------------|
| B   | reg encoded in opcode                  |      | _R         |
| M   | memory encoded in modrm(rm)            |      | _M/_P      |
| C   | ctl reg encoded in modrm(reg)          |      | _C         |
| D   | dbg reg encoded in modrm(reg)          |      | _D         |
| S   | seg selector encoded in modrm(reg)     |      | _S         |
| G   | reg encoded in modrm(reg)              |      | _R         |
| P   | reg encoded in modrm(reg)              | -    | _MMX       |
| T   | reg encoded in modrm(reg)              |      | _R         |
| V   | reg encoded in modrm(reg)              | -    | _XMM       |
| E   | reg or mem encoded in modrm(rm)        |      | _R/_M/_P   |
| Q   | reg or mem encoded in modrm(rm)        | -    | _MMX/_M/_P |
| W   | reg or mem encoded in modrm(rm)        | -    | _XMM/_M/_P |
| I   | immediate                              | -    | _I         |
| J   | immediate                              | -    | _I         |
| O   | immediate: mem offset                  |      | _MI        |
| PR  | reg encoded in modrm(rm)               | -    | _MMX       |
| R   | reg encoded in modrm(rm)               |      | _R         |
| VR  | reg encoded in modrm(rm)               | -    | _XMM       |
| X   | string inst mem (index&seg internally) |      | _M         |
| Y   | string inst mem (index&seg internally) |      | _M         |

Available data size is defined in src/arch/x86/isa/macroop.isa: `getAllocator`

| b | w | d | q | v      | z                    | dp          |
|---|---|---|---|--------|----------------------|-------------|
| 1 | 2 | 4 | 8 | OPSIZE | (OPSIZE==8)?4:OPSIZE | (rex_w?8:4) |

### string specialization

See `gem5/src/arch/x86/isa/formats/string.isa`

`_E` for repe, `_N` for repne, e.g. `STOS_E_M`
