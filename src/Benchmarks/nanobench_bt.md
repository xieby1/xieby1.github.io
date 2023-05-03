<div style="text-align:right; font-size:3em;">2023.03.05</div>

# NanoBench for Binary Translations

## x86-arm test platform

* M1/M2 MacOS
  * Virtual machine: PMU(Apple's performance counter) doesn't work in virtual machine.
  * Asahi Linux: 16K page size, rosetta doesn't work.
* raspberry pi3/4
  * Use ARMv8, some instructions are not available, (use gdb to print the illness instructions) such as `casa` which is not supported until ARMv8.1.
* lxy's arm development board
  * Throw segmentation exception before running rosetta, lxy guessing which is caused by virtual address space is small than rosetta needed.
* TODO: Kunpeng 920
