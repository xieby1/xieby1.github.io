<div style="text-align:right; font-size:3em;">2022.05.28</div>

node2nix脚本

npm install是在installPhase执行的，
见`prepareAndInvokeNPM`变量。

因此buildPhase时npm相关的源码均未准备好。
