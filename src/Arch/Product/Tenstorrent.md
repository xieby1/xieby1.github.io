<div style="text-align:right; font-size:3em;">2024.03.12</div>

* [Tenstorrent unveils Grayskull, its RISC-V answer to GPUs](https://news.ycombinator.com/item?id=39658787)
  * 页面搜索CPU
    * > Been following this for a while b/c Jim Keller, but every time I look at the arch [1; as linked by other commenter] as someone who doesn't know the first thing about CPU/ASIC design it just looks sort of... "wacky"? Does anyone who understands this have a good explainer for the rationale behind having a grid of cores with memory and IFs interspersed between and then something akin to a network interconnecting them with that topology? What is it about the target workloads here that makes this a good approach?
      * [Hardware Overview](https://docs.tenstorrent.com/tenstorrent/v/tt-buda/hardware)
    * ... 有很多原理性的讨论
    * > Oh, so am I to read this right that the actual vector work being done here is not done via the RiscV [V]ector extension, but by a purely custom core?
    * > Yes, the RISC-V Vector extension would be absolutely overkill for an ML accelerator, and waste a lot of die space. Currently the cards need an x86_64 host, but they plan to replace that with their ascalon risc-v cpu, that supports the risc-v vector extension (rvv). So most compute is done by the accelerator cards, but for some things the host system steps in. There rvv can come in handy, because it's a lot more flexible.

Grayskull是many-core设计，每个核称作Tensix，注重NOC互联。

Tensix包含多个rv32i小核，用于控制FPU/SFPU。

FPU/SFPU是自研核，不是RISC-V V拓展。

目前Garyskull需要插到x86-64宿主机器上，未来计划使用自家的Ascalon RISC-V处理器做宿主机器。

TT-Metalium是低层次编程接口，TT-Buda是高层次编程接口。
