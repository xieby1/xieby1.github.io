<div style="text-align:right; font-size:3em;">2022.06.21</div>

# isa, a new DSL(Domain Specific Language)

TLDR: isa_parser.py

* defines a DSL(Domain Specific Language) by Lex&Yacc, called isa,
* generates decoder code (cpp) from isa language, called isa parser.

Resources:

* https://www.gem5.org/documentation/general_docs/architecture_support/isa_parser/
* `gem5/src/arch/isa_parser/isa_parser.py`

---

## isa file

### declaration section

* TODO: Format definitions
* Template definition, ends with
  * `Declare`: declaration (header output) templates
  * `Decode`: decode-block templates
  * `Constructor`: decoder output templates
  * `Execute`: exec output templates
* Output blocks
* Let blocks
* Bitfield definitions: `def [signed] bitfield NAME ...`
* Operand and operand type definitions
* Namespace declaration: `namespace NAME;`

### decode section

## isa parser

Instruction behaviors are described by

* C++ code
* bitfield operators
* operand type qualifiers

## files

see src/arch/isa_parser/isa_parser.py:

```python
# Get the file object for emitting code into the specified section
# (header, decoder, exec, decode_block).
def get_file(self, section):
  ...

# Change the file suffix of a base filename:
#   (e.g.) decoder.cc -> decoder-g.cc.inc for 'global' outputs
def suffixize(self, s, sec):
  ...
```

suffix

* `-ns`: namespace
* `-g`: global
