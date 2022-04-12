<div style="text-align:right; font-size:3em;">2020.08.25</div>

## [OPEN]VLIW适合二进制翻译吗

之前一直理解VLIW适合任何二进制翻译软件，但是不知道为什么。今天看到关于daisy的论文提到VLIW适合翻译静态调度的架构的用户程序，所以VLIW适合二进制翻译是有大前提的咯？

参考daisy论文的综述，

> We describe a VLIW architecture designed specifically as a target for dynamic compilation of an existing instruction set architecture. This design approach offers the simplicity and high performance of statically scheduled architectures, achieves compatibility with an established architecture, and makes use of dynamic adaptation.

## QEMU能处理自修改当前TB的代码吗？

这个问题的难点在于当前TB已被执行了一部分，qemu是否能成功处理？