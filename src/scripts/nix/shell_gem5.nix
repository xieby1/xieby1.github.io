with import <nixpkgs> {};
mkShell {
  packages = [
    scons
    zlib
    m4
    gperftools
    protobuf
    libpng
    hdf5-cpp
  ];
  name = "gem5";
}
