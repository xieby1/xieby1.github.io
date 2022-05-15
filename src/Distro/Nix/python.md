<div style="text-align:right; font-size:3em;">2022.05.15</div>

# Python in Nix/NixOS

According to [What is the correct way to setup pip with nix to install any python package in an isolated nix environment](https://www.reddit.com/r/NixOS/comments/q71v0e/what_is_the_correct_way_to_setup_pip_with_nix_to/),
I found two useful tools to install python packages in Nix/NixOS

* [TODO] poetry
* mach-nix

## mach-nix

mach-nix github repo:
[github.com/DavHau/mach-nix](https://github.com/DavHau/mach-nix)

Here is `shell_python_mach.nix`,
an example which create a shell with a python package called expmcc.

Run it by `nix-shell shell_python_mach.nix`.

```nix
{{#include ../../scripts/nix/shell_python_mach.nix}}
```
