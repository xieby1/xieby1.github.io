<div style="text-align:right; font-size:3em;">2023.03.04</div>

尝试在UTM（QEMU KVM？）中运行`sudo perf stat ...`，
无法得到指令数量。

https://www.reddit.com/r/AsahiLinux/comments/vr27bz/pmu_perf_counters_usable_on_asahi_or_inside_linux/
说在物理机器上taskset即可，在实验室的asahi linux m1上确实可以。
这篇文章还提到虚拟机中**never work**（真的吗？）。

> This will never work in a VM, because Apple do not support the standard ARM performance counters (they use a custom PMU) and they do not expose proprietary features to VM guests (and nor would KVM/qemu for that matter). But it does work on bare metal since we do have a driver for it (and on the m1n1 hypervisor, though I would not recommend using it for benchmarks - it probably has some funky effects on performance).

按照它的方法

```bash
taskset -c 2 perf stat -e apple_firestorm_pmu/cycles/ -e apple_firestorm_pmu/instructions/ <command>
```

这俩event都没是not counted

不加这俩event能够有cycles和instructions数据，
没有branches和branch-misses数据。

---

https://github.com/utmapp/UTM/issues/4200
UTM的github issue中也有人问如何启用PMU，
暂时没有解决方案。
