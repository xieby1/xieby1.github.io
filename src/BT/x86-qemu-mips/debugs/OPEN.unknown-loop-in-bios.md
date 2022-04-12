<div style="font-size:3em; text-align:right;">2020.5.20</div>

调试qemu的guest内运行的bios方法参考`qemu/roms/seabios/docs/Debugging.md`和`Notes/zhangfuxin/qemu_gdb_remote_debug.md`。

```shell
# 龙芯上运行xqm并开发gdb调试端口1235
./qemu-system-i386 \
-bios ~/bios.bin \
-kernel ~/vmlinuz-2.6.32-38-generic \
-append "console=ttyS0 root=/dev/sda1 ro" \
-hda ~/ubuntu10s.img \
-m 2048 \
-nographic \
-smp threads=2 \
-gdb tcp::1235 -S

# x86机器上，先把x86机器的1235端口链接上龙芯的1235端口（ssh local forward）
# 在xqm/roms/seabios/目录里
gdb out/rom16.o
# rom16offset.o是平移过地址的rom16.o，生成方式见qemu/roms/seabios/docs/Debugging.md
(gdb) add-symbol-file rom16offset.o
(gdb) target remote :1235
```

thread1.1会卡在`0xeff81`附近，

```assembly
0xeff81: jmp 0xeff5c
# 做一个简单的对比实验会发现ebx里存的是vCPU的数量
0xeff5c: cmp ebx, dword ptr [0xf53a0] # 这个地方再ni，thread1.2会收到SIGTRAP
0xeff62: je 0xeff83
```

thread1.2会卡在`0xfd090`附近

```assembly
0xfd090: pause
0xfd092: lock bts dword ptr [0x5370], 0
0xfd09b: jb 0xfd090
```

在qemu里做测试确实也会经过这个点，但是多次循环后能够正常执行下去。且这两个地方gdb都没找到对应的源码。thread1.2的代码感觉可能是`src/romlayout.S: entry_smp: 212~214`或`src/fw/smp.c:158~160`因为只有这俩地方里有`bts`指令，仔细一看这两文件(smp.c编译到了rom16.o，和romlayout.S)相同？！。

---

BIOS执行轨迹

* 595:entry_post, 527: iretw, 566, 567, 
* entry_hwpic2
* entry_19