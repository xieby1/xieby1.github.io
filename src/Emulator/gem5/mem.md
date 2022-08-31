<div style="text-align:right; font-size:3em;">2022.08.18</div>

# Mem in Gem5

For mem access inst, IEW will call `initiateAcc` instead of `execute`.
The calling process is as follow.

* src/cpu/o3/iew.cc:

  ```cpp
  IEW::executeInsts() {
    ...
    if (inst->isMemRef()) {
      ...
      fault = ldstQueue.executeStore(inst);
      ...
    }
    ...
  }
  ```

  * src/cpu/o3/lsq.cc:

    ```cpp
    Fault LSQ::executeStore(const DynInstPtr &inst) {
      ThreadID tid = inst->threadNumber;
      return thread[tid].executeStore(inst);
    }
    ```

    * src/cpu/o3/lsq_unit.cc:

      ```cpp
      Fault LSQUnit::executeStore(const DynInstPtr &store_inst) {
        ...
        Fault store_fault = store_inst->initiateAcc();
        ...
      }
      ```

Here initiateAcc of inst is called.
Take Xa_st for an example.

* build/X86/arch/x86/generated/exec-ns.cc.inc:

  ```cpp
  Fault Xa_st::initiateAcc(ExecContext *xc, Trace::InstRecord *traceData) const {
    ...
    fault = writeMemTiming(xc, traceData, Mem, dataSize, EA, memFlags, NULL);
    ...
  }
  ```

  * src/arch/x86/memhelpers.hh:

    ```cpp
    template <size_t N>
    static Fault
    writeMemTiming(ExecContext *xc, Trace::InstRecord *traceData,
        std::array<uint64_t, N> &mem, unsigned dataSize,
        Addr addr, unsigned flags, uint64_t *res) {
      ...
      return writePackedMem<uint64_t, N>(xc, mem, addr, flags, res);
      ...
    }
    ```

    * src/arch/x86/memhelpers.hh:

      ```cpp
      template <typename T, size_t N>
      static Fault
      writePackedMem(ExecContext *xc, std::array<uint64_t, N> &mem, Addr addr,
          unsigned flags, uint64_t *res) {
        ...
        return xc->writeMem((uint8_t *)&real_mem, size, addr, flags, res, byte_enable);
      }
      ```

      * src/cpu/o3/dyn_inst.cc:

        ```cpp
        Fault DynInst::writeMem(uint8_t *data, unsigned size, Addr addr,
            Request::Flags flags, uint64_t *res,
            const std::vector<bool> &byte_enable) {
          assert(byte_enable.size() == size);
          return cpu->pushRequest(
            dynamic_cast<DynInstPtr::PtrType>(this),
            /* st */ false, data, size, addr, flags, res, nullptr,
            byte_enable);
        }
        ```

        * src/cpu/o3/cpu.hh:

          ```cpp
          Fault pushRequest(...) {
            return iew.ldstQueue.pushRequest(inst, isLoad, data, size, addr,
              flags, res, std::move(amo_op), byte_enable);
          }
          ```

          * src/cpu/o3/lsq.cc:

            ```cpp
            Fault LSQ:pushRequest(...) {
              ...
              request = new SingleDataRequest(...);
              ...
              request->initiateTranslation();
            }
            ```

            * src/cpu/o3/lsq.cc:

              ```cpp
              void LSQ::SingleDataRequest::initiateTranslation() {
                ...
                sendFragmentToTranslation(0);
                ...
              }
              ```

              * src/cpu/o3/lsq.cc:

                ```cpp
                void LSQ::LSQRequest::sendFragmentToTranslation(int i) {
                  numInTranslationFragments++;
                  _port.getMMUPtr()->translateTiming(req(i), _inst->thread->getTC(),
                    this, isLoad() ? BaseMMU::Read : BaseMMU::Write);
                }
                ```

                * src/arch/generic/mmu.cc:

                  ```cpp
                  void BaseMMU::translateTiming(...) {
                    return getTlb(mode)->translateTiming(req, tc, translation, mode);
                  }
                  ```

                  * src/arch/x86/tlb.cc:

                    ```cpp
                    void TLB::translateTiming(...) {
                      ...
                      Fault fault = TLB::translate(...);
                      ...
                    }
                    ```

