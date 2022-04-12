<div style="text-align:right; font-size:3em;">2020.7.12</div>

按照[hidclient](https://github.com/benizi/hidclient)里的README.md，我成功的连上了手机！！！键盘一切正常，但是鼠标不能用！那就开始阅读它的源码吧！

<div style="text-align:right; font-size:3em;">2020.08.10</div>

之所以要在bluetoothd启动时添加`-compat`参数，是因为`sdp_connect`需要pipe访问`/var/run/sdp`这文件，然而这个文件在bluetoothd兼容模式下才有。参考：[BlueCove with Bluez chucks “Can not open SDP session. No such file or directory”](https://stackoverflow.com/questions/30946821/bluecove-with-bluez-chucks-can-not-open-sdp-session-2-no-such-file-or-direct)