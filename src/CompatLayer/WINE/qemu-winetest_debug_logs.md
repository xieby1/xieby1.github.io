调试qemu+wine


<div style="text-align:right; font-size:3em;">2021.04.15</div>

# advapi32 service卡死

**参考**：

* [geoff chappell's blog: **ADVAPI32** Intro](https://www.geoffchappell.com/studies/windows/win32/advapi32/index.htm):  ADVAPI32 is **basic** to Windows programming

**运行**：

```shell
./wine dlls/advapi32/tests/advapi32_test.exe.so service
```

service相关记录在QnA.md*如何安装服务*。

`advapi32_test.exe.so service`会依次启动服务

* `advapi32_test.exe service exit` // **disabled** service /// 目前还没enable这个service
* `no_such_file.exe` // bad path
* 卡在了这里！`advapi32_test.exe service exit` // exits right away
* `advapi32_test.exe service serve` // real service

wine提示

```shell
err:service:process_send_start_message service L"winetest_start_stop" failed to start
```

看源码是因为SERVICE_REQUEST_TIMEOUT，上一次IO未完成。

<div style="text-align:right; font-size:3em;">2021.04.20</div>

trace信息获取

```shell
WINEDEBUG=+service ~/Codes/wine/wine ~/winetest/advapi32_test.exe service
```

* dlls/advapi32/tests/service.c: START_TEST(service)  // func_service
  * SC_HANDLE scm_handle = OpenSCManager(...)
  * SC_HANDLE svc_handle = OpenServiceA(scm_handle, servicename, ...)
  * dlls/advapi32/tests/service.c: 2568: test_start_stop( argv[0]svc_handle )
    * try_start_stop(svc_handle, ...)
      * <u>advapi32_test.exe:</u> dlls/advapi32/service.c: 2304: StartServiceA/W( argv[0]hService )

        * （clangd跳转可以看出）通过advapi32.dll的同名函数rpc到<u>services.exe:</u> programs/services/**rpc**.c: svcctl_StartServiceW( argv[0]hService )
          * programs/services/services.c: service_start(argv[0]service)

            * wine5.0.4/programs/services/services.c: service_start_process(...)

              * static process_create(WCHAR *name, process_entry)

                * CreateNamedPipeW(name)

              * CreateProcessW(, path, ...)

                advapi32_test.exe service exit开始运行

            * 进程号发生变化？详细见下<u>services.exe和services.exe+:</u> process_send_start_message ( argv[2]name = service->name)
      * <u>advapi32_test.exe: advapi32.dll:</u> pQueryServiceStatusEx(svc_handle, ...)

        * <u>advapi32_test.exe: advapi32.dll:</u> svcctl_QueryServiceStatusEx，进程间调用

          * NdrSendReceive(stubmsg, buffer)

            * I_RpcSendReceive(pMsg = stubmsg->RpcMsg)

              * I_RpcReceive(pMsg)

                从services.exe接受消息

                * RPCRT4_Receive
                  * RPCRT4_default_receive_fragment
                    * rpcrt4_conn_read
                      * 通过搜索函数签名搜到了（简单的正则表达式就可以）rpcrt4_conn_np_read
                        * 卡在WaitForSingleObject
      * 2319: StartServiceA还未运行（看trace）

建立connection的过程

从I_RpcNegotiateTransferSyntax开始WINEDEBUG=+rpc可见

## **services.exe出错时线程号变化**:

直接在X64上运行WINE这段的线程号是不变的！

```shell
$ QEMU_STRACE=1 WINEDEBUG=+service,+pid ./wine dlls/advapi32/tests/advapi32_test.exe service

# 进程号/线程号不变。
000e:0016:trace:ntdll:NtCancelIoFile before wine_server_call
...
# 解开signal mask后尽管有许多pthread_sigmask调用对，但都是配对的，且配对的线程号/进程号相同
...
000e:0016:trace:ntdll:NtCancelIoFile after wine_server_call
```

<div style="text-align:right; font-size:3em;">2021.04.21</div>

线程号在`wine5.0.4/programs/services/services.c: CancelIo`发生变化。

ConnectNamedPipe的overlap是异步的意思，可对pipe进行异步操作。参考[CreateNamedPipeA function (winbase.h)](https://docs.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-createnamedpipea)，对FILE_FLAG_OVERLAPPED的描述，和[OVERLAPPED structure (minwinbase.h)](https://docs.microsoft.com/en-us/windows/win32/api/minwinbase/ns-minwinbase-overlapped)。

```shell
$ WINEDEBUG=+service,+server,+pid ./wine dlls/advapi32/tests/advapi32_test.exe service
000e:002a:trace:service:process_send_start_message before CancelIo pid 14
002a: cancel_async( handle=0148, iosb=00000000, only_thread=1 )
002a: *sent signal* signal=10
002a: cancel_async() = 0
0041: set_suspend_context( context={cpu=x86,eip=07819102,esp=0506f8ec,ebp=0506fa38,eflags=00000246,cs=0023,ss=002b,ds=002b,es=002b,fs=0033,gs=003b,eax=00000000,ebx=00000002,ecx=0506f9a0,edx=00000000,esi=00000008,edi=0506faa0,dr0=00000000,dr1=00000000,dr2=00000000,dr3=00000000,dr6=00000000,dr7=00000000,fp.ctrl=0000027f,fp.status=00000000,fp.tag=0000ffff,fp.err_off=00000000,fp.err_sel=00000000,fp.data_off=00000000,fp.data_sel=00000000,fp.cr0npx=ffff0000,fp.reg0=0,fp.reg1=0,fp.reg2=0,fp.reg3=0,fp.reg4=0,fp.reg5=0,fp.reg6=0,fp.reg7=0} )
0041: set_suspend_context() = 0
0041: select( flags=2, cookie=7ffbb1a0, timeout=0, prev_apc=0000, result={}, data={} )
0041: select() = TIMEOUT { timeout=1d7365e396438f8 (+0.0000000), call={APC_NONE}, apc_handle=0000 }
0041: get_suspend_context( )
0041: get_suspend_context() = 0 { context={} }
000e:0041:trace:service:process_send_start_message after CancelIo pid 14
```

<div style="text-align:right; font-size:3em;">2021.04.22</div>

`set_suspend_context`是啥，谁调用的？

<div style="text-align:right; font-size:3em;">2021.05.17</div>

QEMU：cpu_dump_state (x86_cpu_dump_state)提供CPU状态信息。

在QEMU里创建线程的地方（linux_user/syscall.c: do_fork: clone_func）添加了语句，进程号变化的地方没有创建新线程，

```shell
$ WINEDEBUG=+ntdll,+server,+pid ./wine dlls/advapi32/tests/advapi32_test.exe.so service

000e:0016:trace:ntdll:NtCancelIoFile before wine_server_call
000e:0016:trace:server:server_call_unlocked before send_request
000e:0016:trace:server:server_call_unlocked after send_request, before wait_reply
0016: cancel_async( handle=013c, iosb=00000000, only_thread=1 )
0016: *sent signal* signal=10
0016: cancel_async() = 0
000e:0016:trace:server:server_call_unlocked after wait_reply
000e:0016:trace:server:wine_server_call before pthread_sigmask
000e:003f:trace:server:server_call_unlocked before send_request
000e:003f:trace:server:server_call_unlocked after send_request, before wait_reply
003f: set_suspend_context( context={cpu=x86,eip=07819102,esp=062ef8ec,ebp=062efa38,eflags=00000246,cs=0023,ss=002b,ds=002b,es=002b,fs=0033,gs=003b,eax=00000000,ebx=00000002,ecx=062ef9a0,edx=00000000,esi=00000008,edi=062efaa0,dr0=00000000,dr1=00000000,dr2=00000000,dr3=00000000,dr6=00000000,dr7=00000000,fp.ctrl=0000027f,fp.status=00000000,fp.tag=0000ffff,fp.err_off=00000000,fp.err_sel=00000000,fp.data_off=00000000,fp.data_sel=00000000,fp.cr0npx=ffff0000,fp.reg0=0,fp.reg1=0,fp.reg2=0,fp.reg3=0,fp.reg4=0,fp.reg5=0,fp.reg6=0,fp.reg7=0} )
003f: set_suspend_context() = 0
000e:003f:trace:server:server_call_unlocked after wait_reply
000e:003f:trace:server:wine_server_call before pthread_sigmask
000e:003f:trace:server:wine_server_call after pthread_sigmask
000e:003f:trace:server:server_call_unlocked before send_request
000e:003f:trace:server:server_call_unlocked after send_request, before wait_reply
003f: select( flags=2, cookie=7ffcf1a0, timeout=0, prev_apc=0000, result={}, data={} )
003f: select() = TIMEOUT { timeout=1d74afa431a1c0e (+0.0000000), call={APC_NONE}, apc_handle=0000 }
000e:003f:trace:server:server_call_unlocked after wait_reply
000e:003f:trace:server:wine_server_call before pthread_sigmask
000e:003f:trace:server:wine_server_call after pthread_sigmask
000e:003f:trace:server:server_call_unlocked before send_request
000e:003f:trace:server:server_call_unlocked after send_request, before wait_reply
003f: get_suspend_context( )
003f: get_suspend_context() = 0 { context={} }
000e:003f:trace:server:server_call_unlocked after wait_reply
000e:003f:trace:server:wine_server_call before pthread_sigmask
000e:003f:trace:server:wine_server_call after pthread_sigmask
000e:003f:trace:server:wine_server_call after pthread_sigmask
000e:003f:trace:ntdll:NtCancelIoFile after wine_server_call
```

在

* NtCancelIoFile
  * wine_server_call
    * pthread_sigmask：恢复信号mask的语句出的问题，即第二个pthread_sigmask函数。前后线程号不同，但QEMU的do_fork语句里的printf没有提示我有新线程产生。

<div style="text-align:right; font-size:3em;">2021.04.22</div>

## 跨进程通讯卡死

追到rpcrt4_conn_np_read的NtReadFile也是正常执行的

```
0008:0009:trace:rpc:RPCRT4_default_receive_fragment (7FD55CB8, 7F56F6DC, 7F56F68C)
0008:0009:trace:rpc:rpcrt4_conn_np_read before NtReadFile
000e:003e:trace:rpc:RPCRT4_default_receive_fragment (7FA7A518, 0272FF28, 0272FED0)
0008:0009:trace:rpc:rpcrt4_conn_np_read after NtReadFile
```

<div style="text-align:right; font-size:3em;">2021.05.10</div>

dlls/rpcrt4/rpc_transport.c: rpcrt4_conn_np_read卡在WaitForSingleObject函数。

[ncacn_np attribute](https://docs.microsoft.com/en-us/windows/win32/midl/ncacn-np)，np是named pipe的缩写。命名方式，

> Specifies a character string that represents a valid combination of an RPC protocol (such as "ncacn"), a transport protocol (such as "tcp"), and a network protocol (such as "ip"). For a list of valid protocol sequences, see [Protocol Sequence Constants](https://docs.microsoft.com/en-us/windows/desktop/Rpc/protocol-sequence-constants).

ncacn是rpc协议，np是指使用named pipes。

<div style="text-align:right; font-size:3em;">2021.05.11</div>

https://wiki.winehq.org/Wine_Developer%27s_Guide/Kernel_module，有讲CurrentTeb()需要和LDT修改和%fs寄存器配合！

Q: include/winnt.h:`__asm__(".byte 0x64\n\tmovl (0x18),%0" : "=r" (teb));`为什么编译后能够出现`fs:0x18`？查看编译出的objdump到有`fs:`前缀。

Q: Teb是fs的0x18偏移，是哪里确定的？

* thread_init(void)
  * signal_alloc_thread( &teb )
    * wine_ldt_alloc_fs( void )
      * 若GDT能找到则wine_get_fs( void )，否则在LDT内申请新的
  * signal_init_thread( teb )
    * wine_ldt_init_fs( thread_data->fs, &fs_entry)

<div style="text-align:right; font-size:3em;">2021.05.18</div>

### 解决

毛前辈的fs问题简单修复patch打入QEMU v6.0.0，之前用的是v5.2.0

| x64 wine | x64 qemu-i386 wine         | x64 qemu-i386(patched) wine                                  |
| -------- | -------------------------- | ------------------------------------------------------------ |
| 正常     | 问题一致。线程号变化、卡死 | 能执行完advapi32_test.exe.so service，但报错“err:seh:setup_exception_record stack overflow...”，详细如下 |



```shell
$ ./wine dlls/advapi32/tests/advapi32_test.exe.so service

0020:err:seh:setup_exception_record stack overflow 1184 bytes in thread 0020 eip 0748e288 esp 7fb40e90 stack 0x7fb40000-0x7fb41000-0x7fd40000
000f:err:service:process_send_command service protocol error - failed to read pipe r = 0  count = 0!
000f:fixme:service:scmdatabase_autostart_services Auto-start service L"winebus" failed to start: 1053
# 接下来的输出信息和x86 wine类似
# ...
# x64应该是648个测试
0008:service: 643 tests executed (19 marked as to.do, 0 failures), 1 skipped.
```

<div style="text-align:right; font-size:3em;">2021.05.25</div>

* dlls/ntdll/signal_i386.c: signal_init_process将信号处理函数设置为segv_handler
* ...
* segv_handler的第二个setup_exception_record
  * setup_exception_record
