#!/bin/bash
#
# Author       : n.shephard@sheffield.ac.uk
# Description  : The Age Gap study has multiple outcomes that are to be analysed and reported in an identical
#                manner, to which end a set of templates are used as a basis for each analyses.

#########################################################################
## Surgery                                                             ##
#########################################################################
# Copy master.Rmd
sed -e 's/OUTCOMETEXT/Surgery/g' template/master.Rmd \
    -e 's/OUTCOMELOWER/surgery/g' > surgery/surgery.Rmd
# Copy overview.Rmd
sed -e 's/OUTCOMETEXT/Surgery/g' template/sections/overview.Rmd > surgery/sections/overview.Rmd
# Copy analysis.Rmd
sed -e 's/OUTCOME/surgery/g' template/sections/analysis.Rmd > surgery/sections/analysis.Rmd
# Copy results.Rmd
sed -e 's/OUTCOMETEXT/Surgery/g' template/sections/results.Rmd \
    -e 's/OUTCOMELOWER/surgery/g' > surgery/sections/results.Rmd

## ToDo 2017-08-31 Put the above in a loop (over Surgery, Radiotherapy, Chemotherapy and Endocrine Therapy)
for i in $( 'surgery' 'chemotherapy' 'radiotherapy' 'endocrine' ); do
    # Conditionally set the text and lower
    if [ "$i" == "endocrine" ]; then
	text    = "Endocrine Therapy"
	lower   = "endocrine therapy"
	outcome = "endocrine_therapy"
    elif [ "$i" == "surgery"]; then
	text    = "Surgery"
	lower   = "surgery"
	outcome = $lower
    elif [ "$i" == "chemotherapy"]; then
	text    = "Chemotherapy"
	lower   = "chemotherapy"
	outcome = $lower
    elif [ "$i" == "radiotherapy"]; then
	text    = "Radiotherapy"
	lower   = "radiotherapy"
	outcome = $lower
    fi
    # Generate files...
    # master.Rmd
    sed -e 's/OUTCOMETEXT/$text/g'     template/master.Rmd \
	-e 's/OUTCOMELOWER/$lower/g' > $i/surgery.Rmd
    # overview.Rmd
    sed -e 's/OUTCOMETEXT/$text/g'     template/sections/overview.Rmd > $i/sections/overview.Rmd
    # analysis.Rmd
    sed -e 's/OUTCOME/$lower/g'   template/sections/analysis.Rmd > $i/sections/analysis.Rmd
    # results.Rmd
    sed -e 's/OUTCOMETEXT/$text/g'     template/sections/results.Rmd \
	-e 's/OUTCOMELOWER/$lower/g' > $i/sections/results.Rmd
done
