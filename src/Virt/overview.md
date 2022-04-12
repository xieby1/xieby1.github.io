<div style="text-align:right; font-size:3em;">2021.05.21</div>

看到Hackers News对[SimpleVisor – Intel VT-x hypervisor in 500 lines of C code](https://ionescu007.github.io/SimpleVisor/)的[讨论](https://news.ycombinator.com/item?id=27227683)。
排名第一的回答感觉算是能够引人进入虚拟化大门。

> A V86 hypervisor is relatively simpler, and a lot of DOS utilities in the late 80s throughout the 90s took advantage of V86 mode, like the (in)famous EMM386 and debuggers like 386SWAT and CUP386. It is a little-known (or perhaps known but little-appreciated) fact that Windows 3.x Enhanced Mode and Win9x are actually architecturally based on a V86 hypervisor and "library OS" concept, instead of a traditional OS like the various Unices, Linux, and the NT line. They also perform "hyperjacking" of the DOS environment at boot time.
>
> I do wish Intel had simply extended V86 mode to a "V386" mode, as this interesting discussion suggests, instead of adding completely new and different instructions and data structures: http://www.os2museum.com/wp/an-old-idea-x86-hardware-virtualization/
>
> *all while containing the ability to run on every recent version of 64-bit Windows*
>
> The presence of that one little extra word "on" changes everything...

