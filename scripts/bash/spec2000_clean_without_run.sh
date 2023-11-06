#!/usr/bin/env bash

# execute this script in root directory of spec2000
rm benchspec/*/*.bset*
rm benchspec/*/*/{Spec,data,docs,exe,result,src,version} -rf
rm benchspec/*/*/*/list
rm benchspec/*/*/*/*/*.{cmd,err,out,cmp}
