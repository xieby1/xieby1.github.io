#!/usr/bin/env nix-shell
# xieby1: 2022.05.16
let
  pkgs_mips_cross = import <nixpkgs> {
    crossSystem = "mips-linux";
  };
  pkgs = import <nixpkgs> {};
in
pkgs.mkShell {
  buildInputs = (with pkgs_mips_cross; [
    buildPackages.gdb
    buildPackages.gcc
  ]) ++ (with pkgs; [
    qemu
  ]);
}
