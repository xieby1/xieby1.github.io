#!/usr/bin/env nix-shell

# --pure: start a pure reproducible shell
{ pkgs ? import <nixpkgs> {} }:
let
  name = "nix";
  myPython = pkgs.python3.withPackages (
    p: with p; [
      ipython
    ]
  );
in
pkgs.mkShell {
  inherit name;
  buildInputs = with pkgs; [
    myPython
    hello
  ];
  shellHook = ''
    # install hello permenantly
    # nix-env -q "${pkgs.hello.name}"
    # if [[ ''$? -ne 0 ]]
    # then
    #   nix-env -i ${pkgs.hello}
    # fi

    # env
    export PYTHONPATH=${myPython}/${myPython.sitePackages}
    export debian_chroot=${name}

    ${pkgs.tmux}/bin/tmux
    exit
  '';
}
