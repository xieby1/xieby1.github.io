<div style="text-align:right; font-size:3em;">2022.11.09</div>

* perf
  * 因为不重编译，信息较少，不准确
* [easy_profiler](https://github.com/yse/easy_profiler)
  * 手动插桩
  * 仅支持C++
* [gprof](https://sourceware.org/binutils/docs/gprof/index.html)
  * 编译-gp，全自动，
  * 无法手动辅助插桩
  * 无法设置采样率
* [gperftools cpu profiler](https://gperftools.github.io/gperftools/cpuprofile.html)
  * 没详细调研，似乎和gprof类似

* [QEMU相关Trace方法](https://qemu.readthedocs.io/en/latest/devel/tracing.html)
  * [lttng](https://lttng.org/)
