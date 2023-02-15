#!/usr/bin/env bash
# input: native assmblies
# output: native machine codes
CMD="${0##*/}"
usage() {
    echo "asm => bin"
    echo "Usage: ${CMD} [-h] <asm>"
    echo "  Convert <asm> to machine code, by GNU assembler 'as'."
    echo "Symbol needs to be escaped:"
    echo "  dolar (\\\$), hash tag (\\#), simicolon (\\;), slash (\\\\)"
    echo "Example:"
    echo "  ${CMD} \"int \\\$0x80\""
    echo "  ${CMD} \"add \\\$12, %eax\""
    echo "  ${CMD} \"nop\\nnop\""
    echo "  ${CMD} \"nop;nop\""
    echo "  ${CMD} \"movl \\\$0x5657e589, 0x55(%esp)\""
    echo "  ${CMD} \"movq \\\$0x12345678, %gs:0x9abcdef(%rax, %rbx, 2)\""
    exit 0
}
if [[ $# -lt 1 ]]
then
    usage
fi
if [[ $1 == "-h" ]]
then
    usage
fi

echo -e "$@" | as -al -o /dev/null
# echo -e "$@" | as -al --32 -o /dev/null
