<div style="text-align:right; font-size:3em;">2022.09.26</div>

# Seaborn

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
