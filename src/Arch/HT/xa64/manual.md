# XA64 MANUAL

## ToC

<!-- vim-markdown-toc GFM -->

* [Uop slot](#uop-slot)
* [Ucache](#ucache)
  * [L1 uache](#l1-uache)
  * [L2 ucache](#l2-ucache)
  * [ucache memory area](#ucache-memory-area)
  * [ucahce controller](#ucahce-controller)
* [Mnemonic](#mnemonic)
* [Encoding](#encoding)
  * [Operand Extension](#operand-extension)
  * [Operand Size](#operand-size)
  * [arithmetic flags](#arithmetic-flags)
  * [general registers](#general-registers)
  * [Immediate](#immediate)
* [Instructions List](#instructions-list)
  * [Pseudo Functions](#pseudo-functions)
    * [Flags](#flags)
  * [4 operands](#4-operands)
    * [[TODO] mul2, mul2_f, mul2_i, mul2_fi](#todo-mul2-mul2_f-mul2_i-mul2_fi)
    * [shliadd](#shliadd)
    * [segaddld_i](#segaddld_i)
    * [segaddst_i](#segaddst_i)
    * [segadd_i](#segadd_i)
  * [3 operands](#3-operands)
    * [add, add_f, add_i, add_fi](#add-add_f-add_i-add_fi)
    * [adc, adc_f, adc_i, adc_fi](#adc-adc_f-adc_i-adc_fi)
    * [[TODO] addld, addld_i](#todo-addld-addld_i)
    * [and, and_f, and_i, and_fi](#and-and_f-and_i-and_fi)
    * [[TODO] rotl, rotl_f, rotli, rotli_f](#todo-rotl-rotl_f-rotli-rotli_f)
    * [[TODO] rotr, rotr_f, rotri, rotri_f](#todo-rotr-rotr_f-rotri-rotri_f)
    * [shl, shl_f, shli, shli_f](#shl-shl_f-shli-shli_f)
    * [shr, shr_f, shri, shri_f](#shr-shr_f-shri-shri_f)
    * [[TODO] mul, mul_f, mul_i, mul_fi](#todo-mul-mul_f-mul_i-mul_fi)
    * [or, or_f, or_i, or_fi](#or-or_f-or_i-or_fi)
    * [[TODO] addst_i](#todo-addst_i)
    * [sar, sar_f, sari, sari_f](#sar-sar_f-sari-sari_f)
    * [sub, sub_f, sub_i, sub_fi](#sub-sub_f-sub_i-sub_fi)
    * [sbb, sbb_f, sbb_i, sbb_fi](#sbb-sbb_f-sbb_i-sbb_fi)
    * [xor, xor_f, xor_i, xor_fi](#xor-xor_f-xor_i-xor_fi)
    * [[TODO] shl2, shl2_f, shl2_i, shl2_fi](#todo-shl2-shl2_f-shl2_i-shl2_fi)
    * [[TODO] cmpxchg, cmpxchg_f](#todo-cmpxchg-cmpxchg_f)
    * [segld](#segld)
    * [segst](#segst)
    * [sexti](#sexti)
    * [zexti](#zexti)
    * [movc, movc_i](#movc-movc_i)
    * [bit, biti](#bit-biti)
    * [hop](#hop)
  * [2 operands](#2-operands)
    * [[TODO] bswap](#todo-bswap)
    * [[TODO] clz, clz_f](#todo-clz-clz_f)
    * [[TODO] ctz, ctz_f](#todo-ctz-ctz_f)
    * [mov](#mov)
    * [mov_i](#mov_i)
    * [[TODO] neg, neg_f](#todo-neg-neg_f)
    * [[TODO] not, not_f](#todo-not-not_f)
    * [[TODO] ld](#todo-ld)
    * [[TODO] st](#todo-st)
    * [callrel, callrel_i](#callrel-callrel_i)
    * [callabs, callabs_i](#callabs-callabs_i)
    * [jrelc, jrelc_i](#jrelc-jrelc_i)
    * [muls, muls_i, muls_f, muls_fi](#muls-muls_i-muls_f-muls_fi)
    * [loopcnt](#loopcnt)
    * [step](#step)
  * [1 operand](#1-operand)
    * [ret](#ret)
    * [rdpc](#rdpc)
    * [jrel, jrel_i](#jrel-jrel_i)
    * [jabs, jabs_i](#jabs-jabs_i)
    * [inc, inc_f](#inc-inc_f)
    * [dec, dec_f](#dec-dec_f)
    * [rdmull, rdmulh](#rdmull-rdmulh)
    * [loopend](#loopend)
  * [0 operand](#0-operand)
    * [invalid](#invalid)
    * [nop](#nop)
    * [syscall](#syscall)
    * [halt](#halt)

<!-- vim-markdown-toc -->

## Uop slot

![](./pictures/manual_uop_slot.svg)

* v: 1 bit: valid
* un: 3 bits: uops number
* npc: 4 bits: next pc offset
* uop4/5 overrlap with iimm

## Ucache

### L1 uache

Granularity: entry (1B in macroop addr)

2-way associated 4K entries, size=`2*4K*32B`=256KB

Able to hold 2 pages (8KB) inst's microops at most.

![](./pictures/manual_l1ucahe.svg)

### L2 ucache

Granularity: entry (1B in macroop addr)

4-way associated 64K entries, size=`4*64K*32B`=8MB

64 pages

### ucache memory area

Granularity: one macroop page

256MB

2048 macroop pages

### ucahce controller

(inspired by CAM)

TODO:

64-way associated 32 entries, to index 2048 macroop pages.

## Mnemonic

```
<op>_<ext> <dst> <src0> <src1>
```

## Encoding

### Operand Extension

The `ex` is a 2-bit field encoded in every xa64 inst,
usually representing the operand size.

3 types of extension are available:

  * Zero
  * Signed
  * Merge (without modification other bits)

### Operand Size

The `sz` is a 2-bit field encoded in every xa64 inst,
representing the extension mode.

4 types of size are available:

* 8 bits: Short
* 16 bits: Word
* 32 bits: Double word
* 64 bits: Quadruple word

### arithmetic flags

There is bit in encoding,
presenting whether arithmetic flags need to be calculated.

### general registers

6 bits

* 1 bit: 0 low, 1 high
* 5 bits: index to 32 general registers

### Immediate

Immediate is saved along with uops in uop slot.

Immediate is access by 6-bit field

* 1 bit: 0 direct, 1 indirect
* 1 bit: sign
* 4 bits: indirect

  ```
  [0b0000]:         reserved
  [0b0001]:         1 64-bit imm
  [0b0010, 0b0011]: 2 32-bit imm
  [0b0100, 0b0111]: 4 16-bit imm
  [0b1000, 0b1111]: 8  8-bit imm
  ```

## Instructions List

direct immediate
indirect immediate

![](./pictures/manual_inst_encoding.svg)

`0x00000000` is invalid instruction.

suffix

* i: immediate version
* f: arithmetic flags version

### Pseudo Functions

* `GPR(idx, sz)`: get GPR value by GPR index `idx` and GPR size `sz`.
* `GPR(idx, sz, ex)`: set GPR value by GPR index `idx`, GPR size `sz` and extension mode `ex`.
* `Load(addr, sz)`: load value from memory address `addr` with size of `sz`.
* `Store(data, addr, sz)`: store value `data` to memory address `addr` with size of `sz`.

#### Flags

Currently flags are identical to x86

E.g. add flags

```
C = (!dest[sz-1] + src1[sz-1] + op2[sz-1]) & 0x2
P = findParity(8, dest)
A = (!dest[3] + src1[3] + op2[3]) & 0x2
Z = !dest[sz-1:0]
S = dest[sz-1]
O = (src1[sz-1] ^ !op2[sz-1]) & (src1[sz-1] ^ dest[sz-1])
```

### 4 operands

#### [TODO] mul2, mul2_f, mul2_i, mul2_fi

#### shliadd

**Type**

IntAluOp

**Mnemonic**

```
shliadd dest, imm6, src1, src2
```

**Operation**

```
GPR(dest, 64, Zero) = (GPR(src1, sz) << imm6) + GPR(src2, sz)
```

**Typical Usage**

Calculate memory address.
`imm`, `src1`, `src2` are scale, index, base repectively.

#### segaddld_i

**Type**

MemReadOp

**Mnemonic**

```
segaddld_i data, segment, base, disp
```

**Operation**

```
GPR(data, sz, ex) = Load(GPR(base) + SEG(segment) + disp, sz)
```

#### segaddst_i

**Type**

MemWriteOp

**Mnemonic**

```
segaddst_i data, segment, base, disp
```

**Operation**

```
Load(GPR(data), GPR(base) + SEG(segment) + disp, sz)
```

#### segadd_i

**Type**

IntAluOp

**Mnemonic**

```
segadd_i data, segment, base, disp
```

**Operation**

```
GPR(data, sz, Merge) = GPR(base) + SEG(segment) + disp
```

**Typical Usage**

Calculate effective address, together with `shliadd`.

### 3 operands

#### add, add_f, add_i, add_fi

**Type**

IntAluOp

**Mnemonic**

```
add dest, src1, src2
add_f dest, src1, src2
add_i dest, src1, imm
add_fi dest, src1, imm
```

**Operation**

```
op2 = imm_version? IIMM(imm) : GPR(src2, sz)
GPR(dest, sz, ex) = GPR(src1, sz) + op2
```

#### adc, adc_f, adc_i, adc_fi

**Type**

IntAluOp

**Mnemonic**

```
adc dest, src1, src2
adc_f dest, src1, src2
adc_i dest, src1, imm
adc_fi dest, src1, imm
```

**Operation**

```
op2 = imm_version? IIMM(imm) : GPR(src2, sz)
GPR(dest, sz, ex) = GPR(src1, sz) + op2 + C
```

#### [TODO] addld, addld_i

#### and, and_f, and_i, and_fi

**Type**

IntAluOp

**Mnemonic**

```
and dest, src1, src2
and_f dest, src1, src2
and_i dest, src1, imm
and_fi dest, src1, imm
```

**Operation**

```
op2 = imm_version? IIMM(imm) : GPR(src2, sz)
GPR(dest, sz, ex) = GPR(src1, sz) & op2
```

#### [TODO] rotl, rotl_f, rotli, rotli_f

#### [TODO] rotr, rotr_f, rotri, rotri_f

#### shl, shl_f, shli, shli_f

**Type**

IntAluOp

**Mnemonic**

```
shl dest, src1, src2
shl_f dest, src1, src2
shli dest, src1, imm6
shli_f dest, src1, imm6
```

**Operation**

```
op2 = imm_version? imm6 : GPR(src2, sz)
shiftAmt = op2 & ((sz==8)? mask(6) : mask(5))
GPR(dest, sz, ex) = GPR(src1, sz) << shiftAmt
```

#### shr, shr_f, shri, shri_f

**Type**

IntAluOp

**Mnemonic**

```
shr dest, src1, src2
shr_f dest, src1, src2
shri dest, src1, imm6
shri_f dest, src1, imm6
```

**Operation**

```
op2 = imm_version? imm6 : GPR(src2, sz)
shiftAmt = op2 & ((sz==8)? mask(6) : mask(5))
GPR(dest, sz, ex) = GPR(src1, sz) >> shiftAmt
```

#### [TODO] mul, mul_f, mul_i, mul_fi

#### or, or_f, or_i, or_fi

**Type**

IntAluOp

**Mnemonic**

```
or dest, src1, src2
or_f dest, src1, src2
or_i dest, src1, imm6
or_fi dest, src1, imm6
```

**Operation**

```
op2 = imm_version? imm6 : GPR(src2, sz)
GPR(dest, sz, ex) = GPR(src1, sz) | op2
```

#### [TODO] addst_i

#### sar, sar_f, sari, sari_f

**Type**

IntAluOp

**Mnemonic**

```
shl dest, src1, src2
shl_f dest, src1, src2
shli dest, src1, imm6
shli_f dest, src1, imm6
```

**Operation**

```
op2 = imm_version? imm6 : GPR(src2, sz)
shiftAmt = op2 & ((sz==8)? mask(6) : mask(5))
GPR(dest, sz, ex) = GPR(src1, sz) s>> shiftAmt)
```

#### sub, sub_f, sub_i, sub_fi

**Type**

IntAluOp

**Mnemonic**

```
sub dest, src1, src2
sub_f dest, src1, src2
sub_i dest, src1, imm
sub_fi dest, src1, imm
```

**Operation**

```
op2 = imm_version? IIMM(imm) : GPR(src2, sz)
GPR(dest, sz, ex) = GPR(src1, sz) - op2
```

#### sbb, sbb_f, sbb_i, sbb_fi

**Type**

IntAluOp

**Mnemonic**

```
sub dest, src1, src2
sub_f dest, src1, src2
sub_i dest, src1, imm
sub_fi dest, src1, imm
```

**Operation**

```
op2 = imm_version? IIMM(imm) : GPR(src2, sz)
GPR(dest, sz, ex) = GPR(src1, sz) - op2 - C
```

#### xor, xor_f, xor_i, xor_fi

**Type**

IntAluOp

**Mnemonic**

```
xor dest, src1, src2
xor_f dest, src1, src2
xor_i dest, src1, imm6
xor_fi dest, src1, imm6
```

**Operation**

```
op2 = imm_version? imm6 : GPR(src2, sz)
GPR(dest, sz, ex) = GPR(src1, sz) ^ op2
```

#### [TODO] shl2, shl2_f, shl2_i, shl2_fi

#### [TODO] cmpxchg, cmpxchg_f

#### segld

**Type**

MemReadOp

**Mnemonic**

```
segld_i data, segment, base
```

**Operation**

```
GPR(data, sz, ex) = Load(GPR(base) + SEG(segment), sz)
```

#### segst

**Type**

MemWriteOp

**Mnemonic**

```
segst_i data, segment, base
```

**Operation**

```
Load(GPR(data), GPR(base) + SEG(segment), sz)
```

#### sexti

**Type**

IntAluOp

**Mnemonic**

```
sexti dest, src1, imm6
```

**Operation**

Sign extend `src1` from size `imm6` to size `sz`.
The result is stored into `dest`.

#### zexti

**Type**

IntAluOp

**Mnemonic**

```
zexti dest, src1, imm6
```

**Operation**

Zero extend `src1` from size `imm6` to size `sz`.
The result is stored into `dest`.

#### movc, movc_i

**Type**

IntAluOp

**Mnemonic**

```
movc dest, src, cond
movc_i dest, imm, cond
```

**Operation**

```
op = imm_version? IIMM(imm) : GPR(src, sz)
if (cond)
  GPR(dest, sz, Merge) = op
```

#### bit, biti

**Type**

IntAluOp

**Mnemonic**

```
bit src1, src2, flag
bit src1, imm6, flag
```

**Operation**

set `flag` with bit `src1[src2]` or `src1[imm6]`

#### hop

**Type**

IntAluOp

**Mnemonic**

```
hop src1, src2, flag
```

**Operation**

```
if (flag) {
  GPR(src1, sz, Zero) = GPR(src1, sz) + sz
  GPR(src2, sz, Zero) = GPR(src2, sz) + sz
} else {
  GPR(src1, sz, Zero) = GPR(src1, sz) - sz
  GPR(src2, sz, Zero) = GPR(src2, sz) - sz
}
```

**Typical Usage**

Translate x86 string inst which has two counters.

### 2 operands

#### [TODO] bswap

#### [TODO] clz, clz_f

#### [TODO] ctz, ctz_f

#### mov

**Type**

IntAluOp

**Mnemonic**

```
mov dest, src
```

**Operation**

[TODO] add extension mode

```
GPR(dest, sz, Merge) = GRR(src, sz)
```

#### mov_i

**Type**

IntAluOp

**Mnemonic**

```
mov_i dest, imm
```

**Operation**

```
GPR(dest, sz, ex) = IIMM(imm)
```

#### [TODO] neg, neg_f

#### [TODO] not, not_f

#### [TODO] ld

#### [TODO] st

#### callrel, callrel_i

**Type**

IntAluOp

**Mnemonic**

```
callrel dest, src
callrel_i dest, imm
```

**Operation**

Call relative to pc with offset `src` or `imm`.
The return address is stored in `dest`.

#### callabs, callabs_i

**Type**

IntAluOp

**Mnemonic**

```
callabs dest, src
callabs_i dest, imm
```

**Operation**

Call address `src` or `imm`.
The return address is stored in `dest`.

#### jrelc, jrelc_i

**Type**

IntAluOp

**Mnemonic**

```
jrelc src, cond
jrelc_i imm, cond
```

**Operation**

Jump relative to pc with offset `src` or `imm`,
according to condition `cond`.

#### muls, muls_i, muls_f, muls_fi

**Type**

IntMultOp

**Mnemonic**

```
muls src1, src2
muls_f src1, src2
muls_i src1, imm
muls_fi src1, imm
```

**Operation**

Signed multiply `src1` and `src2`/`imm`.
The upper half of the product will be stored in an dedicated reg `ProdHi`,
the lower half of the product will be stored in an dedicated reg `ProdLow`.

#### loopcnt

**Type**

IntAluOp

**Mnemonic**

```
loopcnt counter, target
```

**Operation**

```
if (counter) {
  GPR(counter, sz, Zero) = GPR(counter, sz) - 1
} else {
  next_micro_pc = target
}
```

**Typical Usage**

Together with loopend, they can construct a loop
to translate x86 rep prefix.

#### step

**Type**

IntAluOp

**Mnemonic**

```
step src, flag
```

**Operation**

```
if (flag) {
  GPR(src, sz, Zero) = GPR(src, sz) + sz
} else {
  GPR(src, sz, Zero) = GPR(src, sz) - sz
}
```

**Typical Usage**

Translate x86 string inst which has a counter.

### 1 operand

#### ret

**Type**

IntAluOp

**Mnemonic**

```
ret src
```

**Operation**

Return to address `src`.

#### rdpc

**Type**

IntAluOp

**Mnemonic**

```
rdpc dest
```

**Operation**

Read pc and store it to `dest`.

#### jrel, jrel_i

**Type**

IntAluOp

**Mnemonic**

```
jrel src
jrel_i imm
```

**Operation**

Jump relative to pc with offset `src` or `imm`.

#### jabs, jabs_i

**Type**

IntAluOp

**Mnemonic**

```
jabs src
jabs_i imm
```

**Operation**

Jump to address `src` or `imm`.

#### inc, inc_f

**Type**

IntAluOp

**Mnemonic**

```
inc dest
inc_f dest
```

**Operation**

```
GPR(dest, sz, ex) = GPR(dest, sz) + 1
```

#### dec, dec_f

**Type**

IntAluOp

**Mnemonic**

```
dec dest
dec_f dest
```

**Operation**

```
GPR(dest, sz, ex) = GPR(dest, sz) - 1
```

#### rdmull, rdmulh

**Type**

IntAluOp

**Mnemonic**

```
rdmull dest
rdmulh dest
```

**Operation**

Read `ProdLow`/`ProdHi` to `dest`.

#### loopend

**Type**

IntAluOp

**Mnemonic**

```
loopend target
```

**Operation**

```
next_micro_pc = target
```

**Typical Usage**

Together with loopcnt, they can construct a loop
to translate x86 rep prefix.

### 0 operand

#### invalid

#### nop

#### syscall

#### halt
