/***Re-doing analysis based on Multiple imputation of SEP/bwt/eth

*******************************************************************************/
cd "C:\Users\pstn4\Dropbox\PLOS Med"

*********************************HYPERTENSION
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

mi impute chained (regress) sbp_final dbp_final wt (logit)  eth_final  bp_med_final (mlogit) sep_child   = sex cat_dur_ob_5_v2 cohort age_follow_up_final obese_yes tot_duration_ob auc30 auc30_adj, rseed(123) force augment add(30)
mi passive: gen hypertension=.
mi passive: replace hypertension=1 if (sbp_final>=140 ) | (dbp_final>=90 ) | (bp_med_final==1 ) 
mi passive: replace hypertension=0 if sbp_final<140 & dbp_final<90 & bp_med_final==0
save "imputed dataset_hypertension", replace
use "imputed dataset_hypertension", clear

tab obese_yes if _mi_m==0
tab cat_dur_ob_5_v2 if _mi_m==0
mi estimate, post: proportion hypertension, over(obese_yes)
mi estimate, post: proportion hypertension, over(cat_dur_ob_5_v2)

*unadj
mi estimate,  eform: glm hypertension i.obese_yes , fam(poisson) link(log) nolog vce(robust)
mi estimate, eform: glm hypertension i.cat_dur_ob_5_v2  , fam(poisson) link(log) nolog vce(robust)

*covars only
mi estimate, saving(miestfile_hyp_ob_yes) esample(misample_hyp_ob_yes) eform: glm hypertension i.obese_yes sex i.cohort age_follow_up_final eth_final wt i.sep_child , fam(poisson) link(log) nolog vce(robust)
mimrgns using miestfile_hyp_ob_yes , esample(misample_hyp_ob_yes) cmdmargins dydx(obese_yes)  vsquish post
parmest, format(estimate min95 max95 %8.2f p %8.1e) saving(hyp_ob_yes_dataset.dta)
mi estimate, saving(miestfile_hyp_ob_cat) esample(misample_hyp_ob_cat) eform: glm hypertension i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child , fam(poisson) link(log) nolog vce(robust)
mimrgns using miestfile_hyp_ob_cat , esample(misample_hyp_ob_cat) cmdmargins dydx(cat_dur_ob_5_v2)  vsquish post
parmest, format(estimate min95 max95 %8.2f p %8.1e) saving(hyp_ob_cat_dataset.dta)

*covars + obesity severity
mi estimate, saving(miestfile_hyp_ob_yes_auc) esample(misample_hyp_ob_yes_auc) eform: glm hypertension i.obese_yes sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, fam(poisson) link(log) nolog vce(robust)
mimrgns using miestfile_hyp_ob_yes_auc , esample(misample_hyp_ob_yes_auc) cmdmargins dydx(obese_yes)  vsquish post
parmest, format(estimate min95 max95 %8.2f p %8.1e) saving(hyp_ob_yes_dataset_auc.dta)
mi estimate, saving(miestfile_hyp_ob_cat_auc) esample(misample_hyp_ob_cat_auc) eform: glm hypertension i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, fam(poisson) link(log) nolog vce(robust)
mimrgns using miestfile_hyp_ob_cat_auc , esample(misample_hyp_ob_cat_auc) cmdmargins dydx(cat_dur_ob_5_v2)  vsquish post
parmest, format(estimate min95 max95 %8.2f p %8.1e) saving(hyp_ob_cat_dataset_auc.dta)

***linear trend
replace cat_dur_ob_5_v2=. if obese_yes==0
mi estimate: glm hypertension cat_dur_ob_5_v2 , fam(poisson) link(log) nolog eform vce(robust)
mi estimate: glm hypertension cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child, fam(poisson) link(log) nolog eform vce(robust)
mi estimate: glm hypertension cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, fam(poisson) link(log) nolog eform vce(robust)



********************************************LOW HDL
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

mi impute chained (regress) hdl_final wt (logit)  eth_final  lipid_med_final (mlogit) sep_child   = sex cat_dur_ob_5_v2 cohort age_follow_up_final obese_yes tot_duration_ob auc30 auc30_adj, rseed(123) force augment add(30)
mi passive: gen low_hdl=.
mi passive: replace low_hdl=1 if (hdl_final<1.29 & sex1==1) | (lipid_med_final==1 & sex1==1 & lipid_med_final<.)
mi passive: replace low_hdl=0 if (hdl_final>=1.29 & hdl_final<.) & sex1==1 & lipid_med_final==0
mi passive: replace low_hdl=1 if hdl_final<1.03 & sex1==0 | (lipid_med_final==1 & sex1==0 & lipid_med_final<.)
mi passive: replace low_hdl=0 if (hdl_final>=1.03 & hdl_final<.) & sex1==0 & lipid_med_final==0
save "imputed dataset_low_hdl", replace
use "imputed dataset_low_hdl", clear

tab obese_yes if _mi_m==0
tab cat_dur_ob_5_v2 if _mi_m==0
mi estimate, post: proportion low_hdl, over(obese_yes)
mi estimate, post: proportion low_hdl, over(cat_dur_ob_5_v2)

*unadj
mi estimate,  eform: glm low_hdl i.obese_yes , fam(poisson) link(log) nolog vce(robust)
mi estimate, eform: glm low_hdl i.cat_dur_ob_5_v2  , fam(poisson) link(log) nolog vce(robust)


*covars only
mi estimate, saving(miestfile_low_hdl_ob_yes) esample(misample_low_hdl_ob_yes) eform: glm low_hdl i.obese_yes sex i.cohort age_follow_up_final eth_final wt i.sep_child, fam(poisson) link(log) nolog vce(robust)
mimrgns using miestfile_low_hdl_ob_yes , esample(misample_low_hdl_ob_yes) cmdmargins dydx(obese_yes)  vsquish post
parmest, format(estimate min95 max95 %8.2f p %8.1e) saving(low_hdl_ob_yes_dataset.dta)
mi estimate, saving(miestfile_low_hdl_ob_cat) esample(misample_low_hdl_ob_cat) eform: glm low_hdl i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child , fam(poisson) link(log) nolog vce(robust)
mimrgns using miestfile_low_hdl_ob_cat , esample(misample_low_hdl_ob_cat) cmdmargins dydx(cat_dur_ob_5_v2)  vsquish post
parmest, format(estimate min95 max95 %8.2f p %8.1e) saving(low_hdl_ob_cat_dataset.dta)

*covars + obesity severity
mi estimate, saving(miestfile_low_hdl_ob_yes_auc) esample(misample_low_hdl_ob_yes_auc) eform: glm low_hdl i.obese_yes sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, fam(poisson) link(log) nolog vce(robust)
mimrgns using miestfile_low_hdl_ob_yes_auc , esample(misample_low_hdl_ob_yes_auc) cmdmargins dydx(obese_yes)  vsquish post
parmest, format(estimate min95 max95 %8.2f p %8.1e) saving(low_hdl_ob_yes_dataset_auc.dta)
mi estimate, saving(miestfile_low_hdl_ob_cat_auc) esample(misample_low_hdl_ob_cat_auc) eform: glm low_hdl i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, fam(poisson) link(log) nolog vce(robust)
mimrgns using miestfile_low_hdl_ob_cat_auc , esample(misample_low_hdl_ob_cat_auc) cmdmargins dydx(cat_dur_ob_5_v2)  vsquish post
parmest, format(estimate min95 max95 %8.2f p %8.1e) saving(low_hdl_ob_cat_dataset_auc.dta)

***linear trend
replace cat_dur_ob_5_v2=. if obese_yes==0
mi estimate: glm low_hdl cat_dur_ob_5_v2, fam(poisson) link(log) nolog eform vce(robust)
mi estimate: glm low_hdl cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child, fam(poisson) link(log) nolog eform vce(robust)
mi estimate: glm low_hdl cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, fam(poisson) link(log) nolog eform vce(robust)



****************************HIGH HBA1C
///gen high_hba1c =.
///replace high_hba1c=1 if hba1c_final>=5.7 & hba1c_final<. | (diab_med_final==1 & diab_med_final<.)
///replace high_hba1c=0 if hba1c_final<5.7 &  diab_med_final==0

use "dataset for imputation.dta", clear
keep if target_sample==1
drop ln_hdl_final ln_trig_final ln_hba1c_final ln_hdlt_final ln_trigt_final ln_hba1ct_final ln_hdlt_final_v2 ln_trigt_final_v2 ln_hba1ct_final_v2 sbpt_final_v2 dbpt_final_v2
*the above vars will be passive imputed

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
mi impute chained (regress)  wt  (logit) eth_final high_hba1c (mlogit) sep_child   = sex cat_dur_ob_5_v2 cohort age_follow_up_final obese_yes tot_duration_ob auc30 auc30_adj, rseed(123) force augment add(40)

//save "high_hba1c_imputed_dataset.dta", replace
save "high_hba1c_imputed_dataset40.dta", replace
use "high_hba1c_imputed_dataset40.dta", clear

tab obese_yes if _mi_m==0
tab cat_dur_ob_5_v2 if _mi_m==0
mi estimate, post: proportion high_hba1c, over(obese_yes)
mi estimate, post: proportion high_hba1c, over(cat_dur_ob_5_v2)

*unadj
mi estimate,  eform: glm high_hba1c i.obese_yes , fam(poisson) link(log) nolog vce(robust)
mi estimate, eform: glm high_hba1c i.cat_dur_ob_5_v2  , fam(poisson) link(log) nolog vce(robust)


*covars only
mi estimate, saving(miestfile_high_hba1c_ob_yes) esample(misample_high_hba1c_ob_yes) eform: glm high_hba1c i.obese_yes sex i.cohort age_follow_up_final eth_final wt i.sep_child , fam(poisson) link(log) nolog vce(robust)
mimrgns using miestfile_high_hba1c_ob_yes , esample(misample_high_hba1c_ob_yes) cmdmargins dydx(obese_yes)  vsquish post
parmest, format(estimate min95 max95 %8.2f p %8.1e) saving(high_hba1c_ob_yes_dataset.dta)
mi estimate, saving(miestfile_high_hba1c_ob_cat) esample(misample_high_hba1c_ob_cat) eform: glm high_hba1c i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child , fam(poisson) link(log) nolog vce(robust)
mimrgns using miestfile_high_hba1c_ob_cat , esample(misample_high_hba1c_ob_cat) cmdmargins dydx(cat_dur_ob_5_v2)  vsquish post
parmest, format(estimate min95 max95 %8.2f p %8.1e) saving(high_hba1c_ob_cat_dataset.dta)

*covars + obesity severity
mi estimate, saving(miestfile_high_hba1c_ob_yes_auc) esample(misample_high_hba1c_ob_yes_auc) eform: glm high_hba1c i.obese_yes sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, fam(poisson) link(log) nolog vce(robust)
mimrgns using miestfile_high_hba1c_ob_yes_auc , esample(misample_high_hba1c_ob_yes_auc) cmdmargins dydx(obese_yes)  vsquish post
parmest, format(estimate min95 max95 %8.2f p %8.1e) saving(high_hba1c_ob_yes_dataset_auc.dta)
mi estimate, saving(miestfile_high_hba1c_ob_cat_auc) esample(misample_high_hba1c_ob_cat_auc) eform: glm high_hba1c i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, fam(poisson) link(log) nolog vce(robust)
mimrgns using miestfile_high_hba1c_ob_cat_auc , esample(misample_high_hba1c_ob_cat_auc) cmdmargins dydx(cat_dur_ob_5_v2)  vsquish post
parmest, format(estimate min95 max95 %8.2f p %8.1e) saving(high_hba1c_ob_cat_dataset_auc.dta)


***linear trend
replace cat_dur_ob_5_v2=. if obese_yes==0
mi estimate: glm high_hba1c cat_dur_ob_5_v2 , fam(poisson) link(log) nolog eform vce(robust)
mi estimate: glm high_hba1c cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child, fam(poisson) link(log) nolog eform vce(robust)
**p<0.001
mi estimate: glm high_hba1c cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, fam(poisson) link(log) nolog eform vce(robust)
**p=0.006


*************************************HIGH TRIG

*linear trend
mi estimate: regress high_trig cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child, vce(robust)
mi estimate: regress high_trig cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)




