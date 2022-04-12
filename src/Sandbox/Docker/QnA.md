<div style="text-align:right; font-size:3em;">2020.09.06</div>

## docker和chroot异同

**前言**：在问这个问题前，我心里有一个大概的答案，docker要隔离文件系统（假如没有写的需求，那么是否可以不隔离文件系统？）和进程，chroot只隔离文件系统。我想详细弄清这个问题。

---

**参考**：Stack Overflow：[Chroot vs Docker](https://stackoverflow.com/questions/46450341/chroot-vs-docker)，复制高赞如下，

> Docker allows to isolate a process at multiple levels through namespaces:
>
> - mnt namespace provides a root filesystem (this one can be compared to chroot I guess)
> - pid namespace so the process only sees itself and its children
> - network namespace which allows the container to have its dedicated network stack
> - user namespace (quite new) which allows a non root user on a host to be mapped with the root user within the container
> - uts provides dedicated hostname
> - ipc provides dedicated shared memory
>
> All of this adds more isolation than chroot provides

