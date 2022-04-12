<div style="text-align:right; font-size:3em;">2020.09.30</div>

**前言**：Autotools的用途、定位参考[Introducing the GNU Build System](https://www.gnu.org/software/automake/manual/html_node/GNU-Build-System.html#GNU-Build-System)，简而言之，`./configure && make && make install`和相关的标准参数被称作GNU Build System，Autotools用来生成GNU Build System。

<div style="text-align:right; font-size:3em;">2020.10.09</div>

现在看来还是不要用autools吧，参考批评autotools文章[2012.autotools_criticism.kamp..pdf](../../../Essays/GNU/2012.autotools_criticism.kamp..pdf)（来自Wikepedia的autotools页面的引用），而是去用更优秀的工具——CMake来替代autotools吧！