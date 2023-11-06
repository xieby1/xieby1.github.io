gem5启动会调用两次src/base/loader/elf_object.cc: `gem5::loader::ElfObject::ElfObject`

* src/python/m5/main.py
  * ...
    * configs/deprecated/example/se.py:
      ```python
      system.cpu[i].workload = multiprocesses
      ```
      这里是把真正的process的python类给system.cpu[i].workload，但此刻应该还没调用cpp的初始化process的接口。因此这里不是第一次调用ElfObject的地方。

      ```python
      system.workload = SEWorkload.init_compatible(mp0_path)
      ```
      这里`system.workload`拿到的应该只是一个类：src/arch/x86/X86SeWorkload.py: `X86EmuLinux(SEWorkload)`

      * src/sim/Workload.py
        1️⃣第一次调用obj = object_file.create(path)，仅仅为了判断elf的ISA和系统。
        python的object_file.create和cpp的ObjectFile.createObejectFile是绑定起来的
        绑定代码：python/pybind11/object_file.cc
      * configs/common/Simulation.py: `run_elfie(.., system, ..)`
        * src/python/m5/simulate.py: `m5.instantiate(None)`
          ```python
          # Create the C++ sim objects and connect ports
          for obj in root.descendants():
          obj.createCCObject()
          ```
          这里会调用root中的每个SimObject的createCCObject()方法
          * src/python/m5/SimObject.py:
            ```python
            def createCCObject(self):
              if self.abstract:
                  fatal(f"Cannot instantiate an abstract SimObject ({self.path()})")
              self.getCCParams()
              self.getCCObject()  # force creation

            def getCCParams(self):
              ...
              cc_params_struct = getattr(m5.internal.params, f"{self.type}Params")
              ...
            ```
            这里的`cc_params_struct`是拿到了cpp结构体的python bind。
            用Process类举个例子。
            * build/X86/python/_m5/param_Process.cc:
              ```cpp
              py::module_ m = m_internal.def_submodule("param_Process");
                  py::class_<ProcessParams, SimObjectParams, std::unique_ptr<ProcessParams, py::nodelete>>(m, "ProcessParams")
                      .def(py::init<>())
                      .def("create", &ProcessParams::create)
                      ...
              ```
              在python类param_Process类中添加了绑定cpp类ProcessParams和gem5_COLONS_Process。
              这个文件咋生成的之后再来看吧。
              这里把param_Process.ProcessParams.create绑定上了ProcessParams::create函数。
            * src/python/m5/internal/params.py:
              ```python
              for name, module in inspect.getmembers(_m5):
                if name.startswith("param_") or name.startswith("enum_"):
                  exec(f"from _m5.{name} import *")
              ```
              将所有param_开头的python模块中的变量都import了，即包含了param_Process.ProcessParams。

            因此再重复一遍贴上面的代码
            ```python
            cc_params_struct = getattr(m5.internal.params, f"{self.type}Params")
            ```
            这里的cc_params_struct就是param_Process.ProcessParams是cpp类ProcessParams的绑定！

          然后src/python/m5/SimObject.py:

          ```python
          def getCCObject(self):
            ...
              params = self.getCCParams()
              self._ccObject = params.create()
          ```
          这里调用params.create()即ProcessParams的create()
          2️⃣这里是第二次调用`gem5::loader::ElfObject::ElfObject`的地方！
