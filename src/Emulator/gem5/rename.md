<div style="text-align:right; font-size:3em;">2022.07.21</div>

* src/cpu/o3/rename.cc:

  ```cpp
  void Rename::rename(bool &status_change, ThreadID tid) {
    ...
    if (renameStatus[tid] == Running ||
      renameStatus[tid] == Idle) {
      DPRINTF(Rename, "[tid:%i] "
        "Not blocked, so attempting to run stage.\n",
        tid);
      renameInsts(tid);
    ...
  }
  ```

  * src/cpu/o3/rename.cc:

    ```cpp
    void Rename::renameInsts(ThreadID tid) {
      ...
      renameSrcRegs(inst, inst->threadNumber);
      ...
    }
    ```

    * src/cpu/o3/rename.cc:

      ```cpp
      void Rename::renameSrcRegs(const DynInstPtr &inst, ThreadID tid) {
        ...
        renamed_reg = map->lookup(tc->flattenRegId(src_reg));
        ...
      }
      ```

      * src/cpu/o3/rename_map.hh:

        ```cpp
        /// UnifiedRenameMap
        PhysRegIdPtr lookup(const RegId& arch_reg) const {
          ...
          return intMap.lookup(arch_reg);
          ...
        }
        ```

        * src/cpu/o3/rename_map.hh:

          ```cpp
          /// SimpleRenameMap
          PhysRegIdPtr lookup(const RegId& arch_reg) const {

          }
          ```
