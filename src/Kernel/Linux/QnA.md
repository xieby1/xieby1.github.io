<div style="text-align:right; font-size:3em;">2021.10.19</div>

## [DONE] tlb中有不同的虚拟地址映射到物理地址会有问题吗？

2021.11.17: 不会，参考qemu vtlb方案。或者目前的体系结构中，访存顺序问题应该由应用程序考虑。

## TLB execption loop的含义

`2005.mips64_3.pdf`的4.11提到

猜测初始化TLB的时候要求在unmap区域。否则在mapped区域，tlb中若没有包含初始化TLB的代码所在页，则会循环发生TLB例外。

<div style="text-align:right; font-size:3em;">2021.09.23</div>

## [ABORT] LA内核`vmalloc`和`__get_free_page`分配的虚地址页表遍历不到？

见`~/Gist/lkm/va2pa/`

## [OPEN] 内核如何读写用户地址空间？

`copy_to/from_user`


<div style="text-align:right; font-size:3em;">2021.09.22</div>

## [DONE] 如何从源码生成linux-headers-xxx

自己编译的内核的linux-header指向源码，过大。有没有办法生成linux-headers-xxx？

参考[2018: stack exchange: How to create /usr/src/linux-headers-{version} files](https://unix.stackexchange.com/questions/270123/how-to-create-usr-src-linux-headers-version-files):

该方法有问题？Makefile会依赖源码

```bash
# 模块编译文件linux-headers
# 需要2个linux源码：1个编译好，1个干净的
cd <clean>
cp <compiled>/.config .
make O=<output> oldconfig
rm .config
make O=<output> modules_prepare
rm <output>/source
cp <compiled>Module.symvers <output>
# 最后软链接到/lib.modules/xxx/build
```

参考[github gist: Build/install custom linux kernel headers in ubuntu.](https://gist.github.com/bobisme/1078482/4fee50eb6eccdabc0e25a64e14485cd530baebed)：

---

apt包kernel-package的make-kpkg似乎也行，但LA上没有

目前的做法直接用干净的la-linux源码，外加：

* Module.symvers
* scripts/

linux-headers感觉就300M，linux源码外加这些就1.2G。

<div style="text-align:right; font-size:3em;">2021.08.27</div>

## [ABORT] 内核启动中何时依据什么加载非第三方modules

前言：alpine在qemu中替换为ubuntu内核后无法联网。和李欣宇排查后，在内核内置e1000网卡驱动即可。参考`QnA-alpine.md`。

2021.11.17：内核启动参数可以加载modules，剩下的应该就是启动脚本的事情了，需要看各个发行版的启动脚本。

<div style="text-align:right; font-size:3em;">2021.08.17</div>

## vmlinuz是啥

参考[What is VMLINUZ and Difference between VMLINUZ and INITRD](https://postsbylukman.blogspot.com/2017/06/what-is-vmlinuz.html)

压缩过的linux内核可执行程序。

> vmlinuz = Virtual Memory LINUx gZip = Compressed  Bootable Linux kernel Executable
>
> vmlinux = Virtual Memory LINUX = Non-compressed Non-Bootable Linux Kernel Executable

<div style="text-align:right; font-size:3em;">2021.07.02</div>

## TTY、Console区别？

[Linux: Difference between /dev/console , /dev/tty and /dev/tty0](https://unix.stackexchange.com/questions/60641/linux-difference-between-dev-console-dev-tty-and-dev-tty0)

没啥区别，是同义词了。

见`term_pty_sh.md`

## [What happens when Ctrl + Alt + F\<Num\> is pressed?](https://unix.stackexchange.com/questions/63688/what-happens-when-ctrl-alt-fnum-is-pressed)

简：内核处理，

* 按键定义：`src/drivers/tty/vt/defkeymap.map`
* 处理：`keyboard.c`

还推荐了学习资料（好几个已过期）：https://makelinux.github.io/kernel/map/

<div style="text-align:right; font-size:3em;">2020.11.06</div>

## [OPEN]进程虚拟内存空间各个部分的用途

### 32位

参考《Understanding the Linux Kernel》[2005.UnderStanding_The_Linux_Kernel.3rd.pdf](../../../../Books/Kernel/Linux/2005.UnderStanding_The_Linux_Kernel.3rd.pdf)的Memory Management章节。



### 64位