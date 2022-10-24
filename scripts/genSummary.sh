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

echo "# Summary"
echo
echo "* [Welcome](./README.md)"
echo "* [Essays](./Essays.md)"
echo "* [abbreviations](./abbreviations.md)"
echo
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

    # ignore ., pictures folder, Essays.md, abbreviations.md
    if [[ ${1##*/} == "pictures" || \
          ${1##*/} == "." || \
          ${1##*/} == "Essays.md" || \
          ${1##*/} == "abbreviations.md" || \
          ${1} =~ "/miao" ]]
    then
        return 0
    fi

    # ignore none .md file
    EXT=${1:(-3):3}
    if [[ -f $1 && $EXT != ".md" ]]
    then
        return 0
    fi

    # count indentation # $1   = ./miao/wang/x.md
    TMP1=${1#./}        # TMP1 = miao/wang/x.md
    TMP2=${TMP1//[^\/]} # TMP2 = //
    INDENT=${#TMP2}     # INDENT = 2

    # output
    for (( i=0; i<${INDENT}; i++ ))
    do
        echo -n "  "
    done
    if [[ -f $1 ]]
    then
        FILE_NAME=${1##*/}
        re='^[0-9][0-9][0-9][0-9]\.'
        # dont change papers.md name e.g. 2015.overview.mitra.jip.15.md
        if [[ "${FILE_NAME}" =~ $re ]]
        then
            TITLE=""
        else
            TITLE=$(head -n 3 "${1}" | awk '/^# / {$1=""; print substr($0,2); exit;}')
        fi
        if [[ -n ${TITLE} ]]
        then
            echo "* [${TITLE}](${1})"
        else
            echo "* [${NAME}](${1})"
        fi
    elif [[ -f ${1}/index.md ]]
    then
        echo "* [${NAME}](${1}/index.md)"
    elif [[ -f ${1}/README.md ]]
    then
        echo "* [${NAME}](${1}/README.md)"
    else
        echo "* [${NAME}]()"
    fi
}

FIND_OUT=$(find . | sort -n)
for entry in $FIND_OUT
do
    solve_an_entry ${entry}
done
