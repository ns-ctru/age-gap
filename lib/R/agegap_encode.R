#' Derive Primary Treatment for a given event
#'
#' @description Derive Primary Treatment for a given event based on recorded treatments
#'
#' @details
#'
#' Its impossible to derive the primary treatment individuals have received based on
#' the recorded data as only Surgery as a date recorded against it and none of the other
#' treatment possibilities (\code{Primary Endocrine}, \code{Adjuvant}, \code{Neo-Adjuvant
#' Endocrine}, \code{Chemotherapy}, \code{Radiotherapy} or \code{Trastuzumab}) have dates
#' of treatment recorded against them, rather the date of assessment is recorded.
#'
#' This presents a significant problem given the analyses required for the study require
#' dividing people into groups baed on their primary treatment.
#'
#' This function is can be used (iteratively) to derive a primary treatment allocation
#' based on information about the possible treatment pathways provided by the Chief
#' Investigator Lynda Wyld.  It applies the following algorithm...
#'
#' \code{IF endocrine_therapy == 'Yes' AND primary_adjuvant == 'Primary'  THEN 'Primary Endocrine'}
#' \code{ELSE IF endocrine_therapy == 'Yes' AND primary_adjuvant == 'Adjuvant' THEN 'Adjuvant Endocrine'}
#' \code{ELSE IF surgery == 'Yes' AND primary_adjuvant == 'Adjuvant' THEN 'Surgery'}
#' \code{ELSE IF surgery == 'Yes' AND primary_adjuvant == 'Neoddjuvant' THEN 'Surgery'}
#' \code{ELSE IF surgery == 'Yes' AND primary_adjuvant == '' THEN 'Surgery'}
#' \code{ELSE IF endocrine_therapy == 'No' AND surgery == 'No' AND chemotherapy == 'Yes' THEN 'Chemotherapy'}
#' \code{ELSE IF endocrine_therapy == 'No' AND surgery == 'No' AND chemotherapy == 'No' AND radiotherapy == 'Yes' THEN 'Radiotherapy'}
#' #' \code{ELSE IF trastuzumab == 'Yes' THEN 'Radiotherapy'}
#'
#' Because of the way logic is implemented in computer software the first condition that is
#' met defines an individuals primary treatment allocation.
#'
#' This function should be applied itteratively to the data for each of the follow-up time
#' points, because not all individuals have received a treatment by the first follow-up at
#' six-weeks and therefore the treatments recorded at six months need to be used.  A smaller
#' set do not have any treatment recorded at six months and so their 12 month follow-up data
#' needs to be considered and so on.
#'
#' This still leaves some individuals for whom the primary treatment can not be determined
#' from the above rules.  Such instances are being reviewed by the Cheif Invesitagtor who
#' will define their allocation.
#'
#' @export
agegap_encode <- function(df = .,
                          event = '6 weeks'){
    df <- df %>%
          dplyr::filter(event_name == event) %>%
          dplyr::select(individual_id, site, event_name,
                        treatment_profile,
                        endocrine_therapy,
                        radiotherapy,
                        surgery,
                        chemotherapy,
                        trastuzumab,
                        primary_adjuvant) %>%
          mutate(primary_treatment = case_when(endocrine_therapy == 'Yes' & primary_adjuvant == 'Primary' ~ 'Primary Endocrine',
                                               endocrine_therapy == 'Yes' & primary_adjuvant == 'Adjuvant' ~ 'Adjuvant Endocrine',
                                               surgery == 'Yes' & primary_adjuvant == 'Adjuvant' ~ 'Surgery',
                                               surgery == 'Yes' & primary_adjuvant == 'Neoadjuvant' ~ 'Surgery',
                                               surgery == 'Yes' & is.na(primary_adjuvant) ~ 'Surgery',
                                               endocrine_therapy == 'No' & surgery == 'No' & chemotherapy == 'Yes' ~ 'Chemotherapy',
                                               endocrine_therapy == 'No' & surgery == 'No' & chemotherapy == 'No' & radiotherapy == 'Yes' ~ 'Radiotherapy',
                                               radiotherapy == 'Yes' ~ 'Radiotherapy',
                                               trastuzumab  == 'Yes' ~ 'Trastuzumab')) %>%
        dplyr::select(individual_id, site, primary_treatment)
    return(df)
}
