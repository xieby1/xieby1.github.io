<div style="text-align:right; font-size:3em;">2023.11.23</div>

# \cite末尾空格

OK

```latex
\cite{
    cristinacifuentesBinaryTranslationStatic1996,
    altmanWelcomeOpportunitiesBinary2000,
    altmanAdvancesFutureChallenges2001,
    markprobstDynamicBinaryTranslation2003}
```

xelatex不行，pdflatex可以

```latex
\cite{
    cristinacifuentesBinaryTranslationStatic1996,
    altmanWelcomeOpportunitiesBinary2000,
    altmanAdvancesFutureChallenges2001,
    markprobstDynamicBinaryTranslation2003
}
% 或是
二进制翻译(binary translation)技术\cite{
    cristinacifuentesBinaryTranslationStatic1996,
    altmanWelcomeOpportunitiesBinary2000,
    altmanAdvancesFutureChallenges2001,
    markprobstDynamicBinaryTranslation2003 } % 末尾有空格
```

解决方法使用cite或是natbib包，参考https://tex.stackexchange.com/questions/4517/cite-that-tolerates-whitespace

xelatex+cite/natbib不支持cite末尾的空格，

pdflatex+cite/natbib支持cite末尾的空格，
但[pdflatex不支持fandol中文](https://tex.stackexchange.com/questions/545681/critical-package-ctex-errorctex-fontsetfandol-is-unavailable-in-current)

