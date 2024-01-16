let
  pkgs = import <nixpkgs> {};
in pkgs.mkShell {
  packages = with pkgs; [
    mdbook

    python3
    python3Packages.pandas
    python3Packages.openpyxl
    python3Packages.plotly
    python3Packages.packaging
  ];
}
