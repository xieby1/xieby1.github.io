<div style="text-align:right; font-size:3em;">2023.11.09</div>

```nix
# shell.nix
let
  pkgs = import <nixpkgs> {};
  my-conda = pkgs.conda.override {
    extraPkgs = with pkgs; [
      libxcrypt-legacy
    ];
  };
in pkgs.mkShell {
  name = "chipyard-nix-shell";
  packages = with pkgs; [
    my-conda
  ];
}
```

使用如上的shell.nix

TLDR: 步骤如下

```bash
# 进入nix-shell

# edit common.mk:1 SHELL=bash

git checkout 1.10.0
./scripts/init-submodules-no-riscv-tools-nolog.sh

cd sims/verilator
make

./simulator-chipyard-RocketConfig $RISCV/riscv64-unknown-elf/share/riscv-tests/isa/rv64ui-p-simple
```

## Chipyard on NixOS初试（Conda）

* 按照官方教程
  * https://chipyard.readthedocs.io/en/stable/Chipyard-Basics/Initial-Repo-Setup.html
    * 都没啥大问题，完全用conda管理依赖
  * https://chipyard.readthedocs.io/en/stable/Simulation/Software-RTL-Simulation.html
    * `cd sims/verilator`然后`make`会出现conda装的verilator使用的gcc找不到合适的版本dlopen调用，详细报错如下

      ```bash
      Running with RISCV=/home/xieby1/Codes/chipyard/.conda-env/riscv-tools
      make VM_PARALLEL_BUILDS=1 -C /home/xieby1/Codes/chipyard/sims/verilator/generated-src/chipyard.harness.TestHarness.RocketConfig/chipyard.harness.TestHarness.RocketConfig -f VTestDriver.mk
      make[1]: Entering directory '/home/xieby1/Codes/chipyard/sims/verilator/generated-src/chipyard.harness.TestHarness.RocketConfig/chipyard.harness.TestHarness.RocketConfig'
      /home/xieby1/Codes/chipyard/.conda-env/bin/x86_64-conda-linux-gnu-c++    SimDRAM.o SimJTAG.o SimTSI.o SimUART.o mm.o mm_dramsim2.o remote_bitbang.o testchip_tsi.o uart.o verilated.o verilated_dpi.o verilated_vpi.o verilated_timing.o verilated_threads.o VTestDriver__ALL.a   -L/home/xieby1/Codes/chipyard/.conda-env/riscv-tools/lib -Wl,-rpath,/home/xieby1/Codes/chipyard/.conda-env/riscv-tools/lib -L/home/xieby1/Codes/chipyard/sims/verilator -L/home/xieby1/Codes/chipyard/tools/DRAMSim2 -lriscv -lfesvr -ldramsim  -pthread -lpthread -latomic   -o /home/xieby1/Codes/chipyard/sims/verilator/simulator-chipyard.harness-RocketConfig
      /home/xieby1/Codes/chipyard/.conda-env/bin/../lib/gcc/x86_64-conda-linux-gnu/12.2.0/../../../../x86_64-conda-linux-gnu/bin/ld: /home/xieby1/Codes/chipyard/.conda-env/riscv-tools/lib/libriscv.so: undefined reference to `dlopen@GLIBC_2.2.5'
      collect2: error: ld returned 1 exit status
      make[1]: *** [VTestDriver.mk:93: /home/xieby1/Codes/chipyard/sims/verilator/simulator-chipyard.harness-RocketConfig] Error 1
      make[1]: Leaving directory '/home/xieby1/Codes/chipyard/sims/verilator/generated-src/chipyard.harness.TestHarness.RocketConfig/chipyard.harness.TestHarness.RocketConfig'
      make: *** [Makefile:210: /home/xieby1/Codes/chipyard/sims/verilator/simulator-chipyard.harness-RocketConfig] Error 2
      ```

      感觉conda但没有管理所有的依赖呀，比如glibc动态链接库就没管？所以才有这样的报错。
      感觉conda不太靠谱？
      试试完全由nix管理呢？

```bash
$ make -n -C sims/verilator
...
# verilator从verilog生成c的过程
verilator --main --timing --cc --exe -CFLAGS " -O3 -std=c++17 -I/nix/store/xayqnhsvx4z4h3cilgbf1k582pkpg054-riscv64-none-elf-stage-final-gcc-wrapper-12.2.0/include -I/home/xieby1/Codes/chipyard/tools/DRAMSim2 -I/home/xieby1/Codes/chipyard/sims/verilator/generated-src/chipyard.harness.TestHarness.RocketConfig/gen-collateral   -DVERILATOR -include /home/xieby1/Codes/chipyard/sims/verilator/generated-src/chipyard.harness.TestHarness.RocketConfig/chipyard.harness.TestHarness.RocketConfig.plusArgs" -LDFLAGS " -L/nix/store/xayqnhsvx4z4h3cilgbf1k582pkpg054-riscv64-none-elf-stage-final-gcc-wrapper-12.2.0/lib -Wl,-rpath,/nix/store/xayqnhsvx4z4h3cilgbf1k582pkpg054-riscv64-none-elf-stage-final-gcc-wrapper-12.2.0/lib -L/home/xieby1/Codes/chipyard/sims/verilator -L/home/xieby1/Codes/chipyard/tools/DRAMSim2  -lfesvr -ldramsim "   --threads 1 --threads-dpi all -O3 --x-assign fast --x-initial fast --output-split 10000 --output-split-cfuncs 100 --assert -Wno-fatal --timescale 1ns/1ps --max-num-width 1048576 +define+CLOCK_PERIOD=1.0 +define+RESET_DELAY=777.7 +define+PRINTF_COND=TestDriver.printf_cond +define+STOP_COND=!TestDriver.reset +define+MODEL=TestHarness +define+RANDOMIZE_MEM_INIT +define+RANDOMIZE_REG_INIT +define+RANDOMIZE_GARBAGE_ASSIGN +define+RANDOMIZE_INVALID_ASSIGN +define+VERILATOR --top-module TestDriver --vpi -f /home/xieby1/Codes/chipyard/sims/verilator/generated-src/chipyard.harness.TestHarness.RocketConfig/sim_files.common.f  -o /home/xieby1/Codes/chipyard/sims/verilator/simulator-chipyard.harness-RocketConfig -Mdir /home/xieby1/Codes/chipyard/sims/verilator/generated-src/chipyard.harness.TestHarness.RocketConfig/chipyard.harness.TestHarness.RocketConfig -CFLAGS "-include /home/xieby1/Codes/chipyard/sims/verilator/generated-src/chipyard.harness.TestHarness.RocketConfig/chipyard.harness.TestHarness.RocketConfig/VTestDriver.h"
...
```

sim_files.common.f，即Makefile中的$(sim_common_files)，包含生成的verilog 

大量sim_files.common.f的verilog文件来自在sims/verilator/generated-src/chipyard.harness.TestHarness.RocketConfig/chipyard.harness.TestHarness.RocketConfig.all.f, 即$(ALL_MODS_FILELIST)

处理make2graph生成的dot文件
for node in $(sed -n 's/\(\w*\) \-> n18.*/\1/p' sims_verilator_make.dot); do grep $node sims_verilator_make.dot | wc -l; grep "$node\[" sims_verilator_make.dot; done

## Chipyard on NixOS二次尝试（不用Conda）

```bash
./build-setup.sh riscv-tools -s 1 -s 6 -s 7 -s 8 -s 9 -s 10
```

## Chipyard on NixOS三次尝试（手动装submodule）

TLDR：submodule还是太多了，用脚本合适

```bash
git submodule update --init generators/cva6/
git submodule update --init generators/ibex/
git submodule update --init generators/nvdla/
git submodule update --init generators/rocket-chip/
# edit common.mk:1 SHELL=bash
git submodule update --init sims/firesim/
git submodule update --init tools/cde/

# git submodule update --init generators/hardfloat/

git -C generators/rocket-chip/ submodule update --init hardfloat/

# why need boom?
git submodule update --init generators/boom/

git submodule update --init generators/sifive-cache/
```

## Chipyard on NixOS四次尝试（成功！）

```bash
# edit common.mk:1 SHELL=bash

git checkout 1.10.0
./scripts/init-submodules-no-riscv-tools-nolog.sh

cd sims/verilator
make

./simulator-chipyard-RocketConfig $RISCV/riscv64-unknown-elf/share/riscv-tests/isa/rv64ui-p-simple
```
