## Filename    : import.R
## Author      : n.shephard@sheffield.ac.uk
## Description : Imports the CSV files exported from the Prospect database
##               and recreates a lot of the links that existed there to
##               produce one single data set for analysis

###################################################################################
## Reading Data                                                                  ##
###################################################################################
## Master list for holding all imported CSVs
master <- list()
## File : Lookups.csv
master$lookups <- read_prospect(file = 'Lookups.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = NULL)
## File : Abridged Patient Generated Assessment.csv
master$abridged_patient_assessment <- read_prospect(file = 'Abridged Patient Generated Assessment.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookup)
## File : Activities of Daily Living.csv
master$daily_living <- read_prospect(file = 'Activities of Daily Living.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookup)
## File : Adverse Events - AeEvent.csv
master$adverse_events_ae <- read_prospect(file = 'Adverse Events - AeEvent.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookup)
## File : Adverse Events.csv
master$adverse_events <- read_prospect(file = 'Adverse Events.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookup)
## File : Baseline Medications.csv
master$baseline_medications <- read_prospect(file = 'Baseline Medications.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookup)
## File : Baseline Medications - Med.csv
master$baseline_emdications_med <- read_prospect(file = 'Baseline Medications - Med.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookup)
## File : Baseline Tumour Assessment.csv
master$baseline_tumour_assessment <- read_prospect(file = 'Baseline Tumour Assessment.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookup)
## File : Breast Cancer Treatment Choices - chemo vs no chemo.csv
master$treatment_choices_chemo_no_chemo <- read_prospect(file = 'Breast Cancer Treatment Choices - chemo vs no chemo.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookup)
## File : Breast Cancer Treatment Choices - surgery vs pills.csv
master$treatment_choices_surgery_pills <- read_prospect(file = 'Breast Cancer Treatment Choices - surgery vs pills.csv',
                         header          = TRUE,
                         sep             = ',',
                         convert.dates   = TRUE,
                         convert.underscores = TRUE,
                         dictionary      = master$lookup)
## File : Brief COPE.csv
master$brief_cope <- read_prospect(file = 'Brief COPE.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookup)
## File : Change in level of participation.csv
master$change_in_participation <- read_prospect(file = 'Change in level of participation.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookup)
## File : Chemotherapy - Chemotherapy.csv
master$chemotherapy_chemotherapy <- read_prospect(file = 'Chemotherapy - Chemotherapy.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookup)
## File : Chemotherapy.csv
master$chemotherapy <- read_prospect(file = 'Chemotherapy.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookup)
## File : Clinical Assessment (non-PET).csv
master$clinical_assessment_non_pet <- read_prospect(file = 'Clinical Assessment (non-PET).csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookup)
## File : Clinical Assessment (PET).csv
master$clinical_assessment_pet <- read_prospect(file = 'Clinical Assessment (PET).csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookup)
## File : CollaboRATE.csv
master$collaborate <- read_prospect(file = 'CollaboRATE.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookup)
## File : Consent Form.csv
master$consent_form <- read_prospect(file = 'Consent Form.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookup)
## File : Decision Making Preferences.csv
master$decision_making_preferences <- read_prospect(file = 'Decision Making Preferences.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookup)
## File : Decision Regret Scale (DRS).csv
master$decision_regret_scale <- read_prospect(file = 'Decision Regret Scale (DRS).csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookup)
## File : Discussing treatment options.csv
master$discussing_treatment_options <- read_prospect(file = 'Discussing treatment options.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookup)
## File : ECOG Performance Status Score.csv
master$ecog_performance_status_score <- read_prospect(file = 'ECOG Performance Status Score.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookup)
## File : Eligibility checklist.csv
master$eligibility_checklist <- read_prospect(file = 'Eligibility checklist.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookup)
## File : Endocrine Therapy.csv
master$endocrine_therapy <- read_prospect(file = 'Endocrine Therapy.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookup)
## File : EORTC-QLQ-BR23.csv
master$eortc_qlq_br23 <- read_prospect(file = 'EORTC-QLQ-BR23.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookup)
## File : EORTC-QLQ-C30.csv
master$eortc_qlq_c30 <- read_prospect(file = 'EORTC-QLQ-C30.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookup)
## File : EORTC-QLQ-ELD15.csv
master$eortc_qlq_eld15 <- read_prospect(file = 'EORTC-QLQ-ELD15.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookup)
## File : EQ5D.csv
master$eq5d <- read_prospect(file = 'EQ5D.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookup)
## File : Instrumental Activities of Daily Living.csv
master$instrumental_activities_daily_living <- read_prospect(file = 'Instrumental Activities of Daily Living.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookup)
## File : Mini-Mental State Examination.csv
master$mini_mental_state_examination <- read_prospect(file = 'Mini-Mental State Examination.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookup)
## File : Modified Charlson Co-Morbidity.csv
master$modified_charlson_comorbidity <- read_prospect(file = 'Modified Charlson Co-Morbidity.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookup)
## File : Process Evaluation log.csv
master$process_evaluation_log <- read_prospect(file = 'Process Evaluation log.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookup)
## File : QoL  LoL Questionnaire.csv
master$qol_lol_questionnaire <- read_prospect(file = 'QoL  LoL Questionnaire.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookup)
## File : Radiotherapy.csv
master$radiotherapy <- read_prospect(file = 'Radiotherapy.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookup)
## File : Screening Form.csv
master$screening_form <- read_prospect(file = 'Screening Form.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookup)
## File : Spielberger State-Trait Anxiety Inventory (STAI).csv
master$spielberger_state_trait_anxiety <- read_prospect(file = 'Spielberger State-Trait Anxiety Inventory (STAI).csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookup)
## File : Study completion  discontinuation form.csv
master$study_completion_discontinuation_form <- read_prospect(file = 'Study completion  discontinuation form.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookup)
## File : Surgery and Post Operative Pathology.csv
master$surgery_and_post_operative_pathology <- read_prospect(file = 'Surgery and Post Operative Pathology.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookup)
## File : The Brief Illness Perception Questionnaire (BIPQ).csv
master$brief_illness_perception_questionnaire <- read_prospect(file = 'The Brief Illness Perception Questionnaire (BIPQ).csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookup)
## File : Therapy Assessment.csv
master$therapy_assessment <- read_prospect(file = 'Therapy Assessment.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookup)
## File : Trastuzumab.csv
master$trastuzumab <- read_prospect(file = 'Trastuzumab.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookup)
## File : Treatment decision.csv
master$treatment_decision <- read_prospect(file = 'Treatment decision.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookup)
## File : Treatment decision support consultations.csv
master$treatment_decision_support_consultations <- read_prospect(file = 'Treatment decision support consultations.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookup)
## File : Transfers.csv
master$transfers <- read_prospect(file = 'Transfers.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookup)
## File : Sites.csv
master$sites <- read_prospect(file = 'Sites.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookup)
## File : Discrepancies.csv
master$discrepancies <- read_prospect(file = 'Discrepancies.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookup)
## File : Unavailable Forms.csv
master$unavailable_forms <- read_prospect(file = 'Unavailable Forms.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookup)
## File : Annotations.csv
master$annoations <- read_prospect(file = 'Annotations.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookup)

###################################################################################
## Scoring                                                                       ##
###################################################################################
## EQ5D

##
