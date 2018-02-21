## 2018-02-20 - geom_km() wrangling
##
## This works (from the example at https://github.com/sachsmc/ggkm)
lung %>%
    as.tibble() %>%
    ggplot(aes(time = time,
               status = status,
               colour = factor(sex))) +
    geom_km() +
    geom_kmticks() +
    theme_bw()
dim(lung)
str(lung)
dplyr::select(lung, time, status, sex)

## This doesn't look right at all
to_plot <- age_gap %>%
           dplyr::select(individual_id, event_name, primary_treatment, survival, death) %>%
           dplyr::filter(event_name == "Baseline") %>%
           dplyr::filter(!is.na(primary_treatment)) %>%
           dplyr::filter(primary_treatment == "Chemotherapy") %>%
           dplyr::filter(survival != 0) %>%
           mutate(time                = as.double(survival),
                  status              = death,
                  `Primary Treatment` = primary_treatment)
ggplot(to_plot,
       aes(time   = time,
           status = status)) + geom_km()
           colour = `Primary Treatment`)) +
    geom_km() +
    facet_wrap(~primary_treatment, ncol = 1) +
    theme_bw()

## Lets try putting the two together
test <- to_plot %>%
        mutate(time = survival,
               status = death,
               sex    = ifelse(runif(n = 1) > 0.5,
                               yes = as.integer(2),
                               no  = as.integer(1))) %>%
        ungroup() %>%
        dplyr::select(time,
                      status,
                      sex) %>%
        as.data.frame()
test <- rbind(test,
              dplyr::select(lung, time, status, sex))
test %>%
    ggplot(aes(time = time,
               status = status)) +
    geom_km() +
    geom_kmticks() +
    theme_bw()

## 2018-02-19 - Tabulating things using ctru::table_summary()
test <- age_gap %>%
        dplyr::filter(event_name == "Baseline") %>%
        dplyr::filter(!is.na(primary_treatment)) %>%
        ungroup() %>%
        ctru::table_summary(df        = .,
                            lookup    = master$lookups_fields,
                            id        = individual_id,
                            select    = c(histo_grade_baseline),
                            time      = event_name,
                            group     = primary_treatment,
                            nomissing = FALSE,
                            digits    = 3,
                            reshape   = NULL)
## Now reshape (as I've not sussed out how to split quo_group within ctru::table_summary())
test$factor %>%
    ## dcast(event_name + event_name + label ~ value) %>%
    spread(test$factor,
           primary_treatment,
           n_prop)

## 2018-02-14 - Why isn't ethnicity which is a factor in master$screening_form and master$baseline
##              not a factor in age_gap
##
## Worked it out, when combining ethnicity into the master$baseline the event_name in
## the master$screening_form is "Screening" so nothing matched!!!
t <- full_join(master$therapy_qol,
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

is.factor(t$ethnicity)
table(t$ethnicity)


## 2018-02-07 - Graphing the Activities of Daily Living components
##
## Berthel
age_gap %$% levels(feeding)
age_gap %$% levels(transfer_bed_chair)
age_gap %$% levels(personal_toilet)
age_gap %$% levels(toiletting)
age_gap %$% levels(bathing)
age_gap %$% levels(walking_wheelchair)
age_gap %$% levels(ascend_descend)
age_gap %$% levels(dressing)
age_gap %$% levels(bowels)
age_gap %$% levels(bladder)
## Instrumental
age_gap %$% levels(telephone)
age_gap %$% levels(shopping)
age_gap %$% levels(food_prep)
age_gap %$% levels(housekeeping)
age_gap %$% levels(laundry)
age_gap %$% levels(transport)
age_gap %$% levels(medication)
age_gap %$% levels(finances)


## 2018-01-29 - Now we now study completion isn't always the same as two year follow-up
##              need to include the date of study completion as the "last_seen" date
##
## Lets compare the two (df using last event_date is now in age_gap_old for the current session
## change lines 2437/2438 under section "Survival" of ~/lib/data-raw/import.R if needed again)
## png(filename = "~/work/scharr/age-gap/tmp/survival_old.png", width = 1024, height = 768)
ggplot(age_gap_old, aes(survival)) +
    geom_histogram(bins = 80) +
    ## annotate("432",
    ##          x = 0, y = 432) +
    xlab("Days") +
    ylab("N") +
    ggtitle("Survival by Event Date") +
    facet_wrap(~event_name, ncol = 1) +
    theme_bw()
## dev.off()
## png(filename = "~/work/scharr/age-gap/tmp/survival_new.png", width = 1024, height = 768)
age_gap %>%
    mutate(disc_rsn = ifelse(!is.na(disc_rsn),
                             yes = disc_rsn,
                             no  = "No Completion, date last seen.")) %>%
    dplyr::filter(!is.na(disc_rsn)) %>%
ggplot(, aes(as.numeric(survival), fill = disc_rsn)) +
    geom_histogram(bins = 80) +
    ## annotate("432",
    ##          x = 0, y = 432) +
    xlab("Days") +
    ylab("N") +
    ggtitle("Survival by Event Date") +
    facet_wrap(~event_name, ncol = 1) +
    theme(legend.text = "Last Contact")
    theme_bw()
## dev.off()

## Determining how to get the death date by event_name which needs to be the event_date
## for none Baseline/ other periods
check <- age_gap %>%
    dplyr::select(individual_id,
                  ## site,
                  event_name,
                  event_date,
                  study_completion_dt,
                  disc_rsn) %>%
    mutate(death = ifelse(is.na(disc_rsn) | disc_rsn != 'Participant died',
                          yes = 0,
                          no  = 1)) %>%
    arrange(individual_id, event_date) %>%
    group_by(individual_id) %>%
    mutate(recruited = min(event_date, na.rm = TRUE),
           last_seen = case_when(death == 1 & !is.na(study_completion_dt) ~ study_completion_dt,
                                 death == 0 & is.na(study_completion_dt)  ~ event_date,
                                 death == 0 & !is.na(study_completion_dt) ~ study_completion_dt,
                                 death == 0 & is.na(study_completion_dt)  ~ max(event_date, na.rm = TRUE)))
head(check, n = 40) %>% as.data.frame()

## Check by individual_id
## Missing 18/24 month follow-up but study completion available and dated one month after last scheduled contact...
dplyr::filter(check, individual_id == 47728)
## This person is lost to follow-up, should therefore have have NAs...
dplyr::filter(check, individual_id == 47729)
## Looks good (study_completion != event_date for 24 months)...
dplyr::filter(check, individual_id == 47731)
## Looks good (study_completion == event_date for 24 months)...
dplyr::filter(check, individual_id == 47817)
## Looks good (died four months after 6 month visit)...
dplyr::filter(check, individual_id == 47899)
## Looks good didn't die and study completion is a few weeks after 24 month follow-up
dplyr::filter(check, individual_id == 47910)

## Check some others who have died
dplyr::filter(check, death == 1) %$%
    table(individual_id) %>%
    head(n = 10)
## Looks good, Died roughly four months after 6 month follow up
dplyr::filter(check, individual_id == 47962)
## Problematic, Participant died two years after recruitment but missing all data
dplyr::filter(check, individual_id == 48013)
## Looks good, participant died three months after 6 month follow-up no missing data
dplyr::filter(check, individual_id == 48064)
## Looks good, participant died one month after 6 month follow-up, no missing data
dplyr::filter(check, individual_id == 48101)
## Looks good, participant died ~five months after 6 month follow-up, no missing data
dplyr::filter(check, individual_id == 48102)
## Problematic, participant died a year and a half after 6 week follow-up, but missing data
dplyr::filter(check, individual_id == 48322)
## Looks good, participant died four months after 6 week follow up, no missing data
dplyr::filter(check, individual_id == 48375)
## Problematic, participant died seven months after 12 month follow up, missing 18 month data
dplyr::filter(check, individual_id == 48440)

## Now check those who didn't die
dplyr::filter(check, death == 0) %$%
    table(individual_id) %>%
    head(n = 10)
## Problematic study_completiong_date is nine days prior to 24 month follow-up
dplyr::filter(check, individual_id == 47932)
## Problematic, no 24 month follow-up, no study completion
dplyr::filter(check, individual_id == 47953)
## Looks good
dplyr::filter(check, individual_id == 47954)
## Looks good
dplyr::filter(check, individual_id == 47967)
## Problematic, no study completion
dplyr::filter(check, individual_id == 48011)
## Looks good
dplyr::filter(check, individual_id == 48012)

## 2018-01-29 - Checking the data from study discontinuation is merged correctly and
##              gives a death date that is the same across time points
check <- full_join(master$therapy_qol,
                     master$baseline,
                     by = c('individual_id', 'site', 'event_name')) %>%
           full_join(.,
                     master$rct,
                     by = c('individual_id', 'site', 'event_name')) %>%
## Study completion discontinuation form (deaths/censoring)
           left_join(.,
                     dplyr::select(master$study_completion_discontinuation_form,
                                   individual_id, site, ## event_name, event_date, database_id,
                                   disc_death_dt,
                                   disc_rsn,
                                   death_cause_1,
                                   death_cause_2,
                                   death_cause_3),
                     by = c('individual_id', 'site')) %>%
           dplyr::select(individual_id,
                         site,
                         event_name,
                         disc_death_dt,
                         disc_rsn) %>%
           dplyr::filter(disc_rsn == "Participant died")
## How many people have death recorded?
dim(check)
## How many individuals is this?
check %>%
    dplyr::select(individual_id) %>%
    unique() %>%
    dim()
## The correct number (i.e. the above two match)!!!
##
## Lets check the age_gap dataframe and see if the survival/age_last_seen are
## consistent over the multiple events (they should be since the 'recruited'
## variable is the minimum event_date)
check <- age_gap %>%
         dplyr::select(individual_id,
                       event_name,
                       event_date,
                       recruited,
                       disc_death_dt,
                       last_seen,
                       survival)
## Total participants and observations
dim(check)
## Total participants
check %$%
    table(individual_id, event_name) %>%
    nrow()
## How many unique survivals are there
check %>%
    dplyr::select(individual_id, survival, last_seen, disc_death_dt) %>%
    unique() %>%
    dim()


## 2018-01-29 - Checking Study Completion forms == 24 Month follow-up for most
##              individuals (won't be all as some will withdraw/die before then)
t1 <- age_gap %>%
      dplyr::select(individual_id, event_date, event_name) %>%
      dplyr::filter(event_name == "24 months") %>%
      mutate(event_date_master = event_date) %>%
      dplyr::select(-event_date, -event_name)
t2 <- master$study_completion_discontinuation_form %>%
      dplyr::select(individual_id, event_date) %>%
      mutate(event_date_completion = event_date) %>%
      dplyr::select(-event_date)
check <- full_join(t1, t2) %>%
    mutate(completion_diff_24month = event_date_completion - event_date_master)
annotation <- dplyr::filter(check, completion_diff_24month == 0) %>% nrow()
png(filename = "~/work/scharr/age-gap/tmp/difference_completion_and_24_month.png", width = 1024, height = 768)
ggplot(check, aes(completion_diff_24month)) +
    geom_histogram(bins = 80) +
    ## annotate("432",
    ##          x = 0, y = 432) +
    xlab("Days") +
    ylab("N") +
    ggtitle("Difference between Study Completion form date and 24 month follow-up.") +
    theme_bw()
dev.off()
## ...conclusion is that they don't!!!


## 2018-01-25 - Kaplan-Meier plots
##
## Lets look at the example lung data
head(lung, n = 40)
lung %$% table(time, status)

## ...and compare to subsetted age_gap
dplyr::select(age_gap, event_name, individual_id, site, survival, death, primary_treatment) %>%
    dplyr::filter(event_name == "Baseline") %>%
    dplyr::filter(primary_treatment == "Surgery") %>%
    mutate(death = death + 1) %>%
    ## ToDo - filter based on descired comparison
    ## dplyr::filter() %>%
    unique() %$%
    table(survival, death)

## 2018-01-10 - Further work on deriving primary treatment, currently these are defined
##              specific to the time point of follow-up, in reality we want one overall
##              that is consistent across time points.
##
## Take a subset of data to play around with
checking <- age_gap %>%
            dplyr::select(individual_id, site, event_name, primary_treatment, treatment_profile,
                         endocrine_therapy, radiotherapy, surgery, chemotherapy, trastuzumab, primary_adjuvant) %>%
            head(n = 300)
checking_few <- age_gap %>%
            dplyr::select(individual_id, site, event_name, primary_treatment, treatment_profile,
                         endocrine_therapy, radiotherapy, surgery, chemotherapy, trastuzumab, primary_adjuvant) %>%
            dplyr::filter(individual_id %in% c(47954, 48012, 48215))

## Lets take 6 week data
primary_treatment <- dplyr::filter(age_gap, event_name == '6 weeks') %>%
                     dplyr::select(individual_id, site, event_name, primary_treatment, treatment_profile,
                                   endocrine_therapy, radiotherapy, surgery, chemotherapy, trastuzumab, primary_adjuvant) %>%
mutate(primary_treatment = case_when(endocrine_therapy == 'Yes' & primary_adjuvant == 'Primary' ~ 'Primary Endocrine',
                                     surgery == 'Yes' & primary_adjuvant == 'Adjuvant' ~ 'Surgery',
                                     surgery == 'Yes' & primary_adjuvant == 'Neoadjuvant' ~ 'Surgery',
                                     endocrine_therapy == 'No' & surgery == 'No' & chemotherapy == 'Yes' ~ 'Chemotherapy',
                                     endocrine_therapy == 'No' & surgery == 'No' & radiotherapy == 'Yes' ~ 'Chemotherapy',
                                     radiotherapy == 'Yes' ~ 'Radiotherapy',
                                     ## radiotherapy == 'No'  ~ '',
                                     trastuzumab  == 'Yes' ~ 'Trastuzumab'))
table(primary_treatment$primary_treatment)

## Of those who haven't yet got a primary treatment, how many had primary endocrine...
dplyr::filter(primary_treatment, is.na(primary_treatment)) %$%
    table(primary_adjuvant, useNA = 'ifany')
## How many had Surgery
dplyr::filter(primary_treatment, is.na(primary_treatment)) %$%
    table(surgery, useNA = 'ifany')
## Ahha, most of them, lets correct that and look again
primary_treatment <- dplyr::filter(age_gap, event_name == '6 weeks') %>%
                     dplyr::select(individual_id, site, event_name, primary_treatment, treatment_profile,
                                   endocrine_therapy, radiotherapy, surgery, chemotherapy, trastuzumab, primary_adjuvant) %>%
mutate(primary_treatment = case_when(endocrine_therapy == 'Yes' & primary_adjuvant == 'Primary' ~ 'Primary Endocrine',
                                     surgery == 'Yes' & primary_adjuvant == 'Adjuvant' ~ 'Surgery',
                                     surgery == 'Yes' & primary_adjuvant == 'Neoadjuvant' ~ 'Surgery',
                                     surgery == 'Yes' & is.na(primary_adjuvant) ~ 'Surgery',
                                     endocrine_therapy == 'No' & surgery == 'No' & chemotherapy == 'Yes' ~ 'Chemotherapy',
                                     endocrine_therapy == 'No' & surgery == 'No' & radiotherapy == 'Yes' ~ 'Chemotherapy',
                                     radiotherapy == 'Yes' ~ 'Radiotherapy',
                                     ## radiotherapy == 'No'  ~ '',
                                     trastuzumab  == 'Yes' ~ 'Trastuzumab'))
table(primary_treatment$primary_treatment)

## Of those who haven't yet got a primary treatment, how many had primary endocrine...
dplyr::filter(primary_treatment, is.na(primary_treatment)) %$%
    table(primary_adjuvant, useNA = 'ifany')
## How many had Surgery
dplyr::filter(primary_treatment, is.na(primary_treatment)) %$%
    table(surgery, useNA = 'ifany')
## Ok, thats sorted out 1518 individuals, leaving 161 who didn't have endocrine or surgery
## Lets look at their chemo and radiotherapy
dplyr::filter(primary_treatment, is.na(primary_treatment)) %$%
    table(chemotherapy, useNA = 'ifany')
dplyr::filter(primary_treatment, is.na(primary_treatment)) %$%
    table(radiotherapy, useNA = 'ifany')
dplyr::filter(primary_treatment, is.na(primary_treatment)) %$%
    table(trastuzumab, useNA = 'ifany')
## Nope, they didn't have chemo or radiotherapy either (101 for definite; 60 with missing for
## both).  Lets look at the treatment profiles
dplyr::filter(primary_treatment, is.na(primary_treatment)) %>%
    dplyr::select(treatment_profile, endocrine_therapy, surgery,chemotherapy, radiotherapy, primary_adjuvant, primary_treatment) %$%
        table(treatment_profile)
## Ok 61 had "None" 100 had Endocrine, but what sort?
dplyr::filter(primary_treatment, is.na(primary_treatment)) %>%
    dplyr::select(treatment_profile, endocrine_therapy, surgery,chemotherapy, radiotherapy, primary_adjuvant, primary_treatment) %>%
    dplyr::filter(treatment_profile == 'Endocrine') %$%
    table(primary_adjuvant)
## Of those 34 had  Adjuvant and 61 Neoadjuvant

## 2018-01-05 - Duplicate investigation continued
##
## Lets look at individual_id == 47817 to see what file has missing site for this person
quick_check <- function(df = master$baseline){
    substitute(df) %>% deparse() %>% print()
    df %>%
        dplyr::filter(individual_id == 47817) %>%
        dplyr::select(individual_id, site, event_name, event_date)
}

quick_check(df = master$baseline)
quick_check(df = master$therapy_qol)
quick_check(df = master$rct)
quick_check(df = master$abridged_patient_assessment)
quick_check(df = master$activities_daily_living)
quick_check(df = master$adverse_events_ae)
quick_check(df = master$adverse_events)
quick_check(df = master$baseline_medications)
quick_check(df = master$baseline_medications_med)
quick_check(df = master$baseline_tumour_assessment)
quick_check(df = master$breast_cancer_treatment_choices_chemo_no_chemo)
quick_check(df = master$breast_cancer_treatment_choices_surgery_pills)
quick_check(df = master$brief_cope)
quick_check(df = master$change_in_participation)
quick_check(df = master$chemotherapy_chemotherapy)
quick_check(df = master$chemotherapy)
quick_check(df = master$clinical_assessment_non_pet)
quick_check(df = master$clinical_assessment_pet)
quick_check(df = master$collaborate)
quick_check(df = master$consent_form)
quick_check(df = master$decision_making_preferences)
quick_check(df = master$decision_regret_scale)
quick_check(df = master$discussing_treatment_options)
quick_check(df = master$ecog_performance_status_score)
quick_check(df = master$eligibility_checklist)
quick_check(df = master$endocrine_therapy)
quick_check(df = master$eortc_qlq_br23)
quick_check(df = master$eortc_qlq_c30)
quick_check(df = master$eortc_qlq_eld15)
quick_check(df = master$eq5d)
quick_check(df = master$instrumental_activities_daily_living)
quick_check(df = master$mini_mental_state_examination)
quick_check(df = master$modified_charlson_comorbidity)
quick_check(df = master$process_evaluation_log)
quick_check(df = master$process_evaluation)
quick_check(df = master$qol_lol_questionnaire)
quick_check(df = master$radiotherapy)
quick_check(df = master$screening_form)
quick_check(df = master$spielberger_state_trait_anxiety)
quick_check(df = master$study_completion_discontinuation_form)
quick_check(df = master$surgery_and_post_operative_pathology)
quick_check(df = master$the_brief_illness_perception_questionnaire)
quick_check(df = master$therapy_assessment)
quick_check(df = master$therapy_ever)
quick_check(df = master$trastuzumab)
quick_check(df = master$treatment_decision)
quick_check(df = master$treatment_decision_support_consultations)
quick_check(df = master$transfers)

## Perhaps the duplication arises when merging the data frames baseline/therapy_qol/rct
full_join(master$therapy_qol,
          master$baseline,
          by = c('individual_id', 'site', 'event_name', 'event_date')) %>%
    dplyr::filter(individual_id == 47817) %>%
    dplyr::select(individual_id, site, event_name, event_date)
## Ahha, the QoL dataframe doesn't have event_date available, lets see why...
quick_check(df = master$eortc_qlq_br23)
quick_check(df = master$eortc_qlq_c30)
quick_check(df = master$eortc_qlq_eld15)
quick_check(df = master$eq5d)               ## Data with event_date
quick_check(df = master$therapy_assessment) ## Data with event_date
quick_check(df = master$endocrine_therapy)  ## Data with event_date
quick_check(df = master$radiotherapy)
quick_check(df = master$chemotherapy)
quick_check(df = master$surgery)
## ...its because none of the full_join() use event_date thus when combining therapy_qol and baseline
## using event_date its NA from the former
names(master$therapy_qol)
typeof(master$therapy_qol$event_date)
quick_check(df = master$therapy_qol)
names(master$baseline)
typeof(master$baseline$event_date)
quick_check(df = master$baseline)
full_join(master$therapy_qol,
          master$baseline,
          by = c('individual_id', 'site', 'event_name')) %>%
    dplyr::filter(individual_id == 47817) %>%
    dplyr::select(individual_id, site, event_name)


## 2018-01-04 - Duplicate investigation
## There appear some duplicates have crept into the dataset, at a bare minimum
## individual_id == 47817 is in there twice, lest work out why.
##
dplyr::select(age_gap, individual_id, site, event_name, event_date) %>%
        dplyr::filter(individual_id == 47817)


## 2018-01-04 - Checking derivation of survival
dplyr::select(age_gap,
              individual_id,
              event_name,
              event_date,
              recruited,
              last_seen,
              survival,
              disc_death_dt,
              censor) %>%
    arrange(individual_id, event_date) %>%
    ## Check a few types of people...
    ## Those with a discontinuation/death date
    ## dplyr::filter(!is.na(disc_death_dt)) %>% as.data.frame() %>% head(n = 30)
    ## Some without discontinuation/death date
    dplyr::filter(is.na(disc_death_dt)) %>% as.data.frame() %>% head(n = 30)
    ## A few random people...
    ## dplyr::filter(individual_id %in% c(47728, 47731))



## 2017-11-21 - Deriving indicators of whether treatment specific forms are missing
##              Code is present in ~/rmarkdown/sections/results_cohort/treatment_profiles.Rmd
to_share <- age_gap %>%
            dplyr::filter(event_name %in% events) %>%
            dplyr::select(-database_id) %>%
            dplyr::arrange(enrolment_no, event_name) %>%
            dplyr::filter(!treatment_profile %in% c('None',
                                                    'Chemotherapy',
                                                    'Chemotherapy + Surgery',
                                                    'Endocrine',
                                                    'Endocrine + Radiotherapy',
                                                    'Endocrine + Surgery',
                                                    'Radiotherapy + Surgery',
                                                    'Surgery'))
## Derive indicators of whether they are missing forms for a given treatment...
missing_forms <- to_share %>%
                 mutate(missing_surgery      = case_when(surgery           == 'Yes' &
                                                         is.na(surgery_dt) ~ 'Missing'),
                        missing_endocrine    = case_when(endocrine_therapy == 'Yes' &
                                                         is.na(assessment_dt_endocrine) ~ 'Missing'),
                        missing_radiotherapy = case_when(radiotherapy      == 'Yes' &
                                                         is.na(assessment_dt_radiotherapy) ~ 'Missing'),
                        missing_chemotherapy = case_when(chemotherapy      == 'Yes' &
                                                         is.na(assessment_dt_chemotherapy) ~ 'Missing'),
                        missing_trastuzumab  = case_when(trastuzumab       == 'Yes' &
                                                         is.na(assessment_dt_trastuzumab) ~ 'Missing')) %>%
                 dplyr::filter(missing_surgery     == 'Missing' |
                               missing_endocrine    == 'Missing' |
                               missing_radiotherapy == 'Missing' |
                               missing_chemotherapy == 'Missing' |
                               missing_trastuzumab  == 'Missing')
## Now check if anyone has missing forms...
##
## Surgery
missing_forms %>%
    dplyr::filter(missing_surgery == 'Missing') %>%
    dplyr::select(individual_id, enrolment_no, event_name, surgery_dt, treatment_profile,
                  general_local,
                  which_breast_right_surgery,
                  which_breast_left_surgery,
                  r_surgery_type,
                  r_axillary_type,
                  r_surgery_aes_acute,
                  l_allred,
                  l_surgery_type,
                  l_axillary_type,
                  l_surgery_aes_acute,
                  r_allred) %>% as.data.frame()
## Chemotherapy
missing_forms %>%
    dplyr::filter(missing_chemotherapy == 'Missing') %>%
    dplyr::select(individual_id, enrolment_no, event_name, assessment_dt_chemotherapy, treatment_profile,
                  chemo_received, chemo_aes,
                  c_fatigue, c_anaemia, c_low_wc_count, c_thrombocytopenia, c_allergic,
                  c_hair_thinning, c_nausea, c_infection) %>% as.data.frame()
## Radiotherapy
missing_forms %>%
    dplyr::filter(missing_radiotherapy == 'Missing') %>%
    dplyr::select(individual_id, enrolment_no, event_name, assessment_dt_radiotherapy, treatment_profile,
                  which_breast_right_radio, r_site_breast,
                  r_site_axilla, r_site_supraclavicular, r_site_chest_wall,
                  r_site_other, r_breast_fractions, r_axilla_fractions,
                  which_breast_left_radio, l_site_breast,
                  l_site_axilla, l_site_supraclavicular, l_site_chest_wall,
                  l_site_other, l_breast_fractions, l_axilla_fractions) %>% as.data.frame()
## Endocrine
missing_forms %>%
    dplyr::filter(missing_endocrine == 'Missing') %>%
    dplyr::select(individual_id, enrolment_no, event_name, assessment_dt_endocrine, treatment_profile,
                  primary_adjuvant, reason_pet, reason_pet_risk,
                  reason_pet_spcfy, endocrine_type, endocrine_type_oth,
                  therapy_changed, therapy_changed_dtls,
                  compliance, endocrine_aes, et_hot_flushes, et_asthenia) %>% as.data.frame()
## Trastuzumab
missing_forms %>%
    dplyr::filter(missing_trastuzumab == 'Missing') %>%
    dplyr::select(individual_id, enrolment_no, event_name, assessment_dt_trastuzumab, treatment_profile,
                  trast_received, infusion_no, trast_aes, t_cardiac_fail,
                  t_flu_like, t_nausea, t_diarrhoea, t_headache, t_allergy) %>% as.data.frame()
## Write the files to check
write.table(to_share,
            file = '~/work/scharr/age-gap/rmarkdown/data/csv/age_gap_review.csv',
            row.names = FALSE,
            col.names = TRUE,
            sep = ',')
write.table(missing_forms,
            file = '~/work/scharr/age-gap/rmarkdown/data/csv/missing_forms.csv',
            row.names = FALSE,
            col.names = TRUE,
            sep = ',')
write.table(master$lookup_fields,
            file = '~/work/scharr/age-gap/rmarkdown/data/csv/age_gap_dictionary.csv',
            row.names = FALSE,
            col.names = TRUE,
            sep = ',')

## 2017-11-21 - Checking whether there are any missing assessment_dt in the five treatment forms
master$chemotherapy %>%
    dplyr::filter(is.na(assessment_dt_chemotherapy)) %>%
    nrow()
master$radiotherapy %>%
    dplyr::filter(is.na(assessment_dt_radiotherapy)) %>%
    nrow()
master$endocrine %>%
    dplyr::filter(is.na(assessment_dt_endocrine)) %>%
    nrow()
master$surgery %>%
    dplyr::filter(is.na(surgery_dt)) %>%
    nrow()
master$trastuzumab %>%
    dplyr::filter(is.na(assessment_dt_trastuzumab)) %>%
    nrow()


## 2017-09-13 - Developing code for recording whether a treatment has been received between
##              baseline and a given event_date
test <- master$therapy_assessment %>%
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
        ## mutate(event_name = gsub(' ', '_', event_name)) %>%
        group_by(individual_id, variable) %>%
        mutate(lag1 = dplyr::lag(value, n = 1, order_by = event_date),
               lag2 = dplyr::lag(value, n = 2, order_by = event_date),
               lag3 = dplyr::lag(value, n = 3, order_by = event_date),
               lag4 = dplyr::lag(value, n = 4, order_by = event_date),
               lag5 = dplyr::lag(value, n = 5, order_by = event_date)) %>%
        mutate(value = case_when(value == 'Yes' |
                                 lag1  == 'Yes' |
                                 lag2  == 'Yes' |
                                 lag3  == 'Yes' |
                                 lag4  == 'Yes' |
                                 lag5  == 'Yes' ~ 'Yes'),
               value = ifelse(!is.na(value),
                              no  = 'No',
                              yes = value)) %>%
        dplyr::select(-lag1, -lag2, -lag3, -lag4, -lag5) %>%
        dcast(individual_id + event_name + event_date ~ variable, value.var = 'value')

## ToDo - Finish this off, need to dcast to wide with variable the repeated columns of dummy, then
##        its ready for merging with the main age_gap
test %>%  %>% head()
dplyr::filter(test, individual_id == 47731) %>% arrange(event_date) %>% as.data.frame()
dplyr::filter(master$therapy_assessment, individual_id == 47731) %>%
    arrange(event_date) %>%
    dplyr::select(individual_id, event_name, event_date, chemotherapy, radiotherapy, endocrine_therapy, surgery, trastuzumab)
## 2017-09-13 - Checking whether we have the actual dates on which therapy was received

sink(file = 'checking_treatment_dates.txt')
print('Check the number of rows in the data frame (first number after the noted therapy) then print out the number or rows where the two dates are not the same (second number after the noted therapy)...')
print('Therapy Assessment')
master$therapy_assessment %>% nrow()
dplyr::filter(master$therapy_assessment, event_date != date) %>% nrow()
print('Chemotherapy')
master$chemotherapy %>% nrow()
dplyr::filter(master$chemotherapy, event_date != assessment_dt) %>% nrow()
print('Chemotherapy - Chemotherapy')
print('Only one event_date recorded here so just list the number of rows and then print out the first ten rows to show a subset of the data')
master$chemotherapy_chemotherapy %>% nrow()
dplyr::select(master$chemotherapy_chemotherapy, individual_id, event_name, event_date, dose, unit) %>% head(n = 10)
print('Endocrine Therapy')
master$endocrine_therapy %>% nrow()
dplyr::filter(master$endocrine_therapy, event_date != assessment_dt) %>% nrow()
print('Radiotherapy')
master$radiotherapy %>% nrow()
dplyr::filter(master$radiotherapy, event_date != assessment_dt) %>% nrow()
print('Surgery')
master$surgery %>% nrow()
dplyr::filter(master$surgery, event_date != assessment_dt) %>% nrow()
print('Trastuzumab')
master$trastuzumab %>% nrow()
dplyr::filter(master$trastuzumab, event_date != assessment_dt) %>% nrow()
sink()

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
            left     = l_surgery_type,
            right    = r_surgery_type,
            both     = surgery_type,
            n        = 10,
            checking = ' Surgery Type')
quick_check(df       = age_gap,
            left     = l_axillary_type,
            right    = r_axillary_type,
            both     = axillary_type,
            n        = 10,
            checking = ' Surgery AES Acute')
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
quick_check(df       = age_gap,
            left     = l_histo_grade_baseline,
            right    = r_histo_grade_baseline,
            both     = histo_grade_baseline,
            n        = 10,
            checking = ' Histological Grade (Baseline)')
quick_check(df       = age_gap,
            left     = l_histo_subtype_baseline,
            right    = r_histo_subtype_baseline,
            both     = histo_subtype_baseline,
            n        = 10,
            checking = ' Histological Subtype (Baseline)')
quick_check(df       = age_gap,
            left     = l_her_2_score_baseline,
            right    = r_her_2_score_baseline,
            both     = her_2_score_baseline,
            n        = 10,
            checking = ' HER2 Score (Baseline)')
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
