<div style="text-align:right; font-size:3em;">2020.12.10</div>

参考[mingw-wiki](http://www.mingw.org/wiki/MinGW)，windows上有诸多C编译器，但是都不怎么好，所有有了mingw这个项目，原文引用如下，

> Now that Microsoft gives away Visual Studio for free, the Windows compiler market is in poor shape, and other commercial competitors will likely fade over time. Borland has stopped maintaining their free compiler version. lcc-win32 only supports C. Djgpp only builds executables targeted to DOS 32 bit. OpenWatcom was originally a commercial project. It didn't pay for the companies that acquired it to maintain the compiler further. Luckily, it has been added to the list of Open Source C/C++ compilers thanks to the efforts of Scitech. However, it is not very compatible with GNU compiler standards and can be difficult to use in building Open Source not specifically designed for compiling with Watcom. It also only supports C/C++ and Fortran. Same for the Digital Mars project (although it's C/C++ only) which is now also selling parts of its compiler. That will leave MSVC and MinGW as the only high-quality native compilers for Windows.

提到了cygwin和mingw的联系。