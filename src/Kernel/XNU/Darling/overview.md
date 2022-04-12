<div style="text-align:right; font-size:3em;">2021.01.26</div>

https://docs.darlinghq.org/internals/basics/system-call-emulation.html

没有实现直接系统调用，原因：对用户安装复杂，苹果不提供支持直接系统调用

> Emulating XNU system calls directly in Linux would have a few benefits,
> but isn't really workable. Unlike BSD kernels,
> Linux has no support for foreign system call emulation
> and having such an extensive and intrusive patchset merged into Linux
> would be too difficult.
> Requiring Darling's users to patch their kernels is out of question as well.

> Note that Apple provides no support for making direct system calls
> (which is effectively very similar to distributing statically linked executables
> described in the article) and frequently changes the system call table,
> hence such software is bound to break over time.