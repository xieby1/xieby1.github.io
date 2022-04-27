# xieby1: 2022.04.26

let
  pkgs_arm_cross = import <nixpkgs> {
    # get this config on my android
    #   nix repl
    #   builtins.currentSystem
    crossSystem.system = "aarch64-linux";
  };
  pkgs_arm_native = import <nixpkgs> {
    localSystem.system = "aarch64-linux";
    crossSystem.system = "aarch64-linux";
  };
  pkgs = import <nixpkgs> {};
in
pkgs.mkShell {
  buildInputs = with pkgs_arm_cross; [
    # packages for cross compiling, run on local system (x86_64)
    stdenv.cc
  ] ++ (with pkgs_arm_native; [
    # packages run on aarch64
    figlet
  ]) ++ (with pkgs; [
    # packages run on local system (x86_64)
    qemu
  ]);
}
