<div style="text-align:right; font-size:3em;">2023.07.10</div>

## 编译（ubuntu）

* 改config
*

<div style="text-align:right; font-size:3em;">2022.11.17</div>

## 编译(NixOS)

### tools

Using FHS to build tools

#### Err: `__stat`

```
undefined reference to `__stat'
```

**Solution**:

```c
// file: tools/src/make-3.80/glob/glob.c
// change
if _GNU_GLOB_INTERFACE_VERSION == GLOB_INTERFACE_VERSION
// to
if _GNU_GLOB_INTERFACE_VERSION >= GLOB_INTERFACE_VERSION
```

#### Err: `getline`

```
error: conflicting types for 'getline'
```

**Solution**:

```c
// file: tools/src/specmd5sum/lib/getline.h
// comment
int
getline PARAMS ((char **_lineptr, size_t *_n, FILE *_stream));

int
getdelim PARAMS ((char **_lineptr, size_t *_n, int _delimiter, FILE *_stream));
```

#### Err: `asm/page.h`

```
asm/page.h: No such file or directory
```

**Solution**:

```c
// file: tools/src/perl-5.8.7/ext/IPC/SysV/SysV.xs
// comment
#   include <asm/page.h>
```

### NixOS native

#### `cwd`

Cwd.pm: /bin/pwd => pwd

MakeMaker.pm: 162&163: cwd => getcwd

#### Errno_pm.PL

```perl
# file: Errno_pm.PL
# comment
die "No error definitions found" unless keys %err;
```

<div style="text-align:right; font-size:3em;">2021.07.15</div>

运行spec没什么难事，仔细阅读官方完整和`docs/`即可。毕竟是长期运作了几十年的商业软件，使用的坑早被大量用户踩平了。

<div style="text-align:right; font-size:3em;">2020.10.12</div>

**注**：以下提及的SPEC若无特殊说明都指SPEC2000。

#### Undefined reference to pow

在nix-shell中添加链接器参数

NIX_LDFLAGS+=" -lm"

### ubuntu (docker: x86_64, aarch64, riscv64)

编译时链接libm，使用 PERLFLAGS="-A libs=-lm -A libs=-ldl" ./buildtools

#### Undefined reference to pow

编译时链接libm，使用 PERLFLAGS="-A libs=-lm -A libs=-ldl" ./buildtools

#### You haven't done a "make depend" yet!

https://www.okqubit.net/runspec.html

把/bin/sh从dash换成bash

```bash
dpkg-reconfigure dash
# no
```

### 编译测试

#### 252.eon

CXXPORTABILITY  = -DHAS_ERRLIST -fpermissive

改成

CXXPORTABILITY  = -DUSE_STRERROR -fpermissive

## 编译

**仍然未成功编译！！！**

```shell
# 报错ld找不的合适版本的libgfortran.a
sudo apt install libgfortran-9-dev:i386 # 装对应版本的i386的libgfortran # 当然还是没解决ld找不的适合版本的问题
```

直接用刘先喆编译好的版本吧，

* x86-linux：实验室gitlab的xqm-test-suit仓库，[外网](http://foxsen.3322.org:33336/liuxianzhe/xqm-test-suit)，[内网](http://172.17.103.58/liuxianzhe/xqm-test-suit)。
* x86-windows：56服务器`/home/loongson/Documents/Benchmarks/spec2000-win.zip`，[内网网页](http://172.17.103.56/file_manager.php?p=Benchmarks&view=spec2000-win.zip)。
* 龙芯平台：参考[龙芯研发平台-编译工具链-编译SPEC2000的文档](http://sysdev.loongson.cn/projects/compiler/wiki/Cpu2000HowToBuildAndRun)，[龙芯研发平台-编译工具链-编译SPEC2006的文档](http://sysdev.loongson.cn/projects/compiler/wiki/Cpu2006HowToBuildAndRun)

## 运行

### x86-linux

**注**：在RUNME.sh脚本里的runspec程序里添加参数`-I`来忽略错误，而不是在给RUNME.sh参数。

2020.10.20

或者用runspec

```shell
. ./shrc
# runspec -h 可以用帮助
# 只跑一遍
runspec -n 1 --config=x86_32.O3.cfg all
# 跑一遍定点测试集
runspec -n 1 -i test --config=x86_32.O3.cfg int
```

### mips-linux

直接用[刘先喆编好的](http://172.17.103.56/file_manager.php?p=Benchmarks&view=spec2000-all.tar.bz2)，`myrun.sh`就好了。

---

还是没编译成功，如下，

* 注释`tools/src/specmd5sum/lib/getline.h`的getline和getdelim这俩声明。
* `tools/src/buildtools`的255行的./Configure后添加`-Dcc="gcc -lm" -Dlibpth="/usr/local/lib64 /usr/lib64 /lib64"`
* 注释掉`tools/src/perl-5.8.7/ext/IPC/SysV/SysV.xs`里include asm/page.h。

<div style="text-align:right; font-size:3em;">2020.10.13</div>

### x86-windows on wine

```shell
wine cmd # 用wine启动cmd
# 在cmd里的操作参考spec2000-win.zip里的说明，简写如下
shrc
bin\runspec --reportable --config=intel_nt_visual_studio.cfg all
```
