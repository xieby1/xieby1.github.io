<div style="text-align:right; font-size:3em;">2021.06.16</div>

* https://github.com/termux/termux-packages/issues/5444，提示加 `-b /system` and `-b $PREFIX`
* https://github.com/termux/proot/issues/92，提示安卓10加-b apex

```shell
proot -S chroot/u20-x64/ -b /system -b $PREFIX -b /apex -q qemu-x86_64 /bin/bash
```

<div style="text-align:right; font-size:3em;">2021.06.17</div>

DONE: https://gist.github.com/rikka0w0/037b6266976ec6b806127cc41677933f
