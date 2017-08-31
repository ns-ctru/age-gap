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
# Copy

## ToDo 2017-08-31 Put the above in a loop (over Surgery, Radiotherapy, Chemotherapy and Endocrine Therapy)
