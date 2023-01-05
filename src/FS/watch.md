<div style="text-align:right; font-size:3em;">2022.12.10</div>

本地文件备份

* vscode
  * local history
    * 局限：只能vscode
* [incron](https://github.com/ar-/incron/tree/master)
  * 局限：daemon需要root权限。2017年已未更新。
* [systemd.path](http://www.freedesktop.org/software/systemd/man/systemd.path.html)
  * 信息来源：https://www.reddit.com/r/linux/comments/2l1wtl/incron_abandoned/
  * 相关信息：arch使用systemd.path配置rsync，https://wiki.archlinux.org/index.php/rsync#Automated_backup_with_systemd_and_inotify
  * 局限：不能recursively监视子文件夹。
* [versioning filesystem](https://en.wikipedia.org/wiki/Versioning_file_system)
  * NILFS(nilfs-tools)
    * 局限：不能设置忽略，只能对整个文件系统（文件夹）进行备份
* inotify-tools
  * 局限：触发事件时，文件已经被修改了
