# Overview

This is an [R](https://www.r-project.org) package that has been developed for the [Bridging the Age Gap](https://www.sheffield.ac.uk/oncology-metabolism/research/surgicaloncology/research/agegap) study.  It aims to follow the guidelines and practices set out in the book [R Packages by Hadley Wickham](http://r-pkgs.had.co.nz/).  A lot of the code required for reading and summarising data has been abstracted since the tasks are common to all studies conducted within [Sheffield Clinical Trials Research Unit](https://www.sheffield.ac.uk/scharr/sections/dts/ctru) and so a major dependency of the `age-gap` package you are currently browsing is the [ctru](https://github.com/ns-ctru/ctru) package developed by the original author of the work you are reading ([Neil Shephard](mailto:n.shephard@sheffield.ac.uk) who left CTRU mid-April 2018 see [ns-ctru GitHub](https://github.com/ns-ctru) for other work).

The main body of work within this project are therefore the [vignettes](vignettes/) which produce HTML (or if desired PDF and/or Word documents) which summarise the work and analyses required for the study.

## Generating Reports

As mentioned all analyses are performed using the statistical programming language [R](https://www.r-project.org/) and a number of additional packages from the [Comprehensive R Archive Network (CRAN)](https://cran.r-project.org/) (details of which can be found in the `DESCRIPTION` file for the project specific R package).  To facilitate with the reproducibility of this work the data and code specific to the project have been combined into an R-package and the non-sensitive components (i.e. the R code) is [hosted on GitHub](https://github.com/ns-ctru/age-gap) (for privacy no data is included in the GitHub repository, you will have to obtain that from the network drives).  It depends on another R package written by [Neil Shephard](https://github.com/ns-ctru/) which aims to abstract many of the common and repetitive tasks that are required across all studies called [`ctru`](https://github.com/ns-ctru/ctru) and this is a dependency of the `age-gap` package.  To install the dependency on your computer use the following...

    install.packages(devtools)
	install_github('ns-ctru/ctru')

You can now clone the study repository which includes all of the code for producing the reports....

    git clone git@github.com/ns-ctru/age-gap


You will then need to obtain the raw data from the studies project folder and add it to the `lib/data-raw/` directory and run the `lib/data-raw/import.R` file in order to read and clean the data.  Once this has been done you can use the [devtools](https://cran.r-project.org/web/packages/devtools/index.html) package to...

    document()
	build(vignettes = FALSE)
	install()

...the package using the following (since Vignettes consistently fail to build and need to be built seperately).

### Vignettes

Reports have been produced under the [vignettes](http://r-pkgs.had.co.nz/vignettes.html) structure available when writing/developing R packages.  This has the advantage that reports should be rendered/compiled automatically when building the `age-gap` package (although currently my experience is that they do not).  It was a deliberate design choice to include a report/summary for each time point as the tables and figures are extensive given the *huge* number of outcomes, questionnaires and questions involved.  With modern web-browsers allowing multiple tabs it is simple and straight-forward to have copies of each of these open and switch between tabs to compare results.

The following code can be used (it could even be placed in an R script file which could be [`source()`](https://www.rdocumentation.org/packages/base/versions/3.4.3/topics/source) or run using [`Rscript`](https://www.rdocumentation.org/packages/utils/versions/3.4.3/topics/Rscript))



	setwd('/path/to/cloned/age-gap/lib')
	## To make a HTML copy of each of the reports
	setwd('/path/to/cloned/age-gap/lib/vignettes')
	rmarkdown::render("baseline.Rmd",
	                  output_format = "html_document",
					  output_file   = "../inst/doc/baseline.html")
	rmarkdown::render("6weeks.Rmd",
	                  output_format = "html_document",
					  output_file   = "../inst/doc/6weeks.html")
	rmarkdown::render("6months.Rmd",
	                  output_format = "html_document",
					  output_file   = "../inst/doc/6months.html")
	rmarkdown::render("12months.Rmd",
	                  output_format = "html_document",
					  output_file   = "../inst/doc/12months.html")
	rmarkdown::render("18months.Rmd",
	                  output_format = "html_document",
					  output_file   = "../inst/doc/18months.html")
	rmarkdown::render("24months.Rmd",
	                  output_format = "html_document",
					  output_file   = "../inst/doc/24months.html")
	rmarkdown::render("adverse_events.Rmd",
	                  output_format = "html_document",
					  output_file   = "../inst/doc/adverse_events.html")
	rmarkdown::render("survival.Rmd",
	                  output_format = "html_document",
					  output_file   = "../inst/doc/survival.html")
	## To make a PDF copy of each of the reports
	setwd('/path/to/cloned/age-gap/lib/vignettes')
	rmarkdown::render("baseline.Rmd",
	                  output_format = "pdf_document",
					  output_file   = "../inst/doc/baseline.pdf")
	rmarkdown::render("6weeks.Rmd",
	                  output_format = "pdf_document",
					  output_file   = "../inst/doc/6weeks.pdf")
	rmarkdown::render("6months.Rmd",
	                  output_format = "pdf_document",
					  output_file   = "../inst/doc/6months.pdf")
	rmarkdown::render("12months.Rmd",
	                  output_format = "pdf_document",
					  output_file   = "../inst/doc/12months.pdf")
	rmarkdown::render("18months.Rmd",
	                  output_format = "pdf_document",
					  output_file   = "../inst/doc/18months.pdf")
	rmarkdown::render("24months.Rmd",
	                  output_format = "pdf_document",
					  output_file   = "../inst/doc/24months.pdf")
	rmarkdown::render("adverse_events.Rmd",
	                  output_format = "pdf_document",
					  output_file   = "../inst/doc/adverse_events.pdf")
    rmarkdown::render("survival.Rmd",
	                  output_format = "pdf_document",
					  output_file   = "../inst/doc/survival.pdf")
	## To make a M$-Word copy of the report
	setwd('/path/to/cloned/age-gap/lib/vignettes')
	rmarkdown::render("baseline.Rmd",
	                  output_format = "word_document",
					  output_file   = "../inst/doc/baseline.docx")
	rmarkdown::render("6weeks.Rmd",
	                  output_format = "word_document",
					  output_file   = "../inst/doc/6weeks.docx")
	rmarkdown::render("6months.Rmd",
	                  output_format = "word_document",
					  output_file   = "../inst/doc/6months.docx")
	rmarkdown::render("12months.Rmd",
	                  output_format = "word_document",
					  output_file   = "../inst/doc/12months.docx")
	rmarkdown::render("18months.Rmd",
	                  output_format = "word_document",
					  output_file   = "../inst/doc/18months.docx")
	rmarkdown::render("24months.Rmd",
	                  output_format = "word_document",
					  output_file   = "../inst/doc/24months.docx")
	rmarkdown::render("adverse_events.Rmd",
	                  output_format = "word_document",
					  output_file   = "../inst/doc/adverse_events.docx")
    rmarkdown::render("survival.Rmd",
	                  output_format = "word_document",
					  output_file   = "../inst/doc/survival.docx")



##### How to update

Because summarising at different follow-ups is an exercise in [iteration](https://en.wikipedia.org/wiki/Iteration) a programmatic approach has been taken whereby the code is written once for *baseline* outcomes and the code is then re-used for each subsequent follow-up time-point by using simple command line tools (['sed'](https://en.wikipedia.org/wiki/Sed)) called from a [Bash shell script](https://en.wikipedia.org/wiki/Bash_(Unix_shell)) (`lib/vignettes/populate.sh`) that derives the files for subsequent follow-up.  Thus in order to add new summaries simply modify the files under `lib/vignettes/baseline/results.Rmd` and `lib/vignettes/baseline/results/baseline.Rmd` and re-run the `lib/vignettes/populate.sh` script and they will be propogated to all subsequent follow-ups.  To do this you need access to a Bash shell.  If you are not using a GNU/Linux operating system but are instead using a M$-Windows variant then you can install the [Cygwin Shell](https://cygwin.com/) and running the `lib/vignettes/populate.sh` script under Cygwin will work.  Just navigate to `lib/vignettes/populate.sh` in the shell and type...

    ./populate.sh

...and the files under `6weeks`, `6months`, `12months`, `18months` and `24months` will be updated.


### Dependencies

This project makes use of some convenience packages/functions that are not hosted on [CRAN](https://cran.r-project.org/) but are instead developed and maintained on users [GitHub](https://github.com/) accounts.  If a function can not be installed from CRAN on installing the ''age-gap'' package then you must install them via GitHub using the `[devtools](https://cran.r-project.org/web/packages/devtools/)` function `install_github()`.  These dependencies are listed below along with a description and the command to install them (although it should be fairly obvious how this command is derived based on the URL of the packages hosting on GitHub)...

| Package                | Description               | Instal command |
|:-----------------------|:--------------------------|:---------------|
| ''[ggkm](https://github.com/sachsmc/ggkm)'' | Simplifies drawing [Kaplan-Meir survival curves](https://en.wikipedia.org/wiki/Kaplan%E2%80%93Meier_estimator) using [ggplot](http://ggplot2.tidyverse.org/reference/) | `install_github("sachsmc/ggkm")` |
