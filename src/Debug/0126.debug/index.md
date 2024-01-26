---
title: 傻瓜式debug
author: <img src="https://xieby1.github.io/markdown_revealjs/images/me.png" style="height:1.5em;">xieby1
date: 🎉2024.01.26
headerr: <img src="https://xieby1.github.io/markdown_revealjs/images/me.png" style="height:1.5em;">

title-slide-background-image:  https://xieby1.github.io/markdown_revealjs/images/liquid-cheese.svg
toc-slide-background-image:    https://xieby1.github.io/markdown_revealjs/images/liquid-cheese.svg
level1-slide-background-image: https://xieby1.github.io/markdown_revealjs/images/liquid-cheese.svg
level2-slide-background-image: https://xieby1.github.io/markdown_revealjs/images/liquid-cheese_shallow.svg

toc-depth: 1
toc-column-width: unset
toc-margin: 0 500px
---

# 问题场景一

* 正确性测试：每次commit都有会
  * 程序正确性没问题
* 性能回归测试：隔了几十个commit才跑了一次
  * 跑出了明显的性能下降
* 测试慢
  * 一轮测试2小时
* 开发紧张
  * 每天提交20个commit、不能堵住新commit

## 可能的解决方法 {data-auto-animate=1}

::: {.container}
:::: {.col}
```bash
git bisect
git bisect bad HEAD
git bisect good <commit>
<run tests>
git bisect good/bad
<run tests>
git bisect good/bad
<run tests>
...
```
::::
:::: {.col}
<img src="./bisect.svg" style="height: 600px;">
::::
:::

## 时间预估 {data-auto-animate=1}

::: {.container}
:::: {.col}
```bash
git bisect
git bisect bad HEAD
git bisect good <commit>
<run tests>
git bisect good/bad
<run tests>
git bisect good/bad
<run tests>
...
```
::::
:::: {.col}
串行！

* git bisect次数
  * $\left \lceil log_2(几十) \right \rceil$

* 预计消耗时间
  * $2 \times \left \lceil log_2(几十) \right \rceil 小时$
  * $\approx 十几小时 \approx 通宵$
::::
:::

## 解决方法 {data-auto-animate=1}

::: {.container}
:::: {.col}
* git bisect次数
  * $\left \lceil log_2(几十) \right \rceil$

* 预计消耗时间
  * $2 \times \left \lceil log_2(几十) \right \rceil 小时$
  * $\approx 十几小时 \approx 通宵$
::::
:::: {.col}
每隔两小时设一个闹钟⏰

也就一晚上的事情嘛😼

绝对不会耽误明天的工期
::::
:::

## 过了一晚🌃 {data-auto-animate=2}

找到了导致性能下降的commit ...

```cpp
case X86_INS_CALL: switch (oprs_type) {
    case OT_OPR0_I: {
        if (szs[0] == 8) {
            // fuck capstone change relative imm to abosolute address
            uint64_t rel_imm = imms[0] - macroop->address - macroop->size;
            ub.issuec({opc2c_limm_sz8, X86OPR_T1, encode_imm(rel_imm)}, {rel_imm});
            ub.issuec({opc0_stcall}, {});
            ub.issuec({opc2c_subimm_sz8, X86OPR_RSP, encode_imm(8)}, {8});
            ub.issuec({opc1c_wripcall, X86OPR_T1}, {});
            return true;
        }
    } break;
} break; // X86_INS_CALL
```

## 但是 {data-auto-animate=2}

```cpp
case X86_INS_CALL: switch (oprs_type) {
    case OT_OPR0_I: {
        if (szs[0] == 8) {
            // fuck capstone change relative imm to abosolute address
            uint64_t rel_imm = imms[0] - macroop->address - macroop->size;
            ub.issuec({opc2c_limm_sz8, X86OPR_T1, encode_imm(rel_imm)}, {rel_imm});
            ub.issuec({opc0_stcall}, {});
            ub.issuec({opc2c_subimm_sz8, X86OPR_RSP, encode_imm(8)}, {8});
            ub.issuec({opc1c_wripcall, X86OPR_T1}, {});
            return true;
        }
    } break;
} break; // X86_INS_CALL
```

这个commit就几行指令

盯了一个小时都没想明白

为啥会性能下降呢？

## 为啥呀 {data-auto-animate=2}

<img src="./lp.jpg">

[为啥会性能下降呢？]{style="font-size: 2em;"}

# 问题场景二

一条X86的CALL_I

<hr>

::: {.container}
:::: {.col}
原本Gem5

```
gem5_limm
gem5_stcall
gem5_subimm
gem5_wripcall
```
::::
:::: {.col}
替换成了

就出错了
::::
:::: {.col}
微译器

```
transutor_limm
transutor_stcall
transutor_subimm
transutor_wripcall
```
::::
:::

## 可能的解决方法 {data-auto-animate=2}

拆分这个commit！

::: {.container}
:::: {.col}
* 1.  原原原微
* 2.  原原微原
* 3.  原原微微
* 4.  原微原原
* 5.  原微原微
* 6.  原微微原
* 7.  原微微微
::::
:::: {.col}
* 8.  微原原原
* 9.  微原原微
* 10. 微原微原
* 11. 微原微微
* 12. 微微原原
* 13. 微微原微
* 14. 微微微原
::::
:::

全测一遍！

## 可能的解决方法 {data-auto-animate=2}

但是按一定的顺序

::: {.container}
:::: {.col}
* 1.  原原原微
* 2.  原原微原
* 4.  原微原原
* 8.  微原原原
::::
:::: {.col}
* 3.  原原微微
* 5.  原微原微
* 6.  原微微原
* 9.  微原原微
* 10. 微原微原
* 12. 微微原原
::::
:::: {.col}
* 7.  原微微微
* 11. 微原微微
* 13. 微微原微
* 14. 微微微原
::::
:::

## 时间预估 {data-auto-animate=3}

$<14次 \times 2 小时 \approx 28 机时$

[并行：$2小时$ 😼]{.fragment}

::: {.container}
:::: {.col}
* 1.  原原原微
* 2.  原原微原
* 4.  原微原原
* 8.  微原原原
::::
:::: {.col}
* 3.  原原微微
* 5.  原微原微
* 6.  原微微原
* 9.  微原原微
* 10. 微原微原
* 12. 微微原原
::::
:::: {.col}
* 7.  原微微微
* 11. 微原微微
* 13. 微微原微
* 14. 微微微原
::::
:::

# 总结！

如果有良好的测试集的话

* 纯傻瓜式debug！
  * commit粒度：git bisect
  * 行粒度：拆分

# 优化？

* commit粒度：git bisect
  * 并行？且自动化？
* 行粒度：拆分
  * 基于语义自动拆分？且自动测试？

# 谢谢
