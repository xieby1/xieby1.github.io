**注**：@时间均为文件创建时间。

这是关于x86tomips的文档的一个伪说明。x86tomips的文档在其仓库里的`docs/`文件夹下，本文档放在`docs/`才能让链接正常。

## 图

### [work.vsd](./work.vsd)

粗略划分dbt5的任务。

### [signal structure.png](./signal structure.png)

信号数据结构。

## [Flag_Pattern设计文档](./Flag_Pattern设计文档.doc)@2010.6.5

[Flag_Pattern标志位模式优化详细设计文档](./Flag_Pattern标志位模式优化详细设计文档.doc)是该文档的一个历史版本。

针对x86标志寄存器的模块化的优化。**注**：优化都是在翻译过程中被调用的，优化不会在解释中被调用。

## [流程图草稿](./120201流程图草稿/)@2012.2.1

该文件夹的图均出现在⭐️[dbt5总体设计文档](./dbt5总体设计文档.docx)@2012.2.12中。

## [对dbt5的建议](./120201 对dbt5的建议.docx)@2012.2.1

**方法上值得一个团队注意的地方**：

 * 需要良好的报错和警告体系（assert的用法？）
 * 需要详细的注释和文档（可以试试doxygen？）

**他们的分工**：

装载loader、x86环境env、解释器interpreter、系统调用syscall、x86中间表示ir1、回滚和比较rollback&compare、杂misc 。

**注**：原文中有提及具体负责每个模块的人名，此处省略。

## [dbt5设计和模块划分](./120202 dbt5设计和模块划分.pptx)@2012.2.2

**将原文的list变成表格即如下**：

| 模块             | 子模块                                                       |
| ---------------- | ------------------------------------------------------------ |
| **main**         | **option**, **error**, mem_alloc                             |
| **loader**       | **load**, sym_reloc                                          |
| **exec**         | **env**, signal, **rollback_compare**                        |
| **interpreter**  | 无                                                           |
| translator       | reg_alloc, run_native, code_cache                            |
| **syscall**      | 无                                                           |
| **ir1**          | **disasm**, **inst**, **tb**, func                           |
| ir2              | disasm, asm, reorder                                         |
| **optimization** | **flag_reduction**, flag_pattern, shadow_stack, misalign_handling |
| wrapper          | 无                                                           |
| static           | 无                                                           |
| debug            | 无                                                           |
| dbttool          | 无                                                           |


## [dbt5代码规范](./120207 dbt5代码规范.pptx)@2012.2.7

一个团队的代码风格应该在开始写项目前进行统一。

## [loader模块设计文档](./loader模块设计文档0212.doc)@2012.2.12

加载器的设计。需要识别x86代码是否需要动态，若需要，则需要翻译或解释执行x86的动态链接器（interp）。这里有两个“解释器”，注意区分，其英文都为“interpreter”，

1. **dbt5的解释器**

   解释执行IR1代码。

2. **linux的解释器**

   即是动态链接器，用于解析一个程序所需的动态链接文件、寻找并加载这些动态链接文件，然后运行程序，相见`ld.so`的manual page。

## [translator设计](./translator.pptx)

除了一张流程图（在[dbt5总体设计文档](./dbt5总体设计文档.docx)中出现过了），其他全是代码截图，参考意义不大。~~开篇一张图，内容全靠猜？~~

## 🧐[Rollbacker&Checker设计文档](./Rollbacker&Checker.doc)@2012.2.12

为了分析更加方便而设计的回滚机制。回滚粒度为TB。

> 在用户级别的角度看，Linux程序的执行环境是由寄存器状态、进程空间、IO资源组成，如果能够记录下这些信息的修改，就可以回滚到之前的程序执行状态。
>
> 而从指令的层面看，上面的修改可将指令分为两大类：int 0x80和其他指令。

>实现的难易程度和先后顺序应该是：寄存器回滚->内存回滚->IO资源回滚。

## ⭐️[dbt5总体设计文档](./dbt5总体设计文档.docx)@2012.2.12

**该文档介绍了dbt5总体设计概念和7个子模块。**

1. 控制模块
2. 文件装载模块
3. 反汇编模块，定义**IR1**
4. 解释模块（使用IR1）
5. 翻译模块，定义**IR2**（使用IR1）
6. 本地码执行模块
7. 优化模块

## [寄存器分配设计文档](./寄存器分配设计文档.docx)

寄存器分配方案。

## [register allocation](./120221 register allocation.pptx)@2012.2.21

x86和mips的调用ABI的简单比较。

## [multi-threading](./multi-threading.pptx)@2012.2.26

多线程的问题及解决方案。到目前为止我们（龙芯实验室）还没认真探索的地方。

## [flag pattern](./flag pattern.pptx)@2012.3.2

一个简短的展示标志位模式的幻灯片，其内容暂不理解。

## [各模块分配.xlsx](./各模块分配.xlsx)@2012.4.5

拓展优化已有的工作。因此这里的工作相比建立一个可以运行的二进制翻译系统更有创新性（虽然都是学界已经提及过的内容）。所以有必要找到相关论文仔细研读，例如，

1. shadow stack
2. 信号处理
3. 函数翻译（函数边界）
4. switch-case的识别和转换

## [本地码查表、链接等.pptx](./本地码查表、链接等.pptx)2012.4.9

## [符号扩展.pptx](./符号扩展.pptx)@2012.4.21

指令的原操作数大多需要符号扩展，目前的方案及改进方案。

## [手工翻译.pptx](./手工翻译.pptx)@2012.5.21

~~开篇一张图，内容全靠猜？~~

## [dbt5性能](./dbt5性能.xlsx)@2012.7.7

一张dbt5在测试用例上的得分表。

## [debug](./debug.pptx)@2012.8.13

debug遇到的错误及应对方案。

