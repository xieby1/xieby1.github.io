<div style="text-align:right; font-size:3em;">2021.03.15</div>

# C++11访存顺序

术语：lockless不使用锁，lock free不会被锁（死锁、活锁）

参考https://en.cppreference.com/w/cpp/atomic/memory_order

## Relaxed ordering

`memory_order_relaxed`

线程间&内无序

## Release-Acquire ordering

`memory_order_`&`memory_order_acquire`

> That is, once the atomic load is completed, thread B is guaranteed to see **everything** thread A wrote to memory.

> The synchronization is established only between the threads *releasing* and *acquiring* **the same** atomic variable. **Other** threads can see different order of memory accesses than either or both of the synchronized threads.

> On strongly-ordered systems — x86, SPARC TSO, IBM mainframe, etc. — release-acquire ordering is automatic for the majority of operations. No additional CPU instructions are issued for this synchronization mode; only certain compiler optimizations are affected (e.g., the compiler is prohibited from moving non-atomic stores past the atomic store-release or performing non-atomic loads earlier than the atomic load-acquire). On weakly-ordered systems (ARM, Itanium, PowerPC), special CPU load or memory fence instructions are used.

## Release-Consume ordering

`memory_order_release`&`memory_order_consume`

> that is, once the atomic load is completed, those operators and functions in thread B that use the value obtained from the load are guaranteed to see what thread A wrote to memory.

注：只有相关的变量才会同步和Release-Acquire的everything区别。

## Sequentially-consistent ordering

`memory_order_seq_cst`

太长了

<div style="text-align:right; font-size:3em;">2021.03.16</div>

# LWN关于访存顺序的文章

当时看memory order的c++特性是因为LWN的[An introduction to lockless algorithms](https://lwn.net/Articles/844224/)，
其中一些术语的理解简述如下：

* "happens before"是多进程指令执行的偏序关系

**Articles in this series**: （老到新）

- [Relaxed access and partial memory barriers](https://lwn.net/Articles/846700/)

  `WRITE_ONCE()`和`READ_ONCE()`的ONCE是立刻的意思。本意是在relaxed-ordering中保证原子性，即若没原子性可能会使

  > the result could include parts of an old value and parts of a new value

- [Full memory barriers](https://lwn.net/Articles/847481/)

- [Compare-and-swap](https://lwn.net/Articles/847973/)

- (Stay tuned for more)