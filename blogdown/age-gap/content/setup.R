## Sets up some key components
all_var <- list()
all_var$eortc_c30 <- c(c30_q1, c30_q2, c30_q3, c30_q4, c30_q5,
                         c30_q6, c30_q7, c30_q8, c30_q9, c30_q10,
                         c30_q11, c30_q12, c30_q13, c30_q14, c30_q15,
                         c30_q16, c30_q17, c30_q18, c30_q19, c30_q20,
                         c30_q21, c30_q22, c30_q23, c30_q24, c30_q25,
                         c30_q26, c30_q27, c30_q28, c30_q29, c30_q30,
                         ql_raw, ql_scale, pf_raw, pf_scale, rf_raw, rf_scale,
                         ef_raw,ef_scale, cf_raw,cf_scale, sf_raw,sf_scale,
                         fa_raw,fa_scale, nv_raw,nv_scale, pa_raw,pa_scale,
                         dy_scale, sl_scale, ap_scale, co_scale, di_scale, fi_scale)
all_var$eortc_br23 <- c(br23_q31, br23_q32, br23_q33, br23_q34, br23_q35,
                          br23_q36, br23_q37, br23_q38, br23_q39, br23_q30,
                          br23_q31, br23_q32, br23_q33, br23_q34, br23_q35,
                          br23_q36, br23_q37, br23_q38, br23_q39, br23_q40,
                          br23_q41, br23_q42, br23_q43, br23_q44, br23_q45,
                          br23_q46, br23_q47, br23_q48, br23_q49, br23_q50,
                          br23_q51, br23_q52, br23_q53,
                          brbi_raw, brbi_scale, brsef_raw, brsef_scale, brsee_scale, brfu_scale,
                          brst_raw, brst_scale, brbs_raw, brbs_scale, bras_raw, bras_scale,
                          brhl_scale)
all_var$eortc_eld15 <- c(eld15_q54, eld15_q55, eld15_q56, eld15_q57, eld15_q58,
                                              eld15_q59, eld15_q60, eld15_q61, eld15_q62, eld15_q63, eld15_q64,
                                              eld15_q65, eld15_q66, eld15_q67, eld15_q68, mo_raw, mo_scale,
                                              wao_raw, wao_scale, wo_raw, wo_scale, mp_raw, mp_scale,
                                              boi_raw, boi_scale, js_scale, fs_scale)
all_var$eq5d <- c(mobility, self_care, usual_activity, pain_discomfort,
                    anxiety_depression, health_today, eq5d_number, eq5d_score)
all_var$therapy_assessment <- c(any_treatment, endocrine_therapy, radiotherapy,
                                              chemotherapy, trastuzumab, surgery)
all_var$endocrine_therapy <- c(primary_adjuvant, reason_pet, reason_pet_risk,
                                 reason_pet_spcfy, endocrine_type, endocrine_type_oth,
                                 therapy_changed, therapy_changed_dtls,
                                 compliance, endocrine_aes, et_hot_flushes, et_asthenia,
                                 et_joint_pain, et_vaginal_dryness, et_hair_thinning, et_rash,
                                 et_nausea, et_diarrhoea, et_headache, et_vaginal_bleeding,
                                 et_vomiting, et_somnolence)
all_var$radiotherapy <- c(which_breast_right_o, which_breast_left_o, r_site_breast_o,
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
                            l_breast_shrink, l_breast_pain)
all_var$chemotherapy <- c(chemo_received, chemo_aes,
                            c_fatigue, c_anaemia, c_low_wc_count, c_thrombocytopenia, c_allergic,
                            c_hair_thinning, c_nausea, c_infection)
all_var$trastuzumab <- c(trast_received, infusion_no, trast_aes, t_cardiac_fail,
                                              t_flu_like, t_nausea, t_diarrhoea, t_headache, t_allergy)
all_var$clinical_assessment_non_pet <- c(recurrence, recurrence_dt, recurrence_where_breast_o,
                                           recurrence_where_chest_wall_o, recurrence_where_axilla_o,
                                           recurrence_where_metastatic_o, recurrence_met_bone_o,
                                           recurrence_met_liver_o, recurrence_met_lung_o,
                                           recurrence_met_superclavicular_o, recurrence_met_brain_o,
                                           recurrence_met_other_o,
                                           recurrence_met_spcfy, new_tumour_yn, new_tumour_dtls,
                                           clinical_plan, plan_local_surgery_o, plan_local_radio_o,
                                           plan_local_endocrine_o, plan_local_chemo_o, plan_local_trast_o,
                                           plan_local_oth_o, plan_local_spcfy, plan_met_radio_o,
                                           plan_met_endocrine_o, plan_met_chemo_o, plan_met_trast_o,
                                           plan_met_oth_o, plan_met_spcfy, plan_routine_surgery_o,
                                           plan_routine_radio_o, plan_routine_endocrine_o, plan_routine_chemo_o,
                                           plan_routine_trast_o, plan_routine_oth_o, plan_routine_spcfy)
all_var$clinical_assessment_pet <- c(uni_bilateral, primary_tumour, r_focal,
                                       r_num_tumours, r_cancer_palpable, r_size_clin_assess,
                                       r_method_assess, r_size_ultrasound,r_size_mammo,
                                       r_axillary_present, r_axillary_nodes, r_axillary_axis,
                                       l_focal, l_num_tumours, l_cancer_palpable,
                                       l_size_clin_assess, l_method_assess, l_size_ultrasound,
                                       l_size_mammo, l_axillary_present, l_axillary_nodes,
                                       l_axillary_axis, metastatic, metastatic_where_bone_o,
                                       metastatic_where_lung_o, metastatic_where_cervical_node_o, metastatic_where_other_o,
                                       metastatic_where_liver_o, metastatic_where_brain_o, proposed_treat,
                                       clinical_plan2, plan_change_surgery_o, plan_change_radio_o,
                                       plan_change_antioestrogen_o, plan_change_oth_o,plan_change_spcfy)

## Survey responses (i.e. categorical factor_vars)
## Sets up some key components
factor_vars <- list()
factor_vars$eortc_c30 <- c(c30_q1, c30_q2, c30_q3, c30_q4, c30_q5,
                         c30_q6, c30_q7, c30_q8, c30_q9, c30_q10,
                         c30_q11, c30_q12, c30_q13, c30_q14, c30_q15,
                         c30_q16, c30_q17, c30_q18, c30_q19, c30_q20,
                         c30_q21, c30_q22, c30_q23, c30_q24, c30_q25,
                         c30_q26, c30_q27, c30_q28, c30_q29, c30_q30)
factor_vars$eortc_br23 <- c(br23_q31, br23_q32, br23_q33, br23_q34, br23_q35,
                          br23_q36, br23_q37, br23_q38, br23_q39, br23_q30,
                          br23_q31, br23_q32, br23_q33, br23_q34, br23_q35,
                          br23_q36, br23_q37, br23_q38, br23_q39, br23_q40,
                          br23_q41, br23_q42, br23_q43, br23_q44, br23_q45,
                          br23_q46, br23_q47, br23_q48, br23_q49, br23_q50,
                          br23_q51, br23_q52, br23_q53)
factor_vars$eortc_eld15 <- c(eld15_q54, eld15_q55, eld15_q56, eld15_q57, eld15_q58,
                             eld15_q59, eld15_q60, eld15_q61, eld15_q62, eld15_q63, eld15_q64,
                             eld15_q65, eld15_q66, eld15_q67, eld15_q68)
factor_vars$eq5d <- c(eq5d_number, eq5d_score)
factor_vars$therapy_assessment <- c()
factor_vars$endocrine_therapy <- c(primary_adjuvant, reason_pet, endocrine_type,
                                   therapy_changed, compliance, endocrine_aes,
                                   et_hot_flushes, et_asthenia, et_joint_pain,
                                   et_vaginal_dryness, et_hair_thinning, et_rash,
                                   et_nausea, et_diarrhoea, et_headache, et_vaginal_bleeding,
                                   et_vomiting, et_somnolence)
factor_vars$radiotherapy <- c(l_radiotherapy_aes,
                              r_skin_erythema, r_pain, r_breast_oedema, r_breast_shrink,
                              r_breast_pain, l_skin_erythema, l_pain, l_breast_oedema,
                              l_breast_shrink, l_breast_pain)
factor_vars$chemotherapy <- c(chemo_received, chemo_aes,
                              c_fatigue, c_anaemia, c_low_wc_count, c_thrombocytopenia, c_allergic,
                              c_hair_thinning, c_nausea, c_infection)
factor_vars$trastuzumab <- c(trast_received, infusion_no, trast_aes, t_cardiac_fail,
                             t_flu_like, t_nausea, t_diarrhoea, t_headache, t_allergy)
factor_vars$clinical_assessment_non_pet <- c(recurrence, new_tumour_yn,  clinical_plan)
factor_vars$clinical_assessment_pet <- c(uni_bilateral, primary_tumour,
                                         r_focal, r_cancer_palpable, r_method_assess, r_axillary_present,
                                         l_focal, l_cancer_palpable, l_method_assess, l_axillary_present,  clinical_plan2)

## Continuous responses
## Sets up some key components
continuous_vars <- list()
continuous_vars$eortc_c30 <- c(ql_raw, ql_scale, pf_raw, pf_scale, rf_raw, rf_scale,
                          ef_raw,ef_scale, cf_raw,cf_scale, sf_raw,sf_scale,
                          fa_raw,fa_scale, nv_raw,nv_scale, pa_raw,pa_scale,
                          dy_scale, sl_scale, ap_scale, co_scale, di_scale, fi_scale)
continuous_vars$eortc_br23 <- c(brbi_raw, brbi_scale, brsef_raw, brsef_scale, brsee_scale, brfu_scale,
                           brst_raw, brst_scale, brbs_raw, brbs_scale, bras_raw, bras_scale,
                           brhl_scale)
continuous_vars$eortc_eld15 <- c(mo_raw, mo_scale,
                            wao_raw, wao_scale, wo_raw, wo_scale, mp_raw, mp_scale,
                            boi_raw, boi_scale, js_scale, fs_scale)
continuous_vars$eq5d <- c(eq5d_number, eq5d_score)
continuous_vars$therapy_assessment <- c()
continuous_vars$endocrine_therapy <- c()
continuous_vars$radiotherapy <- c(which_breast_right_o, which_breast_left_o, r_site_breast_o,
                             r_site_axilla_o, r_site_supraclavicular_o, r_site_chest_wall_o,
                             r_site_other_o, r_breast_fractions, r_axilla_fractions,
                             r_supra_fractions, r_chest_fractions, r_other_fractions,
                             r_radiotherapy_aes,
                             l_site_breast_o, l_site_axilla_o, l_site_supraclavicular_o,
                             l_site_chest_wall_o, l_site_other_o, l_breast_fractions,
                             l_axilla_fractions, l_supra_fractions, l_chest_fractions,
                             l_other_fractions)
continuous_vars$chemotherapy <- c()
continuous_vars$trastuzumab <- c(infusion_no)
continuous_vars$clinical_assessment_non_pet <- c(recurrence_dt, recurrence_where_breast_o,
                                           recurrence_where_chest_wall_o, recurrence_where_axilla_o,
                                           recurrence_where_metastatic_o, recurrence_met_bone_o,
                                           recurrence_met_liver_o, recurrence_met_lung_o,
                                           recurrence_met_superclavicular_o, recurrence_met_brain_o,
                                           recurrence_met_other_o, recurrence_met_spcfy, plan_local_surgery_o,
                                           plan_local_radio_o,
                                           plan_local_endocrine_o, plan_local_chemo_o, plan_local_trast_o,
                                           plan_local_oth_o, plan_local_spcfy, plan_met_radio_o,
                                           plan_met_endocrine_o, plan_met_chemo_o, plan_met_trast_o,
                                           plan_met_oth_o, plan_met_spcfy, plan_routine_surgery_o,
                                           plan_routine_radio_o, plan_routine_endocrine_o, plan_routine_chemo_o,
                                           plan_routine_trast_o, plan_routine_oth_o, plan_routine_spcfy)
continuous_vars$clinical_assessment_pet <- c(r_num_tumours, r_cancer_palpable, r_size_clin_assess,
                                             r_size_ultrasound,r_size_mammo,
                                             r_axillary_present, r_axillary_nodes, r_axillary_axis,
                                             l_focal, l_num_tumours, l_cancer_palpable,
                                             l_size_clin_assess, l_method_assess, l_size_ultrasound,
                                             l_size_mammo, l_axillary_present, l_axillary_nodes,
                                             l_axillary_axis, metastatic, metastatic_where_bone_o,
                                             metastatic_where_lung_o, metastatic_where_cervical_node_o, metastatic_where_other_o,
                                             metastatic_where_liver_o, metastatic_where_brain_o, proposed_treat,
                                             clinical_plan2, plan_change_surgery_o, plan_change_radio_o,
                                             plan_change_antioestrogen_o, plan_change_oth_o, plan_change_spcfy)
