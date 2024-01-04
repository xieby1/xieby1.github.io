<div style="text-align:right; font-size:3em;">2023.11.15</div>

# 文档和代码

## 想法

不是第一次思考这个问题。
文档和代码分离，会使得开放者懒得（比如我）或者忘记去维护文档。
现有的用注释实现文档的方案都局限太大啦，比如[Doxygen](https://www.doxygen.nl/index.html)只能适用于几种语言，比如[NaturalDocs](https://github.com/NaturalDocs/NaturalDocs)。
它们只能用于部分语言，只能用于特点函数和类，只能生成风格单一的网站。

但，文档是非常通用的，可以反映局部的代码的具体含义，也可以用来记录作者的总体设计构思。

我期待的文档和代码共存框架：注释是后续代码的文档。
这样的设计很简单但也非常通用。
现代计算机语言都有注释功能，利用tree-sitter能够轻松准确地提取注释。
注释可以是Markdown格式，也可以是ReStructuredText格式。

## GitHub的文档

为什么今天又有了这样的想法？
在看[GitHub Action的文档](https://docs.github.com/en/actions/using-workflows/about-workflows#workflow-basics)时看到了*并排展示代码和注释*。
这个文档的源码位于[GitHub: github/docs](https://github.com/github/docs)。
简单阅读源码能够知道GitHub文档*并排代码注释*的技术栈：

* GFM Markdown的文档
* `remark`Markdown语法处理
* `unified`语法处理框架，将Markdown转换为HTML
  * 处理源码: `src/content-render/unified/index.js`
* `sass`生成css:
  * scss源码: `src/content-render/stylesheets/annotate.scss`
* `next.js`负责Javascript控制各种交互

GitHub这一套还是太复杂了，只能解析注释行，不能解析注释块（因为不是基于语法的解析，只是模式匹配。）
并且比较强的依赖于Next.js，来实现交互。
难以剥离成一个独立项目。

## 现在的想法

用Tree-sitter剥离各类源文件的特定注释，注释符紧跟者"MC"的注释为嵌入注释的Markdown（Markdown in Code），例如：

```c
//MC ## miao
//MC
//MC nyan
```
