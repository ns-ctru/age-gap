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
