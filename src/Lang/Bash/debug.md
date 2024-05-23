<div style="text-align:right; font-size:3em;">2024.03.04</div>

https://news.ycombinator.com/item?id=39568728

![](https://wizardzines.com/images/uploads/bash-debugging.png)

* `set -x`
* `trap read DEBUG`
* `trap 'read -p "[$BASH_SOURCE:$LINENO] $BASH_COMMAND"' DEBUG`
* `die() { echo $1 >&2; exit 1; }`, `some_command || die "oh no!"`

