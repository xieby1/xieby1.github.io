# Issue, Execute and Writeback in Gem5

<div style="text-align:right; font-size:3em;">2022.07.15</div>

* Q: how next pc (predPC) is generated?

TODO:

`StaticInst` contains

```cpp
advancePC(*next_pc)
```

`X86StaticInst` overrides `advancePC` from `StaticInst`.

`X86ISA::X86StaticInst` and `X86ISA::X86MicroopBase` override `advancePC` from `StaticInst`.

## macroop pc

* src/cpu/o3/fetch.cc:

  ```cpp
  Fetch::fetch(bool &status_change) {
    ...
    predictedBranch |= lookupAndUpdateNextPC(instruction, *next_pc);
    ...
  }
  ```

  * src/cpu/o3/fetch.cc:

    ```cpp
    bool
    Fetch::lookupAndUpdateNextPC(const DynInstPtr &inst, PCStateBase &next_pc) {
      ...
      inst->staticInst->advancePC(next_pc);
      ...
    }
    ```

    * src/arch/x86/insts/static_inst.hh:

      ```cpp
      advancePC(PCStateBase &pcState) const override {
          pcState.as<PCState>().advance();
      }
      ```

      * src/arch/x86/pcstate.hh:

        ```cpp
        advance() override {
            Base::advance();
            _size = 0;
        }
        ```

        * src/arch/generic/pcstate.hh:

          ```cpp
          advance() override {
              this->_pc = this->_npc;
              this->_npc += InstWidth;
          }
          ```

          The question becomes where and who calculates _npc?
