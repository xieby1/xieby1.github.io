<div style="text-align:right; font-size:3em;">2021.06.01</div>

**背景**：给3a5000的UOS换源后，apt自动删除了包括桌面的诸多程序。

参考`man x`

> If  you want to always have X running on your display, your site administrator
> can set your machine up to use a Display Manager such as
> xdm,  gdm,  or kdm.  This program is typically started by the system
> at boot time and takes care of keeping the server running  and  getting
> users logged in.

在服务目录`/etc/systemd/system/display-manager.service`，找到了Display Manager！

UOS使用lightdm，启动lightdm后，登录界面恢复，图形的命令行出现壁纸出现，但是没有桌面。

<div style="text-align:right; font-size:3em;">2021.04.12</div>

* bing: x11 architecture
  * https://developer.gnome.org/gtk4/stable/gtk-X11-arch.html
    * 《Xlib Programming Manual》 by Adrian Nye