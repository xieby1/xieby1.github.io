<div style="text-align:right; font-size:3em;">2020.3.17</div>

github克隆llvm-project实在是太慢了，在gitee上找了一个从llvm-project的fork出来的项目，然后再从github上pull新增的commit即可。用`git remote add <remote_name> <remote_url>`和`git fetch <remote_name>`。

## 测试mctoll的类型系统

**注**：我用浮点类型会出问题，是不是因为目前版本的mctoll暂时不支持xmm寄存器。但是浮点和MMX共用寄存器啊。

```c
#include<stdio.h>

void func(void){return;}

int main(void)
{
        char c = 'c';
        int i = 113;
        int *ptr = &i;
        void (*funcPtr)(void);
        funcPtr = &func;
        printf("%c, %d, 0x%lx, 0x%lx\n", c, i, ptr, funcPtr);
        return 0;
}
```

gcc编的这个项目有mctoll还没有添加的外部函数`__stack_chk_fail`，报错信息来自`llvm/tools/llvm-mctoll/ExternalFunctions.cpp`，当然这可以一定程度上看出mctoll处理外部函数的方法，体现列了一张已知外部函数表。

clang编出来的就没问题，用mctoll提升出来的llvm ir如下，

```assembly
; ModuleID = '/home/xieby1/Codes/testMctoll/testTypeClang'
source_filename = "/home/xieby1/Codes/testMctoll/testTypeClang"

@rodata_14 = private unnamed_addr constant [26 x i8] c"\01\00\02\00%c, %d, 0x%lx, 0x%lx\0A\00", align 4, !ROData_SecInfo !0

define dso_local void @func() {
entry:
  %RSP = alloca i64, align 8
  %0 = ptrtoint i64* %RSP to i64
  ret void
}

declare dso_local i32 @printf(i8*, ...)

define dso_local i32 @main() {
entry:
  %StackAdj = alloca i64, align 8
  %StackAdj4 = alloca i64, align 8
  %0 = alloca i32, align 4
  %1 = alloca i64, align 8
  %2 = alloca i64, i32 2, align 8
  %3 = alloca i8, align 1
  %4 = alloca i32, align 4
  %5 = alloca i64, align 8
  %RSP = alloca i64, i32 6, align 8
  %6 = ptrtoint i64* %RSP to i64
  %RCX = ptrtoint i64* %5 to i64
  store i32 0, i32* %4, align 4
  store i8 99, i8* %3, align 1
  %7 = zext i32 113 to i64
  store i64 %7, i64* %5, align 4
  store i64 %RCX, i64* %2, align 8
  %8 = ptrtoint void ()* @func to i64
  store i64 %8, i64* %1, align 8
  %9 = bitcast i8* %3 to i32*
  %memload = load i32, i32* %9, align llvm4
  %10 = trunc i32 %memload to i8
  %ESI = sext i8 %10 to i32
  %11 = bitcast i64* %5 to i32*
  %memload1 = load i32, i32* %11, align 4
  %memload2 = load i64, i64* %2, align 8
  %memload3 = load i64, i64* %1, align 8
  %EAX = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([26 x i8], [26 x i8]* @rodata_14, i32 0, i32 4), i32 %ESI, i32 %memload1, i64 %memload2, i64 %memload3)
  store i32 %EAX, i32* %0, align 4
  ret i32 0
}

!0 = !{i64 4195776}
```

可以看出char，int，指针，函数类型都正确的反映出来了。