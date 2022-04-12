<div style="font-size:3em; text-align:right;">2019.11.4</div>

不知道从哪搞到了直接就能在龙芯3A3000上跑的spec2000。目前从`bin/runspec`开头的脚本标记看来，上一次运行这个的人似乎叫`qiuji`。**注**：做了一下实验得知是`bin/relocate`脚本会修改`bin/runspec`开头的脚本标记。

# ✔️在3A3000上运行SPEC

```bash
./myrun.sh
```

# ✔️在X86上运行SPEC

**太长不想看，一句话总结**：解压bin_x86.tgz为bin，修改`config/test.cfg`里的编译相关的变量，然后运行`myrun.sh`脚本即可。

研究了一下myrun.sh的各个语句的含义，**注**：`myrun.sh.xiebenyi_analysis.txt`的内容，

```bash
# @myrun.sh
. shrc # execute shrc in current shell, which equivalent to `source shrc`
    # shrc - sets up the environment to run SPEC CPU2000
    # shrc adds PATH_TO_SPEC_ROOT/spec2000-all/bin to $PATH enviroment varable.

# @bin/relocate
relocate # relocate will edit the script tag in bin/runspec file
    # relocate - fixes headers in the tools when the tools are moved
    # ...
    echo "Top of SPEC benchmark tree is '$SPEC'"
    # ...
    exec $SPEC/bin/specperl -x -S $0 
    # According to `bin/specperl -h`
    #   -x[directory]: strip off text before #!perl line and perhaps cd to directory
    #   -S: look for programfile using PATH environment variable
    # After, relocate script is executed as a specperl script.
    # ...
        
# @bin/runspec, this is specperl script
runspec -c test.cfg -i ref -n 3 all -I
# According to `perl runspec --help`
#   -c: Set config file for runspec to use, Default: default.cfg
#     test.cfg lacates in config/
#   -i: Set the workload to use
#     ref or test or train, these 3 options are 3 folders contained in each workload's data folder, e.g. benchspec/CINT2000/164.gzip/data/
#   -n: Set the number of iterations of each benchmark to run. Reportable runs must have an odd number >= 3
#   -I Continue with benchmark runs even if one benchmark fails
```

# ✔️在3A2000上用X86toMips运行X86的SPEC

2019.11.5**下面的内容太长全是废话，还不如去问刘先喆**：先用脚本运行一遍，会在每个测试的文件夹下多出一个run/文件夹，用测试程序和测试程序的输入.in文件即可。

目前大体上看SPEC是用perl脚本调用编译好的测试程序们运行。可以先尝试单独运行测试程序试试。

测试程序们位于`benchspec/`里，每一个测试的程序主体和测试数据是分开的，要如何将测试数据送入程序主题这个需要研究研究`bin/runspec`脚本。

## 分析`bin/runspec`脚本

<div style="font-size:3em; text-align:right;">2019.11.5</div>

通过阅读`bin/runspec`脚本可以知道如何手动运行测试程序，如何生产结果，

```perl
# 459~503 # Run benchmarks
# 505~520 # Print summary of results
```

往回追踪代码，

```perl
# 479
my $rc = $bench->run_benchmark($users);
  # $bench的定义
  # 250
  # 注：A variable is defined by the ($) symbol (scalar), the (@) symbol (arrays), or the (%) symbol (hashes).
  for my $bench (@{$config->runlist}) {
    # $config的定义
    # 89
    my $config    = new Spec::Config;
    # 看样子是导入了其他文件，强烈需要一个perl文件的分析工具！
```

### 用VSCode来浏览perl文件

安装Perl插件，需要安装`ctags`和`Perl::Tidy`，

```bash
# ctags
sudo apt install exuberant-ctags
# Perl::Tidy # Perl::Tidy官网去看，提示我用cpanm安装
sudo apt install cpanmius # 安装cpanm
sudo cpanm Perl::Tidy
# 按照提设在vscode的extension setting设置好了perltidy的路径
```

## 分析`bin/runspec`脚本-续

```perl
    # Spec::Config使用在bin/config.pl
    # 9
    package Spec::Config; # 此处只是使用，Spec::Config的定义应该在一个叫做Spec.pm的文件里，详细见package和module的含义https://www.tutorialspoint.com/perl/perl_packages_modules.htm
      # Spec.pm在bin/lib/File/里，还是没找到runlist
```

用grep搜索runlist，在`docs/config.html`里找到很多！在`bin/parse.pl`也找到了！看来runlist是脚本运行起来才有的变量，是通过读取.cfg文件产生的变量！

---

上面的路线跑偏了，

```perl
# 479
my $rc = $bench->run_benchmark($users);
```

run_benchmark函数位于`bin/benchmark.pm: 1115~1406`里，

### 分析`bin/benchmark.pm`脚本

