linux-user的自修改代码

* main: signal_init
  * linux-user/signal.c: 582: sigaction(host_sig, host_signal_handler, NULL)注册
* 运行过程QEMU收到signal
  * host_signal_handler(int host_signum, void*pinfo, void *puc)
    * accel/tcg/user-exec.c: 253: cpu_signal_handler
      * 63: handle_cpu_signal(uintptr_t pc, siginfo_t *info, int is_write, sigset_t *old_set)
        * accel/tcg/translate-all.c: 151: page_unprotect(target_ulong address, uintptr_t pc)将页权限改为可些，且无效了对应TB

* 翻译过程中将TB对应的页设置为不可写host和guest的PAGE_WRITE位，**注**：PAGE_WRITE_ORG用作表示该页是否原本可写
  * accel/tcg/translate-all.c: tb_gen_code
    * 1850: tb_link_page
      * 1606: tb_page_add