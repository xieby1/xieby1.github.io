2020.4.3

TCG->IR的函数声明在`llvm/include/llvm-opc.h`，用宏完成如下，

```c
    /* QEMU TCG IR to LLVM IR converion routines. */
#define DEF(name, oargs, iargs, cargs, flags) void op_ ## name(const TCGArg *);
#include "tcg-opc.h"
#undef DEF
```

定义在`llvm/llvm-opc.cpp`里。

2020.4.8

这个版本的qemu linux user的框架

* cpu_exec(...) @cpu-exec.c
  * tb_find_fast(...)
    * tb_find_slow(..)
      * tb_gen_code(...) @translate-all.c
        * tcg_gen_code(...) @tcg.c
  * cpu_tb_exec(...) @cpu-exec.c

hqemu在main.c调用了llvm_init()，并没有fork出新的进程。追踪热点路径是直接在qemu的里的tcg_out_hotpatch(...)函数里往热点路进里插桩了hqemu自己的统计函数helper_NET_profile(...)。

热点信息如何触发优化的流程暂时未知。优化大概是从tracer.cpp里的OptimizeBlock和OptimizeTrace开始，

* OptimizaeBlock(CPUArchState *env, TranslationBlock *TB) @tracer.cpp
  * LLVMEnv::OptimizaBlock(env, Request(TB)) @llvm.cpp
    * LLVMTranslator::GenBlock(env, OptimizationInfo *) @llvm-translator.cpp
      * TraceBuilder::ConvertTotCGIR(env)
      * TraceBuilder::ConvertToLLVMIR() @llvm-opc.cpp

2020.4.9

想弄明白的事情，在llvm-opc.cpp里的

* hqemu的entrynode在哪里初始化的，entrynode里是不是生成了第一个currBB？

  

* hqemu的创建Block时需要的Func是在哪里生成的？（ConverToLLVMIR()调用了CreateBlock()）

  * 在llvm-opc.cpp的IRFactory::CreateFunction()->Function::Create(FuncTy, LinkageType, Name, Module)
    * LinkageType的用处是啥？反正也不会经过链接阶段，无脑写ExternalLinkage就好吧。
    * Module实例（即是对应LLVM对IR文件的包装）在哪里生生成的？
      * 在llvm-opc.cpp的IRFactory::CreateJIT()里。
        * 在Translator里生成的Mod，在llvm-translator.cpp里LLVMTranslator::InitializeModule()。通过llvm的接口ParseIRFile(...)，这个接口在include文件夹里llvm/IRReader/IRReader.h里

* LastInst的用处

  * 最后一条指令，方便所有新增的指令插入到末尾（最后一条指令的前面）。

* 为什么要建立CFG？即为什么需要GraphNode（hqemu概念）？

2020.4.13

`llvm/llvm.cpp`: WorkerFunc

2020.4.14

`llvm.cpp`：OptimizeTrace(CPUArchState *env, OptRequest Request)向待优化的队列里添加；

`llvm.cpp`：WorkerFunc(void* argv)从队列里取，并发给Translator工作。

2020.4.15

OptimizeBlock和OptimizeTrace的联系和区别？

* `tracer.cpp`: tracer_exec_tb(...)
  * SingleBlockTracer::Record(...)
    * OptimizeBlock(...)



* tcg_gen_hotpatch(uint32_t arg1, uint32_t arg2) 

  // 这个函数生成tcg，然后tcg_out_op生成本地码。tcg_gen和tcg_out没有调用关系。

* tcg_out_op(TCGContext *s, TCGOpcode opc, const TCGArg *args, const int *const_args)的case INDEX_op_hotpatch //这个是hqemu添加的

  * tcg_out_hotpatch(TCGContext *s, uint32_t is_user, uint32_t emit_helper)

    // 会生产调用helper_NET_predict函数的代码，在运行本地码时会调用到helper_NET_predict函数

* helper_NET_predict(CPUArchState *env, int id)

  * NETTracer::Predict(TranslationBlock *tb) // 🤔<span style="color: red;">这个tb是如何从qemu获取到的？</span>
    * `tracer.cpp`: OptimizeTrace(...)
      * LLVMEnv::OptimizeTrace(...)

