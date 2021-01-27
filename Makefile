HEADERS := $(patsubst %.tex,%_trim.pdf,$(wildcard I*/header.tex))
ALL: $(patsubst %.tex,%_trim.pdf,$(wildcard I*/*.tex))

$(HEADERS):
	@echo -ne ""

%_trim.pdf: %.tex
	./gen.sh $<
	cd `dirname $<`; ./sync.sh `basename $< .tex`*

.PHONY: clean
clean:
	rm -vf */*~ */*.log */*.bbl */*.blg */*.toc */*.aux */*.out */*.idx */*.ilg */*.ind
	rm -vf */*_html.tex */*_trim.tex */*_def.tex */*_def_thm.tex */*_thm_proof.tex
	rm -vrf */*_output */*_tmp
