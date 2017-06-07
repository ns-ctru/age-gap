#' Labelling of variables in the Bridging The Age Gap Study
#'
#' @description Label variables with human readable descriptions
#'
#' @details
#'
#' Variable names and factor levels are often not quite the format required for
#' human readable tables/figures.  This function ameliorates the burdensome task
#' of labelling regression model outputs and axis labels by taking the
#' \code{master$lookups} for the project and using it to derive meaningful,
#' human readable labels.
#'
#' The \code{Lookups.csv} that is exported from Prospect should have already been
#' read into an R data frame using \code{read_prospect()} from the \code{ctru}
#' package.
#'
#'
#' @param lookups The \code{Lookups.csv} file as an R data frame.
#' @param df Data frame to label, this might be a user generated tabulation, or tidy regression results produced by \code{broom}.
#'
#' @export
label <- function(lookups         = lookups,
                  df              = .data,
                  ...){
}
