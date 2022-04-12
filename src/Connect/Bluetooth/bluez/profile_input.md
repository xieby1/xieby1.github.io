<div style="text-align:right; font-size:3em;">2020.10.21</div>

# 总体架构

这部分内容根据源码推测。

profiles/input/device.c和.h是bluetoothd的一部分，从编译出的.o文件的名称前缀都有bluetoothd进行的合理猜测。bluetoothd是有超级权限的应用程序，其功能通过bluetoothctl直接暴露给用户使用。bluetoothd有监控各类蓝牙设备的能力，远程输入设备就是其中之一。profiles/input/device.c就是来处理远程输入设备的，当连上时会有简单的信息记录，即下面[设置GIOChannel](#设置GIOChannel)章节中的所挂载的ctrl信号和intr信号后的处理函数。

![profile_device_arch](pictures/profile_device_arch.svg)

这一系列文件应该是对远程输入设备的建模。所以我想做的事情，就是模拟一个远程输入设备的模型让其他设备读取，是和这个相对的事。

## 注册远程输入设备

在本地注册远程输入设备

（其实就是读取远程输入设备的信息）

* profiles/input/device.h: input_device_register(struct btd_service *service)
  * btd_service是通用的数据结构，对于该函数有输入数据，有输出数据，
    * int ref
    * struct btd_device输入
    * struct btd_profile *profile输入
    * void *user_data用来存放profile相关的数据，输出新创建的设备，对应远程输入设备。

## 设置和获取sdp

* src/device.c: 6694: sdp_record_t *btd_device_get_record(struct btd_device *device, const char *uuid)
* src/device/c:6661: void btd_device_set_record(struct btd_device *device, const char *uuid, const char *record)

## 设置GIOChannel

猜测是把远程输入设备的通讯映射到GIOChannel上

* profiles/input/device.h: int input_device_set_channel(const bdaddr_t *src, const bdaddr_t *dst, int psm, GIOChannel *io);
  * 参数
    * 猜测bdaddr_t *src是本地蓝牙地址（可能有多个，所以需要设置）
    * 猜测bdaddr_t *dst是远程输入设备的蓝牙地址
    * psm是端口号，用于判断是是L2CAP_PSM_HIDP_CTRL还是L2CAP_PSM_HIDP_INTR。
  * 收到ctrl信号和intr信号后的处理函数在这个函数里挂载上，分别是ctrl_watch_cb和intr_watch_cb。

## 连接远程输入设备

连接刚刚注册的远程输入设备

* profiles/input/device.h: int input_device_connect(struct btd_service *service)