<div style="text-align:right; font-size:3em;">2022.03.03</div>

> downstream tools can distinguish LLVM `load` and `store` instructions from accesses to the modeled program's memory

intrinsics将guest访存和host访存区分开来。

Q：内存操作数是如何展开的？

<div style="text-align:right; font-size:3em;">2022.03.07</div>

## SEM

### SEM

```cpp
template <typemane D, typename S>
ALWAYS_INLINE __attribute__((flatten)) static Memory *MOV(
    Memory *memory, State &state, D dst, const S src) {
    WriteZExt(dst, Read(src));
    return memory;
}
```

### WriteZExt

去掉了do {...}while (false)

```cpp
// WriteZExt
Write(dst, ZExtTo<decltype(dst)>(Read(src));

// Write
static_assert(sizeof(typename BaseType<decltype(dst)>::BT) == sizeof(Read(src)),
    "Bad write!");
memory = _Write(memory, dst, (Read(src));

// _Write: X86 specific!
???
./include/remill/Arch/X86/Runtime/Operators.h
签名不匹配啊！？
```

## ISEL

### DEF_ISEL

MOV是tpl_func, tpl是什么的简写？

```cpp
DEF_ISEL(MOV_MEMv_IMMz_32) = MOV<M32W, I32>;
```

### ISEL

```cpp
extern "C" constexpr auto ISEL_MOV_MEMv_IMMz_32 [[gnu::used]] = MOV<M32W, I32>;
```

### Types

类型 include/remill/Arch/X86/Runtime/Types.h

```cpp
typedef MnW<uint32_t> M32W;
```

## bc

llvm-dis amd64.bc

## 明日TODO

* 查看`__remill_write_memory_32`在哪定义。
* 记录到sixu中。

<div style="text-align:right; font-size:3em;">2022.03.08</div>

## MAKE_RWRITE

```cpp
ALWAYS_INLINE static Memory *_Write(Memory *memory,
        MnW<uint32_t> op,
        uint32_t val) {
    return __remill_write_memory_32(memory, op.addr, val);
}
```

## 

lib/BC/InstructionLifter.cpp

* 147: generate pc
* LiftOperand(arch_inst, block, state_ptr, arg, op);
  * lib/BC/InstructionLifter.cpp: InstructionLifter::LiftAddressOperand
* 193: Memory 变量的处理
* 197: call the function that implements the instruction semantics

## eflags

符号计算生成的IR挺多的，怎么处理？

越反映本质，越简单越好。

* 拓展LLVM IR符号计算操作。不要膨胀那么多。

<div style="text-align:right; font-size:3em;">2022.03.09</div>

```bash
llvm-extract --glob <global> --func <func> --recursive <ir.ll/bc> -o <output.bc>
llc --view-isel-dags <output.bc>
```

<div style="text-align:right; font-size:3em;">2022.03.16</div>

为什么ISEL_PUNPCKHBW_MMXq_MEMq的dst操作数是指针？

看了寄存读写的类型RVnW和RnW都是指针类型的。
所以可以推断RW类型的寄存器都是指针吧。
（对于remill，clangd的跳转太垃圾了吧，
一方面原因事.cpp编译成.bc没有在compile_command.json中留下信息）

remill lift一条punpckhbw的例子

```bash
asm.sh "punpckhbw (%eax),%xmm5"
podman run --rm -it remill --arch amd64 --ir_out /dev/stdout --bytes 660F6828
```

运行gdb remill的环境

```bash
podman run --rm -it --cap-add=SYS_PTRACE remill-build
```