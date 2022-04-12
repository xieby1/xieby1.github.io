# mmap特性

参考`man mmap`的说明，MAP_FIXED覆盖已有的映射，可能会带来意想不到的错误。建议的做法是先预留空间（大概就是PROT_NONE匿名页），然后在预留空间里边用MAP_FIXED。

mmap分配的空间相邻同属性会合并在一起。做了相关覆盖测试，见`Codes/test/libFeatures/mmap_override.c`。

mmap分配的空间大概只能通过/proc/[pid]/maps查看，毕竟`man mmap`里提供的一个情景多进程是在分配前看看/proc/[pid]/maps，毕竟查看pmap程序用的方法也是解析/proc/[pid]/maps里的内容。