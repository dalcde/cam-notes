#!/usr/bin/env python

import os

def mykey (x):
    if x[-1] == "E":
        return x[:-1] + "3"
    elif x[-1] == "L":
        return x[:-1] + "2"
    else: 
        return x[:-1] + "1"

f = open("Makefile", "w")

dirs = list(filter(lambda x: os.path.isdir(x) and x.startswith("I"), os.listdir()))
dirs.sort(key=mykey)

f.write("ALL: {}\n\n".format(" ".join(dirs)))

TARGET_FORMAT="""\
{dir}/{tex}_trim.pdf: {dir}/{tex}.tex
\t./gen.sh {dir}/{tex}.tex
\tcd {dir}; ./sync.sh {tex}*
\techo "`date --rfc-3339=seconds` - {tex}.tex" >> ~/.sync-log

"""

for direc in dirs:
    docs = []
    for doc in os.listdir(direc):
        if not (doc.endswith(".tex")) or (doc == "header.tex"):
            continue
        f.write(TARGET_FORMAT.format(dir=direc, tex=doc[:-4]))

        docs.append(direc + "/" + doc[:-4] + "_trim.pdf")
    f.write("{dir}: {deps}\n\n".format(dir=direc, deps=" ".join(docs)))

f.write("""\
.PHONY: clean
clean:
\trm -vf */*~ */*.log */*.bbl */*.blg */*.toc */*.aux */*.out */*.idx */*.ilg */*.ind
\trm -vf */*_html.tex */*_trim.tex */*_def.tex */*_def_thm.tex */*_thm_proof.tex
\trm -vrf */*_output */*_tmp
""")

f.close()
