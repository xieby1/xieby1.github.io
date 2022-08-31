<div style="text-align:right; font-size:3em;">2022.08.13</div>

I want delete all padding after the end of every function.

https://stackoverflow.com/questions/4486301/

> The padding is created by the assembler, not by gcc.
> ...
> If you use the -Os optimization level, it's off by default
> ...

After reading `man as`,
I only find -n might be useful,
e.g. `gcc -Xassembler -n -S -o helloworld.S helloworld.c`

After this I realize I can eliminate alignment fill in pre-compiled lib.

Maybe ELF editor is a better choice.
