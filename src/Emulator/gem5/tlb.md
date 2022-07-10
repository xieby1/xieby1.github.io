<div style="text-align:right; font-size:3em;">2022.07.06</div>

# TLB in Gem5

X86 TLB miss handling in SE is not delayed, will be finished within the same cycle.

Instead, which in FS will be timing.
Therefore, event schedules.

Below, I focus on FS version TLB miss handling.

## TLB miss handling

### Send request to walker cache

* src/cpu/o3/fetch.cc:

  ```cpp
  bool Fetch::fetchCacheLine(Addr vaddr, ThreadID tid, Addr pc {...}
  ```

  * src/arch/x86/tlb.cc:

    ```cpp
    void TLB::translateTiming(const RequestPtr &req, ThreadContext *tc,
      BaseMMU::Translation *translation, BaseMMU::Mode mode)
    { ... }
    ```

    * src/arch/x86/tlb.cc:

      ```cpp
      Fault
      TLB::translate(const RequestPtr &req,
              ThreadContext *tc, BaseMMU::Translation *translation,
              BaseMMU::Mode mode, bool &delayedResponse, bool timing) {...}
      ```

      * src/arch/x86/pagetable_walker.cc:

        ```cpp
        Fault
        Walker::start(ThreadContext * _tc, BaseMMU::Translation *_translation,
                      const RequestPtr &_req, BaseMMU::Mode _mode)
        {...}
        ```

        * src/arch/x86/pagetable_walker.cc:

        ```cpp
        Fault Walker::WalkerState::startWalk() {
          ...
          sendPackets();
          ...
        }
        ```

### Recieve response from walker cache

* src/arch/x86/pagetable_walker.cc:

  ```cpp
  bool Walker::recvTimingResp(PacketPtr pkt) {...}
  ```
