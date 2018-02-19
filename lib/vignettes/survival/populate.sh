#!/bin/bash
##
## Created          2018-02-19
## Author           n.shephard@sheffield.ac.uk
## Description      Derive follow-up specific summaries based on 'results/baseline.Rmd'

## 6 week follow-up
sed 's/Baseline/6 weeks/g' results/baseline.Rmd > appendix/6weeks.Rmd

## 6 month follow-up
sed 's/Baseline/6 months/g' results/baseline.Rmd > appendix/6months.Rmd

## 12 month follow-up
sed 's/Baseline/12 months/g' results/baseline.Rmd > appendix/12months.Rmd

## 18 month follow-up
sed 's/Baseline/18 months/g' results/baseline.Rmd > appendix/18months.Rmd

## 24 month follow-up
sed 's/Baseline/24 months/g' results/baseline.Rmd > appendix/24months.Rmd
