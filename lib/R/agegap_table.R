#' Summary tables for Bridging The Age Gap study
#'
#' @description Generate tables of various characteristics specific to
#' follow-up time points
#'
#' @details The Bridging The Age Gap study seeks to investigate the
#' characteristics of older women with breast cancer and the treatments
#' they receive.  There are multiple follow-up time points though so
#' summarising the 'baseline' demographics depends on the follow-up
#' time point that is being considered.  This function provides the
#' flexibility to specify the follow-up time point and returns summary
#' tables based on that.
#'
#' @param df Data frame of data (default is \code{age_gap} shouldn't need changing).
#' @param follow_up Follow-up time point to be considered, options are \code{6 weeks} | \code{6 months} | \code{12 months} | \code{18 months} | \code{24 months}.
#' @param treatment Variable defining treatment classification of interest, currently this is one of \code{chemotherapy} | \code{radiotherapy} | \code{endocrine_therapy} | \code{surgery} | \code{trasuzumab} as recorded, but these doo not account for treatment received prior to previous contact so new variables will need deriving reflecting this.
#' @param treatment_missing How to handle individuals with missing treatment, options are \code{'exclude'} to exclude such individuals and \code{'none'} to group such individuals with those who explicitly have no treatment recorded.
#' @param include_eortc_c30 Logical of whether to include EORTC Quality of Life C30 scores (including individual domains).  Default is \code{TRUE}.
#' @param include_eortc_br23 Logical of whether to include EORTC Quality of Life BR23 scores (including individual domains).  Default is \code{TRUE}.
#' @param include_eortc_eld15 Logical of whether to include EORTC Quality of Life ELD15 scores (including individual domains).  Default is \code{TRUE}.
#'
#'
#' @return A list of results including a table.
#'
#' @examples
#'
#' ## Run mortality analyses for Bishop Auckland and its matched site
#' ## producing time-series plot, step and dose models using both the
#' ## panelAR and prais package.
#'
#'
#'
#' @references
#'
#' @export
agegap_table <- function(df                  = age_gap,
                         follow_up           = '6 weeks',
                         treatment           = chemotherapy,
                         treatment_missing   = 'exclude',
                         include_demog       = TRUE,
                         include_eortc_c30   = TRUE,
                         include_eortc_br23  = TRUE,
                         include_eortc_eld15 = TRUE,
                         include_eq5d        = TRUE,
                         include_charlson    = TRUE,
                         include_mmse        = TRUE,
                         ...){
    ## List for returning
    results <- list()
    ## Quote things
    quo_treatment <- enquo(treatment)
    ## Set variables to be summarised conditional on supplied options
    if(include_demog == TRUE){
        quo_demog <- quos(age, ethnicity)
        }
    if(include_eortc_c30 == TRUE){
        quo_eortc_qol_c30 <- quos(ql_raw, ql_scale,
                                  pf_raw, pf_scale,
                                  rf_raw, rf_scale,
                                  ef_raw, ef_scale,
                                  cf_raw, cf_scale,
                                  sf_raw, sf_scale,
                                  fa_raw, fa_scale,
                                  nv_raw, nv_scale,
                                  pa_raw, pa_scale,
                                  dy_scale, sl_scale,
                                  ap_scale, co_scale,
                                  di_scale, fi_scale)
    }
    if(include_eortc_br23){
        quo_eortc_qol_br23 <- quos(brbi_raw, brbi_scale,
                                   brsef_raw, brsef_scale,
                                   brsee_scale,
                                   brfu_scale,
                                   brst_raw, brst_scale,
                                   brbs_raw, brbs_scale,
                                   bras_raw, bras_scale,
                                   brhl_scale)
    }
    if(include_eortc_eld15){
        quo_eortc_qol_eld15 <- quos(eq5d_score)
    }
    if(include_eq5d){
        quo_eq5d <- quos(eq5d_number, eq5d_score)
    }
    if(include_charlson){
        quo_charlson <- quos(cci_score)
    }
    if(include_mmse){
        quo_mmse <- quos(mmse_score)
    }
    ## Filter data based on specified follow-up
    df <- df %>%
          dplyr::filter(event_name %in% c('Baseline', follow_up)) %>%
          ## Select variables to summarise
          dplyr::select(individual_id, event_name,
                        ## Desired treatment
                        !!quo_treatment,
                        !!!quo_eortc_qol_c30,
                        !!!quo_eortc_qol_br23,
                        !!!quo_eortc_qol_eld15,
                        !!!quo_eq5d,
                        !!!quo_charlson,
                        !!!quo_mmse)
    ## Gather the data into long format for summarising
    df <- df %>%
        gather(key   = key,
               value = value,
               -individual_id, -event_name, -!!quo_treatment)
    ## Deal with missing treatmet
    if(treatment_missing == 'exclude'){
        df <- df %>%
              dplyr::filter(!is.na(!!quo_treatment))
    }
    ## ToDo - tidyeval NSE to replace NA to 'No'
    else if(treatment_missing == 'none'){
        df <- df ## %>%
              ## dplyr::mutate(treatment = as.character(!!quo_treatment),
              ##               treatment = ifelse(is.na(treatment),
              ##                                  yes = 'No',
              ##                                  no  = treatment)) %>%
            ## dplyr::select(-!!quo_treatment)
            ## dplyr::mutate(quo_name(quo_treatment) = ifelse(is.na(!!quo_treatment),
            ##                                                yes = 'No',
            ##                                                no  = as.characater(!!quo_treatment)))
        ## if(quo_treatment == 'chemotherapy')      names(df) <- gsub('treatment', 'chemotherapy', names(df))
        ## else if(!!quo_treatment == 'radiotherapy') names(df) <- gsub('treatment', 'radiotherapy', names(df))
        ## else print('No matches!?!?')
    }
    df %>% names() %>% print()
    df %>% head() %>% print()
    results$df <- df
    ####################################################################
    ## Summarise and tabulate categorical variables                   ##
    ####################################################################
    df_cat <- df %>%
              dplyr::select(individual_id, event_name, !!quo_treatment,
                            ethnicity)
    ####################################################################
    ## Summarise and tabulate continuous variables                    ##
    ####################################################################
    df_cont <- df %>%
               dplyr::select(individual_id, event_name, !!quo_treatment,
                             age,
                             !!!quo_eortc_qol_c30,
                             !!!quo_eortc_qol_br23,
                             !!!quo_eortc_qol_eld15)
    return(results)
}
