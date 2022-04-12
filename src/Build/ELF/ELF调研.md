<div style="text-align:right; font-size:3em;">2019.9.5</div>
# 前沿

在Wine的`loader/preloader.c`开头注释里提示可以看linux内核代码`fs/binfmt_elf.c`来学习ELF格式，于是从[linux kernerl achives](https://www.kernel.org/)下载了目前稳定版（5.2.11）的linux内核。

`fs/binfmt_elf.c`开头的注释提示我ELF格式可以查阅《UNIX SYSTEM V RELEASE 4 Programmers Guide: Ansi C and Programming Support Tool》，要收费的~~垃圾~~。还不如[Wikipedia上引用的内容](https://en.wikipedia.org/wiki/Executable_and_Linkable_Format#References)，

* Tool Interface Standard (TIS) [Executable and Linking Format (ELF) Specification](http://refspecs.linuxbase.org/elf/elf.pdf) Version 1.2 (May 1995)
* [System V Application Binary Interface](http://www.sco.com/developers/devspecs/gabi41.pdf) Edition 4.1 (1997-03-18)

# [Executable and Linking Format (ELF) Specification](http://refspecs.linuxbase.org/elf/elf.pdf)

### Book I

**注**：Book I介绍的全是通用结构的定义，至于这些结构被操作系统如何运用的，需要看Book III

这是一种叫ELF的object文件格式，ELF主要有3类，

1. **relocatable**，用于链接，链接后可以生成executable或shared；
2. **executable**，字面意思；
3. **shared**，有2种用法，
   1. 和relocatable链接，
   2. 和executable动态链接。

![1_1_object_file_format](pictures/1_1_object_file_format.svg)

<div style="text-align:right; font-size:3em;">2019.9.6</div>
### Book III

# [Study of ELF loading and relocs](http://netwinder.osuosl.org/users/p/patb/public_html/elf_relocs.html)

基本把上面那个文件[Executable and Linking Format (ELF) Specification](http://refspecs.linuxbase.org/elf/elf.pdf)看了，还是不知道为什么helloworld在内存里的地址和elf中指定的地址不一样，但是wine64的是一样的。于是在wikipedia上找到了这篇文章。

