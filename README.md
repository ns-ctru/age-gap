[![minimal R version](https://img.shields.io/badge/R%3E%3D-3.4.0-brightgreen.svg)](https://cran.r-project.org/)[![ORCiD](https://img.shields.io/badge/ORCiD-0000--0001--8301--6857-green.svg)](https://orcid.org/0000-0001-8301-6857)

# Bridging the Age Gap in Breast Cancer: Improving outcomes for older women

This project contains an [R](https://www.r-project.org/) for analysing and reporting the results of the Randomised Control Trial (RCT) component of the [Bridging The Age Gap Study](https://www.shu.ac.uk/research/specialisms/centre-for-health-and-social-care-research/what-we-do/our-expertise/health-care-and-service-delivery-research/case-studies/bridging-the-age-gap-in-breast-cancer-research-improving-outcomes-for-older-women) which seeks to improve outcomes for older women who have breast cancer.

## Analyses

Detailed Statistical Analysis Plans are provided under `~/doc/sap` although it should be noted that this work focuses only on the Cohort component.  All work is conducted in-line with the principles of [reproducible research](https://en.wikipedia.org/wiki/Reproducibility#Reproducible_research) such that the files within this project allow the replication of the Statistical Report.  Work is version controlled (using [Git](http://www.git-scm.com/)) and hosted here on [Github](https://github.com/about/) to demonstrate the openness of the statistician to sharing work and critique.

### Software

All analyses are performed using the statistical programming language [R](https://www.r-project.org/) and a number of additional packages from the [Comprehensive R Archive Network (CRAN)](https://cran.r-project.org/) (details of which can be found in the `~/lib/DESCRIPTION` file for the project specific R package).  To facilitate with the reproducibility of this work the data and code specific to the project have been combined into an R-package and the non-sensitive components (i.e. the R code) is [hosted on GitHub](https://github.com/ns-ctru/age-gap) (for privacy no data is included in the GitHub repository, you will have to obtain that from the network drives).  It depends on another R package written by [Neil Shephard](https://github.com/ns-ctru/) which aims to abstract many of the common and repetitive tasks that are required across all studies called [`ctru`](https://github.com/ns-ctru/ctru) and this is a dependency of the `age-gap` package.  To install the dependency on your computer use the following...

    install.packages(devtools)
	install_github('ns-ctru/ctru')

You can now clone the study repository which includes all of the code for producing the reports....

    git clone git@github.com/ns-ctru/age-gap

You will then need to obtain the raw data from the studies project folder and add it to the `lib/data-raw/` directory and run the `lib/data-raw/import.R` file in order to read and clean the data.
