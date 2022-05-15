# Vim in Nix/NixOS

## highlight color code

It would be convenient, if color code can be visualised in editor, especially in web programming.
I found two candidates plugins to achieve this goal,
[vim-css-color](https://github.com/ap/vim-css-color),
[vim-hexokinase](https://github.com/RRethy/vim-hexokinase).

Vim-css-color is not compatible with tree-sitter, due to regex based highlight.
See [Github Issue: Neovim tree sitter support](https://github.com/ap/vim-css-color/issues/164) for details.

Vim-hexokinase is good, but must depends on `termguicolors` is turned on.
`termguicolors` will enable 24-bit RGB color,
while originally vim uses Base16 color.
The result is the color theme you familiar with will be changed.

Here is the visual comparison between vim-css-color and vim-hexokinase.
I copy these text as html from my vim.

| vcc                                                                                | vcc tgc                                                                            | vh tgc                                                                             |
|:----------------------------------------------------------------------------------:|:----------------------------------------------------------------------------------:|:----------------------------------------------------------------------------------:|
| <span style="background-color:#FF0000"><font color="#EEEEEC">#ff0000</font></span> | <span style="background-color:#FF0000"><font color="#FFFFFF">#ff0000</font></span> | <span style="background-color:#FF0000"><font color="#FFFFFF">#ff0000</font></span> |
| <span style="background-color:#FF0000"><font color="#EEEEEC">#ff1111</font></span> | <span style="background-color:#FF1111"><font color="#FFFFFF">#ff1111</font></span> | <span style="background-color:#FF1111"><font color="#FFFFFF">#ff1111</font></span> |
| <span style="background-color:#FF0000"><font color="#EEEEEC">#ff2222</font></span> | <span style="background-color:#FF2222"><font color="#FFFFFF">#ff2222</font></span> | <span style="background-color:#FF2222"><font color="#FFFFFF">#ff2222</font></span> |
| <span style="background-color:#FF0000"><font color="#EEEEEC">#ff3333</font></span> | <span style="background-color:#FF3333"><font color="#FFFFFF">#ff3333</font></span> | <span style="background-color:#FF3333"><font color="#FFFFFF">#ff3333</font></span> |
| <span style="background-color:#FF5F5F"><font color="#2E3436">#ff4444</font></span> | <span style="background-color:#FF4444"><font color="#000000">#ff4444</font></span> | <span style="background-color:#FF4444"><font color="#FFFFFF">#ff4444</font></span> |
| <span style="background-color:#FF5F5F"><font color="#2E3436">#ff5555</font></span> | <span style="background-color:#FF5555"><font color="#000000">#ff5555</font></span> | <span style="background-color:#FF5555"><font color="#FFFFFF">#ff5555</font></span> |
| <span style="background-color:#FF5F5F"><font color="#2E3436">#ff6666</font></span> | <span style="background-color:#FF6666"><font color="#000000">#ff6666</font></span> | <span style="background-color:#FF6666"><font color="#FFFFFF">#ff6666</font></span> |
| <span style="background-color:#FF8787"><font color="#2E3436">#ff7777</font></span> | <span style="background-color:#FF7777"><font color="#000000">#ff7777</font></span> | <span style="background-color:#FF7777"><font color="#FFFFFF">#ff7777</font></span> |
| <span style="background-color:#FF8787"><font color="#2E3436">#ff8888</font></span> | <span style="background-color:#FF8888"><font color="#000000">#ff8888</font></span> | <span style="background-color:#FF8888"><font color="#FFFFFF">#ff8888</font></span> |
| <span style="background-color:#FF8787"><font color="#2E3436">#ff9999</font></span> | <span style="background-color:#FF9999"><font color="#000000">#ff9999</font></span> | <span style="background-color:#FF9999"><font color="#FFFFFF">#ff9999</font></span> |
| <span style="background-color:#FFAFAF"><font color="#2E3436">#ffaaaa</font></span> | <span style="background-color:#FFAAAA"><font color="#000000">#ffaaaa</font></span> | <span style="background-color:#FFAAAA"><font color="#000000">#ffaaaa</font></span> |
| <span style="background-color:#FFAFAF"><font color="#2E3436">#ffbbbb</font></span> | <span style="background-color:#FFBBBB"><font color="#000000">#ffbbbb</font></span> | <span style="background-color:#FFBBBB"><font color="#000000">#ffbbbb</font></span> |
| <span style="background-color:#FFD7D7"><font color="#2E3436">#ffcccc</font></span> | <span style="background-color:#FFCCCC"><font color="#000000">#ffcccc</font></span> | <span style="background-color:#FFCCCC"><font color="#000000">#ffcccc</font></span> |
| <span style="background-color:#FFD7D7"><font color="#2E3436">#ffdddd</font></span> | <span style="background-color:#FFDDDD"><font color="#000000">#ffdddd</font></span> | <span style="background-color:#FFDDDD"><font color="#000000">#ffdddd</font></span> |
| <span style="background-color:#EEEEEE"><font color="#2E3436">#ffeeee</font></span> | <span style="background-color:#FFEEEE"><font color="#000000">#ffeeee</font></span> | <span style="background-color:#FFEEEE"><font color="#000000">#ffeeee</font></span> |
| <span style="background-color:#FFFFFF"><font color="#2E3436">#ffffff</font></span> | <span style="background-color:#FFFFFF"><font color="#000000">#ffffff</font></span> | <span style="background-color:#FFFFFF"><font color="#000000">#ffffff</font></span> |
| <span style="background-color:#000000"><font color="#EEEEEC">#000000</font></span> | <span style="background-color:#000000"><font color="#FFFFFF">#000000</font></span> | <span style="background-color:#000000"><font color="#FFFFFF">#000000</font></span>
| <span style="background-color:#121212"><font color="#EEEEEC">#111111</font></span> | <span style="background-color:#111111"><font color="#FFFFFF">#111111</font></span> | <span style="background-color:#111111"><font color="#FFFFFF">#111111</font></span>
| <span style="background-color:#262626"><font color="#EEEEEC">#222222</font></span> | <span style="background-color:#222222"><font color="#FFFFFF">#222222</font></span> | <span style="background-color:#222222"><font color="#FFFFFF">#222222</font></span>
| <span style="background-color:#303030"><font color="#EEEEEC">#333333</font></span> | <span style="background-color:#333333"><font color="#FFFFFF">#333333</font></span> | <span style="background-color:#333333"><font color="#FFFFFF">#333333</font></span>
| <span style="background-color:#444444"><font color="#EEEEEC">#444444</font></span> | <span style="background-color:#444444"><font color="#FFFFFF">#444444</font></span> | <span style="background-color:#444444"><font color="#FFFFFF">#444444</font></span>
| <span style="background-color:#585858"><font color="#EEEEEC">#555555</font></span> | <span style="background-color:#555555"><font color="#FFFFFF">#555555</font></span> | <span style="background-color:#555555"><font color="#FFFFFF">#555555</font></span>
| <span style="background-color:#626262"><font color="#EEEEEC">#666666</font></span> | <span style="background-color:#666666"><font color="#FFFFFF">#666666</font></span> | <span style="background-color:#666666"><font color="#FFFFFF">#666666</font></span>
| <span style="background-color:#767676"><font color="#EEEEEC">#777777</font></span> | <span style="background-color:#777777"><font color="#FFFFFF">#777777</font></span> | <span style="background-color:#777777"><font color="#FFFFFF">#777777</font></span>
| <span style="background-color:#878787"><font color="#2E3436">#888888</font></span> | <span style="background-color:#888888"><font color="#000000">#888888</font></span> | <span style="background-color:#888888"><font color="#FFFFFF">#888888</font></span>
| <span style="background-color:#9E9E9E"><font color="#2E3436">#999999</font></span> | <span style="background-color:#999999"><font color="#000000">#999999</font></span> | <span style="background-color:#999999"><font color="#FFFFFF">#999999</font></span>
| <span style="background-color:#A8A8A8"><font color="#2E3436">#aaaaaa</font></span> | <span style="background-color:#AAAAAA"><font color="#000000">#aaaaaa</font></span> | <span style="background-color:#AAAAAA"><font color="#FFFFFF">#aaaaaa</font></span>
| <span style="background-color:#BCBCBC"><font color="#2E3436">#bbbbbb</font></span> | <span style="background-color:#BBBBBB"><font color="#000000">#bbbbbb</font></span> | <span style="background-color:#BBBBBB"><font color="#000000">#bbbbbb</font></span>
| <span style="background-color:#D0D0D0"><font color="#2E3436">#cccccc</font></span> | <span style="background-color:#CCCCCC"><font color="#000000">#cccccc</font></span> | <span style="background-color:#CCCCCC"><font color="#000000">#cccccc</font></span>
| <span style="background-color:#DADADA"><font color="#2E3436">#dddddd</font></span> | <span style="background-color:#DDDDDD"><font color="#000000">#dddddd</font></span> | <span style="background-color:#DDDDDD"><font color="#000000">#dddddd</font></span>
| <span style="background-color:#EEEEEE"><font color="#2E3436">#eeeeee</font></span> | <span style="background-color:#EEEEEE"><font color="#000000">#eeeeee</font></span> | <span style="background-color:#EEEEEE"><font color="#000000">#eeeeee</font></span>
| <span style="background-color:#FFFFFF"><font color="#2E3436">#ffffff</font></span> | <span style="background-color:#FFFFFF"><font color="#000000">#ffffff</font></span> | <span style="background-color:#FFFFFF"><font color="#000000">#ffffff</font></span>

Vim-css-color with out `termguicolors` cannot display color correctly (or say precisely),
if you dont believe your eye, see the source code of this page.

I think vim-hexokinase with a `termguicolors` toggle is a acceptable compromise.
Toggle `termguicolors` by `:set termguicolors!`.
