<div style="text-align:right; font-size:3em;">2022.07.06</div>

Q: How params are initialized in cpp object.

Take gem5 run configs/example/se.py for an example.

Example command:

```bash
./build/X86/gem5.debug \
  --debug-flags Exec,IntRegs \
    configs/example/se.py \
      --cpu-type O3CPU \
      --caches \
      -c ./tests/test-progs/hello/bin/x86/linux/hello
```

* src/sim/main.cc:

  ```cpp
  py::module_::import("m5").attr("main")();
  ```

  * src/python/m5/main.py:

    ```python
    def main():
      sys.argv = arguments
      sys.path = [ os.path.dirname(sys.argv[0]) ] + sys.path
      filename = sys.argv[0]
      filedata = open(filename, 'r').read()
      filecode = compile(filedata, filename, 'exec')
      ...
      exec(filecode, scope)
    ```

    `argv[0]` is configs/example/se.py.

    * configs/example/se.py:

      ```python
      Simulation.run(args, root, system, FutureClass)
      ```

      * configs/common/Simulation.py:

        ```python
        def run(options, root, testsys, cpu_class):
          ...
          m5.instantiate(checkpoint_dir)
          ...
          exit_event = benchCheckpoints(options, maxtick, cptdir)

          def benchCheckpoints(options, maxtick, cptdir):
            exit_event = m5.simulate(maxtick - m5.curTick())
            ...
        ```

        * src/python/m5/simulate.py:

          ```python
          def instantiate(ckpt_dir=None):
            ...
            root = objects.Root.getInstance()
            ...
            # Initialize the global statistics
            stats.initSimStats()
            # Create the C++ sim objects and connect ports
            for obj in root.descendants(): obj.createCCObject()
            for obj in root.descendants(): obj.connectPorts()
            # Do a second pass to finish initializing the sim objects
            for obj in root.descendants(): obj.init()
            # Do a third pass to initialize statistics
            stats._bindStatHierarchy(root)
            root.regStats()
            ...
            for obj in root.descendants(): obj.initState()
          ```

          The first event is scheduled by Process instance.

          * src/arch/x86/process.cc:

            ```cpp
            void I386Process::initState()
            {
              /// loads executable, intepreter
              X86Process::initState();
              /// set start pc.
              argsInit(PageBytes);
              ...
            }
            ```

            `X86Process::initState()` schedules the first event.

            * src/sim/process.cc:

              ```cpp
              void Process::initState()
              {
                // first thread context for this process... initialize & enable
                ThreadContext *tc = system->threads[contextIds[0]];
                // mark this context as active so it will start ticking.
                tc->activate();
                ...
              }
              ```

              * src/cpu/o3/cpu.cc:

              ```cpp
              void CPU::activateContext(ThreadID tid)
              {
                ...
                scheduleTickEvent(Cycles(0));
                ...
              }
              ```

              * src/cpu/o3/cpu.hh:

                ```cpp
                void scheduleTickEvent(Cycles delay)
                {
                  ...
                  schedule(tickEvent, clockEdge(delay));
                }
                ```

                `tickEvent` is initialized in CPU::CPU constructor @src/cpu/o3/cpu.cc.
                `tickEvent` wraps `void CPU::tick()` function.

                * src/cpu/o3/cpu.cc:

                  ```cpp
                  CPU::CPU(const O3CPUParams &params):
                    ...
                    tickEvent([this]{ tick(); }, "O3CPU tick",
                      false, Event::CPU_Tick_Pri),
                    ...
                  ```

                Inheritage:

                ```
                CPU -> BaseCPU -> ClockedObject -> SimObject -> EventManager
                                                             -> Serializable
                                                             -> Drainable
                                                             -> statistics::Group
                                                             -> Named
                                                -> Clocked
                ```

                `tickEvent` will be add

                * src/sim/eventq.hh:

                  `CPU` inherits `schedule` from `EventManager`.

                  ```cpp
                  void schedule(Event &event, Tick when) {
                    eventq->schedule(&event, when);
                  }
                  ```

                  `eventq` is initialized in SimObject's constructor.

                  * src/sim/sim_object.cc:

                    ```cpp
                    SimObject::SimObject(const Params &p)
                      : EventManager(getEventQueue(p.eventq_index)),
                        ...
                        { ... }
                    ```

                    As m5out/config.ini shows all sim objects' `eventq_index` are 0.

                  * src/sim/eventq.hh:

                    ```cpp
                    void schedule(Event *event, Tick when, bool global=false)
                    {
                      ...
                      insert(event);
                      ...
                    }
                    ```

            * src/arch/x86/process.cc:

              ```cpp
              template<class IntType>
              void
              X86Process::argsInit(int pageSize,
                                   std::vector<gem5::auxv::AuxVector<IntType>> extraAuxvs)
              {
                ...
                tc->pcState(getStartPC());
                ...
              }
              ```

        * src/python/m5/simulate.py:

          ```python
          def simulate(*args, **kwargs):
            ...
            sim_out = _m5.event.simulate(*args, **kwargs)
            ...
          ```

          * src/sim/init.cc:

            python module `_m5` is initialized by

            ```cpp
            GEM5_PYBIND_MODULE_INIT(_m5, EmbeddedPyBind::initAll)
            ```

            * src/python/pybind_init.hh:

              ```cpp
              #define GEM5_PYBIND_MODULE_INIT(name, func) \
              ...
              static auto m = ::pybind11::module_::create_extension_module( \
              #name, nullptr, &mod_def); \
              ...
              ```

              `create_extension_module` is a pybind api,
              which will create a new top-level module.
              See https://pybind11.readthedocs.io/en/stable/reference.html

            ```cpp
            void
            EmbeddedPyBind::initAll(py::module+ &_m5)
            {
              pybind_init_core(_m5);
              pybind_init_debug(_m5);
              pybind_init_event(_m5);
              pybind_init_stats(_m5);
            }
            ```

            * src/python/pybind11/event.cc:

              ```cpp
              void
              pybind_init_event(py::module_ &m_native)
              {
                py::module_ m = m_native.def_submodule("event");
                m.def("simulate", &simulate,
                      py::arg("ticks") = MaxTick);
              }
              ```

          * src/sim/simulate.cc:

            ```cpp
            GlobalSimLoopExitEvent *
            simulate(Tick num_cycles) {...}
            ```
