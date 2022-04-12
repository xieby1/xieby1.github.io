## 共享页

2020.8.6

**详细**：直系进程因为可以共享fd，所以mmap的标志位MAP_SHARED应该可以很简单的共享页（若是MAP_PRIVATE标志位，就是各个linux教程里常常提到的fork时copy-on-write的页）。但是非直系进程怎么处理？

2020.8.9

~~参考这篇问答[Process VS thread : can two processes share the same shared memory ? can two threads ?](https://stackoverflow.com/questions/11566780/process-vs-thread-can-two-processes-share-the-same-shared-memory-can-two-thr)中Gray的回答，~~

> ~~If a process has *not* been forked from another then they typically do not share any memory. One exception is if you are running two instances of the same program then they may share [code and maybe even static data segments](http://en.wikipedia.org/wiki/Data_segment#Program_memory) but no other pages will be shared.~~

~~即非直系进程间不会有共享的内存，有的话大概是代码段和静态数据段（大概是由ELF的加载器判断然后完成的？）~~

参考linux提供的系统调用

* `shmget`: Creating Shared Memory
* `shmat`: Attaching to Shared Memory
* `shmdt`: Dettaching to Shared Memory
* `shmctl`: Shared Meory Control

## 哪些操作会影响/proc/[pid]/maps

2020.8.10

参考`man proc`有关/proc/[pid]/maps的说明，系统调用mmap（当然也有munmap）添加和删除maps项，系统调用ptrace管理访问maps的权限。