<div style="text-align:right; font-size:3em;">2023.11.21</div>

## 访问/mnt的速度极慢

[GH: filesystem performance is much slower than wsl1 in /mnt](https://github.com/microsoft/WSL/issues/4197)

大概是慢了10倍！

```
WSL2
root@LUCIANO-PC:/home/# dd if=/dev/zero of=/mnt/e/testfile bs=1M count=1000
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB, 1000 MiB) copied, 25.939 s, 40.4 MB/s

WSL1
root@LUCIANO-PC:/home/# dd if=/dev/zero of=/mnt/e/testfile bs=1M count=20000
20000+0 records in
20000+0 records out
20971520000 bytes (21 GB, 20 GiB) copied, 47.4897 s, 442 MB/s
```
