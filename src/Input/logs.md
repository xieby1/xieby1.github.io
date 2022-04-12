<div style="font-size:3em; text-align:right;">2020.5.4</div>

用btkbdd获取linux的键盘输入总会提示ioctl grab失败。在[Linux and bash - How can I get the device name of an input device event?](https://stackoverflow.com/questions/33517928/linux-and-bash-how-can-i-get-the-device-name-of-an-input-device-event)里看到了用evtest来测试输入设备的。这样就可以通过看evtest的源码来搞懂怎么捕获linux系统里的键盘和鼠标输入了。