with import <nixpkgs> {};
mkShell {
  packages = [
    dtc
    pkgsCross.riscv64-embedded.stdenv.cc
  ];
  name = "spike";
}
