<div style="text-align:right; font-size:3em;">2023.02.04</div>

## kwin

https://github.com/waydroid/waydroid/issues/49

kwin_wayland

## 联网问题还未解决

清理缓存了一下就可以了，参考https://wiki.archlinux.org/title/Waydroid

* Make sure your Waydroid package is up to date;
* Make sure you have the latest Waydroid image by running

  ```
  # waydroid upgrade
  ```
* Reset Waydroid: stop the waydroid-container.service, run

  ```
  # waydroid init -f
  ```

  and start the service again.

* You may also want to do little cleanup, run

  ```
  # rm -rf /var/lib/waydroid /home/.waydroid
  $ rm -rf ~/waydroid ~/.share/waydroid ~/.local/share/applications/*aydroid* ~/.local/share/waydroid
  ```

<div style="text-align:right; font-size:3em;">2021.10.07</div>

/var/lib/waydroid/images

<div style="text-align:right; font-size:3em;">2021.10.09</div>

垃圾ubuntu20不让我切换到wayland所以用不了waydroid

准备试试ubuntu21
