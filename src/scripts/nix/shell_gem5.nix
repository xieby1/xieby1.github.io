# xieby1 2022.06.10
# place this file in gem5 src dir root
let
  pkgs = import <nixpkgs> {};
in
pkgs.mkShell {
  name = "gem5-dev";
  packages = with pkgs; [
    # for compilation
    scons
    zlib
    m4
    gperftools
    protobuf
    libpng
    hdf5-cpp

    # for execution
    python3Packages.pydot

    # for commit
    python3Packages.pyyaml
  ];

  _VIMRC = builtins.toString ./shell_gem5/vimrc;
  _CCLS = builtins.toString ./shell_gem5/ccls;
  _PYRIGHT = builtins.toString ./shell_gem5/pyrightconfig.json;
  _PSEDOIMPORT = builtins.toString ./shell_gem5/psedoImport.py;
  shellHook = ''
    # add nvim local config
    if [[ ! -f ./.vimrc ]]
    then
      echo "set .vimrc"
      ln -fs ''${_VIMRC} ./.vimrc
    fi

    # add ccls config
    if [[ ! -f ./.ccls ]]
    then
      echo "set .ccls"
      ln -fs ''${_CCLS} ./.ccls
    fi

    # add pyright config
    if [[ ! -f ./pyrightconfig.json ]]
    then
      echo "set pyrightconfig.json"
      ln -fs ''${_PYRIGHT} ./
    fi

    # add psedoImport
    if [[ ! -f ./psedoImport.py ]]
    then
      echo "set psedoImport"
      ln -fs ''${_PSEDOIMPORT} ./
    fi

    # set python path for gem5
    echo "set PYTHONPATH"
    PYTHONPATH+=":''$(realpath src/python)"
    PYTHONPATH+=":''$(realpath site_scons)"
    export PYTHONPATH

    # for FS binaries
    echo "set IMG_ROOT"
    export IMG_ROOT=/home/xiebenyi/Img/aarch-system-20210904
  '';
}
