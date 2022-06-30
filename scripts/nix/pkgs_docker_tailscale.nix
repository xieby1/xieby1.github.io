#!/usr/bin/env nix-build
let
  pkgs = import <nixpkgs> {};
in
pkgs.dockerTools.buildImage {
  name = "headscale";
  tag = "lateset";
  contents = with pkgs; [
    headscale
  ];
}
