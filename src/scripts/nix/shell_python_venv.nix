#2022.05.18
# pip install is usable in venv
# e.g.
# $ nix-shell <this_file>
# $ pip install graphviz2drawio
let
  pkgs = import <nixpkgs> {};
in
pkgs.mkShell {
  propagatedBuildInputs = with pkgs.python3Packages; [
    pip
    pygraphviz
    venvShellHook
  ] ++ (with pkgs; [
    graphviz
  ]);
  venvDir = "venv";
}
