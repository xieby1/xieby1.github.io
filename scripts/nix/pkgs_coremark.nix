#!/usr/bin/env nix-build
let
  pkgs = import <nixpkgs> {};
in
pkgs.pkgsStatic.stdenv.mkDerivation {
  name = "coremark";
  src = pkgs.fetchFromGitHub {
    owner = "eembc";
    repo = "coremark";
    rev = "d26d6fdcefa1f9107ddde70024b73325bfe50ed2";
    sha256 = "0kd6bnrnd3f325ypxzn0w5ii4fmc98h16sbvvjikvzhm78y60wz3";
  };
  preBuild = ''
    export CFLAGS="-DHAS_FLOAT=0"
  '';
  buildFlags = [
    "compile"
  ];
  installPhase = ''
    mkdir -p $out/bin
    find . -maxdepth 1 -type f -executable -print0 | xargs -0 -I {} mv {} $out/bin/
  '';
}
