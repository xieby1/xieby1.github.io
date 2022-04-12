<div style="text-align:right; font-size:3em;">2021.07.30</div>

LoongArch.pdf有一些文字（页码和指令），所以ocrmypdf会自动跳过带文字的页。需要`-f`指令。

`-f`选项将栅格化的图片也加入到了pdf，使得pdf大小膨胀极大，LoongArch.pdf从20+M变成了120+M。

参考[Feature Request: --redo-ocr or -f with text removal](https://github.com/jbarlow83/OCRmyPDF/issues/794)的Jmuccigr的回复2021.6.22：

> See [#736](https://github.com/jbarlow83/OCRmyPDF/issues/736) with lots of comments, including mine about how I handle files that I need to redo the OCR on:
>
> > I have this same thing happen all the time when I redo the OCR on a PDF by removing the text layer and using ocrmypdf --force-ocr on the file, then overlaying just the text layer back onto the original file (I use --output-type pdf not pdfa), or even when I use tesseract to OCR some image files and put them into a PDF.
>
> When I've got a PDF that is just OCRed images, I use PyPDF2 to remove the text and save that to a new file. Then ocrmypdf with force-ocr OCRs that new file, saving to a second file on which I have gs remove all the images leaving just text, and finally(!) qpdf to overlay the text layer back onto the original pdf. I save some of the original file's metadata and also have an option to skip the first page (because I do this on jstor files a lot and I like to keep that info page). Script is [here](https://github.com/Jmuccigr/scripts/blob/master/redo_ocr_PDF.sh).

用`ocrmypdf -f`，提取出ocr文本，叠加在原文档上。

其脚本精华如下，

```shell
# strip text from the PDF
## 这个是个他自己的脚本，调用的pypdf2的removetext，对于LoongArch.pdf并不好用
## 我更倾向于不去掉原文档的文本，因为LoongArch.pdf可视的页码会被去掉。
## 尽管叠加OCR文本后某些文本会重复，不过因为这样的文本很少，可以忍受。
# python3 "$dir_path/remove_PDF_text.py" "$input" "$tmpdir/no_text.pdf"
gs -o "$tmpdir/no_text.pdf" -dFILTERTEXT -sDEVICE=pdfwrite "$input"

# ocr the original pdf ## `tesseract --list-langs`得到chi_sim
ocrmypdf --force-ocr --output-type pdf -l $lang "$tmpdir/no_text.pdf" "$tmpdir/ocr_output.pdf"

#strip images from that result
gs -o "$tmpdir/textonly.pdf" -dFILTERIMAGE -dFILTERVECTOR -sDEVICE=pdfwrite "$tmpdir/ocr_output.pdf"

# overlay ocr text on file stripped of text
qpdf "$tmpdir/no_text.pdf" --overlay "$tmpdir/textonly.pdf" -- "$tmpdir/final.pdf"

# Restore the original metadata, if any
exiftool -Title="$title" "$tmpdir/final.pdf"
exiftool -Author="$author" "$tmpdir/final.pdf"
```

