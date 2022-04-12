#!/usr/bin/env bash
# This script does not use the fzf to search,
# instead it use `rg` (case-ignored mode) to search,
# fzf is just a selector or a UI infrastructure to call `rg`
# From https://github.com/junegunn/fzf/wiki/Examples#searching-file-contents
##
# Interactive search.
# Usage: `ff` or `ff <folder>`.
#

if [[ $1 == "-h" ]]
then
    echo "fuzzy find"
    exit
fi

[[ -n $1 ]] && cd $1 # go to provided folder or noop
RG_DEFAULT_COMMAND="rg -i -l --hidden --no-ignore-vcs --sortr path"

selected=$(
FZF_DEFAULT_COMMAND="rg --files" fzf \
  -m \
  -e \
  --ansi \
  --phony \
  --reverse \
  --bind "ctrl-a:select-all" \
  --bind "f12:execute-silent:(subl -b {})" \
  --bind "change:reload:$RG_DEFAULT_COMMAND {q} || true" \
  --preview "rg -i --pretty --context 2 {q} {}" | cut -d":" -f1,2
)

echo "${selected}"
# [[ -n $selected ]] && gedit $selected # open multiple files in editor 
