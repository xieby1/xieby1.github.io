<div style="text-align:right; font-size:3em;">2020.08.04</div>

`man address_families`推荐了两个文档学习蓝牙编程：

1. Bluetooth  Management  API  overview  ⟨https://git.kernel.org/pub/scm/bluetooth/bluez.git/tree/doc/mgmt-api.txt⟩
2. An  Introduction to Bluetooth Programming by Albert Huang⟨https://people.csail.mit.edu/albert/bluez-intro/⟩ for details.

其中第一个是bluez项目里的文档，第二个就是[](Essays/2005.bluez_intro.albert/An Introduction to Bluetooth Programming.md)。

<div style="text-align:right; font-size:3em;">2020.08.11</div>

[BlueZ 5 API introduction and porting guide](http://www.bluez.org/bluez-5-api-introduction-and-porting-guide/)，提及了删掉了org.blue.Service，这大概就是指`/var/run/sdp`，

> The removal of the org.bluez.Service interface (used for registering SDP records and authorization) and the introduction of a new org.bluez.Profile1 interface

<div style="text-align:right; font-size:3em;">2020.08.14</div>

看上面Bluez 5 API...提到的`test/test-profile`，其中`@...`的语法参考[PEP 318: Decorators#Current Syntax](https://www.python.org/dev/peps/pep-0318/#current-syntax)，粘贴如下，

```python
@dec2
@dec1
def func(arg1, arg2, ...):
    pass
# Equivalent
def func(arg1, arg2, ...):
    pass
func = dec2(dec1(func))
```

```python
@decomaker(argA, argB, ...)
def func(arg1, arg2, ...):
    pass
# Equivalent
func = decomaker(argA, argB, ...)(func)
```

<div style="text-align:right; font-size:3em;">2020.08.16</div>

[Bluez Programming](https://stackoverflow.com/questions/29767053/bluez-programming)给了我很多提示。比如gdbus和d-feet。

<div style="text-align:right; font-size:3em;">2020.08.17</div>

bluez自带的bluetooth-player很有启发性，去研究研究吧。

<div style="text-align:right; font-size:3em;">2020.10.01</div>

参考bluetooth-player后，

bluez里的gdbus/gdbus.h（D-Bus helper library）是把dbus（gio）的api进行了进一步的包装，

比如`g_dbus_client_set_proxy_handlers`是bluez实现，其调用的（再经由`get_managed_objects`调用）`dbus_message_new_method_call`才是dbus(gio)直接提供api。dbus(gio)直接提供的api可以在**devhelp**工具里查到。

所以要是写蓝牙键盘的话有必要直接用bluez实现的D-Bus helper library，而整个bluez使用autotools搞的，有必要详尽地学习一下如何把一个autotools编译框架的项目优雅地纳入自己的项目！