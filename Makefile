all: cli gui

cli: src/SUMMARY.md src/scripts/README.md

src/SUMMARY.md: miao
	rsync -r --exclude-from ~/Documents/Tech/rsync_exclude ~/Documents/Tech/ src/
	genSummary.sh > $@

src/scripts/README.md: miao
	rsync -r --exclude-from ~/Gist/script/bash/rsync_exclude ~/Gist/script/bash/ src/scripts/
	./genScripts.sh > $@

gui: src/my_cheatsheet.html \
	 src/my_Essays.html \
	 src/my_abbreviations.html \
	 src/Benchmarks/my_coremark.html \
	 src/Benchmarks/my_spec2000.html

src/my_cheatsheet.html: ~/Documents/Manuals-Sheets/my_cheatsheet.md
	cheatsheet.sh $<
	cp $(patsubst %.md, %.html, $<) $@

src/my_Essays.html: ~/Documents/Tech/Essays.xlsx
	./genExcel.sh $< $@

src/my_abbreviations.html: ~/Documents/Tech/abbreviations.xlsx
	./genExcel.sh $< $@

src/Benchmarks/my_coremark.html: ~/Documents/Tech/Benchmarks/coremark.xlsx
	./genExcel.sh $< $@

src/Benchmarks/my_spec2000.html: ~/Documents/Tech/Benchmarks/spec2000.xlsx
	./genExcel.sh $< $@

miao:
