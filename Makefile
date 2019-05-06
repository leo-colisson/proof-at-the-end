SRC_DIR:=$(dir $(abspath $(lastword $(MAKEFILE_LIST))))

demo:
	pdflatex demo.tex && pdflatex demo.tex

clean:
	rm -rf buildpratend/
	latexmk -C
	rm -f pratend*

# Generates the doc in buildpratend/proof-at-the-end-doc.pdf
doc:
	rm -rf buildpratend/doc/
	mkdir -p buildpratend/doc/
	pandoc README.md author.yaml --lua-filter=promote-headers.lua --number-sections -f markdown --toc -t latex -s -o buildpratend/doc/proof-at-the-end-doc.tex
	cd buildpratend/doc/ && pdflatex proof-at-the-end-doc.tex && pdflatex proof-at-the-end-doc.tex && cp proof-at-the-end-doc.pdf ../proof-at-the-end.pdf
	@echo "Documentation built in buildpratend/proof-at-the-end.pdf"

# Generates the doc in buildpratend/proof-at-the-end-doc.pdf
package: doc demo
	rm -rf buildpratend/proof-at-the-end/
	mkdir -p buildpratend/proof-at-the-end/
	cp buildpratend/proof-at-the-end.pdf buildpratend/proof-at-the-end/
	cd buildpratend/proof-at-the-end/ && makedtx -dir $(SRC_DIR) -src "proof-at-the-end\.sty=>proof-at-the-end.sty" -doc ../doc/proof-at-the-end-doc.tex proof-at-the-end
	cp demo.pdf buildpratend/proot-at-the-end/
	cd buildpratend/ && tar -zcvf proof-at-the-end.tar.gz proof-at-the-end/
	@echo "Package built in buildpratend/proof-at-the-end.tar.gz"

.PHONY: demo clean doc package
