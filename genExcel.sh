#!/usr/bin/env bash
IN=$1  # /path/to/miao.xlsx
OUT=$2 # /path/to/my_miao.html
TMP=${1##*/}        # miao.xlsx
TMP=${TMP%.*}.html  # miao.html

libreoffice --convert-to html --outdir src/ $IN
mv src/${TMP} $OUT
# eliminate tab
sed -i 's/\t//g' $OUT
# https://unix.stackexchange.com/questions/522038/selective-deletion-of-lines-between-two-patterns
# delete <style>...</style>
awk -i inplace -v f=1 '/<style/{f=0} /<\/head/{f=1} f' $OUT

