<div style="text-align:right; font-size:3em;">2022.08.27</div>

# Syscall in Gem5 SE

* build/X86/arch/x86/generated/exec-ns.cc.inc:

  ```cpp
  Fault Int80::execute(...) {
    return std::make_shared<SESyscallFault>();
  }
  ```

  `SESyscallFault` is a class, defined as below.

  * src/sim/faults.hh:

    ```cpp
    // A fault to trigger a system call in SE mode.
    class SESyscallFault : public FaultBase
    {
        const char *name() const override { return "syscall_fault"; }
        void invoke(ThreadContext *tc, const StaticInstPtr &inst=
                nullStaticInstPtr) override;
    };
    ```

TODO: In IEW the `SESyscallFault` will be invoke.

* src/sim/faults.cc:

  ```cpp
  void SESyscallFault::invoke(ThreadContext *tc, const StaticInstPtr &inst)
  {
      // Move the PC forward since that doesn't happen automatically.
      std::unique_ptr<PCStateBase> pc(tc->pcState().clone());
      inst->advancePC(*pc);
      tc->pcState(*pc);
      tc->getSystemPtr()->workload->syscall(tc);
  }
  ```

  Assume we run a 32bit linux program.

  * src/arch/x86/linux/se_workload.cc:

    ```cpp
    void EmuLinux::syscall(ThreadContext *tc) {
      ...
      syscallDescs32.get(rax)->doSyscall(tc);
    }
    ```

    * build/X86/sim/syscall_desc.cc:

      ```cpp
      void SyscallDesc::doSyscall(ThreadContext *tc) {
        ...
        SyscallReturn retval = executor(this, tc);
        ...
      }
      ```

      The executor is a lambda function, see below.

      * src/sim/syscall_desc.hh:

        ```cpp
        template <typename ...Args>
        static inline Executor buildExecutor(ABIExecutor<Args...> target) {
          return [target](SyscallDesc *desc, ThreadContext *tc) -> SyscallReturn {
            auto partial = [target,desc](ThreadContext *tc, Args... args) -> SyscallReturn {
              return target(desc, tc, args...);
            };
            return invokeSimcall<ABI, false, SyscallReturn, Args...>(tc, std::function<SyscallReturn(ThreadContext *, Args...)>(partial));
          };
        }
        ```

        `partial` will becomes `target` below.

        * build/X86/sim/guest_abi.hh:

          ```cpp
          template <typename ABI, bool store_ret, typename Ret, typename ...Args>
          Ret invokeSimcall(ThreadContext *tc, std::function<Ret(ThreadContext *, Args...)> target) {
            ...
            return guest_abi::callFrom<ABI, Ret, store_ret, Args...>(tc, state, target);
          }
          ```

          * TODO: build/X86/sim/syscall_emul.hh:

            Here is actual `write` syscall, which is used by printf.

            ```cpp
            template <class OS>
            SyscallReturn twriteFunc(SyscallDesc *desc, ThreadContext *tc, int tgt_fd, VPtr<> buf_ptr, int nbytes) {
              ...
            }
            ```
