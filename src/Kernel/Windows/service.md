<div style="text-align:right; font-size:3em;">2021.04.20</div>

由advapi32.dll提供service功能。参考[StartSeviceA](https://docs.microsoft.com/en-us/windows/win32/api/winsvc/nf-winsvc-startservicea):

* StartService函数和Service Control Manager (SCM)交互。SCM创建service进程。因此StartService涉及进程间操作。
* service control dispatcher启动ServiceMain()后就让StartService返回。
* 使用QueryServiceStatus判断service进程的状态。
* serice control database有锁，仅运行一个StartService，即StartService不能“嵌套”（service初始化阶段不能使用StartService）

服务管理器（Service Manager）位于WinXP->开始->管理工具->服务。

众多服务的注册表位置位于`HKEY_LOCAL_MACHINE\ SYSTEM\ CurrentControlSet\ Services\`。