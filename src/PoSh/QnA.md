2021.07.12

## [Setting Windows PowerShell environment variables](https://stackoverflow.com/questions/714877/setting-windows-powershell-environment-variables)

* `$profile` is an automatic variable that points at your user profile for all PowerShell hosts. – [JasonMArcher](https://stackoverflow.com/users/64046/jasonmarcher) [Apr 3 '09 at 22:31](https://stackoverflow.com/questions/714877/setting-windows-powershell-environment-variables#comment528053_714918)

## [CMake on Windows](https://stackoverflow.com/questions/35869564/cmake-on-windows)

总是找不到CMAKE_C(XX)_COMPILER，手动-D也不行，添加环境变量可以正常执行cl.exe也不行。

解决办法找到了，安装Windows 10 SDK就好了。。。。。参考[CMake error at CMakeLists.txt:30 (project): No CMAKE_C_COMPILER could be found](https://stackoverflow.com/questions/32801638/cmake-error-at-cmakelists-txt30-project-no-cmake-c-compiler-could-be-found)Wim Vanhenden + Peter Mortensen的回答。

## Vundle

Windows里的vim使用的文件夹是`~/vimfiles`而不是`~/.vim`。似乎就算是改了vimrc的rtm为前者，也会跑到后者去安装插件。索性搞个文件夹的符号链接得了。
