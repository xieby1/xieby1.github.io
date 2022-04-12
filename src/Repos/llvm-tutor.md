<div style="text-align:right; font-size:3em;">2022.03.17</div>

## 编译环境

通过repl得到llvm_13.dev的路径

```nix
pkgs.llvm_13.dev.outPath
```

```bash
nix-shell -p llvm_13 -p cmake
cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DLT_LLVM_INSTALL_DIR=<llvm_13.dev的路径> .
```
