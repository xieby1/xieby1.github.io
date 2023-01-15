# Fusion

TODO: 分类&命名

* 间接寻址模式
  * riscv: 仅有[reg]
  * arm: pre-index, post-index
* 长立即数加载
  * riscv: 20bit + 12bit
* 操作数+左右移
  * riscv
* 乘法、除法的高低部分
  * riscv

## X86

https://stackoverflow.com/questions/56413517/what-is-instruction-fusion-in-contemporary-x86-processors

> * Macro-fusion decodes cmp/jcc or test/jcc into a single compare-and-branch uop.
> * Micro-fusion stores 2 uops from the same instruction together so they only take up 1 "slot" in the fused-domain parts of the pipeline.

## ARM

### 2019.cortex_a77.pdf

除了加密指令外，均为条件跳转

aarch64

| Head                | Tail            |
|---------------------|-----------------|
| CMP/CMN (immediate) | B.cond          |
| CMP/CMN (register)  | B.cond          |
| TST (immediate)     | B.cond          |
| TST (register)      | B.cond          |
| BICS (register)     | B.cond          |
| NOP                 | Any instruction |

aarch32 & aarch64

| Head | Tail   |
|------|--------|
| AESE | AESMC  |
| AESD | AESIMC |

### 2020.neoverse_n2.pdf

aarch64

| Head                | Tail            |
|---------------------|-----------------|
| CMP/CMN (immediate) | B.cond          |
| CMP/CMN (register)  | B.cond          |
| CMP (immediate)     | CSEL            |
| CMP (register)      | CSEL            |
| CMP (immediate)     | CSET            |
| CMP (register)      | CSET            |
| TST (immediate)     | B.cond          |
| TST (register)      | B.cond          |
| BICS (register)     | B.cond          |
| NOP                 | Any instruction |

aarch32 & aarch64

| Head                | Tail   |
|---------------------|--------|
| AESE                | AESMC  |
| AESD                | AESIMC |
| CMP/CMN (immediate) | B.cond |
| CMP/CMN (register)  | B.cond |
| TST (immediate)     | B.cond |
| TST (register)      | B.cond |
| BICS (register)     | B.cond |

## RISC-V

### 2022.fuse_mem.singh.micro.0.md

这篇文章做的融合，需要使用双GPR写口
包含最后两行，也包含不连续的内存访问，不连续的指令。
双写口的通用性个人感觉不强。

为了正确性，需要新增不少逻辑，见Figure 7。

| Head                     | Tail                     |
|--------------------------|--------------------------|
| add rd, rs1, rs2         | ld rd, 0(rd)             |
| lui rd, imm[31:12]       | addi rd, rd, imm[11:0]   |
| ld rd, imm(rs1)          | add rs1, rs1, 8          |
| auipc t, imm20           | jalr ra, imm12(t)        |
| slli rd, rs1, {1,2,3}    | add rd, rd, rs2          |
| mulh[[S]U] rdh, rs1, rs2 | mul rdl, rs1, rs2        |
| slli rd, rs1, 32         | srli rd, rd, 29/30/31/32 |
| div[U] rdq, rs1, rs2     | rem[U] rdr, rs1, rs      |
| lui rd, imm[31:12]       | ld rd, imm[11:0](rd)     |
| auipc rd, symbol[31:12]  | ld rd, symbol[11:0](rd)  |
| **ld rd1, imm(rs1)**     | **ld rd2, imm+8(rs1)**   |
| **st rs2, imm(rs1)**     | **st rs3, imm+8(rs1)**   |


### 2017.bt_fuse_riscv_x86.clark.carrv.0.pdf

二进制翻译risc-v => x86-64，静态寄存器映射，和qemu比，不太行的样子。

做了N到1的融合，
宏指令融合，感觉没有微码融合带来的性能提升更高？

| Head                | Middle                   | Tail               |
|---------------------|--------------------------|--------------------|
| AUIPC r1, imm20     |                          | ADDI r1, r1, imm12 |
| AUIPC r1, imm20     |                          | JALR ra, imm12(r1) |
| AUIPC ra, imm20     |                          | JALR ra, imm12(ra) |
| AUIPC r1, imm20     |                          | LW r1, imm12(r1)   |
| AUIPC r1, imm20     |                          | LD r1, imm12(r1)   |
| SLLI r1, r1, 32     |                          | SRLI r1, r1, 32    |
| ADDIW r1, r1, imm12 | SLLI r1, r1, 32          | SRLI r1, r1, 32    |
| SRLI r2, r1, imm12  | SLLI r3, r1, (64-imm12)  | OR r2, r2, r3      |
| SRLIW r2, r1, imm12 | SLLIW r3, r1, (32-imm12) | OR r2, r2, r3      |
