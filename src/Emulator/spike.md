<div style="text-align:right; font-size:3em;">2022.08.09</div>

* spike_main/spike.cc:

  ```cpp
  int main(int argc, char** argv) {
    ...
    sim_t s(&cfg, halted,
      mems, plugin_devices, htif_args, dm_config, log_path, dtb_enabled, dtb_file,
  #ifdef HAVE_BOOST_ASIO
      io_service_ptr, acceptor_ptr,
  #endif
      cmd_file);
    ...
    auto return_code = s.run();
    ...
  }
  ```

  * riscv/sim.cc:

    ```cpp
    int sim_t::run() {
      ...
      target.init(sim_thread_main, this);
      ...
    }
    ```

    * riscv/sim.cc:

      ```cpp
      void sim_thread_main(void* arg) {
        ((sim_t*)arg)->main();
      }
      ```

      * riscv/sim.cc:

        ```cpp
        void sim_t::main() {
          ...
          while (!done()) {
            step(INTERLEAVE);
          ...
        }}
        ```

        * riscv/sim.cc:

          ```cpp
          void sim_t::step(size_t n) {
            for (size_t i = 0, steps = 0; i < n; i += steps) {
              ...
              procs[current_proc]->step(steps);
              ...
          }}
          ```
