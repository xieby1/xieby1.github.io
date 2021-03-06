<div style="text-align:right; font-size:3em;">2022.07.04</div>

# Operands in Gem5

## Operands Definition

* src/arch/x86/isa/operands.isa:

  ```isa
  def operands {{
    ...
    'DestReg': intReg('dest', 5),
    ...
  }};
  ```

  `intReg` is defined in the same file.

  ```isa
  def intReg(idx, id):
    return ('IntReg', 'uqw', idx, 'IsInteger', id)
  ```

  This isa file is parsed by src/arch/isa_parser/isa_parser.py.

  * src/arch/isa_parser/isa_parser.py:

    ```python
    class ISAParser(Grammar):
      ...
      def p_def_operands(self, t):
        'def_operands : DEF OPERANDS CODELIT SEMI'
        ...
        user_dict = eval('{' + t[3] + '}', self.exportContext)
        ...
        self.buildOperandNameMap(user_dict, t.lexer.lineno)
      ...
    ```

    After parsing `user_dict` contains a entry
    `user_dict[DestReg] = ('IntReg', 'uqw', 'dest', 'IsInteger', 5)`.

    * src/arch/isa_parser/isa_parser.py:

      ```python
      def buildOperandNameMap(self, user_dict, lineno):
        ...
        for op_name, val in user_dict.items():
          val += (None, None, None, None)
          base_cls_name, dflt_ext, reg_spec, flags, sort_pri, \
          read_code, write_code, read_predicate, write_predicate = val[:9]
          ...
          cls_name = base_cls_name + '_' + op_name
          ...
          base_cls = eval(base_cls_name + 'Operand')
          ...
          operand_name[op_name] = type(cls_name, (base_cls,), tmp_dict)
        self.operandNameMap.update(operand_name)
      ```

      `buildOperandNameMap` shows avialable args for an operand definition.
      `buildOperandNameMap` derives a class named `cls_name` from `base_cls`,
      where `cls_name = IntReg_DestReg`, `base_cls = IntRegOperand`.
      And every thing in operand definition is add to derived class `IntReg_DestReg`.
      Finally, an entry `{"DestReg": class IntReg_DestReg}` is added to `operandNameMap`.

## Operands Reference

* src/arch/x86/isa/microops/limmop.isa:

  ```isa
  def template MicroLimmOpExecute {{
      Fault
      %(class_name)s::execute(ExecContext *xc,
              Trace::InstRecord *traceData) const
      {
          %(op_decl)s;
          %(op_rd)s;
          %(code)s;
          %(op_wb)s;
          return NoFault;
      }
  }};
  ```

  ```isa
  iop = InstObjParams("limm", "Limm", base,
        {"code" : "DestReg = merge(DestReg, dest, imm64, dataSize);"})
  exec_output += MicroLimmOpExecute.subst(iop)
  ```

  `code` will be replaced by `code` defined in `InstObjParams` above.
  `op_decl`, `op_rd`, `op_wb` will be generated by parsing what are `code` needed.
  What are `code` needed means which operands are used.

  * src/arch/isa_parser/isa_parser.py:

    ```python
    class InstObjParams(object):
      def __init__(self, parser, mnem, class_name, base_class = '',
                   snippets = {}, opt_args = []):
        ...
        self.operands = OperandList(parser, compositeCode)
        ...
    ```

    `compositeCode` is `code` passed as parameter to `InstObjParams`,
    is `"DestReg = merge(DestReg, dest, imm64, dataSize);"`.

    * ./src/arch/isa_parser/operand_list.py:

      ```python
      class OperandList(object):
        def __init__(self, parser, code):
          ...
          for match in parser.operandsRE().finditer(code):
            ...
      ```

      A RE is applied to `code`.
      The definition of RE is listed below.

      * src/arch/isa_parser/isa_parser.py:

        ```python
        def operandsRE(self):
            if not self._operandsRE:
                self.buildOperandREs()
            return self._operandsRE
        ```

        ```python
        def buildOperandREs(self):
          operands = list(self.operandNameMap.keys())
          ...
          operandsREString = r'''
          (?<!\w)      # neg. lookbehind assertion: prevent partial matches
          ((%s)(?:_(%s))?)   # match: operand with optional '_' then suffix
          (?!\w)       # neg. lookahead assertion: prevent partial matches
          ''' % ('|'.join(operands), '|'.join(extensions))
        ```

        The re is `(?<!\w)((%s)(?:_(%s))?)(?!\w)`.
        This re contains 3 captured groups,

        * group1: `((%s)(?:_(%s))?)`
        * group2: the first `(%s)`
        * group3: the second `(%s)`

        Note: https://regexr.com/ is good to help you pick up RE quickly.

      RE will capture all operands in `code`.
      The captured operands are processed as below.

      ```python
      class OperandList(object):
        def __init__(self, parser, code):
          ...
          for match in parser.operandsRE().finditer(code):
            op = match.groups()
            (op_full, op_base, op_ext) = op
            ...
            # see if we've already seen this one
            op_desc = self.find_base(op_base)
            if op_desc:
              ...
            else:
              # new operand: create new descriptor
              op_desc = parser.operandNameMap[op_base](parser,
              op_full, op_ext, is_src, is_dest)
              ...
      ```

      The matched operand will be checked whether it has been added to operand list.
      I focus on operand has not been added,
      in which situation, a new operand is created.
      Assume the to-be-created operand is DestReg,
      therefore `op_base` is `DestReg`.
      And `operandNameMap[op_base]` is `class IntReg_DestReg`,
      which is created in operands definition section.
      `class IntReg_DestReg` is a subclass of `IntRegOperand`.

      As a result, the constructor of `class IntReg_DestReg` will be called.

      Finally,

      ```python
      class OperandList(object):
        def __init__(self, parser, code):
          ...
          for op_desc in self.items:
            op_desc.finalize(self.predRead, self.predWrite)
      ```

      `self.predRead` and `self.predWrite` are bool variables,
      which indicate whether conditional read/write exists in current operand list.

      * ./arch/isa_parser/operand_types.py:

      I focus on finalizing a dest reg.

      ```python
      def finalize(self, predRead, predWrite):
        ...
        if self.is_dest:
          self.op_wb = self.makeWrite(predWrite)
          self.op_dest_decl = self.makeDecl()
        else:
          self.op_wb = ''
          self.op_dest_decl = ''
        ...
      ```

      * ./arch/isa_parser/operand_types.py:

        ```python
        def makeWrite(self, predWrite):
          ...
          if predWrite:
            ...
          else:
              wcond = ''
              windex = '%d' % self.dest_reg_idx
          wb = '''
          %s
          {
              %s final_val = %s;
              xc->setIntRegOperand(this, %s, final_val);\n
              if (traceData) { traceData->setData(final_val); }
          }''' % (wcond, self.ctype, self.base_name, windex)
          return wb
        ```

        * If we focus on no conditional code,
        then `wcond = ''`.
        * `self.ctype` is defined in src/arch/isa_parser/operand_types.py: `Operand: __init__`.
          It is needs parser def_operand_types, which is simple.
          `self.ctype` is uint64_t, according to `dflt_ext = uqw`.
        * `self.base_name` is defined in src/arch/isa_parser/isa_parser.py,
          which is equal to `op_name` aka `DestReg`.
        * `windex = self.dest_reg_idx` is defined is ./src/arch/isa_parser/operand_list.py,
          which is sorted by `sort_pri`.
          There is only one dest, so `windex` here is 0.
