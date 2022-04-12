<div style="text-align:right; font-size:3em;">2021.12.18</div>

起因是为了做高级操作系统的作业：
分析Linux启动过程各类内存数据结构初始化。

https://0xax.gitbooks.io/linux-insides/content/Initialization/linux-initialization-1.html

booting process (decompress)(linux kernel setup code)(arch/x86/boot/compressed/head_32.S: `jmp *%eax`)

=>

init process (kernel code)(arch/x86/kernel/head_32.S: __HEAD)

=>

...

=>

init/main.c: start_kernel: to finish kernel initialization process and launch the first init process

<div style="text-align:right; font-size:3em;">2021.12.19</div>

## 启动过程中内核内存管理器memblock

### 初始化

https://www.kernel.org/doc/html/latest/core-api/boot-time-mm.html

* `x86_64_start_kernel` arch/x86/kernel/head64.c
  * `x86_64_start_reservations` arch/x86/kernel/head64.c
    * `start_kernel` init/main.c
      * `setup_arch` arch/x86/kernel/setup.c
        * `memblock_x86_fill` arch/x86/kernel/e820.c

`memblock_phys_alloc`分配物理内存

`memblock_alloc`分配物理内存

### 回收

看free memblock相关代码

* x86_64_start_kernel
  * x86_64_start_reservations
    * start_kernel
      * setup_per_cpu_areas arch/x86/kernel/setup_percpu.c
        * pcpu_embed_first_chunk
          * pcpu_fc_free
            * free_bootmem
              * memblock_free

mem_init中free_all_bootmem
调用之后会把after_bootmem置1

memblock中没有zone的概念，至少看memblock.c/.h中没有

`mem_init`会回收memblock，把内存交给buddy system

## zone

《UnderStanding The Linux Kernel》: Appendix A: System Startup: Modern Age

《UnderStanding The Linux Kernel》: Chapter 8: Memory Zones

### 数据结构

zone: include/linux/mmzone.h

struct pglist_data *node_data[] // 数组元素：每个NUMA节点的ZONE列表

### 初始化函数调用

* `x86_64_start_kernel` arch/x86/kernel/head64.c
  * `x86_64_start_reservations`
    * start_kernel
      * build_all_zonelists mm/page_alloc.c
        * __build_all_zonelists mm/page_alloc.c
          * build_zonelists
          * build_zonelist_cache

## buddy

《UnderStanding The Linux Kernel》: Chapter 8: The Buddy System Algorithm

* `x86_64_start_kernel` arch/x86/kernel/head64.c
  * `x86_64_start_reservations`
    * start_kernel
      * page_alloc_init /// 一个notify函数，用途未知
      * `mm_init` init/main.c
        * `mem_init` arch/x86/mm/init_64.c
          * free_all_bootmem
            * reset_all_zones_managed_pages /// 初始化各种变量
              * free_low_memory_core_early /// 释放memblock空的部分，添加到buddy system /// 若memblock可抛弃CONFIG_ARCH_DISCARD_MEMBLOCK，则将会释放所有memblock
                * for_each_free_mem_range: __free_memory_core
                  * __free_pages_memory
                    * __free_pages_bootmem mm/page_alloc.c
                      * __free_pages /// buddy system的接口 [TODO]https://www.kernel.org/doc/gorman/html/understand/understand009.html

## Per-CPU Page Frame Cache

3.18里似乎把code cache移除了。

### 初始化

qemu:NixOS中编译出来的kernel似乎不正常？在ubuntu20中也跑不了

搜索`pcp->count`找到的初始化函数pageset_init


* `x86_64_start_kernel` arch/x86/kernel/head64.c
  * `x86_64_start_reservations`
    * start_kernel
      * build_all_zonelists mm/page_alloc.c
        * __build_all_zonelists mm/page_alloc.c
          // 这一过程只初始化boot_pagesets
          // 实际pagesets在per cpu allocator可用后初始化
          * setup_pageset
            * pageset_init
            * pageset_set_batch
      * setup_per_cpu_pageset
        // 初始化每个zone（defconfig只有ZONE_DMA32和DMA_NORMAL）
        // 因此会执行两边下面的函数
        * setup_zone_pageset
          * zone_pageset_init
            * pageset_init


### 使用API

《UnderStanding The Linux Kernel》: Chapter 8: The Per-CPU Page Frame Cache

buffered_rmqueue


## slab

### 概况

参考[2014: linuxfound: Slab allocators in the Linux Kernel: SLAB, SLOB, SLUB]https://events.static.linuxfound.org/sites/events/files/slides/slaballocators.pdf

slab分配器目前有3类：SLOB（1991-1999），SLAB（1999-2008），SLUB（2008-今）

### 初始化

查看`mm/slab_common.c`的init相关函数

* `x86_64_start_kernel` arch/x86/kernel/head64.c
  * `x86_64_start_reservations`
    * start_kernel
      * `mm_init` init/main.c
        * kmem_cache_init mm/slub.c
          * create_boot_cache mm/slab_common.c
          * create_kmalloc_caches

## virt

在看mm_init时看到了vmalloc_init

* `x86_64_start_kernel` arch/x86/kernel/head64.c
  * `x86_64_start_reservations`
    * start_kernel
      * `mm_init` init/main.c
        * vmalloc_init

数据结构的关系：
vmap_block -> vmap_area -> vm_struct -> page

---

# 内存管理机制的初始化

谢本壹

## 编译配置

* 3.18内核
* ubuntu16 amd64
* defconfig
  * 额外添加debug支持`scripts/config --set-val DEBUG_INFO y --set-val DEBUG y  --set-val GDB_SCRIPTS y --set-val DEBUG_DRIVER y`

## 初始化简要时间线

* memblock初始化
* zone初始化
* 回收memblock，初始化buddy system，交由buddy system管理
* slab初始化
* 虚存初始化
* per cpu pageset初始化

## 代码调用&数据结构

* `x86_64_start_kernel` arch/x86/kernel/head64.c
  * `x86_64_start_reservations` arch/x86/kernel/head64.c
    * `start_kernel` init/main.c
      * `setup_arch` arch/x86/kernel/setup.c
        * `memblock_x86_fill` arch/x86/kernel/e820.c
          // memblock仅在启动初期使用，
          // 之后会被释放（可以配置成释放）
          // memblock中没有zone的概念，
          // 至少看memblock.c/.h中没有
          // 初始化从e820那到的内存布局
          // `memblock_phys_alloc`分配物理内存
          // `memblock_alloc`分配物理内存
      * setup_per_cpu_areas arch/x86/kernel/setup_percpu.c
        * pcpu_embed_first_chunk
          * pcpu_fc_free
            * free_bootmem
              * memblock_free
                // 释放memlock中的bootmem的部分
      * build_all_zonelists mm/page_alloc.c
        * __build_all_zonelists mm/page_alloc.c
          * build_zonelists
          * build_zonelist_cache
            // zone初始化
            // zone: include/linux/mmzone.h
            // struct pglist_data *node_data[]
            // 数组元素：每个NUMA节点的ZONE列表
          * setup_pageset
            // 初始化per cpu page frame cache
            // 这一过程只初始化boot_pagesets
            // 实际pagesets在后面per cpu allocator可用后初始化
            * pageset_init
            * pageset_set_batch
      * mm_init init/main.c
        * mem_init arch/x86/mm/init_64.c
          // mem_init回收memblock
          // 把内存交给buddy system
          * free_all_bootmem
            // free_all_bootmem调用之后会把after_bootmem置1
            // 标志memblock释放完成
            * reset_all_zones_managed_pages
              /// 初始化各种变量
              * free_low_memory_core_early
                /// 释放memblock空的部分，
                /// 添加到buddy system
                /// 若memblock可抛弃CONFIG_ARCH_DISCARD_MEMBLOCK
                /// 则将会释放所有memblock
                * for_each_free_mem_range: __free_memory_core
                  * __free_pages_memory
                    * __free_pages_bootmem mm/page_alloc.c
                      * __free_pages
                        /// buddy system的接口
      * `mm_init` init/main.c
        // slab分配器初始化
        // 参考[2014: linuxfound: Slab allocators in the Linux Kernel: SLAB, SLOB, SLUB]https://events.static.linuxfound.org/sites/events/files/slides/slaballocators.pdf
        // slab分配器目前有3类：
        // SLOB（1991-1999），
        // SLAB（1999-2008），
        // SLUB（2008-今）3.18采用这个
        * kmem_cache_init mm/slub.c
          * create_boot_cache mm/slab_common.c
          * create_kmalloc_caches
        * vmalloc_init
          // 初始化虚存分配器
          // 数据结构的关系：
          // vmap_block -> vmap_area -> vm_struct -> page
      * setup_per_cpu_pageset
        // 初始化per cpu page frame cache
        // 初始化每个zone（defconfig只有ZONE_DMA32和DMA_NORMAL）
        // 因此会执行两边下面的函数
        * setup_zone_pageset
          * zone_pageset_init
            * pageset_init


