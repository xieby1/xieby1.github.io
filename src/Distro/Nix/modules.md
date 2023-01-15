<div style="text-align:right; font-size:3em;">2023.01.15</div>

nixpkgs/lib/modules.nix:
从`loadModule`可以看出，imports可以接受Function、Attr、路径，不能够嵌套List。
