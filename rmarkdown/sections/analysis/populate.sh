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
## Template        : ../sections/analysis/cohort_table_template.Rmd
## Groups          : chemotherapy
##                   radiotherapy
##                   endocrine_therapy
##                   surgery
##                   trastuzumab
## Chemotherapy
sed -e 's/template/chemotherapy/g'      cohort_table_template.Rmd > cohort_table_chemotherapy.Rmd
## Radiotherapy
sed -e 's/template/radiotherapy/g'      cohort_table_template.Rmd > cohort_table_radiotherapy.Rmd
## Endocrine Therapy
sed -e 's/template/endocrine_therapy/g' cohort_table_template.Rmd > cohort_table_endocrine_therapy.Rmd
## Surgery
sed -e 's/template/surgery/g'           cohort_table_template.Rmd > cohort_table_surgery.Rmd
## Trastuzumab
sed -e 's/template/trastuzumab/g'       cohort_table_template.Rmd > cohort_table_trastuzumab.Rmd


## Analysis/Output : Cohort Plots
## Template        : ../sections/analysis/cohort_table_template.Rmd
## Groups          : chemotherapy
##                   radiotherapy
##                   endocrine_therapy
##                   surgery
##                   trastuzumab
## Chemotherapy
sed -e 's/template/chemotherapy/g'      cohort_plot_template.Rmd > cohort_plot_chemotherapy.Rmd
## Radiotherapy
sed -e 's/template/radiotherapy/g'      cohort_plot_template.Rmd > cohort_plot_radiotherapy.Rmd
## Endocrine Therapy
sed -e 's/template/endocrine_therapy/g' cohort_plot_template.Rmd > cohort_plot_endocrine_therapy.Rmd
## Surgery
sed -e 's/template/surgery/g'           cohort_plot_template.Rmd > cohort_plot_surgery.Rmd
## Trastuzumab
sed -e 's/template/trastuzumab/g'       cohort_plot_template.Rmd > cohort_plot_trastuzumab.Rmd
