<div style="text-align:right; font-size:3em;">2023.07.24</div>

想找一个能够利用多台电脑帮我跑elfies的框架。

保底方法make + ssh。就是每次都有手动手机数据的工作量。

* hcj：htcondor。尝试编译，各种库找不到uuid等，boost还只能用1.66，nixpkgs都没有这么老的。
* Bing: htcondor alternative
  * https://en.wikipedia.org/wiki/Comparison_of_cluster_software
    * 在nixpkgs里挨着试了试这些包，slurm和torque有支持。
      初步看slurm有1.9k星，比htcondor的251多多了。
      torque只有229星。

## slurm

每个节点都得用相同的用户名（slurmUser）？
对非root用户不友好。

依赖munge，似乎是用来节点之间授权的，似乎需要sudo才行？

```bash
mkdir -p /tmp/munge
mkdir -p ~/.local/xieby1
munged --socket=/tmp/munge/socket --key-file=/home/xieby1/.local/munge/key --log-file=/home/xieby1/.local/munge/log --pid-file=/home/xieby1/.local/munge/pid --seed-file=/home/xieby1/.local/munge/seed
```

太复杂啦！！！

## torque

虽然看来起很老旧，但文档比slurm清晰得多！

torque也许要sudo才行。

## parallel

搜索过程

* bing: make makefile execute distributed
  * [Parallel (GNU make)](https://www.gnu.org/software/make/manual/html_node/Parallel.html)
    * 联想到了gnu parallel
