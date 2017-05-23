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
## File   : Age Gap database specification - Forms.csv
## Source : https://goo.gl/oFBs4j
master$lookups.form <- read.csv(file = 'Age Gap database specification - Forms.csv',
                                header = TRUE)
master$lookups.form <- master$lookups.form %>%
                       dplyr::select(Name, Identifier, Subforms)
names(master$lookups.form) <- names(master$lookups.form) %>% tolower()
## File   : Age Gap database specification - Forms.csv
## Source : https://goo.gl/oFBs4j
master$lookups.fields <- read.csv(file = 'Age Gap database specification - Fields.csv',
                                  header = TRUE)
master$lookups.fields <- master$lookups.fields %>%
                         dplyr::select(Form, Subform, Identifier, Label)
names(master$lookups.fields) <- names(master$lookups.fields) %>% tolower()
## File : Abridged Patient Generated Assessment.csv
master$abridged_patient_assessment <- read_prospect(file = 'Abridged Patient Generated Assessment.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookups)
## File : Activities of Daily Living.csv
master$activities_daily_living <- read_prospect(file = 'Activities of Daily Living.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookups)
## File : Adverse Events - AeEvent.csv
master$adverse_events_ae <- read_prospect(file = 'Adverse Events - AeEvent.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookups)
## File : Adverse Events.csv
master$adverse_events <- read_prospect(file = 'Adverse Events.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookups)
## File : Baseline Medications.csv
master$baseline_medications <- read_prospect(file = 'Baseline Medications.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookups)
## File : Baseline Medications - Med.csv
master$baseline_medications_med <- read_prospect(file = 'Baseline Medications - Med.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookups)
## TODO - This file is in long format as there are multiple medications, convert to wide and derive
##        binary indicators for specific medications that are of interest.
## File : Baseline Tumour Assessment.csv
master$baseline_tumour_assessment <- read_prospect(file = 'Baseline Tumour Assessment.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookups)
## File : Breast Cancer Treatment Choices - chemo vs no chemo.csv
master$treatment_choices_chemo_no_chemo <- read_prospect(file = 'Breast Cancer Treatment Choices - chemo vs no chemo.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookups)
## File : Breast Cancer Treatment Choices - surgery vs pills.csv
master$treatment_choices_surgery_pills <- read_prospect(file = 'Breast Cancer Treatment Choices - surgery vs pills.csv',
                         header          = TRUE,
                         sep             = ',',
                         convert.dates   = TRUE,
                         convert.underscores = TRUE,
                         dictionary      = master$lookups)
## File : Brief COPE.csv
master$brief_cope <- read_prospect(file = 'Brief COPE.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookups)
## File : Change in level of participation.csv
master$change_in_participation <- read_prospect(file = 'Change in level of participation.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookups)
## File : Chemotherapy - Chemotherapy.csv
master$chemotherapy_chemotherapy <- read_prospect(file = 'Chemotherapy - Chemotherapy.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookups)
## File : Chemotherapy.csv
master$chemotherapy <- read_prospect(file = 'Chemotherapy.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookups)
## File : Clinical Assessment (non-PET).csv
master$clinical_assessment_non_pet <- read_prospect(file = 'Clinical Assessment (non-PET).csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookups)
## File : Clinical Assessment (PET).csv
master$clinical_assessment_pet <- read_prospect(file = 'Clinical Assessment (PET).csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookups)
## File : CollaboRATE.csv
master$collaborate <- read_prospect(file = 'CollaboRATE.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookups)
## File : Consent Form.csv
master$consent_form <- read_prospect(file = 'Consent Form.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookups)
## Contains TWO copies of 'enrollment_no', resolve now
master$consent_form <- cbind(master$consent_form[1:2],
                             master$consent_form[4:23])
## File : Decision Making Preferences.csv
master$decision_making_preferences <- read_prospect(file = 'Decision Making Preferences.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookups)
## File : Decision Regret Scale (DRS).csv
master$decision_regret_scale <- read_prospect(file = 'Decision Regret Scale (DRS).csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookups)
## File : Discussing treatment options.csv
master$discussing_treatment_options <- read_prospect(file = 'Discussing treatment options.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookups)
## File : ECOG Performance Status Score.csv
master$ecog_performance_status_score <- read_prospect(file = 'ECOG Performance Status Score.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookups)
## File : Eligibility checklist.csv
master$eligibility_checklist <- read_prospect(file = 'Eligibility checklist.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookups)
## File : Endocrine Therapy.csv
master$endocrine_therapy <- read_prospect(file = 'Endocrine Therapy.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookups)
## File : EORTC-QLQ-BR23.csv
master$eortc_qlq_br23 <- read_prospect(file = 'EORTC-QLQ-BR23.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookups)
## File : EORTC-QLQ-C30.csv
master$eortc_qlq_c30 <- read_prospect(file = 'EORTC-QLQ-C30.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookups)
## File : EORTC-QLQ-ELD15.csv
master$eortc_qlq_eld15 <- read_prospect(file = 'EORTC-QLQ-ELD15.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookups)
## File : EQ5D.csv
master$eq5d <- read_prospect(file = 'EQ5D.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookups)
## File : Instrumental Activities of Daily Living.csv
master$instrumental_activities_daily_living <- read_prospect(file = 'Instrumental Activities of Daily Living.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookups)
## File : Mini-Mental State Examination.csv
master$mini_mental_state_examination <- read_prospect(file = 'Mini-Mental State Examination.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookups)
## File : Modified Charlson Co-Morbidity.csv
master$modified_charlson_comorbidity <- read_prospect(file = 'Modified Charlson Co-Morbidity.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookups)
## File : Process Evaluation log.csv
master$process_evaluation_log <- read_prospect(file = 'Process Evaluation log.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookups)
## File : QoL  LoL Questionnaire.csv
master$qol_lol_questionnaire <- read_prospect(file = 'QoL  LoL Questionnaire.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookups)
## File : Radiotherapy.csv
master$radiotherapy <- read_prospect(file = 'Radiotherapy.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookups)
## File : Screening Form.csv
master$screening_form <- read_prospect(file = 'Screening Form.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookups)
## File : Spielberger State-Trait Anxiety Inventory (STAI).csv
master$spielberger_state_trait_anxiety <- read_prospect(file = 'Spielberger State-Trait Anxiety Inventory (STAI).csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookups)
## File : Study completion  discontinuation form.csv
master$study_completion_discontinuation_form <- read_prospect(file = 'Study completion  discontinuation form.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookups)
## File : Surgery and Post Operative Pathology.csv
master$surgery_and_post_operative_pathology <- read_prospect(file = 'Surgery and Post Operative Pathology.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookups)
## File : The Brief Illness Perception Questionnaire (BIPQ).csv
master$brief_illness_perception_questionnaire <- read_prospect(file = 'The Brief Illness Perception Questionnaire (BIPQ).csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookups)
## File : Therapy Assessment.csv
master$therapy_assessment <- read_prospect(file = 'Therapy Assessment.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookups)
## File : Trastuzumab.csv
master$trastuzumab <- read_prospect(file = 'Trastuzumab.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookups)
## File : Treatment decision.csv
master$treatment_decision <- read_prospect(file = 'Treatment decision.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookups)
## File : Treatment decision support consultations.csv
master$treatment_decision_support_consultations <- read_prospect(file = 'Treatment decision support consultations.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookups)
## File : Transfers.csv
master$transfers <- read_prospect(file = 'Transfers.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookups)
## File : Sites.csv
master$sites <- read_prospect(file = 'Sites.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookups)
## File : Discrepancies.csv
master$discrepancies <- read_prospect(file = 'Discrepancies.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookups)
## File : Unavailable Forms.csv
master$unavailable_forms <- read_prospect(file = 'Unavailable Forms.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookups)
## File : Forms.csv
master$forms <- read_prospect(file = 'Forms.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookups)
## File : Annotations.csv
master$annotations <- read_prospect(file = 'Annotations.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookups)
## File : individuals.csv
master$individuals <- read_prospect(file = 'Individuals.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookups)

###################################################################################
## Scoring                                                                       ##
###################################################################################
## EQ5D
## TODO - Need to get eq5d_score() function in CTRU package working with Non-Standard
##        Evaluation/Scoping

###################################################################################
## Data Frame                                                                    ##
###################################################################################
## Derive a single data frame for all data components
## Consent and Baseline Tumor Assessment
master$baseline <- full_join(dplyr::select(master$consent_form,
                                           individual_id, site, ## event_name, event_date, database_id,
                                           screening_no, dob, participation_lvl),
                             dplyr::select(master$baseline_tumour_assessment,
                                           individual_id, site, event_name, event_date, ## database_id,
                                           uni_bilateral, primary_tumour,
                                           r_focal, r_num_tumours, r_cancer_palpable, r_size_clin_assess,
                                           r_method_assess, r_size_ultrasound, r_size_mammo,
                                           r_axillary_present, r_axillary_nodes, r_axillary_axis,
                                           r_biopsy_type, r_confirm_present, r_histo_grade, r_histo_subtype,
                                           r_histo_spcfy, r_allred, r_h_score, r_pgr_score, r_her_2_score,
                                           l_focal, l_num_tumours, l_cancer_palpable, l_size_clin_assess,
                                           l_method_assess, l_size_ultrasound, l_size_mammo,
                                           l_axillary_present, l_axillary_nodes, l_axillary_axis, l_biopsy_type,
                                           l_confirm_present, l_histo_grade, l_histo_subtype, l_histo_spcfy,
                                           l_allred, l_h_score, l_pgr_score, l_her_2_score, taking_meds),
                             by = c('individual_id', 'site')) %>%
## Baseline Medications
           ## full_join(.,
           ##           dplyr::select(master$baseline_medications_med,
           ##                         individual_id, site, event_name, event_date, ## database_id,
           ##                         )) %>%
## Decision making preferences
                  full_join(.,
                            dplyr::select(master$decision_making_preferences,
                                          individual_id, site, event_name, event_date, ## database_id,
                                          ideal_situation, actual_situation),
                            by = c('individual_id', 'site', 'event_name')) %>%
## Abridged Patient Assessment
                  full_join(.,
                            dplyr::select(master$abridged_patient_assessment,
                                          individual_id, site, event_name, ## event_date, database_id,
                                          weight_current_kg, weight_current_st, weight_current_lb,
                                          weight_1m_kg, weight_1m_st, weight_1m_lb,
                                          weight_6m_kg, weight_6m_st, weight_6m_lb,
                                          height_cm, height_ft, height_in),
                            by = c('individual_id', 'site', 'event_name')) %>%
## Mini Mental State Examination
                  full_join(.,
                            dplyr::select(master$mini_mental_state_examination,
                                          individual_id, site, event_name, ## event_date, database_id,
                                          orientation_1, orientation_2,
                                          attention_1, attention_2,
                                          recall_1, naming_1, repetition_1, comprehension_1,
                                          reading_1, writing_1, drawing_1),
                            by = c('individual_id', 'site', 'event_name')) %>%
## Activites of Daily Living
                  full_join(.,
                            dplyr::select(master$activities_daily_living,
                                          individual_id, site, event_name, ## event_date, database_id,
                                          feeding, transfer_bed_chair, personal_toilet, toiletting,
                                          bathing, walking_wheelchair, ascend_descend, dressing,
                                          bowels, bladder, adl_score),
                            by = c('individual_id', 'site', 'event_name')) %>%
## Instrumental Activites Daily Living
                  full_join(.,
                            dplyr::select(master$instrumental_activities_daily_living,
                                          individual_id, site, event_name, ## event_date, database_id,
                                          telephone, shopping, food_prep, housekeeping,
                                          laundry, transport, medication, finances, iadl_score),
                            by = c('individual_id', 'site', 'event_name')) %>%
## Modified CHarlson Co-Morbidity
                   full_join(.,
                             dplyr::select(master$modified_charlson_comorbidity,
                                           individual_id, site, event_name, event_date, ## database_id,
                                           age, aids, cerebrovascular, pulmonary, heart_failure,
                                           connective_tissue, dementia, hemiplegia, leukemia,
                                           lymphoma, myocardial, perpheral_vascular, diabetes,
                                           liver_diease, renal_disease, malignant_tumour,
                                           cci_score, cci_probability),
                             by = c('individual_id', 'site', 'event_name')) %>%
## ## Chemotherapy - Chemotherapy
## ## TODO - Convert to wide first
##            full_join(.,
##                      dplyr::select(master$chemotherapy_chemotherapy,
##                                    individual_id, site, event_name, event_date, ## database_id,
##                                    )) %>%
## ECOG Performance
                  full_join(.,
                            dplyr::select(master$ecog_performance_status_score,
                                          individual_id, site, event_name, event_date, ## database_id,
                                          ecog_grade),
                            by = c('individual_id', 'site', 'event_name')) %>%
## ##
##            full_join(.,
                     ## dplyr::select(master$chemotherapy_chemotherapy,
                     ##               individual_id, site, event_name, event_date, ## database_id,
                     ##               )) %>%

###################################################################################
## Combine questionnaires and therapy assessments made at multiple time points   ##
###################################################################################
## EORTC-QLQ-C30 and EORTC-QLQ-BR23
master$therapy_qol <- full_join(dplyr::select(master$eortc_qlq_c30,
                                              individual_id, site, event_name, event_date, database_id,
                                              c30_q1,  c30_q2,  c30_q3,  c30_q4,  c30_q5,
                                              c30_q6,  c30_q7,  c30_q8,  c30_q9,  c30_q10,
                                              c30_q11, c30_q12, c30_q13, c30_q14, c30_q15,
                                              c30_q16, c30_q17, c30_q18, c30_q19, c30_q20,
                                              c30_q21, c30_q22, c30_q23, c30_q24, c30_q25,
                                              c30_q26, c30_q27, c30_q28, c30_q29, c30_q30,
                                              ql_raw, ql_scale, pf_raw,
                                              pf_scale, rf_raw, rf_scale, ef_raw, ef_scale, cf_raw,
                                              cf_scale, sf_raw, sf_scale, fa_raw, fa_scale, nv_raw,
                                              nv_scale, pa_raw, pa_scale, dy_scale, sl_scale, ap_scale,
                                              co_scale, di_scale, fi_scale),
                                dplyr::select(master$eortc_qlq_br23,
                                              individual_id, site, event_name, event_date, database_id,
                                              br23_q31, br23_q32, br23_q33, br23_q34, br23_q35,
                                              br23_q36, br23_q37, br23_q38, br23_q39, br23_q40, br23_q41,
                                              br23_q42, br23_q43, br23_q44, br23_q45, br23_q46, br23_q47,
                                              br23_q48, br23_q49, br23_q50, br23_q51, br23_q52, br23_q53,
                                              brbi_raw, brbi_scale, brsef_raw, brsef_scale, brsee_scale, brfu_scale,
                                              brst_raw, brst_scale, brbs_raw, brbs_scale, bras_raw, bras_scale,
                                              brhl_scale),
                                by = c('individual_id', 'site', 'event_name', 'event_date')) %>%
## EORTC-QLQ-ELD15
                      full_join(.,
                                dplyr::select(master$eortc_qlq_eld15,
                                              individual_id, site, event_name, event_date, ## database_id,
                                              eld15_q54, eld15_q55, eld15_q56, eld15_q57, eld15_q58,
                                              eld15_q59, eld15_q60, eld15_q61, eld15_q62, eld15_q63, eld15_q64,
                                              eld15_q65, eld15_q66, eld15_q67, eld15_q68, mo_raw, mo_scale,
                                              wao_raw, wao_scale, wo_raw, wo_scale, mp_raw, mp_scale,
                                              boi_raw, boi_scale, js_scale, fs_scale),
                                by = c('individual_id', 'site', 'event_name', 'event_date')) %>%
## EQ5D
                      full_join(.,
                                dplyr::select(master$eq5d,
                                              individual_id, site, event_name, event_date, ## database_id,
                                              mobility, self_care, usual_activity, pain_discomfort,
                                              anxiety_depression, health_today, eq5d_number, eq5d_score),
                                by = c('individual_id', 'site', 'event_name', 'event_date')) %>%
## Therapy Assessment
                      full_join(.,
                                dplyr::select(master$therapy_assessment,
                                              individual_id, site, event_name, event_date, ## database_id,
                                              any_treatment, endocrine_therapy, radiotherapy,
                                              chemotherapy, trastuzumab, surgery),
                                by = c('individual_id', 'site', 'event_name', 'event_date')) %>%
## Endocrine Therapy
                      full_join(.,
                                dplyr::select(master$endocrine_therapy,
                                              individual_id, site, event_name, event_date, ## database_id,
                                              primary_adjuvant, reason_pet, reason_pet_risk,
                                              reason_pet_spcfy, endocrine_type, endocrine_type_oth,
                                              therapy_changed, therapy_changed_dtls,
                                              compliance, endocrine_aes, et_hot_flushes, et_asthenia,
                                              et_joint_pain, et_vaginal_dryness, et_hair_thinning, et_rash,
                                              et_nausea, et_diarrhoea, et_headache, et_vaginal_bleeding,
                                              et_vomiting, et_somnolence),
                                by = c('individual_id', 'site', 'event_name', 'event_date')) %>%
## Radiotherapy
                      full_join(.,
                                dplyr::select(master$radiotherapy,
                                              individual_id, site, event_name, event_date, ## database_id,
                                              which_breast_right_o, which_breast_left_o, r_site_breast_o,
                                              r_site_axilla_o, r_site_supraclavicular_o, r_site_chest_wall_o,
                                              r_site_other_o, r_breast_fractions, r_axilla_fractions,
                                              r_supra_fractions, r_chest_fractions, r_other_fractions,
                                              r_radiotherapy_aes,
                                              l_site_breast_o, l_site_axilla_o, l_site_supraclavicular_o,
                                              l_site_chest_wall_o, l_site_other_o, l_breast_fractions,
                                              l_axilla_fractions, l_supra_fractions, l_chest_fractions,
                                              l_other_fractions, l_radiotherapy_aes,
                                              r_skin_erythema, r_pain, r_breast_oedema, r_breast_shrink,
                                              r_breast_pain, l_skin_erythema, l_pain, l_breast_oedema,
                                              l_breast_shrink, l_breast_pain),
                                by = c('individual_id', 'site', 'event_name', 'event_date')) %>%
## Chemotherapy
                      full_join(.,
                                dplyr::select(master$chemotherapy,
                                              individual_id, site, event_name, event_date, ## database_id,
                                              chemo_received, chemo_aes,
                                              c_fatigue, c_anaemia, c_low_wc_count, c_thrombocytopenia, c_allergic,
                                              c_hair_thinning, c_nausea, c_infection),
                                by = c('individual_id', 'site', 'event_name', 'event_date')) %>%
## Clinical Assessment Non-Pet
                      full_join(.,
                                dplyr::select(master$clinical_assessment_non_pet,
                                              individual_id, site, event_name, event_date, ## database_id,
                                              recurrence, recurrence_dt, recurrence_where_breast_o,
                                              recurrence_where_chest_wall_o, recurrence_where_axilla_o,
                                              recurrence_where_metastatic_o, recurrence_met_bone_o,
                                              recurrence_met_liver_o, recurrence_met_lung_o,
                                              recurrence_met_superclavicular_o, recurrence_met_brain_o
                                              recurrence_met_other_o,
                                              recurrence_met_spcfy, new_tumour_yn, new_tumour_dtls,
                                              clinical_plan, plan_local_surgery_o, plan_local_radio_o,
                                              plan_local_endocrine_o, plan_local_chemo_o, plan_local_trast_o,
                                              plan_local_oth_o, plan_local_spcfy, plan_met_radio_o,
                                              plan_met_endocrine_o, plan_met_chemo_o, plan_met_trast_o,
                                              plan_met_oth_o, plan_met_spcfy, plan_routine_surgery_o,
                                              plan_routine_radio_o, plan_routine_endocrine_o, plan_routine_chemo_o,
                                              plan_routine_trast_o, plan_routine_oth_o, plan_routine_spcfy),
                                by = c('individual_id', 'site', 'event_name', 'event_date')) %>%
## Trastuzumab
                      full_join(.,
                                dplyr::select(master$trastuzumab,
                                              individual_id, site, event_name, event_date, ## database_id,
                                              trast_received, infusion_no, trast_aes, t_cardiac_fail,
                                              t_flu_like, t_nausea, t_diarrhoea, t_headache, t_allergy),
                                by = c('individual_id', 'site', 'event_name', 'event_date'))


###################################################################################
## Combine the RCT components                                                    ##
###################################################################################
master$rct <- full_join(dplyr::select(master$treatment_decision_support_consultations,
                                      individual_id, site, event_name, event_date, ## database_id,
                                      surg_pet_consult, surg_pet_consult_dt, surg_pet_offer,
                                      surg_pet_follow, chemo_no_consult, chemo_no_consult_dt,
                                      chemo_no_offer, chemo_no_follow),
                        dplyr::select(master$treatment_decision_support_consultations,
                                      individual_id, site, event_name, event_date, ## database_id,
                                      trt_opt_discussed, odt_staff_used,
                                      odt_staff_used_no_not_time_o, odt_staff_used_no_pt_not_suit_o,
                                      odt_staff_used_no_staff_not_like_o, odt_staff_used_no_no_access_o,
                                      odt_staff_used_no_already_decide_o, odt_staff_used_no_oth_o,
                                      odt_staff_used_no_oth, odt_pt_shown, odt_pt_shown_no_not_time_o,
                                      odt_pt_shown_no_pt_not_suit_o, odt_pt_shown_no_staff_not_like_o,
                                      odt_pt_shown_no_no_access_o, odt_pt_shown_no_distressed_o,
                                      odt_pt_shown_no_not_understood_o, odt_pt_shown_no_decided_o,
                                      odt_pt_shown_no_fam_reluctant_o, odt_pt_shown_no_oth_o,
                                      odt_pt_shown_no_oth, odt_taken_home, odt_taken_home_no_not_time_o,
                                      odt_taken_home_no_pt_not_suit_o, odt_taken_home_no_staff_not_like_o,
                                      odt_taken_home_no_no_access_o, odt_taken_home_no_not_offer_o,
                                      odt_taken_home_no_distressed_o, odt_taken_home_no_not_understood_o,
                                      odt_taken_home_no_decided_o, odt_taken_home_no_pt_reluctant_o,
                                      odt_taken_home_no_fam_reluctant_o, odt_taken_home_no_oth_o,
                                      odt_taken_home_no_oth, og_staff_used, og_staff_used_no_not_time_o,
                                      og_staff_used_no_pt_not_suit_o, og_staff_used_no_staff_not_like_o,
                                      og_staff_used_no_not_avail_o, og_staff_used_no_distressed_o,
                                      og_staff_used_no_not_understood_o, og_staff_used_no_decided_o,
                                      og_staff_used_no_pt_reluctant_o, og_staff_used_no_fam_reluctant_o,
                                      og_staff_used_no_oth_o, og_staff_used_no_oth, og_taken_home,
                                      og_taken_home_no_not_time_o, og_taken_home_no_pt_not_suit_o,
                                      og_taken_home_no_staff_not_like_o, og_taken_home_no_not_avail_o,
                                      og_taken_home_no_not_offer_o, og_taken_home_no_distressed_o,
                                      og_taken_home_no_not_understood_o, og_taken_home_no_decided_o,
                                      og_taken_home_no_pt_reluctant_o, og_taken_home_no_fam_reluctant_o,
                                      og_taken_home_no_oth_o, og_taken_home_no_oth, b_staff_used,
                                      b_staff_used_no_not_time_o, b_staff_used_no_pt_not_suit_o,
                                      b_staff_used_no_staff_not_like_o, b_staff_used_no_not_avail_o,
                                      b_staff_used_no_distressed_o, b_staff_used_no_not_understood_o,
                                      b_staff_used_no_decided_o, b_staff_used_no_pt_reluctant_o,
                                      b_staff_used_no_fam_reluctant_o, b_staff_used_no_oth_o,
                                      b_staff_used_no_oth, b_taken_home, b_taken_home_no_not_time_o,
                                      b_taken_home_no_pt_not_suit_o, b_taken_home_no_staff_not_like_o,
                                      b_taken_home_no_not_avail_o, b_taken_home_no_not_offer_o,
                                      b_taken_home_no_distressed_o, b_taken_home_no_not_understood_o,
                                      b_taken_home_no_decided_o, b_taken_home_no_pt_reluctant_o,
                                      b_taken_home_no_fam_reluctant_o, b_taken_home_no_oth_o, b_taken_home_no_oth),
                        by = c('individual_id', 'site', 'event_name'))

###################################################################################
## Combine baseline and multiple timepoints into one coherent data frame         ##
###################################################################################
age_gap <- full_join(master$therapy_qol,
                     master$baseline,
                     by = c('individual_id', 'site', 'event_name'))

###################################################################################
## Check for duplicates that might have arisen                                   ##
###################################################################################
master$duplicates <- age_gap %>%
                     group_by(individual_id, site, event_name, event_date) %>%
                     summarise(n = n())


###################################################################################
## Tidy data, deriving variables, removing outliers etc                          ##
###################################################################################
## Convert all weights to same units (kg)
age_gap <- age_gap %>%
           mutate(weight_current_kg = ifelse(is.na(weight_current_kg),
                                             yes = 0.453592 * ((weight_current_st * 14) + weight_current_lb),
                                             no  = weight_current_kg),
                  weight_1m_kg = ifelse(is.na(weight_1m_kg),
                                        yes = 0.453592 * ((weight_1m_st * 14) + weight_1m_lb),
                                        no  = weight_1m_kg),
                  weight_6m_kg = ifelse(is.na(weight_6m_kg),
                                        yes = 0.453592 * ((weight_6m_st * 14) + weight_6m_lb),
                                        no  = weight_6m_kg)) %>%
## QUESTION : If current weight missing are 1/6 months ago to be used instead?
           mutate(weight_kg = case_when(!is.na(.$weight_current_kg) ~ .$weight_current_kg,
                                        is.na(.$weight_current_kg) & !is.na(.$weight_1m_kg) ~ .$weight_1m_kg,
                                        is.na(.$weight_current_kg) & is.na(.$weight_1m_kg) & !is.na(.$weight_6m_kg) ~ .$weight_6m_kg)) %>%
## Convert all heights to same units (cm)
           mutate(height_cm = ifelse(is.na(height_cm),
                                     yes = 2.54 * ((height_ft * 12) + height_in),
                                     no  = height_cm)) %>%
## Derive BMI
           mutate(bmi = weight_kg / (height_cm /100)^2) %>%
## Age based on Date of Birth
           mutate(age_exact = consent_dt - dob) %>%
## Elapsed time from consent/randomisation to noted event
           group_by(individual_id) %>%
           mutate(start_date = min(consent_dt, na.rm = TRUE),
                  elapsed    = interval(event_date, start_date)) %>%
           dplyr::select(-start_date) %>%
           ungroup()

###################################################################################
## README files describing all variables                                         ##
###################################################################################
master$README <- names(master)
names(master$README) <- c('data_frame')

###################################################################################
## Save and Export                                                               ##
###################################################################################
save(master,
     file = '../data/age-gap.RData',
     compression_level = 9)
## write_dta(age_gap, version = 14, path = 'stata/age_gap.dta')
