<div style="text-align:right; font-size:3em;">2022.04.17</div>

nix的pandoc没有独立的data-dir，
`nixpkgs/pkgs/development/tools/pandoc/default.nix`，
可见编译开启了-fembed_data_files选项。
