<div style="text-align:right; font-size:3em;">2021.09.14</div>

```c
/// 参考：Documentation/driver-api/ioctl.rst

include/uapi/asm-generic/ioctl.h
#define _IOC(dir,type,nr,size)
/// _IOR/W/WR的size应该输入变量类型，
/// size会经过一次sizeof！
332             1
109             5      87      0
[][size        ][type  ][nr    ]
dir

/// type: Documentation/userspace-api/ioctl/ioctl-number.rst
```
