#!/bin/bash
## Filename    : populate.sh
## Author      : n.shephard@sheffield.ac.uk
## Description : A Bash-script for generating analysis files from templates.
##               Much work is repetition, tables/graphs grouped by one variable, then
##               another, so templates are created and parsed from this script using
##               sed[1][2] to produce individual files for each grouing variable.
##               This eases work/maintenance as any change made to the *_template.Rmd
##               are then propogated to specific files by running this script and the
##               study specific outputs master RMarkdown files.
##
## Usage       : This script works under GNU/Linux.  If you are using M$-Win then
##               install and use Cygwin[3]
##
## [1] http://sed.sourceforge.net/
## [2] http://sed.sourceforge.net/sed1line.txt
## [3] https://cygwin.com/

## Analysis/Output : Cohort Tables
## Template        : ../sections/results_cohort/summary_template.Rmd
## Groups          : chemotherapy
##                   endocrine_therapy
##                   surgery
## Comment         : At present on Endocrine, Chemotherapy and Surgery are included, to
##                   add radiotherapy and trastuzumab in you will need to modify the template
##                   and add additional sed statements.
## EQ5D
sed -e 's/template1/chemotherapy/g'        summary_template.Rmd \
    -e 's/TEMPLATE1/Chemotherapy/g'      \
    -e 's/template2/surgery/g'           \
    -e 's/TEMPLATE2/Surgery/g'           \
    -e 's/template3/endocrine_therapy/g' \
    -e 's/TEMPLATE3/Endocrine therapy/g' \
    -e 's/outcome/eq5d/g'                > summary_eq5d.Rmd
## EORTC QLQ C30
sed -e 's/template1/chemotherapy/g'        summary_template.Rmd \
    -e 's/TEMPLATE1/Chemotherapy/g'      \
    -e 's/template2/surgery/g'           \
    -e 's/TEMPLATE2/Surgery/g'           \
    -e 's/template3/endocrine_therapy/g' \
    -e 's/TEMPLATE3/Endocrine therapy/g' \
    -e 's/outcome/eortc_qlq_c30/g'       > summary_eortc_qlq_c30.Rmd
## EORTC QLQ BR23
sed -e 's/template1/chemotherapy/g'        summary_template.Rmd \
    -e 's/TEMPLATE1/Chemotherapy/g'      \
    -e 's/template2/surgery/g'           \
    -e 's/TEMPLATE2/Surgery/g'           \
    -e 's/template3/endocrine_therapy/g' \
    -e 's/TEMPLATE3/Endocrine therapy/g' \
    -e 's/outcome/eortc_qlq_br23/g'      > summary_eortc_qlq_br23.Rmd
## EORTC QLQ ELD15
sed -e 's/template1/chemotherapy/g'        summary_template.Rmd \
    -e 's/TEMPLATE1/Chemotherapy/g'      \
    -e 's/template2/surgery/g'           \
    -e 's/TEMPLATE2/Surgery/g'           \
    -e 's/template3/endocrine_therapy/g' \
    -e 's/TEMPLATE3/Endocrine therapy/g' \
    -e 's/outcome/eortc_qlq_eld15/g'     > summary_eortc_qlq_eld15.Rmd
## Thearpy Assessment
sed -e 's/template1/chemotherapy/g'        summary_template.Rmd \
    -e 's/TEMPLATE1/Chemotherapy/g'      \
    -e 's/template2/surgery/g'           \
    -e 's/TEMPLATE2/Surgery/g'           \
    -e 's/template3/endocrine_therapy/g' \
    -e 's/TEMPLATE3/Endocrine therapy/g' \
    -e 's/outcome/therapy_assessment/g'  > summary_therapy_assessment.Rmd
## Endocrine Therapy
sed -e 's/template1/chemotherapy/g'        summary_template.Rmd \
    -e 's/TEMPLATE1/Chemotherapy/g'      \
    -e 's/template2/surgery/g'           \
    -e 's/TEMPLATE2/Surgery/g'           \
    -e 's/template3/endocrine_therapy/g' \
    -e 's/TEMPLATE3/Endocrine therapy/g' \
    -e 's/outcome/endocrine_therapy/g'   > summary_endocrine_therapy.Rmd
## Chemotherapy
sed -e 's/template1/chemotherapy/g'        summary_template.Rmd \
    -e 's/TEMPLATE1/Chemotherapy/g'      \
    -e 's/template2/surgery/g'           \
    -e 's/TEMPLATE2/Surgery/g'           \
    -e 's/template3/endocrine_therapy/g' \
    -e 's/TEMPLATE3/Endocrine therapy/g' \
    -e 's/outcome/chemotherapy/g'        > summary_chemotherapy.Rmd
## Radiotherapy
sed -e 's/template1/chemotherapy/g'        summary_template.Rmd \
    -e 's/TEMPLATE1/Chemotherapy/g'      \
    -e 's/template2/surgery/g'           \
    -e 's/TEMPLATE2/Surgery/g'           \
    -e 's/template3/endocrine_therapy/g' \
    -e 's/TEMPLATE3/Endocrine therapy/g' \
    -e 's/outcome/chemotherapy/g'        > summary_radiotherapy.Rmd
## Trastuzumab
sed -e 's/template1/chemotherapy/g'        summary_template.Rmd \
    -e 's/TEMPLATE1/Chemotherapy/g'      \
    -e 's/template2/surgery/g'           \
    -e 's/TEMPLATE2/Surgery/g'           \
    -e 's/template3/endocrine_therapy/g' \
    -e 's/TEMPLATE3/Endocrine therapy/g' \
    -e 's/outcome/trastuzumab/g'         > summary_trastuzumab.Rmd
## Surgery
sed -e 's/template1/chemotherapy/g'        summary_template.Rmd \
    -e 's/TEMPLATE1/Chemotherapy/g'      \
    -e 's/template2/surgery/g'           \
    -e 's/TEMPLATE2/Surgery/g'           \
    -e 's/template3/endocrine_therapy/g' \
    -e 's/TEMPLATE3/Endocrine therapy/g' \
    -e 's/outcome/surgery/g'             > summary_surgery.Rmd
## Clinical Assessment PET
sed -e 's/template1/chemotherapy/g'        summary_template.Rmd \
    -e 's/TEMPLATE1/Chemotherapy/g'      \
    -e 's/template2/surgery/g'           \
    -e 's/TEMPLATE2/Surgery/g'           \
    -e 's/template3/endocrine_therapy/g' \
    -e 's/TEMPLATE3/Endocrine therapy/g' \
    -e 's/outcome/clinical_assessment_pet/g' > summary_clinical_assessment_pet.Rmd
## Clinical Assessment Non-PET
sed -e 's/template1/chemotherapy/g'        summary_template.Rmd \
    -e 's/TEMPLATE1/Chemotherapy/g'      \
    -e 's/template2/surgery/g'           \
    -e 's/TEMPLATE2/Surgery/g'           \
    -e 's/template3/endocrine_therapy/g' \
    -e 's/TEMPLATE3/Endocrine therapy/g' \
    -e 's/outcome/clinical_assessment_non_pet/g' > summary_clinical_assessment_non_pet.Rmd
