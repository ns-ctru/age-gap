[![minimal R version](https://img.shields.io/badge/R%3E%3D-3.4.0-brightgreen.svg)](https://cran.r-project.org/)[![ORCiD](https://img.shields.io/badge/ORCiD-0000--0001--8301--6857-green.svg)](https://orcid.org/0000-0001-8301-6857)

# Bridging the Age Gap in Breast Cancer: Improving outcomes for older women

This project contains an [R](https://www.r-project.org/) package for analysing and [RMarkdown](http://rmarkdown.rstudio.com/) code for reporting the results of the Randomised Control Trial (RCT) component of the [Bridging The Age Gap Study](https://www.shu.ac.uk/research/specialisms/centre-for-health-and-social-care-research/what-we-do/our-expertise/health-care-and-service-delivery-research/case-studies/bridging-the-age-gap-in-breast-cancer-research-improving-outcomes-for-older-women) which seeks to improve outcomes for older women who have breast cancer.

## Analyses

Detailed Statistical Analysis Plans are provided under `~/doc/sap` although it should be noted that this work focuses only on the Cohort component.  All work is conducted in-line with the principles of [reproducible research](https://en.wikipedia.org/wiki/Reproducibility#Reproducible_research) such that the files within this project allow the replication of the Statistical Report.  Work is version controlled (using [Git](http://www.git-scm.com/)) and hosted here on [Github](https://github.com/about/) to demonstrate the openness of the statistician to sharing work and critique.

### Data

Much of the work done here has been to establish a *work-flow* acknowledging that the final data set in terms of who is allocated to which Primary Treatment (variable : `primary_treatment`) group for their analysis and what their survival status is at a follow-up date are yet to be determined.  As such a few tweaks may be required to the data to ensure when classifications are finalised and survival data is available.  These changes should be made to the `lib/data-raw/import.R` file which reads in and combines the multitude of individual files, if the nomenclature used is maintained then minimal changes will need to be made to the documents in the `vignettes/` directory which produce the reports.

#### Primary Treatment Grouping

Primary Treatment Grouping (variable : `primary_treatment`) is derived using the rules defined in the function `agegap_encode()` this is an R file located at `lib/R/agegap_encode.R`.  It is called repeatedly because not everyone has any treatment recorded at six weeks follow-up so the six month data is then looked at, if that too is missing 12 month data and so on.  The code calling this function repeatedly can be found on lines 2265-2412 of the file `lib/data-raw/import.R` although these should not need modifying.  Additionally the relevant methods sections should be modified to reflect the new rules.  Currently this is only the `### Primary Treatment` section on lines 9-39 of `lib/vignettes/survival/methods.Rmd`.

#### Survival

At the time of writing the primary outcome, five year survival, was not available.  In order to establish a workflow the data from the *Study Completion and Discontinuation* Case Report Form was used, specifically the fields `study_completion_dt`, `disc_death_dt`, `disc_rsn`, `death_cause_1`, `death_cause_2` and `death_cause_3` (refer to the [database specification for descriptions](https://docs.google.com/spreadsheets/d/1mi2BsSIDHnslnxtbm1tCUdvt-uJ883iEHO0QOt0wig8/edit#gid=0)).  The code for merging this with the main data can be found under `lib/data-raw/import.R` on lines 1625-1634 where a `[left_join()](https://www.rdocumentation.org/packages/dplyr/versions/0.7.3/topics/join)` is done to the data frame that results from the preceeding `[full_join()](https://www.rdocumentation.org/packages/dplyr/versions/0.7.3/topics/join)`.  Its quite possible that the survival data will come from a new file derived externally to Prospect.  In this case you will have to write code to read in the file (likely in CSV format), tidy it up and then replace the afforementioned lines with code to bind the key variables with the previous files based on the variables `individual_id` and `site`.

### Software

All analyses are performed using the statistical programming language [R](https://www.r-project.org/) and a number of additional packages from the [Comprehensive R Archive Network (CRAN)](https://cran.r-project.org/) (details of which can be found in the `~/lib/DESCRIPTION` file for the project specific R package).  To facilitate with the reproducibility of this work the data and code specific to the project have been combined into an R-package and the non-sensitive components (i.e. the R code) is [hosted on GitHub](https://github.com/ns-ctru/age-gap) (for privacy no data is included in the GitHub repository, you will have to obtain that from the network drives).  It depends on another R package written by [Neil Shephard](https://github.com/ns-ctru/) which aims to abstract many of the common and repetitive tasks that are required across all studies called [`ctru`](https://github.com/ns-ctru/ctru) and this is a dependency of the `age-gap` package.  To install the dependency on your computer use the following...

    install.packages(devtools)
	install_github('ns-ctru/ctru')

You can now clone the study repository which includes all of the code for producing the reports....

    git clone git@github.com/ns-ctru/age-gap

You will then need to obtain the raw data from the studies project folder and add it to the `lib/data-raw/` directory and run the `lib/data-raw/import.R` file in order to read and clean the data.  Once this has been done you can use the [devtools](https://cran.r-project.org/web/packages/devtools/index.html) package to `document()`, `build()` and `install()` the package using the following (since Vignettes consistently fail to build and need to be built seperately).

	setwd('/path/to/cloned/age-gap/lib')
	devtools::document()
	devtools::build(vignettes = FALSE)
	devtools::install()
	devtools::build_vignettes()


#### Dependencies

This project makes use of some convenience packages/functions that are not hosted on [CRAN](https://cran.r-project.org/) but are instead developed and maintained on users [GitHub](https://github.com/) accounts.  If a function can not be installed from CRAN on installing the ''age-gap'' package then you must install them via GitHub using the `[devtools](https://cran.r-project.org/web/packages/devtools/)` function `install_github()`.  These dependencies are listed below along with a description and the command to install them (although it should be fairly obvious how this command is derived based on the URL of the packages hosting on GitHub)...

| Package                | Description               | Instal command |
|:-----------------------|:--------------------------|:---------------|
| ''[ggkm](https://github.com/sachsmc/ggkm)'' | Simplifies drawing [Kaplan-Meir survival curves](https://en.wikipedia.org/wiki/Kaplan%E2%80%93Meier_estimator) using [ggplot](http://ggplot2.tidyverse.org/reference/) | `install_github("sachsmc/ggkm")` |
