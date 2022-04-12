<div style="text-align:right; font-size:3em;">2020.12.21</div>

# 内存模型测试——DIY（Herdtools）

* google search “memory consistency model test github”
  * https://github.com/litmus-tests/litmus-tests-riscv
    * http://diy.inria.fr/
      * reference：Intel 64 Architecture Memory Ordering White Paper, August 2007.

## 安装

参考官网http://diy.inria.fr/sources/index.html用opam安装，安装好后若没有可执行的指令，大概是opam的环境没设置好，opam init会有提示。

## 使用

```shell
diy7 -arch <arch> -cross <dir> # <dir>末尾不要带`/`可以生产对应平台的C代码
```

