#!/usr/bin/env nix-shell
with import <nixpkgs> {};
# You will get a shell with hello executable,
# and environment variable $name, $miao.
mkShell {
  packages = [
    hello
  ];
  name = "test-env";
  miao = "miao!";
}
