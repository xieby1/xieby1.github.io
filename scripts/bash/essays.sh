#!/usr/bin/env -S bash -i
pdfs=$(find ~/Documents/Tech/ -name "*.pdf")
for pdf in $pdfs; do
    filename=${pdf##*/}
    publication_citation_pdf=${filename#*.*.*.}
    publication=${publication_citation_pdf%.*.*}
    echo $publication
    # [[ $publication == "$1" ]] && echo ${pdf#*Tech/}
done
