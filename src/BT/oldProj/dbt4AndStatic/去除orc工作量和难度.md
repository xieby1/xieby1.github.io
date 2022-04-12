# ORC的CGIR

在`SBT_TU::Translate()`调用`SBT_TU::Ir1_To_Cgir()`之后dbt static的优化和生成MIPS代码完全由ORC提供的各种功能完成，因为orc相关的.so文件缺失而缺失的代码量见下面[ORC .so提供的功能](#ORC .so提供的功能)。而在调用`SBT_TU::Ir1_To_Cgir()`的代码是有dbt自己实现的是有源码的。在dbt代码和orc代码之间起衔接的作用的`SBT_TU::Ir1_To_Cgir()`实现了将IR1转换为CGIR，

* IR1，本质是用C++类包装好的x86指令；dbt static里一共收录了610条x86指令
* CGIR是ORC中间表示的最底层，ORC有多层中间表示，每一层都有诸多特有的优化措施，CGIR是最接近机器语言的一层。大概用到了500多条CGIR指令，如下所述

CGIR的操作码见`orc_include_hier/targia32_godson_nodebug/targ_info/topcode.h`。其中除了CGIR新增的指令还包含了诸多mips和alpha的指令。CGIR指令操作码使用数量，使用/总数，统计误差个位数，如下，

| CGIR新增                    | MIPS    | ALPHA   |
| --------------------------- | ------- | ------- |
| 65/759，65条和cmp相关的指令 | 230/320 | 278/278 |

`SBT_TU::Ir1_To_Cgir()`总体就是个超大的switch case（1246~3614），把IR1翻译成CGIR。

所以总的来说修改`SBT_TU::Ir1_To_Cgir()`工作量是把600多条IR1重新精确地转到新的中间表示去，应该也是10^2量级的指令数量，比如LLVM。LLVM IR和CGIR都是接近RISC机器语言的中间表示，所以需要我们自己写一个`SBT_TU::Ir1_To_Llvmir()`的函数来完成这一工作。LLVM IR相比纯的机器语言新增了“类型”的概念，因此可以做的优化更多一些。尽管反汇编x86代码不能得到数据类型，但是函数和数据一定程度上仍然可以区分，所以LLVM IR的“类型”仍然有效。LLVM IR的优势很简单：有活力。

# ORC .so提供的功能

这一部分所涉及的所有代码都需要移除。

## 内存分配和回收

http://ipf-orc.sourceforge.net/ORC-style.htm

`orc_include_hier/common/util/mempool.h`开头的注释

`orc_include_hier/common/util/cxx_memory.h`开头的注释

### 变量

初始化不在源码

* MEM_local_nz_pool, MEM_src_nz_pool, MEM_pu_nz_pool, MEM_phase_nz_pool, SBT_MEM_pool, MEM_local_pool, MEM_src_pool, MEM_pu_pool, MEM_phase_pool

### 函数

`CXX_NEW...`/`CXX_DELETE...`这俩的原理还不懂，比如，

```c++
#define CXX_NEW(constructor, mempool)                   \
  (_dummy_new_mempool = mempool,                        \
   new constructor)
```

🤔🤔🤔为啥给一个MEM_POOL变量赋值一下再new和直接new不同呢？？？

* MEM_Initialize, MEM_POOL_Alloc_P, MEM_POOL_Realloc_P, MEM_POOL_Push_P, MEM_POOL_Push_Freeze_P, MEM_POOL_Pop_P, MEM_POOL_Pop_Unfreeze_P, MEM_POOL_Set_Default, MEM_POOL_FREE, MEM_POOL_Delete, MEM_POOL_Initialize_P, 

### 修改方法

删掉所有相关函数和变量，参考`cxx_memory.h`，将`CXX_NEW`/`CXX_DELETE`替换为`new`/`delete`

## TN（操作数）

### 变量

#### 初始化在源代码里，初始化代码不在

外部变量声明@`translator/translator.h`，初始化@`source/x86/c_file/c_file.cpp`：

* reg_map

* R0_TN~T31_TN除了R3、R11、R19、R28
* F0_TN~F31_TN全部
* ENV_TN
* C0_TN~C17_TN, C20_TN, C24_TN, C30_TN, C31_TN, C32_TN, C33_TN, C48_TN, C56_TN, C63_TN, C64_TN, C68_TN, C80_TN, C128_TN, C8000_TN
* CC0_TN, CD7_TN, CF0_TN, CFC_TN, CFE_TN, CFF00_TN, CFFFF_TN, CFF_TN, CN1_TN, CN2_TN, CN4_TN, CN8_TN, CN9_TN, CN17_TN, CN32_TN, CN33_TN, LINK_TN, TOP_TN, c100_TN
* cEAX_TN, cEBP_TN, cEBX_TN, cECX_TN, cEDI_TN, cEDX_TN, cEFLAG_OPND, cENV_TN, cESI_TN, cESP_TN, cGP_TN, cINFO_IR2_OPND, cINFO_TN, cMASK_CF, cMASK_DF, cMASK_OF, cMASK_PF, cMASK_SF, cMASK_ZF, cRA_TN, cRESERVE_CF, cRESERVE_DF, cRESERVE_OF, cRESERVE_PF, cRESERVE_SF, cRESERVE_ZF, cSPILL_TN, cSP_TN, cTOP_MASK, cTOP_TN, cTemp_freg1, cTemp_freg2, cSSSP_TN
* `__ST`, `__ST1`
* XMM
* INT_PARAMETERS, FP_PARAMETERS
* RET_VALS

外部变量声明@`orc_include_hier/cg/tn.h`，初始化`source/x86/c_file/c_file.cpp`：

* Last_TN

外部变量声明@`orc_include_hier/cg/tn.h`，未找到初始化：

* Zero_TN, FP_TN, SP_TN, RA_TN, Ep_TN, GP_TN, Pfs_TN, LC_TN, EC_TN, True_TN, FZero_TN, FOne_TN, HI_TN, LO_TN, AT_TN

外部变量声明@`orc_include_hier/cg/cg_internal.h`，初始化`source/x86/c_tu/c_tu.cpp`

* TN_To_PREG_Map, PREG_To_TN_Array, PREG_To_TN_Mtype

### 函数

* `TN *Build_Dedicated_TN ( ISA_REGISTER_CLASS rclass, REGISTER reg, INT size)`初始化TN
* `TN *Gen_Literal_TN ( INT64 val, INT size )`初始化常数TN
* `TN *Gen_Unique_Literal_TN (INT64 ivalue, INT size);初始化某种类型的TN`
* TN_MAP_Create 

### 修改方法

## ORC环境

ORC_Initialize(), ORC_Finalize()里涉及的函数和变量

### 变量

#### 初始化在源代码里，初始化代码也在源代码里

* Target_ABI, Target_ISA, Target

### 函数

* Init_Operator_To_Opcode_Table, Initialize_Targ_Info, REGISTER_Begin, BE_symtab_initialize_be_scopes, Initialize_Symbol_Tables, New_Scope, orc_CG_Init
* BE_symtab_free_be_scopes

### 修改方法

单纯的移除，之后再因地制宜地换上替代框架（比如LLVM）。

## OP

### 变量

### 函数

* Mk_OP, OPS_Append_Op

## symtb

### 变量

未在源码中初始化

* File_info, Pu_Table, St_Table, Ty_tab, Ty_Table, Fld_Table, Tylist_Table, Arb_Table, Str_Table, Tcon_Table, Initv_Table, Inito_Table, Preg_Table, St_Attr_Table, Label_Table, Blk_Table, Current_scope, Current_pu
* Scope_tab

## TU

诸多TU需要的函数

## BB

Basic Block是ORC提供的用来装CGIR的。

## 其他

### 变量

* Stack_Offset_Adjustment
* Cur_PU_Name, PU_BB_Count
* spill_Int_Mtype, Spill_Float_Mtype
* GRA_loop_splitting

### 函数

* xstats的Initialize_Stats
* Initialize_Special_Global_Symbols
* BBlist_Find_BB

# 非ORC相关

## 有声明有定义却出了问题

有点奇怪，明明源码里是有这些函数的定义的。稍后在来解决。

### 变量

### 函数

* SBT_INSTR的函数
* Schedule_For_Pattern
* translator/convert_float_arith1.cpp: Init_Saving_Regs
* SBT_FILE::Rename_Table_Init()
* SBT_S2D_FUNC_INFO_TABLE的函数
* SBT_S2D_SO_DEP_FUNC_TABLE的函数

## 其他

### 变量

#### 初始化在源代码里，初始化代码不在

初始化@`source/x86/c_file/c_file.cpp`：

* S2D_SO_DIR
* X86_LIB_DIR

#### 初始化不在源代码里

虽然可以通过命令行（c_program.cpp），但该命令是非必须的，默认的初始化值在so里

* CLAMP_START_ADDR, CLAMP_END_ADDR
* specify_s2ddir, specify_x86lib
* Ua_Exception_Space, FP_Exception_Enable, Switch_Case_Disable