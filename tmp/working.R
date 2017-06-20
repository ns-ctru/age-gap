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
