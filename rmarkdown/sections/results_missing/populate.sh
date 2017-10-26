#!/bin/bash
## Filename    : populate.sh
## Author      : n.shephard@sheffield.ac.uk
## Description : A Bash-script for generating analysis files from templates.
##               Eases work/maintenance as any change is made to the *_template.Rmd
##               and then propogated to specific files by running this script.
##               Much work is repetition, tables/graphs grouped by one variable, then
##               another, so templates are created and parsed from this script using
##               sed[1][2] to produce individual files for each grouing variable.
##
## Usage       : This script works under GNU/Linux.  If you are using M$-Win then
##               install and use Cygwin[2]
##
## [1] http://sed.sourceforge.net/
## [2] http://sed.sourceforge.net/sed1line.txt
## [3] https://cygwin.com/

## Analysis/Output : Cohort Tables
## Template        : ../sections/results_cohort/summary_template.Rmd
## Groups          : chemotherapy
##                   radiotherapy
##                   endocrine_therapy
##                   surgery
##                   trastuzumab
##
## Comment         :
## EQ5D
sed -e 's/template/eq5d/g'                 patterns_template.Rmd \
    -e 's/TEMPLATE/individual_id, event_name, site, mobility, self_care, usual_activity, pain_discomfort, anxiety_depression, health_today, eq5d_number, eq5d_score/g'       > patterns_eq5d.Rmd
## EORTC QLQ C30
sed -e 's/template/erotc_qlq_c30/g'        patterns_template.Rmd \
    -e 's/TEMPLATE/individual_id, event_name, site, c30_q1,  c30_q2,  c30_q3,  c30_q4,  c30_q5, c30_q6,  c30_q7,  c30_q8,  c30_q9,  c30_q10, c30_q11, c30_q12, c30_q13, c30_q14, c30_q15, c30_q16, c30_q17, c30_q18, c30_q19, c30_q20, c30_q21, c30_q22, c30_q23, c30_q24, c30_q25, c30_q26, c30_q27, c30_q28, c30_q29, c30_q30, ql_raw, ql_scale, pf_raw, pf_scale, rf_raw, rf_scale, ef_raw, ef_scale, cf_raw, cf_scale, sf_raw, sf_scale, fa_raw, fa_scale, nv_raw, nv_scale, pa_raw, pa_scale, dy_scale, sl_scale, ap_scale, co_scale, di_scale, fi_scale/g'       > patterns_eortc_qlq_c30.Rmd
## EORTC QLQ BR23
sed -e 's/template/erotc_qlq_br23/g'       patterns_template.Rmd \
    -e 's/TEMPLATE/individual_id, event_name, site, br23_q31, br23_q32, br23_q33, br23_q34, br23_q35, br23_q36, br23_q37, br23_q38, br23_q39, br23_q40, br23_q41, br23_q42, br23_q43, br23_q44, br23_q45, br23_q46, br23_q47, br23_q48, br23_q49, br23_q50, br23_q51, br23_q52, br23_q53, brbi_raw, brbi_scale, brsef_raw, brsef_scale, brsee_scale, brfu_scale, brst_raw, brst_scale, brbs_raw, brbs_scale, bras_raw, bras_scale, brhl_scale/g'       > patterns_eortc_qlq_br23.Rmd
## EORTC QLQ ELD15
sed -e 's/template/eortc_qlq_eld15/g'      patterns_template.Rmd \
    -e 's/TEMPLATE/individual_id, event_name, site, eld15_q54, eld15_q55, eld15_q56, eld15_q57, eld15_q58, eld15_q59, eld15_q60, eld15_q61, eld15_q62, eld15_q63, eld15_q64, eld15_q65, eld15_q66, eld15_q67, eld15_q68, mo_raw, mo_scale, wao_raw, wao_scale, wo_raw, wo_scale, mp_raw, mp_scale, boi_raw, boi_scale, js_scale, fs_scale/g'       > patterns_eortc_qlq_eld15.Rmd
## Thearpy Assessment
sed -e 's/template/therapy_assessment/g'   patterns_template.Rmd \
    -e 's/TEMPLATE/individual_id, event_name, site, any_treatment, endocrine_therapy, radiotherapy, chemotherapy, trastuzumab, surgery/g'       > patterns_therapy_assessment.Rmd
## Endocrine Therapy
sed -e 's/template/endocrine_therapy/g'    patterns_template.Rmd \
    -e 's/TEMPLATE/individual_id, event_name, site, primary_adjuvant, reason_pet, reason_pet_risk, reason_pet_spcfy, endocrine_type, endocrine_type_oth, therapy_changed, therapy_changed_dtls, compliance, endocrine_aes, et_hot_flushes, et_asthenia, et_joint_pain, et_vaginal_dryness, et_hair_thinning, et_rash, et_nausea, et_diarrhoea, et_headache, et_vaginal_bleeding, et_vomiting, et_somnolence/g'       > patterns_endocrine_therapy.Rmd
## Chemotherapy
sed -e 's/template/chemotherapy/g'        patterns_template.Rmd \
    -e 's/TEMPLATE/individual_id, event_name, site, chemo_received, chemo_aes, c_fatigue, c_anaemia, c_low_wc_count, c_thrombocytopenia, c_allergic, c_hair_thinning, c_nausea, c_infection/g'      > patterns_chemotherapy.Rmd
## Radiotherapy
sed -e 's/template/radiotherapy/g'        patterns_template.Rmd \
    -e 's/TEMPLATE/individual_id, event_name, site, which_breast_right_radio, which_breast_left_radio, r_site_breast, r_site_axilla, r_site_supraclavicular, r_site_chest_wall, r_site_other, r_breast_fractions, r_axilla_fractions, r_supra_fractions, r_chest_fractions, r_other_fractions, r_radiotherapy_aes, l_site_breast, l_site_axilla, l_site_supraclavicular, l_site_chest_wall, l_site_other, l_breast_fractions, l_axilla_fractions, l_supra_fractions, l_chest_fractions, l_other_fractions, l_radiotherapy_aes, r_skin_erythema, r_pain, r_breast_oedema, r_breast_shrink, r_breast_pain, l_skin_erythema, l_pain, l_breast_oedema, l_breast_shrink, l_breast_pain/g'      > patterns_radiotherapy.Rmd
## Trastuzumab
sed -e 's/template/trastuzumab/g'         patterns_template.Rmd \
    -e 's/TEMPLATE/individual_id, event_name, site, trast_received, infusion_no, trast_aes, t_cardiac_fail, t_flu_like, t_nausea, t_diarrhoea, t_headache, t_allergy/g'      > patterns_trastuzumab.Rmd
## Surgery
sed -e 's/template/surgery/g'             patterns_template.Rmd \
    -e 's/TEMPLATE/individual_id, event_name, site, general_local, which_breast_right_surgery, which_breast_left_surgery, r_surgery_type, r_axillary_type, r_surgery_aes_acute, r_sa_haemorrhage, r_sa_seroma, r_sa_haematoma, r_sa_infection, r_sa_necrosis, r_sa_wound, r_surgery_aes_chronic, r_sc_wound_pain, r_sc_functional_diff, r_sc_neuropathy, r_sc_lymphoedema, r_tumour_size, r_allred, r_h_score, r_her_2_score, r_onco_offered, r_onco_used, r_risk_score, r_tumour_type, r_tumour_grade, r_margins_clear, r_margin, r_designation_anterior, r_designation_posterior, r_designation_lateral, r_designation_medial, r_designation_superior, r_designation_inferior, r_close_margin, r_nodes_excised, r_nodes_involved, l_surgery_type, l_axillary_type, l_surgery_aes_acute, l_sa_haemorrhage, l_sa_seroma, l_sa_haematoma, l_sa_infection, l_sa_necrosis, l_sa_wound, l_surgery_aes_chronic, l_sc_wound_pain, l_sc_functional_diff, l_sc_neuropathy, l_sc_lymphoedema, l_tumour_size, l_allred, l_h_score, l_her_2_score, l_onco_offered, l_onco_used, l_risk_score, l_tumour_type, l_tumour_grade, l_margins_clear, l_margin, l_designation_anterior, l_designation_posterior, l_designation_lateral, l_designation_medial, l_designation_superior, l_designation_inferior, l_close_margin, l_nodes_excised, l_nodes_involved/g'      > patterns_surgery.Rmd
## Clinical Assessment PET
sed -e 's/template/clinical_assessment_pet/g'        patterns_template.Rmd \
    -e 's/TEMPLATE/individual_id, event_name, site, uni_bilateral_pet, primary_tumour_pet, r_focal_pet, r_num_tumours_pet, r_cancer_palpable_pet, r_size_clin_assess_pet, r_method_assess_pet, r_size_ultrasound_pet, r_size_mammo_pet, r_axillary_present_pet, r_axillary_nodes_pet, r_axillary_axis_pet, l_focal_pet, l_num_tumours_pet, l_cancer_palpable_pet, l_size_clin_assess_pet, l_method_assess_pet, l_size_ultrasound_pet, l_size_mammo_pet, l_axillary_present_pet, l_axillary_nodes_pet, l_axillary_axis_pet, metastatic, metastatic_where_bone, metastatic_where_lung, metastatic_where_cervical_node, metastatic_where_other, metastatic_where_liver, metastatic_where_brain, proposed_treat, clinical_plan2, plan_change_surgery, plan_change_radio, plan_change_antioestrogen, plan_change_other,plan_change_spcfy/g'      > patterns_clinical_assessment_pet.Rmd
## Clinical Assessment Non-PET
sed -e 's/template/clinical_assessment_non_pet/g'        patterns_template.Rmd \
    -e 's/TEMPLATE/individual_id, event_name, site, recurrence, recurrence_dt, recurrence_where_breast, recurrence_where_chest_wall, recurrence_where_axilla, recurrence_where_metastatic, recurrence_met_bone, recurrence_met_liver, recurrence_met_lung, recurrence_met_superclavicular, recurrence_met_brain, recurrence_met_other, recurrence_met_spcfy, new_tumour_yn, new_tumour_dtls, clinical_plan, plan_local_surgery, plan_local_radio, plan_local_endocrine, plan_local_chemo, plan_local_trast, plan_local_other, plan_local_spcfy, plan_met_radio, plan_met_endocrine, plan_met_chemo, plan_met_trast, plan_met_other, plan_met_spcfy, plan_routine_surgery, plan_routine_radio, plan_routine_endocrine, plan_routine_chemo, plan_routine_trast, plan_routine_other, plan_routine_spcfy/g'      > patterns_clinical_assessment_non_pet.Rmd
## Collaborate
sed -e 's/template/collaborate/g'       patterns_template.Rmd \
    -e 's/TEMPLATE/individual_id, event_name, site, understand_issues, listen_to_issues, matters_most, collaborate_calc_score/g'     > patterns_collaborate.Rmd
## Breast Cancer Treatment Choices Surgery v Endocrine Therapy
sed -e 's/template/breast_cancer_treatment_choices_surgery_pills/g'       patterns_template.Rmd \
    -e 's/TEMPLATE/individual_id, event_name, site, hblock_chemo, surg_no_hblock, hblock_hosp_chk, hblock_stop, hblock_stay_alive, hblock_change, surg_swell, need_radio, know_enough_surgery_pills, aware_surgery_pills, option_pref_surgery_pills, decision_surgery_pills, moment_think_surgery_pills, influence_dcsn_int_no_dec_surgery_pills, influence_dcsn_int_tlk_fam_surgery_pills, influence_dcsn_int_rd_bklt_surgery_pills, influence_dcsn_int_rd_other_surgery_pills, influence_dcsn_int_opt_grd_surgery_pills, influence_dcsn_int_tlk_hlth_prof_surgery_pills, influence_dcsn_int_tlk_gp_surgery_pills, influence_dcsn_int_tlk_oth_pts_surgery_pills, influence_dcsn_int_other_surgery_pills, other_int_surgery_pills, influence_dcsn_cont_no_dec_surgery_pills, influence_dcsn_cont_tlk_fam_surgery_pills, influence_dcsn_cont_rd_other_surgery_pills, influence_dcsn_cont_tlk_hlth_prof_surgery_pills, influence_dcsn_cont_tlk_gp_surgery_pills, influence_dcsn_cont_tlk_oth_pts_surgery_pills, influence_dcsn_cont_other_surgery_pills, other_cont_surgery_pills/g'     > patterns_.Rmd
## Breast Cancer Treatment Choices - chemo vs no chemo
sed -e 's/template/breast_cancer_treatment_choices_chemo_no_chemo/g'       patterns_template.Rmd \
    -e 's/TEMPLATE/individual_id, event_name, site, inc_long_term, not_visit_people, hair_never_regrows, herceptin, chemo_vein, chemo_infect, feel_tired_unwell, over_3m_6m, no_meds_nausea, pills_radio_not_chemo, know_enough_chemo_no_chemo, aware_chemo_no_chemo, option_pref_chemo_no_chemo, decision_chemo_no_chemo, moment_think_chemo_no_chemo, influence_dcsn_int_no_dec_chemo_no_chemo, influence_dcsn_int_tlk_fam_chemo_no_chemo, influence_dcsn_int_rd_bklt_chemo_no_chemo, influence_dcsn_int_rd_other_chemo_no_chemo, influence_dcsn_int_opt_grd_chemo_no_chemo, influence_dcsn_int_tlk_hlth_prof_chemo_no_chemo, influence_dcsn_int_tlk_gp_chemo_no_chemo, influence_dcsn_int_tlk_oth_pts_chemo_no_chemo, influence_dcsn_int_other_chemo_no_chemo, other_int_chemo_no_chemo, influence_dcsn_cont_no_dec_chemo_no_chemo, influence_dcsn_cont_tlk_fam_chemo_no_chemo, influence_dcsn_cont_rd_other_chemo_no_chemo, influence_dcsn_cont_tlk_hlth_prof_chemo_no_chemo, influence_dcsn_cont_tlk_gp_chemo_no_chemo, influence_dcsn_cont_tlk_oth_pts_chemo_no_chemo, influence_dcsn_cont_other_chemo_no_chemo, other_cont_chemo_no_chemo/g'     > patterns_.Rmd
## Spielberge state trait anxiety
sed -e 's/template/spielberger_state_trait_anxiety/g'       patterns_template.Rmd \
    -e 's/TEMPLATE/individual_id, event_name, site, calm, tense, upset, relaxed, content, worried/g'     > patterns_.Rmd
## Brief Cope
sed -e 's/template/brief_cope/g'       patterns_template.Rmd \
    -e 's/TEMPLATE/individual_id, event_name, site, do_something, isnt_real, support_from_others, giving_up_dealing, taking_action, refuse_to_believe, help_from_others, different_light, strategy_to_do, comfort_someone, giving_up_coping, steps_to_take, accepting_reality, advice_from_others, live_with_it, looking_for_good/g'     > patterns_.Rmd
## Brief Illness Percetion Questionnaire
sed -e 's/template/the_brief_illness_perception_questionnaire/g'       patterns_template.Rmd \
    -e 's/TEMPLATE/individual_id, event_name, site, ill_affect, ill_continue, ill_control, ill_treatment, ill_symptoms, ill_concern, ill_understand, ill_emotion/g'     > patterns_.Rmd
## Discussing Treatment Options
sed -e 's/template//g'       patterns_template.Rmd \
    -e 's/TEMPLATE/individual_id, event_name, site, discussing_treatment_options, individual_id, site, event_name, ## event_date, database_id, spoke_trt_option_hosp_dr, spoke_trt_option_hosp_nurse, spoke_trt_option_helpline_dr, spoke_trt_option_practice_gp, spoke_trt_option_other, spoke_trt_option_oth, booklet_provided, booklet_yes_int_risk_info, booklet_yes_int_grid, booklet_yes_int_booklet, booklet_yes_int_other, booklet_yes_int_oth, booklet_yes_cont, info_taken_read_all, info_taken_read_some, info_taken_not_read, info_taken_showed_fam, info_taken_blank_sec, info_taken_other, info_taken_oth, info_useful, risk_info, option_grid, booklet_info, booklet_my_decision, info_thoughts/g'     > patterns_.Rmd
## Decision Regret Scale
sed -e 's/template/decision_regret_scale/g'       patterns_template.Rmd \
    -e 's/TEMPLATE/individual_id, event_name, site, right_decision, regret_choice, same_if_do_over, choice_did_harm, wise_decision, decision_regret_scale_calc_score/g'     > patterns_.Rmd
