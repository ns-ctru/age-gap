## Filename    : import.R
## Author      : n.shephard@sheffield.ac.uk
## Description : Imports the CSV files exported from the Prospect database
##               and recreates a lot of the links that existed there to
##               produce one single data set for analysis
library(ctru)

###################################################################################
## Script specific functions (unlikely to ever be needed elsewhere)              ##
###################################################################################
agegap_rename_events <- function(df = .,
                                 ...){
    df <- df %>%
          mutate(event_name = gsub('RCT ',      '',         event_name),
                 event_name = gsub('baseline',  'Baseline', event_name),
                 event_name = gsub('treatment', 'Baseline', event_name))
    return(df)
}

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
##
## NB : Not actually required due to Prospect exporting 'Sites.csv'
## master$sites <- read.csv(file = 'Age Gap database specification - Sites.csv',
##                          header = TRUE)
## master$sites <- master$sites %>%
##                 dplyr::select(Name, Site.group, RCT.date, PE.site)
## names(master$sites) <- names(master$sites) %>% tolower()
## names(master$sites) <- gsub('\\.', '_', names(master$sites))
## names(master$sites) <- gsub('name', 'site', names(master$sites))
## File   : Age Gap database specification - Fields.csv
## Source : https://goo.gl/oFBs4j
master$lookups_fields <- read.csv(file = 'Age Gap database specification - Fields.csv',
                                  header = TRUE,
                                  stringsAsFactors = FALSE)
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
                               c('Radiotherapy', '', 'which_breast_right_radio', 'Right Breast treated with Radiotherapy'),
                               c('Radiotherapy', '', 'r_site_breast', 'Treatment Site (Right) : Breast'),
                               c('Radiotherapy', '', 'r_site_axilla', 'Treatment Site (Right) : Axilla'),
                               c('Radiotherapy', '', 'r_site_supraclavicular', 'Treatment Site (Right) : Suprclavicular'),
                               c('Radiotherapy', '', 'r_site_chest_wall', 'Treatment Site (Right) : Chest Wall'),
                               c('Radiotherapy', '', 'r_sitether', 'Treatment Site (Right) : Other'),
                               c('Radiotherapy', '', 'which_breast_left_radio', 'Left Breast treated with Radiotherapy'),
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
                               c('Surgery and Post Operative Pathology', '', 'which_breast_right_surgery', 'Surgery and Post Operative Pathology of Right Breast'),
                               c('Surgery and Post Operative Pathology', '', 'which_breast_left_surgery', 'Surgery and Post Operative Pathology of Right Left'),
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
## Derive overall allred/h_score_her_2_score at baseline, do this here so that
## merged and available across all time points
master$baseline_tumour_assessment <- mutate(master$baseline_tumour_assessment,
                                            allred_baseline           = pmax(l_allred_baseline, r_allred_baseline, na.rm = TRUE),
                                            h_score_baseline          = pmax(l_h_score_baseline, r_h_score_baseline, na.rm = TRUE),
                                            her_2_score_baseline      = pmax(l_her_2_score_baseline, r_h_score_baseline, na.rm = TRUE),
                                            pgr_score_baseline        = pmax(l_pgr_score_baseline, r_pgr_score_baseline),
                                            histo_grade_baseline      = pmax(l_histo_grade_baseline, r_histo_grade_baseline, na.rm = TRUE),
                                            histo_subtype_baseline    = pmax(l_histo_subtype_baseline, r_histo_subtype_baseline, na.rm = TRUE),
                                            focal_baseline            = pmax(l_focal_baseline, r_focal_baseline),
                                            num_tumours_baseline      = pmax(l_num_tumours_baseline, r_num_tumours_baseline),
                                            cancer_palpable_baseline  = pmax(l_cancer_palpable_baseline, r_cancer_palpable_baseline),
                                            size_clin_assess_baseline = pmax(l_size_clin_assess_baseline, r_size_clin_assess_baseline),
                                            method_assess_baseline    = pmax(l_method_assess_baseline, r_method_assess_baseline),
                                            size_ultrasound_baseline  = pmax(l_size_ultrasound_baseline, r_size_ultrasound_baseline),
                                            size_mammo_baseline       = pmax(l_size_mammo_baseline, r_size_mammo_baseline),
                                            axillary_present_baseline = pmax(l_axillary_present_baseline, r_axillary_present_baseline),
                                            axillary_nodes_baseline   = pmax(l_axillary_nodes_baseline, r_axillary_nodes_baseline),
                                            axillary_axis_baseline    = pmax(l_axillary_axis_baseline, r_axillary_axis_baseline),
                                            biopsy_type_baseline      = pmax(l_biopsy_type_baseline, r_biopsy_type_baseline),
                                            confirm_present_baseline  = pmax(l_confirm_present_baseline, r_confirm_present_baseline),
                                            histo_spcfy_baseline      = pmax(l_histo_spcfy_baseline, r_histo_spcfy_baseline)) %>%
## Define Estrogen Receptor status of tumurs based on...
## allred  | ER Status
## --------+-------------------
## 0-2     | ER Negative
## 3-8     | ER Positive
    mutate(er_tumour = case_when(allred_baseline <= 2 ~ 'ER Negative',
                                 allred_baseline >= 3 ~ 'ER Positive'),
           er_tumour = factor(er_tumour))
## File : Breast Cancer Treatment Choices - chemo vs no chemo.csv
master$breast_cancer_treatment_choices_chemo_no_chemo <- read_prospect(file = 'Breast Cancer Treatment Choices - chemo vs no chemo.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookups)
master$breast_cancer_treatment_choices_chemo_no_chemo <- agegap_rename_events(df = master$breast_cancer_treatment_choices_chemo_no_chemo)
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
master$breast_cancer_treatment_choices_surgery_pills <- agegap_rename_events(df = master$breast_cancer_treatment_choices_surgery_pills)
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
master$brief_cope <- agegap_rename_events(df = master$brief_cope)
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
names(master$chemotherapy) <- gsub('assessment_dt',
                                   'assessment_dt_chemotherapy',
                                   names(master$chemotherapy))
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
master$collaborate <- agegap_rename_events(df = master$collaborate)
names(master$collaborate) <- gsub('calc_score', 'collaborate_calc_score', names(master$collaborate))
## File : Consent Form.csv
master$consent_form <- read_prospect(file = 'Consent Form.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookups)
names(master$consent_form) <- gsub("screening_no", "screening", names(master$consent_form))
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
master$decision_regret_scale <- agegap_rename_events(df = master$decision_regret_scale)
names(master$decision_regret_scale) <- gsub('calc_score', 'decision_regret_scale_calc_score', names(master$decision_regret_scale))
## File : Discussing treatment options.csv
master$discussing_treatment_options <- read_prospect(file = 'Discussing treatment options.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookups)
master$discussing_treatment_options <- agegap_rename_events(df = master$discussing_treatment_options)
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
names(master$endocrine_therapy) <- gsub('assessment_dt',
                                        'assessment_dt_endocrine',
                                        names(master$endocrine_therapy))
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
master$process_evaluation <- agegap_rename_events(df = master$process_evaluation)
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
names(master$radiotherapy) <- gsub('which_breast_right',
                                   'which_breast_right_radio',
                                   names(master$radiotherapy))
names(master$radiotherapy) <- gsub('which_breast_left',
                                   'which_breast_left_radio',
                                   names(master$radiotherapy))
names(master$radiotherapy) <- gsub('assessment_dt',
                                   'assessment_dt_radiotherapy',
                                   names(master$radiotherapy))
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
master$spielberger_state_trait_anxiety <- agegap_rename_events(df = master$spielberger_state_trait_anxiety)
## File : Study completion  discontinuation form.csv
master$study_completion_discontinuation_form <- read_prospect(file = 'Study completion  discontinuation form.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookups)
## 2018-01-29 : Rename the event_date which is required because the study completion and
##              discontinuation form is NOT always completed at 2 year follow up, it is
##              very often recorded _after_
master$study_completion_discontinuation_form <- master$study_completion_discontinuation_form %>%
                                                mutate(study_completion_dt = event_date)
## File : Surgery and Post Operative Pathology.csv
master$surgery_and_post_operative_pathology <- read_prospect(file = 'Surgery and Post Operative Pathology.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookups)
names(master$surgery_and_post_operative_pathology) <- gsub('which_breast_right',
                                                           'which_breast_right_surgery',
                                                           names(master$surgery_and_post_operative_pathology))
names(master$surgery_and_post_operative_pathology) <- gsub('which_breast_left',
                                                           'which_breast_left_surgery',
                                                           names(master$surgery_and_post_operative_pathology))
## 2018-01-04 - Some people have had multiple surgical procedures, but since the dates
##              are not recorded its impossible to say which came first.  However, to avoid
##              duplicates creeping in we must now uniquely name their event_name
master$surgery_and_post_operative_pathology <- master$surgery_and_post_operative_pathology %>%
                                               group_by(individual_id) %>%
                                               mutate(event_name = paste0(event_name, ' ', 1:n()))
## File : The Brief Illness Perception Questionnaire (BIPQ).csv
master$the_brief_illness_perception_questionnaire <- read_prospect(file = 'The Brief Illness Perception Questionnaire (BIPQ).csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookups)
master$the_brief_illness_perception_questionnaire <- agegap_rename_events(df = master$the_brief_illness_perception_questionnaire)
## File : Therapy Assessment.csv
master$therapy_assessment <- read_prospect(file = 'Therapy Assessment.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookups)
## The indicators encorine_therapy, chemotherapy, radiotherapy, surgery and trastuzumab only
## indicate if the respective treatment has been received at a given assessment, and are
## therefore not useful when summarising at baseline, since no one will have received any
## therapy at that time point.  Therefore need to construct an indicator of ever having
## received each type of therapy
## master$therapy_ever <- master$therapy_assessment %>%
##                        dplyr::select(individual_id,
##                                      event_name,
##                                      endocrine_therapy,
##                                      radiotherapy,
##                                      chemotherapy,
##                                      trastuzumab,
##                                      surgery) %>%
##                        melt(id.vars = c('individual_id', 'event_name'),
##                             measure.vars = c('endocrine_therapy',
##                                              'radiotherapy',
##                                              'chemotherapy',
##                                              'trastuzumab',
##                                              'surgery')) %>%
##                        mutate(event_name = gsub(' ', '_', event_name)) %>%
##                        dcast(individual_id ~ variable + event_name) %>%
##                        mutate(endocrine_therapy_ever = ifelse(endocrine_therapy_6_weeks   == 'Yes' |
##                                                 endocrine_therapy_6_months  == 'Yes' |
##                                                 endocrine_therapy_12_months == 'Yes' |
##                                                 endocrine_therapy_18_months == 'Yes' |
##                                                 endocrine_therapy_24_months == 'Yes',
##                                                 yes = 'Yes',
##                                                 no  = 'No'),
##                               endocrine_therapy_ever = ifelse(!is.na(endocrine_therapy_ever),
##                                                 yes = endocrine_therapy_ever,
##                                                 no  = 'No'),
##                               endocrine_therapy_ever = factor(endocrine_therapy_ever,
##                                                 levels = c('No', 'Yes')),
##                               chemotherapy_ever = ifelse(chemotherapy_6_weeks   == 'Yes' |
##                                                          chemotherapy_6_months  == 'Yes' |
##                                                          chemotherapy_12_months == 'Yes' |
##                                                          chemotherapy_18_months == 'Yes' |
##                                                          chemotherapy_24_months == 'Yes',
##                                                          yes = 'Yes',
##                                                          no  = 'No'),
##                               chemotherapy_ever = ifelse(!is.na(chemotherapy_ever),
##                                                          yes = chemotherapy_ever,
##                                                          no  = 'No'),
##                               chemotherapy_ever = factor(chemotherapy_ever,
##                                                          levels = c('No', 'Yes')),
##                               radiotherapy_ever = ifelse(radiotherapy_6_weeks   == 'Yes' |
##                                                          radiotherapy_6_months  == 'Yes' |
##                                                          radiotherapy_12_months == 'Yes' |
##                                                          radiotherapy_18_months == 'Yes' |
##                                                          radiotherapy_24_months == 'Yes',
##                                                          yes = 'Yes',
##                                                          no  = 'No'),
##                               radiotherapy_ever = ifelse(!is.na(radiotherapy_ever),
##                                                          yes = radiotherapy_ever,
##                                                          no  = 'No'),
##                               radiotherapy_ever = factor(radiotherapy_ever,
##                                        levels = c('No', 'Yes')),
##                               trastuzumab_ever = ifelse(trastuzumab_6_weeks   == 'Yes' |
##                                                         trastuzumab_6_months  == 'Yes' |
##                                                         trastuzumab_12_months == 'Yes' |
##                                                         trastuzumab_18_months == 'Yes' |
##                                                         trastuzumab_24_months == 'Yes',
##                                                         yes = 'Yes',
##                                                         no  = 'No'),
##                               trastuzumab_ever = ifelse(!is.na(trastuzumab_ever),
##                                                         yes = trastuzumab_ever,
##                                                         no  = 'No'),
##                               trastuzumab_ever = factor(trastuzumab_ever,
##                                                         levels = c('No', 'Yes')),
##                               surgery_ever = ifelse(surgery_6_weeks   == 'Yes' |
##                                                     surgery_6_months  == 'Yes' |
##                                                     surgery_12_months == 'Yes' |
##                                                     surgery_18_months == 'Yes' |
##                                                     surgery_24_months == 'Yes',
##                                                     yes = 'Yes',
##                                                     no  = 'No'),
##                               surgery_ever = ifelse(!is.na(surgery_ever),
##                                                     yes = surgery_ever,
##                                                     no  = 'No'),
##                               surgery_ever = factor(surgery_ever,
##                                                     levels = c('No', 'Yes'))) %>%
##                        dplyr::select(individual_id, endocrine_therapy_ever, chemotherapy_ever, radiotherapy_ever,
##                                      trastuzumab_ever, surgery_ever)
## Rather than whether someone has ever received a treatment instead record whether they have received a
## given treatment between baseline and the noted event_[name|date].  Ideally I think we would want to
## know the date on which therapy was received, but this doesn't appear to be available for anything.
master$therapy_ever <- master$therapy_assessment %>%
                       dplyr::select(individual_id,
                                     event_name,
                                     event_date,
                                     endocrine_therapy,
                                     radiotherapy,
                                     chemotherapy,
                                     trastuzumab,
                                     surgery) %>%
                       melt(id.vars = c('individual_id', 'event_name', 'event_date'),
                            measure.vars = c('endocrine_therapy',
                                             'radiotherapy',
                                             'chemotherapy',
                                             'trastuzumab',
                                             'surgery')) %>%
                       group_by(individual_id, variable) %>%
                       mutate(lag1 = dplyr::lag(value, n = 1, order_by = event_date),
                              lag2 = dplyr::lag(value, n = 2, order_by = event_date),
                              lag3 = dplyr::lag(value, n = 3, order_by = event_date),
                              lag4 = dplyr::lag(value, n = 4, order_by = event_date),
                              lag5 = dplyr::lag(value, n = 5, order_by = event_date)) %>%
                       ungroup() %>%
                       mutate(value = case_when(value == 'Yes' |
                                                lag1  == 'Yes' |
                                                lag2  == 'Yes' |
                                                lag3  == 'Yes' |
                                                lag4  == 'Yes' |
                                                lag5  == 'Yes' ~ 'Yes'),
                              value = ifelse(!is.na(value),
                                             no  = 'No',
                                             yes = value),
                              value = factor(value),
                              ## Need to make therapy names unique to avoid conflict when merging
                              variable = paste0(variable, '_received_yet' )) %>%
                       dplyr::select(-lag1, -lag2, -lag3, -lag4, -lag5) %>%
                       dcast(individual_id + event_name + event_date ~ variable, value.var = 'value') %>%
                       ## Derive 'ever' treatment indicators
                       group_by(individual_id) %>%
                       mutate(endocrine_therapy_ever  = max(endocrine_therapy_received_yet),
                              chemotherapy_ever       = max(chemotherapy_received_yet),
                              radiotherapy_ever       = max(radiotherapy_received_yet),
                              surgery_ever            = max(surgery_received_yet),
                              trastuzumab_ever        = max(trastuzumab_received_yet))
## File : Trastuzumab.csv
master$trastuzumab <- read_prospect(file = 'Trastuzumab.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookups)
names(master$trastuzumab) <- gsub('assessment_dt',
                                  'assessment_dt_trastuzumab',
                                  names(master$trastuzumab))
## File : Treatment decision.csv
master$treatment_decision <- read_prospect(file = 'Treatment decision.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookups)
master$treatment_decision <- agegap_rename_events(df = master$treatment_decision)
## File : Treatment decision support consultations.csv
master$treatment_decision_support_consultations <- read_prospect(file = 'Treatment decision support consultations.csv',
                         header              = TRUE,
                         sep                 = ',',
                         convert.dates       = TRUE,
                         convert.underscores = TRUE,
                         dictionary          = master$lookups)
master$treatment_decision_support_consultations <- agegap_rename_events(df = master$treatment_decision_support_consultations)
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
## This may not be required, its possible all scores have been derived within    ##
## Prospect                                                                      ##
###################################################################################
## EQ5D
## TODO - Need to get eq5d_score() function in CTRU package working with Non-Standard
##        Evaluation/Scoping

###################################################################################
## Data Frame                                                                    ##
###################################################################################
## Derive a single data frame for all data components

###################################################################################
## Extract event_date for merging later, this is required because some           ##
## individualsa do not have an event_date for eortc_qlq_c30 which was originally ##
## the source of inclusion, hence when then merging the event_date was always    ##
## missing                                                                       ##
###################################################################################
common <- c('individual_id', 'site', 'event_name', 'event_date')
master$event_date <- rbind(master$abridged_patient_assessment[, common],
                           master$activities_daily_living[, common],
                           master$adverse_events_ae[, common],
                           master$adverse_events[, common],
                           master$baseline_medications[, common],
                           master$baseline_medications_med[, common],
                           master$baseline_tumour_assessment[, common],
                           master$breast_cancer_treatment_choices_chemo_no_chemo[, common],
                           master$breast_cancer_treatment_choices_surgery_pills[, common],
                           master$brief_cope[, common],
                           master$change_in_participation[, common],
                           master$chemotherapy_chemotherapy[, common],
                           master$chemotherapy[, common],
                           master$clinical_assessment_non_pet[, common],
                           master$clinical_assessment_pet[, common],
                           master$collaborate[, common],
                           master$consent_form[, common],
                           master$decision_making_preferences[, common],
                           master$decision_regret_scale[, common],
                           master$discussing_treatment_options[, common],
                           master$ecog_performance_status_score[, common],
                           master$eligibility_checklist[, common],
                           master$endocrine_therapy[, common],
                           master$eortc_qlq_br23[, common],
                           master$eortc_qlq_c30[, common],
                           master$eortc_qlq_eld15[, common],
                           master$eq5d[, common],
                           master$instrumental_activities_daily_living[, common],
                           master$mini_mental_state_examination[, common],
                           master$modified_charlson_comorbidity[, common],
                           master$process_evaluation_log[, common],
                           master$process_evaluation[, common],
                           master$qol_lol_questionnaire[, common],
                           master$radiotherapy[, common], #
                           master$screening_form[, common],
                           master$spielberger_state_trait_anxiety[, common],
                           master$study_completion_discontinuation_form[, common],
                           ## master$surgery_and_post_operative_pathology[, common],
                           master$the_brief_illness_perception_questionnaire[, common],
                           master$therapy_assessment[, common],
                           master$trastuzumab[, common],
                           master$treatment_decision[, common],
                           master$treatment_decision_support_consultations[, common]) %>%
    ## Remove duplicates and instances with missing dates
    unique() %>%
    dplyr::filter(!is.na(event_date)) %>%
    dplyr::filter(event_name != 'RCT 6 weeks') %>%
    dplyr::filter(event_name != 'Screening') %>%
    mutate(event_name = factor(event_name,
                               levels = c('Baseline',
                                          ## 'RCT baseline',
                                          ## 'RCT treatment',
                                          '6 weeks',
                                          ## 'RCT 6 weeks',
                                          '6 months',
                                          ## 'RCT 6 months',
                                          '12 months',
                                          '18 months',
                                          '24 months'))) %>%
    arrange(individual_id, event_date)

## Consent and Baseline Tumor Assessment
## NB - 'event_name' is NOT used from master$consent_form since these are all 'Screening' and
##      all that is required is pulling in the four non-matching variables with the baseline
master$baseline <- full_join(dplyr::select(master$consent_form,
                                           individual_id, site, ## event_name, event_date, database_id,
                                           screening, dob, participation_lvl, consent_dt),
                             dplyr::select(master$baseline_tumour_assessment,
                                           individual_id,
                                           ## enrolment_no,
                                           randomisation,
                                           site,
                                           event_name,
                                           ## event_date,
                                           ## database_id,
                                           uni_bilateral_baseline,
                                           primary_tumour_baseline,
                                           focal_baseline,
                                           num_tumours_baseline,
                                           cancer_palpable_baseline,
                                           size_clin_assess_baseline,
                                           method_assess_baseline,
                                           size_ultrasound_baseline,
                                           size_mammo_baseline,
                                           axillary_present_baseline,
                                           axillary_nodes_baseline,
                                           axillary_axis_baseline,
                                           biopsy_type_baseline,
                                           confirm_present_baseline,
                                           histo_grade_baseline,
                                           histo_subtype_baseline,
                                           histo_spcfy_baseline,
                                           allred_baseline,
                                           h_score_baseline,
                                           her_2_score_baseline,
                                           pgr_score_baseline,
                                           er_tumour,
                                           taking_meds_baseline),
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
                                          reading_1, writing_1, drawing_1, mmse_score),
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
## Modified Charlson Co-Morbidity
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
                            by = c('individual_id', 'site', 'event_name')) %>%
## Ethnicity
           full_join(.,
                     dplyr::select(master$screening_form,
                                   individual_id, site, event_name, ## event_date, database_id,
                                   ethnicity) %>%
                     mutate(event_name = "Baseline"))## %>%

## Site Randomisation
                  ## full_join(.,
                  ##           dplyr::select(master$sites,
                  ##                         site, group, pe_site, qol_sub_study),
                  ##           by = c('site'))
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
                                              individual_id, site, event_name, database_id, ## event_date,
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
                                              assessment_dt_endocrine,
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
                                              assessment_dt_radiotherapy,
                                              which_breast_right_radio, which_breast_left_radio, r_site_breast,
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
                                              assessment_dt_chemotherapy,
                                              chemo_received, chemo_aes,
                                              c_fatigue, c_anaemia, c_low_wc_count, c_thrombocytopenia, c_allergic,
                                              c_hair_thinning, c_nausea, c_infection),
                                by = c('individual_id', 'site', 'event_name')) %>%
## Surgery
                      full_join(.,
                                dplyr::select(master$surgery_and_post_operative_pathology,
                                              individual_id, site, event_name, ## event_date, database_id,
                                              surgery_dt,
                                              general_local,
                                              which_breast_right_surgery,
                                              which_breast_left_surgery,
                                              r_surgery_type,
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
                                              l_nodes_involved,
                                              surgery_aes_acute_gen,
                                              sa_somnolence,
                                              sa_allergic,
                                              sa_arrhythmia,
                                              sa_dvt_embolism,
                                              sa_infarction,
                                              sa_stroke,
                                              sa_atelectasis),
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
                                              assessment_dt_trastuzumab,
                                              trast_received, infusion_no, trast_aes, t_cardiac_fail,
                                              t_flu_like, t_nausea, t_diarrhoea, t_headache, t_allergy),
                                by = c('individual_id', 'site', 'event_name')) ## %>%
## Site Randomisation
                      ## full_join(.,
                      ##           dplyr::select(master$sites,
                      ##                         site, group, pe_site, qol_sub_study),
                      ##           by = c('site'))

###################################################################################
## Combine the RCT components                                                    ##
###################################################################################
## Treatment Decision Support Consultations + Treatment Decision
master$rct <- full_join(dplyr::select(master$treatment_decision_support_consultations,
                                      individual_id, site, event_name, ## event_date, database_id,
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
## Breast Cancer Treatment Choices - chemo vs no chemo
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
                        by = c('individual_id', 'site', 'event_name')) ## %>%
## Site Randomisation
              ## full_join(.,
              ##           dplyr::select(master$sites,
              ##                         site, group, pe_site, qol_sub_study),
              ##           by = c('site'))
###################################################################################
## Combine baseline and multiple timepoints into one coherent data frame         ##
###################################################################################
age_gap <- full_join(master$therapy_qol,
                     master$baseline,
                     by = c('individual_id', 'site', 'event_name')) %>%
           full_join(.,
                     master$rct,
                     by = c('individual_id', 'site', 'event_name')) %>%
## Study completion discontinuation form (deaths/censoring)
           left_join(.,
                     dplyr::select(master$study_completion_discontinuation_form,
                                   individual_id, site, ## event_name, event_date, database_id,
                                   study_completion_dt,
                                   disc_death_dt,
                                   disc_rsn,
                                   death_cause_1,
                                   death_cause_2,
                                   death_cause_3),
                     by = c('individual_id', 'site')) %>%
## Merge in the event_date (use left_join() so that all data is retained, but exclude instances
## where there is an individual_id/site/event_name without any data)
           left_join(.,
                     master$event_date,
                     by = c('individual_id', 'site', 'event_name')) %>%
## Convert event_name to a factor so that it will plot in the correct order in all
## subsequent uses
           mutate(event_name = factor(event_name,
                                      levels = c('Baseline',
                                                 ## 'RCT baseline',
                                                 ## 'RCT treatment',
                                                 '6 weeks',
                                                 ## 'RCT 6 weeks',
                                                 '6 months',
                                                 ## 'RCT 6 months',
                                                 '12 months',
                                                 '18 months',
                                                 '24 months',
                                                 'Surgery'))) %>%
## The site allocation so that RCT component can be conducted
           left_join(.,
                     dplyr::select(master$sites,
                                   site, group, rct_date, pe_site, qol_sub_study),
                     by = c('site')) %>%
## And finally the treatments received by a given follow-up
           full_join(.,
                     master$therapy_ever,
                     by = c('individual_id', 'event_name', 'event_date'))

###################################################################################
## Check for duplicates that might have arisen                                   ##
###################################################################################
master$duplicates <- age_gap %>%
                     group_by(individual_id, site, event_name, event_date) %>%
    summarise(n = n())
###################################################################################
## There are a number of instances where there are no event_name, this seems     ##
## to be because the Eligibility form which is merged into age_gap consent_form  ##
## which is included since it contains the consent date (often a proxy for       ##
## baseline) includes those who did not consent, and in turn they have no        ##
## follow-up data nor associated events.  These are now removed.                 ##
###################################################################################
master$no_event <- age_gap %>%
                   dplyr::filter(is.na(event_name)) %>%
                   dplyr::select(individual_id, event_name, event_date)
age_gap <- age_gap %>%
           dplyr::filter(!is.na(event_name))
## HERE

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
                  site = gsub(' Teaching Hospitals$', '', site),
                  site = gsub(' Hospital$', '', site),
                  site = gsub(' Hospitals$', '', site),
                  site = gsub(' $', '', site)) %>%
## Convert all heights to same units (cm)
           mutate(height_cm = ifelse(is.na(height_cm),
                                     yes = 2.54 * ((height_ft * 12) + height_in),
                                     no  = height_cm)) %>%
## Derive BMI
           mutate(bmi = weight_kg / (height_cm /100)^2) %>%
## Derive an indicator of all of the possible combinations of treatment for each time point
           mutate(endocrine_therapy_t = ifelse(endocrine_therapy == 'Yes',
                                               yes = 'Endocrine + ',
                                               no  = ''),
                  radiotherapy_t = ifelse(radiotherapy == 'Yes',
                                                  yes = 'Radiotherapy + ',
                                                  no  = ''),
                  chemotherapy_t = ifelse(chemotherapy == 'Yes',
                                                  yes = 'Chemotherapy + ',
                                                  no  = ''),
                  trastuzumab_t = ifelse(trastuzumab == 'Yes',
                                                 yes = 'Trastuzumab + ',
                                                 no  = ''),
                  surgery_t = ifelse(surgery == 'Yes',
                                             yes = 'Surgery',
                                             no  = ''),
                  treatment_profile = paste0(endocrine_therapy_t,
                                             radiotherapy_t,
                                             chemotherapy_t,
                                             trastuzumab_t,
                                             surgery_t),
                  ## NB - Treated 'NA' for any treatment as 'No' otherwise 5550 observations
                  ##      could not be included (mostly 5513 are all 'No'
                  treatment_profile = gsub('NA', '', treatment_profile),
                  treatment_profile = gsub(' \\+ $', '', treatment_profile),
                  treatment_profile = ifelse(treatment_profile == '',
                                             yes = 'None',
                                             no  = treatment_profile),
                  ## Convert to factor and set reference level to be 'None'
                  treatment_profile = factor(treatment_profile),
                  treatment_profile = relevel(treatment_profile, ref = 'None'),
                  ## Binary indicator of whether there is missing data on treatment
                  treatment_missing = case_when(!is.na(endocrine_therapy) &
                                                !is.na(radiotherapy) &
                                                !is.na(chemotherapy) &
                                                !is.na(trastuzumab) &
                                                !is.na(surgery) ~ 'No missing treatment',
                                                is.na(endocrine_therapy) |
                                                is.na(radiotherapy) |
                                                is.na(chemotherapy) |
                                                is.na(trastuzumab) |
                                                is.na(surgery) ~ 'One or more missing treatment')) %>%
    dplyr::select(-endocrine_therapy_t, -radiotherapy_t, -chemotherapy_t, -trastuzumab_t, -surgery_t) %>%
########################################################################
## Treatment Profile                                                  ##
########################################################################
## Derive an indicator of all of the possible combinations of treatment ever received
           mutate(endocrine_therapy_t = ifelse(endocrine_therapy_ever == 'Yes',
                                               yes = 'Endocrine + ',
                                               no  = ''),
                  radiotherapy_t = ifelse(radiotherapy_ever == 'Yes',
                                                  yes = 'Radiotherapy + ',
                                                  no  = ''),
                  chemotherapy_t = ifelse(chemotherapy_ever == 'Yes',
                                                  yes = 'Chemotherapy + ',
                                                  no  = ''),
                  trastuzumab_t = ifelse(trastuzumab_ever == 'Yes',
                                                 yes = 'Trastuzumab + ',
                                                 no  = ''),
                  surgery_t = ifelse(surgery_ever == 'Yes',
                                             yes = 'Surgery',
                                             no  = ''),
                  treatment_profile_ever = paste0(endocrine_therapy_t,
                                             radiotherapy_t,
                                             chemotherapy_t,
                                             trastuzumab_t,
                                             surgery_t),
                  ## NB - Treated 'NA' for any treatment as 'No' otherwise 5550 observations
                  ##      could not be included (mostly 5513 are all 'No'
                  treatment_profile_ever = gsub('NA', '', treatment_profile_ever),
                  treatment_profile_ever = gsub(' \\+ $', '', treatment_profile_ever),
                  treatment_profile_ever = ifelse(treatment_profile_ever == '',
                                             yes = 'None',
                                             no  = treatment_profile_ever),
                  ## Convert to factor and set reference level to be 'None'
                  treatment_profile_ever = factor(treatment_profile_ever),
                  treatment_profile_ever = relevel(treatment_profile_ever, ref = 'None'),
                  ## Binary indicator of whether there is missing data on treatment
                  treatment_missing = case_when(!is.na(endocrine_therapy_ever) &
                                                !is.na(radiotherapy_ever) &
                                                !is.na(chemotherapy_ever) &
                                                !is.na(trastuzumab_ever) &
                                                !is.na(surgery_ever) ~ 'No missing treatment',
                                                is.na(endocrine_therapy_ever) |
                                                is.na(radiotherapy_ever) |
                                                is.na(chemotherapy_ever) |
                                                is.na(trastuzumab_ever) |
                                                is.na(surgery_ever) ~ 'One or more missing treatment')) %>%
           dplyr::select(-endocrine_therapy_t, -radiotherapy_t, -chemotherapy_t, -trastuzumab_t, -surgery_t) %>%
# Age based on Date of Birth
           mutate(age_exact = lubridate::new_interval(start = dob,
                                           end = consent_dt) / duration(num = 1, units = 'years'),
                  age_cat = case_when(age_exact >= 70 & age_exact < 75 ~ '70-74',
                                      age_exact >= 75 & age_exact < 80 ~ '75-79',
                                      age_exact >= 80 & age_exact < 85 ~ '80-84',
                                      age_exact >= 85                  ~ '>=85'),
                  age_cat = factor(age_cat,
                                   levels = c('70-74', '75-79', '80-84', '>=85'))) %>%
## ToDo - Categorisation of other baseline scores, awaiting SAP to be completed
## Categorise Charlson
           mutate(charlson_cat = case_when(cci_score <= 3                  ~ 'Low',
                                           cci_score > 3 & cci_score <= 7  ~ 'Moderate',
                                           cci_score > 7 & cci_score <= 11 ~ 'High',
                                           cci_score >= 12                 ~ 'Extreme'),
                  charlson_cat = factor(charlson_cat,
                                        levels = c('Low', 'Moderate', 'High', 'Extreme')),
                  charlson_cat = relevel(charlson_cat, ref = 'Low')) %>%
## Categorise IADL
##            mutate() %>%
## Categorise MMSE
           mutate(mmse_cat = case_when(mmse_score >= 24                   ~ 'None',
                                       mmse_score >= 18 & mmse_score < 24 ~ 'Mild',
                                       mmse_score <= 17                   ~ 'Severe'),
                  mmse_cat = factor(mmse_cat),
                  mmse_cat = relevel(mmse_cat, ref = 'None')) %>%
                  ## mmse_cat = relevel(mmse_cat, ref = 'None')) %>%
## Categorise Barthel ADL
##            mutate() %>%
## Elapsed time from consent/randomisation to noted event
           group_by(individual_id) %>%
           mutate(start_date = min(consent_dt, na.rm = TRUE),
                  elapsed    = interval(event_date, start_date)) %>%
           dplyr::select(-start_date) %>%
           ungroup() %>%
## Derive overall measurements for items recorded on both axes.
mutate(site_breast           = case_when(l_site_breast == 'Ticked' & r_site_breast == 'Not Ticked' ~ 'Left Breast',
                                         l_site_breast == 'Not Ticked' & r_site_breast == 'Ticked' ~ 'Right Breast',
                                         l_site_breast == 'Ticked' & r_site_breast == 'Ticked' ~ 'Left & Right Breast',
                                         l_site_breast == 'Not Ticked' & r_site_breast == 'Not Ticked' ~ 'No Breast'),
       site_breast           = factor(site_breast),
       site_axilla           = case_when(l_site_axilla == 'Ticked' & r_site_axilla == 'Not Ticked' ~ 'Left Axilla',
                                         l_site_axilla == 'Not Ticked' & r_site_axilla == 'Ticked' ~ 'Right Axilla',
                                         l_site_axilla == 'Ticked' & r_site_axilla == 'Ticked' ~ 'Left & Right Axilla',
                                         l_site_axilla == 'Not Ticked' & r_site_axilla == 'Not Ticked' ~ 'No Axilla'),
       site_axilla           = factor(site_axilla),
       site_supraclavicular  = case_when(l_site_supraclavicular == 'Ticked' & r_site_supraclavicular == 'Not Ticked' ~ 'Left Supraclavicular',
                                         l_site_supraclavicular == 'Not Ticked' & r_site_supraclavicular == 'Ticked' ~ 'Right Supraclavicular',
                                         l_site_supraclavicular == 'Ticked' & r_site_supraclavicular == 'Ticked' ~ 'Left & Right Supraclavicular',
                                         l_site_supraclavicular == 'Not Ticked' & r_site_supraclavicular == 'Not Ticked' ~ 'No Supraclavicular'),
       site_supraclavicular  = factor(site_supraclavicular),
       site_chest_wall       = case_when(l_site_chest_wall == 'Ticked' & r_site_chest_wall == 'Not Ticked' ~ 'Left Chest Wall',
                                         l_site_chest_wall == 'Not Ticked' & r_site_chest_wall == 'Ticked' ~ 'Right Chest Wall',
                                         l_site_chest_wall == 'Ticked' & r_site_chest_wall == 'Ticked' ~ 'Left & Right Chest Wall',
                                         l_site_chest_wall == 'Not Ticked' & r_site_chest_wall == 'Not Ticked' ~ 'No Chest Wall'),
       site_chest_wall       = factor(site_chest_wall),
       site_other            = case_when(l_site_other == 'Ticked' & r_site_other == 'Not Ticked' ~ 'Left Other',
                                         l_site_other == 'Not Ticked' & r_site_other == 'Ticked' ~ 'Right Other',
                                         l_site_other == 'Ticked' & r_site_other == 'Ticked' ~ 'Left & Right Other',
                                         l_site_other == 'Not Ticked' & r_site_other == 'Not Ticked' ~ 'No Other'),
       site_other            = factor(site_other),
       breast_fractions      = pmax(l_breast_fractions, r_breast_fractions, na.rm = TRUE),
       axilla_fractions      = pmax(l_axilla_fractions, r_axilla_fractions, na.rm = TRUE),
       supra_fractions       = pmax(l_supra_fractions, r_supra_fractions, na.rm = TRUE),
       chest_fractions       = pmax(l_chest_fractions, r_chest_fractions, na.rm = TRUE),
       other_fractions       = pmax(l_other_fractions, r_other_fractions, na.rm = TRUE),
       radiotherapy_aes      = case_when(l_radiotherapy_aes == 'No'  & r_radiotherapy_aes == 'No'  ~ 'No',
                                         l_radiotherapy_aes == 'No'  & is.na(r_radiotherapy_aes)   ~ 'No',
                                         is.na(l_radiotherapy_aes)   & r_radiotherapy_aes == 'No'  ~ 'No',
                                         l_radiotherapy_aes == 'Yes' & r_radiotherapy_aes == 'No'  ~ 'Yes',
                                         l_radiotherapy_aes == 'No'  & r_radiotherapy_aes == 'Yes' ~ 'Yes',
                                         l_radiotherapy_aes == 'Yes' & r_radiotherapy_aes == 'Yes' ~ 'Yes',
                                         l_radiotherapy_aes == 'Yes' & is.na(r_radiotherapy_aes)   ~ 'Yes',
                                         is.na(l_radiotherapy_aes)   & r_radiotherapy_aes == 'Yes' ~ 'Yes'),
       radiotherapy_aes      = factor(radiotherapy_aes),
       skin_erythema         = case_when(l_skin_erythema == 'No'  & r_skin_erythema == 'No'  ~ 'No',
                                         l_skin_erythema == 'No'  & is.na(r_skin_erythema)   ~ 'No',
                                         is.na(l_skin_erythema)   & r_skin_erythema == 'No'  ~ 'No',
                                         l_skin_erythema == 'Yes' & r_skin_erythema == 'No'  ~ 'Yes',
                                         l_skin_erythema == 'No'  & r_skin_erythema == 'Yes' ~ 'Yes',
                                         l_skin_erythema == 'Yes' & r_skin_erythema == 'Yes' ~ 'Yes',
                                         l_skin_erythema == 'Yes' & is.na(r_skin_erythema)   ~ 'Yes',
                                         is.na(l_skin_erythema)   & r_skin_erythema == 'Yes' ~ 'Yes'),
       skin_erythema         = factor(skin_erythema),
       pain                  = case_when(l_pain == 'No'  & r_pain == 'No'  ~ 'No',
                                         l_pain == 'No'  & is.na(r_pain)   ~ 'No',
                                         is.na(l_pain)   & r_pain == 'No'  ~ 'No',
                                         l_pain == 'Yes' & r_pain == 'No'  ~ 'Yes',
                                         l_pain == 'No'  & r_pain == 'Yes' ~ 'Yes',
                                         l_pain == 'Yes' & r_pain == 'Yes' ~ 'Yes',
                                         l_pain == 'Yes' & is.na(r_pain)   ~ 'Yes',
                                         is.na(l_pain)   & r_pain == 'Yes' ~ 'Yes'),
       pain                  = factor(pain),
       breast_oedema         = case_when(l_breast_oedema == 'No'  & r_breast_oedema == 'No'  ~ 'No',
                                         l_breast_oedema == 'No'  & is.na(r_breast_oedema)   ~ 'No',
                                         is.na(l_breast_oedema)   & r_breast_oedema == 'No'  ~ 'No',
                                         l_breast_oedema == 'Yes' & r_breast_oedema == 'No'  ~ 'Yes',
                                         l_breast_oedema == 'No'  & r_breast_oedema == 'Yes' ~ 'Yes',
                                         l_breast_oedema == 'Yes' & r_breast_oedema == 'Yes' ~ 'Yes',
                                         l_breast_oedema == 'Yes' & is.na(r_breast_oedema)   ~ 'Yes',
                                         is.na(l_breast_oedema)   & r_breast_oedema == 'Yes' ~ 'Yes'),
       breast_oedema         = factor(breast_oedema),
       breast_shrink         = case_when(l_breast_shrink == 'No'  & r_breast_shrink == 'No'  ~ 'No',
                                         l_breast_shrink == 'No'  & is.na(r_breast_shrink)   ~ 'No',
                                         is.na(l_breast_shrink)   & r_breast_shrink == 'No'  ~ 'No',
                                         l_breast_shrink == 'Yes' & r_breast_shrink == 'No'  ~ 'Yes',
                                         l_breast_shrink == 'No'  & r_breast_shrink == 'Yes' ~ 'Yes',
                                         l_breast_shrink == 'Yes' & r_breast_shrink == 'Yes' ~ 'Yes',
                                         l_breast_shrink == 'Yes' & is.na(r_breast_shrink)   ~ 'Yes',
                                         is.na(l_breast_shrink)   & r_breast_shrink == 'Yes' ~ 'Yes'),
       breast_shrink         = factor(breast_shrink),
       breast_pain           = case_when(l_breast_pain == 'No'  & r_breast_pain == 'No'  ~ 'No',
                                         l_breast_pain == 'No'  & is.na(r_breast_pain)   ~ 'No',
                                         is.na(l_breast_pain)   & r_breast_pain == 'No'  ~ 'No',
                                         l_breast_pain == 'Yes' & r_breast_pain == 'No'  ~ 'Yes',
                                         l_breast_pain == 'No'  & r_breast_pain == 'Yes' ~ 'Yes',
                                         l_breast_pain == 'Yes' & r_breast_pain == 'Yes' ~ 'Yes',
                                         l_breast_pain == 'Yes' & is.na(r_breast_pain)   ~ 'Yes',
                                         is.na(l_breast_pain)   & r_breast_pain == 'Yes' ~ 'Yes'),
       breast_pain           = factor(breast_pain),
       ## ToDo 2017-09-04 : How to reconcile these?  Clearly this adds too many categories
       l_surgery_type_str    = ifelse(is.na(l_surgery_type),
                                      no  = as.character(l_surgery_type),
                                      yes = 'None'),
       r_surgery_type_str    = ifelse(is.na(r_surgery_type),
                                      no  = as.character(r_surgery_type),
                                      yes = 'None'),
       surgery_type          = paste0(l_surgery_type_str, ' (Left)',
                                      ' / ',
                                      r_surgery_type_str, ' (Right)'),
       ## ToDo 2017-09-04 : How to reconcile these?  Clearly this adds too many categories
       l_axillary_type_str   = ifelse(is.na(l_axillary_type),
                                      no  = as.character(l_axillary_type),
                                      yes = 'None'),
       r_axillary_type_str   = ifelse(is.na(r_axillary_type),
                                      no  = as.character(r_axillary_type),
                                      yes = 'None'),
       axillary_type         = paste0(l_axillary_type_str, ' (Left)',
                                      ' / ',
                                      r_axillary_type_str, ' (Right)'),
       surgery_aes_acute     = case_when(l_surgery_aes_acute == 'No'  & r_surgery_aes_acute == 'No'  ~ 'No',
                                         l_surgery_aes_acute == 'No'  & is.na(r_surgery_aes_acute)   ~ 'No',
                                         is.na(l_surgery_aes_acute)   & r_surgery_aes_acute == 'No'  ~ 'No',
                                         l_surgery_aes_acute == 'Yes' & r_surgery_aes_acute == 'No'  ~ 'Yes',
                                         l_surgery_aes_acute == 'No'  & r_surgery_aes_acute == 'Yes' ~ 'Yes',
                                         l_surgery_aes_acute == 'Yes' & r_surgery_aes_acute == 'Yes' ~ 'Yes',
                                         l_surgery_aes_acute == 'Yes' & is.na(r_surgery_aes_acute)   ~ 'Yes',
                                         is.na(l_surgery_aes_acute)   & r_surgery_aes_acute == 'Yes' ~ 'Yes'),
       surgery_aes_acute     = factor(surgery_aes_acute),
       surgery_aes_chronic   = case_when(l_surgery_aes_chronic == 'No'  & r_surgery_aes_chronic == 'No'  ~ 'No',
                                         l_surgery_aes_chronic == 'No'  & is.na(r_surgery_aes_chronic)   ~ 'No',
                                         is.na(l_surgery_aes_chronic)   & r_surgery_aes_chronic == 'No'  ~ 'No',
                                         l_surgery_aes_chronic == 'Yes' & r_surgery_aes_chronic == 'No'  ~ 'Yes',
                                         l_surgery_aes_chronic == 'No'  & r_surgery_aes_chronic == 'Yes' ~ 'Yes',
                                         l_surgery_aes_chronic == 'Yes' & r_surgery_aes_chronic == 'Yes' ~ 'Yes',
                                         l_surgery_aes_chronic == 'Yes' & is.na(r_surgery_aes_chronic)   ~ 'Yes',
                                         is.na(l_surgery_aes_chronic)   & r_surgery_aes_chronic == 'Yes' ~ 'Yes'),
       surgery_aes_chronic   = factor(surgery_aes_chronic),
       sa_haemorrhage        = case_when(l_sa_haemorrhage == 'No'  & r_sa_haemorrhage == 'No'  ~ 'No',
                                         l_sa_haemorrhage == 'No'  & is.na(r_sa_haemorrhage)   ~ 'No',
                                         is.na(l_sa_haemorrhage)   & r_sa_haemorrhage == 'No'  ~ 'No',
                                         l_sa_haemorrhage == 'Yes' & r_sa_haemorrhage == 'No'  ~ 'Yes',
                                         l_sa_haemorrhage == 'No'  & r_sa_haemorrhage == 'Yes' ~ 'Yes',
                                         l_sa_haemorrhage == 'Yes' & r_sa_haemorrhage == 'Yes' ~ 'Yes',
                                         l_sa_haemorrhage == 'Yes' & is.na(r_sa_haemorrhage)   ~ 'Yes',
                                         is.na(l_sa_haemorrhage)   & r_sa_haemorrhage == 'Yes' ~ 'Yes'),
       sa_haemorrhage        = factor(sa_haemorrhage),
       sa_seroma             = case_when(l_sa_seroma == 'No'  & r_sa_seroma == 'No'  ~ 'No',
                                         l_sa_seroma == 'No'  & is.na(r_sa_seroma)   ~ 'No',
                                         is.na(l_sa_seroma)   & r_sa_seroma == 'No'  ~ 'No',
                                         l_sa_seroma == 'Yes' & r_sa_seroma == 'No'  ~ 'Yes',
                                         l_sa_seroma == 'No'  & r_sa_seroma == 'Yes' ~ 'Yes',
                                         l_sa_seroma == 'Yes' & r_sa_seroma == 'Yes' ~ 'Yes',
                                         l_sa_seroma == 'Yes' & is.na(r_sa_seroma)   ~ 'Yes',
                                         is.na(l_sa_seroma)   & r_sa_seroma == 'Yes' ~ 'Yes'),
       sa_seroma             = factor(sa_seroma),
       sa_haematoma          = case_when(l_sa_haematoma == 'No'  & r_sa_haematoma == 'No'  ~ 'No',
                                         l_sa_haematoma == 'No'  & is.na(r_sa_haematoma)   ~ 'No',
                                         is.na(l_sa_haematoma)   & r_sa_haematoma == 'No'  ~ 'No',
                                         l_sa_haematoma == 'Yes' & r_sa_haematoma == 'No'  ~ 'Yes',
                                         l_sa_haematoma == 'No'  & r_sa_haematoma == 'Yes' ~ 'Yes',
                                         l_sa_haematoma == 'Yes' & r_sa_haematoma == 'Yes' ~ 'Yes',
                                         l_sa_haematoma == 'Yes' & is.na(r_sa_haematoma)   ~ 'Yes',
                                         is.na(l_sa_haematoma)   & r_sa_haematoma == 'Yes' ~ 'Yes'),
       sa_haematoma          = factor(sa_haematoma),
       sa_infection          = case_when(l_sa_infection == 'No'  & r_sa_infection == 'No'  ~ 'No',
                                         l_sa_infection == 'No'  & is.na(r_sa_infection)   ~ 'No',
                                         is.na(l_sa_infection)   & r_sa_infection == 'No'  ~ 'No',
                                         l_sa_infection == 'Yes' & r_sa_infection == 'No'  ~ 'Yes',
                                         l_sa_infection == 'No'  & r_sa_infection == 'Yes' ~ 'Yes',
                                         l_sa_infection == 'Yes' & r_sa_infection == 'Yes' ~ 'Yes',
                                         l_sa_infection == 'Yes' & is.na(r_sa_infection)   ~ 'Yes',
                                         is.na(l_sa_infection)   & r_sa_infection == 'Yes' ~ 'Yes'),
       sa_infection          = factor(sa_infection),
       sa_necrosis           = case_when(l_sa_necrosis == 'No'  & r_sa_necrosis == 'No'  ~ 'No',
                                         l_sa_necrosis == 'No'  & is.na(r_sa_necrosis)   ~ 'No',
                                         is.na(l_sa_necrosis)   & r_sa_necrosis == 'No'  ~ 'No',
                                         l_sa_necrosis == 'Yes' & r_sa_necrosis == 'No'  ~ 'Yes',
                                         l_sa_necrosis == 'No'  & r_sa_necrosis == 'Yes' ~ 'Yes',
                                         l_sa_necrosis == 'Yes' & r_sa_necrosis == 'Yes' ~ 'Yes',
                                         l_sa_necrosis == 'Yes' & is.na(r_sa_necrosis)   ~ 'Yes',
                                         is.na(l_sa_necrosis)   & r_sa_necrosis == 'Yes' ~ 'Yes'),
       sa_necrosis           = factor(sa_necrosis),
       sc_wound_pain         = case_when(l_sc_wound_pain == 'No'  & r_sc_wound_pain == 'No'  ~ 'No',
                                         l_sc_wound_pain == 'No'  & is.na(r_sc_wound_pain)   ~ 'No',
                                         is.na(l_sc_wound_pain)   & r_sc_wound_pain == 'No'  ~ 'No',
                                         l_sc_wound_pain == 'Yes' & r_sc_wound_pain == 'No'  ~ 'Yes',
                                         l_sc_wound_pain == 'No'  & r_sc_wound_pain == 'Yes' ~ 'Yes',
                                         l_sc_wound_pain == 'Yes' & r_sc_wound_pain == 'Yes' ~ 'Yes',
                                         l_sc_wound_pain == 'Yes' & is.na(r_sc_wound_pain)   ~ 'Yes',
                                         is.na(l_sc_wound_pain)   & r_sc_wound_pain == 'Yes' ~ 'Yes'),
       sc_wound_pain         = factor(sc_wound_pain),
       sc_functional_diff    = case_when(l_sc_functional_diff == 'No'  & r_sc_functional_diff == 'No'  ~ 'No',
                                         l_sc_functional_diff == 'No'  & is.na(r_sc_functional_diff)   ~ 'No',
                                         is.na(l_sc_functional_diff)   & r_sc_functional_diff == 'No'  ~ 'No',
                                         l_sc_functional_diff == 'Yes' & r_sc_functional_diff == 'No'  ~ 'Yes',
                                         l_sc_functional_diff == 'No'  & r_sc_functional_diff == 'Yes' ~ 'Yes',
                                         l_sc_functional_diff == 'Yes' & r_sc_functional_diff == 'Yes' ~ 'Yes',
                                         l_sc_functional_diff == 'Yes' & is.na(r_sc_functional_diff)   ~ 'Yes',
                                         is.na(l_sc_functional_diff)   & r_sc_functional_diff == 'Yes' ~ 'Yes'),
       sc_functional_diff    = factor(sc_functional_diff),
       sc_neuropathy         = case_when(l_sc_neuropathy == 'No'  & r_sc_neuropathy == 'No'  ~ 'No',
                                         l_sc_neuropathy == 'No'  & is.na(r_sc_neuropathy)   ~ 'No',
                                         is.na(l_sc_neuropathy)   & r_sc_neuropathy == 'No'  ~ 'No',
                                         l_sc_neuropathy == 'Yes' & r_sc_neuropathy == 'No'  ~ 'Yes',
                                         l_sc_neuropathy == 'No'  & r_sc_neuropathy == 'Yes' ~ 'Yes',
                                         l_sc_neuropathy == 'Yes' & r_sc_neuropathy == 'Yes' ~ 'Yes',
                                         l_sc_neuropathy == 'Yes' & is.na(r_sc_neuropathy)   ~ 'Yes',
                                         is.na(l_sc_neuropathy)   & r_sc_neuropathy == 'Yes' ~ 'Yes'),
       sc_neuropathy         = factor(sc_neuropathy),
       sc_lymphoedema        = case_when(l_sc_lymphoedema == 'No'  & r_sc_lymphoedema == 'No'  ~ 'No',
                                         l_sc_lymphoedema == 'No'  & is.na(r_sc_lymphoedema)   ~ 'No',
                                         is.na(l_sc_lymphoedema)   & r_sc_lymphoedema == 'No'  ~ 'No',
                                         l_sc_lymphoedema == 'Yes' & r_sc_lymphoedema == 'No'  ~ 'Yes',
                                         l_sc_lymphoedema == 'No'  & r_sc_lymphoedema == 'Yes' ~ 'Yes',
                                         l_sc_lymphoedema == 'Yes' & r_sc_lymphoedema == 'Yes' ~ 'Yes',
                                         l_sc_lymphoedema == 'Yes' & is.na(r_sc_lymphoedema)   ~ 'Yes',
                                         is.na(l_sc_lymphoedema)   & r_sc_lymphoedema == 'Yes' ~ 'Yes'),
       sc_lymphoedema        = factor(sc_lymphoedema),
       ## ToDo 2017-09-04 : How to reconcile these? case_when() rules?
       tumour_size           = pmax(l_tumour_size, r_tumour_size, na.rm = TRUE),
       ## Combine laft and right tumour types
       l_tumour_type_str     = ifelse(is.na(l_tumour_type),
                                      no  = as.character(l_tumour_type),
                                      yes = 'None'),
       r_tumour_type_str     = ifelse(is.na(r_tumour_type),
                                      no  = as.character(r_tumour_type),
                                      yes = 'None'),
       tumour_type           = paste0(l_tumour_type_str, ' (Left)', ' / ', r_tumour_type_str, ' (Right)'),
       ## tumour_type           = gsub('NA (Right)', 'None (Right)', tumour_type),
       ## tumour_type           = gsub('NA (Left)', 'None (Left)', tumour_type),
       tumour_type           = factor(tumour_type),
       l_tumour_grade_num    = as.numeric(l_tumour_grade),
       r_tumour_grade_num    = as.numeric(r_tumour_grade),
       tumour_grade          = pmax(l_tumour_grade_num, r_tumour_grade_num, na.rm = TRUE),
       ## 'Not available' is the highest factor but there are four instances where
       ## a tumor grade is recorded for the other side, these need correcting as I could not
       ## get the case_when() code below to work and don't have further time to spend on it.
       ## The code is generic such that if additional data is available it will still work as
       ## desired rather than just for the four instances observed when writing the code
       ## tumour_grade          = case_when(l_tumour_grade == 'I' & is.na(r_tumour_grade)                ~ 'I',
       ##                                   l_tumour_grade == 'I' & r_tumour_grade == 'Not available'    ~ 'I',
       ##                                   l_tumour_grade == 'Not available' & r_tumour_grade == 'I'    ~ 'I',
       ##                                   l_tumour_grade == 'I' & r_tumour_grade == 'I'                ~ 'I',
       ##                                   l_tumour_grade == 'II' & is.na(r_tumour_grade)               ~ 'II',
       ##                                   l_tumour_grade == 'II' & r_tumour_grade == 'Not available'   ~ 'II',
       ##                                   l_tumour_grade == 'Not available' & r_tumour_grade == 'II'   ~ 'II',
       ##                                   l_tumour_grade == 'II' & r_tumour_grade == 'I'               ~ 'II',
       ##                                   l_tumour_grade == 'I'  & r_tumour_grade == 'II'              ~ 'II',
       ##                                   l_tumour_grade == 'III' & is.na(r_tumour_grade)              ~ 'III',
       ##                                   l_tumour_grade == 'III' & r_tumour_grade == 'Not available'  ~ 'III',
       ##                                   l_tumour_grade == 'Not available' & r_tumour_grade == 'III'  ~ 'III',
       ##                                   l_tumour_grade == 'III' & r_tumour_grade == 'I'              ~ 'III',
       ##                                   l_tumour_grade == 'I'  & r_tumour_grade == 'III'             ~ 'III',
       ##                                   l_tumour_grade == 'III' & r_tumour_grade == 'II'             ~ 'III',
       ##                                   l_tumour_grade == 'II'  & r_tumour_grade == 'III'            ~ 'III'),
       ##
       ## For some reason having this code within this mutate() simply does not work, it
       ## therefore follows in a seperate pipe to another mutate(), converting to a factor is
       ## also included there.
       ## tumour_grade          = factor(tumour_grade,
       ##                                levels = c(1:4),
       ##                                labels = c('I', 'II', 'III', 'Not available')),
       tumour_grade          = factor(tumour_grade,
                                      levels = c(1:4),
                                      labels = c('I', 'II', 'III', 'Not available')),
       ## allred_baseline       = pmax(l_allred_baseline, r_allred_baseline, na.rm = TRUE),
       ## h_score_baseline      = pmax(l_h_score_baseline, r_h_score_baseline, na.rm = TRUE),
       ## her_2_score_baseline  = pmax(l_her_2_score_baseline, r_h_score_baseline, na.rm = TRUE),
       ## ToDo 2017-09-04 : How to reconcile these? case_when() rules?
       ## her_2_score           = pmax(l_her_2_score, r_her_2_score),
       onco_offered          = case_when(l_onco_offered == 'No'  & r_onco_offered == 'No'  ~ 'No',
                                         l_onco_offered == 'No'  & is.na(r_onco_offered)   ~ 'No',
                                         is.na(l_onco_offered)   & r_onco_offered == 'No'  ~ 'No',
                                         l_onco_offered == 'Yes' & r_onco_offered == 'No'  ~ 'Yes',
                                         l_onco_offered == 'No'  & r_onco_offered == 'Yes' ~ 'Yes',
                                         l_onco_offered == 'Yes' & r_onco_offered == 'Yes' ~ 'Yes',
                                         l_onco_offered == 'Yes' & is.na(r_onco_offered)   ~ 'Yes',
                                         is.na(l_onco_offered)   & r_onco_offered == 'Yes' ~ 'Yes'),
       onco_offered          = factor(onco_offered),
       onco_used             = case_when(l_onco_used == 'No'  & r_onco_used == 'No'  ~ 'No',
                                         l_onco_used == 'No'  & is.na(r_onco_used)   ~ 'No',
                                         is.na(l_onco_used)   & r_onco_used == 'No'  ~ 'No',
                                         l_onco_used == 'Yes' & r_onco_used == 'No'  ~ 'Yes',
                                         l_onco_used == 'No'  & r_onco_used == 'Yes' ~ 'Yes',
                                         l_onco_used == 'Yes' & r_onco_used == 'Yes' ~ 'Yes',
                                         l_onco_used == 'Yes' & is.na(r_onco_used)   ~ 'Yes',
                                         is.na(l_onco_used)   & r_onco_used == 'Yes' ~ 'Yes'),
       onco_used             = factor(onco_used),
       ## ToDo 2017-09-04 : Check this is correct, not much data there anyway!
       ## risk_score            = pmax(l_risk_score, r_risk_score),
       margins_clear         = case_when(l_margins_clear == 'No'  & r_margins_clear == 'No'  ~ 'No',
                                         l_margins_clear == 'No'  & is.na(r_margins_clear)   ~ 'No',
                                         is.na(l_margins_clear)   & r_margins_clear == 'No'  ~ 'No',
                                         l_margins_clear == 'Yes' & r_margins_clear == 'No'  ~ 'Yes',
                                         l_margins_clear == 'No'  & r_margins_clear == 'Yes' ~ 'Yes',
                                         l_margins_clear == 'Yes' & r_margins_clear == 'Yes' ~ 'Yes',
                                         l_margins_clear == 'Yes' & is.na(r_margins_clear)   ~ 'Yes',
                                         is.na(l_margins_clear)   & r_margins_clear == 'Yes' ~ 'Yes'),
       margins_clear         = factor(margins_clear),
       margin                = pmax(l_margin, r_margin, na.rm = TRUE),
       designation_anterior  = ifelse(l_designation_anterior == 'Ticked' | l_designation_anterior == 'Ticked',
                                      no  = 'No',
                                      yes = 'Yes'),
       designation_anterior  = factor(designation_anterior),
       designation_posterior = ifelse(l_designation_posterior == 'Ticked' | l_designation_posterior == 'Ticked',
                                      no  = 'No',
                                      yes = 'Yes'),
       designation_posterior = factor(designation_posterior),
       designation_lateral   = ifelse(l_designation_lateral == 'Ticked' | l_designation_lateral == 'Ticked',
                                      no  = 'No',
                                      yes = 'Yes'),
       designation_lateral   = factor(designation_lateral),
       designation_medial    = ifelse(l_designation_medial == 'Ticked' | l_designation_medial == 'Ticked',
                                      no  = 'No',
                                      yes = 'Yes'),
       designation_medial    = factor(designation_medial),
       designation_superior  = ifelse(l_designation_superior == 'Ticked' | l_designation_superior == 'Ticked',
                                      no  = 'No',
                                      yes = 'Yes'),
       designation_superior  = factor(designation_superior),
       designation_inferior  = ifelse(l_designation_inferior == 'Ticked' | l_designation_inferior == 'Ticked',
                                      no  = 'No',
                                      yes = 'Yes'),
       designation_inferior  = factor(designation_inferior),
       ## ToDo 2017-09-04 : How to reconcile these, only really two that are discordant
       ## l_close_margin
       ## ToDo 2017-09-04 : Take the pmaximum or should these be sumnmed for excised and involved?
       nodes_excised         = pmax(l_nodes_excised, r_nodes_excised, na.rm = TRUE),
       nodes_involved        = pmax(l_nodes_involved, r_nodes_involved, na.rm = TRUE),
       ## ToDo 2017-09-04 : How to reconcile these, only really a handful that are discordant
       ## l_focal_pet
       num_tumours_pet       = pmax(l_num_tumours_pet, r_num_tumours_pet, na.rm = TRUE),
       cancer_palpable_pet   = case_when(l_cancer_palpable_pet == 'No'  & r_cancer_palpable_pet == 'No'  ~ 'No',
                                         l_cancer_palpable_pet == 'No'  & is.na(r_cancer_palpable_pet)   ~ 'No',
                                         is.na(l_cancer_palpable_pet)   & r_cancer_palpable_pet == 'No'  ~ 'No',
                                         l_cancer_palpable_pet == 'Yes' & r_cancer_palpable_pet == 'No'  ~ 'Yes',
                                         l_cancer_palpable_pet == 'No'  & r_cancer_palpable_pet == 'Yes' ~ 'Yes',
                                         l_cancer_palpable_pet == 'Yes' & r_cancer_palpable_pet == 'Yes' ~ 'Yes',
                                         l_cancer_palpable_pet == 'Yes' & is.na(r_cancer_palpable_pet)   ~ 'Yes',
                                         is.na(l_cancer_palpable_pet)   & r_cancer_palpable_pet == 'Yes' ~ 'Yes'),
       cancer_palpable_pet   = factor(cancer_palpable_pet),
       size_clin_assess_pet  = pmax(l_size_clin_assess_pet, r_size_clin_assess_pet, na.rm = TRUE),
       ## ToDo 2017-09-04 : How to reconcile these, none are discordant
       ## l_method_assess_pet
       size_ultrasound_pet   = pmax(l_size_ultrasound_pet, r_size_ultrasound_pet, na.rm = TRUE),
       size_mammo_pet        = pmax(l_size_mammo_pet, r_size_mammo_pet, na.rm = TRUE),
       axillary_present_pet  = case_when(l_axillary_present_pet == 'No'  & r_axillary_present_pet == 'No'  ~ 'No',
                                         l_axillary_present_pet == 'No'  & is.na(r_axillary_present_pet)   ~ 'No',
                                         is.na(l_axillary_present_pet)   & r_axillary_present_pet == 'No'  ~ 'No',
                                         l_axillary_present_pet == 'Yes' & r_axillary_present_pet == 'No'  ~ 'Yes',
                                         l_axillary_present_pet == 'No'  & r_axillary_present_pet == 'Yes' ~ 'Yes',
                                         l_axillary_present_pet == 'Yes' & r_axillary_present_pet == 'Yes' ~ 'Yes',
                                         l_axillary_present_pet == 'Yes' & is.na(r_axillary_present_pet)   ~ 'Yes',
                                         is.na(l_axillary_present_pet)   & r_axillary_present_pet == 'Yes' ~ 'Yes'),
       axillary_present_pet  = factor(axillary_present_pet),
       axillary_nodes_pet    = pmax(l_axillary_nodes_pet, r_axillary_nodes_pet, na.rm = TRUE),
       axillary_axis_pet     = pmax(l_axillary_axis_pet, r_axillary_axis_pet, na.rm = TRUE)) %>%
## Can not for the life of me work out why this doesn't work as I would expect it to...
## mutate(tumour_grade = as.character(tumour_grade),
##        tumour_grade          = ifelse((l_tumour_grade == 'I' & r_tumour_grade == 'Not available') |
##                                       (l_tumour_grade == 'Not available'   & r_tumour_grade == 'I') |
##                                       no  = tumour_grade,
##                                       yes = 'I')) %>%
##        tumour_grade          = ifelse((l_tumour_grade == 'II'   & r_tumour_grade == 'Not available') |
##                                       (l_tumour_grade == 'Not available'   & r_tumour_grade == 'II'),
##                                       no  = tumour_grade,
##                                       yes = 'II'),
##        tumour_grade          = ifelse((l_tumour_grade == 'III'   & r_tumour_grade == 'Not available') |
##                                       (l_tumour_grade == 'Not available'   & r_tumour_grade == 'III'),
##                                       no  = tumour_grade,
##                                       yes = 'III')## ,
##        ## tumour_grade          = factor(tumour_grade,
##        ##                                levels = c('I', 'II', 'III', 'Not available'))
##        ) %>%
## Instead do it manually based on the individual_id that has been looked up
mutate(tumour_grade = as.character(tumour_grade),
       tumour_grade = ifelse(individual_id %in% c(52097),
                             no  = tumour_grade,
                             yes = 'I'),
       tumour_grade = ifelse(individual_id %in% c(53128),
                             no  = tumour_grade,
                             yes = 'II'),
       tumour_grade = ifelse(individual_id %in% c(53527, 51758, 65609),
                             no  = tumour_grade,
                             yes = 'III'),
       tumour_grade = ifelse(is.na(l_tumour_grade) & is.na(r_tumour_grade),
                             no  = tumour_grade,
                             yes = NA),
       tumour_grade = factor(tumour_grade)) %>%
dplyr::select(-l_tumour_grade_num, -r_tumour_grade_num,
              -l_tumour_type_str, -r_tumour_type_str,
              -l_surgery_type_str, -r_surgery_type_str,
              -l_axillary_type_str, -r_axillary_type_str)


###################################################################################
## Primary Treatment                                                             ##
###################################################################################
## Derive an indicator of the primary treatment received based on
## notes from meeting with Lynda Wylde 2017-10-23 @ 09:00-11:00
##
## 2017-12-11 : Lynda will be going through a list of some 400 or so to manually
##              check/indicate what treatment they have received.
##
##              Its unclear to me why these rules can not be written down
##              by Lynda for me to translate into code?
##
## 2018-01-10 : Code not quite right, produces event_name specific categorisation, need overall
##              Look to moving code elsewhere or collapsing/replacing things?
##
##              All but 61 individuals have received a treatment of some sort by 6 week
##              assessment, therefore use that to derive primary, then fix the remaining
##
## agegap_encode <- function(df = .,
##                           event = '6 weeks'){
##     df <- df %>%
##           dplyr::filter(event_name == event) %>%
##           dplyr::select(individual_id, site, event_name,
##                         treatment_profile,
##                         endocrine_therapy,
##                         radiotherapy,
##                         surgery,
##                         chemotherapy,
##                         trastuzumab,
##                         primary_adjuvant) %>%
##           mutate(primary_treatment = case_when(endocrine_therapy == 'Yes' & primary_adjuvant == 'Primary' ~ 'Primary Endocrine',
##                                                endocrine_therapy == 'Yes' & primary_adjuvant == 'Adjuvant' ~ 'Adjuvant Endocrine',
##                                                surgery == 'Yes' & primary_adjuvant == 'Adjuvant' ~ 'Surgery',
##                                                surgery == 'Yes' & primary_adjuvant == 'Neoadjuvant' ~ 'Surgery',
##                                                surgery == 'Yes' & is.na(primary_adjuvant) ~ 'Surgery',
##                                                endocrine_therapy == 'No' & surgery == 'No' & chemotherapy == 'Yes' ~ 'Chemotherapy',
##                                                endocrine_therapy == 'No' & surgery == 'No' & chemotherapy == 'No' & radiotherapy == 'Yes' ~ 'Radiotherapy',
##                                                radiotherapy == 'Yes' ~ 'Radiotherapy',
##                                                trastuzumab  == 'Yes' ~ 'Trastuzumab')) %>%
##         dplyr::select(individual_id, site, primary_treatment)
##     return(df)
## }
## Get primary treatment at 6 weeks if available
primary_6weeks <- agegap_encode(df    = age_gap,
                                event = '6 weeks')
## Get a list of those who do not have primary treatment then remove them from the primary_treatment df
missing_6weeks <- dplyr::filter(primary_6weeks, is.na(primary_treatment))$individual_id %>% as.vector()
primary_6weeks <- filter(primary_6weeks, !is.na(primary_treatment)) %>%
                  unique()
## Sort out those who had not received any treatment by 6 weeks by looking at their 6 month data
primary_6months <- dplyr::filter(age_gap, individual_id %in% missing_6weeks) %>%
                   agegap_encode(df    = .,
                                 event = '6 months')
## Get a list of those who do not have primary treatment then remove them from the primary_treatment df
missing_6months <- dplyr::filter(primary_6months, is.na(primary_treatment))$individual_id %>% as.vector()
primary_6months <- filter(primary_6months, !is.na(primary_treatment)) %>%
                   unique()
## Repeat at 12 months as there are still some who don't have any treatment recorded
primary_12months <- dplyr::filter(age_gap, individual_id %in% missing_6months) %>%
                    agegap_encode(df    = .,
                                  event = '12 months')
## Get a list of those who do not have primary treatment then remove them from the primary_treatment df
missing_12months <- dplyr::filter(primary_12months, is.na(primary_treatment))$individual_id %>% as.vector()
primary_12months <- filter(primary_12months, !is.na(primary_treatment)) %>%
                    unique()
## Repeat at 18 months as there are still some who don't have any treatment recorded
primary_18months <- dplyr::filter(age_gap, individual_id %in% missing_12months) %>%
                    agegap_encode(df    = .,
                                event = '18 months')
## Get a list of those who do not have primary treatment then remove them from the primary_treatment df
missing_18months <- dplyr::filter(primary_18months, is.na(primary_treatment))$individual_id %>% as.vector()
primary_18months <- filter(primary_18months, !is.na(primary_treatment)) %>%
                    unique()
## Repeat at 24 months as there are still some who don't have any treatment recorded
primary_24months <- dplyr::filter(age_gap, individual_id %in% missing_18months) %>%
                    agegap_encode(df    = .,
                                event = '24 months')
## Get a list of those who do not have primary treatment then remove them from the primary_treatment df
missing_24months <- dplyr::filter(primary_24months, is.na(primary_treatment))$individual_id %>% as.vector()
primary_24months <- filter(primary_24months, !is.na(primary_treatment)) %>%
                    unique()
## Store numbers for everything and save later for use in report
primary_treatment_numbers <- list()
primary_treatment_numbers$n_6weeks_any  <- nrow(primary_6weeks)
primary_treatment_numbers$n_6weeks_surgery <- dplyr::filter(primary_6weeks,
                                                            primary_treatment == 'Surgery') %>%
                                              nrow()
primary_treatment_numbers$n_6weeks_primary_endocrine <- dplyr::filter(primary_6weeks,
                                                                      primary_treatment == 'Primary Endocrine') %>%
                                              nrow()
primary_treatment_numbers$n_6weeks_adjuvant_endocrine <- dplyr::filter(primary_6weeks,
                                                                       primary_treatment == 'Adjuvant Endocrine') %>%
                                              nrow()
primary_treatment_numbers$n_6weeks_chemotherapy <- dplyr::filter(primary_6weeks,
                                                                 primary_treatment == 'Chemotherapy') %>%
                                              nrow()
primary_treatment_numbers$n_6weeks_radiotherapy <- dplyr::filter(primary_6weeks,
                                                                 primary_treatment == 'Radiotherapy') %>%
                                              nrow()
primary_treatment_numbers$n_6weeks_none <- length(missing_6weeks)
primary_treatment_numbers$n_6months_any  <- nrow(primary_6months)
primary_treatment_numbers$n_6months_surgery <- dplyr::filter(primary_6months,
                                                            primary_treatment == 'Surgery') %>%
                                              nrow()
primary_treatment_numbers$n_6months_primary_endocrine <- dplyr::filter(primary_6months,
                                                                      primary_treatment == 'Primary Endocrine') %>%
                                              nrow()
primary_treatment_numbers$n_6months_adjuvant_endocrine <- dplyr::filter(primary_6months,
                                                                       primary_treatment == 'Adjuvant Endocrine') %>%
                                              nrow()
primary_treatment_numbers$n_6months_chemotherapy <- dplyr::filter(primary_6months,
                                                                 primary_treatment == 'Chemotherapy') %>%
                                              nrow()
primary_treatment_numbers$n_6months_radiotherapy <- dplyr::filter(primary_6months,
                                                                 primary_treatment == 'Radiotherapy') %>%
                                              nrow()
primary_treatment_numbers$n_6months_none <- length(missing_6months)
primary_treatment_numbers$n_12months_any  <- nrow(primary_12months)
primary_treatment_numbers$n_12months_surgery <- dplyr::filter(primary_12months,
                                                            primary_treatment == 'Surgery') %>%
                                              nrow()
primary_treatment_numbers$n_12months_primary_endocrine <- dplyr::filter(primary_12months,
                                                                      primary_treatment == 'Primary Endocrine') %>%
                                              nrow()
primary_treatment_numbers$n_12months_adjuvant_endocrine <- dplyr::filter(primary_12months,
                                                                       primary_treatment == 'Adjuvant Endocrine') %>%
                                              nrow()
primary_treatment_numbers$n_12months_chemotherapy <- dplyr::filter(primary_12months,
                                                                 primary_treatment == 'Chemotherapy') %>%
                                              nrow()
primary_treatment_numbers$n_12months_radiotherapy <- dplyr::filter(primary_12months,
                                                                 primary_treatment == 'Radiotherapy') %>%
                                              nrow()
primary_treatment_numbers$n_12months_none <- length(missing_12months)
primary_treatment_numbers$n_18months_any  <- nrow(primary_18months)
primary_treatment_numbers$n_18months_surgery <- dplyr::filter(primary_18months,
                                                            primary_treatment == 'Surgery') %>%
                                              nrow()
primary_treatment_numbers$n_18months_primary_endocrine <- dplyr::filter(primary_18months,
                                                                      primary_treatment == 'Primary Endocrine') %>%
                                              nrow()
primary_treatment_numbers$n_18months_adjuvant_endocrine <- dplyr::filter(primary_18months,
                                                                       primary_treatment == 'Adjuvant Endocrine') %>%
                                              nrow()
primary_treatment_numbers$n_18months_chemotherapy <- dplyr::filter(primary_18months,
                                                                 primary_treatment == 'Chemotherapy') %>%
                                              nrow()
primary_treatment_numbers$n_18months_radiotherapy <- dplyr::filter(primary_18months,
                                                                 primary_treatment == 'Radiotherapy') %>%
                                              nrow()
primary_treatment_numbers$n_18months_none <- length(missing_18months)
primary_treatment_numbers$n_24months_any  <- nrow(primary_24months)
primary_treatment_numbers$n_24months_surgery <- dplyr::filter(primary_24months,
                                                            primary_treatment == 'Surgery') %>%
                                              nrow()
primary_treatment_numbers$n_24months_primary_endocrine <- dplyr::filter(primary_24months,
                                                                      primary_treatment == 'Primary Endocrine') %>%
                                              nrow()
primary_treatment_numbers$n_24months_adjuvant_endocrine <- dplyr::filter(primary_24months,
                                                                       primary_treatment == 'Adjuvant Endocrine') %>%
                                              nrow()
primary_treatment_numbers$n_24months_chemotherapy <- dplyr::filter(primary_24months,
                                                                 primary_treatment == 'Chemotherapy') %>%
                                              nrow()
primary_treatment_numbers$n_24months_radiotherapy <- dplyr::filter(primary_24months,
                                                                 primary_treatment == 'Radiotherapy') %>%
                                              nrow()
primary_treatment_numbers$n_24months_none <- length(missing_24months)
## Combine everything into one data frame, remove intermediates and bind into master age_gap
primary_treatment <- rbind(primary_6weeks,
                           primary_6months,
                           primary_12months,
                           primary_18months,
                           primary_24months)
rm(primary_6weeks, missing_6weeks,
   primary_6months, missing_6months,
   primary_12months, missing_12months,
   primary_18months, missing_18months,
   primary_24months, missing_24months)
age_gap <- left_join(age_gap,
                     primary_treatment,
                     by = c('individual_id', 'site')) %>%
           mutate(primary_treatment = factor(primary_treatment),
                  ## 2018-01-31 - Make event_name a factor with Baseline as the reference level
                  event_name = factor(event_name, levels = c('Baseline',
                                                             '6 weeks',
                                                             '6 months',
                                                             '12 months',
                                                             '18 months',
                                                             '24 months')))

## Old Code for Reference
## mutate(primary_treatment = case_when(endocrine_therapy == 'Yes' & primary_adjuvant == 'Primary' ~ 'Endocrine',
##                                      ## endocrine_therapy == 'Yes' & priary_adjuvant == 'Adjuvant' ~ ,
##                                      ## endocrine_therapy == 'Yes' & priary_adjuvant == 'Neoadjuvant' ~ ,
##                                      surgery == 'Yes' & primary_adjuvant == 'Adjuvant' ~ 'Surgery',
##                                      surgery == 'Yes' & primary_adjuvant == 'Neoadjuvant' ~ 'Surgery',
##                                      endocrine_therapy == 'No' & surgery == 'No' & chemotherapy == 'Yes' ~ 'Chemotherapy',
##                                      endocrine_therapy == 'No' & surgery == 'No' & radiotherapy == 'Yes' ~ 'Chemotherapy',
##                                      radiotherapy == 'Yes' ~ 'Radiotherapy',
##                                      ## radiotherapy == 'No'  ~ '',
##                                      trastuzumab  == 'Yes' ~ 'Trastuzumab')) %>% ## ,
##                                      ## trastuzumab  == 'No'  ~ '')) %>%


###################################################################################
## Survival                                                                      ##
###################################################################################
## Derive variables required for survival here                                   ##
##                                                                               ##
## This will likely all change when actual data becomes available!!!             ##
###################################################################################
age_gap <- age_gap %>%
           mutate(death    = ifelse(is.na(disc_rsn) | disc_rsn != 'Participant died',
                                    yes = 0,
                                    no  = 1)) %>%
           arrange(individual_id, event_date) %>%
           group_by(individual_id) %>%
       mutate(recruited = min(event_date, na.rm = TRUE),
                  ## These need to be far more complex and conditional on the event_name
                  ## last_seen = case_when(death == 1 ~ max(disc_death_dt, na.rm = TRUE),
                  ##                       ## death == 0 ~ max(event_date, na.rm = TRUE))) %>%
                  ##                       death == 0 ~ max(study_completion_dt, na.rm = TRUE)),
                  ## First replace last_seen with event_date if this is 6 week/6 month/12 month/
                  ## 18 month follow up date
              last_seen = case_when(death == 1 & !is.na(study_completion_dt) ~ study_completion_dt,
                                 death == 0 & is.na(study_completion_dt)  ~ event_date,
                                 death == 0 & !is.na(study_completion_dt) ~ study_completion_dt,
                                 death == 0 & is.na(study_completion_dt)  ~ max(event_date, na.rm = TRUE))) %>%
           ungroup() %>%
           mutate(survival      = last_seen - recruited,
                  age_last_seen = lubridate::new_interval(start = dob,
                                                          end = last_seen) / duration(num = 1, units = 'years'))



###################################################################################
## Bulk out data                                                                 ##
###################################################################################
## Some variables are derived at a single time point, but are required to be     ##
## present at all event_names (e.g. primary_treatment or er_tumour), these are   ##
## bulked out here                                                               ##
###################################################################################
age_gap <- age_gap %>%
    group_by(individual_id) %>%
    ## Because study completion data has been coerced to align with Baseline (since the
    ## event_name 'Study Completion' doesn't align with any others)
           fill(## Key identifier
                ## enrolment_no,
                randomisation,
                ethnicity,
                ## Baseline tumour assessments
                allred_baseline,
                h_score_baseline,
                pgr_score_baseline,
                her_2_score_baseline,
                taking_meds_baseline,
                histo_grade_baseline,
                histo_subtype_baseline,
                focal_baseline,
                num_tumours_baseline,
                cancer_palpable_baseline,
                size_clin_assess_baseline,
                method_assess_baseline,
                size_ultrasound_baseline,
                size_mammo_baseline,
                axillary_present_baseline,
                axillary_nodes_baseline,
                axillary_axis_baseline,
                biopsy_type_baseline,
                confirm_present_baseline,
                histo_spcfy_baseline,
                adl_score,
                iadl_score,
                ## Derived variables
                age_exact,
                height_cm,
                weight_kg,
                bmi,
                age_cat,
                primary_treatment,
                er_tumour,
                ## Survival variables
                disc_death_dt,
                disc_rsn,
                death_cause_1,
                death_cause_2,
                death_cause_3,
                death,
                last_seen,
                age_last_seen,
                ethnicity)

## Finally make copies of age_gap to master$ and then remove those who were not enrolled
master$master <- age_gap
age_gap <- age_gap %>%
           ## dplyr::filter(!is.na(enrolment_no))
           dplyr::filter(!is.na(randomisation))

###################################################################################
## Add in derived variables to the fields lookup                                 ##
###################################################################################
master$lookups_fields <- rbind(master$lookups_fields,
                               ## c('', '', '', ''),
                               c('', '', 'weight_kg', 'Weight (kg)'),
                               c('', '', 'bmi', 'Body Mass Index'),
                               c('', '', 'age_exact', 'Age (years)'),
                               c('', '', 'elapsed', 'Time from consent/randomisation to stated event.'),
                               c('', '', 'collaborate_calc_score', 'Collaborate Score'),
                               c('Sites', '', 'database_id', 'Database ID for Site'),
                               c('Sites', '', 'code', 'Numeric Site Code'),
                               c('Sites', '', 'site', 'Site Name'),
                               c('Sites', '', 'long_site', 'Long-form Site name'),
                               c('Sites', '', 'rct_site', 'Site involved in RCT component'),
                               c('Sites', '', 'group', 'Site RCT allocation'),
                               c('Sites', '', 'rct_date', 'Date of Randomisation'),
                               c('Sites', '', 'pe_site', 'Site included in PE'),
                               c('Sites', '', 'qol_sub_study', 'Site included in Qualit of Life Sub-Study'),
                               c('', '', 'cf_raw', 'CF Raw'),
                               c('', '', 'ef_raw', 'EF Raw'),
                               c('', '', 'fa_raw', 'FA Raw'),
                               c('', '', 'nv_raw', 'NV Raw'),
                               c('', '', 'pa_raw', 'PA Raw'),
                               c('', '', 'pf_raw', 'PF Raw'),
                               c('', '', 'ql_raw', 'QL Raw'),
                               c('', '', 'rf_raw', 'RF Raw'),
                               c('', '', 'sf_raw', 'SF Raw'),
                               c('', '', 'treatment_profile', 'Treatments Received'),
                               c('', '', 'treatment_missing', 'Indicator of whether there is missing data for any given treatment.'),
                               c('', '', 'mmse_cat', 'Categorisation of Mini Mental State Examination'),
                               c('', '', 'charlson_cat', 'Categorisation of Charlson Score'),
                               c('Derived', '', 'endocrine_therapy_yet', 'Has patient received Endocrine Therapy by the noted event'),
                               c('Derived', '', 'endocrine_therapy_ever', 'Has patient ever received Endocrine Therapy during the study'),
                               c('Derived', '', 'chemotherapy_yet', 'Has patient received Chemotherapy by the noted event'),
                               c('Derived', '', 'chemotherapy_ever', 'Has patient ever received Chemotherapy during the study'),
                               c('Derived', '', 'radiotherapy_yet', 'Has patient received Radiotherapy by the noted event'),
                               c('Derived', '', 'radiotherapy_ever', 'Has patient ever received Radiotherapy during the study'),
                               c('Derived', '', 'surgery_yet', 'Has patient received Surgery by the noted event'),
                               c('Derived', '', 'surgery_ever', 'Has patient ever received Surgery during the study'),
                               c('Derived', '', 'trastuzumab_yet', 'Has patient received Trastuzumab by the noted event'),
                               c('Derived', '', 'trastuzumab_ever', 'Has patient ever received Trastuzumab during the study'),
                               c('Derived', '', 'site_breast', 'Overall Site of Breast Cancer'),
                               c('Derived', '', 'site_axilla', 'Overall Site of Axilla'),
                               c('Derived', '', 'site_supraclavicular', 'Overall Site of Supraclavicular'),
                               c('Derived', '', 'site_chest_wall', 'Overall Site of Chest Wall'),
                               c('Derived', '', 'site_other', 'Overall site of Other'),
                               c('Derived', '', 'breast_fractions', 'Overall Breast Fractions'),
                               c('Derived', '', 'axilla_fractions', 'Overall Axilla Fracions'),
                               c('Derived', '', 'supra_fractions', 'Overall Supra Fractions'),
                               c('Derived', '', 'chest_fractions', 'Overall Chest Fractions'),
                               c('Derived', '', 'other_fractions', 'Overall Other Fractions'),
                               c('Derived', '', 'radiotherapy_aes', 'Overall Radiotherapy AES'),
                               c('Derived', '', 'skin_erythema', 'Overall Skin Erythema'),
                               c('Derived', '', 'pain', 'Overall Pain'),
                               c('Derived', '', 'breast_oedema', 'Overall Breast Oedema'),
                               c('Derived', '', 'breast_shrink', 'Overall Breast Shrinkage'),
                               c('Derived', '', 'breast_pain', 'Overall Breast Pain'),
                               c('Derived', '', 'surgery_type', 'Overall Surgery Type'),
                               c('Derived', '', 'axillary_type', 'Overall Axillary Type'),
                               c('Derived', '', 'surgery_aes_acute', 'Overall Acute Adverse Events relating to surgery'),
                               c('Derived', '', 'sa_haemorrhage', 'Overall Acute Haemorrhage Adverse Events related to Surgery'),
                               c('Derived', '', 'sa_seroma', 'Overall Acute SA Seroma Adverse Events related to Surgery'),
                               c('Derived', '', 'sa_haematoma', 'Overall Acute Haematoma Adverse Events related to Surgery'),
                               c('Derived', '', 'sa_infection', 'Overall Acute Infection Adverse Events related to Surgery'),
                               c('Derived', '', 'sa_necrosis', 'Overall Acute Necrosis Adverse Events related to Surgery'),
                               c('Derived', '', 'sa_wound', 'Overall Acute Wound Adverse Events related to Surgery'),
                               c('Derived', '', 'surgery_aes_chronic', 'Overall Chronic Adverse Events relating to Surgery'),
                               c('Derived', '', 'sc_wound_pain', 'Overall Chronic Wound Pain Adverse Events related to Surgery'),
                               c('Derived', '', 'sc_functional_diff', 'Overall Functional Difficulty Pain Adverse Events related to Surgery'),
                               c('Derived', '', 'sc_neuropathy', 'Overall Chronic Neuropathy Adverse Events related to Surgery'),
                               c('Derived', '', 'sc_lymphoedema', 'Overall Chronic Lymphoedema Adverse Events related to Surgery'),
                               c('Derived', '', 'tumour_size', 'Overall Tumour Size'),
                               c('Derived', '', 'allred', 'Overall Allred (Estrogen Receptor Responsiveness)'),
                               c('Derived', '', 'h_score', 'Overall '),
                               c('Derived', '', 'her_2_score', 'Overall '),
                               c('Derived', '', 'onco_offered', 'Overall '),
                               c('Derived', '', 'onco_used', 'Overall '),
                               c('Derived', '', 'risk_score', 'Overall '),
                               c('Derived', '', 'tumour_type', 'Overall '),
                               c('Derived', '', 'tumour_grade', 'Overall '),
                               c('Derived', '', 'margins_clear', 'Overall '),
                               c('Derived', '', 'margin', 'Overall '),
                               c('Derived', '', 'designation_anterior', 'Overall '),
                               c('Derived', '', 'designation_posterior', 'Overall '),
                               c('Derived', '', 'designation_lateral', 'Overall '),
                               c('Derived', '', 'designation_medial', 'Overall '),
                               c('Derived', '', 'designation_superior', 'Overall '),
                               c('Derived', '', 'designation_inferior', 'Overall '),
                               c('Derived', '', 'close_margin', 'Overall '),
                               c('Derived', '', 'nodes_excised', 'Overall '),
                               c('Derived', '', 'nodes_involved', 'Overall '),
                               c('Derived', '', 'focal_pet', 'Overall '),
                               c('Derived', '', 'num_tumours_pet', 'Overall '),
                               c('Derived', '', 'cancer_palpable_pet', 'Overall '),
                               c('Derived', '', 'size_clin_assess_pet', 'Overall '),
                               c('Derived', '', 'method_assess_pet', 'Overall '),
                               c('Derived', '', 'size_ultrasound_pet', 'Overall '),
                               c('Derived', '', 'size_mammo_pet', 'Overall '),
                               c('Derived', '', 'axillary_present_pet', 'Overall '),
                               c('Derived', '', 'axillary_nodes_pet', 'Overall '),
                               c('Derived', '', 'axillary_axis_pet', 'Overall '),
                               c('Derived', '', 'focal_baseline', 'Overall '),
                               c('Derived', '', 'num_tumours_baseline', 'Overall '),
                               c('Derived', '', 'cancer_palpable_baseline', 'Overall '),
                               c('Derived', '', 'size_clin_assess_baseline', 'Overall '),
                               c('Derived', '', 'method_assess_baseline', 'Overall '),
                               c('Derived', '', 'size_ultrasound_baseline', 'Overall '),
                               c('Derived', '', 'size_mammo_baseline', 'Overall '),
                               c('Derived', '', 'axillary_present_baseline', 'Overall '),
                               c('Derived', '', 'axillary_nodes_baseline', 'Overall '),
                               c('Derived', '', 'axillary_axis_baseline', 'Overall '),
                               c('Derived', '', 'biopsy_type_baseline', 'Overall '),
                               c('Derived', '', 'confirm_present_baseline', 'Overall '),
                               c('Derived', '', 'histo_grade_baseline', 'Overall '),
                               c('Derived', '', 'histo_subtype_baseline', 'Overall '),
                               c('Derived', '', 'histo_spcfy_baseline', 'Overall '),
                               c('Derived', '', 'allred_baseline', 'Estrogen receptor score at Baseline (worst of l_allred_baseline and r_allred_baseline)'),
                               c('Derived', '', 'h_score_baseline', 'Overall '),
                               c('Derived', '', 'pgr_score_baseline', 'Overall '),
                               c('Derived', '', 'her_2_score_baseline', 'Overall '),
                               c('Derived', '', 'er_tumour', 'Estrogen Receptor binary classifcation (based on allred_baseline)'),
                               c('Derived', '', 'assessment_dt_chemotherapy' ,'Date of Chemotherapy form completion (derived from assessment_dt on Chemotherapy form, renamed to avoid conflicts)'),
                               c('Derived', '', 'assessment_dt_radiotherapy' ,'Date of Radiotherapy form completion (derived from assessment_dt on Radiotherapy form, renamed to avoid conflicts)'),
                               c('Derived', '', 'assessment_dt_endocrine' ,'Date of Endocrine Therapy form completion (derived from assessment_dt on Endocrine Therapy form, renamed to avoid conflicts)'),
                               c('Derived', '', 'assessment_dt_trastuzumab' ,'Date of Trastuzumab form completion (derived from assessment_dt on Trastuzumab form, renamed to avoid conflicts)'),
                               c('Derived', '', 'death' ,'Death (currently based on Study Discontinuation Form)'),
                               c('Derived', '', 'recruited' ,'Date of recruitment, a proxy for diagnosis from which survival is calculated'),
                               c('Derived', '', 'last_seen' ,'Date of last contact'),
                               c('Derived', '', 'survival' ,'Length of Survival (last_seen - recruited)'),
                               c('Derived', '', 'age_last_seen' ,'Age at last contact (based on Date of Birth)'),
                               c('Derived', '', 'study_completion_dt' ,'Date on which Study Completion and Discontinuation Form was completed (based on event_date from that form, required as not always at two year follow-up visit)'))



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
                        form = ifelse(data_frame == 'event_date',
                                      yes        = 'Unique Event Dates',
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
                                      no         = form),
                        form = ifelse(data_frame == 'master',
                                      yes        = 'List of all of Data Frame including those not enrolled but with Baseline data.',
                                      no         = form),
                        form = ifelse(data_frame == 'age_gap',
                                      yes        = 'Master Data Frame including those not enrolled but with Baseline data.',
                                      no         = form),
                        form = ifelse(data_frame == 'primary_treatment_numbers',
                                      yes        = 'List of the number of individuals primary treatment derived at each time point (not everyone has had treatment by 6 weeks so 6 month data is then used etc.)',
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
## Generate an imputed data set                                                  ##
###################################################################################
## ToDo...                                                                       ##
##                                                                               ##
## 1. Find out what variables are to be included, this depends on input from     ##
##    the CI at least, likely some sort of consensus from others.                ##
##                                                                               ##
## 2. Assess how much missing daata there is.                                    ##
##                                                                               ##
## 3. Decide what modelling approach to use.                                     ##
##                                                                               ##
## 4. What package to use, mice, amelia or mi, mitools? (Likely not one but many)##
##                                                                               ##
## 5. How to assess whether data is MCAR/MAR/NMAR?                               ##
##                                                                               ##
##    - Could plot a heat-map of event (x) and response (y) with colour          ##
##      indicating the proportion of missing data?                               ##
##                                                                               ##
##      See https://goo.gl/JCKv5f                                                ##
##                                                                               ##
## Some link/tutorials...                                                        ##
##                                                                               ##
## https://goo.gl/mFrTDt                                                         ##
## https://goo.gl/chCwHz                                                         ##
##                                                                               ##
## Notes...                                                                      ##
##                                                                               ##
## * Generally not advisable to impute categorical variables                     ##
## * Paper : https://goo.gl/8d9HFR                                               ##
##                                                                               ##
###################################################################################

###################################################################################
## Save and Export                                                               ##
###################################################################################
save(master, age_gap, primary_treatment_numbers,
     all_var, factor_vars, continuous_vars,
     file = '../data/age-gap.RData',
     compression_level = 9)
## write_dta(age_gap, version = 14, path = 'stata/age_gap.dta')
