#!/usr/bin/env bash
# input: native assmblies
# output: native machine codes
CMD="${0##*/}"
usage() {
    echo "asm => bin"
    echo "${CMD} [-h] <asm>"
    echo "Convert <asm> to machine code, by as"
    echo "Escape Note:"
    echo "  hash tag (#), simicolon (;), slash (\\)"
    echo "Example:"
    echo "  ${CMD} \"int \\\$0x80\""
    echo "  ${CMD} \"add \\\$12, %eax\""
    echo "  ${CMD} \"nop\\nnop\""
    echo "  ${CMD} \"nop\\;nop\""
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

echo -e "$@" | as -al --32 -o /dev/null
