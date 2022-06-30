<div style="text-align:right; font-size:3em;">2022.06.25</div>

# PLY(Python Lex Yacc) in gem5

http://www.dabeaz.com/ply/ply.html

> PLY relies on reflection (introspection) to build its lexers and parsers.

Here is the basic ideas:

## (Lex)Token:

* tokens list

  `tokens`

* specification of tokens: regex in python re mode

  `t_` prefixed variable or function

## (Yacc)Parser

* grammaer rule: function with docstring contains grammaer specification, e.g.

  ```python
  def p_expression_plus(p):
       'expression : expression PLUS term'
       #   ^            ^        ^    ^
       #  p[0]         p[1]     p[2] p[3]

       p[0] = p[1] + p[3]
  ```



