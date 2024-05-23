Verilator: Coremark

* make -C smart_run/ runcase CASE=coremark SIM=verilator THREADS=8 -j
  * smart_run/Makefile: runcase
    * make -s compile
      * cd ./work && verilator $(SIMULATOR_OPT) $(SIMULATOR_DEF) $(SIMULATOR_LOG) $(SIM_FILELIST) $(SIM_DUMP) # 生成verilator编译需要的文件，其中SIM_FILELIST里写的是verilator的参数，一层一层看-f的文件后，就能看到C910_RTL_FACTORY/gen_rtl/filelists/C910_asic_rtl.fl包含了所有.v文件，
    * make -s buildcase CASE=coremark
      * make -s coremark_build
        * smart_run/setup/smart_cfg.mk: coremark_build:
          * cd ./work && make -s clean && make -s all CPU_ARCH_FLAG_0=c910  ENDIAN_MODE=little-endian CASENAME=coremark FILE=core_main >& coremark_build.case.log 
            * all : ${FILE}.pat ${FILE}.hex ${FILE}.elf ${FILE}.obj
              * %.pat: %.hex # 将coremark.hex转换为inst.pat（代码段）和data.pat（数据段）
    * make buildVerilator
      * ...
        * smart_run/logical/tb/sim_main1.cpp
        * ./smart_run/logical/tb/tb_verilator.v # 运行时会去读inst.pat和data.pat
    * cd ./work && obj_dir/Vtop # 执行Verilator


* smart_run/logical/filelists/tb_verilator.fl
  * smart_run/logical/tb/sim_main1.cpp
