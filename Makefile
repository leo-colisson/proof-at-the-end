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

# Generates the doc in buildpratend/proofAtTheEnd_doc.pdf
doc:
	rm -rf buildpratend/doc/
	mkdir -p buildpratend/doc/
	pandoc README.md author.yaml --lua-filter=promote-headers.lua --number-sections -f markdown --toc -t latex -s -o buildpratend/doc/proofAtTheEnd_doc.tex
	cd buildpratend/doc/ && pdflatex proofAtTheEnd_doc.tex && pdflatex proofAtTheEnd_doc.tex && cp proofAtTheEnd_doc.pdf ../proofAtTheEnd.pdf
	@echo "Documentation built in buildpratend/proofAtTheEnd.pdf"

# Generates the package in buildpratend/proofAtTheEnd.tar.gz
package: doc demo
	rm -rf buildpratend/proofAtTheEnd/
	mkdir -p buildpratend/proofAtTheEnd/
	cp buildpratend/proofAtTheEnd.pdf buildpratend/proofAtTheEnd/
	cd buildpratend/proofAtTheEnd/ && makedtx -author "Léo Colisson" -dir $(SRC_DIR) -src "proofAtTheEnd\.sty=>proofAtTheEnd.sty" -doc ../doc/proofAtTheEnd_doc.tex proofAtTheEnd
	cp demo.pdf buildpratend/proofAtTheEnd/proofAtTheEnd_demo.pdf
	cd buildpratend/ && tar -zcvf proofAtTheEnd.tar.gz proofAtTheEnd/
	@echo "Package built in buildpratend/proofAtTheEnd.tar.gz"

.PHONY: demo clean doc package
