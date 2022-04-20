#!/usr/bin/env bash
# ls files & directories only contaion in git repo
if [[ $1 == "-h" ]]
then
    echo "ls files in git"
    exit
fi
FILES_IN_GIT=$(git ls-files .)
if [[ $? -ne 0 ]]; then
    exit $?
fi
echo ${FILES_IN_GIT} | \
    tr " " "\n" | \
    sed s,/.*,, | \
    uniq | \
    xargs ls -d --color=auto $*
