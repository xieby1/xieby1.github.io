<div style="text-align:right; font-size:3em;">2022.07.04</div>

# Operands Man Page

## def operand

parser: src/arch/isa_parser/isa_parser.py

```isa
def operand {{
  'op_name': tuple
}};
```

tuple can be

```isa
(base_cls_name, dflt_ext, reg_spec, flags, sort_pri, [read_code[, write_code[, read_predicat[e, write_predicate]]]])
```

## def operand_types

parser: isa_parser.py

```isa
def operand_types {{
  'typename' : 'ctype'
}};
```

