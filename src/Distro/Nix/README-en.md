# Nix/NixOS

<!-- vim-markdown-toc GFM -->

* [Relationship between Nix and NixOS](#relationship-between-nix-and-nixos)
* [Usage Scenarios](#usage-scenarios)
* [References](#references)

<!-- vim-markdown-toc -->

## Relationship between Nix and NixOS

Nix is an advanced package management system for managing software packages.
Its target is the same as that of common package managers such as apt and rpm.
Comparing with these package managers, Nix adopts a pure function construction model, uses hashes to store packages and adopts other ideas.
These ideas make it easy for Nix to do reproducible builds and resolve dependency hell.
Nix is born from research conducted during Dolstra's PhD,
which is detailed in his doctor dissertation[^doc_thesis],

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

At this point you may be wondering, Nix/NixOS can manage systems, software and their configuration, but what about data?
Although Nix/NixOS does not directly manage data, Nix/NixOS can manage data synchronization software well.
For example, using the open source software Syncthing, or the open source service NextCloud, or the commercial service Google Drive.
Therefore, as long as you keep the configuration files of Nix/NixOS,
you can easily build a software env/OS that contains the software, configuration, and data you are familiar with.

My Nix/NixOS configuration are hosted here
[github.com/xieby1/nix_config](https://github.com/xieby1/nix_config).

## Usage Scenarios

* OS re-installation: recover the env of old OS
* Dual boot OS: keep WSL and Linux have same env
* Virtual machine: keep local env and VM have same env
* Container: keep local env and container have same env
* Multiple devices: keep multiple computers/phones[^nix-on-droid] have same env

## References

[^doc_thesis]: Dolstra, Eelco. “The purely functional software deployment model.” (2006).

[^nix-on-droid]: [github.com/t184256/nix-on-droid](https://github.com/t184256/nix-on-droid) a termux fork, supporting nix
