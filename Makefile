all: cli gui

cli: src/SUMMARY.md src/scripts/README.md

src/SUMMARY.md: miao src/scripts/README.md
	rsync -r --exclude-from ~/Documents/Tech/rsync_exclude ~/Documents/Tech/ src/
	./scripts/genSummary.sh > $@

src/scripts/README.md: miao
	rsync -r --exclude-from ~/Gist/script/bash/rsync_exclude ~/Gist/script/bash/ src/scripts/bash/
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

clean:
	find src/ -maxdepth 1 \
		! -wholename src/ \
		! -wholename src/fonts \
		! -wholename src/abbreviations.md \
		! -wholename src/cheatsheet.md \
		! -wholename src/Essays.md \
		! -wholename src/README.md \
		! -wholename src/scripts \
		! -wholename src/Benchmarks \
		-exec rm -rf "{}" \;
	find src/scripts/ -maxdepth 1 \
		! -wholename src/scripts/ \
		! -wholename src/scripts/foot.html \
		-exec rm -rf "{}" \;
	rm -f src/Benchmarks/*.html
