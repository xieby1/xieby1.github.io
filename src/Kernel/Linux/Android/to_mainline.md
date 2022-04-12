<div style="text-align:right; font-size:3em;">2021.10.08</div>

前言：今天突然想看这个是因为

* waydroid
  * 安装提示`ashmem_linux`内核模块加载不上
    * 突然想起anbox
      * 突然想起为啥waydroid官方没提ashmem的事
        * 突然想起大概未来版本ubunut已经有ashmem了
          * 于是想重新看看安卓和主分支的事
            * 搜索lwn ashmem就搜索了之前文章

[2011: LWN: Bringing Android closer to the mainline](https://lwn.net/Articles/472984/)

当时安卓分支还没有移植到主分支的内容：

* Binder：跨进程通讯

* Logger：安卓的log系统

* low memory killer

* Pmem：大块连续内存分配器
  * 其提供给用户空间连续分配的特性不应该被加入主分支
  * 替代方案[CMA](https://lwn.net/Articles/447405/)
    * 有提到预留物理内存做单独的用途，很有学习价值-mtlb方案。
  
* RAM console

* Timed GPIO

* ashmem：匿名共享内存

  * Linux创建匿名共享页的方法[2011: LWN: ashmem](https://lwn.net/Articles/473080/)

    * > creating a file in /tmp (tmpfs), truncating it, unlinking it, and passing the fd
