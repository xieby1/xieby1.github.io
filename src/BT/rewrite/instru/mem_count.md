<div style="text-align:right; font-size:3em;">2021.07.06</div>

想尝试用统计4k程序非16k对齐访存的频率。

候选对象：

- qemu: [TCG Instruction Counting](https://qemu.readthedocs.io/en/latest/devel/tcg-icount.html)只支持系统态，不支持用户态
- valgrind
- pin (intel)感觉不错，文档详尽，示例丰富，支持Linux, Windows, MacOS
  - [20210520: Pin - A Dynamic Binary Instrumentation Tool](https://software.intel.com/content/www/us/en/develop/articles/pin-a-dynamic-binary-instrumentation-tool.html)
    - [lateset: 下载&文档链接](https://software.intel.com/content/www/us/en/develop/articles/pin-a-binary-instrumentation-tool-downloads.html)
      - [20210601: Pin 3.19 User Guide](https://software.intel.com/sites/landingpage/pintool/docs/98425/Pin/html/index.html)
- perf

<div style="text-align:right; font-size:3em;">2021.07.07</div>

用bing dict搜索binary instrumentation的合适翻译，利用基于网页的搜索搜到了[20131103: Dyninst学习笔记](https://blog.csdn.net/u010838822/article/details/14094287)，它除了Pin, Valgrind以外还推荐了，

* DynamoRio
* Dyninst

还看到了博客推荐提到了Fuzz Test软件AFL，感觉就是邹旭想做的事情。Fuzz Test中文翻译为模糊测试。借此机会学习了graphviz，复兴了之前想做二进制翻译时间轴的想法，这一次直接做成自己的知识图谱吧。

## Pin

代码参考`source/tools/ManualExamples/`，`pinatrace`访存插桩（mem access instrumentation），`inscount2`快速统计执行过的指令数。

目前可以统计执行指令数，访存信息{pc，读写类型，访存大小，访存地址}，

还需要统计（对齐的）4*4K页权限不同的，instrument中打印`/proc/xxx/maps`吧。

**注**：需要做实验验证or查证`/proc/xxx/maps`确实是客户程序的maps。

* [20180814: Stack Overflow: Intel Pin memory management](https://stackoverflow.com/questions/51848467/intel-pin-memory-management)

[Pin - A Binary Instrumentation Tool - FAQ](https://software.intel.com/content/www/us/en/develop/articles/pin-a-binary-instrumentation-tool-faq.html)提到了引用的事

<div style="text-align:right; font-size:3em;">2021.07.08</div>

## SPEC测试

<div style="text-align:right; font-size:3em;">2021.07.16</div>

164.gzip在第一个任务还没有结束, 25.47%, safe 73202743 unsafe 25010940

176.gcc只输出main, 9.255% safe 75076632 unsafe 7657026

168.wupwuse显示出NITER，访存问题惊人81.7%, safe 9315566 unsafe 41676842

---

调整为sample后，可以完整测试，访存问题率没有那么高。

<div style="text-align:right; font-size:3em;">2021.07.19</div>

