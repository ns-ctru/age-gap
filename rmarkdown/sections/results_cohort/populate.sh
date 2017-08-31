#!/bin/bash
## Filename    : populate.sh
## Author      : n.shephard@sheffield.ac.uk
## Description : A Bash-script for generating analysis files from templates.
##               Eases work/maintenance as any change is made to the *_template.Rmd
##               and then propogated to specific files by running this script.
##               Much work is repetition, tables/graphs grouped by one variable, then
##               another, so templates are created and parsed from this script using
##               sed[1][2] to produce individual files for each grouing variable.
##
## Usage       : This script works under GNU/Linux.  If you are using M$-Win then
##               install and use Cygwin[2]
##
## [1] http://sed.sourceforge.net/
## [2] http://sed.sourceforge.net/sed1line.txt
## [3] https://cygwin.com/

## Analysis/Output : Cohort Tables
## Template        : ../sections/results_cohort/summary_template.Rmd
## Groups          : chemotherapy
##                   radiotherapy
##                   endocrine_therapy
##                   surgery
##                   trastuzumab
## Chemotherapy
sed -e 's/template/chemotherapy/g'        summary_template.Rmd \
    -e 's/TEMPLATE/Chemotherapy/g'      > summary_chemotherapy.Rmd
## Radiotherapy
sed -e 's/template/radiotherapy/g'        summary_template.Rmd \
    -e 's/TEMPLATE/Radiotherapy/g'      > summary_radiotherapy.Rmd
## Endocrine Therapy
sed -e 's/template/endocrine_therapy/g'   summary_template.Rmd \
    -e 's/TEMPLATE/Endocrine Therapy/g' > summary_endocrine_therapy.Rmd
## Surgery
sed -e 's/template/surgery/g'             summary_template.Rmd \
    -e 's/TEMPLATE/Surgery/g'           > summary_surgery.Rmd
## Trastuzumab
sed -e 's/template/trastuzumab/g'         summary_template.Rmd \
    -e 's/TEMPLATE/Trastuzumab/g'       > summary_trastuzumab.Rmd
