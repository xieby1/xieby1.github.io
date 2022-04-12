参考《User Mode Linux》[2006.user_mode_linux.dike.pdf](2006.user_mode_linux.dike.pdf)。

<div style="text-align:right; font-size:3em;">2021.09.09</div>

```bash
sudo apt install user-mode-linux-doc
```

文档在`/usr/share/doc/user-mode-linux-doc/html`

kernel.html

> Basically, anything in Linux that's not hardware-specific just works. This includes kernel modules, the filesystems, software devices, and network protocols.

想法：驱动移植！
先搞定ISA无关的驱动！
然后搞定ISA相关的驱动！

### compiling

参考：http://user-mode-linux.sourceforge.net/source.html

```bash
export ARCH=um
# then do as normal...
```

<div style="text-align:right; font-size:3em;">2020.10.12</div>

我最关系的问题是如何实现系统调用，参考UML书的第9章Host Setup for a Small UML Server - UML Execution Modes，可以知道UML最原始的处理系统调用的模式叫做tt (tracing thread)，

> In tt mode, a single tracing thread controls the rest of the threads in the UML instance by deciding when to intercept their system calls and have them executed within UML. When a UML process is running, it intercepts its system calls, and when the UML kernel is running, it doesn’t. This is the tracing that gives this thread its name.

所以和WINE对比tt模式的UML并未太考虑性能问题。

<div style="text-align:right; font-size:3em;">2020.11.06</div>

不太懂高0.5GB指的哪里，可以直接用内核的内存空间吗？~~tt模式的高0.5GB应该是指在用户内存空间的高0.5GB。~~**注**：用户内存空间和内核内存空间是可调的，默认是3GB+1GB。
