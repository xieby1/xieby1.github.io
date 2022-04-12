写在前面：

* hqemu用的是历史版本的qemu，目前看来hqemu和现今的qemu的框架是一样的，但是仍有不少不一样的地方。
* 2020.4.23 😱😱😱hqemu用的qemu还不支持64位的mips，对比hqemu和当今qemu的`tcg/mips/tcg-target.h`的定义，所以讲道理hqemu在目前的龙芯平台是用不了的咯。


<div style="font-size:3em; text-align:right;">2020.4.16</div>

## 从TCG到LLVM

我将TCG到LLVM的过程分为3个部分：翻译、执行、优化。翻译和执行完全是按照qemu的框架里来的，优化的部分就涉及到了hqemu自己创新的多线程协调。接下来主要是通过代码框图来展示TCG到LLVM的这3个部分。

### 翻译

翻译过程使用的是qemu的框架详细可以去看看qemu的代码框图。hqemu在qemu的tcg翻译框架上添加了自己的tcg指令hotpatch用于插桩相关代码。

2020.4.20

**将guest代码翻译成tcg**的代码框架，

![tcg_to_llvm_tran_0-formatted](pictures/tcg_to_llvm_tran_0-formatted.svg)

**将tcg翻译成本地码**的代码框架，

![tcg_to_llvm_tran_1-formatted](pictures/tcg_to_llvm_tran_1-formatted.svg)

### 执行

插桩函数`helper_NET_predict`执行过程，

![tcg_to_llvm-formatted](pictures/tcg_to_llvm_exec-formatted.svg)

需要注意的是单优化线程（HYBRIDS）的模式直接在helper函数里调用`GenTrace`，而多优化线程模式（HYBRIDM）是在优化线程中去调用的`GenTrace`，`GenTrace`的内容如下。

### 优化

<div style="font-size:3em; text-align:right;">2020.4.20</div>

![tcg_to_llvm_2-formatted](pictures/tcg_to_llvm_opt-formatted.svg)

2020.4.30

其中`CreateSession(...)`中做了诸多变量的初始话，其中通过调用`CreateJIT()`函数来初始化JIT。`CreateJIT()`代码框图如下，

![CreateJIT-formatted](pictures/CreateJIT-formatted.svg)

hqemu定义的`EventListener`这个类的一些方法让人十分疑惑。`EventListener`的继承了LLVM的`JITEventListener`类，但是`EventListener`出现了自己的定义的函数`NotifyFunctionEmitted`，这个是在哪里会被用到LLVM的文档完全没写，**但是**LLVM的源码`llvm/inllude/llvm/ExecutionEngine/JITEventListener.h`又提到了一句

> NotifyObjectEmitted - Called after an object has been successfully emitted to memory.  NotifyFunctionEmitted will not be called for individual functions in the object.

所以`NotifyObjectEmitted`使用宏拼出来的吗？？？

大概是在网上找到了答案[LLVM 2.7版的JIT类](http://legup.eecg.utoronto.ca/doxygen/classllvm_1_1JIT.html)（现在已经被MCJIT类取代了）。所以这个`NotifyObjectEmitted`大概是不再使用的历史版本的接口。

上面的`CreateJIT`是创建JIT的过程，接下来是运行JIT的过程，即`IRFactory::Compile`函数的工作，





<div style="font-size:3em; text-align:right;">2020.4.28</div>

## hqemu移植到xqm的编译问题

1. qemu版本不同头文件里的一些定义发生变化；
2. xqm项目的一些语法和变量名在cpp编译器里会有问题；

目前的解决方案是参考并修改hqemu的多线程优化框架，原hqemu的多线程优化框架如下（**注**：一个矩形框表示一个线程），

![hqemu_arch-formatted](pictures/hqemu_arch-formatted.svg)

新的修改的框架如下，

![new_arch-formatted](pictures/new_arch-formatted.svg)