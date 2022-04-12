<div style="text-align:right; font-size:3em;">2021.09.15</div>

ioctl示例代码：

[2011: OpenSource: Device Drivers, Part 9: Input/Output Control in Linux](https://www.opensourceforu.com/2011/08/io-control-in-linux/)

<div style="text-align:right; font-size:3em;">2021.09.01</div>

* SYSCALL_DEFINE6(mmap, ...6)
  * ksys_mmap_pgoff(...6)
    * vm_mmap_pgoff(...6)
      * 🤔security_mmap_file
      * do_mmap(...6+2)
        * get_unmmaped_area(...6-prot) /// 为啥不需要prot？是把文件或shmem映射进来就不用？
        * 

<div style="text-align:right; font-size:3em;">2021.08.27</div>

`make modules_install`做了啥，使用`make -Bn`可见，

* 清理文件
* 复制文件：`modules.order`的kernel部分、`modules.builtin`、`modules.builtin.modinfo`、`*.ko` > `/lib/modules/<VERSION>/`
*  生成module依赖关系的文件`depmod /lib/modules/<VERSION>/`

<div style="text-align:right; font-size:3em;">2021.08.25</div>

尝试修改运行lkmpg[^lkmpg]的kbleds。

修改几个API后kbleds可以运行了。

查内核API的方法：

* [内核邮件](https://www.mail-archive.com/linux-kernel@vger.kernel.org/)
* fugitive的Git blame + Gedit

<div style="text-align:right; font-size:3em;">2021.08.24</div>

阅读lkmpg[^lkmpg]的syscall stealing。

<div style="text-align:right; font-size:3em;">2021.08.23</div>

数据是否驻留在物理内存里

参考https://linux-kernel-labs.github.io/refs/heads/master/labs/introduction.html
可以使用linux源码中提供的脚本生成`compile_commands.json`和ctags文件。

```shell
# 先编译内核
make defconfig # 或者用别的.config
make -j4

# 再生成compile_commands.json和cscope文件
./scripts/clang-tools/gen_compile_commands.py
make ARCH=x86 COMPILED_SOURCE=1 cscope
```

lkmpg[^lkmpg]介绍2.6版本的内核模块，对于我能够建立起模块的框架，是个很好的入门读物，说清楚了

* module和driver的关系（linux官方文档里，module_init的说明竟然在dirver目录中，让人十分迷惑），
* 内核的哪些函数可以被module使用——整个内核的变量和函数都可以，他们在一个变量空间，暴露出符号的变量和函数见`/proc/kallsyms`

<div style="text-align:right; font-size:3em;">2021.08.18</div>

文档见`linux/Documentation/kbuild/modules.rst`，可以用`make htmldocs`或`pdfdocs`编译。

<div style="text-align:right; font-size:3em;">2021.08.17</div>

[Writing a Simple Linux Kernel Module](https://blog.sourcerer.io/writing-a-simple-linux-kernel-module-d9dc3762c234)

[^lkmpg]: https://tldp.org/LDP/lkmpg/2.6/html/index.html