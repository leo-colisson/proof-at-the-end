SRC_DIR:=$(dir $(abspath $(lastword $(MAKEFILE_LIST))))
# CTAN description:
# Summary: A package to move proofs in appendix
# This package aims to provide a way to easily move proofs in the appendix. You can (among other) move proofs in different places/sections, create links from theorem to proofs, restate theorems, add comments in appendix...

demo:
	latexmk -pdf demo.tex

quickstart:
	pdflatex quickstart.tex && pdflatex quickstart.tex

clean:
	rm -rf buildpratend/
	latexmk -pdf -C
	rm -f pratend*
	rm -rf *.log

# Generates the doc in buildpratend/proof-at-the-end_doc.pdf
doc:
	rm -rf buildpratend/doc/
	mkdir -p buildpratend/doc/
	pandoc README.md author.yaml --lua-filter=promote-headers.lua --number-sections -f markdown --toc -t latex -s -o buildpratend/doc/proof-at-the-end_doc.tex
	cp screenshot.png buildpratend/doc/
	cd buildpratend/doc/ && latexmk -pdf proof-at-the-end_doc.tex && cp proof-at-the-end_doc.pdf ../proof-at-the-end.pdf
	@echo "Documentation built in buildpratend/proof-at-the-end.pdf"

# Generates the package in buildpratend/proof-at-the-end.tar.gz
package: doc demo
	rm -rf buildpratend/proof-at-the-end/
	mkdir -p buildpratend/proof-at-the-end/
	cp README.md buildpratend/proof-at-the-end/
	cp buildpratend/proof-at-the-end.pdf buildpratend/proof-at-the-end/
	cd buildpratend/proof-at-the-end/ && makedtx -author "Léo Colisson" -dir $(SRC_DIR) -src "proof-at-the-end\.sty=>proof-at-the-end.sty" -doc ../doc/proof-at-the-end_doc.tex proof-at-the-end
	cp demo.pdf buildpratend/proof-at-the-end/proof-at-the-end_demo.pdf
	cp demo.tex buildpratend/proof-at-the-end/proof-at-the-end_demo.tex
	cd buildpratend/ && tar -zcvf proof-at-the-end.tar.gz proof-at-the-end/
	@echo "Package built in buildpratend/proof-at-the-end.tar.gz"
	@echo "################ /!\ Make sure to update the version in proof-at-the-end.sty"

.PHONY: demo clean doc package
