# xieby1: 2022.11.18

{ pkgs ? import <nixpkgs> {}
, targetPkgs ? pkgs.pkgsStatic
# , targetPkgs ? pkgs.pkgsCross.aarch64-multiplatform
}:
# let
#   targetPrefix = pkgs.lib.optionalString (pkgs.targetPlatform != hostPlatform)
#     (pkgs.targetPlatform.config + "-");
# in
(targetPkgs.proot.override {
  enablePython = false;
}).overrideAttrs (old: {
  preBuild = ''
    substituteInPlace src/GNUmakefile \
      --replace pkg-config ${targetPkgs.stdenv.cc.targetPrefix}pkg-config
  '';
})
