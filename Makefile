SRC_DIR:=$(dir $(abspath $(lastword $(MAKEFILE_LIST))))
# CTAN description:
# Summary: A package to move proofs in appendix
# This small package aims to provide a way to easily move proofs in the appendix. You can (among other) move proofs in different places/sections, create links from theorem to proofs, restate theorems, add comments in appendix...

demo:
	pdflatex demo.tex && pdflatex demo.tex

clean:
	rm -rf buildpratend/
	latexmk -C
	rm -f pratend*
	rm -rf *.log

# Generates the doc in buildpratend/proof-at-the-end_doc.pdf
doc:
	rm -rf buildpratend/doc/
	mkdir -p buildpratend/doc/
	pandoc README.md author.yaml --lua-filter=promote-headers.lua --number-sections -f markdown --toc -t latex -s -o buildpratend/doc/proof-at-the-end_doc.tex
	cd buildpratend/doc/ && pdflatex proof-at-the-end_doc.tex && pdflatex proof-at-the-end_doc.tex && cp proof-at-the-end_doc.pdf ../proof-at-the-end.pdf
	@echo "Documentation built in buildpratend/proof-at-the-end.pdf"

# Generates the package in buildpratend/proof-at-the-end.tar.gz
package: doc demo
	rm -rf buildpratend/proof-at-the-end/
	mkdir -p buildpratend/proof-at-the-end/
	cp buildpratend/proof-at-the-end.pdf buildpratend/proof-at-the-end/
	cd buildpratend/proof-at-the-end/ && makedtx -author "Léo Colisson" -dir $(SRC_DIR) -src "proof-at-the-end\.sty=>proof-at-the-end.sty" -doc ../doc/proof-at-the-end_doc.tex proof-at-the-end
	cp demo.pdf buildpratend/proof-at-the-end/proof-at-the-end_demo.pdf
	cd buildpratend/ && tar -zcvf proof-at-the-end.tar.gz proof-at-the-end/
	@echo "Package built in buildpratend/proof-at-the-end.tar.gz"

.PHONY: demo clean doc package
