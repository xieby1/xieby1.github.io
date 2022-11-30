<div style="text-align:right; font-size:3em;">2022.10.20</div>

## bokeh

无法输出pdf

## plotly

输出静态图片的后端老orca新kaleido nixos都不支持。

<div style="text-align:right; font-size:3em;">2022.10.19</div>

## matplotlib

不支持中文！！？？

<div style="text-align:right; font-size:3em;">2022.09.26</div>

## Seaborn

缺点：

* 说是可以从多个层次操作，包括seaborn层次、matplotlib层次。
  实际体验seaborn可操作空间很小，暴露的matplotlib文档又少。

  * 我现在使用的nixos22.05采用的seaborn的版本为0.11.2，
    最新seaborn版本为0.12.0，新增了一套decalarative操作。
    但是，暴露结构更少了。
    老版本relplot()可以返回matplotlib.axes.Axes，
    新版本Plot.add()只返回Plotter根本看不到matplotlib？
    Plot.on()是提供，不是叠加？
    layer概念根本不能发挥作用。

    尝试在折线图的线上添加标签，太难了。
    尝试的以下方法，
    https://stackoverflow.com/questions/43573623/how-can-i-plot-the-label-on-the-line-of-a-lineplot

* 图不能互动
<div style="text-align:right; font-size:3em;">2021.06.22</div>

忘记怎么搜索到的了，搜索到了[中科院科研信息素养讲堂：VOSviewer文献可视化](http://il.las.ac.cn/course/detail?id=470b9e386893892bc5d3a6dc5b6c7e00)，相关给我推荐了好几个可视化分析软件，以及相关软件

* [VOSviewer](https://www.vosviewer.com/)，开源，文献的多种关系可视化，java，感觉不错。使用发现UI都好小，没有找到调整的地方。提到了“bibliometric networks”这个词
* [Citespace](https://citespace.podia.com/)，开源，文献引用可视化，java，官网说明很少，不太会介绍自己的样子，试用运行很低效，文档收费？
* [Gephi](https://gephi.org/)，开源，通用可视化，看起来很老旧，一点也不直观！
  * Graphviz，开源，通用可视化，似乎之前用过？命令行？
* Reaxys

[知乎：vosviewer与citespace区别？](https://www.zhihu.com/question/389455103/answer/1173552363)说citespace更厉害。
