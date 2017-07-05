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
master$lookups_form <- read.csv(file = 'Age Gap database specification - Forms.csv',
                                header = TRUE)
master$lookups_form <- master$lookups_form %>%
                       dplyr::select(Name, Identifier, Subforms)
names(master$lookups_form) <- names(master$lookups_form) %>% tolower()
## File   : Age Gap database specification - Forms.csv
## Source : https://goo.gl/oFBs4j
master$lookups_fields <- read.csv(file = 'Age Gap database specification - Fields.csv',
                                  header = TRUE)
master$lookups_fields <- master$lookups_fields %>%
                         dplyr::select(Form, Subform, Identifier, Label)
names(master$lookups_fields) <- names(master$lookups_fields) %>% tolower()
## Bulk out labels for numbered responses
master$lookups_fields <- master$lookups_fields %>%
                         mutate(label = ifelse(label == '1. Do you have any trouble doing strenuous activities?',
                                               yes   = paste0('0', label),
                                               no    = label),
                                label = ifelse(label == '2. Do you have any trouble taking a long walk?',
                                               yes   = paste0('0', label),
                                               no    = label),
                                label = ifelse(label == '3. Do you have any trouble taking a short walk outside of the house?',
                                               yes   = paste0('0', label),
                                               no    = label),
                                label = ifelse(label == '4. Do you need to stay in bed or a chair during the day?',
                                               yes   = paste0('0', label),
                                               no    = label),
                                label = ifelse(label == '5. Do you need help with eating, dressing, washing yourself or using the toilet?',
                                               yes   = paste0('0', label),
                                               no    = label),
                                label = ifelse(label == '6. Were you limited in doing either your work or other daily activities?',
                                               yes   = paste0('0', label),
                                               no    = label),
                                label = ifelse(label == '7. Were you limited in pursuing your hobbies or other leisure activities?',
                                               yes   = paste0('0', label),
                                               no    = label),
                                label = ifelse(label == '8. Were you short of breath?',
                                               yes   = paste0('0', label),
                                               no    = label),
                                label = ifelse(label == '9. Have you had pain?',
                                               yes   = paste0('0', label),
                                               no    = label))
## Another short-coming of Prospect, or perhaps more accurately its documentation
## is that fields that are 'Flags' are not fully documented, as they results in
## multiple variables suffixed with '[option]_o'.  This has two implicaitons...
##
## 1) Variables do not have labels available.
## 2) Such derived variables do not have factor levels/labels defined
##
## At present there is insufficient time to solve this programatically so these additional
## fields are now defined for the fields and have been added above to the master$lookups
## dataframe
master$lookups_fields <- rbind(master$lookups_fields,
                               c('Radiotherapy', '', 'which_breast_right', 'Right Breast treated with Radiotherapy'),
                               c('Radiotherapy', '', 'r_site_breast', 'Treatment Site (Right) : Breast'),
                               c('Radiotherapy', '', 'r_site_axilla', 'Treatment Site (Right) : Axilla'),
                               c('Radiotherapy', '', 'r_site_supraclavicular', 'Treatment Site (Right) : Suprclavicular'),
                               c('Radiotherapy', '', 'r_site_chest_wall', 'Treatment Site (Right) : Chest Wall'),
                               c('Radiotherapy', '', 'r_sitether', 'Treatment Site (Right) : Other'),
                               c('Radiotherapy', '', 'which_breast_left', 'Left Breast treated with Radiotherapy'),
                               c('Radiotherapy', '', 'l_site_breast', 'Treatment Site (Left) : Breast'),
                               c('Radiotherapy', '', 'l_site_axilla', 'Treatment Site (Left) : Axilla'),
                               c('Radiotherapy', '', 'l_site_supraclavicular', 'Treatment Site (Left) : Supraclavicular'),
                               c('Radiotherapy', '', 'l_site_chest_wall', 'Treatment Site (Left) : Chest Wall'),
                               c('Radiotherapy', '', 'l_sitether', 'Treatment Site (Left) : Other'),
                               c('Clinical Assessment (PET)', '', 'metastatic_where_bone', 'Metastatic : Bone'),
                               c('Clinical Assessment (PET)', '', 'metastatic_where_lung', 'Metastatic : Lung'),
                               c('Clinical Assessment (PET)', '', 'metastatic_where_cervical_node', 'Metastatic : Cervical Node'),
                               c('Clinical Assessment (PET)', '', 'metastatic_wherether', 'Metastatic : Other'),
                               c('Clinical Assessment (PET)', '', 'metastatic_where_liver', 'Metastatic : Liver'),
                               c('Clinical Assessment (PET)', '', 'metastatic_where_brain', 'Metastatic : Brain'),
                               c('Clinical Assessment (PET)', '', 'plan_change_surgery', 'Treatment plan changed due to recurrence : Surgery'),
                               c('Clinical Assessment (PET)', '', 'plan_change_radio', 'Treatment plan changed due to recurrence : Radiotherapy'),
                               c('Clinical Assessment (PET)', '', 'plan_change_antioestrogen', 'Treatment plan changed due to recurrence : Anti-oestrogen'),
                               c('Clinical Assessment (non-PET)', '', 'recurrence_where_breast', 'Recurrence : Breast'),
                               c('Clinical Assessment (non-PET)', '', 'recurrence_where_chest_wall', 'Recurrence : Chest Wall'),
                               c('Clinical Assessment (non-PET)', '', 'recurrence_where_axilla', 'Recurrence : Axilla'),
                               c('Clinical Assessment (non-PET)', '', 'recurrence_where_metastatic', 'Recurrence : Metastatic'),
                               c('Clinical Assessment (non-PET)', '', 'recurrence_where_met_bone', 'Recurrence : Bone (Metastatic)'),
                               c('Clinical Assessment (non-PET)', '', 'recurrence_where_met_liver', 'Recurrence : Liver (Metastatic'),
                               c('Clinical Assessment (non-PET)', '', 'recurrence_where_met_lung', 'Recurrence : Lung (Metastatic)'),
                               c('Clinical Assessment (non-PET)', '', 'recurrence_where_met_superclavicular', 'Recurrence : Superclavicular (Metatstatic)'),
                               c('Clinical Assessment (non-PET)', '', 'recurrence_where_met_brain', 'Recurrence : Brain (Metastatic)'),
                               c('Clinical Assessment (non-PET)', '', 'recurrence_where_metther', 'Recurrence : Other'),
                               c('Clinical Assessment (non-PET)', '', 'plan_local_surgery', 'Therapy due to local recurrence : Surgery'),
                               c('Clinical Assessment (non-PET)', '', 'plan_local_radio', 'Therapy due to local recurrence : Radiotherapy'),
                               c('Clinical Assessment (non-PET)', '', 'plan_local_endocrine', 'Therapy due to local recurrence : Endocrine Therapy'),
                               c('Clinical Assessment (non-PET)', '', 'plan_local_chemo', 'Therapy due to local recurrence : Chemotherapy'),
                               c('Clinical Assessment (non-PET)', '', 'plan_local_trast', 'Therapy due to local recurrence : Trastuzumab'),
                               c('Clinical Assessment (non-PET)', '', 'plan_localth', 'Therapy due to local recurrence : Other'),
                               c('Clinical Assessment (non-PET)', '', 'plan_met_radio', 'Therapy due to metastatic recurrence : Radiotherapy'),
                               c('Clinical Assessment (non-PET)', '', 'plan_met_endocrine', 'Therapy due to metastatic recurrence : Endocrine Therapy'),
                               c('Clinical Assessment (non-PET)', '', 'plan_met_chemo', 'Therapy due to metastatic recurrence : Chemotherapy'),
                               c('Clinical Assessment (non-PET)', '', 'plan_met_trast', 'Therapy due to metastatic recurrence : Trastuzumab'),
                               c('Clinical Assessment (non-PET)', '', 'plan_metth', 'Therapy due to metastatic recurrence : Other'),
                               c('Clinical Assessment (non-PET)', '', 'plan_routine_surgery', 'Routine Therapy : Surgery'),
                               c('Clinical Assessment (non-PET)', '', 'plan_routine_radio', 'Routine Therapy : Radiotherapy'),
                               c('Clinical Assessment (non-PET)', '', 'plan_routine_endocrine', 'Routine Therapy : Endocrine Therapy'),
                               c('Clinical Assessment (non-PET)', '', 'plan_routine_chemo', 'Routine Therapy : Chemotherapy'),
                               c('Clinical Assessment (non-PET)', '', 'plan_routine_trast', 'Routine Therapy : Trastuzumab'),
                               c('Clinical Assessment (non-PET)', '', 'plan_routineth', 'Routine Therapy : Other'),
                               c('Abridged Patient Generated Assessment', '', 'symptoms_2_week_no_problems', 'Symptoms in the Past 2 Weeks : None'),
                               c('Abridged Patient Generated Assessment', '', 'symptoms_2_week_no_appetite', 'Symptoms in the Past 2 Weeks : No Appetite'),
                               c('Abridged Patient Generated Assessment', '', 'symptoms_2_week_feeling_full', 'Symptoms in the Past 2 Weeks : Feeling Full'),
                               c('Abridged Patient Generated Assessment', '', 'symptoms_2_week_food_tasting_funny', 'Symptoms in the Past 2 Weeks : Food Tasting Funny'),
                               c('Abridged Patient Generated Assessment', '', 'symptoms_2_week_vomiting', 'Symptoms in the Past 2 Weeks : Vomiting'),
                               c('Abridged Patient Generated Assessment', '', 'symptoms_2_week_nausea', 'Symptoms in the Past 2 Weeks : Nausea'),
                               c('Abridged Patient Generated Assessment', '', 'symptoms_2_week_pain', 'Symptoms in the Past 2 Weeks : Pain'),
                               c('Abridged Patient Generated Assessment', '', 'symptoms_2_weekther', 'Symptoms in the Past 2 Weeks : Other'),
                               c('Abridged Patient Generated Assessment', '', 'symptoms_2_week_dry_mouth', 'Symptoms in the Past 2 Weeks : Dry Mouth'),
                               c('Abridged Patient Generated Assessment', '', 'symptoms_2_week_mouth_sores', 'Symptoms in the Past 2 Weeks : Mouth Sores'),
                               c('Abridged Patient Generated Assessment', '', 'symptoms_2_week_constipation', 'Symptoms in the Past 2 Weeks : Constipation'),
                               c('Abridged Patient Generated Assessment', '', 'symptoms_2_week_diarrhoea', 'Symptoms in the Past 2 Weeks : Diarrhoea'),
                               c('Abridged Patient Generated Assessment', '', 'symptoms_2_week_problems_swallowing', 'Symptoms in the Past 2 Weeks : Problems Swallowing'),
                               c('Abridged Patient Generated Assessment', '', 'symptoms_2_week_smells_bother', 'Symptoms in the Past 2 Weeks : Smells Bother'),
                               c('Breast Cancer Treatment Choices - chemo vs no chemo.csv', '', 'influence_dcsn_int_no_dec', 'What influenced you most in making your decision : No decision'),
                               c('Breast Cancer Treatment Choices - chemo vs no chemo.csv', '', 'influence_dcsn_int_tlk_fam', 'What influenced you most in making your decision : Talking to family'),
                               c('Breast Cancer Treatment Choices - chemo vs no chemo.csv', '', 'influence_dcsn_int_rd_bklt', 'What influenced you most in making your decision : Reading booklet'),
                               c('Breast Cancer Treatment Choices - chemo vs no chemo.csv', '', 'influence_dcsn_int_rdth', 'What influenced you most in making your decision : Reading other'),
                               c('Breast Cancer Treatment Choices - chemo vs no chemo.csv', '', 'influence_dcsn_intpt_grd', 'What influenced you most in making your decision : Option grid'),
                               c('Breast Cancer Treatment Choices - chemo vs no chemo.csv', '', 'influence_dcsn_int_tlk_hlth_prof', 'What influenced you most in making your decision : Talking to health professional'),
                               c('Breast Cancer Treatment Choices - chemo vs no chemo.csv', '', 'influence_dcsn_int_tlk_gp', 'What influenced you most in making your decision : Talking to GP'),
                               c('Breast Cancer Treatment Choices - chemo vs no chemo.csv', '', 'influence_dcsn_int_tlkth_pts', 'What influenced you most in making your decision : Talking to other patients'),
                               c('Breast Cancer Treatment Choices - chemo vs no chemo.csv', '', 'influence_dcsn_intther', 'What influenced you most in making your decision : Other'),
                               c('Breast Cancer Treatment Choices - chemo vs no chemo.csv', '', 'influence_dcsn_cont_no_dec', 'What influenced you most in making your decision : No decision'),
                               c('Breast Cancer Treatment Choices - chemo vs no chemo.csv', '', 'influence_dcsn_cont_tlk_fam', 'What influenced you most in making your decision : Talking to family'),
                               c('Breast Cancer Treatment Choices - chemo vs no chemo.csv', '', 'influence_dcsn_cont_rdth', 'What influenced you most in making your decision : Reading other'),
                               c('Breast Cancer Treatment Choices - chemo vs no chemo.csv', '', 'influence_dcsn_cont_tlk_hlth_prof', 'What influenced you most in making your decision : Talking to healthcare professional'),
                               c('Breast Cancer Treatment Choices - chemo vs no chemo.csv', '', 'influence_dcsn_cont_tlk_gp', 'What influenced you most in making your decision : Talking to GP'),
                               c('Breast Cancer Treatment Choices - chemo vs no chemo.csv', '', 'influence_dcsn_cont_tlkth_pts', 'What influenced you most in making your decision : Talking to other patients'),
                               c('Breast Cancer Treatment Choices - chemo vs no chemo.csv', '', 'influence_dcsn_contther', 'What influenced you most in making your decision : Other'),
                               c('Breast Cancer Treatment Choices - surgery vs pills', '', 'influence_dcsn_int_no_dec', 'What influenced you most in making your decision : No decision'),
                               c('Breast Cancer Treatment Choices - surgery vs pills', '', 'influence_dcsn_int_tlk_fam', 'What influenced you most in making your decision : Talking to family'),
                               c('Breast Cancer Treatment Choices - surgery vs pills', '', 'influence_dcsn_int_rd_bklt', 'What influenced you most in making your decision : Reading booklet'),
                               c('Breast Cancer Treatment Choices - surgery vs pills', '', 'influence_dcsn_int_rdth', 'What influenced you most in making your decision : Reading other'),
                               c('Breast Cancer Treatment Choices - surgery vs pills', '', 'influence_dcsn_intpt_grd', 'What influenced you most in making your decision : Option grid'),
                               c('Breast Cancer Treatment Choices - surgery vs pills', '', 'influence_dcsn_int_tlk_hlth_prof', 'What influenced you most in making your decision : Talking to health care professional'),
                               c('Breast Cancer Treatment Choices - surgery vs pills', '', 'influence_dcsn_int_tlk_gp', 'What influenced you most in making your decision : Talking to GP'),
                               c('Breast Cancer Treatment Choices - surgery vs pills', '', 'influence_dcsn_int_tlkth_pts', 'What influenced you most in making your decision : Talking to other patients'),
                               c('Breast Cancer Treatment Choices - surgery vs pills', '', 'influence_dcsn_intther', 'What influenced you most in making your decision : Other'),
                               c('Breast Cancer Treatment Choices - surgery vs pills', '', 'influence_dcsn_cont_no_dec', 'What influenced you most in making your decision : No decision'),
                               c('Breast Cancer Treatment Choices - surgery vs pills', '', 'influence_dcsn_cont_tlk_fam', 'What influenced you most in making your decision : Talking to family'),
                               c('Breast Cancer Treatment Choices - surgery vs pills', '', 'influence_dcsn_cont_rdth', 'What influenced you most in making your decision : Reading other'),
                               c('Breast Cancer Treatment Choices - surgery vs pills', '', 'influence_dcsn_cont_tlk_hlth_prof', 'What influenced you most in making your decision : Talking to healthcare professional'),
                               c('Breast Cancer Treatment Choices - surgery vs pills', '', 'influence_dcsn_cont_tlk_gp', 'What influenced you most in making your decision : Talking to GP'),
                               c('Breast Cancer Treatment Choices - surgery vs pills', '', 'influence_dcsn_cont_tlkth_pts', 'What influenced you most in making your decision : Talking to other patients'),
                               c('Breast Cancer Treatment Choices - surgery vs pills', '', 'influence_dcsn_contther', 'What influenced you most in making your decision : Other'),
                               c('Discussing treatment options', '', 'booklet_yes_int_risk_info', 'Booklet : Personalised risk information'),
                               c('Discussing treatment options', '', 'booklet_yes_int_grid', 'Booklet : Option grid'),
                               c('Discussing treatment options', '', 'booklet_yes_int_booklet', 'Booklet : Information'),
                               c('Discussing treatment options', '', 'booklet_yes_intther', 'Booklet : Other'),
                               c('Discussing treatment options', '', 'info_taken_read_all', 'How was information taken away used : Read all'),
                               c('Discussing treatment options', '', 'info_taken_read_some', 'How was information taken away used : Read some'),
                               c('Discussing treatment options', '', 'info_taken_not_read', 'How was information taken away used : Not read'),
                               c('Discussing treatment options', '', 'info_taken_showed_fam', 'How was information taken away used : Showed family'),
                               c('Discussing treatment options', '', 'info_taken_blank_sec', 'How was information taken away used : Blank section'),
                               c('Discussing treatment options', '', 'info_takenther', 'How was information taken away used : Other'),
                               c('Surgery and Post Operative Pathology', '', 'which_breast_right', 'Surgery and Post Operative Pathology of Right Breast'),
                               c('Surgery and Post Operative Pathology', '', 'which_breast_left', 'Surgery and Post Operative Pathology of Right Left'),
                               c('Surgery and Post Operative Pathology', '', 'r_designation_anterior', 'Right Breast Designation : Anterior'),
                               c('Surgery and Post Operative Pathology', '', 'r_designation_posterior', 'Right Breast Designation : Posterior'),
                               c('Surgery and Post Operative Pathology', '', 'r_designation_lateral', 'Right Breast Designation : Lateral'),
                               c('Surgery and Post Operative Pathology', '', 'r_designation_medial', 'Right Breast Designation : Medial'),
                               c('Surgery and Post Operative Pathology', '', 'r_designation_superior', 'Right Breast Designation : Superior'),
                               c('Surgery and Post Operative Pathology', '', 'r_designation_inferior', 'Right Breast Designation : Inferior'),
                               c('Surgery and Post Operative Pathology', '', 'l_designation_anterior', 'Left Breast Designation : Anterior'),
                               c('Surgery and Post Operative Pathology', '', 'l_designation_posterior', 'Left Breast Designation : Posterior'),
                               c('Surgery and Post Operative Pathology', '', 'l_designation_lateral', 'Left Breast Designation : Lateral'),
                               c('Surgery and Post Operative Pathology', '', 'l_designation_medial', 'Left Breast Designation : Medial'),
                               c('Surgery and Post Operative Pathology', '', 'l_designation_superior', 'Left Breast Designation : Superior'),
                               c('Surgery and Post Operative Pathology', '', 'l_designation_inferior', 'Left Breast Designation : Inferior'),
                               c('Treatment decision', '', 'odt_staff_used_no_not_time', 'Online Decision Tool (Staff) : Not Time'),
                               c('Treatment decision', '', 'odt_staff_used_no_pt_not_suit', 'Online Decision Tool (Staff) : Not suitable'),
                               c('Treatment decision', '', 'odt_staff_used_no_staff_not_like', 'Online Decision Tool (Staff) : Staff not like'),
                               c('Treatment decision', '', 'odt_staff_used_no_no_access', 'Online Decision Tool (Staff) : No Access'),
                               c('Treatment decision', '', 'odt_staff_used_no_already_decide', 'Online Decision Tool (Staff) : Already decided'),
                               c('Treatment decision', '', 'odt_staff_used_nother', 'Online Decision Tool (Staff) : Other'),
                               c('Treatment decision', '', 'odt_pt_shown_no_not_time', 'Online Decision Tool (Patient not shown) : Not time'),
                               c('Treatment decision', '', 'odt_pt_shown_no_pt_not_suit', 'Online Decision Tool (Patient not shown) : Not suitable'),
                               c('Treatment decision', '', 'odt_pt_shown_no_staff_not_like', 'Online Decision Tool (Patient not shown) : Staff not like'),
                               c('Treatment decision', '', 'odt_pt_shown_no_no_access', 'Online Decision Tool (Patient not shown) : No Access'),
                               c('Treatment decision', '', 'odt_pt_shown_no_distressed', 'Online Decision Tool (Patient not shown) : Distressed'),
                               c('Treatment decision', '', 'odt_pt_shown_no_not_understood', 'Online Decision Tool (Patient not shown) : Not Understood'),
                               c('Treatment decision', '', 'odt_pt_shown_no_decided', 'Online Decision Tool (Patient not shown) : Already decided'),
                               c('Treatment decision', '', 'odt_pt_shown_no_fam_reluctant', 'Online Decision Tool (Patient not shown) : Family reluctant'),
                               c('Treatment decision', '', 'odt_pt_shown_nother', 'Online Decision Tool (Patient not shown) : Other'),
                               c('Treatment decision', '', 'odt_taken_home_no_not_time', 'Online Decision Tool (Print out not taken home) : Not time'),
                               c('Treatment decision', '', 'odt_taken_home_no_pt_not_suit', 'Online Decision Tool (Print out not taken home) : Not suitable'),
                               c('Treatment decision', '', 'odt_taken_home_no_staff_not_like', 'Online Decision Tool (Print out not taken home) : Staff not like'),
                               c('Treatment decision', '', 'odt_taken_home_no_no_access', 'Online Decision Tool (Print out not taken home) : No Access'),
                               c('Treatment decision', '', 'odt_taken_home_no_notffer', 'Online Decision Tool (Print out not taken home) : Not offered'),
                               c('Treatment decision', '', 'odt_taken_home_no_distressed', 'Online Decision Tool (Print out not taken home) : Distressed'),
                               c('Treatment decision', '', 'odt_taken_home_no_not_understood', 'Online Decision Tool (Print out not taken home) : Not Understood'),
                               c('Treatment decision', '', 'odt_taken_home_no_decided', 'Online Decision Tool (Print out not taken home) : Already decided'),
                               c('Treatment decision', '', 'odt_taken_home_no_pt_reluctant', 'Online Decision Tool (Print out not taken home) : Patient reluctant'),
                               c('Treatment decision', '', 'odt_taken_home_no_fam_reluctant', 'Online Decision Tool (Print out not taken home) : Family reluctant'),
                               c('Treatment decision', '', 'odt_taken_home_nother', 'Online Decision Tool (Print out not taken home) : Other'),
                               c('Treatment decision', '', 'og_staff_used_no_not_time', 'Option Grid Not Used : Not Time'),
                               c('Treatment decision', '', 'og_staff_used_no_pt_not_suit', 'Option Grid Not Used : Patient not suitable'),
                               c('Treatment decision', '', 'og_staff_used_no_staff_not_like', 'Option Grid Not Used : Staff not like'),
                               c('Treatment decision', '', 'og_staff_used_no_not_avail', 'Option Grid Not Used : Not available'),
                               c('Treatment decision', '', 'og_staff_used_no_distressed', 'Option Grid Not Used : Distressed'),
                               c('Treatment decision', '', 'og_staff_used_no_not_understood', 'Option Grid Not Used : Not Understood'),
                               c('Treatment decision', '', 'og_staff_used_no_decided', 'Option Grid Not Used : Already decided'),
                               c('Treatment decision', '', 'og_staff_used_no_pt_reluctant', 'Option Grid Not Used : Patient Reluctant'),
                               c('Treatment decision', '', 'og_staff_used_no_fam_reluctant', 'Option Grid Not Used : Family Reluctant'),
                               c('Treatment decision', '', 'og_staff_used_nother', 'Option Grid Not Used : Other'),
                               c('Treatment decision', '', 'og_taken_home_no_not_time', 'Option Grid Not Taken Home : '),
                               c('Treatment decision', '', 'og_taken_home_no_pt_not_suit', 'Option Grid Not Taken Home : '),
                               c('Treatment decision', '', 'og_taken_home_no_staff_not_like', 'Option Grid Not Taken Home : '),
                               c('Treatment decision', '', 'og_taken_home_no_not_avail', 'Option Grid Not Taken Home : '),
                               c('Treatment decision', '', 'og_taken_home_no_notffer', 'Option Grid Not Taken Home : '),
                               c('Treatment decision', '', 'og_taken_home_no_distressed', 'Option Grid Not Taken Home : '),
                               c('Treatment decision', '', 'og_taken_home_no_not_understood', 'Option Grid Not Taken Home : '),
                               c('Treatment decision', '', 'og_taken_home_no_decided', 'Option Grid Not Taken Home : '),
                               c('Treatment decision', '', 'og_taken_home_no_pt_reluctant', 'Option Grid Not Taken Home : '),
                               c('Treatment decision', '', 'og_taken_home_no_fam_reluctant', 'Option Grid Not Taken Home : '),
                               c('Treatment decision', '', 'og_taken_home_nother', 'Option Grid Not Taken Home : Other'),
                               c('Treatment decision', '', 'b_staff_used_no_not_time', 'Booklet (Staff not used) : Not Time'),
                               c('Treatment decision', '', 'b_staff_used_no_pt_not_suit', 'Booklet (Staff not used) : Patient not suitable'),
                               c('Treatment decision', '', 'b_staff_used_no_staff_not_like', 'Booklet (Staff not used) : Staff not like'),
                               c('Treatment decision', '', 'b_staff_used_no_not_avail', 'Booklet (Staff not used) : Not available'),
                               c('Treatment decision', '', 'b_staff_used_no_distressed', 'Booklet (Staff not used) : Distressed'),
                               c('Treatment decision', '', 'b_staff_used_no_not_understood', 'Booklet (Staff not used) : Not understood'),
                               c('Treatment decision', '', 'b_staff_used_no_decided', 'Booklet (Staff not used) : Already decided'),
                               c('Treatment decision', '', 'b_staff_used_no_pt_reluctant', 'Booklet (Staff not used) : Patient reluctant'),
                               c('Treatment decision', '', 'b_staff_used_no_fam_reluctant', 'Booklet (Staff not used) : Family reluctant'),
                               c('Treatment decision', '', 'b_staff_used_nother', 'Booklet (Staff not used) : Other'),
                               c('Treatment decision', '', 'b_taken_home_no_not_time', 'Booklet (not taken home) : Not time'),
                               c('Treatment decision', '', 'b_taken_home_no_pt_not_suit', 'Booklet (not taken home) : Patient not suitable'),
                               c('Treatment decision', '', 'b_taken_home_no_staff_not_like', 'Booklet (not taken home) : Staff not like'),
                               c('Treatment decision', '', 'b_taken_home_no_not_avail', 'Booklet (not taken home) : Not Available'),
                               c('Treatment decision', '', 'b_taken_home_no_notffer', 'Booklet (not taken home) : Not Offered'),
                               c('Treatment decision', '', 'b_taken_home_no_distressed', 'Booklet (not taken home) : Distressed'),
                               c('Treatment decision', '', 'b_taken_home_no_not_understood', 'Booklet (not taken home) : Not Understood'),
                               c('Treatment decision', '', 'b_taken_home_no_decided', 'Booklet (not taken home) : Already Decided'),
                               c('Treatment decision', '', 'b_taken_home_no_pt_reluctant', 'Booklet (not taken home) : Patient reluctant'),
                               c('Treatment decision', '', 'b_taken_home_no_fam_reluctant', 'Booklet (not taken home) : Family reluctant'),
                               c('Treatment decision', '', 'b_taken_home_nother', 'Booklet (not taken home) : Other')
                               )

## Replace '[calculated] ' in all identifiers since this is NOT used in the actual
## identifier!!
master$lookups_fields <- master$lookups_fields %>%
                         mutate(identifier = gsub('\\[calculated] ', '', identifier))
## Because of duplicated variable names across tables the fields lookups need adjusting to
## account for the renaming of variables in each table.
duplicated_var_names <- list()
duplicated_var_names$baseline <- c('uni_bilateral',
                                   'primary_tumour',
                                   'r_focal',
                                   'r_num_tumours',
                                   'r_cancer_palpable',
                                   'r_size_clin_assess',
                                   'r_method_assess',
                                   'r_size_ultrasound',
                                   'r_size_mammo',
                                   'r_axillary_present',
                                   'r_axillary_nodes',
                                   'r_axillary_axis',
                                   'r_biopsy_type',
                                   'r_confirm_present',
                                   'r_histo_grade',
                                   'r_histo_subtype',
                                   'r_histo_spcfy',
                                   'r_allred',
                                   'r_h_score',
                                   'r_pgr_score',
                                   'r_her_2_score',
                                   'l_focal',
                                   'l_num_tumours',
                                   'l_cancer_palpable',
                                   'l_size_clin_assess',
                                   'l_method_assess',
                                   'l_size_ultrasound',
                                   'l_size_mammo',
                                   'l_axillary_present',
                                   'l_axillary_nodes',
                                   'l_axillary_axis',
                                   'l_biopsy_type',
                                   'l_confirm_present',
                                   'l_histo_grade',
                                   'l_histo_subtype',
                                   'l_histo_spcfy',
                                   'l_allred',
                                   'l_h_score',
                                   'l_pgr_score',
                                   'l_her_2_score',
                                   'taking_meds')
duplicated_var_names$clinical_assessment_pet <- c('uni_bilateral',
                                                  'primary_tumour',
                                                  'r_focal',
                                                  'r_num_tumours',
                                                  'r_cancer_palpable',
                                                  'r_size_clin_assess',
                                                  'r_method_assess',
                                                  'r_size_ultrasound',
                                                  'r_size_mammo',
                                                  'r_axillary_present',
                                                  'r_axillary_nodes',
                                                  'r_axillary_axis',
                                                  'l_focal',
                                                  'l_num_tumours',
                                                  'l_cancer_palpable',
                                                  'l_size_clin_assess',
                                                  'l_method_assess',
                                                  'l_size_ultrasound',
                                                  'l_size_mammo',
                                                  'l_axillary_present',
                                                  'l_axillary_nodes',
                                                  'l_axillary_axis')
duplicated_var_names$chemo_no_chemo <- c('know_enough',
                                         'aware',
                                         'option_pref',
                                         'decision',
                                         'moment_think',
                                         'influence_dcsn_int_no_dec',
                                         'influence_dcsn_int_tlk_fam',
                                         'influence_dcsn_int_rd_bklt',
                                         'influence_dcsn_int_rd_other',
                                         'influence_dcsn_int_opt_grd',
                                         'influence_dcsn_int_tlk_hlth_prof',
                                         'influence_dcsn_int_tlk_gp',
                                         'influence_dcsn_int_tlk_oth_pts',
                                         'influence_dcsn_int_other',
                                         'other_int',
                                         'influence_dcsn_cont_no_dec',
                                         'influence_dcsn_cont_tlk_fam',
                                         'influence_dcsn_cont_rd_other',
                                         'influence_dcsn_cont_tlk_hlth_prof',
                                         'influence_dcsn_cont_tlk_gp',
                                         'influence_dcsn_cont_tlk_oth_pts',
                                         'influence_dcsn_cont_other',
                                         'other_cont')
duplicated_var_names$surgery_pills <- c('know_enough',
                                        'aware',
                                        'option_pref',
                                        'decision',
                                        'moment_think',
                                        'influence_dcsn_int_no_dec',
                                        'influence_dcsn_int_tlk_fam',
                                        'influence_dcsn_int_rd_bklt',
                                        'influence_dcsn_int_rd_other',
                                        'influence_dcsn_int_opt_grd',
                                        'influence_dcsn_int_tlk_hlth_prof',
                                        'influence_dcsn_int_tlk_gp',
                                        'influence_dcsn_int_tlk_oth_pts',
                                        'influence_dcsn_int_other',
                                        'other_int',
                                        'influence_dcsn_cont_no_dec',
                                        'influence_dcsn_cont_tlk_fam',
                                        'influence_dcsn_cont_rd_other',
                                        'influence_dcsn_cont_tlk_hlth_prof',
                                        'influence_dcsn_cont_tlk_gp',
                                        'influence_dcsn_cont_tlk_oth_pts',
                                        'influence_dcsn_cont_other',
                                        'other_cont')
master$lookups_fields <- master$lookups_fields %>%
                         mutate(identifier = ifelse(form == 'Baseline Tumour Assessment' &
                                                    identifier %in% duplicated_var_names$baseline,
                                                    no  = identifier,
                                                    yes = paste0(identifier, '_baseline')),
                                identifier = ifelse(form == 'Breast Cancer Treatment Choices - chemo vs no chemo' &
                                                    identifier %in% duplicated_var_names$chemo_no_chemo,
                                                    no  = identifier,
                                                    yes = paste0(identifier, '_chemo_no_chemo')),
                                identifier = ifelse(form == 'Breast Cancer Treatment Choices - surgery vs pills' &
                                                    identifier %in% duplicated_var_names$surgery_pills,
                                                    no  = identifier,
                                                    yes = paste0(identifier, '_surgery_pills')),
                                identifier = ifelse(form == 'Clinical Assessment (PET)' &
                                                    identifier %in% duplicated_var_names$clinical_assessment_pet,
                                                    no  = identifier,
                                                    yes = paste0(identifier, '_pet')))
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
## File : Baseline Tumor Assessment.csv
master$baseline_tumour_assessment <- read_prospect(file = 'Baseline Tumour Assessment.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookups)
## Duplicated variable names (used in PET) data table need resolving...
##
## Neat trick from StackOverflow (https://stackoverflow.com/a/10669726/1444043)
names(master$baseline_tumour_assessment) <- ifelse(names(master$baseline_tumour_assessment) %in% duplicated_var_names$baseline,
                                                   no  = names(master$baseline_tumour_assessment),
                                                   yes = paste0(names(master$baseline_tumour_assessment), '_baseline'))
## File : Breast Cancer Treatment Choices - chemo vs no chemo.csv
master$breast_cancer_treatment_choices_chemo_no_chemo <- read_prospect(file = 'Breast Cancer Treatment Choices - chemo vs no chemo.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookups)
## Variable names duplicate/conflict with Breast Cancer Treatment Choices - chemo vs no chemo.csv
names(master$breast_cancer_treatment_choices_chemo_no_chemo) <- ifelse(names(master$breast_cancer_treatment_choices_chemo_no_chemo) %in% duplicated_var_names$chemo_no_chemo,
                                                   no  = names(master$breast_cancer_treatment_choices_chemo_no_chemo),
                                                   yes = paste0(names(master$breast_cancer_treatment_choices_chemo_no_chemo), '_chemo_no_chemo'))
## File : Breast Cancer Treatment Choices - surgery vs pills.csv
master$breast_cancer_treatment_choices_surgery_pills <- read_prospect(file = 'Breast Cancer Treatment Choices - surgery vs pills.csv',
                         header          = TRUE,
                         sep             = ',',
                         convert.dates   = TRUE,
                         convert.underscores = TRUE,
                         dictionary      = master$lookups)
## Variable names duplicate/conflict with Breast Cancer Treatment Choices - chemo vs no chemo.csv
names(master$breast_cancer_treatment_choices_surgery_pills) <- ifelse(names(master$breast_cancer_treatment_choices_surgery_pills) %in% duplicated_var_names$surgery_pills,
                                                   no  = names(master$breast_cancer_treatment_choices_surgery_pills),
                                                   yes = paste0(names(master$breast_cancer_treatment_choices_surgery_pills), '_surgery_pills'))
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
## Duplicated variable/field names are now resolved
names(master$clinical_assessment_pet) <- ifelse(names(master$clinical_assessment_pet) %in% duplicated_var_names$clinical_assessment_pet,
                                                   no  = names(master$clinical_assessment_pet),
                                                   yes = paste0(names(master$clinical_assessment_pet), '_pet'))

## File : CollaboRATE.csv
master$collaborate <- read_prospect(file = 'CollaboRATE.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookups)
names(master$collaborate) <- gsub('calc_score', 'collaborate_calc_score', names(master$collaborate))
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
names(master$decision_regret_scale) <- gsub('calc_score', 'decision_regret_scale_calc_score', names(master$decision_regret_scale))
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
master$the_brief_illness_perception_questionnaire <- read_prospect(file = 'The Brief Illness Perception Questionnaire (BIPQ).csv',
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
names(master$sites) <- gsub('site_group', 'group', names(master$sites))
names(master$sites) <- gsub('name',       'site', names(master$sites))
## Some sites were not randomised to the RCT so have '' (rather than truely missing)
## correct that now
master$sites <- master$sites %>%
                mutate(group = ifelse(group == '',
                                      no  = group,
                                      yes = NA))
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

## File : db_spec_forms.csv
master$db_spec_forms <- read.csv(file = 'db_spec_forms.csv',
                                 header = TRUE,
                                 sep    = ',') %>%
                        mutate(data_frame = tolower(Form),
                               data_frame = gsub(' ', '_', data_frame))
names(master$db_spec_forms) <- names(master$db_spec_forms) %>% tolower()
names(master$db_spec_forms) <- gsub('\\.', '_', names(master$db_spec_forms))
## Remove acronyms from data_frame and tidy to improve matching
master$db_spec_forms <- master$db_spec_forms %>%
                        mutate(data_frame = gsub('\\(non-pet\\)', 'non_pet', data_frame),
                               data_frame = gsub('\\(pet\\)',     'pet',     data_frame),
                               data_frame = gsub('_\\(stai\\)',   '',        data_frame),
                               data_frame = gsub('_\\(drs\\)',    '',        data_frame),
                               data_frame = gsub('_\\(bipq\\)',   '',        data_frame),
                               ## data_frame = gsub('x',             'cohort_', data_frame),
                               data_frame = gsub('&',             'and',     data_frame),
                               data_frame = gsub('-',             '_',       data_frame),
                               data_frame = gsub('_/_',           '_',       data_frame),
                               data_frame = gsub('_generated_',   '_',       data_frame),
                               data_frame = gsub('_of_',          '_',       data_frame),
                               data_frame = gsub('_level_',       '_',       data_frame),
                               data_frame = gsub('_\\(\\)',       '',        data_frame),
                               data_frame = gsub('___',           '_',       data_frame),
                               data_frame = gsub('_-_',           '_',       data_frame),
                               data_frame = gsub('co_',           'co',       data_frame),
                               data_frame = gsub('_vs_',          '_',       data_frame)
                               )

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
## NB - 'event_name' is NOT used from master$consent_form since these are all 'Screening' and
##      all that is required is pulling in the four non-matching variables with the baseline
master$baseline <- full_join(dplyr::select(master$consent_form,
                                           individual_id, site, ## event_name, event_date, database_id,
                                           screening_no, dob, participation_lvl, consent_dt),
                             dplyr::select(master$baseline_tumour_assessment,
                                           individual_id, site, event_name, event_date, ## database_id,
                                           uni_bilateral_baseline, primary_tumour_baseline,
                                           r_focal_baseline, r_num_tumours_baseline, r_cancer_palpable_baseline,
                                           r_size_clin_assess_baseline, r_method_assess_baseline,
                                           r_size_ultrasound_baseline, r_size_mammo_baseline,
                                           r_axillary_present_baseline, r_axillary_nodes_baseline,
                                           r_axillary_axis_baseline, r_biopsy_type_baseline,
                                           r_confirm_present_baseline, r_histo_grade_baseline,
                                           r_histo_subtype_baseline, r_histo_spcfy_baseline, r_allred_baseline,
                                           r_h_score_baseline, r_pgr_score_baseline, r_her_2_score_baseline,
                                           l_focal_baseline, l_num_tumours_baseline, l_cancer_palpable_baseline,
                                           l_size_clin_assess_baseline, l_method_assess_baseline,
                                           l_size_ultrasound_baseline, l_size_mammo_baseline,
                                           l_axillary_present_baseline, l_axillary_nodes_baseline,
                                           l_axillary_axis_baseline, l_biopsy_type_baseline,
                                           l_confirm_present_baseline, l_histo_grade_baseline,
                                           l_histo_subtype_baseline, l_histo_spcfy_baseline,
                                           l_allred_baseline, l_h_score_baseline, l_pgr_score_baseline,
                                           l_her_2_score_baseline, taking_meds_baseline),
                             by = c('individual_id', 'site')) %>%
## Baseline Medications
           ## full_join(.,
           ##           dplyr::select(master$baseline_medications_med,
           ##                         individual_id, site, event_name, event_date, ## database_id,
           ##                         )) %>%
## Decision making preferences
                  full_join(.,
                            dplyr::select(master$decision_making_preferences,
                                          individual_id, site, event_name, ## event_date, database_id,
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
                                           individual_id, site, event_name, ## event_date, database_id,
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
                                          individual_id, site, event_name, ## event_date, database_id,
                                          ecog_grade),
                            by = c('individual_id', 'site', 'event_name'))
## ## TEMPLATE
##            full_join(.,
##                      dplyr::select(master$TEMPLATE,
##                                    individual_id, site, event_name, event_date, ## database_id,
##                                    )) %>%

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
                                              individual_id, site, event_name, ## event_date, database_id,
                                              br23_q31, br23_q32, br23_q33, br23_q34, br23_q35,
                                              br23_q36, br23_q37, br23_q38, br23_q39, br23_q40, br23_q41,
                                              br23_q42, br23_q43, br23_q44, br23_q45, br23_q46, br23_q47,
                                              br23_q48, br23_q49, br23_q50, br23_q51, br23_q52, br23_q53,
                                              brbi_raw, brbi_scale, brsef_raw, brsef_scale, brsee_scale, brfu_scale,
                                              brst_raw, brst_scale, brbs_raw, brbs_scale, bras_raw, bras_scale,
                                              brhl_scale),
                                by = c('individual_id', 'site', 'event_name')) %>%
## EORTC-QLQ-ELD15
                      full_join(.,
                                dplyr::select(master$eortc_qlq_eld15,
                                              individual_id, site, event_name, ## event_date, database_id,
                                              eld15_q54, eld15_q55, eld15_q56, eld15_q57, eld15_q58,
                                              eld15_q59, eld15_q60, eld15_q61, eld15_q62, eld15_q63, eld15_q64,
                                              eld15_q65, eld15_q66, eld15_q67, eld15_q68, mo_raw, mo_scale,
                                              wao_raw, wao_scale, wo_raw, wo_scale, mp_raw, mp_scale,
                                              boi_raw, boi_scale, js_scale, fs_scale),
                                by = c('individual_id', 'site', 'event_name')) %>%
## EQ5D
                      full_join(.,
                                dplyr::select(master$eq5d,
                                              individual_id, site, event_name, ## event_date, database_id,
                                              mobility, self_care, usual_activity, pain_discomfort,
                                              anxiety_depression, health_today, eq5d_number, eq5d_score),
                                by = c('individual_id', 'site', 'event_name')) %>%
## Therapy Assessment
                      full_join(.,
                                dplyr::select(master$therapy_assessment,
                                              individual_id, site, event_name, ## event_date, database_id,
                                              any_treatment, endocrine_therapy, radiotherapy,
                                              chemotherapy, trastuzumab, surgery),
                                by = c('individual_id', 'site', 'event_name')) %>%
## Endocrine Therapy
                      full_join(.,
                                dplyr::select(master$endocrine_therapy,
                                              individual_id, site, event_name, ## event_date, database_id,
                                              primary_adjuvant, reason_pet, reason_pet_risk,
                                              reason_pet_spcfy, endocrine_type, endocrine_type_oth,
                                              therapy_changed, therapy_changed_dtls,
                                              compliance, endocrine_aes, et_hot_flushes, et_asthenia,
                                              et_joint_pain, et_vaginal_dryness, et_hair_thinning, et_rash,
                                              et_nausea, et_diarrhoea, et_headache, et_vaginal_bleeding,
                                              et_vomiting, et_somnolence),
                                by = c('individual_id', 'site', 'event_name')) %>%
## Radiotherapy
                      full_join(.,
                                dplyr::select(master$radiotherapy,
                                              individual_id, site, event_name, ## event_date, database_id,
                                              which_breast_right, which_breast_left, r_site_breast,
                                              r_site_axilla, r_site_supraclavicular, r_site_chest_wall,
                                              r_site_other, r_breast_fractions, r_axilla_fractions,
                                              r_supra_fractions, r_chest_fractions, r_other_fractions,
                                              r_radiotherapy_aes,
                                              l_site_breast, l_site_axilla, l_site_supraclavicular,
                                              l_site_chest_wall, l_site_other, l_breast_fractions,
                                              l_axilla_fractions, l_supra_fractions, l_chest_fractions,
                                              l_other_fractions, l_radiotherapy_aes,
                                              r_skin_erythema, r_pain, r_breast_oedema, r_breast_shrink,
                                              r_breast_pain, l_skin_erythema, l_pain, l_breast_oedema,
                                              l_breast_shrink, l_breast_pain),
                                by = c('individual_id', 'site', 'event_name')) %>%
## Chemotherapy
                      full_join(.,
                                dplyr::select(master$chemotherapy,
                                              individual_id, site, event_name, ## event_date, database_id,
                                              chemo_received, chemo_aes,
                                              c_fatigue, c_anaemia, c_low_wc_count, c_thrombocytopenia, c_allergic,
                                              c_hair_thinning, c_nausea, c_infection),
                                by = c('individual_id', 'site', 'event_name')) %>%
## Clinical Assessment Non-Pet
                      full_join(.,
                                dplyr::select(master$clinical_assessment_non_pet,
                                              individual_id, site, event_name, ## event_date, database_id,
                                              recurrence, recurrence_dt, recurrence_where_breast,
                                              recurrence_where_chest_wall, recurrence_where_axilla,
                                              recurrence_where_metastatic, recurrence_met_bone,
                                              recurrence_met_liver, recurrence_met_lung,
                                              recurrence_met_superclavicular, recurrence_met_brain,
                                              recurrence_met_other,
                                              recurrence_met_spcfy, new_tumour_yn, new_tumour_dtls,
                                              clinical_plan, plan_local_surgery, plan_local_radio,
                                              plan_local_endocrine, plan_local_chemo, plan_local_trast,
                                              plan_local_other, plan_local_spcfy, plan_met_radio,
                                              plan_met_endocrine, plan_met_chemo, plan_met_trast,
                                              plan_met_other, plan_met_spcfy, plan_routine_surgery,
                                              plan_routine_radio, plan_routine_endocrine, plan_routine_chemo,
                                              plan_routine_trast, plan_routine_other, plan_routine_spcfy),
                                by = c('individual_id', 'site', 'event_name')) %>%
## Clinical Assessment Pet
                      full_join(.,
                                dplyr::select(master$clinical_assessment_pet,
                                              individual_id, site, event_name, ## event_date, database_id,
                                              uni_bilateral_pet, primary_tumour_pet, r_focal_pet,
                                              r_num_tumours_pet, r_cancer_palpable_pet, r_size_clin_assess_pet,
                                              r_method_assess_pet, r_size_ultrasound_pet, r_size_mammo_pet,
                                              r_axillary_present_pet, r_axillary_nodes_pet, r_axillary_axis_pet,
                                              l_focal_pet, l_num_tumours_pet, l_cancer_palpable_pet,
                                              l_size_clin_assess_pet, l_method_assess_pet, l_size_ultrasound_pet,
                                              l_size_mammo_pet, l_axillary_present_pet, l_axillary_nodes_pet,
                                              l_axillary_axis_pet, metastatic, metastatic_where_bone,
                                              metastatic_where_lung, metastatic_where_cervical_node, metastatic_where_other,
                                              metastatic_where_liver, metastatic_where_brain, proposed_treat,
                                              clinical_plan2, plan_change_surgery, plan_change_radio,
                                              plan_change_antioestrogen, plan_change_other,plan_change_spcfy),
                                by = c('individual_id', 'site', 'event_name')) %>%
## Trastuzumab
                      full_join(.,
                                dplyr::select(master$trastuzumab,
                                              individual_id, site, event_name, ## event_date, database_id,
                                              trast_received, infusion_no, trast_aes, t_cardiac_fail,
                                              t_flu_like, t_nausea, t_diarrhoea, t_headache, t_allergy),
                                by = c('individual_id', 'site', 'event_name'))


###################################################################################
## Combine the RCT components                                                    ##
###################################################################################
## Treatment Decision Support Consultations + Treatment Decision
master$rct <- full_join(dplyr::select(master$treatment_decision_support_consultations,
                                      individual_id, site, event_name, event_date, ## database_id,
                                      surg_pet_consult, surg_pet_consult_dt, surg_pet_offer,
                                      surg_pet_follow, chemo_no_consult, chemo_no_consult_dt,
                                      chemo_no_offer, chemo_no_follow),
                        dplyr::select(master$treatment_decision,
                                      individual_id, site, event_name, ## event_date, database_id,
                                      trt_opt_discussed, odt_staff_used,
                                      odt_staff_used_no_not_time, odt_staff_used_no_pt_not_suit,
                                      odt_staff_used_no_staff_not_like, odt_staff_used_no_no_access,
                                      odt_staff_used_no_already_decide, odt_staff_used_no_other,
                                      odt_staff_used_no_oth, odt_pt_shown, odt_pt_shown_no_not_time,
                                      odt_pt_shown_no_pt_not_suit, odt_pt_shown_no_staff_not_like,
                                      odt_pt_shown_no_no_access, odt_pt_shown_no_distressed,
                                      odt_pt_shown_no_not_understood, odt_pt_shown_no_decided,
                                      odt_pt_shown_no_fam_reluctant, odt_pt_shown_no_other,
                                      odt_pt_shown_no_oth, odt_taken_home, odt_taken_home_no_not_time,
                                      odt_taken_home_no_pt_not_suit, odt_taken_home_no_staff_not_like,
                                      odt_taken_home_no_no_access, odt_taken_home_no_not_offer,
                                      odt_taken_home_no_distressed, odt_taken_home_no_not_understood,
                                      odt_taken_home_no_decided, odt_taken_home_no_pt_reluctant,
                                      odt_taken_home_no_fam_reluctant, odt_taken_home_no_other,
                                      odt_taken_home_no_oth, og_staff_used, og_staff_used_no_not_time,
                                      og_staff_used_no_pt_not_suit, og_staff_used_no_staff_not_like,
                                      og_staff_used_no_not_avail, og_staff_used_no_distressed,
                                      og_staff_used_no_not_understood, og_staff_used_no_decided,
                                      og_staff_used_no_pt_reluctant, og_staff_used_no_fam_reluctant,
                                      og_staff_used_no_other, og_staff_used_no_oth, og_taken_home,
                                      og_taken_home_no_not_time, og_taken_home_no_pt_not_suit,
                                      og_taken_home_no_staff_not_like, og_taken_home_no_not_avail,
                                      og_taken_home_no_not_offer, og_taken_home_no_distressed,
                                      og_taken_home_no_not_understood, og_taken_home_no_decided,
                                      og_taken_home_no_pt_reluctant, og_taken_home_no_fam_reluctant,
                                      og_taken_home_no_other, og_taken_home_no_oth, b_staff_used,
                                      b_staff_used_no_not_time, b_staff_used_no_pt_not_suit,
                                      b_staff_used_no_staff_not_like, b_staff_used_no_not_avail,
                                      b_staff_used_no_distressed, b_staff_used_no_not_understood,
                                      b_staff_used_no_decided, b_staff_used_no_pt_reluctant,
                                      b_staff_used_no_fam_reluctant, b_staff_used_no_other,
                                      b_staff_used_no_oth, b_taken_home, b_taken_home_no_not_time,
                                      b_taken_home_no_pt_not_suit, b_taken_home_no_staff_not_like,
                                      b_taken_home_no_not_avail, b_taken_home_no_not_offer,
                                      b_taken_home_no_distressed, b_taken_home_no_not_understood,
                                      b_taken_home_no_decided, b_taken_home_no_pt_reluctant,
                                      b_taken_home_no_fam_reluctant, b_taken_home_no_other, b_taken_home_no_oth),
                        by = c('individual_id', 'site', 'event_name')) %>%
## Collaborate
              full_join(.,
                        dplyr::select(master$collaborate,
                                      individual_id, site, event_name, ## event_date, database_id,
                                      understand_issues, listen_to_issues, matters_most, collaborate_calc_score),
                        by = c('individual_id', 'site', 'event_name')) %>%
## Breast Cancer Treatment Choices - surgery vs pills
              full_join(.,
                        dplyr::select(master$breast_cancer_treatment_choices_surgery_pills,
                                      individual_id, site, event_name, ## event_date, database_id,
                                      hblock_chemo, surg_no_hblock,
                                      hblock_hosp_chk, hblock_stop,
                                      hblock_stay_alive, hblock_change,
                                      surg_swell, need_radio,
                                      know_enough_surgery_pills,
                                      aware_surgery_pills,
                                      option_pref_surgery_pills,
                                      decision_surgery_pills,
                                      moment_think_surgery_pills,
                                      influence_dcsn_int_no_dec_surgery_pills,
                                      influence_dcsn_int_tlk_fam_surgery_pills,
                                      influence_dcsn_int_rd_bklt_surgery_pills,
                                      influence_dcsn_int_rd_other_surgery_pills,
                                      influence_dcsn_int_opt_grd_surgery_pills,
                                      influence_dcsn_int_tlk_hlth_prof_surgery_pills,
                                      influence_dcsn_int_tlk_gp_surgery_pills,
                                      influence_dcsn_int_tlk_oth_pts_surgery_pills,
                                      influence_dcsn_int_other_surgery_pills,
                                      other_int_surgery_pills,
                                      influence_dcsn_cont_no_dec_surgery_pills,
                                      influence_dcsn_cont_tlk_fam_surgery_pills,
                                      influence_dcsn_cont_rd_other_surgery_pills,
                                      influence_dcsn_cont_tlk_hlth_prof_surgery_pills,
                                      influence_dcsn_cont_tlk_gp_surgery_pills,
                                      influence_dcsn_cont_tlk_oth_pts_surgery_pills,
                                      influence_dcsn_cont_other_surgery_pills,
                                      other_cont_surgery_pills),
                        by = c('individual_id', 'site', 'event_name')) %>%
## Breast Cancer Treatment Choices - surgery vs no chemo
              full_join(.,
                        dplyr::select(master$breast_cancer_treatment_choices_chemo_no_chemo,
                                      individual_id, site, event_name, ## event_date, database_id,
                                      inc_long_term, not_visit_people,
                                      hair_never_regrows, herceptin,
                                      chemo_vein, chemo_infect,
                                      feel_tired_unwell, over_3m_6m,
                                      no_meds_nausea, pills_radio_not_chemo,
                                      know_enough_chemo_no_chemo,
                                      aware_chemo_no_chemo,
                                      option_pref_chemo_no_chemo,
                                      decision_chemo_no_chemo,
                                      moment_think_chemo_no_chemo,
                                      influence_dcsn_int_no_dec_chemo_no_chemo,
                                      influence_dcsn_int_tlk_fam_chemo_no_chemo,
                                      influence_dcsn_int_rd_bklt_chemo_no_chemo,
                                      influence_dcsn_int_rd_other_chemo_no_chemo,
                                      influence_dcsn_int_opt_grd_chemo_no_chemo,
                                      influence_dcsn_int_tlk_hlth_prof_chemo_no_chemo,
                                      influence_dcsn_int_tlk_gp_chemo_no_chemo,
                                      influence_dcsn_int_tlk_oth_pts_chemo_no_chemo,
                                      influence_dcsn_int_other_chemo_no_chemo,
                                      other_int_chemo_no_chemo,
                                      influence_dcsn_cont_no_dec_chemo_no_chemo,
                                      influence_dcsn_cont_tlk_fam_chemo_no_chemo,
                                      influence_dcsn_cont_rd_other_chemo_no_chemo,
                                      influence_dcsn_cont_tlk_hlth_prof_chemo_no_chemo,
                                      influence_dcsn_cont_tlk_gp_chemo_no_chemo,
                                      influence_dcsn_cont_tlk_oth_pts_chemo_no_chemo,
                                      influence_dcsn_cont_other_chemo_no_chemo,
                                      other_cont_chemo_no_chemo),
                        by = c('individual_id', 'site', 'event_name')) %>%
## Spielberger State Trait Anxiety
              full_join(.,
                        dplyr::select(master$spielberger_state_trait_anxiety,
                                      individual_id, site, event_name, ## event_date, database_id,
                                      calm, tense, upset, relaxed, content, worried),
                        by = c('individual_id', 'site', 'event_name')) %>%
## Brief COPE
              full_join(.,
                        dplyr::select(master$brief_cope,
                                      individual_id, site, event_name, ## event_date, database_id,
                                      do_something, isnt_real, support_from_others, giving_up_dealing,
                                      taking_action, refuse_to_believe, help_from_others,
                                      different_light, strategy_to_do, comfort_someone,
                                      giving_up_coping, steps_to_take, accepting_reality,
                                      advice_from_others, live_with_it, looking_for_good),
                        by = c('individual_id', 'site', 'event_name')) %>%
## Brief Illness Percetion Questionnaire
              full_join(.,
                        dplyr::select(master$the_brief_illness_perception_questionnaire,
                                      individual_id, site, event_name, ## event_date, database_id,
                                      ill_affect, ill_continue, ill_control, ill_treatment,
                                      ill_symptoms, ill_concern, ill_understand, ill_emotion),
                        by = c('individual_id', 'site', 'event_name')) %>%
## Discussing Treatment Options
              full_join(.,
                        dplyr::select(master$discussing_treatment_options,
                                      individual_id, site, event_name, ## event_date, database_id,
                                      spoke_trt_option_hosp_dr, spoke_trt_option_hosp_nurse,
                                      spoke_trt_option_helpline_dr, spoke_trt_option_practice_gp,
                                      spoke_trt_option_other, spoke_trt_option_oth, booklet_provided,
                                      booklet_yes_int_risk_info, booklet_yes_int_grid,
                                      booklet_yes_int_booklet, booklet_yes_int_other,
                                      booklet_yes_int_oth, booklet_yes_cont, info_taken_read_all,
                                      info_taken_read_some, info_taken_not_read,
                                      info_taken_showed_fam, info_taken_blank_sec,
                                      info_taken_other, info_taken_oth, info_useful, risk_info,
                                      option_grid, booklet_info, booklet_my_decision, info_thoughts),
                        by = c('individual_id', 'site', 'event_name')) %>%
## Decision Regret Scale
              full_join(.,
                        dplyr::select(master$decision_regret_scale,
                                      individual_id, site, event_name, ## event_date, database_id,
                                      right_decision, regret_choice, same_if_do_over, choice_did_harm,
                                      wise_decision, decision_regret_scale_calc_score),
                        by = c('individual_id', 'site', 'event_name'))

###################################################################################
## Combine baseline and multiple timepoints into one coherent data frame         ##
###################################################################################
age_gap <- full_join(master$therapy_qol,
                     master$baseline,
                     by = c('individual_id', 'site', 'event_name', 'event_date')) %>%
           full_join(.,
                     master$rct,
                     by = c('individual_id', 'site', 'event_name', 'event_date')) %>%
## Convert event_name to a factor so that it will plot in the correct order in all
## subsequent uses
           mutate(event_name = factor(event_name,
                                      levels = c('Baseline',
                                                 'RCT baseline',
                                                 'RCT treatment',
                                                 '6 weeks',
                                                 'RCT 6 weeks',
                                                 '6 months',
                                                 'RCT 6 months',
                                                 '12 months',
                                                 '18 months',
                                                 '24 months'))) %>%
## Finally the site allocation so that RCT component can be confudcted
           left_join(.,
                     dplyr::select(master$sites,
                                   site, group),
                        by = c('site'))

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
## Remove 'University Hospital of' / 'University Hospital' / 'Hospital' etc.
## to make plotting/tabulation neater
           mutate(site = gsub('^University Hospital of ', '', site),
                  site = gsub('^University Hospital ', '', site),
                  site = gsub(' Teaching Hospital$', '', site),
                  site = gsub(' Teaching Hospitals$', '', site))
                  site = gsub(' Hospital$', '', site),
                  site = gsub(' Hospitals$', '', site))
## Convert all heights to same units (cm)
           mutate(height_cm = ifelse(is.na(height_cm),
                                     yes = 2.54 * ((height_ft * 12) + height_in),
                                     no  = height_cm)) %>%
## Derive BMI
           mutate(bmi = weight_kg / (height_cm /100)^2) %>%
# Age based on Date of Birth
           mutate(age_exact = new_interval(start = dob,
                                           end = consent_dt) / duration(num = 1, units = 'years')) %>%
## Elapsed time from consent/randomisation to noted event
           group_by(individual_id) %>%
           mutate(start_date = min(consent_dt, na.rm = TRUE),
                  elapsed    = interval(event_date, start_date)) %>%
           dplyr::select(-start_date) %>%
           ungroup()

###################################################################################
## Add in derived variables to the fields lookup                                 ##
###################################################################################
master$lookups_fields <- rbind(master$lookups_fields,
                               c('', '', 'weight_kg', 'Weight (kg)'),
                               c('', '', 'bmi', 'Body Mass Index'),
                               c('', '', 'age_exact', 'Age (years)'),
                               c('', '', 'elapsed', 'Time from consent/randomisation to stated event.'),
                               c('', '', 'collaborate_calc_score', 'Collaborate Score'),
                               c('', '', 'cf_raw', 'CF Raw'),
                               c('', '', 'ef_raw', 'EF Raw'),
                               c('', '', 'fa_raw', 'FA Raw'),
                               c('', '', 'nv_raw', 'NV Raw'),
                               c('', '', 'pa_raw', 'PA Raw'),
                               c('', '', 'pf_raw', 'PF Raw'),
                               c('', '', 'ql_raw', 'QL Raw'),
                               c('', '', 'rf_raw', 'RF Raw'),
                               c('', '', 'sf_raw', 'SF Raw'))


###################################################################################
## README files describing all variables                                         ##
###################################################################################
master$README <- names(master) %>%
                 as.data.frame()
names(master$README) <- c('data_frame')
master$README <- left_join(master$README,
                           dplyr::select(master$db_spec_forms,
                                         data_frame, form))
## Describe other data_frame within master
## Purposefully done as a series of individual ifelse() since using case_when()
## would require _everything_ to be defined (something I'm trying to avoid)
master$README <- master$README %>%
                 mutate(form = ifelse(data_frame == 'lookups',
                                      yes        = 'Lookups',
                                      no         = form),
                        form = ifelse(data_frame == 'lookups_form',
                                      yes        = 'Form Lookups (from Database Specifiation)',
                                      no         = form),
                        form = ifelse(data_frame == 'lookups_fields',
                                      yes        = 'Field Lookups (from Database Specification).',
                                      no         = form),
                        form = ifelse(data_frame == 'adverse_events_ae',
                                      yes        = 'Adverse Events - AeEvent.',
                                      no         = form),
                        form = ifelse(data_frame == 'baseline_medications_med',
                                      yes        = 'Baseline Medications - Med.',
                                      no         = form),
                        form = ifelse(data_frame == 'chemotherapy_chemotherapy',
                                      yes        = 'Chemotherapy Details.',
                                      no         = form),
                        form = ifelse(data_frame == 'transfers',
                                      yes        = 'Transfers of participants between sites.',
                                      no         = form),
                        form = ifelse(data_frame == 'sites',
                                      yes        = 'Study Site Details.',
                                      no         = form),
                        form = ifelse(data_frame == 'discrepancies',
                                      yes        = 'Discrepancies identified by Data Management.',
                                      no         = form),
                        form = ifelse(data_frame == 'unavailable_forms',
                                      yes        = 'Unavailable Froms.',
                                      no         = form),
                        form = ifelse(data_frame == 'forms',
                                      yes        = 'Available Forms.',
                                      no         = form),
                        form = ifelse(data_frame == 'annotations',
                                      yes        = 'Annotations.',
                                      no         = form),
                        form = ifelse(data_frame == 'individuals',
                                      yes        = 'Individuals.',
                                      no         = form),
                        form = ifelse(data_frame == 'db_spec_forms',
                                      yes        = 'Database Specification Forms.',
                                      no         = form),
                        form = ifelse(data_frame == 'baseline',
                                      yes        = 'Derived Baseline data frame.',
                                      no         = form),
                        form = ifelse(data_frame == 'therapy_qol',
                                      yes        = 'Derived Therapy and Quality of Life data frame.',
                                      no         = form),
                        form = ifelse(data_frame == 'rct',
                                      yes        = 'Derived RCT data frame.',
                                      no         = form),
                        form = ifelse(data_frame == 'duplicates',
                                      yes        = 'Data Frame indicating duplicates.',
                                      no         = form))

###################################################################################
## Define three lists that capture the variables for each set of surveys, these  ##
## are saved as part of the packages data frame for subsequent use               ##
###################################################################################
## Sets up some key components
all_var <- list()
all_var$eortc_c30 <- quos(c30_q1, c30_q2, c30_q3, c30_q4, c30_q5,
                       c30_q6, c30_q7, c30_q8, c30_q9, c30_q10,
                       c30_q11, c30_q12, c30_q13, c30_q14, c30_q15,
                       c30_q16, c30_q17, c30_q18, c30_q19, c30_q20,
                       c30_q21, c30_q22, c30_q23, c30_q24, c30_q25,
                       c30_q26, c30_q27, c30_q28, c30_q29, c30_q30,
                       ql_raw, ql_scale, pf_raw, pf_scale, rf_raw, rf_scale,
                       ef_raw,ef_scale, cf_raw,cf_scale, sf_raw, sf_scale,
                       fa_raw,fa_scale, nv_raw,nv_scale, pa_raw, pa_scale,
                       dy_scale, sl_scale, ap_scale, co_scale, di_scale, fi_scale)
all_var$eortc_br23 <- quos(br23_q31, br23_q32, br23_q33, br23_q34, br23_q35,
                          br23_q36, br23_q37, br23_q38, br23_q39, br23_q40,
                          br23_q41, br23_q42, br23_q43, br23_q44, br23_q45,
                          br23_q46, br23_q47, br23_q48, br23_q49, br23_q50,
                          br23_q51, br23_q52, br23_q53,
                          brbi_raw, brbi_scale, brsef_raw, brsef_scale, brsee_scale, brfu_scale,
                          brst_raw, brst_scale, brbs_raw, brbs_scale, bras_raw, bras_scale,
                          brhl_scale)
all_var$eortc_eld15 <- quos(eld15_q54, eld15_q55, eld15_q56, eld15_q57, eld15_q58,
                           eld15_q59, eld15_q60, eld15_q61, eld15_q62, eld15_q63, eld15_q64,
                           eld15_q65, eld15_q66, eld15_q67, eld15_q68, mo_raw, mo_scale,
                           wao_raw, wao_scale, wo_raw, wo_scale, mp_raw, mp_scale,
                           boi_raw, boi_scale, js_scale, fs_scale)
all_var$eq5d <- quos(mobility, self_care, usual_activity, pain_discomfort,
                    anxiety_depression, health_today, eq5d_number, eq5d_score)
all_var$therapy_assessment <- quos(any_treatment, endocrine_therapy, radiotherapy,
                                  chemotherapy, trastuzumab, surgery)
all_var$endocrine_therapy <- quos(primary_adjuvant, reason_pet, reason_pet_risk,
                                 reason_pet_spcfy, endocrine_type, endocrine_type_oth,
                                 therapy_changed, therapy_changed_dtls,
                                 compliance, endocrine_aes, et_hot_flushes, et_asthenia,
                                 et_joint_pain, et_vaginal_dryness, et_hair_thinning, et_rash,
                                 et_nausea, et_diarrhoea, et_headache, et_vaginal_bleeding,
                                 et_vomiting, et_somnolence)
all_var$radiotherapy <- quos(which_breast_right, r_site_breast,
                             r_site_axilla, r_site_supraclavicular, r_site_chest_wall,
                             r_site_other, r_breast_fractions, r_axilla_fractions,
                             r_supra_fractions, r_chest_fractions, r_other_fractions,
                             r_radiotherapy_aes, r_skin_erythema, r_pain, r_breast_oedema,
                             r_breast_shrink, r_breast_pain,
                             which_breast_left, l_site_breast,
                             l_site_axilla, l_site_supraclavicular, l_site_chest_wall,
                             l_site_other, l_breast_fractions, l_axilla_fractions,
                             l_supra_fractions, l_chest_fractions, l_other_fractions,
                             l_radiotherapy_aes, l_skin_erythema, l_pain, l_breast_oedema,
                             l_breast_shrink, l_breast_pain)
all_var$chemotherapy <- quos(chemo_received, chemo_aes,
                            c_fatigue, c_anaemia, c_low_wc_count, c_thrombocytopenia, c_allergic,
                            c_hair_thinning, c_nausea, c_infection)
all_var$trastuzumab <- quos(trast_received, infusion_no, trast_aes, t_cardiac_fail,
                            t_flu_like, t_nausea, t_diarrhoea, t_headache, t_allergy)
all_var$clinical_assessment_non_pet <- quos(recurrence, recurrence_dt, recurrence_where_breast,
                                           recurrence_where_chest_wall, recurrence_where_axilla,
                                           recurrence_where_metastatic, recurrence_met_bone,
                                           recurrence_met_liver, recurrence_met_lung,
                                           recurrence_met_superclavicular, recurrence_met_brain,
                                           recurrence_met_other,
                                           recurrence_met_spcfy, new_tumour_yn, new_tumour_dtls,
                                           clinical_plan, plan_local_surgery, plan_local_radio,
                                           plan_local_endocrine, plan_local_chemo, plan_local_trast,
                                           plan_local_oth, plan_local_spcfy, plan_met_radio,
                                           plan_met_endocrine, plan_met_chemo, plan_met_trast,
                                           plan_met_oth, plan_met_spcfy, plan_routine_surgery,
                                           plan_routine_radio, plan_routine_endocrine, plan_routine_chemo,
                                           plan_routine_trast, plan_routine_oth, plan_routine_spcfy)
all_var$clinical_assessment_pet <- quos(uni_bilateral_pet, primary_tumour_pet, r_focal_pet,
                                        r_num_tumours_pet, r_cancer_palpable_pet, r_size_clin_assess_pet,
                                        r_method_assess_pet, r_size_ultrasound_pet,r_size_mammo_pet,
                                        r_axillary_present_pet, r_axillary_nodes_pet, r_axillary_axis_pet,
                                        l_focal_pet, l_num_tumours_pet, l_cancer_palpable_pet,
                                        l_size_clin_assess_pet, l_method_assess_pet, l_size_ultrasound_pet,
                                        l_size_mammo_pet, l_axillary_present_pet, l_axillary_nodes_pet,
                                        l_axillary_axis_pet, metastatic, metastatic_where_bone,
                                        metastatic_where_lung, metastatic_where_cervical_node, metastatic_where_other,
                                        metastatic_where_liver, metastatic_where_brain, proposed_treat,
                                        clinical_plan2, plan_change_surgery, plan_change_radio,
                                        plan_change_antioestrogen, plan_change_oth,plan_change_spcfy)

## Survey responses (i.e. categorical factor_vars)
## Sets up some key components
factor_vars <- list()
factor_vars$eortc_c30 <- quos(c30_q1, c30_q2, c30_q3, c30_q4, c30_q5,
                             c30_q6, c30_q7, c30_q8, c30_q9, c30_q10,
                             c30_q11, c30_q12, c30_q13, c30_q14, c30_q15,
                             c30_q16, c30_q17, c30_q18, c30_q19, c30_q20,
                             c30_q21, c30_q22, c30_q23, c30_q24, c30_q25,
                             c30_q26, c30_q27, c30_q28, c30_q29, c30_q30)
factor_vars$eortc_br23 <- quos(br23_q31, br23_q32, br23_q33, br23_q34, br23_q35,
                              br23_q36, br23_q37, br23_q38, br23_q39, br23_q40,
                              br23_q41, br23_q42, br23_q43, br23_q44, br23_q45,
                              br23_q46, br23_q47, br23_q48, br23_q49, br23_q50,
                              br23_q51, br23_q52, br23_q53)
factor_vars$eortc_eld15 <- quos(eld15_q54, eld15_q55, eld15_q56, eld15_q57, eld15_q58,
                               eld15_q59, eld15_q60, eld15_q61, eld15_q62, eld15_q63, eld15_q64,
                               eld15_q65, eld15_q66, eld15_q67, eld15_q68)
factor_vars$eq5d <- quos(eq5d_number, eq5d_score)
factor_vars$therapy_assessment <- quos()
factor_vars$endocrine_therapy <- quos(primary_adjuvant, reason_pet, endocrine_type,
                                     therapy_changed, compliance, endocrine_aes,
                                     et_hot_flushes, et_asthenia, et_joint_pain,
                                     et_vaginal_dryness, et_hair_thinning, et_rash,
                                     et_nausea, et_diarrhoea, et_headache, et_vaginal_bleeding,
                                     et_vomiting, et_somnolence)
factor_vars$radiotherapy <- quos(which_breast_right, r_site_breast,
                                 r_site_axilla, r_site_supraclavicular, r_site_chest_wall,
                                 r_site_other, r_radiotherapy_aes, r_skin_erythema, r_pain,
                                 r_breast_oedema, r_breast_shrink, r_breast_pain,
                                 which_breast_left, l_site_breast,
                                 l_site_axilla, l_site_supraclaviculal, l_site_chest_wall,
                                 l_site_othel, l_radiotherapy_aes, l_skin_erythema, l_pain,
                                 l_breast_oedema, l_breast_shrink, l_breast_pain)
factor_vars$chemotherapy <- quos(chemo_received, chemo_aes,
                                c_fatigue, c_anaemia, c_low_wc_count, c_thrombocytopenia, c_allergic,
                                c_hair_thinning, c_nausea, c_infection)
factor_vars$trastuzumab <- quos(which_breast_right, r_site_breast, r_site_axilla,
                                r_site_supraclavicular, r_site_chest_wall, r_site_other,

     trast_received, infusion_no, trast_aes, t_cardiac_fail,
                               t_flu_like, t_nausea, t_diarrhoea, t_headache, t_allergy)
factor_vars$clinical_assessment_non_pet <- quos(recurrence, new_tumour_yn,  clinical_plan)
factor_vars$clinical_assessment_pet <- quos(which_breast_right, r_site_breast, r_site_axilla,
                                            r_site_supraclavicular, r_site_chest_wall,
                                            r_site_other, r_radiotherapy_aes,
                                            r_skin_erythema, r_pain, r_breast_oedema, r_breast_shrink,
                                            r_breast_pain,
                                            which_breast_left, l_site_breast, l_site_axilla,
                                            l_site_supraclaviculal, l_site_chest_wall,
                                            l_site_othel, l_radiotherapy_aes,
                                            l_skin_erythema, l_pain, l_breast_oedema, l_breast_shrink,
                                            l_breast_pain,
                                            metastatic, metatstatic_where_bone, metastatic_where_brain,
                                            metatstatc_where_cervical_node, metatstatc_where_liver,
                                            metastatic_where_lung, metastatic_where_other,
                                            plan_change_antioestrogen, plan_change_oth,
                                            plan_change_radio, plan_change_spcfy, plan_change_surgery_o)

## Continuous responses
## Sets up some key components
continuous_vars <- list()
continuous_vars$eortc_c30 <- quos(ql_raw, ql_scale, pf_raw, pf_scale, rf_raw, rf_scale,
                                 ef_raw,ef_scale, cf_raw,cf_scale, sf_raw,sf_scale,
                                 fa_raw,fa_scale, nv_raw,nv_scale, pa_raw,pa_scale,
                                 dy_scale, sl_scale, ap_scale, co_scale, di_scale, fi_scale)
continuous_vars$eortc_br23 <- quos(brbi_raw, brbi_scale, brsef_raw, brsef_scale, brsee_scale, brfu_scale,
                                  brst_raw, brst_scale, brbs_raw, brbs_scale, bras_raw, bras_scale,
                                  brhl_scale)
continuous_vars$eortc_eld15 <- quos(mo_raw, mo_scale,
                                   wao_raw, wao_scale, wo_raw, wo_scale, mp_raw, mp_scale,
                                   boi_raw, boi_scale, js_scale, fs_scale)
continuous_vars$eq5d <- quos(eq5d_number, eq5d_score)
continuous_vars$therapy_assessment <- quos()
continuous_vars$endocrine_therapy <- quos()
continuous_vars$radiotherapy <- quos(r_breast_fractions, r_axilla_fractions,
                                     r_supra_fractions, r_chest_fractions, r_other_fractions,
                                     l_breast_fractions, l_axilla_fractions,
                                     l_supra_fractions, l_chest_fractions, l_other_fractions)
continuous_vars$chemotherapy <- quos()
continuous_vars$trastuzumab <- quos(infusion_no)
continuous_vars$clinical_assessment_non_pet <- quos(recurrence_dt, recurrence_where_breast,
                                                   recurrence_where_chest_wall, recurrence_where_axilla,
                                                   recurrence_where_metastatic, recurrence_met_bone,
                                                   recurrence_met_liver, recurrence_met_lung,
                                                   recurrence_met_superclavicular, recurrence_met_brain,
                                                   recurrence_met_other, recurrence_met_spcfy, plan_local_surgery,
                                                   plan_local_radio,
                                                   plan_local_endocrine, plan_local_chemo, plan_local_trast,
                                                   plan_local_oth, plan_local_spcfy, plan_met_radio,
                                                   plan_met_endocrine, plan_met_chemo, plan_met_trast,
                                                   plan_met_oth, plan_met_spcfy, plan_routine_surgery,
                                                   plan_routine_radio, plan_routine_endocrine, plan_routine_chemo,
                                                   plan_routine_trast, plan_routine_oth, plan_routine_spcfy)
continuous_vars$clinical_assessment_pet <- quos(r_breast_fractions, r_axilla_fractions, r_supra_fractions,
                                                r_chest_fractions, r_other_fractions,
                                                l_breast_fractions, l_axilla_fractions, l_supra_fractions,
                                                l_chest_fractions, l_other_fractions)

###################################################################################
## Save and Export                                                               ##
###################################################################################
save(master, age_gap,
     all_var, factor_vars, continuous_vars,
     file = '../data/age-gap.RData',
     compression_level = 9)
## write_dta(age_gap, version = 14, path = 'stata/age_gap.dta')
