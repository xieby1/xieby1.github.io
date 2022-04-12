2021.8.2

https://www.kernel.org/doc/gorman/html/understand/index.html

chap 8

RAM
* Kernal code, kernel data structure
* Dynamic memory

Physical memory management
* contiguous memory
  * Page Frame Management
  * Memory Area Management
* non-contiguous memory
  * Noncontinuous Memory Area Management

memory zone
* DMA: <16MB
* NORMAL: 16MB-896MB 内核数据，虚存3GB-4GB
* HIGHMEM: >896MB
* 
* hhhhh

the pool of reserved page frames

内存不够时，会保留一部分做紧急使用