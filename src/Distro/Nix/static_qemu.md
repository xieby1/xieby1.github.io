<div style="text-align:right; font-size:3em;">2022.05.29</div>

# 静态链接，以qemu为例

太长不看

* 实现了qemu静态链接，无任何动态链接库的依赖。
  采用了两个版本的qemu，当前版本Nix的qemu（nix 21.11, qemu 6.1.1）
  和qemu3.1.0这两个版本。
* nix脚本：https://github.com/xieby1/xieby1.github.io/blob/main/src/scripts/nix/pkgs_qemu_static.nix

## pkgsStatic及其源代码

Nixpkgs含有pkgsStatic软件包，但是大多软件无法直接使用。
需要进行手动修复。

pkgsStatic加载过程的源码

* pkgs/top-level/stage.nix
  将crossSystem设置为static且abi为musl。
  之所以用Musl是因为，

  > Currently uses Musl on Linux (couldn’t get static glibc to work).

  其代码大致的如下，
  ```nix
  pkgsStatic = nixpkgsFun {
    crossSystem = {
      isStatic = true;
      parsed = stdenv.hostPlatform.parsed // {
        abi = musl;
  };};};
  ```
  * nixpkgsFun = newArgs: import pkgs/top-level/default.nix (...)
    * pkgs/top-level/default.nix: stdenvStages {..., crossSystem, ...}
      * pkgs/stdenv/default.nix: stagesCross
        * pkgs/stdenv/cross/default.nix: stdenvAdapters.makeStatic
          * pkgs/stdenv/adapters.nix: makeStatic
            * makeStaticLibraries
              * 添加configureFlags "--enable-static" "--disable-shared"
              * 添加cmakeFlags "-DBUILD_SHARED_LIBS:BOOL=OFF"
              * 添加mesonFlags "-Ddefault_library=static"
            * makeStaticBinaries
              * 添加NIX_CFLAGS_LINK "-static"
              * 添加configureFlags "--disable-shared"

TODO: 读懂makeStaticLibraries和makeStaticBinaries。

## 基本思路

使用pkgsStatic.qemu，挨个修复编译报错即可。

## 调试手段

### 还原构建环境

```bash
# 保留构建失败的现场
nix-build pkgs_qemu_static.nix -K
```

进入现场包含env-vars文件和失败时的源码文件夹。
恢复环境，

```bash
. ./env-vars
. $stdenv/setup
```

### 查看依赖树

```bash
nix-store --query --tree <xxx.drv>
```
