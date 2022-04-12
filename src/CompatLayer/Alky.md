<div style="text-align:right; font-size:3em;">2021.04.29</div>

前言：

刘先喆昨天说想查一查WINE相关的论文。他没找到论文，但是他推荐给我了Alky，

* [2006.06.17 OS news: Convert a Windows Executable to a MacOS X, Linux Binary?](https://www.osnews.com/story/14923/convert-a-windows-executable-to-a-macos-x-linux-binary/)
* github上有非官方源码

## wine-devel邮件

2007.4.23有一次简单的讨论

* Ian Macfarlane第一次在wine-devel里提到Alky，是DirectX10的另一种实现，即可以跨平台。
* H. Verbeet：Alky团队低估了工作量
* Stefandoesinger：Alky不靠谱。
  * 最开始是开源程序，转换Win32程序到Linux和Mac
  * 变成闭源。目标是运行Prey Demo（xieby1：Prey是一款游戏），使用OpenGL，工作量不大。
  * 目标变成d3d程序，然后又变成了d3d10程序。
  * 现在变成了在winxp上的d3d10函数库（xieby1：大概就是github能找到那个Alky吧）。实现十分不完善。

2008.1.7项目宣布失败

* 有人转发了Cody Brocious（xieby1：即刘先喆发的OS news新闻里提到的PyMusique作者之一）宣布Alky失败，开放源码。LGPL证书。包含两部分，
  * 转换器，可以转换Prey Demo到Linux和OSX上。
  * DirectX10兼容运行时，只能在Windows XP上用。（xiby1：这个重任现在由Vulkan肩负起来了！）
* marcodasilva：可以借用Alky代码到WINE里来吗
* stefandoesinger：WINE有框架，要加几小时，但是Alky实现太简单了是hello world级别的。

