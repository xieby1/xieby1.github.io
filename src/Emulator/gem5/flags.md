<div style="text-align:right; font-size:3em;">2022.08.25</div>

# Flags in Gem5

## X86 Jump Condition (Jcc)

amd64.pdf: General-Purpose Instruction Reference: Jcc

vim-markdown TableFormat does not handle `\|` well,
use `v` to represent logic operation OR.

| Cond    | F        | Cond     | !F        |
|---------|----------|----------|-----------|
| O       | O        | NO       | !O        |
| B,C,NAE | C        | NB,NC,AE | !C        |
| Z,E     | Z        | NZ,NE    | !Z        |
| BE,NA   | CvZ      | NBE,A    | !C&!Z     |
| S       | S        | NS       | !S        |
| P,PE    | P        | NP,PO    | !P        |
| L,NGE   | S!=O     | NL,GE    | S==O      |
| LE,NG   | Zv(S!=O) | NLE,G    | !Z&(S==O) |

## A64 Jump Condtion (B.cond)

2021.armv8.pdf: C6.2.25 B.cond => J1.3.3 shared/functions/system/ConditionHolds:

v: or

| Cond | F         | Cond | !F       |
|------|-----------|------|----------|
| EQ   | Z         | NE   | !Z       |
| CS   | C         | CC   | !C       |
| MI   | N         | PL   | !N       |
| VS   | V         | VC   | !V       |
| HI   | C&!Z      | LS   | !CvZ     |
| GE   | N==V      | LT   | N!=V     |
| GT   | (N==V)&!Z | LE   | (N!=V)vZ |
| AL   | True      |      |          |

## mapping

N?OF=(SF!=OF)?OF
0=0?0=(0!=0)?0
0=1?1=(0!=1)?1
1=1?0=(1!=0)?0
1=0?1=(1!=1)?1
Therefor, ? is !=

OF:V
CF:C
ZF:Z
SF:N!=V
PF

Z:ZF
C:CF
N:SF!=OF
V:OF
