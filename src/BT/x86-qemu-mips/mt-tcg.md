<div style="font-size:3em; text-align:right;">2020.5.25</div>

## 编译

```shell
./configure --enable-debug --enable-debug-info --disable-werror --enable-x86tomips  --target-list=i386-softmmu
```

## debug运行

```shell
./qemu-system-i386 \
-bios ~/Codes/x86-qemu-mips/roms/seabios/out/bios.bin \
-kernel ~/vmlinuz-2.6.32-38-generic \
-append "console=ttyS0 root=/dev/sda1 ro" \
-hda ~/ubuntu10s.img \
-m 2048 \
-nographic \
-smp threads=2 \
-accel tcg,thread=multi \
-gdb tcp::1235 -S \
-xtm [none,select,all],verbose,trace=100,dump=1111 # trace simple,TB,ir1 dump func,ir1,ir2,host

(gdb) disp/x ((CPUX86State*)cpu->env_ptr)->eip
(gdb) disp/x ((CPUX86State*)cpu->env_ptr)->segs[1] # cs
```



<div style="font-size:3em; text-align:right;">2020.5.9</div>

## `vl.c`

`vl.c`的代码框架和QEMU的一致如下，

![vl-formatted](../QEMU/pictures/vl-formatted.svg)

### `configure_accelerator`

`vl.c`调用这个函数中经过多层调用会用到`lsenv`，然而目前的方案是把`lsenv`的初始化放到了`qemu_thread_create`里。这样的好处是可以直接完成**线程局部变量**`lsenv`的初始化。缺点很明显，`configure_accelerator`是`lsenv`还不可用。

接下来详细看看`configure_accelerator`的代码框架，看看这里使用`lsenv`是否有必要，是否可以迁移到后边去。