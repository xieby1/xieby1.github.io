<div style="text-align:right; font-size:3em;">2022.04.27</div>

# AWK

> AWK was created at Bell Labs in the 1970s, and its name is derived from the surnames of its authors: Alfred Aho, Peter Weinberger, and Brian Kernighan. The acronym is pronounced the same as the bird auk, which is on the cover of The AWK Programming Language.
>
> -- wikipedia --

Reference:

* https://www.gnu.org/software/gawk/manual/gawk.html
* `man awk`

## Language

Data driven programming language (compared with procdedural programming language)

An awk program

* @include "filename"
* @load "filename"
* @namespace "name"
* pattern { action statements }
* function name(parameter list) { statements }

pattern

* BEGIN
* END
* BEGINFILE
* ENDFILE
* /regular expression/
* relational expression
* pattern && pattern
* pattern || pattern
* pattern ? pattern : pattern
* (pattern)
* ! pattern
* pattern1, pattern2

action: { statements }

* expressions
  * operators
    * $ Field reference
    * ...
* control statements
* compound statments
* IO statments
  * next
  * print
  * ...
* deletion statements

function
