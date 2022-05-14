# Nix/NixOS

## Relationship between Nix and NixOS

Nix is an advanced package management system for managing software packages.
Its target is the same as that of common package managers such as apt and rpm.
Comparing with these package managers, Nix adopts a pure function construction model, uses hashes to store packages and adopts other ideas.
These ideas make it easy for Nix to do reproducible builds and resolve dependency hell.
Nix is born from research conducted during Dolstra's PhD.
Which is detailed in his doctor dissertation,

> Dolstra, Eelco. “The purely functional software deployment model.” (2006).

NixOS regards the entire Linux operating system (including the kernel) as a collection of software packages and uses Nix to manage it.
In other words, NixOS is a Linux distribution that uses the Nix package manager.

You can use the Nix package manager alone to manage your user programs.
You can also use NixOS to have your entire operating system managed by Nix.
The most intuitive advantage brought by Nix/NixOS is that as long as the Nix/NixOS configuration files are kept,
an identical software environment/OS can be restored.
(Of course this is only ideal.
The impure feature of nix 2.8, home-manager etc. are breaking this.
But don't worry.
As long as the configuration files are kept, an almost identical software environment/OS can be generated on Nix/NixOS)

My Nix/NixOS configuration are hosted here
[github.com/xieby1/nix_config](https://github.com/xieby1/nix_config).
