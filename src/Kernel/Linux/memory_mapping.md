<div style="text-align:right; font-size:3em;">2021.08.31</div>

syscall的讲解`linux/Documentation/process/adding-syscalls.rst`

<div style="text-align:right; font-size:3em;">2021.08.30</div>

（chp15）《linux device driver》不讲page table的操作，需要的话去看《Understanding The Linux kernel》。

两种方式building Page Table:

* `remap_pfn_range()`
* `nopage()`，VMA提供的方法

<div style="text-align:right; font-size:3em;">2021.08.26</div>

参考`2005.linux_device_drivers_3rd.pdf`第15章。

内核中涉及的集中地址类型：

* User virtual addresses：用户程序-操作系统
* Physical addresses：处理器-物理内存
* Bus addresses：（2021.8.30：我觉得书说的不准，应该是处理器-外设总线，毕竟IOMMU是需要CPU特殊指令支持，就像MMU是由ld/st指令支持。）外设总线(peripheral bus)-物理内存。大部分情况下：和Physical addresses一致。若存在IOMMU，可以重新映射外设总线和物理内存的地址。
* Kernel logical addresses：内核内部-物理内存。该地址映射到部分或全部物理内存，和物理地址可能会有常数偏移。一定是一一映射。
  * `__pa()`：logical address => physical address
  * `__va()`：physical address => logical address, only for low-memory pages
* Kernel virtual addresses：内核内部-物理内存。比如`vmalloc()`和`kmap()`返回的地址。

logical address和virtual address的区别参考[2012.1.3 | stack overflow: Difference between Kernel Virtual Address and Kernel Logical Address?](https://stackoverflow.com/questions/8708463/difference-between-kernel-virtual-address-and-kernel-logical-address)。在x86平台logical和virtual都使用虚存期间（MMU）完成。