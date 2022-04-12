<div style="text-align:right; font-size:3em;">2020.12.14</div>

## 动态链接库头文件应该包含的内容

**起因**：看《Windows核心编程（第5版）》19.2.1构建DLL模块的示例头文件，不推荐在头文件里写变量。

从C语言的角度说、且在dll开发者和dll使用者用的是同一个头文件的前提下，头文件里可以包含函数和extern变量。
不能包含没有添加extern的变量，否则dll里和使用dll的二进制程序里的变量会重复。C++的类暂时未关注。

但这里我更想引用一下这本对程序模块化设计的考虑，

> 在创建一个DLL的时候，我们事实上是在创建一组可供一个执行模块（或者其他DLL）调用的函数。
> 一个DLL可以导出变量、函数、或C++类来供其他模块使用。
> 在实际开发中，我们应该避免从DLL中导出变量，因为这等于是去掉了代码中的一个抽象层，从而使得DLL的代码更加难以维护。
> 此外，只有当导出C++类的模块使用的编译器与导入C++类的模块使用的编译器由同一家厂商提供时，我们才可以导出C++类。
> 因此，除非知道可执行模块的开发人员与DLL模块的开发人员使用的是相同的工具包，否则我们应该避免从DLL中导出C++类。

<div style="text-align:right; font-size:3em;">2020.07.27</div>

## `#include<>`和所需的`.so`文件的关系

并没有直接关系。`#include<>`只是和C/CPP的预处理相关。

真正和`.so`文件相关的是include进来的头文件里带有`extern`修饰的变量。

**后续**：

* [编译器/连接器如何判断`extern`变量用动态链接还是静态链接](#编译器/连接器如何判断`extern`变量用动态链接还是静态链接)

## 编译器/连接器如何判断`extern`变量用动态链接还是静态链接

**结论**：动态链接优先。有`.so`文件就用动态，没有`.so`而有`.a`就用静态。

详细查看man ld的关于`-l`和`--library`的说明，man gcc里关于`-l`的说明。

**后续**：

* [`.so`和`.a`的区别](#`.so`和`.a`的区别)
* [`.so`能用于静态链接吗](#`.so`能用于静态链接吗)

## `.so`和`.a`的区别

2020.9.9

**答**：前者用于动态链接，后者用于静态链接。

## `.so`能用于静态链接吗

2020.9.9

**结论**：能。

**答**：

参考：stack overflow的问答

* [Is it possible to statically link against a shared object?](https://stackoverflow.com/questions/5720205/is-it-possible-to-statically-link-against-a-shared-object)
  *  and [check out this question](https://stackoverflow.com/questions/1022120/do-i-need-static-libraries-to-statically-link) too => [Do I need static libraries to statically link?](https://stackoverflow.com/questions/1022120/do-i-need-static-libraries-to-statically-link)
    * There exist tools like [ELF Statifier](http://statifier.sourceforge.net/) which attempt to bundle dynamically-linked libraries into a dynamically-linked executable, but it is very difficult to generate a correctly-working result in all circumstances.

## 编译时为何有些库需要`-llib`而有些不需要

**结论**：gcc会有默认链接的库。能在默认库里找到就不需要加`-llib`。

从man gcc的对`-nodefaultlibs`和`-nolibc`的说明可以看出。

然后通过给gcc加-v参数和向链接器传递`--verbose`参数可以看出哪些库是默认的，比如libc.so。

```shell
gcc -v helloworld.c -Wl,--verbose
```

## 链接器是如何在`.so`里定位所需的函数的范围的

**注**：肯定不是通过符号信息，因为发行版的库都是没有符号的（stripped）。