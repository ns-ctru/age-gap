## 2017-09-04 - Deriving overall tumour grade and type from left/right
cd('~/work/scharr/age-gap/lib/data-raw/')
source('import.R')

sink('~/work/scharr/age-gap/tmp/check.txt')
print('Rows    : Right')
print('Columns : Left')
table(age_gap$r_tumour_grade, age_gap$l_tumour_grade, useNA = 'ifany')
print('Rows    : Combined')
print('Columns : Left')
table(age_gap$tumour_grade, age_gap$l_tumour_grade, useNA = 'ifany')
print('Rows    : Combined')
print('Columns : Right')
table(age_gap$tumour_grade, age_gap$r_tumour_grade, useNA = 'ifany')
print('Left')
table(age_gap$l_tumour_grade, useNA = 'ifany')
print('Right')
table(age_gap$r_tumour_grade, useNA = 'ifany')
print('Combined')
table(age_gap$tumour_grade, useNA = 'ifany')
print('Left')
dplyr::select(age_gap, l_tumour_grade, r_tumour_grade, tumour_grade) %>%
    dplyr::filter(!is.na(l_tumour_grade))%>%
    head(n = 10) %>%
    as.data.frame()
print('Right')
dplyr::select(age_gap, l_tumour_grade, r_tumour_grade, tumour_grade) %>%
    dplyr::filter(!is.na(r_tumour_grade))%>%
    head(n = 10) %>%
        as.data.frame()
sink()


## Check all of the variables
sink('~/work/scharr/age-gap/tmp/check_left_right_resolution.txt')
quick_check <- function(df    = age_gap,
                        both  = tumour_grade,
                        left  = l_tumour_grade,
                        right = r_tumour_grade,
                        n     = 30,
                        checking = 'Tumour Grade'){
    quo_left  <- enquo(left)
    quo_right <- enquo(right)
    quo_both  <- enquo(both)
    paste0('Checking    : ', checking)          %>% print()
    paste0('Combined value !is.na(', quo_both, ')') %>% print()
    dplyr::select(df, individual_id, !!quo_left, !!quo_right, !!quo_both) %>%
        dplyr::filter(!is.na(!!quo_both)) %>%
        head(n = n) %>%
        as.data.frame() %>%
        print()
    paste0('Both Left and Right are recorded') %>% print()
    dplyr::select(df, individual_id, !!quo_left, !!quo_right, !!quo_both) %>%
        dplyr::filter(!is.na(!!quo_left) & !is.na(!!quo_right)) %>%
        head(n = n) %>%
        as.data.frame() %>%
        print()
    paste0('Cross Tabulation') %>% print()
    dplyr::select(df, individual_id, !!!quo_left, !!!quo_right) %>%
        group_by(., !!quo_left, !!quo_right) %>%
        summarise(n = n()) %>%
        print()
    dplyr::select(df, individual_id, !!!quo_both) %>%
        group_by(., !!quo_both) %>%
        summarise(n = n()) %>%
        print()
    print('')
    print('')
}
quick_check(df       = age_gap,
            left     = l_site_breast,
            right    = r_site_breast,
            both     = site_breast,
            n        = 10,
            checking = 'Site Breast')
quick_check(df       = age_gap,
            left     = l_site_axilla,
            right    = r_site_axilla,
            both     = site_axilla,
            n        = 10,
            checking = 'Site Axilla')
quick_check(df       = age_gap,
            left     = l_site_supraclavicular,
            right    = r_site_supraclavicular,
            both     = site_supraclavicular,
            n        = 10,
            checking = 'Site Supraclavicular')
quick_check(df       = age_gap,
            left     = l_site_chest_wall,
            right    = r_site_chest_wall,
            both     = site_chest_wall,
            n        = 10,
            checking = 'Site Chest Wall')
quick_check(df       = age_gap,
            left     = l_site_other,
            right    = r_site_other,
            both     = site_other,
            n        = 10,
            checking = ' Site Other')
quick_check(df       = age_gap,
            left     = l_breast_fractions,
            right    = r_breast_fractions,
            both     = breast_fractions,
            n        = 10,
            checking = 'Breast Fractions')
quick_check(df       = age_gap,
            left     = l_axilla_fractions,
            right    = r_axilla_fractions,
            both     = axilla_fractions,
            n        = 10,
            checking = 'Axilla Fractions')
quick_check(df       = age_gap,
            left     = l_supra_fractions,
            right    = r_supra_fractions,
            both     = supra_fractions,
            n        = 10,
            checking = 'Supra_Fractions')
quick_check(df       = age_gap,
            left     = l_chest_fractions,
            right    = r_chest_fractions,
            both     = chest_fractions,
            n        = 10,
            checking = ' Chest Fractions')
quick_check(df       = age_gap,
            left     = l_other_fractions,
            right    = r_other_fractions,
            both     = other_fractions,
            n        = 10,
            checking = ' Other Fractions')
quick_check(df       = age_gap,
            left     = l_radiotherapy_aes,
            right    = r_radiotherapy_aes,
            both     = radiotherapy_aes,
            n        = 10,
            checking = ' Radiotherapy AES')
quick_check(df       = age_gap,
            left     = l_skin_erythema,
            right    = r_skin_erythema,
            both     = skin_erythema,
            n        = 10,
            checking = ' Skin Erythema')
quick_check(df       = age_gap,
            left     = l_pain,
            right    = r_pain,
            both     = pain,
            n        = 10,
            checking = ' Pain')
quick_check(df       = age_gap,
            left     = l_breast_oedema,
            right    = r_breast_oedema,
            both     = breast_oedema,
            n        = 10,
            checking = ' Breast Oedema')
quick_check(df       = age_gap,
            left     = l_breast_shrink,
            right    = r_breast_shrink,
            both     = breast_shrink,
            n        = 10,
            checking = ' Breast Shrink')
quick_check(df       = age_gap,
            left     = l_breast_pain,
            right    = r_breast_pain,
            both     = breast_pain,
            n        = 10,
            checking = ' Breast Pain')
quick_check(df       = age_gap,
            left     = l_surgery_aes_acute,
            right    = r_surgery_aes_acute,
            both     = surgery_aes_acute,
            n        = 10,
            checking = ' Surgery AES Acute')
quick_check(df       = age_gap,
            left     = l_surgery_aes_chronic,
            right    = r_surgery_aes_chronic,
            both     = surgery_aes_chronic,
            n        = 10,
            checking = ' Surgery AES Chronic')
quick_check(df       = age_gap,
            left     = l_sa_haemorrhage,
            right    = r_sa_haemorrhage,
            both     = sa_haemorrhage,
            n        = 10,
            checking = ' SA Haemorrhage')
quick_check(df       = age_gap,
            left     = l_sa_seroma,
            right    = r_sa_seroma,
            both     = sa_seroma,
            n        = 10,
            checking = ' SA Seroma')
quick_check(df       = age_gap,
            left     = l_sa_haematoma,
            right    = r_sa_haematoma,
            both     = sa_haematoma,
            n        = 10,
            checking = ' SA Haematoma')
quick_check(df       = age_gap,
            left     = l_sa_infection,
            right    = r_sa_infection,
            both     = sa_infection,
            n        = 10,
            checking = ' SA Infection')
quick_check(df       = age_gap,
            left     = l_sa_necrosis,
            right    = r_sa_necrosis,
            both     = sa_necrosis,
            n        = 10,
            checking = ' SA Necrosis')
quick_check(df       = age_gap,
            left     = l_sc_wound_pain,
            right    = r_sc_wound_pain,
            both     = sc_wound_pain,
            n        = 10,
            checking = ' SC Wound Pain')
quick_check(df       = age_gap,
            left     = l_sc_functional_diff,
            right    = r_sc_functional_diff,
            both     = sc_functional_diff,
            n        = 10,
            checking = ' SC Functional Diff')
quick_check(df       = age_gap,
            left     = l_sc_neuropathy,
            right    = r_sc_neuropathy,
            both     = sc_neuropathy,
            n        = 10,
            checking = ' SC Neuropathy')
quick_check(df       = age_gap,
            left     = l_sc_lymphoedema,
            right    = r_sc_lymphoedema,
            both     = sc_lymphoedema,
            n        = 10,
            checking = ' SC Lymphoedema')
quick_check(df       = age_gap,
            left     = l_tumour_size,
            right    = r_tumour_size,
            both     = tumour_size,
            n        = 10,
            checking = ' Tumour Size')
quick_check(df       = age_gap,
            left     = l_tumour_type,
            right    = r_tumour_type,
            both     = tumour_type,
            n        = 10,
            checking = ' Tumour Type')
quick_check(df       = age_gap,
            left     = l_tumour_grade,
            right    = r_tumour_grade,
            both     = tumour_grade,
            n        = 10,
            checking = ' Tumour Grade')
quick_check(df       = age_gap,
            left     = l_allred,
            right    = r_allred,
            both     = allred,
            n        = 10,
            checking = ' Allred')
quick_check(df       = age_gap,
            left     = l_h_score,
            right    = r_h_score,
            both     = h_score,
            n        = 10,
            checking = ' H Score')
quick_check(df       = age_gap,
            left     = l_onco_offered,
            right    = r_onco_offered,
            both     = onco_offered,
            n        = 10,
            checking = ' Onco Offered')
quick_check(df       = age_gap,
            left     = l_onco_used,
            right    = r_onco_used,
            both     = onco_used,
            n        = 10,
            checking = ' Onco Used')
quick_check(df       = age_gap,
            left     = l_margins_clear,
            right    = r_margins_clear,
            both     = margins_clear,
            n        = 10,
            checking = ' Margins Clear')
quick_check(df       = age_gap,
            left     = l_margin,
            right    = r_margin,
            both     = margin,
            n        = 10,
            checking = ' Margin')
quick_check(df       = age_gap,
            left     = l_designation_anterior,
            right    = r_designation_anterior,
            both     = designation_anterior,
            n        = 10,
            checking = ' Designation Anterior')
quick_check(df       = age_gap,
            left     = l_designation_posterior,
            right    = r_designation_posterior,
            both     = designation_posterior,
            n        = 10,
            checking = ' Designation Posterior')
quick_check(df       = age_gap,
            left     = l_designation_lateral,
            right    = r_designation_lateral,
            both     = designation_lateral,
            n        = 10,
            checking = ' Designation Lateral')
quick_check(df       = age_gap,
            left     = l_designation_medial,
            right    = r_designation_medial,
            both     = designation_medial,
            n        = 10,
            checking = ' Designation Medial')
quick_check(df       = age_gap,
            left     = l_designation_superior,
            right    = r_designation_superior,
            both     = designation_superior,
            n        = 10,
            checking = ' Designation Superior')
quick_check(df       = age_gap,
            left     = l_designation_inferior,
            right    = r_designation_inferior,
            both     = designation_inferior,
            n        = 10,
            checking = ' Designation Inferior')
quick_check(df       = age_gap,
            left     = l_nodes_excised,
            right    = r_nodes_excised,
            both     = nodes_excised,
            n        = 10,
            checking = ' Nodes Excised')
quick_check(df       = age_gap,
            left     = l_nodes_involved,
            right    = r_nodes_involved,
            both     = nodes_involved,
            n        = 10,
            checking = ' Nodes Involved')
quick_check(df       = age_gap,
            left     = l_num_tumours_pet,
            right    = r_num_tumours_pet,
            both     = num_tumours_pet,
            n        = 10,
            checking = ' Num Tumours PET')
quick_check(df       = age_gap,
            left     = l_cancer_palpable_pet,
            right    = r_cancer_palpable_pet,
            both     = cancer_palpable_pet,
            n        = 10,
            checking = ' Cancer Palpable PET')
quick_check(df       = age_gap,
            left     = l_size_clin_assess_pet,
            right    = r_size_clin_assess_pet,
            both     = size_clin_assess_pet,
            n        = 10,
            checking = ' Size Clinical Assessment PET')
quick_check(df       = age_gap,
            left     = l_size_ultrasound_pet,
            right    = r_size_ultrasound_pet,
            both     = size_ultrasound_pet,
            n        = 10,
            checking = ' Size Ultrasound PET')
quick_check(df       = age_gap,
            left     = l_size_mammo_pet,
            right    = r_size_mammo_pet,
            both     = size_mammo_pet,
            n        = 10,
            checking = ' Size Mammography PET')
quick_check(df       = age_gap,
            left     = l_axillary_present_pet,
            right    = r_axillary_present_pet,
            both     = axillary_present_pet,
            n        = 10,
            checking = ' Axillary Present PET')
quick_check(df       = age_gap,
            left     = l_axillary_nodes_pet,
            right    = r_axillary_nodes_pet,
            both     = axillary_nodes_pet,
            n        = 10,
            checking = ' Axillary Nodes PET')
quick_check(df       = age_gap,
            left     = l_axillary_axis_pet,
            right    = r_axillary_axis_pet,
            both     = axillary_axis_pet,
            n        = 10,
            checking = ' Axillary Axis PET')
sink()

## 2017-08-21 - Fixing plot_summary()
load('~/work/scharr/age-gap/lib/data/age-gap.RData')

build()
install()
cohort_plot_chemotherapy$eq5d <- age_gap %>%
    dplyr::filter(!is.na(chemotherapy)) %>%
    ctru::plot_summary(
                       id               = individual_id,
                       select           = c(mobility,
                                            self_care,
                                            usual_activity,
                                            pain_discomfort,
                                            anxiety_depression,
                                            eq5d_score),
                       lookup_fields    = master$lookups_fields,
                       levels_factor    = c('None', 'Slight', 'Moderate', 'Severe', 'Extreme'),
                       group            = chemotherapy,
                       events           = event_name,
                       theme            = theme_bw(),
                       position         = 'identity',
                       histogram        = TRUE,
                       boxplot          = TRUE,
                       individual       = TRUE,
                       plotly           = FALSE,
                       remove_na        = TRUE,
                       title_factor     = 'Summary of EQ-5D-5L scores over time',
                       title_continuous = NULL,
                       legend_continuous = FALSE,
                       legend_factor    = TRUE)

## 2017-08-08 - case_when for mmse_score
t <- age_gap %>%
     mutate(mmse_cat = case_when(mmse_score >= 24                   ~ 1,
                                 mmse_score >= 18 & mmse_score < 23 ~ 2,
                                 mmse_score <= 17                   ~ 3))
## Solution : Using is.na() within case_when() is a bad idea.

## 2017-07-31 - Why isn't import.R working
dplyr::select(master$surgery_and_post_operative_pathology,
              individual_id, site, event_name, ## event_date, database_id,
              general_local,
              which_breast_right_surgery,
              which_breast_left_surgery,
              r_surgery_type
              r_axillary_type,
              r_surgery_aes_acute,
              r_sa_haemorrhage,
              r_sa_seroma,
              r_sa_haematoma,
              r_sa_infection,
              r_sa_necrosis,
              r_sa_wound,
              r_surgery_aes_chronic,
              r_sc_wound_pain,
              r_sc_functional_diff,
              r_sc_neuropathy,
              r_sc_lymphoedema,
              r_tumour_size,
              r_allred,
              r_h_score,
              r_her_2_score,
              r_onco_offered,
              r_onco_used,
              r_risk_score,
              r_tumour_type,
              r_tumour_grade,
              r_margins_clear,
              r_margin,
              r_designation_anterior,
              r_designation_posterior,
              r_designation_lateral,
              r_designation_medial,
              r_designation_superior,
              r_designation_inferior,
              r_close_margin,
              r_nodes_excised,
              r_nodes_involved,
              l_surgery_type,
              l_axillary_type,
              l_surgery_aes_acute,
              l_sa_haemorrhage,
              l_sa_seroma,
              l_sa_haematoma,
              l_sa_infection,
              l_sa_necrosis,
              l_sa_wound,
              l_surgery_aes_chronic,
              l_sc_wound_pain,
              l_sc_functional_diff,
              l_sc_neuropathy,
              l_sc_lymphoedema,
              l_tumour_size,
              l_allred,
              l_h_score,
              l_her_2_score,
              l_onco_offered,
              l_onco_used,
              l_risk_score,
              l_tumour_type,
              l_tumour_grade,
              l_margins_clear,
              l_margin,
              l_designation_anterior,
              l_designation_posterior,
              l_designation_lateral,
              l_designation_medial,
              l_designation_superior,
              l_designation_inferior,
              l_close_margin,
              l_nodes_excised,
              l_nodes_involved)
## Solution -

## 2017-07-28 Plotting missing data
t <- age_gap %>%
     gather(key = identifier, value = value, -individual_id, -event_name) %>%
    mutate(missing = is.na(value),
           individual_id = factor(individual_id))
t <- left_join(t,
               master$lookups_fields)
ggplot(t, aes(x = label, y = individual_id, fill = missing)) +
    geom_raster() +
    theme_bw()

## Testing function
ggplot_missing(df      = age_gap,
               exclude = NULL,
               id      = individual_id,
               event   = event_name,
               site    = site,
               theme   = theme_bw())

## 2017-07-26 Is there any data associated with RCT events?
##
## Looks to me like baseline is simply that, baseline, and that is both cohort and RCT baseline.
## Lets check...
sink('~/work/scharr/age-gap/tmp/event_name.log')
## Levels of event_name
age_gap %$% levels(event_name)
## EORTC QoL questionnaires are recorded at
age_gap %$%
    table(event_name, c30_q1)
## Check RCT specific forms
master$collaborate %$%
    table(event_name, matters_most)
master$decision_regret_scale %$%
    table(event_name, regret_choice)

## Lets check all RCT forms
master$treatment_decision %$%
    table(event_name)
master$treatment_decision_support_consultations %$%
    table(event_name)
master$collaborate %$% ## done
    table(event_name)
master$breast_cancer_treatment_choices_chemo_no_chemo %$% ## done
    table(event_name)
master$breast_cancer_treatment_choices_surgery_pills %$% ## done
    table(event_name)
master$spielberger_state_trait_anxiety %$% ## done
    table(event_name)
master$decision_regret_scale %$% ## done
    table(event_name)
master$treatment_decision %$%
    table(event_name)
master$brief_cope %$% ## done
    table(event_name)
master$the_brief_illness_perception_questionnaire %$% ##done
    table(event_name)
master$discussing_treatment_options %$% ## done
    table(event_name)
master$process_evaluation_log %$% ## done
    table(event_name)

## 2017-07-20 plot_summary() doesn't use the 'event' option to grid_wrap() and only
##            facet_wrap() the plot, lets resolve that.
load('~/work/scharr/age-gap/lib/data/age-gap.RData')
cohort_plot <- list()

## EQ5D
build()
install()
## dplyr::filter(age_gap, !is.na(eq5d_score)) %>%
##     mutate(event_name = factor(event_name)) %>%
cohort_plot$eq5d <- ctru::plot_summary(df            = age_gap,
                                       id               = individual_id,
                                       select           = c(mobility,
                                                            self_care,
                                                            usual_activity,
                                                            pain_discomfort,
                                                            anxiety_depression,
                                                            eq5d_score),
                                       lookup_fields    = master$lookups_fields,
                                       levels_factor    = c('None', 'Slight', 'Moderate', 'Severe', 'Extreme'),
                                       group            = chemotherapy_ever,
                                       events           = event_name,
                                       theme            = theme_bw(),
                                       position         = 'identity',
                                       histogram        = TRUE,
                                       boxplot          = TRUE,
                                       individual       = TRUE,
                                       plotly           = FALSE,
                                       remove_na        = TRUE,
                                       title_factor     = 'Summary of EQ-5D-5L scores over time',
                                       title_continuous = 'Calculated EQ-5D-5L Scores',
                                       legend_continuous = FALSE,
                                       legend_factor    = TRUE)

cohort_plot$eq5d %>% names()
cohort_plot$eq5d$histogram
cohort_plot$eq5d$histogram_eq5d_score
cohort_plot$eq5d$histogram_group
cohort_plot$eq5d$boxplot
cohort_plot$eq5d$boxplot_eq5d_score
cohort_plot$eq5d$boxplot_group
## This works, but can't for the life of me get quo_group (which holds the 'group' variable)
## to work internally in plot_summary()
cohort_plot$eq5d$factor_eq5d + facet_grid(label~chemotherapy_ever)

## 2017-07-19 Working out why *_ever variables not correctly derived...
## Only PET is correct...
age_gap %$% table(endocrine_therapy_ever, useNA = 'ifany')
age_gap %$% table(surgery_ever, useNA = 'ifany')
age_gap %$% table(chemotherapy_ever, useNA = 'ifany')
age_gap %$% table(radiotherapy_ever, useNA = 'ifany')
age_gap %$% table(trastuzumab_ever, useNA = 'ifany')
## Lets check master$therapy_ever
master$therapy_ever %$% table(endocrine_therapy_ever, useNA = 'ifany')
master$therapy_ever %$% table(surgery_ever, useNA = 'ifany')
master$therapy_ever %$% table(chemotherapy_ever, useNA = 'ifany')
master$therapy_ever %$% table(radiotherapy_ever, useNA = 'ifany')
master$therapy_ever %$% table(trastuzumab_ever, useNA = 'ifany')
## Ok they _are_ there and are correct, so something is happening after merging into the dataframe.
## Having run the code upto the point where these are merged in, they are correctly merged,
## suggesting something afterwards is causing the problem.

## 2017-07-17 Working out missing in table summaries
load('~/work/scharr/age-gap/lib/data/age-gap.RData')
cohort_table_chemotherapy$eq5d$factor %$% table(event_name, useNA = 'ifany')
cohort_table_chemotherapy$eq5d$factor %$% table(chemotherapy, useNA = 'ifany')
cohort_table_chemotherapy$eq5d$factor %$% table(value, useNA = 'ifany')
cohort_table_chemotherapy$eq5d$factor %$% table(event_name, chemotherapy, event_name, useNA = 'ifany')
## Ok definitely down to multiple missings across what data is being reshaped for
cohort_table_chemotherapy$eq5d$factor %>%
    ## dplyr::filter(!is.na(chemotherapy), !is.na(value)) %>%
    melt(id.vars = c('event_name', 'chemotherapy', 'label', 'value'),
         measure.vars = c('n', 'prop'),
         value.name   = 'val') %>%
    dcast(event_name + label + value ~ chemotherapy + variable, value.var = 'val') %>% head()
## Need to have an option in summary_table() to remove these automatically, there is,
## 'nomissing' but I've not used it on factor data.
##
## Lets check what is missing
cohort_table_chemotherapy$chemotherapy$df_factor %$% table(event_name, useNA = 'ifany')
dplyr::filter(age_gap, is.na(event_name)) %>% dim()
## Now lets test the modified function that should remove the missing data prior to summarisation
cohort_table_chemotherapy <- list()
cohort_table_chemotherapy$eq5d <- dplyr::filter(age_gap, !is.na(event_name)) %>%
                     ctru::table_summary(df        = .,
                                         lookup    = master$lookups_fields,
                                         id        = individual_id,
                                         select    = c(eq5d_score,
                                                       mobility,
                                                       self_care,
                                                       usual_activity,
                                                       pain_discomfort,
                                                       anxiety_depression),
                                         nomissing = TRUE,
                                         event_name, chemotherapy)
cohort_table_chemotherapy$eq5d$factor %>%
    dplyr::filter(is.na(value) & is.na(chemotherapy))
## event_name missing            : 0
## chemotherapy missing          : 193
## value (eq5d response) missing : 100
## chemotherapy & value missing  : 50

## 2017-07-14 Why doesn't summary_plot() work surgery/chemotherpay/radiotherapy/etc.?

cohort_plot <- list()
## EQ5D
cohort_plot$eq5d <- ctru::plot_summary(df            = age_gap,
                                       id               = individual_id,
                                       select           = c(mobility,
                                                            self_care,
                                                            usual_activity,
                                                            pain_discomfort,
                                                            anxiety_depression,
                                                            eq5d_score),
                                       lookup_fields    = master$lookups_fields,
                                       levels_factor    = c('None', 'Slight', 'Moderate', 'Severe', 'Extreme'),
                                       group            = endocrine_therapy,
                                       events           = event_name,
                                       theme            = theme_bw(),
                                       position         = 'identity',
                                       histogram        = TRUE,
                                       boxplot          = TRUE,
                                       individual       = TRUE,
                                       plotly           = FALSE,
                                       remove_na        = TRUE,
                                       title_factor     = 'Summary of EQ-5D-5L scores over time',
                                       title_continuous = NULL,
                                       legend_continuous = FALSE,
                                       legend_factor    = TRUE)
## Solved! Problem was with how factor variables are selected and the data subsequently
## reshaped.  Had solved this in table_summary() but hadn't copied over to plot_summary()

## 2017-06-29 Developing plots and tables
## Lets try all of the responses for EQ5d
load('~/work/scharr/age-gap/lib/data/age-gap.RData')
event <- list()
survey_vars <- list()
event$eq5d <- c('Baseline', '6 weeks', '6 months', '12 months', '18 months', '24 months')
survey_vars$eq5d <- c(mobility, self_care, usual_activity, pain_discomfort, anxiety_depression)

build()
install()
test <- ctru::plot_summary(df            = age_gap,
                           id            = individual_id,
                           select        = c(mobility, self_care, usual_activity, pain_discomfort, anxiety_depression, bmi),
                           lookup_fields = master$lookups_fields,
                           levels_factor = c('None', 'Slight', 'Moderate', 'Severe', 'Extreme'),
                           group         = site,
                           events        = event_name,
                           theme         = theme_bw(),
                           position      = 'identity',
                           histogram     = TRUE,
                           boxplot       = TRUE,
                           individual    = TRUE,
                           plotly        = FALSE,
                           remove_na     = TRUE,
                           title_factor  = 'Factor outcomes by treatment group',
                           title_continuous = 'Continuous outcomes by treatment group')
test$factor_eq5d

test$histogram
test$boxplot

## What age gap requires...
ggplot(test$df_factor, aes(x = event_name,  fill = value)) + geom_bar(position = 'fill') + coord_flip() + facet_wrap(~label, ncol = 1) + scale_y_continuous(trans = 'reverse')

## THink of a way of using a formula description for how factors are plotted.

## 2017-06-26 Checking if/how pixiedust functions can be integrated into table_summary()
check <- dplyr::select(age_gap, individual_id, site, event_name, age_exact, height_cm, weight_current_kg, bmi)
dust(check)
table_summary(df = check,
              lookup = master$lookups_fields,
              id     = individual_id,
              select = c(age_exact, height_cm, weight_current_kg, bmi),
              event_name) %>%
    dplyr::filter(n != missing) %>%
    dust()
## Looks like using table_summary() and then passing to dust() and subsequent augmentation is the way
## forward.

## 2017-06-22 Checking revised import and conversion of boolean factors works
## File : Treatment decision.csv
master$treatment_decision <- read_prospect(file = '~/work/scharr/age-gap/lib/data-raw/Treatment decision.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookups)
check <- read.csv('~/work/scharr/age-gap/lib/data-raw/Treatment decision.csv')
print('Check')
table(check$odt_taken_home_no_oth_o, useNA = 'ifany')
table(check$odt_taken_home_no_decided_o, useNA = 'ifany')
table(check$b_taken_home_no_oth_o, useNA = 'ifany')
print('Master')
table(master$treatment_decision$odt_taken_home_no_decided, useNA = 'ifany')
table(master$treatment_decision$odt_taken_home_no_other, useNA = 'ifany')
table(master$treatment_decision$b_taken_home_no_other, useNA = 'ifany')

being_checked <- c('odt_taken_home_no_other')
dplyr::filter(master$lookups, form == 'Treatment decision') %>% dplyr::select(field, code, label)
dplyr::filter(master$lookups, form == 'Treatment decision' & field %in% being_checked)
factor(check$odt_taken_home_no_decided_o,
       levels = c(subset(master$lookups, field == 'odt_taken_home_no_decided')$code),
       labels = c(subset(master$lookups, field == 'odt_taken_home_no_decided')$label)) %>% table()
factor(check$odt_taken_home_no_oth_o,
       levels = c(subset(master$lookups, field == 'odt_taken_home_no_other')$code),
       labels = c(subset(master$lookups, field == 'odt_taken_home_no_other')$label)) %>% table()

## Lets check the lookups file
subset(master$lookups, field == 'odt_taken_home_no_decided')
subset(master$lookups, field == 'b_taken_home_no_decided')

## OK SOLVED IT!!!  It was using 'dt' to identify date variables that need converting to internal
## elapsed dates, the 'odt_taken_home_no_*' group of variables were first being converted to dates
## hence all being NA since they were not date strings.  Corrected read_prospect() to look for '_dt'
## in variable names.  PHEW!  I guess this is the sort of thing that could be avoided if databases
## (i.e. Prospect) could be queried directly as data types would not be lost when exporting to CSV
## files, but hey, thats never going to change because it was decided to out-source database
## development and maintenance and Access Control is done at the WebUI level rather than the database
## level.

## 2017-06-21 Checking _o variables are read in as 0/1
check <- read.csv(file = '~/work/scharr/age-gap/lib/data-raw/Radiotherapy.csv')
names(check)
table(check$r_site_breast_o, useNA = 'ifany')
table(check$r_site_axilla_o, useNA = 'ifany')
table(check$r_site_supraclavicular_o, useNA = 'ifany')

## 2017-06-21 debugging why summary_table() doesn't work
continuous_vars$radiotherapy <- quos(## r_site_breast_o,
                                     ## r_site_axilla_o, r_site_supraclavicular_o, r_site_chest_wall_o,
                                     ## r_site_other_o, r_breast_fractions, r_axilla_fractions,
                                     ## r_supra_fractions, r_chest_fractions, r_other_fractions,
                                     ## r_radiotherapy_aes)
                                     ## l_site_breast_o, l_site_axilla_o, l_site_supraclavicular_o,
                                     ## l_site_chest_wall_o, l_site_other_o, l_breast_fractions,
                                     ## l_axilla_fractions, l_supra_fractions, l_chest_fractions,
                                     l_other_fractions)
summary_tables$radiotherapy                <- table_summary(df = age_gap,
                                                            lookup = master$lookups_fields,
                                                            id = individual_id,
                                                            select = c(!!!continuous_vars$radiotherapy),
                                                            site)

sink('~/work/scharr/age-gap/tmp/check.txt')
which(sapply(master$radiotherapy, class) == "integer")
sapply(master$radiotherapy, table)
sink()
## Ok, looks like there are a lot of factor variables mistakenly included.
sink('~/work/scharr/age-gap/tmp/check_non_pet.txt')
which(sapply(master$clinical_assessment_non_pet, class) == "integer")
sapply(master$radiotherapy, table)
sink()
sink('~/work/scharr/age-gap/tmp/check_pet.txt')
which(sapply(master$clinical_assessment_pet, class) == "integer")
sapply(master$radiotherapy, table)
sink()

## 2017-06-16 ggmosaic() for plotting likert responses
test$df_factor %>%
    dplyr::filter(!is.na(value)) %>%
    ## group_by(group, variable, value) %>%
    ## summarise(n = n()) %>%
    ggplot(aes(x = label, fill = value)) +
    geom_bar(position = 'fill') + coord_flip()

## 2017-06-16 Testing facet_grid() by event_name
load('~/work/scharr/age-gap/lib/data/age-gap.RData')

build()
install()
age_gap <- age_gap %>%
           mutate(group = ifelse(runif(n = nrow(.)) > 0.5,
                                       yes = 'Case',
                                       no  = 'Control'))
test <- plot_summary(df         = age_gap,
                     id         = individual_id,
                     select     = c(weight_kg,
                                    age_exact,
                                    bmi,
                                    collaborate_calc_score,
                                    fs_scale,
                                    worried,
                                    tense,
                                    upset,
                                    content,
                                    relaxed),
                     lookup     = master$lookups_field,
                     theme      = theme_bw(),
                     group      = group,
                     events     = NULL,
                     position   = 'dodge',
                     individual = TRUE,
                     plotly     = FALSE,
                     title.continuous = 'Some Random title instad of the default',
                     title.factor     = 'Summaries of one of the surveys')
test$relaxed

## 2017-06-15 On-going development, why isn't data plotted correctly?
build()
install()
age_gap <- age_gap %>%
           mutate(group = ifelse(runif(n = nrow(.)) > 0.5,
                                       yes = 'Case',
                                       no  = 'Control'))
test <- plot_summary(df         = age_gap,
                     id         = individual_id,
                     select     = c(weight_kg, age_exact, bmi, collaborate_calc_score, fs_scale, worried, tense, upset, content, relaxed),
                     lookup     = master$lookups_field,
                     theme      = theme_bw(),
                     group      = group,
                     position   = 'dodge',
                     individual = TRUE,
                     plotly     = FALSE,
                     title.continuous = 'Some Random title instad of the default')

test$continuous
test$bmi

test$continuous$data %>%
    ggplot(aes(x = value, fill = group)) +
    geom_histogram(position = 'dodge', alpha = 0.5) +
    facet_wrap(~label,
               scales = 'free',
               strip.position = 'bottom') +
    xlab('') + ylab('N') +
    theme_bw() +
    theme(strip.background = element_blank(),
          strip.placement  = 'outside')

test$bmi$data %>%
    ggplot(aes(x = value, fill = group)) +
    geom_histogram(position = 'dodge', alpha = 0.5) +
    facet_wrap(~label,
               scales = 'free',
               strip.position = 'bottom') +
    xlab('') + ylab('N') +
    theme_bw() +
    theme(strip.background = element_blank(),
          strip.placement  = 'outside')

test$df_numeric %>%
    dplyr::filter(!is.na(site)) %>% dim()

ggplot(test$df_numeric, aes(x = value, fill = site)) + geom_histogram(stat = 'count')


## 2017-06-14 Development of a plot_summary() function in the CTRU package
##
## How to assess what variables in a data frame are numeric/continuous
## and therefore need distributions plotting.
sapply(age_gap, class) == "numeric"

## Can we use this to subset a data frame?
## Yes....
test <- age_gap[, sapply(age_gap, class) == "numeric"]
## ...but need to have the grouping variables that are specified so need
## to solve it with dplyr::select(), this works...
test <- age_gap %>% dplyr::select(which(sapply(., class) == 'numeric'), surgery)

## Now lets start testing the filtering, gathering labelling etc.
build()
install()
test <- plot_summary(df         = age_gap,
                     id         = individual_id,
                     select     = c(weight_kg, age_exact, bmi, collaborate_calc_score, fs_scale),
                     lookup     = master$lookups_field,
                     theme      = theme_bw(),
                     group      = 'surgery',
                     individual = TRUE,
                     plotly     = FALSE)

test$continuous

## Checking left_join with master$lookups_field
test <- left_join(test$df_numeric,
                  master$lookups_field,
                  by = c('variable' = 'identifier'))

## Test plotting
test %>%
    ggplot(aes(value, fill = surgery)) +
    geom_density() +
    facet_wrap(~ variable)

gather(test, key = variable, value = value )

## 2017-06-08 Development of a recruitment() function in the CTRU package
build()
install()
test <- recruitment(df = screening_form,
                    screening = screening_no,
                    enrollnment = enrollment_no,
                    facet       = NULL,
                    plotly      = FALSE)

## 2017-06-07 Simple regression for checking output formats to aid development of
##            (hopefully generic) label() function that takes the concatenated
##            variable + factor as output by regression models and provides more
##            human readable output.
##
## Test a dummy model
tidy_model <- dplyr::filter(age_gap, event_name == 'Baseline') %>%
              glm(formula = bmi ~ age + height_cm + weight_current_kg + c30_q1 + c30_q3,
                  family  = 'gaussian') %>%
              tidy()

## Now test labelling it
build()
install()
ctru::label(fields  = master$lookups_fields,
            lookups = master$lookups,
            df      = tidy_model)


## 2017-05-23 Working out what data we (should) have since multiple merges are required
##            to combine data (which was stored in a database!) into a coherent dataset.
## Table the event_name in each data frame that has been read
sink('~/work/age-gap/tmp/file_events.txt')
print('abridged_patient_assessment')
table(master$abridged_patient_assessment$event_name)
print('activities_daily_living')
table(master$activities_daily_living$event_name)
print('adverse_events')
table(master$adverse_events$event_name)
print('adverse_events_ae')
table(master$adverse_events_ae$event_name)
print('annotations')
table(master$annotations$event_name)
print('baseline_medications')
table(master$baseline_medications$event_name)
print('baseline_medications_med')
table(master$baseline_medications_med$event_name)
print('baseline_tumour_assessment')
table(master$baseline_tumour_assessment$event_name)
print('brief_cope')
table(master$brief_cope$event_name)
print('brief_illness_perception_questionnaire')
table(master$brief_illness_perception_questionnaire$event_name)
print('change_in_participation')
table(master$change_in_participation$event_name)
print('chemotherapy')
table(master$chemotherapy$event_name)
print('chemotherapy_chemotherapy')
table(master$chemotherapy_chemotherapy$event_name)
print('clinical_assessment_non_pet')
table(master$clinical_assessment_non_pet$event_name)
print('clinical_assessment_pet')
table(master$clinical_assessment_pet$event_name)
print('collaborate')
table(master$collaborate$event_name)
print('consent_form')
table(master$consent_form$event_name)
print('decision_making_preferences')
table(master$decision_making_preferences$event_name)
print('decision_regret_scale')
table(master$decision_regret_scale$event_name)
print('discrepancies')
table(master$discrepancies$event_name)
print('discussing_treatment_options')
table(master$discussing_treatment_options$event_name)
print('duplicates')
table(master$duplicates$event_name)
print('ecog_performance_status_score')
table(master$ecog_performance_status_score$event_name)
print('eligibility_checklist')
table(master$eligibility_checklist$event_name)
print('endocrine_therapy')
table(master$endocrine_therapy$event_name)
print('eortc_qlq_br23')
table(master$eortc_qlq_br23$event_name)
print('eortc_qlq_c30')
table(master$eortc_qlq_c30$event_name)
print('eortc_qlq_eld15')
table(master$eortc_qlq_eld15$event_name)
print('EQ5D')
table(master$eq5d$event_name)
print('Forms')
table(master$forms$event_name)
sink()

## 2017-05-18 Developing/reworking  eq5d_score() from ctru package
load('~/work/age-gap/lib/data/age-gap.RData')

eq5d <- eq5d_score(master$eq5d,
                   dimensions = 5,
                   levels     = 5,
                   mobility   = 'mobility',
                   self       = 'self_care',
                   activity   = 'usual_activity',
                   pain       = 'pain_discomfort',
                   usual      = 'usual_activity',
                   mobility.response = levels(master$eq5d$mobility),
                   self.response     = levels(master$eq5d$self_care),
                   activity.response = levels(master$eq5d$usual_activity),
                   pain.response     = levels(master$eq5d$pain_discomfort),
                   usual.response    = levels(master$eq5d$usual_activity))
## Non-standard evaluation in dplyr-0.6.0...
##
## https://alexpghayes.github.io/2017/gentle-non-standard-evaluation-in-dplyr-0-6/

## 2017-05-18 read_prospect() no longer seems to label factors??
eq5d <- read_prospect(file = '~/work/age-gap/lib/data-raw/EQ5D.csv',
                      header              = TRUE,
                      sep                 = ',',
                      convert.dates       = TRUE,
                      convert.underscores = TRUE,
                      dictionary          = master$lookups)
## SOLUTION : lookup) -> lookups)

## 2017-05-17 Investigating "Factor levels are duplicated"
clinical_assessment_pet <- read_prospect(file = 'Clinical Assessment (PET).csv',
                         header          = TRUE,
                         sep             = ',',
                         convert.dates   = TRUE,
                         dictionary      = master$lookup)
## Check for duplicates across all lookups
dim(master$lookups)
unique(master$lookups) %>% dim()
## Look at fields for just this form
dplyr::filter(master$lookups, form == 'Clinical Assessment (PET)') %>% dim()
dplyr::filter(master$lookups, form == 'Clinical Assessment (PET)') %>% unique() %>% dim()
## Group by form/subform/field/code and look for duplicates
dplyr::filter(master$lookups, form == 'Clinical Assessment (PET)') %>%
    group_by(form, subform, field, code) %>%
    mutate(n = n()) %>%
    dplyr::filter(n > 1)
## How many times does 'uni_bilateral' occur
dplyr::filter(master$lookups, field == 'uni_bilateral')
## SOLUTION : Ahha, thats the problem, the same field name is used in mutiiple forms.
##            Solved by adapting read_prospect() in the ctru package.
