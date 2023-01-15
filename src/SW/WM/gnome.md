<div style="text-align:right; font-size:3em;">2023.01.10</div>

## 不同scale

仅wayland

* https://askubuntu.com/questions/662546/config-dual-monitors-with-quite-different-resolution?rq=1
  * https://askubuntu.com/questions/393400/is-it-possible-to-have-different-dpi-configurations-for-two-different-screens
    * https://wiki.archlinux.org/title/HiDPI#Multiple_displays

x11不支持

* https://gitlab.gnome.org/GNOME/gtk/-/issues/1753#:~:text=GTK%20difficult%20to%20use%20with%20mixed%20DPI%20monitors,4%20Version%20information%20...%205%20Additional%20information%20
* https://www.reddit.com/r/gnome/comments/i1b2d1/x11_scaling_issues_with_multiple_monitors/
* [Solved] http://wok.oblomov.eu/tecnologia/mixed-dpi-x11/

<div style="text-align:right; font-size:3em;">2023.01.04</div>

## 无线投屏

gnome network displays可以mirror输出到无线显示器，
但是不能join/extend输出到无线显示器。
最新进展见：
https://gitlab.gnome.org/GNOME/gnome-network-displays/-/issues/12

2023.01.13

* Google: gnome-network-displays virtual display
  * https://deskreen.com/lang-en
    * Is having a Virtual Display Adapter absolutely necessary when using Deskreen?
      * https://github.com/pavlobu/deskreen/discussions/86
        * jrpear: This looks promising, but says it's for X.org only: https://cgit.freedesktop.org/xorg/driver/xf86-video-dummy/

* Bing: xf86-video-dummy
  * https://askubuntu.com/questions/1229168/video-dummy-the-fake-display-with-without-monitor-connected-at-the-same-time
    * https://askubuntu.com/questions/453109/add-fake-display-when-no-monitor-is-plugged-in