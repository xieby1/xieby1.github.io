all: cli gui

cli: src/SUMMARY.md src/scripts/README.md

src/SUMMARY.md: miao
	rsync -r --exclude-from ~/Documents/Tech/rsync_exclude ~/Documents/Tech/ src/
	./scripts/genSummary.sh > $@

src/scripts/README.md: miao
	rsync -r --exclude-from ~/Gist/script/bash/rsync_exclude ~/Gist/script/bash/ src/scripts/bash/
	rsync -r ~/Gist/script/nix/ src/scripts/nix/
	./scripts/genScripts.sh > $@

gui: src/my_cheatsheet.html \
	 src/my_Essays.html \
	 src/my_abbreviations.html \
	 src/Benchmarks/my_coremark.html \
	 src/Benchmarks/my_spec2000.html

src/my_Essays.html: ~/Documents/Tech/Essays.xlsx
	./scripts/genExcel.sh $< $@

src/my_abbreviations.html: ~/Documents/Tech/abbreviations.xlsx
	./scripts/genExcel.sh $< $@

src/Benchmarks/my_coremark.html: ~/Documents/Tech/Benchmarks/coremark.xlsx
	./scripts/genExcel.sh $< $@

src/Benchmarks/my_spec2000.html: ~/Documents/Tech/Benchmarks/spec2000.xlsx
	./scripts/genExcel.sh $< $@

miao:
