<div style="text-align:right; font-size:3em;">2021.07.30</div>

* [How can I run my GUI application without desktop enviroment and make it fullscreen?](https://askubuntu.com/questions/889725/how-can-i-run-my-gui-application-without-desktop-enviroment-and-make-it-fullscre)

  提到了xdotool。测试了下，有能力操作没有全屏，没有贴边的窗口。

* [What is the best/recommended way to do simple full-screen GUI custom drawing?](https://raspberrypi.stackexchange.com/questions/74372/what-is-the-best-recommended-way-to-do-simple-full-screen-gui-custom-drawing)

  ![](https://upload.wikimedia.org/wikipedia/commons/thumb/9/95/Schema_of_the_layers_of_the_graphical_user_interface.svg/560px-Schema_of_the_layers_of_the_graphical_user_interface.svg.png)

  * https://unix.stackexchange.com/questions/93202/linux-operating-system-graphical-user-interface/93210#93210

    提到了window manager的作用是绘制titlebar, frame, free standing menu。

    像chrome, firefox这样的程序应该用的是自己绘制的titlebar，**所以要通过window manager来搞部分全屏不现实**。chrome里可以设置为Use system title bar and borders。

    **应该从更第低层次**。

---

Q：x11, x.org, xlib的关系？参考[what is the difference between X11 and Xlib?](https://unix.stackexchange.com/questions/118813/what-is-the-difference-between-x11-and-xlib)

A：前两者的关系如上图。xlib（也叫libx11）是X11 client（用户程序）使用X11 protocol的库。
所以为了避免xlib库不同（不同语言的binding，静态链接）的问题，**应该在X11 server上搞事情**。

要是一个程序在启动时就读了屏幕的长宽和位置，那全屏就没办法可变。

大概还是需要虚拟显示设备。

但是一般需求也不要时常变换，重启应用是可接受的！

---

xlib全屏的例子：

[XLIB How to make a window go fullscreen?](https://stackoverflow.com/questions/55111001/xlib-how-to-make-a-window-go-fullscreen)

大概就是`_NET_WM_STATE`改为`_NET_WM_STATE_FULLSCREEN`

在X11 server端插桩捕获这个行为。

