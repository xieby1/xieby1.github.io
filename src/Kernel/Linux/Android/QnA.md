## Android内核和Linux内核的关系

**答**：Android内核在Linux内核上增了（网络上用裁剪这个词不太合适）许多补丁（上游补丁backport，新硬件的补丁等等）。

因为这些补丁，Android离Linux有距离，每次Linux进行更新时，Android更新会耗费非常大的力气合并来自Linux的更新。所以Linux开发者/维护者在不断地推进合并Android的工作。下面是LWN上历年关于合并Android的文章，

* [Bringing Android closer to the mainline](https://lwn.net/Articles/472984/) (December 20, 2011)
* [Running a mainline kernel on a cellphone](https://lwn.net/Articles/662147/) (October 28, 2015)
* [Bringing Android explicit fencing to the mainline](https://lwn.net/Articles/702339/) (October 5, 2016)
* [Bringing the Android kernel back to the mainline](https://lwn.net/Articles/771974/) (November 15, 2018)
* [Android kernel notes from LPC 2020](https://lwn.net/Articles/830979/) (September 10, 2020)