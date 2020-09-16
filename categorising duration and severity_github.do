/***********categorising the duration and severity variables********************


*******************************************************************************/

use "C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1970 biomedical\time_severity_obese\v2\obesity profiles_both sexes_with outcomes_13_11_19.dta", clear

***merge with NSHD age at follow-up dataset sent by Adam Moore on 10/10/19 (NSHD was only cohort without it)
drop _merge
merge m:1 NSHD_ID using "C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\raw data\age at follow up vars_10oct\age at follow_up dataset after running script.dta", keepusing(age99)
drop _merge
gen age_follow_up_NSHD= age99/12
rename xage age_follow_up_NCDS
sum age_follow_up_NSHD age_follow_up_NCDS age_follow_up_bcs
gen age_follow_up_final=.
replace age_follow_up_final= age_follow_up_NSHD if cohort==1
replace age_follow_up_final= age_follow_up_NCDS if cohort==2
replace age_follow_up_final= age_follow_up_bcs if cohort==3
br age_fol*

***merge medication files (for adjustment)
merge m:1 NSHD_ID using  "C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\v2\bp_med_nshd.dta"
drop _merge
//merge m:1 ncdsid using "C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1958 biomedical\raw data\UKDA-5594-stata9\stata9\biomedicalsurvey2004.dta", keepusing(medtyp1 medtyp2 medtyp6 medtyp9)
//11/6/20 changed the dataset after havign now created the NCDS med dataset
merge m:1 ncdsid using "C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1958 biomedical\time_severity_obese\v2\bp_med_ncds_final.dta"
drop _merge
merge m:1 BCSID using "C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1970 biomedical\time_severity_obese\v2\bp_med_bcs_final.dta"


/*fre medtyp1 medtyp2 medtyp6 medtyp9
*all the relevant medications i identified in NCDS at biomedical sweep 
***NB NB NB ----until i receive the NCDS BNF data, will just create the bp_med_final/diab_med_final and lipid_med_final vars based on the very limited vars we do have (above)
egen bp_med_ncds= anymatch(medtyp2), v(1)
egen lipid_med_ncds= anymatch(medtyp2 medtyp9), v(1)
egen diab_med_ncds= anymatch(medtyp6 medtyp9), v(1)
*/

*combine into relevant medication variables
gen bp_med_final=.
replace bp_med_final= bp_med_nshd if cohort==1
replace bp_med_final= bp_med_ncds if cohort==2
replace bp_med_final= bp_med_bcs if cohort==3
tab bp_med_final

gen lipid_med_final=.
replace lipid_med_final= lipid_med_nshd if cohort==1
replace lipid_med_final= lipid_med_ncds if cohort==2
replace lipid_med_final= lipid_med_bcs if cohort==3
tab lipid_med_final

gen diab_med_final=.
replace diab_med_final= diab_med_nshd if cohort==1
replace diab_med_final= diab_med_ncds if cohort==2
replace diab_med_final= diab_med_bcs if cohort==3
tab diab_med_final


***(b)classifying never_ob== 0 (instead of missing)
replace tot_duration_obese=0 if num_times_obese==0 & obese_all_way!=1

*gen obese binary var
gen obese_yes= 1 if tot_duration_obese>0 & tot_duration_obese<.
replace obese_yes=0 if tot_duration_obese==0
tab obese_yes

drop _merge
merge m:1 NSHD_ID using "C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\v2\obesity profiles_males_NSHD_final_v2.dta", keepusing(auc25_nshd_males auc30_nshd_males) nogen
merge m:1 NSHD_ID using "C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\v2\obesity profiles_females_NSHD_final_v2.dta", keepusing(auc25_nshd_females auc30_nshd_females) nogen
merge m:1 newpid using "C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1958 biomedical\time_severity_obese\v2\obesity profiles_males_NCDS_final_v2.dta" , keepusing(auc25_ncds_males auc30_ncds_males) nogen
merge m:1 newpid using "C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1958 biomedical\time_severity_obese\v2\obesity profiles_females_NCDS_final_v2.dta" , keepusing(auc25_ncds_females auc30_ncds_females) nogen
merge m:1 newpid_bcs using "C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1970 biomedical\time_severity_obese\v2\obesity profiles_males_BCS_final_v2.dta", keepusing(auc25_bcs_male auc30_bcs_male) nogen
merge m:1 newpid_bcs using "C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1970 biomedical\time_severity_obese\v2\obesity profiles_females_BCS_final_v2.dta", keepusing(auc25_bcs_female auc30_bcs_female) nogen
gen auc25=.
replace auc25= auc25_nshd_males if cohort==1 & sex==0
replace auc25= auc25_nshd_females if cohort==1 & sex==1
replace auc25= auc25_ncds_males if cohort==2 & sex==0
replace auc25= auc25_ncds_females if cohort==2 & sex==1
replace auc25= auc25_bcs_male if cohort==3 & sex==0
replace auc25= auc25_bcs_female if cohort==3 & sex==1
gen auc30=.
replace auc30= auc30_nshd_males if cohort==1 & sex==0
replace auc30= auc30_nshd_females if cohort==1 & sex==1
replace auc30= auc30_ncds_males if cohort==2 & sex==0
replace auc30= auc30_ncds_females if cohort==2 & sex==1
replace auc30= auc30_bcs_male if cohort==3 & sex==0
replace auc30= auc30_bcs_female if cohort==3 & sex==1
sum auc25
sum auc25 if obese_yes==1
sum auc30 if obese_yes==1
pwcorr auc30 tot_duration_ob if obese_yes==1
scatter auc30 tot_duration_ob if obese_yes==1
hist auc30
***classifying never_ob== 0 (instead of missing)
replace auc30=0 if num_times_obese==0 & obese_all_way!=1

*adjusted auc30for duration_ob- if needed
gen auc30_adj=.
replace auc30_adj=auc30 if obese_yes==0
replace auc30_adj= auc30/tot_duration_obese if obese_yes==1
pwcorr auc30_adj tot_duration_ob if obese_yes==1


****TARGET SAMPLE
gen target_sample=.
replace target_sample=1 if cohort==1 & age_follow_up_NSHD<. & obese_yes<. & auc30<.
replace target_sample=1 if cohort==2 & age_follow_up_NCDS<. & obese_yes<. & auc30<. & target_sample==.
replace target_sample=1 if cohort==3 & age_follow_up_bcs<. & obese_yes<. & auc30<. & target_sample==.
replace target_sample=0 if target_sample==.
tab target_
tab sex if cohort==1 & age_follow_up_NSHD<. & obese_yes<. & auc30<.
tab sex if cohort==2 & age_follow_up_NCDS<. & obese_yes<. & auc30<.
tab sex if cohort==3 & age_follow_up_bcs<. & obese_yes<. & auc30<.

keep if target_sample==1

*******creating categorical duration and severity variables
**duration
pctile pct_tot_duration_obese_5 if obese_yes==1 & auc30<. = tot_duration_obese, nq(5)
*identify the cutpoints that split the duration var into 5 equal groups (approx 606 per group)
xtile cat_dur_ob_5 if obese_yes==1 & auc30<. = tot_duration_obese, cut(pct_tot_duration_obese_5)
*categorise people according to the cutpoints derived above
tab cat_dur_ob_5
replace cat_dur_ob_5=0 if obese_yes==0


gen cat_dur_ob_5_v2=.
replace cat_dur_ob_5_v2=0 if obese_yes==0
replace cat_dur_ob_5_v2=1 if tot_duration_obese<5 & obese_yes==1
replace cat_dur_ob_5_v2=2 if tot_duration_obese>=5 & tot_duration_obese<10
replace cat_dur_ob_5_v2=3 if tot_duration_obese>=10 & tot_duration_obese<15
replace cat_dur_ob_5_v2=4 if tot_duration_obese>=15 & tot_duration_obese<20
replace cat_dur_ob_5_v2=5 if tot_duration_obese>=20 & tot_duration_obese<=30

**severity
pctile pct_auc30_5 if obese_yes==1 = auc30, nq(5)
*identify the cutpoints that split the duration var into 5 equal groups (approx 606 per group)
xtile cat_auc30_5 if obese_yes==1 = auc30, cut(pct_auc30_5)
*categorise people according to the cutpoints derived above
tab cat_auc30_5


**********correcting for medication
***create adjusted bp - add 10 for hypertension users
clonevar sbpt_final = sbp_final
replace sbpt_final = sbp_final + 10 if bp_med_final ==1 & !missing(bp_med_final)
clonevar dbpt_final = dbp_final
replace dbpt_final = dbp_final + 5 if bp_med_final ==1 & !missing(bp_med_final)

***create adjusted hba1c - add 1% to hba1c for diabeteic med users (1% comes from the conclusions of the two papers i have found on review of diab med on hba1c: https://care.diabetesjournals.org/content/33/8/1859 and https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5256065/pdf/fendo-08-00006.pdf (both in folder)
clonevar hba1ct_final = hba1c_final
replace hba1ct_final = hba1c_final + 1 if diab_med_final ==1 & !missing(diab_med_final)

***create adjusted trig - increase trig by 10% (conservative estimate) of raw value for lipid med users (10% comes from the findings of the meta-analysis i have found on review of lipid-lowering med on trig & hdl:  https://doi.org/10.1136/bmj.38793.468449.AE (pdf in folder)
clonevar trigt_final = trig_final
replace trigt_final = trig_final * 1.15 if lipid_med_final ==1 & !missing(lipid_med_final)

***create adjusted hdl - decrease HDL by 5% (conservative estimate) of raw value for lipd med users (5% comes from the findings of the meta-analysis i have found on review of lipid-lowering med on trig & hdl:  https://doi.org/10.1136/bmj.38793.468449.AE (pdf in folder)
clonevar hdlt_final = hdl_final
replace hdlt_final = hdl_final * 0.95 if lipid_med_final ==1 & !missing(lipid_med_final)

sum sbp_final sbpt_final dbp_final dbpt_final hba1c_final hba1ct_final trig_final trigt_final hdl_final hdlt_final

***Regressions against the outcomes
gen ln_hdl_final= ln(hdl_final)
gen ln_trig_final= ln(trig_final)
gen ln_hba1c_final= ln(hba1c_final)
gen ln_hdlt_final= ln(hdlt_final)
gen ln_trigt_final= ln(trigt_final)
gen ln_hba1ct_final= ln(hba1ct_final)


*We decided to re-run the analysis with sympercents, i.e. instead of transforming the variables onto the ln scale, we transform to 100*ln(x). this means the differences can then be interpreted in terms of % difference, without
*having to do all of the back-transforming etc
clonevar ln_hdlt_final_v2 =ln_hdlt_final
replace ln_hdlt_final_v2= ln_hdlt_final*100
clonevar ln_trigt_final_v2 =ln_trigt_final
replace ln_trigt_final_v2= ln_trigt_final*100
clonevar ln_hba1ct_final_v2 =ln_hba1ct_final
replace ln_hba1ct_final_v2= ln_hba1ct_final*100
clonevar sbpt_final_v2 =sbpt_final
replace sbpt_final_v2= (ln(sbpt_final))*100
clonevar dbpt_final_v2 =dbpt_final
replace dbpt_final_v2= (ln(dbpt_final))*100


*****(18/6/20) RESPONSE TO REVIEWER COMMENTS*********************
merge m:1 NSHD_ID using "C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\v2\NSHD bwt and SEP"
capture: drop _merge
merge m:1 ncdsid using "C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1958 biomedical\time_severity_obese\v2\NCDS bwt eth.dta", update
capture: drop _merge
merge m:1 BCSID using "C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1970 biomedical\time_severity_obese\v2\BCS bwt eth.dta", update
capture: drop _merge
*SEP
rename ncdsid NCDSID
merge m:1 NCDSID using "C:\Users\pstn4\OneDrive - Loughborough University\LBORO WORK\BMI tracking\Data\SEP\NCDS\NCDS Harmonised ChildhoodSES.dta" , keepusing(NCDS2FCL)
capture: drop _merge
rename BCSID bcsid
merge m:1 bcsid using "C:\Users\pstn4\OneDrive - Loughborough University\LBORO WORK\BMI tracking\Data\SEP\BCS70\BCS70 Harmonised ChildhoodSES.dta", keepusing(BCS3FCL)
drop _merge

recode rgclass70 3.1=3 3.2=4 4=5 5=6 6=7
label drop RGCLASS7
label define rg70 1 "Professional" 2 "Intermediate" 3 "Skilled non-manual" 4 "Skilled-manual" 5 "Partly skilled manual" 6 "Unskilled manual" 7 "Armed forces"
label values rgclass70 rg70
tab rgclass70
recode rgclass70 7=.
*recode 23 people whose fathers in armed forces
wridit rgclass70 , gen( rgclass70_ridit)


recode NCDS2FCL 3.1=3 3.2=4 4=5 5=6 6=7 10=8 11=.
label drop  NCDS2FCL
label define ncds_child_sep 1 "Professional" 2 "Intermediate" 3 "Skilled non-manual" 4 "Skilled-manual" 5 "Partly skilled manual" 6 "Unskilled manual" 7 "not classifiable" 8 "no male head"
label values NCDS2FCL ncds_child_sep
tab NCDS2FCL
recode NCDS2FCL 7/8=.
*recode 714 people whose fathers occ not classificable or no father present
wridit NCDS2FCL , gen( NCDS2FCL_ridit)


*recoding childhod SEP based on fathers rgclass at age 10
recode BCS3FCL 3.1=3 3.2=4 4=5 5=6 6=7 11=.
label drop  BCS3FCL
label define bcs_child_sep 1 "Professional" 2 "Intermediate" 3 "Skilled non-manual" 4 "Skilled-manual" 5 "Partly skilled manual" 6 "Unskilled manual" 7 "not classifiable" 
label values BCS3FCL bcss_child_sep
tab BCS3FCL
recode BCS3FCL 7=.
*recode 556 people whose fathers occ not classificable 
wridit BCS3FCL , gen( BCS3FCL_ridit)

gen SEP_final=.
replace SEP_final= rgclass70_ridit if cohort==1
replace SEP_final= NCDS2FCL_ridit if cohort==2
replace SEP_final= BCS3FCL_ridit if cohort==3

clonevar eth_final=eth
replace eth_final=0 if cohort==1
keep if target_sample==1
save "C:\Users\pstn4\Dropbox\PLOS Med\dataset for imputation.dta", replace

*****************************COEFPLOTS******************************************
replace cat_dur_ob_5=0 if obese_yes==0
replace cat_auc30_5=0 if obese_yes==0
*doing these for these plots only so that we can see the effects relative to never obese. However, to test the trend of the cat vars, we will once again recode those never obese (obese_yes==0) as missing


**********************************UNADJUSTED************************************(suppl material)
****Duration
***SBP
regress sbpt_final_v2 i.obese_yes, vce(bootstrap, reps(200))
estimates store bin
tab obese_yes if e(sample)
regress sbpt_final_v2 i.cat_dur_ob_5_v2, vce(bootstrap, reps(200))
estimates store cat
tab cat_dur_ob_5_v2 if e(sample)
coefplot bin cat , mlcolor(none) mfcolor(gs7) drop(_cons) baselevels vertical xlab(none) xlabel(1 "Never Obese (ref)" 2 "Ever Obese" 4 "Never Obese (ref)" 5 "Obese<5 years" 6 "Obese 5-10 years" 7 "Obese 10-15 years" 8 "Obese 15-20 years" 9 "Obese 20-30 years", angle(45) labsize(tiny) add) order(_cons) ciopts(recast(rcap) lcolor(gs7)) graphregion(color(white) ) ylabel(, nogrid) yline(0, lcolor(black) lpattern(dash)) nokey offset(0) groups(?.obese_yes = "{bf:model 1}" ?.cat_dur_ob_5 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash)) ytitle("Change in Systolic blood pressure (mmHg)")   mlabel(cond(@pval<.001, "***", cond(@pval<.01, "**", cond(@pval<.05, "*", "")))) text(1.5 8.5 "{it:***=p{subscript:(diff)}}<0.001" "{it:p{subscript:(trend)}}=0.918", box fcolor(none) margin(small) justification(right) size(small)) saving("C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\sbp_dur_unadj.gph", replace)


/*local models ""
regress sbp_final ibn.obese_yes, noconstant
estimates store bin
regress sbp_final ibn.cat_dur_ob_5, noconstant
estimates store cat
local models `"`models' bin cat || "'
coefplot `models' , vertical xlab(none) xlabel(1 "Never Obese" 2 "Ever Obese" 4 "Obese<5 years" 5 "Obese 5-10 years" 6 "Obese 10-15 years" 7 "Obese 15-20 years" 8 "Obese 20-30 years", angle(45) labsize(tiny) add) order(_cons) ciopts(recast(rcap)) graphregion(color(white) ) ylabel(, nogrid) nokey offset(0) groups(?.obese_yes = "{bf:model 1}" ?.cat_dur_ob_5 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash)) ytitle("Systolic blood pressure (mmHg)") note("{it:p{subscript:(trend)}}=0.918", ring(0) position(4))
*/

***DBP
regress dbpt_final_v2 i.obese_yes, vce(bootstrap, reps(200))
estimates store bin
tab obese_yes if e(sample)
regress dbpt_final_v2 i.cat_dur_ob_5_v2, vce(bootstrap, reps(200))
estimates store cat
tab cat_dur_ob_5_v2 if e(sample)
coefplot bin cat , mlcolor(none) mfcolor(gs7) drop(_cons) baselevels vertical xlab(none) xlabel(1 "Never Obese (ref)" 2 "Ever Obese" 4 "Never Obese (ref)" 5 "Obese<5 years" 6 "Obese 5-10 years" 7 "Obese 10-15 years" 8 "Obese 15-20 years" 9 "Obese 20-30 years", angle(45) labsize(tiny) add) order(_cons) ciopts(recast(rcap) lcolor(gs7)) graphregion(color(white) ) ylabel(, nogrid) yline(0, lcolor(black) lpattern(dash)) nokey offset(0) groups(?.obese_yes = "{bf:model 1}" ?.cat_dur_ob_5 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash)) ytitle("Change in Diastolic blood pressure (mmHg)")   mlabel(cond(@pval<.001, "***", cond(@pval<.01, "**", cond(@pval<.05, "*", "")))) text(1.5 8.5 "{it:***=p{subscript:(diff)}}<0.001" "{it:p{subscript:(trend)}}=0.418", box fcolor(none) margin(small) justification(right) size(small)) saving("C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\dbp_dur_unadj.gph", replace)


/*local models ""
regress dbp_final ibn.obese_yes, noconstant
estimates store bin
regress dbp_final ibn.cat_dur_ob_5, noconstant
estimates store cat
local models `"`models' bin cat || "'
coefplot `models' , vertical xlab(none) xlabel(1 "Never Obese" 2 "Ever Obese" 4 "Obese<5 years" 5 "Obese 5-10 years" 6 "Obese 10-15 years" 7 "Obese 15-20 years" 8 "Obese 20-30 years", angle(45) labsize(tiny) add) order(_cons) ciopts(recast(rcap)) graphregion(color(white) ) ylabel(, nogrid) nokey offset(0) groups(?.obese_yes = "{bf:model 1}" ?.cat_dur_ob_5 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash)) ytitle("Diastolic blood pressure (mmHg)") note("{it:p{subscript:(trend)}}=0.418", ring(0) position(4))
*/

***HDL
regress ln_hdlt_final_v2 i.obese_yes, vce(bootstrap, reps(200))
estimates store bin
tab obese_yes if e(sample)
regress ln_hdlt_final_v2 i.cat_dur_ob_5_v2, vce(bootstrap, reps(200))
estimates store cat
tab cat_dur_ob_5_v2 if e(sample)
coefplot bin cat , mlcolor(none) mfcolor(gs7) drop(_cons) baselevels vertical xlab(none) xlabel(1 "Never Obese (ref)" 2 "Ever Obese" 4 "Never Obese (ref)" 5 "Obese<5 years" 6 "Obese 5-10 years" 7 "Obese 10-15 years" 8 "Obese 15-20 years" 9 "Obese 20-30 years", angle(45) labsize(tiny) add) order(_cons) ciopts(recast(rcap) lcolor(gs7)) graphregion(color(white) ) ylabel(, nogrid) yline(0, lcolor(black) lpattern(dash)) nokey offset(0) groups(?.obese_yes = "{bf:model 1}" ?.cat_dur_ob_5 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash)) ytitle("Change in ln(HDL-cholesterol)")   mlabel(cond(@pval<.001, "***", cond(@pval<.01, "**", cond(@pval<.05, "*", "")))) text(-0.05 8.5 "{it:***=p{subscript:(diff)}}<0.001" "{it:p{subscript:(trend)}}<0.001", box fcolor(none) margin(small) justification(right) size(small)) saving("C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\hdl_dur_unadj.gph", replace)


/*local models ""
regress ln_hdl_final ibn.obese_yes, noconstant
estimates store bin
regress ln_hdl_final ibn.cat_dur_ob_5, noconstant
estimates store cat
local models `"`models' bin cat || "'
coefplot `models' , vertical xlab(none) xlabel(1 "Never Obese" 2 "Ever Obese" 4 "Obese<5 years" 5 "Obese 5-10 years" 6 "Obese 10-15 years" 7 "Obese 15-20 years" 8 "Obese 20-30 years", angle(45) labsize(tiny) add) order(_cons) ciopts(recast(rcap)) graphregion(color(white) ) ylabel(, nogrid)  nokey offset(0) groups(?.obese_yes = "{bf:model 1}" ?.cat_dur_ob_5 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash)) ytitle("HDL-cholesterol (mmol/L)") note("{it:p{subscript:(trend)}}<0.001", ring(0) position(1))
*/


***Triglycerides
regress ln_trigt_final_v2 i.obese_yes, vce(bootstrap, reps(200))
estimates store bin
tab obese_yes if e(sample)
regress ln_trigt_final_v2 i.cat_dur_ob_5_v2, vce(bootstrap, reps(200))
estimates store cat
tab cat_dur_ob_5_v2 if e(sample)
coefplot bin cat , mlcolor(none) mfcolor(gs7) drop(_cons) baselevels vertical xlab(none) xlabel(1 "Never Obese (ref)" 2 "Ever Obese" 4 "Never Obese (ref)" 5 "Obese<5 years" 6 "Obese 5-10 years" 7 "Obese 10-15 years" 8 "Obese 15-20 years" 9 "Obese 20-30 years", angle(45) labsize(tiny) add) order(_cons) ciopts(recast(rcap) lcolor(gs7)) graphregion(color(white) ) ylabel(, nogrid) yline(0, lcolor(black) lpattern(dash)) nokey offset(0) groups(?.obese_yes = "{bf:model 1}" ?.cat_dur_ob_5 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash)) ytitle("Change in ln(Triglcerides)")   mlabel(cond(@pval<.001, "***", cond(@pval<.01, "**", cond(@pval<.05, "*", "")))) text(0.075 8.5 "{it:***=p{subscript:(diff)}}<0.001" "{it:p{subscript:(trend)}}=0.606", box fcolor(none) margin(small) justification(right) size(small)) saving("C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\trig_dur_unadj.gph", replace)


/*local models ""
regress ln_trig_final ibn.obese_yes, noconstant
estimates store bin
regress ln_trig_final ibn.cat_dur_ob_5, noconstant
estimates store cat
local models `"`models' bin cat || "'
coefplot `models' , vertical xlab(none) xlabel(1 "Never Obese" 2 "Ever Obese" 4 "Obese<5 years" 5 "Obese 5-10 years" 6 "Obese 10-15 years" 7 "Obese 15-20 years" 8 "Obese 20-30 years", angle(45) labsize(tiny) add) order(_cons) ciopts(recast(rcap)) graphregion(color(white) ) ylabel(, nogrid) eform nokey offset(0) groups(?.obese_yes = "{bf:model 1}" ?.cat_dur_ob_5 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash)) ytitle("Triglycerides (mmol/L)") note("{it:p{subscript:(trend)}}=0.606", ring(0) position(4))
*/


***HbA1c
regress ln_hba1ct_final_v2 i.obese_yes, vce(bootstrap, reps(200))
estimates store bin
tab obese_yes if e(sample)
regress ln_hba1ct_final_v2 i.cat_dur_ob_5_v2, vce(bootstrap, reps(200))
estimates store cat
tab cat_dur_ob_5_v2 if e(sample)
coefplot bin cat , mlcolor(none) mfcolor(gs7) drop(_cons) baselevels vertical xlab(none) xlabel(1 "Never Obese (ref)" 2 "Ever Obese" 4 "Never Obese (ref)" 5 "Obese<5 years" 6 "Obese 5-10 years" 7 "Obese 10-15 years" 8 "Obese 15-20 years" 9 "Obese 20-30 years", angle(45) labsize(tiny) add) order(_cons) ciopts(recast(rcap) lcolor(gs7)) graphregion(color(white) ) ylabel(, nogrid) yline(0, lcolor(black) lpattern(dash)) nokey offset(0) groups(?.obese_yes = "{bf:model 1}" ?.cat_dur_ob_5 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash)) ytitle("Change in ln(HbA1c)")   mlabel(cond(@pval<.001, "***", cond(@pval<.01, "**", cond(@pval<.05, "*", "")))) text(0.025 8.5 "{it:***=p{subscript:(diff)}}<0.001" "{it:p{subscript:(trend)}}<0.001", box fcolor(none) margin(small) justification(right) size(small)) saving("C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\hba1c_dur_unadj.gph", replace)


/*local models ""
regress ln_hba1c_final ibn.obese_yes, noconstant
estimates store bin
regress ln_hba1c_final ibn.cat_dur_ob_5, noconstant
estimates store cat
local models `"`models' bin cat || "'
coefplot `models' , vertical xlab(none) xlabel(1 "Never Obese" 2 "Ever Obese" 4 "Obese<5 years" 5 "Obese 5-10 years" 6 "Obese 10-15 years" 7 "Obese 15-20 years" 8 "Obese 20-30 years", angle(45) labsize(tiny) add) order(_cons) ciopts(recast(rcap)) graphregion(color(white) ) ylabel(, nogrid) eform nokey offset(0) groups(?.obese_yes = "{bf:model 1}" ?.cat_dur_ob_5 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash)) ytitle("HbA1c (%)") note("{it:p{subscript:(trend)}}<0.001", ring(0) position(4))
*/

/****AUC
***SBP
regress sbp_final i.obese_yes
estimates store bin
regress sbp_final i.cat_auc30_5
estimates store cat
coefplot bin cat , mlcolor(gs7) mfcolor(white) drop(_cons) baselevels vertical xlab(none) xlabel(1 "Never Obese (ref)" 2 "Ever Obese" 4 "Never Obese (ref)" 5 "Category 1 obesity severity" 6 "Category 2 obesity severity" 7 "Category 3 obesity severity" 8 "Category 4 obesity severity" 9 "Category 5 obesity severity", angle(45) labsize(tiny) add) order(_cons) ciopts(recast(rcap) lcolor(gs7)) graphregion(color(white) ) ylabel(, nogrid) yline(0, lcolor(black) lpattern(dash)) nokey offset(0) groups(?.obese_yes = "{bf:model 1}" ?.cat_auc30_5 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash)) ytitle("Change in Systolic blood pressure (mmHg)")   mlabel(cond(@pval<.001, "***", cond(@pval<.01, "**", cond(@pval<.05, "*", "")))) text(1.5 8.5 "{it:***=p{subscript:(diff)}}<0.001" "{it:p{subscript:(trend)}}=0.931", box fcolor(none) margin(small) justification(right) size(small)) saving("C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\sbp_auc_unadj.gph", replace)


***DBP
regress dbp_final i.obese_yes
estimates store bin
regress dbp_final i.cat_auc30_5
estimates store cat
coefplot bin cat , mlcolor(none) mfcolor(white) drop(_cons) baselevels vertical xlab(none) xlabel(1 "Never Obese (ref)" 2 "Ever Obese" 4 "Never Obese (ref)" 5 "Category 1 obesity severity" 6 "Category 2 obesity severity" 7 "Category 3 obesity severity" 8 "Category 4 obesity severity" 9 "Category 5 obesity severity", angle(45) labsize(tiny) add) order(_cons) ciopts(recast(rcap) lcolor(gs7)) graphregion(color(white) ) ylabel(, nogrid) yline(0, lcolor(black) lpattern(dash)) nokey offset(0) groups(?.obese_yes = "{bf:model 1}" ?.cat_auc30_5 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash)) ytitle("Change in Diastolic blood pressure (mmHg)")   mlabel(cond(@pval<.001, "***", cond(@pval<.01, "**", cond(@pval<.05, "*", "")))) text(1.5 8.5 "{it:***=p{subscript:(diff)}}<0.001" "{it:p{subscript:(trend)}}=0.437", box fcolor(none) margin(small) justification(right) size(small)) saving("C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\dbp_auc_unadj.gph", replace)


***HDL
regress ln_hdl_final i.obese_yes
estimates store bin
regress ln_hdl_final i.cat_auc30_5
estimates store cat
coefplot bin cat , mlcolor(none) mfcolor(white) drop(_cons) baselevels vertical xlab(none) xlabel(1 "Never Obese (ref)" 2 "Ever Obese" 4 "Never Obese (ref)" 5 "Category 1 obesity severity" 6 "Category 2 obesity severity" 7 "Category 3 obesity severity" 8 "Category 4 obesity severity" 9 "Category 5 obesity severity", angle(45) labsize(tiny) add) order(_cons) ciopts(recast(rcap) lcolor(gs7)) graphregion(color(white) ) ylabel(, nogrid) yline(0, lcolor(black) lpattern(dash)) nokey offset(0) groups(?.obese_yes = "{bf:model 1}" ?.cat_auc30_5 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash)) ytitle("Change in ln(HDL-cholesterol)")   mlabel(cond(@pval<.001, "***", cond(@pval<.01, "**", cond(@pval<.05, "*", "")))) text(-0.05 8.5 "{it:***=p{subscript:(diff)}}<0.001" "{it:p{subscript:(trend)}}<0.001", box fcolor(none) margin(small) justification(right) size(small)) saving("C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\hdl_auc_unadj.gph", replace)


***Triglycerides
regress ln_trig_final i.obese_yes
estimates store bin
regress ln_trig_final i.cat_auc30_5
estimates store cat
coefplot bin cat , mlcolor(none) mfcolor(white) drop(_cons) baselevels vertical xlab(none) xlabel(1 "Never Obese (ref)" 2 "Ever Obese" 4 "Never Obese (ref)" 5 "Category 1 obesity severity" 6 "Category 2 obesity severity" 7 "Category 3 obesity severity" 8 "Category 4 obesity severity" 9 "Category 5 obesity severity", angle(45) labsize(tiny) add) order(_cons) ciopts(recast(rcap) lcolor(gs7)) graphregion(color(white) ) ylabel(, nogrid) yline(0, lcolor(black) lpattern(dash)) nokey offset(0) groups(?.obese_yes = "{bf:model 1}" ?.cat_auc30_5 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash)) ytitle("Change in ln(Triglcerides)")   mlabel(cond(@pval<.001, "***", cond(@pval<.01, "**", cond(@pval<.05, "*", "")))) text(0.075 8.5 "{it:***=p{subscript:(diff)}}<0.001" "{it:p{subscript:(trend)}}=0.592", box fcolor(none) margin(small) justification(right) size(small)) saving("C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\trig_auc_unadj.gph", replace)


***HbA1c
regress ln_hba1c_final i.obese_yes
estimates store bin
regress ln_hba1c_final i.cat_auc30_5
estimates store cat
coefplot bin cat , mlcolor(none) mfcolor(white) drop(_cons) baselevels vertical xlab(none) xlabel(1 "Never Obese (ref)" 2 "Ever Obese" 4 "Never Obese (ref)" 5 "Category 1 obesity severity" 6 "Category 2 obesity severity" 7 "Category 3 obesity severity" 8 "Category 4 obesity severity" 9 "Category 5 obesity severity", angle(45) labsize(tiny) add) order(_cons) ciopts(recast(rcap) lcolor(gs7)) graphregion(color(white) ) ylabel(, nogrid) yline(0, lcolor(black) lpattern(dash)) nokey offset(0) groups(?.obese_yes = "{bf:model 1}" ?.cat_auc30_5 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash)) ytitle("Change in ln(HbA1c)")   mlabel(cond(@pval<.001, "***", cond(@pval<.01, "**", cond(@pval<.05, "*", "")))) text(0.025 8.5 "{it:***=p{subscript:(diff)}}<0.001" "{it:p{subscript:(trend)}}<0.001", box fcolor(none) margin(small) justification(right) size(small)) saving("C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\hba1c_auc_unadj.gph", replace)

*/

*****TESTPARM (to test the categorical variable, thus now looking at the change in the coefs relative to cat==1)
replace cat_dur_ob_5_v2=. if obese_yes==0
replace cat_auc30_5=. if obese_yes==0

foreach y in sbp_final dbp_final ln_hdl ln_trig ln_hba1c {
	regress `y' i.cat_dur_ob_5_v2
	testparm i.cat_dur_ob_5_v2
	tab cat_dur_ob_5_v2 if e(sample)
}

***OR
replace cat_dur_ob_5_v2=. if obese_yes==0
regress sbpt_final_v2 cat_dur_ob_5_v2 , vce(bootstrap, rep(200))
regress dbpt_final_v2 cat_dur_ob_5_v2 , vce(bootstrap, rep(200))
regress ln_hdlt_final_v2 cat_dur_ob_5_v2 , vce(bootstrap, rep(200))
regress ln_trigt_final_v2 cat_dur_ob_5_v2 , vce(bootstrap, rep(200))
regress ln_hba1ct_final_v2 cat_dur_ob_5_v2 , vce(bootstrap, rep(200))

***********************************ADJUSTED**************************************(Table 3)
replace cat_dur_ob_5_v2=0 if obese_yes==0
replace cat_auc30_5=0 if obese_yes==0

****Duration
***SBP
regress sbpt_final_v2 i.obese_yes sex i.cohort age_follow_up_final 
estimates store bin
tab obese_yes if e(sample)
regress sbpt_final_v2 i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final 
estimates store cat
tab cat_dur_ob_5_v2 if e(sample)
coefplot bin cat , mfcolor(gs7) mlcolor(gs7) drop(_cons sex1 1.cohort 2.cohort 3.cohort age_follow_up_final ) baselevels vertical xlab(none) xlabel(1 "Never Obese (ref)" 2 "Ever Obese" 4 "Never Obese (ref)" 5 "Obese<5 years" 6 "Obese 5-10 years" 7 "Obese 10-15 years" 8 "Obese 15-20 years" 9 "Obese 20-30 years", angle(45) labsize(tiny) add) order(_cons) ciopts(recast(rcap) lcolor(gs7)) graphregion(color(white) ) ylabel(, nogrid) yline(0, lcolor(black) lpattern(dash)) nokey offset(0) groups(?.obese_yes = "{bf:model 1}" ?.cat_dur_ob_5 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash)) ytitle("Change in Systolic blood pressure (mmHg)")   mlabel(cond(@pval<.001, "***", cond(@pval<.01, "**", cond(@pval<.05, "*", "")))) text(1.5 8.5 "{it:***=p{subscript:(diff)}}<0.001" "{it:p{subscript:(trend)}}=0.698", box fcolor(none) margin(small) justification(right) size(small)) saving("C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\sbp_dur_adj.gph", replace)


/*local models ""
regress sbp_final ibn.obese_yes, noconstant
estimates store bin
regress sbp_final ibn.cat_dur_ob_5, noconstant
estimates store cat
local models `"`models' bin cat || "'
coefplot `models' , vertical xlab(none) xlabel(1 "Never Obese" 2 "Ever Obese" 4 "Obese<5 years" 5 "Obese 5-10 years" 6 "Obese 10-15 years" 7 "Obese 15-20 years" 8 "Obese 20-30 years", angle(45) labsize(tiny) add) order(_cons) ciopts(recast(rcap)) graphregion(color(white) ) ylabel(, nogrid) nokey offset(0) groups(?.obese_yes = "{bf:model 1}" ?.cat_dur_ob_5 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash)) ytitle("Systolic blood pressure (mmHg)") note("{it:p{subscript:(trend)}}=0.918", ring(0) position(4))
*/

***DBP
regress dbpt_final_v2 i.obese_yes sex i.cohort age_follow_up_final 
estimates store bin
tab obese_yes if e(sample)
regress dbpt_final_v2 i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final 
estimates store cat
tab cat_dur_ob_5_v2 if e(sample)
coefplot bin cat , mfcolor(gs7) mlcolor(gs7) drop(_cons sex1 1.cohort 2.cohort 3.cohort age_follow_up_final ) baselevels vertical xlab(none) xlabel(1 "Never Obese (ref)" 2 "Ever Obese" 4 "Never Obese (ref)" 5 "Obese<5 years" 6 "Obese 5-10 years" 7 "Obese 10-15 years" 8 "Obese 15-20 years" 9 "Obese 20-30 years", angle(45) labsize(tiny) add) order(_cons) ciopts(recast(rcap) lcolor(gs7)) graphregion(color(white) ) ylabel(, nogrid) yline(0, lcolor(black) lpattern(dash)) nokey offset(0) groups(?.obese_yes = "{bf:model 1}" ?.cat_dur_ob_5 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash)) ytitle("Change in Diastolic blood pressure (mmHg)")   mlabel(cond(@pval<.001, "***", cond(@pval<.01, "**", cond(@pval<.05, "*", "")))) text(1.5 8.5 "{it:***=p{subscript:(diff)}}<0.001" "{it:p{subscript:(trend)}}=0.303", box fcolor(none) margin(small) justification(right) size(small)) saving("C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\dbp_dur_adj.gph", replace)


/*local models ""
regress dbp_final ibn.obese_yes, noconstant
estimates store bin
regress dbp_final ibn.cat_dur_ob_5, noconstant
estimates store cat
local models `"`models' bin cat || "'
coefplot `models' , vertical xlab(none) xlabel(1 "Never Obese" 2 "Ever Obese" 4 "Obese<5 years" 5 "Obese 5-10 years" 6 "Obese 10-15 years" 7 "Obese 15-20 years" 8 "Obese 20-30 years", angle(45) labsize(tiny) add) order(_cons) ciopts(recast(rcap)) graphregion(color(white) ) ylabel(, nogrid) nokey offset(0) groups(?.obese_yes = "{bf:model 1}" ?.cat_dur_ob_5 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash)) ytitle("Diastolic blood pressure (mmHg)") note("{it:p{subscript:(trend)}}=0.418", ring(0) position(4))
*/

***HDL
regress ln_hdlt_final_v2 i.obese_yes sex i.cohort age_follow_up_final 
estimates store bin
tab obese_yes if e(sample)
regress ln_hdlt_final_v2 i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final 
estimates store cat
tab cat_dur_ob_5_v2 if e(sample)
coefplot bin cat , mfcolor(gs7) mlcolor(gs7) drop(_cons sex1 1.cohort 2.cohort 3.cohort age_follow_up_final ) baselevels vertical xlab(none) xlabel(1 "Never Obese (ref)" 2 "Ever Obese" 4 "Never Obese (ref)" 5 "Obese<5 years" 6 "Obese 5-10 years" 7 "Obese 10-15 years" 8 "Obese 15-20 years" 9 "Obese 20-30 years", angle(45) labsize(tiny) add) order(_cons) ciopts(recast(rcap) lcolor(gs7)) graphregion(color(white) ) ylabel(, nogrid) yline(0, lcolor(black) lpattern(dash)) nokey offset(0) groups(?.obese_yes = "{bf:model 1}" ?.cat_dur_ob_5 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash)) ytitle("Change in ln(HDL-cholesterol)")   mlabel(cond(@pval<.001, "***", cond(@pval<.01, "**", cond(@pval<.05, "*", "")))) text(-0.05 8.5 "{it:***=p{subscript:(diff)}}<0.001" "{it:p{subscript:(trend)}}<0.001", box fcolor(none) margin(small) justification(right) size(small)) saving("C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\hdl_dur_adj.gph", replace)


/*local models ""
regress ln_hdl_final ibn.obese_yes, noconstant
estimates store bin
regress ln_hdl_final ibn.cat_dur_ob_5, noconstant
estimates store cat
local models `"`models' bin cat || "'
coefplot `models' , vertical xlab(none) xlabel(1 "Never Obese" 2 "Ever Obese" 4 "Obese<5 years" 5 "Obese 5-10 years" 6 "Obese 10-15 years" 7 "Obese 15-20 years" 8 "Obese 20-30 years", angle(45) labsize(tiny) add) order(_cons) ciopts(recast(rcap)) graphregion(color(white) ) ylabel(, nogrid)  nokey offset(0) groups(?.obese_yes = "{bf:model 1}" ?.cat_dur_ob_5 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash)) ytitle("HDL-cholesterol (mmol/L)") note("{it:p{subscript:(trend)}}<0.001", ring(0) position(1))
*/


***Triglycerides
regress ln_trigt_final_v2 i.obese_yes sex i.cohort age_follow_up_final 
estimates store bin
tab obese_yes if e(sample)
regress ln_trigt_final_v2 i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final 
estimates store cat
tab cat_dur_ob_5_v2 if e(sample)
coefplot bin cat , mfcolor(gs7) mlcolor(gs7) drop(_cons sex1 1.cohort 2.cohort 3.cohort age_follow_up_final ) baselevels vertical xlab(none) xlabel(1 "Never Obese (ref)" 2 "Ever Obese" 4 "Never Obese (ref)" 5 "Obese<5 years" 6 "Obese 5-10 years" 7 "Obese 10-15 years" 8 "Obese 15-20 years" 9 "Obese 20-30 years", angle(45) labsize(tiny) add) order(_cons) ciopts(recast(rcap) lcolor(gs7)) graphregion(color(white) ) ylabel(, nogrid) yline(0, lcolor(black) lpattern(dash)) nokey offset(0) groups(?.obese_yes = "{bf:model 1}" ?.cat_dur_ob_5 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash)) ytitle("Change in ln(Triglcerides)")   mlabel(cond(@pval<.001, "***", cond(@pval<.01, "**", cond(@pval<.05, "*", "")))) text(0.075 8.5 "{it:***=p{subscript:(diff)}}<0.001" "{it:p{subscript:(trend)}}=0.391", box fcolor(none) margin(small) justification(right) size(small)) saving("C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\trig_dur_adj.gph", replace)


/*local models ""
regress ln_trig_final ibn.obese_yes, noconstant
estimates store bin
regress ln_trig_final ibn.cat_dur_ob_5, noconstant
estimates store cat
local models `"`models' bin cat || "'
coefplot `models' , vertical xlab(none) xlabel(1 "Never Obese" 2 "Ever Obese" 4 "Obese<5 years" 5 "Obese 5-10 years" 6 "Obese 10-15 years" 7 "Obese 15-20 years" 8 "Obese 20-30 years", angle(45) labsize(tiny) add) order(_cons) ciopts(recast(rcap)) graphregion(color(white) ) ylabel(, nogrid) eform nokey offset(0) groups(?.obese_yes = "{bf:model 1}" ?.cat_dur_ob_5 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash)) ytitle("Triglycerides (mmol/L)") note("{it:p{subscript:(trend)}}=0.606", ring(0) position(4))
*/


***HbA1c
regress ln_hba1ct_final_v2 i.obese_yes sex i.cohort age_follow_up_final 
estimates store bin
tab obese_yes if e(sample)
regress ln_hba1ct_final_v2 i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final 
estimates store cat
tab cat_dur_ob_5_v2 if e(sample)
coefplot bin cat , mfcolor(gs7) mlcolor(gs7) drop(_cons sex1 1.cohort 2.cohort 3.cohort age_follow_up_final ) baselevels vertical xlab(none) xlabel(1 "Never Obese (ref)" 2 "Ever Obese" 4 "Never Obese (ref)" 5 "Obese<5 years" 6 "Obese 5-10 years" 7 "Obese 10-15 years" 8 "Obese 15-20 years" 9 "Obese 20-30 years", angle(45) labsize(tiny) add) order(_cons) ciopts(recast(rcap) lcolor(gs7)) graphregion(color(white) ) ylabel(, nogrid) yline(0, lcolor(black) lpattern(dash)) nokey offset(0) groups(?.obese_yes = "{bf:model 1}" ?.cat_dur_ob_5 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash)) ytitle("Change in ln(HbA1c)")   mlabel(cond(@pval<.001, "***", cond(@pval<.01, "**", cond(@pval<.05, "*", "")))) text(0.025 8.5 "{it:***=p{subscript:(diff)}}<0.001" "{it:p{subscript:(trend)}}<0.001", box fcolor(none) margin(small) justification(right) size(small)) saving("C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\hba1c_dur_adj.gph", replace)


/*local models ""
regress ln_hba1c_final ibn.obese_yes, noconstant
estimates store bin
regress ln_hba1c_final ibn.cat_dur_ob_5, noconstant
estimates store cat
local models `"`models' bin cat || "'
coefplot `models' , vertical xlab(none) xlabel(1 "Never Obese" 2 "Ever Obese" 4 "Obese<5 years" 5 "Obese 5-10 years" 6 "Obese 10-15 years" 7 "Obese 15-20 years" 8 "Obese 20-30 years", angle(45) labsize(tiny) add) order(_cons) ciopts(recast(rcap)) graphregion(color(white) ) ylabel(, nogrid) eform nokey offset(0) groups(?.obese_yes = "{bf:model 1}" ?.cat_dur_ob_5 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash)) ytitle("HbA1c (%)") note("{it:p{subscript:(trend)}}<0.001", ring(0) position(4))
*/

/****AUC
***SBP
regress sbp_final i.obese_yes sex i.cohort age_follow_up_final medication_final
estimates store bin
regress sbp_final i.cat_auc30_5 sex i.cohort age_follow_up_final medication_final
estimates store cat
coefplot bin cat , mfcolor(gs7) mlcolor(gs7) drop(_cons sex1 1.cohort 2.cohort 3.cohort age_follow_up_final medication_final) baselevels vertical xlab(none) xlabel(1 "Never Obese (ref)" 2 "Ever Obese" 4 "Never Obese (ref)" 5 "Category 1 obesity severity" 6 "Category 2 obesity severity" 7 "Category 3 obesity severity" 8 "Category 4 obesity severity" 9 "Category 5 obesity severity", angle(45) labsize(tiny) add) order(_cons) ciopts(recast(rcap) lcolor(gs7)) graphregion(color(white) ) ylabel(, nogrid) yline(0, lcolor(black) lpattern(dash)) nokey offset(0) groups(?.obese_yes = "{bf:model 1}" ?.cat_auc30_5 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash)) ytitle("Change in Systolic blood pressure (mmHg)")   mlabel(cond(@pval<.001, "***", cond(@pval<.01, "**", cond(@pval<.05, "*", "")))) text(1.5 8.5 "{it:***=p{subscript:(diff)}}<0.001" "{it:p{subscript:(trend)}}=0.222", box fcolor(none) margin(small) justification(right) size(small)) saving("C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\sbp_auc_adj.gph", replace)


***DBP
regress dbp_final i.obese_yes sex i.cohort age_follow_up_final medication_final
estimates store bin
regress dbp_final i.cat_auc30_5 sex i.cohort age_follow_up_final medication_final
estimates store cat
coefplot bin cat , mfcolor(gs7) mlcolor(gs7) drop(_cons sex1 1.cohort 2.cohort 3.cohort age_follow_up_final medication_final) baselevels vertical xlab(none) xlabel(1 "Never Obese (ref)" 2 "Ever Obese" 4 "Never Obese (ref)" 5 "Category 1 obesity severity" 6 "Category 2 obesity severity" 7 "Category 3 obesity severity" 8 "Category 4 obesity severity" 9 "Category 5 obesity severity", angle(45) labsize(tiny) add) order(_cons) ciopts(recast(rcap) lcolor(gs7)) graphregion(color(white) ) ylabel(, nogrid) yline(0, lcolor(black) lpattern(dash)) nokey offset(0) groups(?.obese_yes = "{bf:model 1}" ?.cat_auc30_5 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash)) ytitle("Change in Diastolic blood pressure (mmHg)")   mlabel(cond(@pval<.001, "***", cond(@pval<.01, "**", cond(@pval<.05, "*", "")))) text(1.5 8.5 "{it:***=p{subscript:(diff)}}<0.001" "{it:p{subscript:(trend)}}=0.088", box fcolor(none) margin(small) justification(right) size(small)) saving("C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\dbp_auc_adj.gph", replace)


***HDL
regress ln_hdl_final i.obese_yes sex i.cohort age_follow_up_final medication_final
estimates store bin
regress ln_hdl_final i.cat_auc30_5 sex i.cohort age_follow_up_final medication_final
estimates store cat
coefplot bin cat , mfcolor(gs7) mlcolor(gs7) drop(_cons sex1 1.cohort 2.cohort 3.cohort age_follow_up_final medication_final) baselevels vertical xlab(none) xlabel(1 "Never Obese (ref)" 2 "Ever Obese" 4 "Never Obese (ref)" 5 "Category 1 obesity severity" 6 "Category 2 obesity severity" 7 "Category 3 obesity severity" 8 "Category 4 obesity severity" 9 "Category 5 obesity severity", angle(45) labsize(tiny) add) order(_cons) ciopts(recast(rcap) lcolor(gs7)) graphregion(color(white) ) ylabel(, nogrid) yline(0, lcolor(black) lpattern(dash)) nokey offset(0) groups(?.obese_yes = "{bf:model 1}" ?.cat_auc30_5 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash)) ytitle("Change in ln(HDL-cholesterol)")   mlabel(cond(@pval<.001, "***", cond(@pval<.01, "**", cond(@pval<.05, "*", "")))) text(-0.05 8.5 "{it:***=p{subscript:(diff)}}<0.001" "{it:p{subscript:(trend)}}<0.001", box fcolor(none) margin(small) justification(right) size(small)) saving("C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\hdl_auc_adj.gph", replace)


***Triglycerides
regress ln_trig_final i.obese_yes sex i.cohort age_follow_up_final medication_final
estimates store bin
regress ln_trig_final i.cat_auc30_5 sex i.cohort age_follow_up_final medication_final
estimates store cat
coefplot bin cat , mfcolor(gs7) mlcolor(gs7) drop(_cons sex1 1.cohort 2.cohort 3.cohort age_follow_up_final medication_final) baselevels vertical xlab(none) xlabel(1 "Never Obese (ref)" 2 "Ever Obese" 4 "Never Obese (ref)" 5 "Category 1 obesity severity" 6 "Category 2 obesity severity" 7 "Category 3 obesity severity" 8 "Category 4 obesity severity" 9 "Category 5 obesity severity", angle(45) labsize(tiny) add) order(_cons) ciopts(recast(rcap) lcolor(gs7)) graphregion(color(white) ) ylabel(, nogrid) yline(0, lcolor(black) lpattern(dash)) nokey offset(0) groups(?.obese_yes = "{bf:model 1}" ?.cat_auc30_5 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash)) ytitle("Change in ln(Triglcerides)")   mlabel(cond(@pval<.001, "***", cond(@pval<.01, "**", cond(@pval<.05, "*", "")))) text(0.075 8.5 "{it:***=p{subscript:(diff)}}<0.001" "{it:p{subscript:(trend)}}=0.245", box fcolor(none) margin(small) justification(right) size(small)) saving("C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\trig_auc_adj.gph", replace)


***HbA1c
regress ln_hba1c_final i.obese_yes sex i.cohort age_follow_up_final medication_final
estimates store bin
regress ln_hba1c_final i.cat_auc30_5 sex i.cohort age_follow_up_final medication_final
estimates store cat
coefplot bin cat , mfcolor(gs7) mlcolor(gs7) drop(_cons sex1 1.cohort 2.cohort 3.cohort age_follow_up_final medication_final) baselevels vertical xlab(none) xlabel(1 "Never Obese (ref)" 2 "Ever Obese" 4 "Never Obese (ref)" 5 "Category 1 obesity severity" 6 "Category 2 obesity severity" 7 "Category 3 obesity severity" 8 "Category 4 obesity severity" 9 "Category 5 obesity severity", angle(45) labsize(tiny) add) order(_cons) ciopts(recast(rcap) lcolor(gs7)) graphregion(color(white) ) ylabel(, nogrid) yline(0, lcolor(black) lpattern(dash)) nokey offset(0) groups(?.obese_yes = "{bf:model 1}" ?.cat_auc30_5 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash)) ytitle("Change in ln(HbA1c)")   mlabel(cond(@pval<.001, "***", cond(@pval<.01, "**", cond(@pval<.05, "*", "")))) text(0.025 8.5 "{it:***=p{subscript:(diff)}}<0.001" "{it:p{subscript:(trend)}}<0.001", box fcolor(none) margin(small) justification(right) size(small)) saving("C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\hba1c_auc_adj.gph", replace)

*/

***TESTPARM
replace cat_dur_ob_5_v2=. if obese_yes==0
replace cat_auc30_5=. if obese_yes==0
foreach y in sbpt_final_v2 dbpt_final_v2 ln_hdlt_final_v2 ln_trigt_final_v2 ln_hba1ct_final_v2 {
    regress `y' i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final 
	testparm i.cat_dur_ob_5_v2
	tab cat_dur_ob_5_v2 if e(sample)
}



*****************************ADJUSTED FOR EACHOTHER*****************************
replace cat_dur_ob_5_v2=0 if obese_yes==0
replace cat_auc30_5_v2=0 if obese_yes==0

***SBP
/*
regress sbpt_final_v2 i.obese_yes sex i.cohort age_follow_up_final  
estimates store bin1
regress sbpt_final_v2 i.obese_yes sex i.cohort age_follow_up_final  auc30_adj
estimates store bin2
tab obese_yes if e(sample)
regress sbpt_final_v2 i.cat_dur_ob_5 sex i.cohort age_follow_up_final  
estimates store cat1
regress sbpt_final_v2 i.cat_dur_ob_5 sex i.cohort age_follow_up_final  auc30_adj
estimates store cat2
coefplot (bin1, keep(0.obese_yes 1.obese_yes) msymbol(S)mfcolor(gs7) offset(-0.1)) (bin2, keep(0.obese_yes 1.obese_yes) msymbol(S) offset(0.1)) (cat1, keep(0.cat_dur_ob_5 1.cat_dur_ob_5 2.cat_dur_ob_5 3.cat_dur_ob_5 4.cat_dur_ob_5 5.cat_dur_ob_5) mfcolor(gs7) offset(-0.1)) (cat2, keep(0.cat_dur_ob_5 1.cat_dur_ob_5 2.cat_dur_ob_5 3.cat_dur_ob_5 4.cat_dur_ob_5 5.cat_dur_ob_5) offset(0.1) ) , legend(order(1 2) label(1 domestic) label(2 foreign)) mfcolor(white) mlcolor(gs7) drop(_cons sex1 1.cohort 2.cohort 3.cohort age_follow_up_final ) baselevels vertical xlab(none) xlabel(1 "Never Obese (ref)" 2 "Ever Obese" 4 "Never Obese (ref)" 5 "Obese<3.8 years" 6 "Obese 3.8-7.4 years" 7 "Obese 7.4-11.1 years" 8 "Obese 11.1-15.7 years" 9 "Obese 15.7-30 years" , angle(45) labsize(tiny) add) order(_cons) ciopts(recast(rcap) col(gs7)) graphregion(color(white) ) ylabel(, nogrid) yline(0, lcolor(black) lpattern(dash)) nokey  groups(?.obese_yes = "{bf:model 1}" ?.cat_dur_ob_5 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash))  ytitle("Percentage change in Systolic blood pressure")  saving("C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\sbp_mut_adj.gph", replace)
//text(15 14.5 "{it:***=p{subscript:(diff)}}<0.001" "{it:**=p{subscript:(diff)}}<0.01" "{it:*=p{subscript:(diff)}}<0.05" "{it:p{subscript:(duration trend)}}=0.551" "{it:p{subscript:(severity trend)}}=0.162", box fcolor(none) margin(small) justification(right) size(small))
*add above exactly if want to indicate significance
*/


regress sbpt_final_v2 i.obese_yes sex i.cohort age_follow_up_final, vce(bootstrap, reps(200))
estimates store bin1
tab obese_yes if e(sample)
regress sbpt_final_v2 i.obese_yes sex i.cohort age_follow_up_final  auc30_adj, vce(bootstrap, reps(200))
estimates store bin2
tab obese_yes if e(sample)
regress sbpt_final_v2 i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final, vce(bootstrap, reps(200))
estimates store cat1
tab cat_dur_ob_5_v2 if e(sample)
regress sbpt_final_v2 i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final  auc30_adj, vce(bootstrap, reps(200))
estimates store cat2
tab cat_dur_ob_5_v2 if e(sample)
coefplot (bin1, keep(0.obese_yes 1.obese_yes) msymbol(S)mfcolor(gs7) offset(-0.1)) (bin2, keep(0.obese_yes 1.obese_yes) msymbol(S) offset(0.1)) (cat1, keep(0.cat_dur_ob_5_v2 1.cat_dur_ob_5_v2 2.cat_dur_ob_5_v2 3.cat_dur_ob_5_v2 4.cat_dur_ob_5_v2 5.cat_dur_ob_5_v2) mfcolor(gs7) offset(-0.1)) (cat2, keep(0.cat_dur_ob_5_v2 1.cat_dur_ob_5_v2 2.cat_dur_ob_5_v2 3.cat_dur_ob_5_v2 4.cat_dur_ob_5_v2 5.cat_dur_ob_5_v2) offset(0.1) ) , mfcolor(white) mlcolor(gs7) drop(_cons sex1 1.cohort 2.cohort 3.cohort age_follow_up_final ) baselevels vertical xlab(none) xlabel(1 "Never Obese (ref)" 2 "Ever Obese" 4 "Never Obese (ref)" 5 "Obese<5 years" 6 "Obese 5-9.99 years" 7 "Obese 10-14.99 years" 8 "Obese 15-19.99 years" 9 "Obese 20-30 years" , angle(45) labsize(small) add) order(_cons) ciopts(recast(rcap) col(gs7)) graphregion(color(white) ) ylabel(, nogrid) yline(0, lcolor(black) lpattern(dash)) nokey  groups(?.obese_yes = "{bf:model 1}" ?.cat_dur_ob_5_v2 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash)) yscale(range(0 30)) ylabel( 0 (5) 30) ytitle("Percentage change in SBP", size(small))    saving("C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\sbp_mut_adj_v2.gph", replace)
//text(15 14.5 "{it:***=p{subscript:(diff)}}<0.001" "{it:**=p{subscript:(diff)}}<0.01" "{it:*=p{subscript:(diff)}}<0.05" "{it:p{subscript:(duration trend)}}=0.551" "{it:p{subscript:(severity trend)}}=0.162", box fcolor(none) margin(small) justification(right) size(small))

***DBP
/*
regress dbpt_final_v2 i.obese_yes sex i.cohort age_follow_up_final  
estimates store bin1
regress dbpt_final_v2 i.obese_yes sex i.cohort age_follow_up_final  auc30_adj
estimates store bin2
tab obese_yes if e(sample)
regress dbpt_final_v2 i.cat_dur_ob_5 sex i.cohort age_follow_up_final  
estimates store cat1
regress dbpt_final_v2 i.cat_dur_ob_5 sex i.cohort age_follow_up_final  auc30_adj
estimates store cat2
coefplot (bin1, keep(0.obese_yes 1.obese_yes) msymbol(S)mfcolor(gs7) offset(-0.1)) (bin2, keep(0.obese_yes 1.obese_yes) msymbol(S) offset(0.1)) (cat1, keep(0.cat_dur_ob_5 1.cat_dur_ob_5 2.cat_dur_ob_5 3.cat_dur_ob_5 4.cat_dur_ob_5 5.cat_dur_ob_5) mfcolor(gs7) offset(-0.1)) (cat2, keep(0.cat_dur_ob_5 1.cat_dur_ob_5 2.cat_dur_ob_5 3.cat_dur_ob_5 4.cat_dur_ob_5 5.cat_dur_ob_5) offset(0.1) ) , legend(order(1 2) label(1 domestic) label(2 foreign)) mfcolor(white) mlcolor(gs7) drop(_cons sex1 1.cohort 2.cohort 3.cohort age_follow_up_final ) baselevels vertical xlab(none) xlabel(1 "Never Obese (ref)" 2 "Ever Obese" 4 "Never Obese (ref)" 5 "Obese<3.8 years" 6 "Obese 3.8-7.4 years" 7 "Obese 7.4-11.1 years" 8 "Obese 11.1-15.7 years" 9 "Obese 15.7-30 years" , angle(45) labsize(tiny) add) order(_cons) ciopts(recast(rcap) col(gs7)) graphregion(color(white) ) ylabel(, nogrid) yline(0, lcolor(black) lpattern(dash)) nokey  groups(?.obese_yes = "{bf:model 1}" ?.cat_dur_ob_5 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash))  ytitle("Change in Diastolic blood pressure (mmHg)")   text(15 14.5 "{it:***=p{subscript:(diff)}}<0.001" "{it:**=p{subscript:(diff)}}<0.01" "{it:*=p{subscript:(diff)}}<0.05" "{it:p{subscript:(duration trend)}}=0.551" "{it:p{subscript:(severity trend)}}=0.162", box fcolor(none) margin(small) justification(right) size(small)) saving("C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\dbp_mut_adj.gph", replace)
*/

regress dbpt_final_v2 i.obese_yes sex i.cohort age_follow_up_final  , vce(bootstrap, reps(200))
estimates store bin1
tab obese_yes if e(sample)
regress dbpt_final_v2 i.obese_yes sex i.cohort age_follow_up_final  auc30_adj, vce(bootstrap, reps(200))
estimates store bin2
tab obese_yes if e(sample)
regress dbpt_final_v2 i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final  , vce(bootstrap, reps(200))
estimates store cat1
tab cat_dur_ob_5_v2 if e(sample)
regress dbpt_final_v2 i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final  auc30_adj, vce(bootstrap, reps(200))
estimates store cat2
tab cat_dur_ob_5_v2 if e(sample)
coefplot (bin1, keep(0.obese_yes 1.obese_yes) msymbol(S)mfcolor(gs7) offset(-0.1)) (bin2, keep(0.obese_yes 1.obese_yes) msymbol(S) offset(0.1)) (cat1, keep(0.cat_dur_ob_5_v2 1.cat_dur_ob_5_v2 2.cat_dur_ob_5_v2 3.cat_dur_ob_5_v2 4.cat_dur_ob_5_v2 5.cat_dur_ob_5_v2) mfcolor(gs7) offset(-0.1)) (cat2, keep(0.cat_dur_ob_5_v2 1.cat_dur_ob_5_v2 2.cat_dur_ob_5_v2 3.cat_dur_ob_5_v2 4.cat_dur_ob_5_v2 5.cat_dur_ob_5_v2) offset(0.1) ) ,  mfcolor(white) mlcolor(gs7) drop(_cons sex1 1.cohort 2.cohort 3.cohort age_follow_up_final ) baselevels vertical xlab(none) xlabel(1 "Never Obese (ref)" 2 "Ever Obese" 4 "Never Obese (ref)" 5 "Obese<5 years" 6 "Obese 5-9.99 years" 7 "Obese 10-14.99 years" 8 "Obese 15-19.99 years" 9 "Obese 20-30 years" , angle(45) labsize(small) add) order(_cons) ciopts(recast(rcap) col(gs7)) graphregion(color(white) ) ylabel(, nogrid) yline(0, lcolor(black) lpattern(dash)) nokey  groups(?.obese_yes = "{bf:model 1}" ?.cat_dur_ob_5_v2 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash)) yscale(range(0 30)) ylabel( 0 (5) 30) ytitle("Percentage change in DBP", size(small))   saving("C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\dbp_mut_adj_v2.gph", replace)


***HDL
/*
regress ln_hdlt_final_v2 i.obese_yes sex i.cohort age_follow_up_final  
estimates store bin1
regress ln_hdlt_final_v2 i.obese_yes sex i.cohort age_follow_up_final  auc30_adj
estimates store bin2
tab obese_yes if e(sample)
regress ln_hdlt_final_v2 i.cat_dur_ob_5 sex i.cohort age_follow_up_final  
estimates store cat1
regress ln_hdlt_final_v2 i.cat_dur_ob_5 sex i.cohort age_follow_up_final  auc30_adj
estimates store cat2
coefplot (bin1, keep(0.obese_yes 1.obese_yes) msymbol(S)mfcolor(gs7) offset(-0.1)) (bin2, keep(0.obese_yes 1.obese_yes) msymbol(S) offset(0.1)) (cat1, keep(0.cat_dur_ob_5 1.cat_dur_ob_5 2.cat_dur_ob_5 3.cat_dur_ob_5 4.cat_dur_ob_5 5.cat_dur_ob_5) mfcolor(gs7) offset(-0.1)) (cat2, keep(0.cat_dur_ob_5 1.cat_dur_ob_5 2.cat_dur_ob_5 3.cat_dur_ob_5 4.cat_dur_ob_5 5.cat_dur_ob_5) offset(0.1) ) , legend(order(1 2) label(1 domestic) label(2 foreign)) mfcolor(white) mlcolor(gs7) drop(_cons sex1 1.cohort 2.cohort 3.cohort age_follow_up_final ) baselevels vertical xlab(none) xlabel(1 "Never Obese (ref)" 2 "Ever Obese" 4 "Never Obese (ref)" 5 "Obese<3.8 years" 6 "Obese 3.8-7.4 years" 7 "Obese 7.4-11.1 years" 8 "Obese 11.1-15.7 years" 9 "Obese 15.7-30 years" , angle(45) labsize(tiny) add) order(_cons) ciopts(recast(rcap) col(gs7)) graphregion(color(white) ) ylabel(, nogrid) yline(0, lcolor(black) lpattern(dash)) nokey  groups(?.obese_yes = "{bf:model 1}" ?.cat_dur_ob_5 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash))  ytitle("Change in ln(HDL-cholesterol)")   text(15 14.5 "{it:***=p{subscript:(diff)}}<0.001" "{it:**=p{subscript:(diff)}}<0.01" "{it:*=p{subscript:(diff)}}<0.05" "{it:p{subscript:(duration trend)}}=0.551" "{it:p{subscript:(severity trend)}}=0.162", box fcolor(none) margin(small) justification(right) size(small)) saving("C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\hdl_mut_adj.gph", replace)
*/

regress ln_hdlt_final_v2 i.obese_yes sex i.cohort age_follow_up_final  , vce(bootstrap, reps(200))
estimates store bin1
tab obese_yes if e(sample)
regress ln_hdlt_final_v2 i.obese_yes sex i.cohort age_follow_up_final  auc30_adj, vce(bootstrap, reps(200))
estimates store bin2
tab obese_yes if e(sample)
regress ln_hdlt_final_v2 i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final  , vce(bootstrap, reps(200))
estimates store cat1
tab cat_dur_ob_5_v2 if e(sample)
regress ln_hdlt_final_v2 i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final  auc30_adj, vce(bootstrap, reps(200))
estimates store cat2
tab cat_dur_ob_5_v2 if e(sample)
coefplot (bin1, keep(0.obese_yes 1.obese_yes) msymbol(S)mfcolor(gs7) offset(-0.1)) (bin2, keep(0.obese_yes 1.obese_yes) msymbol(S) offset(0.1)) (cat1, keep(0.cat_dur_ob_5_v2 1.cat_dur_ob_5_v2 2.cat_dur_ob_5_v2 3.cat_dur_ob_5_v2 4.cat_dur_ob_5_v2 5.cat_dur_ob_5_v2) mfcolor(gs7) offset(-0.1)) (cat2, keep(0.cat_dur_ob_5_v2 1.cat_dur_ob_5_v2 2.cat_dur_ob_5_v2 3.cat_dur_ob_5_v2 4.cat_dur_ob_5_v2 5.cat_dur_ob_5_v2) offset(0.1) ) , mfcolor(white) mlcolor(gs7) drop(_cons sex1 1.cohort 2.cohort 3.cohort age_follow_up_final ) baselevels vertical xlab(none) xlabel(1 "Never Obese (ref)" 2 "Ever Obese" 4 "Never Obese (ref)" 5 "Obese<5 years" 6 "Obese 5-9.99 years" 7 "Obese 10-14.99 years" 8 "Obese 15-19.99 years" 9 "Obese 20-30 years" , angle(45) labsize(small) add) order(_cons) ciopts(recast(rcap) col(gs7)) graphregion(color(white) ) ylabel(, nogrid) yline(0, lcolor(black) lpattern(dash)) nokey  groups(?.obese_yes = "{bf:model 1}" ?.cat_dur_ob_5_v2 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash))  ytitle("Percentage change in HDL-C", size(small))   saving("C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\hdl_mut_adj_v2.gph", replace)


***Triglycerides

/*regress ln_trigt_final_v2 i.obese_yes sex i.cohort age_follow_up_final  
estimates store bin1
regress ln_trigt_final_v2 i.obese_yes sex i.cohort age_follow_up_final  auc30_adj
estimates store bin2
tab obese_yes if e(sample)
regress ln_trigt_final_v2 i.cat_dur_ob_5 sex i.cohort age_follow_up_final  
estimates store cat1
regress ln_trigt_final_v2 i.cat_dur_ob_5 sex i.cohort age_follow_up_final  auc30_adj
estimates store cat2
coefplot (bin1, keep(0.obese_yes 1.obese_yes) msymbol(S)mfcolor(gs7) offset(-0.1)) (bin2, keep(0.obese_yes 1.obese_yes) msymbol(S) offset(0.1)) (cat1, keep(0.cat_dur_ob_5 1.cat_dur_ob_5 2.cat_dur_ob_5 3.cat_dur_ob_5 4.cat_dur_ob_5 5.cat_dur_ob_5) mfcolor(gs7) offset(-0.1)) (cat2, keep(0.cat_dur_ob_5 1.cat_dur_ob_5 2.cat_dur_ob_5 3.cat_dur_ob_5 4.cat_dur_ob_5 5.cat_dur_ob_5) offset(0.1) ) , legend(order(1 2) label(1 domestic) label(2 foreign)) mfcolor(white) mlcolor(gs7) drop(_cons sex1 1.cohort 2.cohort 3.cohort age_follow_up_final ) baselevels vertical xlab(none) xlabel(1 "Never Obese (ref)" 2 "Ever Obese" 4 "Never Obese (ref)" 5 "Obese<3.8 years" 6 "Obese 3.8-7.4 years" 7 "Obese 7.4-11.1 years" 8 "Obese 11.1-15.7 years" 9 "Obese 15.7-30 years" , angle(45) labsize(tiny) add) order(_cons) ciopts(recast(rcap) col(gs7)) graphregion(color(white) ) ylabel(, nogrid) yline(0, lcolor(black) lpattern(dash)) nokey  groups(?.obese_yes = "{bf:model 1}" ?.cat_dur_ob_5 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash))  ytitle("Change in ln(Triglycerides)")   text(15 14.5 "{it:***=p{subscript:(diff)}}<0.001" "{it:**=p{subscript:(diff)}}<0.01" "{it:*=p{subscript:(diff)}}<0.05" "{it:p{subscript:(duration trend)}}=0.551" "{it:p{subscript:(severity trend)}}=0.162", box fcolor(none) margin(small) justification(right) size(small)) saving("C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\trig_mut_adj.gph", replace)
*/


regress ln_trigt_final_v2 i.obese_yes sex i.cohort age_follow_up_final , vce(bootstrap, reps(200)) 
estimates store bin1
tab obese_yes if e(sample)
regress ln_trigt_final_v2 i.obese_yes sex i.cohort age_follow_up_final  auc30_adj, vce(bootstrap, reps(200))
estimates store bin2
tab obese_yes if e(sample)
regress ln_trigt_final_v2 i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final  , vce(bootstrap, reps(200))
estimates store cat1
tab cat_dur_ob_5_v2 if e(sample)
regress ln_trigt_final_v2 i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final  auc30_adj, vce(bootstrap, reps(200))
estimates store cat2
tab cat_dur_ob_5_v2 if e(sample)
coefplot (bin1, keep(0.obese_yes 1.obese_yes) msymbol(S)mfcolor(gs7) offset(-0.1)) (bin2, keep(0.obese_yes 1.obese_yes) msymbol(S) offset(0.1)) (cat1, keep(0.cat_dur_ob_5_v2 1.cat_dur_ob_5_v2 2.cat_dur_ob_5_v2 3.cat_dur_ob_5_v2 4.cat_dur_ob_5_v2 5.cat_dur_ob_5_v2) mfcolor(gs7) offset(-0.1)) (cat2, keep(0.cat_dur_ob_5_v2 1.cat_dur_ob_5_v2 2.cat_dur_ob_5_v2 3.cat_dur_ob_5_v2 4.cat_dur_ob_5_v2 5.cat_dur_ob_5_v2) offset(0.1) ) , mfcolor(white) mlcolor(gs7) drop(_cons sex1 1.cohort 2.cohort 3.cohort age_follow_up_final ) baselevels vertical xlab(none) xlabel(1 "Never Obese (ref)" 2 "Ever Obese" 4 "Never Obese (ref)" 5 "Obese<5 years" 6 "Obese 5-9.99 years" 7 "Obese 10-14.99 years" 8 "Obese 15-19.99 years" 9 "Obese 20-30 years" , angle(45) labsize(small) add) order(_cons) ciopts(recast(rcap) col(gs7)) graphregion(color(white) ) ylabel(, nogrid) yline(0, lcolor(black) lpattern(dash)) nokey  groups(?.obese_yes = "{bf:model 1}" ?.cat_dur_ob_5_v2 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash))  ytitle("Percentage change in Triglycerides", size(small))   saving("C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\trig_mut_adj_v2.gph", replace)


***HbA1c
/*
regress ln_hba1ct_final_v2 i.obese_yes sex i.cohort age_follow_up_final  
estimates store bin1
regress ln_hba1ct_final_v2 i.obese_yes sex i.cohort age_follow_up_final  auc30_adj
estimates store bin2
tab obese_yes if e(sample)
regress ln_hba1ct_final_v2 i.cat_dur_ob_5 sex i.cohort age_follow_up_final  
estimates store cat1
regress ln_hba1ct_final_v2 i.cat_dur_ob_5 sex i.cohort age_follow_up_final  auc30_adj
estimates store cat2
coefplot (bin1, keep(0.obese_yes 1.obese_yes) msymbol(S)mfcolor(gs7) offset(-0.1)) (bin2, keep(0.obese_yes 1.obese_yes) msymbol(S) offset(0.1)) (cat1, keep(0.cat_dur_ob_5 1.cat_dur_ob_5 2.cat_dur_ob_5 3.cat_dur_ob_5 4.cat_dur_ob_5 5.cat_dur_ob_5) mfcolor(gs7) offset(-0.1)) (cat2, keep(0.cat_dur_ob_5 1.cat_dur_ob_5 2.cat_dur_ob_5 3.cat_dur_ob_5 4.cat_dur_ob_5 5.cat_dur_ob_5) offset(0.1) ) , legend(order(1 2) label(1 domestic) label(2 foreign)) mfcolor(white) mlcolor(gs7) drop(_cons sex1 1.cohort 2.cohort 3.cohort age_follow_up_final ) baselevels vertical xlab(none) xlabel(1 "Never Obese (ref)" 2 "Ever Obese" 4 "Never Obese (ref)" 5 "Obese<3.8 years" 6 "Obese 3.8-7.4 years" 7 "Obese 7.4-11.1 years" 8 "Obese 11.1-15.7 years" 9 "Obese 15.7-30 years" , angle(45) labsize(tiny) add) order(_cons) ciopts(recast(rcap) col(gs7)) graphregion(color(white) ) ylabel(, nogrid) yline(0, lcolor(black) lpattern(dash)) nokey  groups(?.obese_yes = "{bf:model 1}" ?.cat_dur_ob_5 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash)) ytitle("Change in ln(HbA1c)")   text(0.15 14.5 "{it:***=p{subscript:(diff)}}<0.001" "{it:**=p{subscript:(diff)}}<0.01" "{it:*=p{subscript:(diff)}}<0.05" "{it:p{subscript:(duration trend)}}=0.221" "{it:p{subscript:(severity trend)}}=0.001", box fcolor(none) margin(small) justification(right) size(small)) saving("C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\hba1c_mut_adj.gph", replace)
*/


regress ln_hba1ct_final_v2 i.obese_yes sex i.cohort age_follow_up_final  , vce(bootstrap, reps(200))
estimates store bin1
tab obese_yes if e(sample)
regress ln_hba1ct_final_v2 i.obese_yes sex i.cohort age_follow_up_final  auc30_adj, vce(bootstrap, reps(200))
estimates store bin2
tab obese_yes if e(sample)
regress ln_hba1ct_final_v2 i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final  , vce(bootstrap, reps(200))
estimates store cat1
tab cat_dur_ob_5_v2 if e(sample)
regress ln_hba1ct_final_v2 i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final  auc30_adj, vce(bootstrap, reps(200))
estimates store cat2
tab cat_dur_ob_5_v2 if e(sample)
coefplot (bin1, keep(0.obese_yes 1.obese_yes) msymbol(S)mfcolor(gs7) offset(-0.1)) (bin2, keep(0.obese_yes 1.obese_yes) msymbol(S) offset(0.1)) (cat1, keep(0.cat_dur_ob_5_v2 1.cat_dur_ob_5_v2 2.cat_dur_ob_5_v2 3.cat_dur_ob_5_v2 4.cat_dur_ob_5_v2 5.cat_dur_ob_5_v2) mfcolor(gs7) offset(-0.1)) (cat2, keep(0.cat_dur_ob_5_v2 1.cat_dur_ob_5_v2 2.cat_dur_ob_5_v2 3.cat_dur_ob_5_v2 4.cat_dur_ob_5_v2 5.cat_dur_ob_5_v2) offset(0.1) ) , mfcolor(white) mlcolor(gs7) drop(_cons sex1 1.cohort 2.cohort 3.cohort age_follow_up_final ) baselevels vertical xlab(none) xlabel(1 "Never Obese (ref)" 2 "Ever Obese" 4 "Never Obese (ref)" 5 "Obese<5 years" 6 "Obese 5-9.99 years" 7 "Obese 10-14.99 years" 8 "Obese 15-19.99 years" 9 "Obese 20-30 years" , angle(45) labsize(small) add) order(_cons) ciopts(recast(rcap) col(gs7)) graphregion(color(white) ) ylabel(, nogrid) yline(0, lcolor(black) lpattern(dash)) nokey  groups(?.obese_yes = "{bf:model 1}" ?.cat_dur_ob_5_v2 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash)) yscale(range(0 30)) ylabel( 0 (5) 30) ytitle("Percentage change in HbA1c", size(small))    saving("C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\hba1c_mut_adj_v2.gph", replace)


***TESTPARM
replace cat_dur_ob_5_v2=. if obese_yes==0
replace cat_auc30_5=. if obese_yes==0
foreach y in sbpt_final_v2 dbpt_final_v2 ln_hdlt_final_v2 ln_trigt_final_v2 ln_hba1ct_final_v2 {
    regress `y' i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final  
	testparm i.cat_dur_ob_5_v2
	tab cat_dur_ob_5_v2 if e(sample)
}

replace cat_dur_ob_5_v2=. if obese_yes==0
replace cat_auc30_5=. if obese_yes==0
foreach y in sbpt_final_v2 dbpt_final_v2 ln_hdlt_final_v2 ln_trigt_final_v2 ln_hba1ct_final_v2 {
    regress `y' i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final  auc30_adj
	testparm i.cat_dur_ob_5_v2
	tab cat_dur_ob_5_v2 if e(sample)
}

***OR
replace cat_dur_ob_5_v2=. if obese_yes==0
regress sbpt_final_v2 cat_dur_ob_5_v2 sex i.cohort age_follow_up_final, vce(bootstrap, rep(200))
regress dbpt_final_v2 cat_dur_ob_5_v2 sex i.cohort age_follow_up_final, vce(bootstrap, rep(200))
regress ln_hdlt_final_v2 cat_dur_ob_5_v2 sex i.cohort age_follow_up_final, vce(bootstrap, rep(200))
regress ln_trigt_final_v2 cat_dur_ob_5_v2 sex i.cohort age_follow_up_final, vce(bootstrap, rep(200))
regress ln_hba1ct_final_v2 cat_dur_ob_5_v2 sex i.cohort age_follow_up_final, vce(bootstrap, rep(200))
regress sbpt_final_v2 cat_dur_ob_5_v2 sex i.cohort age_follow_up_final auc30_adj, vce(bootstrap, rep(200))
regress dbpt_final_v2 cat_dur_ob_5_v2 sex i.cohort age_follow_up_final auc30_adj, vce(bootstrap, rep(200))
regress ln_hdlt_final_v2 cat_dur_ob_5_v2 sex i.cohort age_follow_up_final auc30_adj, vce(bootstrap, rep(200))
regress ln_trigt_final_v2 cat_dur_ob_5_v2 sex i.cohort age_follow_up_final auc30_adj, vce(bootstrap, rep(200))
regress ln_hba1ct_final_v2 cat_dur_ob_5_v2 sex i.cohort age_follow_up_final auc30_adj, vce(bootstrap, rep(200))

**********************Categorical outcome variables*****************************
gen hypertension=.
replace hypertension=1 if (sbp_final>=140 & sbp_final<.) | (dbp_final>=90 & dbp_final<.) | (bp_med_final==1 & bp_med_final<.) 
replace hypertension=0 if sbp_final<140 & dbp_final<90 & bp_med_final==0


/*
pctile pct_hdl = hdl_final, nq(10)
*see what the value at the 10th centile is
gen low_hdl =.
replace low_hdl=1 if hdl_final<1.1
replace low_hdl=0 if hdl_final>1.1 & hdl_final<.
*/
gen low_hdl=.
replace low_hdl=1 if (hdl_final<1.29 & sex1==1) | (lipid_med_final==1 & sex1==1 & lipid_med_final<.)
replace low_hdl=0 if (hdl_final>=1.29 & hdl_final<.) & sex1==1 & lipid_med_final==0
replace low_hdl=1 if hdl_final<1.03 & sex1==0 | (lipid_med_final==1 & sex1==0 & lipid_med_final<.)
replace low_hdl=0 if (hdl_final>=1.03 & hdl_final<.) & sex1==0 & lipid_med_final==0
***low HDL according to ATP III sex-specific definition ("National cholesterol education program. Third report of the national cholesterol education program (NCEP) expert panel on detection, evaluation, and treatment of high blood cholesterol in adults (adult treatment panel III) final report. Circulation. 2002;106(25):3143–421.)

/*pctile pct_trig = trig_final, nq(10)
pctile pct_hba1c = hba1c_final, nq(10)
*see what the 90th centile is for both
gen high_trig =.
replace high_trig=1 if trig_final>3.6 & trig_final<.
replace high_trig=0 if trig_final<3.6
*/
*high trig (as per NCEP ATP III and IDF criteria for MetS, 150mg/dl- divide by 88.57)
gen high_trig=. 
replace high_trig=1 if trig_final>=1.69 & trig_final<. | (lipid_med_final==1 & lipid_med_final<.)
replace high_trig=0 if trig_final<1.69 & lipid_med_final==0

/*gen high_hba1c =.
replace high_hba1c=1 if hba1c_final>5.9 & hba1c_final<.
replace high_hba1c=0 if hba1c_final<5.9
*/
*HIGH hbA1c (CDC define normal as <5.7%, pre-diab as 5.7-6.4% and diab as >6.4%: https://www.cdc.gov/diabetes/library/features/a1c.html)
gen high_hba1c =.
replace high_hba1c=1 if hba1c_final>=5.7 & hba1c_final<. | (diab_med_final==1 & diab_med_final<.)
replace high_hba1c=0 if hba1c_final<5.7 &  diab_med_final==0


egen missing_met_vars= rowmiss( hypertension low_hdl high_trig high_hba1c)
egen metabolically_unhealhty_pre = rowtotal(hypertension low_hdl high_trig high_hba1c) if missing_met_vars<3
*specified that a ps must have at least 2 of the 4 categorical metabolic variables in order to be classifed in the metabolically_unhealhty_variable. if a person had 3 missing vars, they wont be able to be classed as met_unhealthy
*as Will and i said the classifcation would be based on a ps having at least 2 unhealhty profiles out of the 4 we have looked at (i.e. below code)
gen metabolically_unhealhty_final=.
replace metabolically_unhealhty_final=1 if metabolically_unhealhty_pre>=2 & metabolically_unhealhty_pre<.
replace metabolically_unhealhty_final=0 if metabolically_unhealhty_pre<2



*********Unadjusted
***Hypertension
glm hypertension i.obese_yes, fam(poisson) link(log) nolog eform vce(bootstrap, reps(200))
estimates store bin
tab obese_yes hypertension if e(sample)
glm hypertension i.cat_dur_ob_5_v2, fam(poisson) link(log) nolog eform  vce(bootstrap, reps(200))
estimates store cat
tab hypertension cat_dur_ob_5_v2 if e(sample)
coefplot bin cat , eform mlcolor(none) mfcolor(gs7) drop(_cons) baselevels vertical xlab(none) xlabel(1 "Never Obese (ref)" 2 "Ever Obese" 4 "Never Obese (ref)" 5 "Obese<5 years" 6 "Obese 5-10 years" 7 "Obese 10-15 years" 8 "Obese 15-20 years" 9 "Obese 20-30 years", angle(45) labsize(tiny) add) order(_cons) ciopts(recast(rcap) lcolor(gs7)) graphregion(color(white) ) ylabel(, nogrid) yline(1, lcolor(black) lpattern(dash)) nokey offset(0) groups(?.obese_yes = "{bf:model 1}" ?.cat_dur_ob_5 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash)) ytitle("Risk ratio for hypertension")   mlabel(cond(@pval<.001, "***", cond(@pval<.01, "**", cond(@pval<.05, "*", "")))) text(1.5 8.5 "{it:***=p{subscript:(diff)}}<0.001" "{it:p{subscript:(trend)}}=0.918", box fcolor(none) margin(small) justification(right) size(small)) saving("C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\hyperten_dur_unadj.gph", replace)

***low HDL
glm low_hdl i.obese_yes, fam(poisson) link(log) nolog eform vce(bootstrap, reps(200))
estimates store bin
tab obese_yes low_hdl if e(sample)
glm low_hdl i.cat_dur_ob_5_v2, fam(poisson) link(log) nolog eform  vce(bootstrap, reps(200))
estimates store cat
tab low_hdl cat_dur_ob_5_v2 if e(sample)
coefplot bin cat , eform mlcolor(none) mfcolor(gs7) drop(_cons) baselevels vertical xlab(none) xlabel(1 "Never Obese (ref)" 2 "Ever Obese" 4 "Never Obese (ref)" 5 "Obese<5 years" 6 "Obese 5-10 years" 7 "Obese 10-15 years" 8 "Obese 15-20 years" 9 "Obese 20-30 years", angle(45) labsize(tiny) add) order(_cons) ciopts(recast(rcap) lcolor(gs7)) graphregion(color(white) ) ylabel(, nogrid) yline(1, lcolor(black) lpattern(dash)) nokey offset(0) groups(?.obese_yes = "{bf:model 1}" ?.cat_dur_ob_5 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash)) ytitle("Risk ratio for low HDL-cholesterol")   mlabel(cond(@pval<.001, "***", cond(@pval<.01, "**", cond(@pval<.05, "*", "")))) text(1.5 8.5 "{it:***=p{subscript:(diff)}}<0.001" "{it:p{subscript:(trend)}}=0.918", box fcolor(none) margin(small) justification(right) size(small)) saving("C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\low_hdl_dur_unadj.gph", replace)

***High trig
glm high_trig i.obese_yes, fam(poisson) link(log) nolog eform vce(bootstrap, reps(200))
estimates store bin
tab obese_yes high_trig if e(sample)
glm high_trig i.cat_dur_ob_5_v2, fam(poisson) link(log) nolog eform  vce(bootstrap, reps(200))
estimates store cat
tab high_trig cat_dur_ob_5_v2 if e(sample)
coefplot bin cat , eform mlcolor(none) mfcolor(gs7) drop(_cons) baselevels vertical xlab(none) xlabel(1 "Never Obese (ref)" 2 "Ever Obese" 4 "Never Obese (ref)" 5 "Obese<5 years" 6 "Obese 5-10 years" 7 "Obese 10-15 years" 8 "Obese 15-20 years" 9 "Obese 20-30 years", angle(45) labsize(tiny) add) order(_cons) ciopts(recast(rcap) lcolor(gs7)) graphregion(color(white) ) ylabel(, nogrid) yline(1, lcolor(black) lpattern(dash)) nokey offset(0) groups(?.obese_yes = "{bf:model 1}" ?.cat_dur_ob_5 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash)) ytitle("Risk ratio for high triglycerides")   mlabel(cond(@pval<.001, "***", cond(@pval<.01, "**", cond(@pval<.05, "*", "")))) text(1.5 8.5 "{it:***=p{subscript:(diff)}}<0.001" "{it:p{subscript:(trend)}}=0.918", box fcolor(none) margin(small) justification(right) size(small)) saving("C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\high_trig_dur_unadj.gph", replace)

***High HbA1c
glm high_hba1c i.obese_yes, fam(poisson) link(log) nolog eform vce(bootstrap, reps(200))
estimates store bin
tab obese_yes high_hba1c if e(sample)
glm high_hba1c i.cat_dur_ob_5_v2, fam(poisson) link(log) nolog eform  vce(bootstrap, reps(200))
estimates store cat
tab high_hba1c cat_dur_ob_5_v2 if e(sample)
coefplot bin cat , eform mlcolor(none) mfcolor(gs7) drop(_cons) baselevels vertical xlab(none) xlabel(1 "Never Obese (ref)" 2 "Ever Obese" 4 "Never Obese (ref)" 5 "Obese<5 years" 6 "Obese 5-10 years" 7 "Obese 10-15 years" 8 "Obese 15-20 years" 9 "Obese 20-30 years", angle(45) labsize(tiny) add) order(_cons) ciopts(recast(rcap) lcolor(gs7)) graphregion(color(white) ) ylabel(, nogrid) yline(1, lcolor(black) lpattern(dash)) nokey offset(0) groups(?.obese_yes = "{bf:model 1}" ?.cat_dur_ob_5 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash)) ytitle("Risk ratio for high HbA1c")   mlabel(cond(@pval<.001, "***", cond(@pval<.01, "**", cond(@pval<.05, "*", "")))) text(1.5 8.5 "{it:***=p{subscript:(diff)}}<0.001" "{it:p{subscript:(trend)}}=0.918", box fcolor(none) margin(small) justification(right) size(small)) saving("C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\high_hba1c_dur_unadj.gph", replace)

***metabolically_unhealhty
glm metabolically_unhealhty_final i.obese_yes, fam(poisson) link(log) nolog eform vce(bootstrap, reps(200))
estimates store bin
tab obese_yes metabolically_unhealhty_final if e(sample)
glm metabolically_unhealhty_final i.cat_dur_ob_5_v2, fam(poisson) link(log) nolog eform  vce(bootstrap, reps(200))
estimates store cat
tab cat_dur_ob_5_v2 if e(sample)
coefplot bin cat , eform mlcolor(none) mfcolor(gs7) drop(_cons) baselevels vertical xlab(none) xlabel(1 "Never Obese (ref)" 2 "Ever Obese" 4 "Never Obese (ref)" 5 "Obese<5 years" 6 "Obese 5-10 years" 7 "Obese 10-15 years" 8 "Obese 15-20 years" 9 "Obese 20-30 years", angle(45) labsize(tiny) add) order(_cons) ciopts(recast(rcap) lcolor(gs7)) graphregion(color(white) ) ylabel(, nogrid) yline(1, lcolor(black) lpattern(dash)) nokey offset(0) groups(?.obese_yes = "{bf:model 1}" ?.cat_dur_ob_5 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash)) ytitle("Risk ratio for metaboically unhealthy")   mlabel(cond(@pval<.001, "***", cond(@pval<.01, "**", cond(@pval<.05, "*", "")))) text(1.5 8.5 "{it:***=p{subscript:(diff)}}<0.001" "{it:p{subscript:(trend)}}=0.918", box fcolor(none) margin(small) justification(right) size(small)) saving("C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\met_unhealthy_dur_unadj.gph", replace)

***linear trend
replace cat_dur_ob_5_v2=. if obese_yes==0
glm hypertension cat_dur_ob_5_v2  , fam(poisson) link(log) nolog eform vce(bootstrap, reps(200))
glm low_hdl cat_dur_ob_5_v2  , fam(poisson) link(log) nolog eform vce(bootstrap, reps(200))
glm high_hba1c cat_dur_ob_5_v2  , fam(poisson) link(log) nolog eform vce(bootstrap, reps(200))


*****Adjusted 
***Hypertension
glm hypertension i.obese_yes sex i.cohort age_follow_up_final , fam(poisson) link(log) nolog eform
estimates store bin1
tab obese_yes hypertension if e(sample)
glm hypertension i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final , fam(poisson) link(log) nolog eform 
estimates store cat1
tab cat_dur_ob_5_v2 if e(sample)
coefplot bin1 cat1 , eform mfcolor(gs7) mlcolor(gs7) drop(_cons sex1 1.cohort 2.cohort 3.cohort age_follow_up_final ) baselevels vertical xlab(none) xlabel(1 "Never Obese (ref)" 2 "Ever Obese" 4 "Never Obese (ref)" 5 "Obese<5 years" 6 "Obese 5-10 years" 7 "Obese 10-15 years" 8 "Obese 15-20 years" 9 "Obese 20-30 years", angle(45) labsize(tiny) add) order(_cons) ciopts(recast(rcap) lcolor(gs7)) graphregion(color(white) ) ylabel(, nogrid) yline(1, lcolor(black) lpattern(dash)) nokey offset(0) groups(?.obese_yes = "{bf:model 1}" ?.cat_dur_ob_5 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash)) ytitle("Risk ratio for hypertension")   mlabel(cond(@pval<.001, "***", cond(@pval<.01, "**", cond(@pval<.05, "*", "")))) text(-0.05 8.5 "{it:***=p{subscript:(diff)}}<0.001" "{it:p{subscript:(trend)}}<0.001", box fcolor(none) margin(small) justification(right) size(small)) saving("C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\hyperten_dur_adj.gph", replace)

***Low HDL
glm low_hdl i.obese_yes sex i.cohort age_follow_up_final , fam(poisson) link(log) nolog eform
estimates store bin1
tab obese_yes low_hdl if e(sample)
glm low_hdl i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final , fam(poisson) link(log) nolog eform 
estimates store cat1
tab cat_dur_ob_5_v2 if e(sample)
coefplot bin1 cat1 , eform mfcolor(gs7) mlcolor(gs7) drop(_cons sex1 1.cohort 2.cohort 3.cohort age_follow_up_final ) baselevels vertical xlab(none) xlabel(1 "Never Obese (ref)" 2 "Ever Obese" 4 "Never Obese (ref)" 5 "Obese<5 years" 6 "Obese 5-10 years" 7 "Obese 10-15 years" 8 "Obese 15-20 years" 9 "Obese 20-30 years", angle(45) labsize(tiny) add) order(_cons) ciopts(recast(rcap) lcolor(gs7)) graphregion(color(white) ) ylabel(, nogrid) yline(1, lcolor(black) lpattern(dash)) nokey offset(0) groups(?.obese_yes = "{bf:model 1}" ?.cat_dur_ob_5 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash)) ytitle("Risk ratio for low HDL-cholesterol")   mlabel(cond(@pval<.001, "***", cond(@pval<.01, "**", cond(@pval<.05, "*", "")))) text(-0.05 8.5 "{it:***=p{subscript:(diff)}}<0.001" "{it:p{subscript:(trend)}}<0.001", box fcolor(none) margin(small) justification(right) size(small)) saving("C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\low_hdl_dur_adj.gph", replace)

***High trig
glm high_trig i.obese_yes sex i.cohort age_follow_up_final , fam(poisson) link(log) nolog eform
estimates store bin1
tab obese_yes high_trig if e(sample)
glm high_trig i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final , fam(poisson) link(log) nolog eform 
estimates store cat1
tab cat_dur_ob_5_v2 if e(sample)
coefplot bin1 cat1 , eform mfcolor(gs7) mlcolor(gs7) drop(_cons sex1 1.cohort 2.cohort 3.cohort age_follow_up_final ) baselevels vertical xlab(none) xlabel(1 "Never Obese (ref)" 2 "Ever Obese" 4 "Never Obese (ref)" 5 "Obese<5 years" 6 "Obese 5-10 years" 7 "Obese 10-15 years" 8 "Obese 15-20 years" 9 "Obese 20-30 years", angle(45) labsize(tiny) add) order(_cons) ciopts(recast(rcap) lcolor(gs7)) graphregion(color(white) ) ylabel(, nogrid) yline(1, lcolor(black) lpattern(dash)) nokey offset(0) groups(?.obese_yes = "{bf:model 1}" ?.cat_dur_ob_5 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash)) ytitle("Risk ratio for high triglycerides")   mlabel(cond(@pval<.001, "***", cond(@pval<.01, "**", cond(@pval<.05, "*", "")))) text(-0.05 8.5 "{it:***=p{subscript:(diff)}}<0.001" "{it:p{subscript:(trend)}}<0.001", box fcolor(none) margin(small) justification(right) size(small)) saving("C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\high_trig_dur_adj.gph", replace)

***High HbA1c
glm high_hba1c i.obese_yes sex i.cohort age_follow_up_final , fam(poisson) link(log) nolog eform
estimates store bin1
tab obese_yes high_hba1c if e(sample)
glm high_hba1c i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final , fam(poisson) link(log) nolog eform 
estimates store cat1
tab cat_dur_ob_5_v2 if e(sample)
coefplot bin1 cat1 , eform mfcolor(gs7) mlcolor(gs7) drop(_cons sex1 1.cohort 2.cohort 3.cohort age_follow_up_final ) baselevels vertical xlab(none) xlabel(1 "Never Obese (ref)" 2 "Ever Obese" 4 "Never Obese (ref)" 5 "Obese<5 years" 6 "Obese 5-10 years" 7 "Obese 10-15 years" 8 "Obese 15-20 years" 9 "Obese 20-30 years", angle(45) labsize(tiny) add) order(_cons) ciopts(recast(rcap) lcolor(gs7)) graphregion(color(white) ) ylabel(, nogrid) yline(1, lcolor(black) lpattern(dash)) nokey offset(0) groups(?.obese_yes = "{bf:model 1}" ?.cat_dur_ob_5 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash)) ytitle("Risk ratio for high HbA1c")   mlabel(cond(@pval<.001, "***", cond(@pval<.01, "**", cond(@pval<.05, "*", "")))) text(-0.05 8.5 "{it:***=p{subscript:(diff)}}<0.001" "{it:p{subscript:(trend)}}<0.001", box fcolor(none) margin(small) justification(right) size(small)) saving("C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\high_hba1c_dur_adj.gph", replace)

***Metabolically unhealthy
glm metabolically_unhealhty_final i.obese_yes sex i.cohort age_follow_up_final , fam(poisson) link(log) nolog eform
estimates store bin1
tab obese_yes metabolically_unhealhty_final if e(sample)
glm metabolically_unhealhty_final i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final , fam(poisson) link(log) nolog eform 
estimates store cat1
tab cat_dur_ob_5_v2 if e(sample)
coefplot bin1 cat1 , eform mfcolor(gs7) mlcolor(gs7) drop(_cons sex1 1.cohort 2.cohort 3.cohort age_follow_up_final ) baselevels vertical xlab(none) xlabel(1 "Never Obese (ref)" 2 "Ever Obese" 4 "Never Obese (ref)" 5 "Obese<5 years" 6 "Obese 5-10 years" 7 "Obese 10-15 years" 8 "Obese 15-20 years" 9 "Obese 20-30 years", angle(45) labsize(tiny) add) order(_cons) ciopts(recast(rcap) lcolor(gs7)) graphregion(color(white) ) ylabel(, nogrid) yline(1, lcolor(black) lpattern(dash)) nokey offset(0) groups(?.obese_yes = "{bf:model 1}" ?.cat_dur_ob_5 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash)) ytitle("Risk ratio for metabolically unhealthy")   mlabel(cond(@pval<.001, "***", cond(@pval<.01, "**", cond(@pval<.05, "*", "")))) text(-0.05 8.5 "{it:***=p{subscript:(diff)}}<0.001" "{it:p{subscript:(trend)}}<0.001", box fcolor(none) margin(small) justification(right) size(small)) saving("C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\met_unhealthy_dur_adj.gph", replace)

*****Adjuststed for severity
***Hypertension
/*
glm hypertension i.obese_yes sex i.cohort age_follow_up_final , fam(poisson) link(log) nolog eform
estimates store bin1
glm hypertension i.obese_yes sex i.cohort age_follow_up_final  auc30_adj, fam(poisson) link(log) nolog eform
estimates store bin2
tab obese_yes hypertension if e(sample)
glm hypertension i.cat_dur_ob_5 sex i.cohort age_follow_up_final , fam(poisson) link(log) nolog eform 
estimates store cat1
glm hypertension i.cat_dur_ob_5 sex i.cohort age_follow_up_final  auc30_adj, fam(poisson) link(log) nolog eform
estimates store cat2
coefplot (bin1, keep(0.obese_yes 1.obese_yes) msymbol(S)mfcolor(gs7) offset(-0.1)) (bin2, keep(0.obese_yes 1.obese_yes) msymbol(S) offset(0.1)) (cat1, keep(0.cat_dur_ob_5 1.cat_dur_ob_5 2.cat_dur_ob_5 3.cat_dur_ob_5 4.cat_dur_ob_5 5.cat_dur_ob_5) mfcolor(gs7) offset(-0.1)) (cat2, keep(0.cat_dur_ob_5 1.cat_dur_ob_5 2.cat_dur_ob_5 3.cat_dur_ob_5 4.cat_dur_ob_5 5.cat_dur_ob_5) offset(0.1) ) , eform legend(order(1 2) label(1 domestic) label(2 foreign)) mfcolor(white) mlcolor(gs7) drop(_cons sex1 1.cohort 2.cohort 3.cohort age_follow_up_final ) baselevels vertical xlab(none) xlabel(1 "Never Obese (ref)" 2 "Ever Obese" 4 "Never Obese (ref)" 5 "Obese<3.8 years" 6 "Obese 3.8-7.4 years" 7 "Obese 7.4-11.1 years" 8 "Obese 11.1-15.7 years" 9 "Obese 15.7-30 years" , angle(45) labsize(tiny) add) order(_cons) ciopts(recast(rcap) col(gs7)) graphregion(color(white) ) ylabel(, nogrid) yline(1, lcolor(black) lpattern(dash)) nokey  groups(?.obese_yes = "{bf:model 1}" ?.cat_dur_ob_5 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash)) ytitle("Risk ratio for hypertension")   text(0.15 14.5 "{it:***=p{subscript:(diff)}}<0.001" "{it:**=p{subscript:(diff)}}<0.01" "{it:*=p{subscript:(diff)}}<0.05" "{it:p{subscript:(duration trend)}}=0.221" "{it:p{subscript:(severity trend)}}=0.001", box fcolor(none) margin(small) justification(right) size(small)) saving("C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\hyperten_mut_adj.gph", replace)
*/


glm hypertension i.obese_yes sex i.cohort age_follow_up_final , fam(poisson) link(log) nolog eform  vce(bootstrap, reps(200))
estimates store bin1
tab obese_yes hypertension if e(sample)
glm hypertension i.obese_yes sex i.cohort age_follow_up_final  auc30_adj, fam(poisson) link(log) nolog eform vce(bootstrap, reps(200))
estimates store bin2
tab obese_yes hypertension if e(sample)
glm hypertension i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final , fam(poisson) link(log) nolog eform vce(bootstrap, reps(200))
estimates store cat1
tab cat_dur_ob_5_v2 hypertension if e(sample)
glm hypertension i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final  auc30_adj, fam(poisson) link(log) nolog eform vce(bootstrap, reps(200))
estimates store cat2
tab cat_dur_ob_5_v2 hypertension if e(sample)
coefplot (bin1, keep(0.obese_yes 1.obese_yes) msymbol(S)mfcolor(gs7) offset(-0.1)) (bin2, keep(0.obese_yes 1.obese_yes) msymbol(S) offset(0.1)) (cat1, keep(0.cat_dur_ob_5_v2 1.cat_dur_ob_5_v2 2.cat_dur_ob_5_v2 3.cat_dur_ob_5_v2 4.cat_dur_ob_5_v2 5.cat_dur_ob_5_v2) mfcolor(gs7) offset(-0.1)) (cat2, keep(0.cat_dur_ob_5_v2 1.cat_dur_ob_5_v2 2.cat_dur_ob_5_v2 3.cat_dur_ob_5_v2 4.cat_dur_ob_5_v2 5.cat_dur_ob_5_v2) offset(0.1) ) , eform mfcolor(white) mlcolor(gs7) drop(_cons sex1 1.cohort 2.cohort 3.cohort age_follow_up_final ) baselevels vertical xlab(none) xlabel(1 "Never Obese (ref)" 2 "Ever Obese" 4 "Never Obese (ref)" 5 "Obese<5 years" 6 "Obese 5-9.99 years" 7 "Obese 10-14.99 years" 8 "Obese 15-19.99 years" 9 "Obese 20-30 years" , angle(45) labsize(small) add) order(_cons) ciopts(recast(rcap) col(gs7)) graphregion(color(white) ) ylabel(, nogrid) yline(1, lcolor(black) lpattern(dash)) nokey  groups(?.obese_yes = "{bf:model 1}" ?.cat_dur_ob_5_v2 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash)) ytitle("Risk ratio for hypertension", size(small))   saving("C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\hyperten_mut_adj_v2.gph", replace)


***Low HDL
/*
glm low_hdl i.obese_yes sex i.cohort age_follow_up_final , fam(poisson) link(log) nolog eform
estimates store bin1
glm low_hdl i.obese_yes sex i.cohort age_follow_up_final  auc30_adj, fam(poisson) link(log) nolog eform
estimates store bin2
tab obese_yes low_hdl if e(sample)
glm low_hdl i.cat_dur_ob_5 sex i.cohort age_follow_up_final , fam(poisson) link(log) nolog eform 
estimates store cat1
glm low_hdl i.cat_dur_ob_5 sex i.cohort age_follow_up_final  auc30_adj, fam(poisson) link(log) nolog eform
estimates store cat2
coefplot (bin1, keep(0.obese_yes 1.obese_yes) msymbol(S)mfcolor(gs7) offset(-0.1)) (bin2, keep(0.obese_yes 1.obese_yes) msymbol(S) offset(0.1)) (cat1, keep(0.cat_dur_ob_5 1.cat_dur_ob_5 2.cat_dur_ob_5 3.cat_dur_ob_5 4.cat_dur_ob_5 5.cat_dur_ob_5) mfcolor(gs7) offset(-0.1)) (cat2, keep(0.cat_dur_ob_5 1.cat_dur_ob_5 2.cat_dur_ob_5 3.cat_dur_ob_5 4.cat_dur_ob_5 5.cat_dur_ob_5) offset(0.1) ) , eform legend(order(1 2) label(1 domestic) label(2 foreign)) mfcolor(white) mlcolor(gs7) drop(_cons sex1 1.cohort 2.cohort 3.cohort age_follow_up_final ) baselevels vertical xlab(none) xlabel(1 "Never Obese (ref)" 2 "Ever Obese" 4 "Never Obese (ref)" 5 "Obese<3.8 years" 6 "Obese 3.8-7.4 years" 7 "Obese 7.4-11.1 years" 8 "Obese 11.1-15.7 years" 9 "Obese 15.7-30 years" , angle(45) labsize(tiny) add) order(_cons) ciopts(recast(rcap) col(gs7)) graphregion(color(white) ) ylabel(, nogrid) yline(1, lcolor(black) lpattern(dash)) nokey  groups(?.obese_yes = "{bf:model 1}" ?.cat_dur_ob_5 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash)) ytitle("Risk ratio for low HDL-cholesterol")   text(0.15 14.5 "{it:***=p{subscript:(diff)}}<0.001" "{it:**=p{subscript:(diff)}}<0.01" "{it:*=p{subscript:(diff)}}<0.05" "{it:p{subscript:(duration trend)}}=0.221" "{it:p{subscript:(severity trend)}}=0.001", box fcolor(none) margin(small) justification(right) size(small)) saving("C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\low_hdl_mut_adj.gph", replace)
*/


glm low_hdl i.obese_yes sex i.cohort age_follow_up_final , fam(poisson) link(log) nolog eform vce(bootstrap, reps(200))
estimates store bin1
tab obese_yes low_hdl if e(sample)
glm low_hdl i.obese_yes sex i.cohort age_follow_up_final  auc30_adj, fam(poisson) link(log) nolog eform vce(bootstrap, reps(200))
estimates store bin2
tab obese_yes low_hdl if e(sample)
glm low_hdl i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final , fam(poisson) link(log) nolog eform  vce(bootstrap, reps(200))
estimates store cat1
tab cat_dur_ob_5_v2 low_hdl if e(sample)
glm low_hdl i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final  auc30_adj, fam(poisson) link(log) nolog eform vce(bootstrap, reps(200))
estimates store cat2
tab cat_dur_ob_5_v2 low_hdl if e(sample)
coefplot (bin1, keep(0.obese_yes 1.obese_yes) msymbol(S)mfcolor(gs7) offset(-0.1)) (bin2, keep(0.obese_yes 1.obese_yes) msymbol(S) offset(0.1)) (cat1, keep(0.cat_dur_ob_5_v2 1.cat_dur_ob_5_v2 2.cat_dur_ob_5_v2 3.cat_dur_ob_5_v2 4.cat_dur_ob_5_v2 5.cat_dur_ob_5_v2) mfcolor(gs7) offset(-0.1)) (cat2, keep(0.cat_dur_ob_5_v2 1.cat_dur_ob_5_v2 2.cat_dur_ob_5_v2 3.cat_dur_ob_5_v2 4.cat_dur_ob_5_v2 5.cat_dur_ob_5_v2) offset(0.1) ) , eform mfcolor(white) mlcolor(gs7) drop(_cons sex1 1.cohort 2.cohort 3.cohort age_follow_up_final ) baselevels vertical xlab(none) xlabel(1 "Never Obese (ref)" 2 "Ever Obese" 4 "Never Obese (ref)" 5 "Obese<5 years" 6 "Obese 5-9.9 years" 7 "Obese 10-14.99 years" 8 "Obese 15-19.99 years" 9 "Obese 20-30 years" , angle(45) labsize(small) add) order(_cons) ciopts(recast(rcap) col(gs7)) graphregion(color(white) ) ylabel(, nogrid) yline(1, lcolor(black) lpattern(dash)) nokey  groups(?.obese_yes = "{bf:model 1}" ?.cat_dur_ob_5_v2 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash)) ytitle("Risk ratio for low HDL-C", size(small))    saving("C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\low_hdl_mut_adj_v2.gph", replace)


***High trig
/*
glm high_trig i.obese_yes sex i.cohort age_follow_up_final , fam(poisson) link(log) nolog eform
estimates store bin1
glm high_trig i.obese_yes sex i.cohort age_follow_up_final  auc30_adj, fam(poisson) link(log) nolog eform
estimates store bin2
tab obese_yes high_trig if e(sample)
glm high_trig i.cat_dur_ob_5 sex i.cohort age_follow_up_final , fam(poisson) link(log) nolog eform 
estimates store cat1
glm high_trig i.cat_dur_ob_5 sex i.cohort age_follow_up_final  auc30_adj, fam(poisson) link(log) nolog eform
estimates store cat2
coefplot (bin1, keep(0.obese_yes 1.obese_yes) msymbol(S)mfcolor(gs7) offset(-0.1)) (bin2, keep(0.obese_yes 1.obese_yes) msymbol(S) offset(0.1)) (cat1, keep(0.cat_dur_ob_5 1.cat_dur_ob_5 2.cat_dur_ob_5 3.cat_dur_ob_5 4.cat_dur_ob_5 5.cat_dur_ob_5) mfcolor(gs7) offset(-0.1)) (cat2, keep(0.cat_dur_ob_5 1.cat_dur_ob_5 2.cat_dur_ob_5 3.cat_dur_ob_5 4.cat_dur_ob_5 5.cat_dur_ob_5) offset(0.1) ) , eform legend(order(1 2) label(1 domestic) label(2 foreign)) mfcolor(white) mlcolor(gs7) drop(_cons sex1 1.cohort 2.cohort 3.cohort age_follow_up_final ) baselevels vertical xlab(none) xlabel(1 "Never Obese (ref)" 2 "Ever Obese" 4 "Never Obese (ref)" 5 "Obese<3.8 years" 6 "Obese 3.8-7.4 years" 7 "Obese 7.4-11.1 years" 8 "Obese 11.1-15.7 years" 9 "Obese 15.7-30 years" , angle(45) labsize(tiny) add) order(_cons) ciopts(recast(rcap) col(gs7)) graphregion(color(white) ) ylabel(, nogrid) yline(1, lcolor(black) lpattern(dash)) nokey  groups(?.obese_yes = "{bf:model 1}" ?.cat_dur_ob_5 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash)) ytitle("Risk ratio for high triglycerides")   text(0.15 14.5 "{it:***=p{subscript:(diff)}}<0.001" "{it:**=p{subscript:(diff)}}<0.01" "{it:*=p{subscript:(diff)}}<0.05" "{it:p{subscript:(duration trend)}}=0.221" "{it:p{subscript:(severity trend)}}=0.001", box fcolor(none) margin(small) justification(right) size(small)) saving("C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\high_trig_mut_adj.gph", replace)
*/


glm high_trig i.obese_yes sex i.cohort age_follow_up_final , fam(poisson) link(log) nolog eform vce(bootstrap, reps(200))
estimates store bin1
tab obese_yes high_trig if e(sample)
glm high_trig i.obese_yes sex i.cohort age_follow_up_final  auc30_adj, fam(poisson) link(log) nolog eform vce(bootstrap, reps(200))
estimates store bin2
tab obese_yes high_trig if e(sample)
glm high_trig i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final , fam(poisson) link(log) nolog eform  vce(bootstrap, reps(200))
estimates store cat1
tab cat_dur_ob_5_v2 high_trig if e(sample)
glm high_trig i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final  auc30_adj, fam(poisson) link(log) nolog eform vce(bootstrap, reps(200))
estimates store cat2
tab cat_dur_ob_5_v2 high_trig if e(sample)
coefplot (bin1, keep(0.obese_yes 1.obese_yes) msymbol(S)mfcolor(gs7) offset(-0.1)) (bin2, keep(0.obese_yes 1.obese_yes) msymbol(S) offset(0.1)) (cat1, keep(0.cat_dur_ob_5_v2 1.cat_dur_ob_5_v2 2.cat_dur_ob_5_v2 3.cat_dur_ob_5_v2 4.cat_dur_ob_5_v2 5.cat_dur_ob_5_v2) mfcolor(gs7) offset(-0.1)) (cat2, keep(0.cat_dur_ob_5_v2 1.cat_dur_ob_5_v2 2.cat_dur_ob_5_v2 3.cat_dur_ob_5_v2 4.cat_dur_ob_5_v2 5.cat_dur_ob_5_v2) offset(0.1) ) , eform  mfcolor(white) mlcolor(gs7) drop(_cons sex1 1.cohort 2.cohort 3.cohort age_follow_up_final ) baselevels vertical xlab(none) xlabel(1 "Never Obese (ref)" 2 "Ever Obese" 4 "Never Obese (ref)" 5 "Obese<5 years" 6 "Obese 5-9.99 years" 7 "Obese 10-14.99 years" 8 "Obese 15-19.99 years" 9 "Obese 20-30 years" , angle(45) labsize(small) add) order(_cons) ciopts(recast(rcap) col(gs7)) graphregion(color(white) ) ylabel(, nogrid) yline(1, lcolor(black) lpattern(dash)) nokey  groups(?.obese_yes = "{bf:model 1}" ?.cat_dur_ob_5_v2 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash)) ytitle("Risk ratio for high triglycerides", size(small))    saving("C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\high_trig_mut_adj_v2.gph", replace)


***High HbA1c
/*
glm high_hba1c i.obese_yes sex i.cohort age_follow_up_final , fam(poisson) link(log) nolog eform
estimates store bin1
glm high_hba1c i.obese_yes sex i.cohort age_follow_up_final  auc30_adj, fam(poisson) link(log) nolog eform
estimates store bin2
tab obese_yes high_hba1c if e(sample)
glm high_hba1c i.cat_dur_ob_5 sex i.cohort age_follow_up_final , fam(poisson) link(log) nolog eform 
estimates store cat1
glm high_hba1c i.cat_dur_ob_5 sex i.cohort age_follow_up_final  auc30_adj, fam(poisson) link(log) nolog eform
estimates store cat2
coefplot (bin1, keep(0.obese_yes 1.obese_yes) msymbol(S)mfcolor(gs7) offset(-0.1)) (bin2, keep(0.obese_yes 1.obese_yes) msymbol(S) offset(0.1)) (cat1, keep(0.cat_dur_ob_5 1.cat_dur_ob_5 2.cat_dur_ob_5 3.cat_dur_ob_5 4.cat_dur_ob_5 5.cat_dur_ob_5) mfcolor(gs7) offset(-0.1)) (cat2, keep(0.cat_dur_ob_5 1.cat_dur_ob_5 2.cat_dur_ob_5 3.cat_dur_ob_5 4.cat_dur_ob_5 5.cat_dur_ob_5) offset(0.1) ) , eform legend(order(1 2) label(1 domestic) label(2 foreign)) mfcolor(white) mlcolor(gs7) drop(_cons sex1 1.cohort 2.cohort 3.cohort age_follow_up_final ) baselevels vertical xlab(none) xlabel(1 "Never Obese (ref)" 2 "Ever Obese" 4 "Never Obese (ref)" 5 "Obese<3.8 years" 6 "Obese 3.8-7.4 years" 7 "Obese 7.4-11.1 years" 8 "Obese 11.1-15.7 years" 9 "Obese 15.7-30 years" , angle(45) labsize(tiny) add) order(_cons) ciopts(recast(rcap) col(gs7)) graphregion(color(white) ) ylabel(, nogrid) yline(1, lcolor(black) lpattern(dash)) nokey  groups(?.obese_yes = "{bf:model 1}" ?.cat_dur_ob_5 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash)) ytitle("Risk ratio for high HbA1c)")   text(0.15 14.5 "{it:***=p{subscript:(diff)}}<0.001" "{it:**=p{subscript:(diff)}}<0.01" "{it:*=p{subscript:(diff)}}<0.05" "{it:p{subscript:(duration trend)}}=0.221" "{it:p{subscript:(severity trend)}}=0.001", box fcolor(none) margin(small) justification(right) size(small)) saving("C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\high_hba1c_mut_adj.gph", replace)
*/


glm high_hba1c i.obese_yes sex i.cohort age_follow_up_final , fam(poisson) link(log) nolog eform vce(bootstrap, reps(200))
estimates store bin1
tab obese_yes high_hba1c if e(sample)
glm high_hba1c i.obese_yes sex i.cohort age_follow_up_final  auc30_adj, fam(poisson) link(log) nolog eform vce(bootstrap, reps(200))
estimates store bin2
tab obese_yes high_hba1c if e(sample)
glm high_hba1c i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final , fam(poisson) link(log) nolog eform  vce(bootstrap, reps(200))
estimates store cat1
tab cat_dur_ob_5_v2 high_hba1c if e(sample)
glm high_hba1c i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final  auc30_adj, fam(poisson) link(log) nolog eform vce(bootstrap, reps(200))
estimates store cat2
tab cat_dur_ob_5_v2 high_hba1c if e(sample)
coefplot (bin1, keep(0.obese_yes 1.obese_yes) msymbol(S)mfcolor(gs7) offset(-0.1)) (bin2, keep(0.obese_yes 1.obese_yes) msymbol(S) offset(0.1)) (cat1, keep(0.cat_dur_ob_5_v2 1.cat_dur_ob_5_v2 2.cat_dur_ob_5_v2 3.cat_dur_ob_5_v2 4.cat_dur_ob_5_v2 5.cat_dur_ob_5_v2) mfcolor(gs7) offset(-0.1)) (cat2, keep(0.cat_dur_ob_5_v2 1.cat_dur_ob_5_v2 2.cat_dur_ob_5_v2 3.cat_dur_ob_5_v2 4.cat_dur_ob_5_v2 5.cat_dur_ob_5_v2) offset(0.1) ) , eform mfcolor(white) mlcolor(gs7) drop(_cons sex1 1.cohort 2.cohort 3.cohort age_follow_up_final ) baselevels vertical xlab(none) xlabel(1 "Never Obese (ref)" 2 "Ever Obese" 4 "Never Obese (ref)" 5 "Obese<5 years" 6 "Obese 5-9.99 years" 7 "Obese 10-14.99 years" 8 "Obese 15-19.99 years" 9 "Obese 20-30 years" , angle(45) labsize(small) add) order(_cons) ciopts(recast(rcap) col(gs7)) graphregion(color(white) ) ylabel(, nogrid) yline(1, lcolor(black) lpattern(dash)) nokey  groups(?.obese_yes = "{bf:model 1}" ?.cat_dur_ob_5_v2 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash)) ytitle("Risk ratio for high HbA1c", size(small))   saving("C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\high_hba1c_mut_adj_v2.gph", replace)



***Metabolically unhealthy
/*
glm metabolically_unhealhty_final i.obese_yes sex i.cohort age_follow_up_final , fam(poisson) link(log) nolog eform
estimates store bin1
glm metabolically_unhealhty_final i.obese_yes sex i.cohort age_follow_up_final  auc30_adj, fam(poisson) link(log) nolog eform
estimates store bin2
tab obese_yes metabolically_unhealhty_final if e(sample)
glm metabolically_unhealhty_final i.cat_dur_ob_5 sex i.cohort age_follow_up_final , fam(poisson) link(log) nolog eform 
estimates store cat1
glm metabolically_unhealhty_final i.cat_dur_ob_5 sex i.cohort age_follow_up_final  auc30_adj, fam(poisson) link(log) nolog eform
estimates store cat2
coefplot (bin1, keep(0.obese_yes 1.obese_yes) msymbol(S)mfcolor(gs7) offset(-0.1)) (bin2, keep(0.obese_yes 1.obese_yes) msymbol(S) offset(0.1)) (cat1, keep(0.cat_dur_ob_5 1.cat_dur_ob_5 2.cat_dur_ob_5 3.cat_dur_ob_5 4.cat_dur_ob_5 5.cat_dur_ob_5) mfcolor(gs7) offset(-0.1)) (cat2, keep(0.cat_dur_ob_5 1.cat_dur_ob_5 2.cat_dur_ob_5 3.cat_dur_ob_5 4.cat_dur_ob_5 5.cat_dur_ob_5) offset(0.1) ) , eform legend(order(1 2) label(1 domestic) label(2 foreign)) mfcolor(white) mlcolor(gs7) drop(_cons sex1 1.cohort 2.cohort 3.cohort age_follow_up_final ) baselevels vertical xlab(none) xlabel(1 "Never Obese (ref)" 2 "Ever Obese" 4 "Never Obese (ref)" 5 "Obese<3.8 years" 6 "Obese 3.8-7.4 years" 7 "Obese 7.4-11.1 years" 8 "Obese 11.1-15.7 years" 9 "Obese 15.7-30 years" , angle(45) labsize(tiny) add) order(_cons) ciopts(recast(rcap) col(gs7)) graphregion(color(white) ) ylabel(, nogrid) yline(1, lcolor(black) lpattern(dash)) nokey  groups(?.obese_yes = "{bf:model 1}" ?.cat_dur_ob_5 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash)) ytitle("Risk ratio for metabolically unhealthy")   text(0.15 14.5 "{it:***=p{subscript:(diff)}}<0.001" "{it:**=p{subscript:(diff)}}<0.01" "{it:*=p{subscript:(diff)}}<0.05" "{it:p{subscript:(duration trend)}}=0.221" "{it:p{subscript:(severity trend)}}=0.001", box fcolor(none) margin(small) justification(right) size(small)) saving("C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\met_unhealthy_mut_adj.gph", replace)
*/


glm metabolically_unhealhty_final i.obese_yes sex i.cohort age_follow_up_final , fam(poisson) link(log) nolog eform vce(bootstrap, reps(200))
estimates store bin1
glm metabolically_unhealhty_final i.obese_yes sex i.cohort age_follow_up_final  auc30_adj, fam(poisson) link(log) nolog eform vce(bootstrap, reps(200))
estimates store bin2
tab obese_yes metabolically_unhealhty_final if e(sample)
glm metabolically_unhealhty_final i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final , fam(poisson) link(log) nolog eform  vce(bootstrap, reps(200))
estimates store cat1
glm metabolically_unhealhty_final i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final  auc30_adj, fam(poisson) link(log) nolog eform vce(bootstrap, reps(200))
estimates store cat2
coefplot (bin1, keep(0.obese_yes 1.obese_yes) msymbol(S)mfcolor(gs7) offset(-0.1)) (bin2, keep(0.obese_yes 1.obese_yes) msymbol(S) offset(0.1)) (cat1, keep(0.cat_dur_ob_5_v2 1.cat_dur_ob_5_v2 2.cat_dur_ob_5_v2 3.cat_dur_ob_5_v2 4.cat_dur_ob_5_v2 5.cat_dur_ob_5_v2) mfcolor(gs7) offset(-0.1)) (cat2, keep(0.cat_dur_ob_5_v2 1.cat_dur_ob_5_v2 2.cat_dur_ob_5_v2 3.cat_dur_ob_5_v2 4.cat_dur_ob_5_v2 5.cat_dur_ob_5_v2) offset(0.1) ) , eform mfcolor(white) mlcolor(gs7) drop(_cons sex1 1.cohort 2.cohort 3.cohort age_follow_up_final ) baselevels vertical xlab(none) xlabel(1 "Never Obese (ref)" 2 "Ever Obese" 4 "Never Obese (ref)" 5 "Obese<5 years" 6 "Obese 5-9.99 years" 7 "Obese 10-14.99 years" 8 "Obese 15-19.99 years" 9 "Obese 20-30 years" , angle(45) labsize(small) add) order(_cons) ciopts(recast(rcap) col(gs7)) graphregion(color(white) ) ylabel(, nogrid) yline(1, lcolor(black) lpattern(dash)) nokey  groups(?.obese_yes = "{bf:model 1}" ?.cat_dur_ob_5_v2 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash)) ytitle("Risk ratio for metabolically unhealthy", size(small))    saving("C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\met_unhealthy_mut_adj_v2.gph", replace)

***linear trend
replace cat_dur_ob_5_v2=. if obese_yes==0
glm hypertension cat_dur_ob_5_v2 sex i.cohort age_follow_up_final , fam(poisson) link(log) nolog eform vce(bootstrap, reps(200))
glm hypertension cat_dur_ob_5_v2 sex i.cohort age_follow_up_final  auc30_adj, fam(poisson) link(log) nolog eform vce(bootstrap, reps(200))
glm low_hdl cat_dur_ob_5_v2 sex i.cohort age_follow_up_final , fam(poisson) link(log) nolog eform vce(bootstrap, reps(200))
glm low_hdl cat_dur_ob_5_v2 sex i.cohort age_follow_up_final  auc30_adj, fam(poisson) link(log) nolog eform vce(bootstrap, reps(200))
glm high_hba1c cat_dur_ob_5_v2 sex i.cohort age_follow_up_final , fam(poisson) link(log) nolog eform vce(bootstrap, reps(200))
glm high_hba1c cat_dur_ob_5_v2 sex i.cohort age_follow_up_final  auc30_adj, fam(poisson) link(log) nolog eform vce(bootstrap, reps(200))


***Graph combine for paper
graph combine "C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\hba1c_mut_adj_v2.gph" "C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\high_hba1c_mut_adj_v2.gph", graphregion(color(white))  altshrink saving("C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\fig2 paper.gph", replace)
graph export "C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\fig2 paper.tif"
//graph combine "C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\sbp_mut_adj_v2.gph" "C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\dbp_mut_adj_v2.gph" "C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\hdl_mut_adj_v2.gph" "C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\trig_mut_adj_v2.gph", graphregion(color(white)) iscale(*0.5) saving("C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\fig3 paper.gph", replace)
//graph export "C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\fig3 paper.tif"
graph combine "C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\sbp_mut_adj_v2.gph" "C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\dbp_mut_adj_v2.gph" "C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\hdl_mut_adj_v2.gph", graphregion(color(white)) iscale(*0.75) saving("C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\fig3 paper_no_trig.gph", replace)
graph export "C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\fig3 paper_no_trig.tif"



***18/6/20- RESPONSE TO REVIEWER COMMENTS
*include another figure for the two dischotomous outcomes not already included (hypertension and low HDL)
graph combine "C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\hyperten_mut_adj_v2.gph" "C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\low_hdl_mut_adj_v2.gph", graphregion(color(white)) altshrink saving("C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\fig4 paper.gph", replace)
graph export "C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\fig4 paper.tif"

********************************************************************************
*******************************(archive code)***********************************
/*****Duration
***SBP
regress sbp_final i.obese_yes sex i.cohort age_follow_up_final medication_final 
estimates store bin
regress sbp_final i.cat_dur_ob_5 sex i.cohort age_follow_up_final medication_final i.cat_auc30_5
estimates store cat
coefplot (bin, keep(0.obese_yes 1.obese_yes)) (cat, keep(0.cat_auc30_5 1.cat_auc30_5 2.cat_auc30_5 3.cat_auc30_5 4.cat_auc30_5 5.cat_auc30_5 0.cat_dur_ob_5 1.cat_dur_ob_5 2.cat_dur_ob_5 3.cat_dur_ob_5 4.cat_dur_ob_5 5.cat_dur_ob_5)) , drop(_cons sex1 1.cohort 2.cohort 3.cohort age_follow_up_final medication_final) baselevels vertical xlab(none) xlabel(1 "Never Obese (ref)" 2 "Ever Obese" 4 "Never Obese (ref)" 5 "Obese<5 years" 6 "Obese 5-10 years" 7 "Obese 10-15 years" 8 "Obese 15-20 years" 9 "Obese 20-30 years" 11 "Never Obese (ref)" 12 "Category 1 obesity severity" 13 "Category 2 obesity severity" 14 "Category 3 obesity severity" 15 "Category 4 obesity severity" 16 "Category 5 obesity severity", angle(45) labsize(tiny) add) order(_cons) ciopts(recast(rcap)) graphregion(color(white) ) ylabel(, nogrid) yline(0, lcolor(black) lpattern(dash)) nokey offset(0) groups(?.obese_yes = "{bf:model 1}" ?.cat_dur_ob_5 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash)) ytitle("Systolic blood pressure (mmHg)")   mlabel(cond(@pval<.001, "***", cond(@pval<.01, "**", cond(@pval<.05, "*", "")))) text(15 14.5 "{it:***=p{subscript:(diff)}}<0.001" "{it:**=p{subscript:(diff)}}<0.01" "{it:*=p{subscript:(diff)}}<0.05" "{it:p{subscript:(duration trend)}}=0.551" "{it:p{subscript:(severity trend)}}=0.162", box fcolor(none) margin(small) justification(right) size(small)) saving("C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\sbp_mut_adj.gph", replace)


***DBP
regress dbp_final i.obese_yes sex i.cohort age_follow_up_final medication_final 
estimates store bin
regress dbp_final i.cat_dur_ob_5 sex i.cohort age_follow_up_final medication_final i.cat_auc30_5
estimates store cat
coefplot (bin, keep(0.obese_yes 1.obese_yes)) (cat, keep(0.cat_auc30_5 1.cat_auc30_5 2.cat_auc30_5 3.cat_auc30_5 4.cat_auc30_5 5.cat_auc30_5 0.cat_dur_ob_5 1.cat_dur_ob_5 2.cat_dur_ob_5 3.cat_dur_ob_5 4.cat_dur_ob_5 5.cat_dur_ob_5)) , drop(_cons sex1 1.cohort 2.cohort 3.cohort age_follow_up_final medication_final) baselevels vertical xlab(none) xlabel(1 "Never Obese (ref)" 2 "Ever Obese" 4 "Never Obese (ref)" 5 "Obese<5 years" 6 "Obese 5-10 years" 7 "Obese 10-15 years" 8 "Obese 15-20 years" 9 "Obese 20-30 years" 11 "Never Obese (ref)" 12 "Category 1 obesity severity" 13 "Category 2 obesity severity" 14 "Category 3 obesity severity" 15 "Category 4 obesity severity" 16 "Category 5 obesity severity", angle(45) labsize(tiny) add) order(_cons) ciopts(recast(rcap)) graphregion(color(white) ) ylabel(, nogrid) yline(0, lcolor(black) lpattern(dash)) nokey offset(0) groups(?.obese_yes = "{bf:model 1}" ?.cat_dur_ob_5 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash)) ytitle("Diastolic blood pressure (mmHg)")   mlabel(cond(@pval<.001, "***", cond(@pval<.01, "**", cond(@pval<.05, "*", "")))) text(10 14.5 "{it:***=p{subscript:(diff)}}<0.001" "{it:**=p{subscript:(diff)}}<0.01" "{it:*=p{subscript:(diff)}}<0.05" "{it:p{subscript:(duration trend)}}=0.076" "{it:p{subscript:(severity trend)}}=0.020", box fcolor(none) margin(small) justification(right) size(small)) saving("C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\dbp_mut_adj.gph", replace)


***HDL
regress ln_hdl_final i.obese_yes sex i.cohort age_follow_up_final medication_final 
estimates store bin
regress ln_hdl_final i.cat_dur_ob_5 sex i.cohort age_follow_up_final medication_final i.cat_auc30_5
estimates store cat
coefplot (bin, keep(0.obese_yes 1.obese_yes)) (cat, keep(0.cat_auc30_5 1.cat_auc30_5 2.cat_auc30_5 3.cat_auc30_5 4.cat_auc30_5 5.cat_auc30_5 0.cat_dur_ob_5 1.cat_dur_ob_5 2.cat_dur_ob_5 3.cat_dur_ob_5 4.cat_dur_ob_5 5.cat_dur_ob_5)) , drop(_cons sex1 1.cohort 2.cohort 3.cohort age_follow_up_final medication_final) baselevels vertical xlab(none) xlabel(1 "Never Obese (ref)" 2 "Ever Obese" 4 "Never Obese (ref)" 5 "Obese<5 years" 6 "Obese 5-10 years" 7 "Obese 10-15 years" 8 "Obese 15-20 years" 9 "Obese 20-30 years" 11 "Never Obese (ref)" 12 "Category 1 obesity severity" 13 "Category 2 obesity severity" 14 "Category 3 obesity severity" 15 "Category 4 obesity severity" 16 "Category 5 obesity severity", angle(45) labsize(tiny) add) order(_cons) ciopts(recast(rcap)) graphregion(color(white) ) ylabel(, nogrid) yline(0, lcolor(black) lpattern(dash)) nokey offset(0) groups(?.obese_yes = "{bf:model 1}" ?.cat_dur_ob_5 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash)) ytitle("Change in ln(HDL-cholesterol)")   mlabel(cond(@pval<.001, "***", cond(@pval<.01, "**", cond(@pval<.05, "*", "")))) text(-0.3 14.5 "{it:***=p{subscript:(diff)}}<0.001" "{it:**=p{subscript:(diff)}}<0.01" "{it:*=p{subscript:(diff)}}<0.05" "{it:p{subscript:(duration trend)}}=0.616" "{it:p{subscript:(severity trend)}}=0.031", box fcolor(none) margin(small) justification(right) size(small)) saving("C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\hdl_mut_adj.gph", replace)


***Triglycerides
regress ln_trig_final i.obese_yes sex i.cohort age_follow_up_final medication_final 
estimates store bin
regress ln_trig_final i.cat_dur_ob_5 sex i.cohort age_follow_up_final medication_final i.cat_auc30_5
estimates store cat
coefplot (bin, keep(0.obese_yes 1.obese_yes)) (cat, keep(0.cat_auc30_5 1.cat_auc30_5 2.cat_auc30_5 3.cat_auc30_5 4.cat_auc30_5 5.cat_auc30_5 0.cat_dur_ob_5 1.cat_dur_ob_5 2.cat_dur_ob_5 3.cat_dur_ob_5 4.cat_dur_ob_5 5.cat_dur_ob_5)) , drop(_cons sex1 1.cohort 2.cohort 3.cohort age_follow_up_final medication_final) baselevels vertical xlab(none) xlabel(1 "Never Obese (ref)" 2 "Ever Obese" 4 "Never Obese (ref)" 5 "Obese<5 years" 6 "Obese 5-10 years" 7 "Obese 10-15 years" 8 "Obese 15-20 years" 9 "Obese 20-30 years" 11 "Never Obese (ref)" 12 "Category 1 obesity severity" 13 "Category 2 obesity severity" 14 "Category 3 obesity severity" 15 "Category 4 obesity severity" 16 "Category 5 obesity severity", angle(45) labsize(tiny) add) order(_cons) ciopts(recast(rcap)) graphregion(color(white) ) ylabel(, nogrid) yline(0, lcolor(black) lpattern(dash)) nokey offset(0) groups(?.obese_yes = "{bf:model 1}" ?.cat_dur_ob_5 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash)) ytitle("Change in ln(Triglcerides)")   mlabel(cond(@pval<.001, "***", cond(@pval<.01, "**", cond(@pval<.05, "*", "")))) text(0.8 14.5 "{it:***=p{subscript:(diff)}}<0.001" "{it:**=p{subscript:(diff)}}<0.01" "{it:*=p{subscript:(diff)}}<0.05" "{it:p{subscript:(duration trend)}}=0.104" "{it:p{subscript:(severity trend)}}=0.061", box fcolor(none) margin(small) justification(right) size(small)) saving("C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\trig_mut_adj.gph", replace)


***HbA1c
regress ln_hba1c_final i.obese_yes sex i.cohort age_follow_up_final medication_final 
estimates store bin
regress ln_hba1c_final i.cat_dur_ob_5 sex i.cohort age_follow_up_final medication_final i.cat_auc30_5
estimates store cat
coefplot (bin, keep(0.obese_yes 1.obese_yes)) (cat, keep(0.cat_auc30_5 1.cat_auc30_5 2.cat_auc30_5 3.cat_auc30_5 4.cat_auc30_5 5.cat_auc30_5 0.cat_dur_ob_5 1.cat_dur_ob_5 2.cat_dur_ob_5 3.cat_dur_ob_5 4.cat_dur_ob_5 5.cat_dur_ob_5)) , drop(_cons sex1 1.cohort 2.cohort 3.cohort age_follow_up_final medication_final) baselevels vertical xlab(none) xlabel(1 "Never Obese (ref)" 2 "Ever Obese" 4 "Never Obese (ref)" 5 "Obese<5 years" 6 "Obese 5-10 years" 7 "Obese 10-15 years" 8 "Obese 15-20 years" 9 "Obese 20-30 years" 11 "Never Obese (ref)" 12 "Category 1 obesity severity" 13 "Category 2 obesity severity" 14 "Category 3 obesity severity" 15 "Category 4 obesity severity" 16 "Category 5 obesity severity", angle(45) labsize(tiny) add) order(_cons) ciopts(recast(rcap)) graphregion(color(white) ) ylabel(, nogrid) yline(0, lcolor(black) lpattern(dash)) nokey offset(0) groups(?.obese_yes = "{bf:model 1}" ?.cat_dur_ob_5 = "{bf:model 2}") xline(3, lcolor(black*0.5) lpattern(dash)) ytitle("Change in ln(HbA1c)")   mlabel(cond(@pval<.001, "***", cond(@pval<.01, "**", cond(@pval<.05, "*", "")))) text(0.15 14.5 "{it:***=p{subscript:(diff)}}<0.001" "{it:**=p{subscript:(diff)}}<0.01" "{it:*=p{subscript:(diff)}}<0.05" "{it:p{subscript:(duration trend)}}=0.221" "{it:p{subscript:(severity trend)}}=0.001", box fcolor(none) margin(small) justification(right) size(small)) saving("C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\hba1c_mut_adj.gph", replace)
*/


