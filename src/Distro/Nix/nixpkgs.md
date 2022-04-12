<div style="text-align:right; font-size:3em;">2021.11.29</div>

import <nixpgks> {}

...

* pkgs/top-level/default.nix
  * stdenvStages import pkgs/stdenv/default.nix
    * stagesLinux = import pkgs/stdenv/linux/
      * thisStdenv, stdenv = import pkgs/stdenv/generic/default.nix
        * import lib/default.nix
          # this is where customisation.nix come from
  * allPackages import pkgs/top-level/stage.nix
    * allPackages import pkgs/top-level/all-packages.nix
  * boot = import pkgs/stdenv/booter.nix

vim_configurable.override {python = python3}
vimUtils.makeCustomizable (vim.override {python = python3})
vimUtils.makeCustomizable (vim.override {python = python3})

似乎是一个浮现override变量的最小集
f = a:{res = a+1;}
fo = pkgsMiao.makeOverride f
f 2
