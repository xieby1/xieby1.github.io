2020.3.23

## ir1=>ir2=>native的过程：

* `x86-qemu-mips/target/i386/X86toMIPS/x86tomips-config.c: target_x86_to_mips_host(...)`
  *  ` tr_translate_tb(TB, ETB) `
    * `tr_ir2_generate(ETB1, ETB2)`

### ir1和ir2是否会被清理？

其中tr_data里装ir1链表指针和，ETB2里（TranslationBlock里的ETB里）装ir1表的指针，

也就是说ir1列表和ir2列表都存在`lsenv->tr_data`所以翻译玩成后翻译下一个TB前，ir2列表就被清理了？

ETB（ir1）是有存储在hash表里的，所以只要ETB（ir1）数量没有溢出就一直保留。



哪里修改过ir2_inst_array

tr_init