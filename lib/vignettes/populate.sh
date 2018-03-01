#!/bin/bash

# Populate results.Rmd for each vignette
sed -e 's/baseline/6weeks/g'   baseline/results.Rmd > 6weeks/results.Rmd
sed -e 's/baseline/6months/g'  baseline/results.Rmd > 6months/results.Rmd
sed -e 's/baseline/12months/g' baseline/results.Rmd > 12months/results.Rmd
sed -e 's/baseline/18months/g' baseline/results.Rmd > 18months/results.Rmd
sed -e 's/baseline/24months/g' baseline/results.Rmd > 24months/results.Rmd
