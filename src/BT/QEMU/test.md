<div style="text-align:right; font-size:3em;">2022.04.24</div>

`qemu/tests/tcg/i386/test-i386.c`

```bash
nix-shell '<nixpkgs>' -A qemu
nix-shell -p glibc.static
bear --output compile_commands-test.json -- env CFLAGS=-O make -e build-tcg-tests-x86_64-linux-user
```

宏`__init_call`相关

* [gcc: common function attr: section](https://gcc.gnu.org/onlinedocs/gcc-10.1.0/gcc/Common-Function-Attributes.html#Common-Function-Attributes): 将变量放入自定义section
* [How do you get the start and end addresses of a custom ELF section?](https://stackoverflow.com/questions/16552710): `__start_SECTION`

<div style="text-align:right; font-size:3em;">2022.04.25</div>

`qemu/tests/tcg/i386/test-i386.c`
没有覆盖所有编码，比如btc没有立即数版本的
