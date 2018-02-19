#!/bin/bash
##
## Created          2018-02-19
## Author           n.shephard@sheffield.ac.uk
## Description      Derive follow-up specific summaries based on 'results/baseline.Rmd'
##
## Notes            Two substitutions are required, one to change the text that is used
##                  to subset the data (the first substitution) and a second to change
##                  the chunk names (as Rmarkdown does not allow duplicated chunk names).
## 6 week follow-up
sed -e 's/Baseline/6 weeks/g' results/baseline.Rmd \
    -e 's/baseline_/6weeks_/g' > appendix/6weeks.Rmd

## 6 month follow-up
sed -e 's/Baseline/6 months/g' results/baseline.Rmd \
    -e 's/baseline_/6months_/g' > appendix/6months.Rmd

## 12 month follow-up
sed -e 's/Baseline/12 months/g' results/baseline.Rmd  \
    -e 's/baseline_/12months_/g' > appendix/12months.Rmd

## 18 month follow-up
sed -e 's/Baseline/18 months/g' results/baseline.Rmd  \
    -e 's/baseline_/18months_/g' >  appendix/18months.Rmd

## 24 month follow-up
sed -e 's/Baseline/24 months/g' results/baseline.Rmd  \
    -e 's/baseline_/24months_/g' > appendix/24months.Rmd
