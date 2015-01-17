#!/bin/bash

for var in "$@"
do
    if [ "${var##*.}" != "tex" ]; then
        echo "$var not a tex file";
        continue;
    fi

    if [ $var == "header.tex" ]; then
        echo "Not compiling header.tex";
        continue;
    fi

    # Compile regular
    echo "compile ‘"`basename $var .tex`".pdf’"
    pdflatex $var > /dev/null
    pdflatex $var > /dev/null

    # Compile theorem
    parse="BEGIN{
        printing = 1;
    }
    /begin\{thm/||/begin\{prop/||/begin\{lemma/||/begin\{cor/||/begin\{axiom/||/begin\{law/{
        printing = 1;
    }

    /end\{document/{
        printing = 1;
    }

    printing == 1 {
        print;
    }
    /section\{/{
        print;
    }
    /tableofcontents/{
        printing = 0;
    }

    /end\{thm/||/end\{prop/||/end\{lemma/||/end\{cor/||/end\{axiom/||/end\{law/{
        printing = 0;
    }"

    echo "compile ‘"`basename $var .tex`"_thm.pdf’"
    awk "$parse" $var | sed 's/title{[a-zA-Z -]*/&\\\\ {\\Large Theorems}/;s/pdftitle={[a-zA-Z -]*/& (Theorems)/' | pdflatex > /dev/null
    awk "$parse" $var | sed 's/title{[a-zA-Z -]*/&\\\\ {\\Large Theorems}/;s/pdftitle={[a-zA-Z -]*/& (Theorems)/' | pdflatex > /dev/null
    mv texput.pdf `basename $var .tex`"_thm.pdf"

    # Compile theorem with proof
    parse="BEGIN{
        printing = 1;
    }
    /begin\{thm/||/begin\{prop/||/begin\{lemma/||/begin\{cor/||/begin\{axiom/||/begin\{law/||/begin\{proof/{
        printing = 1;
    }

    /end\{document/{
        printing = 1;
    }

    printing == 1 {
        print;
    }
    /section\{/{
        print;
    }
    /tableofcontents/{
        printing = 0;
    }

    /end\{thm/||/end\{prop/||/end\{lemma/||/end\{cor/||/end\{axiom/||/end\{law/||/end\{proof/{
        printing = 0;
    }"

    echo "compile ‘"`basename $var .tex`"_thm_proof.pdf’"
    awk "$parse" $var | sed 's/title{[a-zA-Z -]*/&\\\\ {\\Large Theorems with Proof}/;s/pdftitle={[a-zA-Z -]*/& (Theorems with Proof)/' | pdflatex > /dev/null
    awk "$parse" $var | sed 's/title{[a-zA-Z -]*/&\\\\ {\\Large Theorems with Proof}/;s/pdftitle={[a-zA-Z -]*/& (Theorems with Proof)/' | pdflatex > /dev/null
    mv texput.pdf `basename $var .tex`"_thm_proof.pdf"

    # Compile definitions
    parse="BEGIN{
        printing = 1;
    }
    /begin\{defi/{
        printing = 1;
    }

    /end\{document/{
        printing = 1;
    }

    printing == 1 {
        print;
    }
    /section\{/{
        print;
    }
    /tableofcontents/{
        printing = 0;
    }

    /end\{defi/{
        printing = 0;
    }"

    echo "compile ‘"`basename $var .tex`"_def.pdf’"
    awk "$parse" $var | sed 's/title{[a-zA-Z -]*/&\\\\ {\\Large Definitions}/;s/pdftitle={[a-zA-Z -]*/& (Definitions)/' | pdflatex > /dev/null
    awk "$parse" $var | sed 's/title{[a-zA-Z -]*/&\\\\ {\\Large Definitions}/;s/pdftitle={[a-zA-Z -]*/& (Definitions)/' | pdflatex > /dev/null
    mv texput.pdf `basename $var .tex`"_def.pdf"
done

rm -vf texput.*
rm -vf *~ *.log *.bbl *.blg *.toc *.aux \#*# *.out *.dvi
