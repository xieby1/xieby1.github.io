# Web Assembly and Linux GUI (GUI Shell)

<div style="text-align:right; font-size:3em;">2021.06.11</div>

昨天听说wdt准备去做高级语言虚拟机的实习，就在生日聚会上聊起了webAssembly。

今天在装整理窗口的gnome插件时，突然想到，gnome的图形界面是javascript驱动的，那么webAssembly相比javascript性能更高，在若能在桌面环境替换javascript，那么似乎可以大有可为。就像“Android-JVM-Linux”，之后会有“桌面-WasmVM-Linux”吗？

那么Android跨平台的尝试（intel曾尝试过的x86 Android，houdini）的失败，应该会有很多经验可以吸纳。二进制翻译也顺理成章的又有一大块稳定生长田地。

又查了一下准确的说应该是gnome shell是由javascript驱动，关系如下，

[Wikipedia: GNOME](https://en.wikipedia.org/wiki/GNOME)的graphic shell（即图形界面）目前有3个：

1. GNOME Classic
2. GNOME Flashback
3. GNOME Shell（默认）由javascript驱动

由查了一下deepin图形界面是QT写的，参考[Wikipedia: Deepin](https://en.wikipedia.org/wiki/Deepin)。

---

* google搜索“gnome shell javascript”

  * 2012: [Reddit: Why did GNOME choose to use JavaScript as the Shell's scripting language?](https://www.reddit.com/r/gnome/comments/r5r48/why_did_gnome_choose_to_use_javascript_as_the/)最高票回复大意是觉得python解释器太重量，Lua和javascript都不错，gnome大概有Mozilla背景，所以选了javascript。他推荐了两篇文章，

    * 2008: [Implementing the next Gnome Shell](http://blog.fishsoup.net/2008/10/22/implementing-the-next-gnome-shell/)

      * 文章的“Mozilla JS-1.7/JS-1.8”就是指Mozilla的[SpiderMonkey](https://spidermonkey.dev/)JS引擎

        主页的一句话简介已经是

        > SpiderMonkey is Mozilla’s JavaScript and WebAssembly Engine, ...

        WebAssembly！感觉自己的逻辑形成回路了！

    * 2008: [Embeddable languages, an implementation](http://blogs.gnome.org/alexl/2008/09/09/embeddable-languages-an-implementation/)

<div style="text-align:right; font-size:3em;">2020.11.25</div>

**前言**：lx平台，libmozjs.so替换为4k页版本的，4k页内核启动图形界面时会变快。

mozjs是mozilla的javascript引擎。为什么图形界面需要js？突然想起之前看gnome extension里边用的全是js！

Linux图形服务器X或Wayland（前者的替代品），在此之上是GNOME，用GTK图形编程。

引用[Javascript in GNOME](https://wiki.gnome.org/JavaScript)，

> The two projects (Gjs, Seed) have been in friendly competition, but since the adoption of Gjs by GNOME Shell, its usage has become more prevalent.

GNOME Shell就是指GNOME的图形界面。我一直不知道shell的明确意思，直到查了wikipedia的定义[Shell (computing)#GUI](https://en.wikipedia.org/wiki/Shell_(computing)#GUI)。shell为操作系统提供给用户的最外层接口，分为CLI和GUI！
