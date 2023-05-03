let
  pkgs = import <nixpkgs> {};
in
pkgs.mkShell {
  propagatedBuildInputs = with pkgs.python3Packages; [
    pip
    venvShellHook
    ipython
  ];
  venvDir = "${builtins.getEnv "HOME"}/venv";
}
