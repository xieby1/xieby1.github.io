let
  pkgs = import <nixpkgs> {};
in pkgs.mkShellNoCC {
  name = "gcc11";
  packages = with pkgs; [
    gcc11
  ];
}
