# Nix/NixOS

[English](./README-en.md)

<!-- vim-markdown-toc GFM -->

* [Nix和NixOS的关系](#nix和nixos的关系)
* [使用场景](#使用场景)
* [引用](#引用)

<!-- vim-markdown-toc -->

## Nix和NixOS的关系

Nix是一个先进的包管理系统，用来管理软件包。
其目标和常见的apt、rpm等包管理器一致。
相对于这些包管理器，Nix采用了纯函数构建模型、使用哈希存储软件包等思想。
这使得Nix能够轻松做到做到可重现构建、解决依赖地狱（dependency hell）。
Nix源自于Dolstra博士期间的研究内容。
其详细理论由他的博士论文[^doc_thesis]支撑。

NixOS则是把整个Linux操作系统看作一系列软件包（包括内核），采用Nix来进行管理。
换句话说，NixOS是一个的使用Nix包管理器的Linux发行版。

你可以单独使用Nix包管理器，用它来管理你的用户程序。
你也可以使用NixOS，让你的整个操作系统都由Nix管理。
Nix/NixOS带来的最直观的优势就是，只要保留着Nix/NixOS的配置文件，
就能恢复出一个一模一样的软件环境/操作系统。
（当然这是理想情况下。
nix 2.8的impure特性，home-manager等在打破这一特性。
不过不用担心。
只要保留配置文件，Nix/NixOS上能够生成一个几乎一模一样的软件环境/操作系统）

至此你可能会产生疑问，Nix/NixOS能够管理系统、软件及其配置，那数据呢？
虽然Nix/NixOS不直接管理数据，但是Nix/NixOS可以很好的管理数据同步软件。
比如使用开源软件Syncthing，或是开源服务NextCloud，或是商业服务Google Drive。
因此只要有Nix/NixOS的配置文件，
那就能轻松的构建出包含你熟悉的软件、配置、数据的软件环境/操作系统啦。

我的Nix/NixOS配置存放在这里
[github.com/xieby1/nix_config](https://github.com/xieby1/nix_config)。

## 使用场景

* 重装系统：复原老系统的环境
* 双系统：让WSL和Linux保持相同的环境
* 虚拟机：让本地环境和虚拟机保持相同的环境
* 容器：让本地环境和容器保持相同的环境
* 多设备：让多台电脑/手机[^nix-on-droid]保持相同的环境

## 引用

[^doc_thesis]: Dolstra, Eelco. “The purely functional software deployment model.” (2006).

[^nix-on-droid]: [github.com/t184256/nix-on-droid](https://github.com/t184256/nix-on-droid) termux的分支，支持nix
