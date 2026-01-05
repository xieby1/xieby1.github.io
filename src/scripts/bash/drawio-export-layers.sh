#!/usr/bin/env bash
set -e

usage() {
  echo "Usage: ${0##*/} <file.drawio>"
  echo "Output: <file.svg>"
  echo "  In addition, if the number of layers is greater than 1,"
  echo "  the <file_0.svg> [<file_1.svg> [...]] will be exported."
  exit 0
}
if [[ $# -lt 1 ]]; then usage; fi
if [[ ! $1 =~ .drawio ]]; then usage; fi
if [[ ! -f $1 ]]; then usage; fi

OPTS="--embed-svg-fonts false --svg-theme light -x -f svg"

drawio $OPTS "$1" -o "${1%.*}.svg"

# drawio layer有两种
# 1. 直接点+添加的：
#    <mxCell id="a3G2nR5CTN_Bl481C6k4-48" value="main_coherence" parent="0" />
#    匹配模式：value="([^"]*)".*parent="0"
# 2. 修改了属性（比如名字的）
#    <object label="main_consistency" id="a3G2nR5CTN_Bl481C6k4-47">
#      <mxCell parent="0" />
#    </object>
#    匹配模式：object label="([^"]*)

readarray -t layers < <(perl -ne 'print "$1$2\n" if /value="([^"]*)".*parent="0"|object label="([^"]*)"/' "$1")
nlayers=${#layers[@]}
if [[ $nlayers -gt 1 ]]; then
  for ((i=0; i<nlayers; i++)); do
    drawio $OPTS "$1" -l $i -o "${1%.*}_${i}_${layers[i]}.svg"
  done
fi
