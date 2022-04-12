在`dbt5_ut/`里运行make test，详细查看Makefile文件。

❌：不能运行；

❗️：能运行，但测试不通过；

✅：能运行，部分测试不通过；

✔️：能运行，且测试通过。

序号：0️⃣ 1️⃣ 2️⃣ 3️⃣ 4️⃣ 5️⃣ 6️⃣ 7️⃣ 8️⃣ 9️⃣ 🔟

<div style="font-size:3em;">倒序记录：</div>
<div style="font-size:3em; text-align:right;">2019.11.2</div>
## 3. 黄科乐修改小问题

|        |  -t  |              -t -fno-bt               |        -t -fno-mda         |            -t -fno-fp             |  -i  |       -c       |
| ------ | :--: | :-----------------------------------: | :------------------------: | :-------------------------------: | :--: | :------------: |
|        | 翻译 | 翻译但不用手工翻译（byhand translate) | 翻译但不用misalign process | 翻译但不用标志模式（flag pattern) | 解释 | 检测解释和翻译 |
| arith  |  ✔️   |                   ✔️                   |             ✔️              |                 ✔️                 |  ✔️   |       ❌        |
| logic  |  ✔️   |                   ✔️                   |             ✔️              |                 ✔️                 |  ✔️   |       ❌        |
| string |  ❗️   |                   ❗️                   |             ❗️              |                 ❗️                 |  ❗️   |       ❌        |
| eflag  |  ✔️   |                   ✔️                   |             ✔️              |                 ✔️                 |  ✔️   |       ❌        |
| jcc    |  ✔️   |                   ✔️                   |             ✔️              |                 ✔️                 |  ✔️   |       ❌        |
| mov    |  ✔️   |                   ✔️                   |             ✔️              |                 ✔️                 |  ✔️   |       ❌        |
| farith |  ✅0️⃣  |                  ✅0️⃣                   |             ✔️              |                ✅0️⃣                 |  ✔️   |       ❌        |
| fldst  |  ✔️   |                   ✔️                   |             ✔️              |                 ✔️                 |  ✅2️⃣  |       ❌        |
| fctrl  |  ✅3️⃣  |                  ✅3️⃣                   |             ✅3️⃣             |                ✅3️⃣                 |  ✅4️⃣  |       ❌        |
| mmx    |  ✔️   |                   ✔️                   |             ✔️              |                 ✔️                 |  ✔️   |       ❌        |
| xmm    |  ✔️   |                   ✔️                   |             ✔️              |                 ✔️                 |  ✔️   |       ❌        |

* ❌：`assertion failed in <set_em_or> translator/extension.cpp:328`

* ❗️：都能运行，但一个测试都过不了。

* ✅0️⃣：

  * ❌`farith/fxtract`：`assertion failed in <mda_sigbus_handler> optimization/mda.cpp:412 `

* ✅2️⃣：

  * <pre>fistp:   328 tests <font color="#4E9A06">passed</font>,    22 tests <font color="#CC0000">failed</font>.    COSZ   flags are checked.</pre>

*  ✅3️⃣：

  * <pre>fnsave:     0 tests <font color="#4E9A06">passed</font>,     1 tests <font color="#CC0000">failed</font>.    COSZ   flags are checked.</pre>

*  ✅4️⃣：

  * <div>
      <pre>fldenv/fnstenv:     0 tests <font color="#4E9A06">passed</font>,     2 tests <font color="#CC0000">failed</font>.    COSZ   flags are checked.
                   finit:     0 tests <font color="#4E9A06">passed</font>,     1 tests <font color="#CC0000">failed</font>.    COSZ   flags are checked.
                   ffree:     0 tests <font color="#4E9A06">passed</font>,     2 tests <font color="#CC0000">failed</font>.    COSZ   flags are checked.
                  fnclex:     0 tests <font color="#4E9A06">passed</font>,     2 tests <font color="#CC0000">failed</font>.    COSZ   flags are checked.
                  fnsave:     0 tests <font color="#4E9A06">passed</font>,     1 tests <font color="#CC0000">failed</font>.    COSZ   flags are checked.
                    fldx:     7 tests <font color="#4E9A06">passed</font>.    COSZ   flags are checked.
         fincstp/fdecstp:     0 tests <font color="#4E9A06">passed</font>,     4 tests <font color="#CC0000">failed</font>.    COSZ   flags are checked.</pre>
    </div>

<div style="font-size:3em; text-align:right;">2019.10.29</div>
## 2. 黄科乐make diff output more accurate

|        |  -t  |              -t -fno-bt               |        -t -fno-mda         |            -t -fno-fp             |  -i  |       -c       |
| ------ | :--: | :-----------------------------------: | :------------------------: | :-------------------------------: | :--: | :------------: |
|        | 翻译 | 翻译但不用手工翻译（byhand translate) | 翻译但不用misalign process | 翻译但不用标志模式（flag pattern) | 解释 | 检测解释和翻译 |
| arith  |  ✔️   |                   ✔️                   |             ✔️              |                 ✔️                 |  ✔️   |       ❌        |
| logic  |  ✔️   |                   ✔️                   |             ✔️              |                 ✔️                 |  ✔️   |       ❌        |
| string |  ❗️   |                   ❗️                   |             ❗️              |                 ❗️                 |  ❗️   |       ❌        |
| eflag  |  ✔️   |                   ✔️                   |             ✔️              |                 ✔️                 |  ✔️   |       ❌        |
| jcc    |  ✔️   |                   ✔️                   |             ✔️              |                 ✔️                 |  ✔️   |       ❌        |
| mov    |  ✔️   |                   ✔️                   |             ✔️              |                 ✔️                 |  ✔️   |       ❌        |
| farith |  ✅0️⃣  |                  ✅0️⃣                   |             ✅1️⃣             |                ✅0️⃣                 |  ✔️   |       ❌        |
| fldst  |  ✔️   |                   ✔️                   |             ✔️              |                 ✔️                 |  ✅2️⃣  |       ❌        |
| fctrl  |  ✅3️⃣  |                  ✅3️⃣                   |             ✅3️⃣             |                ✅3️⃣                 |  ✅4️⃣  |       ❌        |
| mmx    |  ✔️   |                   ✔️                   |             ✔️              |                 ✔️                 |  ✔️   |       ❌        |
| xmm    |  ✔️   |                   ✔️                   |             ✔️              |                 ✔️                 |  ✔️   |       ❌        |

* ❌：`assertion failed in <set_em_or> translator/extension.cpp:328`

* ❗️：都能运行，但一个测试都过不了。

* ✅0️⃣：

  * ❌`farith/fxtract`：`assertion failed in <mda_sigbus_handler> optimization/mda.cpp:412 `

  * <pre>fprem:    99 tests <font color="#4E9A06">passed</font>,    93 tests <font color="#CC0000">failed</font>.    COSZ   flags are checked.</pre>
  
* ✅1️⃣：

  * <pre>fprem:    99 tests <font color="#4E9A06">passed</font>,    93 tests <font color="#CC0000">failed</font>.    COSZ   flags are checked.</pre>

* ✅2️⃣：

  * <pre>fistp:   328 tests <font color="#4E9A06">passed</font>,    22 tests <font color="#CC0000">failed</font>.    COSZ   flags are checked.</pre>

*  ✅3️⃣：

  * <pre>fnsave:     0 tests <font color="#4E9A06">passed</font>,     1 tests <font color="#CC0000">failed</font>.    COSZ   flags are checked.</pre>

*  ✅4️⃣：

  * <div>
      <pre>fldenv/fnstenv:     0 tests <font color="#4E9A06">passed</font>,     2 tests <font color="#CC0000">failed</font>.    COSZ   flags are checked.
                   finit:     0 tests <font color="#4E9A06">passed</font>,     1 tests <font color="#CC0000">failed</font>.    COSZ   flags are checked.
                   ffree:     0 tests <font color="#4E9A06">passed</font>,     2 tests <font color="#CC0000">failed</font>.    COSZ   flags are checked.
                  fnclex:     0 tests <font color="#4E9A06">passed</font>,     2 tests <font color="#CC0000">failed</font>.    COSZ   flags are checked.
                  fnsave:     0 tests <font color="#4E9A06">passed</font>,     1 tests <font color="#CC0000">failed</font>.    COSZ   flags are checked.
                    fldx:     7 tests <font color="#4E9A06">passed</font>.    COSZ   flags are checked.
         fincstp/fdecstp:     0 tests <font color="#4E9A06">passed</font>,     4 tests <font color="#CC0000">failed</font>.    COSZ   flags are checked.</pre>
    </div>

## 1. 黄科乐添加对x86/ cdq; x87/ fnstsw, fnstenv, fldenv, finit, fnclex, ffree, fptan, fstp, fincstp, fdecstp的支持。

|        |  -t  |              -t -fno-bt               |        -t -fno-mda         |            -t -fno-fp             |  -i  |       -c       |
| ------ | :--: | :-----------------------------------: | :------------------------: | :-------------------------------: | :--: | :------------: |
|        | 翻译 | 翻译但不用手工翻译（byhand translate) | 翻译但不用misalign process | 翻译但不用标志模式（flag pattern) | 解释 | 检测解释和翻译 |
| arith  |  ✔️   |                   ✔️                   |             ✔️              |                 ✔️                 |  ✔️   |       ❌        |
| logic  |  ✔️   |                   ✔️                   |             ✔️              |                 ✔️                 |  ✔️   |       ❌        |
| string |  ❗️   |                   ❗️                   |             ❗️              |                 ❗️                 |  ❗️   |       ❌        |
| eflag  |  ✔️   |                   ✔️                   |             ✔️              |                 ✔️                 |  ✔️   |       ❌        |
| jcc    |  ✔️   |                   ✔️                   |             ✔️              |                 ✔️                 |  ✔️   |       ❌        |
| mov    |  ✔️   |                   ✔️                   |             ✔️              |                 ✔️                 |  ✔️   |       ❌        |
| farith |  ✅0️⃣  |                  ✅0️⃣                   |             ✅1️⃣             |                ✅0️⃣                 |  ✔️   |       ❌        |
| fldst  |  ✅2️⃣  |                  ✅2️⃣                   |             ✅2️⃣             |                ✅2️⃣                 |  ✅3️⃣  |       ❌        |
| fctrl  |  ✅4️⃣  |                  ✅4️⃣                   |             ✅4️⃣             |                ✅4️⃣                 |  ✅5️⃣  |       ❌        |
| mmx    |  ✔️   |                   ✔️                   |             ✔️              |                 ✔️                 |  ✔️   |       ❌        |
| xmm    |  ✔️   |                   ✔️                   |             ✔️              |                 ✔️                 |  ✔️   |       ❌        |

* ❌：`assertion failed in <set_em_or> translator/extension.cpp:328`

* ❗️：都能运行，但一个测试都过不了。

* ✅0️⃣：

  * ❌`farith/fxtract`：`assertion failed in <mda_sigbus_handler> optimization/mda.cpp:412 `

  * <pre>fprem:    99 tests <font color="#4E9A06">passed</font>,    93 tests <font color="#CC0000">failed</font>.    COSZ   flags are checked.</pre>

  * <pre>fptan:     7 tests <font color="#4E9A06">passed</font>,     1 tests <font color="#CC0000">failed</font>.    COSZ   flags are checked.</pre>
  
* ✅1️⃣：

  * <pre>fprem:    99 tests <font color="#4E9A06">passed</font>,    93 tests <font color="#CC0000">failed</font>.    COSZ   flags are checked.</pre>

  * <pre>fptan:     7 tests <font color="#4E9A06">passed</font>,     1 tests <font color="#CC0000">failed</font>.    COSZ   flags are checked.</pre>

* ✅2️⃣：

  * <pre>fstp:   426 tests <font color="#4E9A06">passed</font>,    14 tests <font color="#CC0000">failed</font>.    COSZ   flags are checked.</pre>

  * <pre>fld:   430 tests <font color="#4E9A06">passed</font>,    10 tests <font color="#CC0000">failed</font>.    COSZ   flags are checked.</pre>
  
* ✅3️⃣：

  * <pre>fistp:   328 tests <font color="#4E9A06">passed</font>,    22 tests <font color="#CC0000">failed</font>.    COSZ   flags are checked.</pre>

* ✅4️⃣ 

  * <pre>fnsave:     0 tests <font color="#4E9A06">passed</font>,     1 tests <font color="#CC0000">failed</font>.    COSZ   flags are checked.</pre>

* ✅5️⃣：

  * <pre>  fldenv/fnstenv:     0 tests <font color="#4E9A06">passed</font>,     2 tests <font color="#CC0000">failed</font>.    COSZ   flags are checked.
               finit:     0 tests <font color="#4E9A06">passed</font>,     1 tests <font color="#CC0000">failed</font>.    COSZ   flags are checked.
               ffree:     0 tests <font color="#4E9A06">passed</font>,     2 tests <font color="#CC0000">failed</font>.    COSZ   flags are checked.
              fnclex:     0 tests <font color="#4E9A06">passed</font>,     2 tests <font color="#CC0000">failed</font>.    COSZ   flags are checked.
              fnsave:     0 tests <font color="#4E9A06">passed</font>,     1 tests <font color="#CC0000">failed</font>.    COSZ   flags are checked.
                fldx:     7 tests <font color="#4E9A06">passed</font>.    COSZ   flags are checked.
     fincstp/fdecstp:     0 tests <font color="#4E9A06">passed</font>,     4 tests <font color="#CC0000">failed</font>.    COSZ   flags are checked.</pre>

* 

<div>
ss
</div>

