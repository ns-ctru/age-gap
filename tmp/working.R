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
