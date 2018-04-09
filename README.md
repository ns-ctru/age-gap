[![minimal R version](https://img.shields.io/badge/R%3E%3D-3.4.0-brightgreen.svg)](https://cran.r-project.org/)[![ORCiD](https://img.shields.io/badge/ORCiD-0000--0001--8301--6857-green.svg)](https://orcid.org/0000-0001-8301-6857)

# Bridging the Age Gap in Breast Cancer: Improving outcomes for older women

This project contains an [R](https://www.r-project.org/) package for analysing and [RMarkdown](http://rmarkdown.rstudio.com/) code for reporting the results of the Randomised Control Trial (RCT) component of the [Bridging The Age Gap Study](https://www.shu.ac.uk/research/specialisms/centre-for-health-and-social-care-research/what-we-do/our-expertise/health-care-and-service-delivery-research/case-studies/bridging-the-age-gap-in-breast-cancer-research-improving-outcomes-for-older-women) which seeks to improve outcomes for older women who have breast cancer.

## Analyses

Detailed Statistical Analysis Plans are provided under `~/doc/sap` although it should be noted that this work focuses only on the Cohort component.  All work is conducted in-line with the principles of [reproducible research](https://en.wikipedia.org/wiki/Reproducibility#Reproducible_research) such that the files within this project allow the replication of the Statistical Report.  Work is version controlled (using [Git](http://www.git-scm.com/)) and hosted here on [Github](https://github.com/about/) to demonstrate the openness of the statistician to sharing work and critique.

### Data

Much of the work done here has been to establish a *work-flow* acknowledging that the final data set in terms of who is allocated to which Primary Treatment (variable : `primary_treatment`) group for their analysis and what their survival status is at a follow-up date are yet to be determined.  As such a few tweaks may be required to the data to ensure when classifications are finalised and survival data is available.  These changes should be made to the `lib/data-raw/import.R` file which reads in and combines the multitude of individual files, if the nomenclature used is maintained then minimal changes will need to be made to the documents in the `vignettes/` directory which produce the reports.

#### Primary Treatment Grouping

Primary Treatment Grouping (variable : `primary_treatment`) is derived using the rules defined in the function `agegap_encode()` this is an R file located at `lib/R/agegap_encode.R`.  It is called repeatedly because not everyone has any treatment recorded at six weeks follow-up so the six month data is then looked at, if that too is missing 12 month data and so on.  The code calling this function repeatedly can be found on lines 2265-2412 of the file `lib/data-raw/import.R` although these should not need modifying.  Additionally the relevant methods sections should be modified to reflect the new rules.  Currently this is only the `### Primary Treatment` section on lines 9-39 of `lib/vignettes/survival/methods.Rmd`.

#### Summaries at Follow-Up

A series of reports have been produced under the [vignettes](http://r-pkgs.had.co.nz/vignettes.html) structure available when writing/developing R packages.  However they are not defined as `output: html_vignette` because for some unfathomable reason they stalled on package `build()`.  Instead they need rendering individually, so from [RStudio](https://www.rstudio.com/) you should navigate so that your working directory is the `~/PR_Age_Gap/General/Statistics/lib/vignettes/` and then `render("[timepoint].Rmd")` to roduce the HTML report (replacing `[timepoint]` appropriately).  It was a deliberate design choice to include a report/summary for each time point as the tables and figures are extensive given the *huge* number of outcomes, questionnaires and questions involved.  With modern web-browsers allowing multiple tabs it is simple and straight-forward to have copies of each of these open and switch between tabs to compare results.

The underlying code that generates the reports can be found on the network drives at the following locations, there are three forms of each a `*.Rmd` version which is the source [RMarkdown](https://rmarkdown.rstudio.com/), and following the instructions below under [Software](#software) you can create PDF/HTML/docx reports under `~/PR_Age_Gap/General/Statistics/lib/inst/doc/` (currently only HTML are present as the author feels these are the most flexible and easiest to read/navigate).

| Outcomes   | Source                    | HTML Output               |
|:-----------|:--------------------------|:--------------------------|
| Baseline   | `~/PR_Age_Gap/General/Statistics/lib/vignettes/baseline.Rmd` | `~/PR_Age_Gap/General/Statistics/lib/inst/doc/baseline.html` |
| 6 Months   | `~/PR_Age_Gap/General/Statistics/lib/vignettes/6months.Rmd`  | `~/PR_Age_Gap/General/Statistics/lib/inst/doc/6months.html` |
| 12 Months  | `~/PR_Age_Gap/General/Statistics/lib/vignettes/12months.Rmd` | `~/PR_Age_Gap/General/Statistics/lib/inst/doc/12months.html` |
| 18 Months  | `~/PR_Age_Gap/General/Statistics/lib/vignettes/18months.Rmd` | `~/PR_Age_Gap/General/Statistics/lib/inst/doc/18months.html` |
| 24 Months  | `~/PR_Age_Gap/General/Statistics/lib/vignettes/24months.Rmd` | `~/PR_Age_Gap/General/Statistics/lib/inst/doc/6months.html` |
| Adverse Events | `~/PR_Age_Gap/General/Statistics/lib/vignettes/adverse_events.Rmd` | `~/PR_Age_Gap/General/Statistics/lib/inst_doc/adverse_events.html` |

**NB** The survival report is far from complete, mainly because the required data was not available and other responsibilities such as handover of this and other projects precluded spending time developing the workflow with dummy variables.

Each document listed above is a "master" file and includes a number of child documents from the associated directory of the same name (i.e. `baseline.Rmd` includes child documents from the `baseline` sub-directory), these take a common structure and so a scripted approach to automating the updating of these child documents has been taken and how to update them is described below.

It is recommended that you also read the [`lib/README.md`](https://github.com/ns-ctru/age-gap/lib/) that accompanies the R package in the `lib` sub-directory as it contains a lot of additional information on how these reports are generated,  and how to update them and details of deriving survival.
