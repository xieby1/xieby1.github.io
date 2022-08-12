<div style="text-align:right; font-size:3em;">2022.08.11</div>

# Debug Gem5

## debug flags

* src/python/m5/main.py:

  ```python
  ...
  option("--debug-flags", metavar="FLAG[,FLAG]", action='append', split=',',
    help="Sets the flags for debug output (-FLAG disables a flag)")
  ...
  ```

  ```python
  if options.debug_flags:
    ...
    debug.flags[flag].enable()
  ```

  `debug.flags` is defined in src/python/m5/debug.py

  * src/python/m5/debug.py:

    ```python
    class AllFlags(Mapping):
    ...
      def __getitem__(self, item):
        self._update()
          return self._dict[item]
    ...
    flags = AllFlags()
    ```

    * src/python/m5/debug.py:

      ```python
      class AllFlags(Mapping):
        ...
        def _update(self):
          current_version = _m5.debug.getAllFlagsVersion()
          if self._version == current_version:
            return
          self._dict.clear()
          for name, flag in _m5.debug.allFlags().items():
              self._dict[name] = flag
          self._version = current_version
        ...
      ```

      * src/python/pybind11/debug.cc:

        ```cpp
        m_debug
          .def("getAllFlagsVersion",
            []() { return debug::AllFlagsFlag::version(); })
          .def("allFlags", &debug::allFlags, py::return_value_policy::reference)
          ...
        ```

        * src/base/debug.cc:

          ```cpp
          FlagsMap &allFlags()
          ```
