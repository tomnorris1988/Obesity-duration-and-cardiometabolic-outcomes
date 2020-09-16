**********SUPPLEMENTARY MATERIAL BASED ON IMPUTED DATA



**************************SUPPLEMENTARY MATERIAL******************************** 
  
  
 *****************************(1)exclude NSHD**********************************/

  
use "imputed dataset_continuous", clear
drop if cohort==1

***Adjusted for COVARS AND SEVERITY
***SBP 
mi estimate: regress sbpt_final_v2 i.obese_yes sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)
mi estimate: regress sbpt_final_v2 i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)

***DBP 
mi estimate: regress dbpt_final_v2 i.obese_yes sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)
mi estimate: regress dbpt_final_v2 i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)

***HDL 
mi estimate: regress hdlt_final_v2 i.obese_yes sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)
mi estimate: regress hdlt_final_v2 i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)

***hbA1c 
mi estimate: regress hba1ct_final_v2 i.obese_yes sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)
mi estimate: regress hba1ct_final_v2 i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)

***linear trend
replace cat_dur_ob_5_v2=. if obese_yes==0
mi estimate: regress sbpt_final_v2 cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)
mi estimate: regress dbpt_final_v2 cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)
mi estimate: regress hdlt_final_v2 cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)
mi estimate: regress trigt_final_v2 cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)
mi estimate: regress hba1ct_final_v2 cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)





********************(4)restricted to once obese= always obese*******************
use "imputed dataset_continuous", clear
*need to identify those who stay obese once becoming obese
gen end_minus_age_first_ob= 40-age_first_obese
replace end_minus_age_first_ob =round( end_minus_age_first_ob, 0.001)
gen once_ob_always_ob=.
replace once_ob_always_ob=1 if (end_minus_age_first_ob==tot_duration_obese) & obese_yes==1
replace once_ob_always_ob=0 if (end_minus_age_first_ob!=tot_duration_obese) & end_minus_age_first_ob<.
tab obese_yes once_ob_always_ob if _mi_m==0
drop if once_ob_always_ob==0

***Adjusted for COVARS AND SEVERITY
***SBP 
mi estimate: regress sbpt_final_v2 i.obese_yes sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)
mi estimate: regress sbpt_final_v2 i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)

***DBP 
mi estimate: regress dbpt_final_v2 i.obese_yes sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)
mi estimate: regress dbpt_final_v2 i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)

***HDL 
mi estimate: regress hdlt_final_v2 i.obese_yes sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)
mi estimate: regress hdlt_final_v2 i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)

***hbA1c 
mi estimate: regress hba1ct_final_v2 i.obese_yes sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)
mi estimate: regress hba1ct_final_v2 i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)

***linear trend
replace cat_dur_ob_5_v2=. if obese_yes==0
mi estimate: regress sbpt_final_v2 cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)
mi estimate: regress dbpt_final_v2 cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)
mi estimate: regress hdlt_final_v2 cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)
mi estimate: regress trigt_final_v2 cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)
mi estimate: regress hba1ct_final_v2 cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)


********************************************************************************
********************************************************************************

******(2)re-running the bp models with bp taken at 43yr in NSHD- REQUIRES FRESH IMPUTATION

use "dataset for imputation.dta", clear
keep if target_sample==1
drop ln_hdl_final ln_trig_final ln_hba1c_final ln_hdlt_final ln_trigt_final ln_hba1ct_final ln_hdlt_final_v2 ln_trigt_final_v2 ln_hba1ct_final_v2 sbpt_final_v2 dbpt_final_v2
*the above vars will be passive imputed

gen sep_child=.
replace sep_child= 1 if (rgclass70==1 | rgclass70==2 | NCDS2FCL==1 | NCDS2FCL==2 | BCS3FCL==1 | BCS3FCL==2) 
replace sep_child= 2 if (rgclass70==5 | rgclass70==6 | NCDS2FCL==5 | NCDS2FCL==6 | BCS3FCL==5 | BCS3FCL==6) 
replace sep_child= 0 if (rgclass70==3 | rgclass70==4 | NCDS2FCL==3 | NCDS2FCL==4 | BCS3FCL==3 | BCS3FCL==4) & sep_child==.
tab sep_child 

gen ln_hdlt_final=ln(hdlt_final)
gen ln_trigt_final=ln(trigt_final)

drop sbpt_final dbpt_final
*this are already in the imputing dataset and thus need to be removed as creating fresh ones below

sort NSHD_ID
clonevar NSHD_ID_v2 = NSHD_ID
replace NSHD_ID_v2 = 10000 if NSHD_ID==.  
gen n=_n
replace NSHD_ID_v2 = NSHD_ID_v2+n if NSHD_ID==.  
duplicates report NSHD_ID_v2
*no dups
drop NSHD_ID n
rename NSHD_ID_v2 NSHD_ID
merge 1:1 NSHD_ID using "C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\raw data\just blood pressures at 43 yr in NSHD for suppl analysis.dta"
replace NSHD_ID=. if NSHD_ID>5362
drop if _merge==2 
drop _merge

*clean the bp vars
renvars DBP89 SBP89, lower
replace sbp89=. if sbp89==9999
replace dbp89=. if dbp89==9999
sum sbp89 dbp89
hist sbp89 
hist dbp89

*replace the sbp_final and dbp_final vars for the age 43 (sbp89 and dbp89) bp vars ONLY IN THOSE IN NSHD
replace sbp_final= sbp89 if cohort==1 & sbp99<.
replace dbp_final= dbp89 if cohort==1 & dbp99<.

clonevar sbpt_final = sbp_final
replace sbpt_final = sbp_final + 10 if bp_med_final ==1 & !missing(bp_med_final)
clonevar dbpt_final = dbp_final
replace dbpt_final = dbp_final + 5 if bp_med_final ==1 & !missing(bp_med_final)

set matsize 800
mi set flong
mi register imputed sbpt_final dbpt_final hba1ct_final ln_trigt_final ln_hdlt_final  wt eth eth_final sep_child 
mi impute chained (regress) sbpt_final dbpt_final hba1ct_final ln_trigt_final ln_hdlt_final wt (logit)  eth_final   (mlogit) sep_child   = sex cat_dur_ob_5_v2 cohort age_follow_up_final obese_yes tot_duration_ob auc30 auc30_adj, rseed(123) force augment add(50)

mi passive: gen sbpt_final_v2= (ln(sbpt_final))*100
mi passive: gen dbpt_final_v2= (ln(dbpt_final))*100

save "imputed dataset_continuous_BP89", replace
use "imputed dataset_continuous_BP89", clear

***Adjusted for COVARS AND SEVERITY
***SBP 
mi estimate: regress sbpt_final_v2 i.obese_yes sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)
mi estimate: regress sbpt_final_v2 i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)

***DBP 
mi estimate: regress dbpt_final_v2 i.obese_yes sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)
mi estimate: regress dbpt_final_v2 i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)

***linear trend
replace cat_dur_ob_5_v2=. if obese_yes==0
mi estimate: regress sbpt_final_v2 cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)
mi estimate: regress dbpt_final_v2 cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)



********************************************************************************
********************************************************************************
******(2)sex interaction- NEED TO RUN FRESH IMPUTATION

use "dataset for imputation.dta", clear
keep if target_sample==1
drop ln_hdl_final ln_trig_final ln_hba1c_final ln_hdlt_final ln_trigt_final ln_hba1ct_final ln_hdlt_final_v2 ln_trigt_final_v2 ln_hba1ct_final_v2 sbpt_final_v2 dbpt_final_v2
*the above vars will be passive imputed

gen sep_child=.
replace sep_child= 1 if (rgclass70==1 | rgclass70==2 | NCDS2FCL==1 | NCDS2FCL==2 | BCS3FCL==1 | BCS3FCL==2) 
replace sep_child= 2 if (rgclass70==5 | rgclass70==6 | NCDS2FCL==5 | NCDS2FCL==6 | BCS3FCL==5 | BCS3FCL==6) 
replace sep_child= 0 if (rgclass70==3 | rgclass70==4 | NCDS2FCL==3 | NCDS2FCL==4 | BCS3FCL==3 | BCS3FCL==4) & sep_child==.
tab sep_child 

gen ln_hdlt_final=ln(hdlt_final)
gen ln_trigt_final=ln(trigt_final)

set matsize 800
mi set flong


mi register imputed sbpt_final dbpt_final hba1ct_final ln_trigt_final ln_hdlt_final  wt eth eth_final sep_child 
mi impute chained (regress) sbpt_final dbpt_final hba1ct_final ln_trigt_final ln_hdlt_final wt (logit)  eth_final   (mlogit) sep_child   = sex##cat_dur_ob_5_v2 cohort age_follow_up_final sex##obese_yes tot_duration_ob auc30 auc30_adj, rseed(123) force augment add(50)

mi passive: gen sbpt_final_v2= (ln(sbpt_final))*100
mi passive: gen dbpt_final_v2= (ln(dbpt_final))*100
mi passive: gen hdlt_final_v2= ln_hdlt_final*100
mi passive: gen trigt_final_v2= ln_trigt_final*100
mi passive: gen hba1ct_final_v2= (ln(hba1ct_final))*100

save "imputed dataset_continuous_sex_int", replace
use "imputed dataset_continuous_sex_int", clear

***Adjusted for COVARS AND SEVERITY
***SBP 
mi estimate: regress sbpt_final_v2 i.obese_yes##sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)
//mi estimate(obese_yes_female:_b[1.obese_yes] + _b[1.obese_yes#1.sex1]), coeflegend: regress sbpt_final_v2 i.obese_yes##sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)
//mi testtransform obese_yes_female
mi test 1.sex#1.obese_yes
mi estimate: regress sbpt_final_v2 i.cat_dur_ob_5_v2##sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)
*report the coefficients from the above as these are relative to never, but then delete those never obese to get p-value for interaction based on those with cat_dur_ob_5_v2 data
replace cat_dur_ob_5_v2=. if obese_yes==0
mi estimate(obese_cat_female:_b[cat_dur_ob_5_v2] + _b[1.sex1#c.cat_dur_ob_5_v2]), coeflegend: regress sbpt_final_v2 c.cat_dur_ob_5_v2##i.sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)
mi testtransform obese_cat_female
*OR- instead of doign the above and running the interaction on the continuous duration var instead of in its categorical form, i can keep it as a cat var and run the below code
//mi estimate: regress sbpt_final_v2 i.cat_dur_ob_5_v2##sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)
//mi test 1.sex1#1.cat_dur_ob_5_v2 1.sex1#2.cat_dur_ob_5_v2 1.sex1#3.cat_dur_ob_5_v2 1.sex1#4.cat_dur_ob_5_v2 1.sex1#5.cat_dur_ob_5_v2

replace cat_dur_ob_5_v2=0 if obese_yes==0

/**to get the n in ech group for males and females (although im only reporting females, do the following (and then divide the number by number of imputations (50)
tab sex if _mi_m > 0 & _mi_m <= 50 & obese_yes==0
tab sex if _mi_m > 0 & _mi_m <= 50 & cat_dur_ob_5_v2==1
tab sex if _mi_m > 0 & _mi_m <= 50 & cat_dur_ob_5_v2==2
tab sex if _mi_m > 0 & _mi_m <= 50 & cat_dur_ob_5_v2==3
tab sex if _mi_m > 0 & _mi_m <= 50 & cat_dur_ob_5_v2==4
tab sex if _mi_m > 0 & _mi_m <= 50 & cat_dur_ob_5_v2==5
or
mi estimate, post i(1/50): proportion sex if  cat_dur_ob_5_v2==5
*/

***DBP 
mi estimate: regress dbpt_final_v2 i.obese_yes##sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)
//mi estimate(obese_yes_female_dbp:_b[1.obese_yes] + _b[1.obese_yes#1.sex1]), coeflegend: regress dbpt_final_v2 i.obese_yes##sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)
//mi testtransform obese_yes_female_dbp
mi test 1.sex#1.obese_yes
mi estimate: regress dbpt_final_v2 i.cat_dur_ob_5_v2##sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)
replace cat_dur_ob_5_v2=. if obese_yes==0
mi estimate(obese_cat_female_dbp:_b[cat_dur_ob_5_v2] + _b[1.sex1#c.cat_dur_ob_5_v2]), coeflegend: regress dbpt_final_v2 c.cat_dur_ob_5_v2##i.sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)
mi testtransform obese_cat_female_dbp
*OR- instead of doign the above and running the interaction on the continuous duration var instead of in its categorical form, i can keep it as a cat var and run the below code
//mi estimate: regress dbpt_final_v2 i.cat_dur_ob_5_v2##sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)
//mi test 1.sex1#1.cat_dur_ob_5_v2 1.sex1#2.cat_dur_ob_5_v2 1.sex1#3.cat_dur_ob_5_v2 1.sex1#4.cat_dur_ob_5_v2 1.sex1#5.cat_dur_ob_5_v2
replace cat_dur_ob_5_v2=0 if obese_yes==0


***HDL 
mi estimate: regress hdlt_final_v2 i.obese_yes##sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)
//mi estimate(obese_yes_female_hdl:_b[1.obese_yes] + _b[1.obese_yes#1.sex1]), coeflegend: regress hdlt_final_v2 i.obese_yes##sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)
//mi testtransform obese_yes_female_hdl
mi test 1.sex#1.obese_yes
mi estimate: regress hdlt_final_v2 i.cat_dur_ob_5_v2##sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)
replace cat_dur_ob_5_v2=. if obese_yes==0
mi estimate(obese_cat_female_hdl:_b[cat_dur_ob_5_v2] + _b[1.sex1#c.cat_dur_ob_5_v2]), coeflegend: regress hdlt_final_v2 c.cat_dur_ob_5_v2##i.sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)
mi testtransform obese_cat_female_hdl
*OR- instead of doign the above and running the interaction on the continuous duration var instead of in its categorical form, i can keep it as a cat var and run the below code
//mi estimate: regress hdlt_final_v2 i.cat_dur_ob_5_v2##sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)
//mi test 1.sex1#1.cat_dur_ob_5_v2 1.sex1#2.cat_dur_ob_5_v2 1.sex1#3.cat_dur_ob_5_v2 1.sex1#4.cat_dur_ob_5_v2 1.sex1#5.cat_dur_ob_5_v2

replace cat_dur_ob_5_v2=0 if obese_yes==0

***hbA1c 
mi estimate: regress hba1ct_final_v2 i.obese_yes##sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)
//mi estimate(obese_yes_female_hba1c:_b[1.obese_yes] + _b[1.obese_yes#1.sex1]), coeflegend: regress hba1ct_final_v2 i.obese_yes##sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)
//mi testtransform obese_yes_female_hba1c
mi test 1.sex#1.obese_yes
mi estimate: regress hba1ct_final_v2 i.cat_dur_ob_5_v2##sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)
replace cat_dur_ob_5_v2=. if obese_yes==0
mi estimate(obese_cat_female_hba1c:_b[cat_dur_ob_5_v2] + _b[1.sex1#c.cat_dur_ob_5_v2]), coeflegend: regress hba1ct_final_v2 c.cat_dur_ob_5_v2##i.sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)
mi testtransform obese_cat_female_hba1c
*OR- instead of doign the above and running the interaction on the continuous duration var instead of in its categorical form, i can keep it as a cat var and run the below code
//mi estimate: regress hba1ct_final_v2 i.cat_dur_ob_5_v2##sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)
//mi test 1.sex1#1.cat_dur_ob_5_v2 1.sex1#2.cat_dur_ob_5_v2 1.sex1#3.cat_dur_ob_5_v2 1.sex1#4.cat_dur_ob_5_v2 1.sex1#5.cat_dur_ob_5_v2

replace cat_dur_ob_5_v2=0 if obese_yes==0




********************************************************************************
********************************************************************************
**********************CATEGORICAL VARIABLES*************************************

 *****************************(1)exclude NSHD**********************************/
**hypert
use "imputed dataset_hypertension", clear
drop if cohort==1

*covars + obesity severity
mi estimate, eform: glm hypertension i.obese_yes sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, fam(poisson) link(log) nolog vce(robust)
mi estimate,  eform: glm hypertension i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, fam(poisson) link(log) nolog vce(robust)

tab obese_yes if _mi_m==0
tab cat_dur_ob_5_v2 if _mi_m==0
mi estimate, post: proportion hypertension, over(obese_yes)
mi estimate, post: proportion hypertension, over(cat_dur_ob_5_v2)

***linear trend
replace cat_dur_ob_5_v2=. if obese_yes==0
mi estimate: glm hypertension cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, fam(poisson) link(log) nolog eform vce(robust)

clear

***low hdl
use "imputed dataset_low_hdl", clear
drop if cohort==1

*covars + obesity severity
mi estimate,  eform: glm low_hdl i.obese_yes sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, fam(poisson) link(log) nolog vce(robust)
mi estimate,  eform: glm low_hdl i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, fam(poisson) link(log) nolog vce(robust)
tab obese_yes if _mi_m==0
tab cat_dur_ob_5_v2 if _mi_m==0
mi estimate, post: proportion low_hdl, over(obese_yes)
mi estimate, post: proportion low_hdl, over(cat_dur_ob_5_v2)

***linear trend
replace cat_dur_ob_5_v2=. if obese_yes==0
mi estimate: glm low_hdl cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, fam(poisson) link(log) nolog eform vce(robust)

clear

***high hba1c
use "high_hba1c_imputed_dataset40.dta", clear
drop if cohort==1

*covars + obesity severity
mi estimate,  eform: glm high_hba1c i.obese_yes sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, fam(poisson) link(log) nolog vce(robust)
mi estimate,  eform: glm high_hba1c i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, fam(poisson) link(log) nolog vce(robust)
tab obese_yes if _mi_m==0
tab cat_dur_ob_5_v2 if _mi_m==0
mi estimate, post: proportion high_hba1c, over(obese_yes)
mi estimate, post: proportion high_hba1c, over(cat_dur_ob_5_v2)


***linear trend
replace cat_dur_ob_5_v2=. if obese_yes==0
mi estimate: glm high_hba1c cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, fam(poisson) link(log) nolog eform vce(robust)

clear


********************(4)restricted to once obese= always obese*******************
***hypert
use "imputed dataset_hypertension", clear
*need to identify those who stay obese once becoming obese
gen end_minus_age_first_ob= 40-age_first_obese
replace end_minus_age_first_ob =round( end_minus_age_first_ob, 0.001)
gen once_ob_always_ob=.
replace once_ob_always_ob=1 if (end_minus_age_first_ob==tot_duration_obese) & obese_yes==1
replace once_ob_always_ob=0 if (end_minus_age_first_ob!=tot_duration_obese) & end_minus_age_first_ob<.
tab obese_yes once_ob_always_ob if _mi_m==0
drop if once_ob_always_ob==0

*covars + obesity severity
mi estimate, eform: glm hypertension i.obese_yes sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, fam(poisson) link(log) nolog vce(robust)
mi estimate, eform: glm hypertension i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, fam(poisson) link(log) nolog vce(robust)
*to get the numbers of the 2x2 table of hypert vs obese_yes (and same for cat_dur_ob_5_v2)i need to report in the tables, do the below, but be careful which numbers you take- read the output carefully. 
tab obese_yes if _mi_m==0
tab cat_dur_ob_5_v2 if _mi_m==0
mi estimate, post: proportion hypertension, over(obese_yes)
mi estimate, post: proportion hypertension, over(cat_dur_ob_5_v2)

***linear trend
replace cat_dur_ob_5_v2=. if obese_yes==0
mi estimate: glm hypertension cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, fam(poisson) link(log) nolog eform vce(robust)


clear

***low hdl
use "imputed dataset_low_hdl", clear
gen end_minus_age_first_ob= 40-age_first_obese
replace end_minus_age_first_ob =round( end_minus_age_first_ob, 0.001)
gen once_ob_always_ob=.
replace once_ob_always_ob=1 if (end_minus_age_first_ob==tot_duration_obese) & obese_yes==1
replace once_ob_always_ob=0 if (end_minus_age_first_ob!=tot_duration_obese) & end_minus_age_first_ob<.
tab obese_yes once_ob_always_ob if _mi_m==0
drop if once_ob_always_ob==0

*covars + obesity severity
mi estimate,  eform: glm low_hdl i.obese_yes sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, fam(poisson) link(log) nolog vce(robust)
mi estimate,  eform: glm low_hdl i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, fam(poisson) link(log) nolog vce(robust)
tab obese_yes if _mi_m==0
tab cat_dur_ob_5_v2 if _mi_m==0
mi estimate, post: proportion low_hdl, over(obese_yes)
mi estimate, post: proportion low_hdl, over(cat_dur_ob_5_v2)

***linear trend
replace cat_dur_ob_5_v2=. if obese_yes==0
mi estimate: glm low_hdl cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, fam(poisson) link(log) nolog eform vce(robust)

clear

***high hba1c
use "high_hba1c_imputed_dataset40.dta", clear
gen end_minus_age_first_ob= 40-age_first_obese
replace end_minus_age_first_ob =round( end_minus_age_first_ob, 0.001)
gen once_ob_always_ob=.
replace once_ob_always_ob=1 if (end_minus_age_first_ob==tot_duration_obese) & obese_yes==1
replace once_ob_always_ob=0 if (end_minus_age_first_ob!=tot_duration_obese) & end_minus_age_first_ob<.
tab obese_yes once_ob_always_ob if _mi_m==0
drop if once_ob_always_ob==0

*covars + obesity severity
mi estimate,  eform: glm high_hba1c i.obese_yes sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, fam(poisson) link(log) nolog vce(robust)
mi estimate,  eform: glm high_hba1c i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, fam(poisson) link(log) nolog vce(robust)
tab obese_yes if _mi_m==0
tab cat_dur_ob_5_v2 if _mi_m==0
mi estimate, post: proportion high_hba1c, over(obese_yes)
mi estimate, post: proportion high_hba1c, over(cat_dur_ob_5_v2)


***linear trend
replace cat_dur_ob_5_v2=. if obese_yes==0
mi estimate: glm high_hba1c cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, fam(poisson) link(log) nolog eform vce(robust)

clear

********************************************************************************
******(2)re-running the bp models with bp taken at 43yr in NSHD- REQUIRES FRESH IMPUTATION

use "dataset for imputation.dta", clear
keep if target_sample==1
drop ln_hdl_final ln_trig_final ln_hba1c_final ln_hdlt_final ln_trigt_final ln_hba1ct_final ln_hdlt_final_v2 ln_trigt_final_v2 ln_hba1ct_final_v2 sbpt_final_v2 dbpt_final_v2
*the above vars will be passive imputed

gen sep_child=.
replace sep_child= 1 if (rgclass70==1 | rgclass70==2 | NCDS2FCL==1 | NCDS2FCL==2 | BCS3FCL==1 | BCS3FCL==2) 
replace sep_child= 2 if (rgclass70==5 | rgclass70==6 | NCDS2FCL==5 | NCDS2FCL==6 | BCS3FCL==5 | BCS3FCL==6) 
replace sep_child= 0 if (rgclass70==3 | rgclass70==4 | NCDS2FCL==3 | NCDS2FCL==4 | BCS3FCL==3 | BCS3FCL==4) & sep_child==.
tab sep_child 

gen ln_hdlt_final=ln(hdlt_final)
gen ln_trigt_final=ln(trigt_final)

drop sbpt_final dbpt_final
*this are already in the imputing dataset and thus need to be removed as creating fresh ones below

sort NSHD_ID
clonevar NSHD_ID_v2 = NSHD_ID
replace NSHD_ID_v2 = 10000 if NSHD_ID==.  
gen n=_n
replace NSHD_ID_v2 = NSHD_ID_v2+n if NSHD_ID==.  
duplicates report NSHD_ID_v2
*no dups
drop NSHD_ID n
rename NSHD_ID_v2 NSHD_ID
merge 1:1 NSHD_ID using "C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\raw data\just blood pressures at 43 yr in NSHD for suppl analysis.dta"
replace NSHD_ID=. if NSHD_ID>5362
drop if _merge==2 
drop _merge

*clean the bp vars
renvars DBP89 SBP89, lower
replace sbp89=. if sbp89==9999
replace dbp89=. if dbp89==9999
sum sbp89 dbp89
hist sbp89 
hist dbp89

*replace the sbp_final and dbp_final vars for the age 43 (sbp89 and dbp89) bp vars ONLY IN THOSE IN NSHD
replace sbp_final= sbp89 if cohort==1 & sbp99<.
replace dbp_final= dbp89 if cohort==1 & dbp99<.

set matsize 800
mi set flong

mi register imputed eth_final sep_child  sbp_final dbp_final bp_med_final wt

mi impute chained (regress) sbp_final dbp_final wt (logit)  eth_final  bp_med_final (mlogit) sep_child   = sex cat_dur_ob_5_v2 cohort age_follow_up_final obese_yes tot_duration_ob auc30 auc30_adj, rseed(123) force augment add(30)
mi passive: gen hypertension=.
mi passive: replace hypertension=1 if (sbp_final>=140 ) | (dbp_final>=90 ) | (bp_med_final==1 ) 
mi passive: replace hypertension=0 if sbp_final<140 & dbp_final<90 & bp_med_final==0
save "imputed dataset_hypertension_BP89", replace

use "imputed dataset_hypertension_BP89", clear

*covars + obesity severity
mi estimate, eform: glm hypertension i.obese_yes sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, fam(poisson) link(log) nolog vce(robust)
mi estimate, eform: glm hypertension i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, fam(poisson) link(log) nolog vce(robust)
tab obese_yes if _mi_m==0
tab cat_dur_ob_5_v2 if _mi_m==0
mi estimate, post: proportion hypertension, over(obese_yes)
mi estimate, post: proportion hypertension, over(cat_dur_ob_5_v2)

***linear trend
replace cat_dur_ob_5_v2=. if obese_yes==0
mi estimate: glm hypertension cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, fam(poisson) link(log) nolog eform vce(robust)



********************************************************************************
********************************************************************************
******(2)sex interaction- NEED TO RUN FRESH IMPUTATION
*hypertension
use "dataset for imputation.dta", clear
keep if target_sample==1
drop ln_hdl_final ln_trig_final ln_hba1c_final ln_hdlt_final ln_trigt_final ln_hba1ct_final ln_hdlt_final_v2 ln_trigt_final_v2 ln_hba1ct_final_v2 sbpt_final_v2 dbpt_final_v2

gen sep_child=.
replace sep_child= 1 if (rgclass70==1 | rgclass70==2 | NCDS2FCL==1 | NCDS2FCL==2 | BCS3FCL==1 | BCS3FCL==2) 
replace sep_child= 2 if (rgclass70==5 | rgclass70==6 | NCDS2FCL==5 | NCDS2FCL==6 | BCS3FCL==5 | BCS3FCL==6) 
replace sep_child= 0 if (rgclass70==3 | rgclass70==4 | NCDS2FCL==3 | NCDS2FCL==4 | BCS3FCL==3 | BCS3FCL==4) & sep_child==.
tab sep_child 

set matsize 800
mi set flong

mi register imputed eth_final sep_child  sbp_final dbp_final bp_med_final wt

mi impute chained (regress) sbp_final dbp_final wt (logit)  eth_final  bp_med_final (mlogit) sep_child   = sex##cat_dur_ob_5_v2 cohort age_follow_up_final sex##obese_yes tot_duration_ob auc30 auc30_adj, rseed(123) force augment add(30)
mi passive: gen hypertension=.
mi passive: replace hypertension=1 if (sbp_final>=140 ) | (dbp_final>=90 ) | (bp_med_final==1 ) 
mi passive: replace hypertension=0 if sbp_final<140 & dbp_final<90 & bp_med_final==0
save "imputed dataset_hypertension_sex_int", replace
use "imputed dataset_hypertension_sex_int", clear

mi estimate, eform: glm hypertension i.obese_yes##sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, fam(poisson) link(log) nolog vce(robust)
mi test 1.sex#1.obese_yes
mi estimate, eform: glm hypertension i.cat_dur_ob_5_v2##sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, fam(poisson) link(log) nolog vce(robust)
replace cat_dur_ob_5_v2=. if obese_yes==0
mi estimate(obese_cat_female:_b[cat_dur_ob_5_v2] + _b[1.sex1#c.cat_dur_ob_5_v2]), coeflegend: glm hypertension c.cat_dur_ob_5_v2##i.sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, fam(poisson) link(log) nolog vce(robust)
mi testtransform obese_cat_female

replace cat_dur_ob_5_v2=0 if obese_yes==0



*low HDL
use "dataset for imputation.dta", clear
keep if target_sample==1
drop ln_hdl_final ln_trig_final ln_hba1c_final ln_hdlt_final ln_trigt_final ln_hba1ct_final ln_hdlt_final_v2 ln_trigt_final_v2 ln_hba1ct_final_v2 sbpt_final_v2 dbpt_final_v2

gen sep_child=.
replace sep_child= 1 if (rgclass70==1 | rgclass70==2 | NCDS2FCL==1 | NCDS2FCL==2 | BCS3FCL==1 | BCS3FCL==2) 
replace sep_child= 2 if (rgclass70==5 | rgclass70==6 | NCDS2FCL==5 | NCDS2FCL==6 | BCS3FCL==5 | BCS3FCL==6) 
replace sep_child= 0 if (rgclass70==3 | rgclass70==4 | NCDS2FCL==3 | NCDS2FCL==4 | BCS3FCL==3 | BCS3FCL==4) & sep_child==.
tab sep_child 

set matsize 800
mi set flong


mi register imputed eth_final sep_child  hdl_final lipid_med_final wt

mi impute chained (regress) hdl_final wt (logit)  eth_final  lipid_med_final (mlogit) sep_child   = sex##cat_dur_ob_5_v2 cohort age_follow_up_final sex##obese_yes tot_duration_ob auc30 auc30_adj, rseed(123) force augment add(30)
mi passive: gen low_hdl=.
mi passive: replace low_hdl=1 if (hdl_final<1.29 & sex1==1) | (lipid_med_final==1 & sex1==1 & lipid_med_final<.)
mi passive: replace low_hdl=0 if (hdl_final>=1.29 & hdl_final<.) & sex1==1 & lipid_med_final==0
mi passive: replace low_hdl=1 if hdl_final<1.03 & sex1==0 | (lipid_med_final==1 & sex1==0 & lipid_med_final<.)
mi passive: replace low_hdl=0 if (hdl_final>=1.03 & hdl_final<.) & sex1==0 & lipid_med_final==0
save "imputed dataset_low_hdl_sex_int", replace
use "imputed dataset_low_hdl_sex_int", clear


*covars + obesity severity
mi estimate,  eform: glm low_hdl i.obese_yes##sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, fam(poisson) link(log) nolog vce(robust)
mi test 1.sex#1.obese_yes
mi estimate,  eform: glm low_hdl i.cat_dur_ob_5_v2##sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, fam(poisson) link(log) nolog vce(robust)
replace cat_dur_ob_5_v2=. if obese_yes==0
mi estimate(obese_cat_female:_b[cat_dur_ob_5_v2] + _b[1.sex1#c.cat_dur_ob_5_v2]), coeflegend: glm low_hdl c.cat_dur_ob_5_v2##i.sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, fam(poisson) link(log) nolog eform vce(robust)
mi testtransform obese_cat_female



***High HbA1c
use "dataset for imputation.dta", clear
keep if target_sample==1
drop ln_hdl_final ln_trig_final ln_hba1c_final ln_hdlt_final ln_trigt_final ln_hba1ct_final ln_hdlt_final_v2 ln_trigt_final_v2 ln_hba1ct_final_v2 sbpt_final_v2 dbpt_final_v2

gen sep_child=.
replace sep_child= 1 if (rgclass70==1 | rgclass70==2 | NCDS2FCL==1 | NCDS2FCL==2 | BCS3FCL==1 | BCS3FCL==2) 
replace sep_child= 2 if (rgclass70==5 | rgclass70==6 | NCDS2FCL==5 | NCDS2FCL==6 | BCS3FCL==5 | BCS3FCL==6) 
replace sep_child= 0 if (rgclass70==3 | rgclass70==4 | NCDS2FCL==3 | NCDS2FCL==4 | BCS3FCL==3 | BCS3FCL==4) & sep_child==.
tab sep_child 
wridit sep_child , gen( sep_child_ridit)

gen high_hba1c =.
replace high_hba1c=1 if hba1c_final>=5.7 & hba1c_final<. | (diab_med_final==1 & diab_med_final<.)
replace high_hba1c=0 if hba1c_final<5.7 &  diab_med_final==0


set matsize 800
mi set flong

mi register imputed eth_final sep_child high_hba1c wt
mi impute chained (regress)  wt  (logit) eth_final high_hba1c (mlogit) sep_child   = sex##cat_dur_ob_5_v2 cohort age_follow_up_final sex##obese_yes tot_duration_ob auc30 auc30_adj, rseed(123) force augment add(40)

//save "high_hba1c_imputed_dataset.dta", replace
save "high_hba1c_imputed_dataset40_sex_int.dta", replace
use "high_hba1c_imputed_dataset40_sex_int.dta", clear

*covars + obesity severity
mi estimate,  eform: glm high_hba1c i.obese_yes##sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, fam(poisson) link(log) nolog vce(robust)
mi test 1.sex#1.obese_yes
mi estimate,  eform: glm high_hba1c i.cat_dur_ob_5_v2##sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, fam(poisson) link(log) nolog vce(robust)
replace cat_dur_ob_5_v2=. if obese_yes==0
mi estimate(obese_cat_female:_b[cat_dur_ob_5_v2] + _b[1.sex1#c.cat_dur_ob_5_v2]), coeflegend: glm high_hba1c c.cat_dur_ob_5_v2##i.sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, fam(poisson) link(log) nolog eform vce(robust)
mi testtransform obese_cat_female



