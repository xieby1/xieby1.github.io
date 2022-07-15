<div style="text-align:right; font-size:3em;">2022.07.11</div>

# X86MMU (X86TLB) in gem5

## Initialization

* ./src/cpu/BaseCPU.py:

  ```python
  ...
  elif buildEnv['TARGET_ISA'] == 'x86':
    from m5.objects.X86MMU import X86MMU as ArchMMU
    ...
  ```

  ```python
  class BaseCPU(ClockedObject):
    ...
    mmu = Param.BaseMMU(ArchMMU(), "CPU memory management unit")
    ...
  ```

## ICache Access

Q: fetch size?

### Req

* src/cpu/o3/fetch.cc:

  ```cpp
  void Fetch::fetch(bool &status_change)
  ```

  * src/cpu/o3/fetch.cc:

    ```cpp
    bool Fetch::fetchCacheLine(Addr vaddr, ThreadID tid, Addr pc)
    ```

    * src/arch/generic/mmu.cc:

      ```cpp
      void BaseMMU::translateTiming(...)
      ```

      * src/arch/x86/tlb.cc:

        ```cpp
        void TLB::translateTiming(const RequestPtr &req, ThreadContext *tc,
            BaseMMU::Translation *translation, BaseMMU::Mode mode)
        {
          ...
          TLB::translate(req, tc, translation, mode, delayedResponse, true);
          ...
          translation->finish(fault, req, tc, mode);
        }
        ```

        * src/cpu/o3/fetch.cc:

          ```cpp
          void Fetch::finishTranslation(const Fault &fault, const RequestPtr &mem_req)
          {
            ...
            icachePort.sendTimingReq(data_pkt);
            ...
          }
          ```

### Resp

* src/cpu/o3/fetch.cc:

  ```cpp
  bool Fetch::IcachePort::recvTimingResp(PacketPtr pkt)
  {
    ...
    fetch->processCacheCompletion(pkt);
    ...
  }
  ```

  * src/cpu/o3/fetch.cc:

    ```cpp
    void Fetch::processCacheCompletion(PacketPtr pkt)
    {
      ...
      memcpy(fetchBuffer[tid], pkt->getConstPtr<uint8_t>(), fetchBufferSize);
      ...
      cpu->wakeCPU();
      switchToActive();
      fetchStatus[tid] = IcacheAccessComplete;
      ...
    }
    ```

<div style="text-align:right; font-size:3em;">2022.07.06</div>

## ITLB

X86 TLB miss handling in SE is not delayed, will be finished within the same cycle.

Instead, which in FS will be timing.
Therefore, event schedules.

Below, I focus on FS version TLB miss handling.

### TLB miss handling

#### Send request to walker cache

* src/cpu/o3/fetch.cc:

  ```cpp
  bool Fetch::fetchCacheLine(Addr vaddr, ThreadID tid, Addr pc {...}
  ```

  * src/arch/generic/mmu.cc:

    ```cpp
    void BaseMMU::translateTiming(...)
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

#### Recieve response from walker cache

* src/arch/x86/pagetable_walker.cc:

  ```cpp
  bool Walker::recvTimingResp(PacketPtr pkt) {
    ...
    bool walkComplete = senderWalk->recvPacket(pkt);
    ...
  }
  ```

  * src/arch/x86/pagetable_walker.cc:

    ```cpp
    bool Walker::WalkerState::recvPacket(PacketPtr pkt)
    {

    }
    ```
