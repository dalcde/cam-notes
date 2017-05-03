#!/usr/bin/env python

import os

f = open("Makefile", "w")

dirs = list(filter(lambda x: os.path.isdir(x) and x.startswith("I"), os.listdir()))

f.write("ALL: " + " ".join(dirs) + "\n\n")

for direc in dirs:
    docs = []
    for doc in os.listdir(direc):
        if not (doc.endswith(".tex")) or (doc == "header.tex"):
            continue
        f.write(direc + "/" + doc[:-4] + "_trim.pdf: " + direc + "/" + doc + "\n")
        f.write("\t./gen.sh " + direc + "/" + doc + "\n")
        f.write("\tcd " + direc + "; ./sync.sh " + doc[:-4] + "*\n")
        f.write("\techo \"`date --rfc-3339=seconds` - " + doc + "\" >> ~/.sync-log\n")
        f.write("\n")
        docs.append(direc + "/" + doc[:-4] + "_trim.pdf")
    f.write(direc + ": " + " ".join(docs) + "\n\n")

f.write(".PHONY: clean\n")
f.write("clean:\n")
f.write("\trm -vf */*~ */*.log */*.bbl */*.blg */*.toc */*.aux */*.out */*.idx */*.ilg */*.ind\n")
f.write("\trm -vf */*_html.tex */*_trim.tex */*_def.tex */*_def_thm.tex */*_thm_proof.tex\n")
f.write("\trm -vrf */*_output */*_tmp\n")
f.close()
