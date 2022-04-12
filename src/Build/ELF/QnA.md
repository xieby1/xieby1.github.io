<div style="text-align:right; font-size:3em;">2020.09.28</div>

## 链接多个静态库

**起因**：我的Libbreak依赖于libcapstone.a我希望链接时暴露给用户的只有libbreak.a，而不需要让用户再添加链接libcapstone.a的选项。有没有办法做到？

**结论**：目前没有现成的软件能完成这个工作，不过可以试着用ar的thin archive功能。

这个提问和我的想法一致[Linking static libraries to other static libraries](https://stackoverflow.com/questions/2157629/linking-static-libraries-to-other-static-libraries)，但是他还没找到很好的解决方法。但不过有人提到ar的thin archive的功能。既然libbreak是内嵌在别的代码的源码中的，那么break.o和libcapstone.a等thin archive指向的文件都会保留，那么thin archive应该算是一个比较好的解决方案吧。

相近的问题，链接动态链接库就没问题[Linking a shared library with another shared lib in linux](https://stackoverflow.com/questions/19424494/linking-a-shared-library-with-another-shared-lib-in-linux)。

<div style="text-align:right; font-size:3em;">2020.09.03</div>

## [ABORTED] EXEC/DYN，Interp，PIC的关系

**详细**：

EXEC/DYN指ELF文件的类型，可执行文件和动态链接文件

Interp是ELF文件里制定的动态链接器

PIC是位置无关代码（Position Independent Code），PIE（Position Independent Executable）

问题是：

* 动态链接文件（DYN）的代码一定是位置无关代码（PIC）吗
* 可执行文件（EXEC）一定不需要动态链接器吗

---

参考：[distinguish shared objects from position independent executables](https://stackoverflow.com/questions/16302575/distinguish-shared-objects-from-position-independent-executables)，

* 值得借鉴的是*a PIE executable is a shared object.*，隐含地说shared object不一定是位置无关的。这个**回答有个纰漏**，其实PIE不一定需要动态链接器，如`gcc -static-pie`是动态链接文件（DYN）但是不需要动态链接器，[DONE]这是怎么实现的呢？`scrt1.o`发挥的作用，参考：[What's the usage of Mcrt1.o and Scrt1.o?](https://stackoverflow.com/questions/16436035/whats-the-usage-of-mcrt1-o-and-scrt1-o)，简单地说就是有`*crt*.o`将_start（ELF的入口）引导到main的。

## [DONE] ELF的低于segments最低地址的内存不会被使用吗

和QEMU相关

**详细**：低于segments（program headers所指）的最低地址的内存是不会被分配（mmap）的吗？`linux-user/elfload.c: 2405 probe_guest_base`，保证guest的elf的program header最低地址不会低于host的最低可分配地址。

2020.9.9

**结论**：会，但是qemu为了尽可能让guest>=host的用户程序可以运行。**注**：记录于Diary/2020/09/03。

**答**：这大概就是用户态guest>=host 64/64, 32/32, 64/32能够运行运行的原因，为了将guest内存空间尽可能地折叠到host用户空间。

<div style="text-align:right; font-size:3em;">2020.8.7</div>

## 如何定位动态链接库里的函数、变量的位置

**详细**：完全stripped的动态链接库可以被正常的动态链接，而动态链接需要知道函数、变量的位置，这是如何做到的？

**结论**：符号信息被哈希了，放在ELF文件的`.hash` section里。

**答**：参考[1997.SYSTEM_V_APPLICATION_BINARY_INTERFACE_Edition_4.1.pdf](../../../BOOKS/ELF/1997.SYSTEM_V_APPLICATION_BINARY_INTERFACE_Edition_4.1.pdf)的5-13 Dynamic Linker这一章节，

> The `.hash` section with type `SHT_HASH` holds a symbol hash table.

这样的设计能够很好的保证商业秘密。

### [ABORT] 如何通过hash定位

