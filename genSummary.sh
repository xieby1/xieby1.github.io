#!/usr/bin/env bash

if [[ $# -ge 1 ]]
then
    SRC=$1
else
    SRC="./src/"
fi
if [[ ! -d $SRC ]]
then
    echo "${SRC} is not a directory"
    exit -1
fi
cd "$SRC"

echo "# xieby1's notes"
echo

solve_an_entry()
{
    # README.md & index.md belongs to current folder
    NAME=${1##*/}
    if [[ ${NAME} == "README.md" || ${NAME} == "index.md" || ${NAME} == "SUMMARY.md" ]]
    then
        return 0
    fi

    # .
    if [[ $1 == '.' ]]
    then
        NAME=Welcome
    fi

    # ignore none .md file
    EXT=${1:(-3):3}
    if [[ -f $1 && $EXT != ".md" ]]
    then
        return 0
    fi

    # ignore pictures folder
    if [[ ${1##*/} == "pictures" ]]
    then
        return 0
    fi

    # count indentation # $1   = ./miao/wang/x.md
    TMP1=${1#./}        # TMP1 = miao/wang/x.md
    TMP2=${TMP1//[^\/]} # TMP2 = //
    INDENT=${#TMP2}     # INDENT = 2

    # output
    RES=""
    for (( i=0; i<${INDENT}; i++ ))
    do
        echo -n "  "
    done
    echo -n "* ["
    echo -n ${NAME}
    echo -n "]("
    if [[ -f $1 ]]
    then
    echo -n $1
    fi
    if [[ -f ${1}/index.md ]]
    then
        echo -n ${1}/index.md
    fi
    if [[ -f ${1}/README.md ]]
    then
        echo -n ${1}/README.md
    fi
    echo ")"
}

FIND_OUT=$(find . | sort -n)
for entry in $FIND_OUT
do
    solve_an_entry ${entry}
done
