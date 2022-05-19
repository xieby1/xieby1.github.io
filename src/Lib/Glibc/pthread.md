<div style="text-align:right; font-size:3em;">2020.08.04</div>

pthread和glibc的关系——pthread是glibc的一部分；详细的关系见[Why glibc and pthread library both defined same APIs?](https://stackoverflow.com/questions/11161462/why-glibc-and-pthread-library-both-defined-same-apis)，其中提到了动态链接库的[**symbol interposition**](http://www.airs.com/blog/archives/307)技术和[**symbol versions**](http://sourceware.org/binutils/docs/ld/VERSION.html)技术很有意思。前者让多个库的同名变量之间有优先级关系，后者让同一个库的中可以存在多个版本的同名变量以提高兼容性。