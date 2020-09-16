/***Re-doing analysis based on Multiple imputation of SEP/bwt/eth


*******************************************************************************/
cd "C:\Users\pstn4\Dropbox\PLOS Med"

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


log using "imputed analysis", replace
mi register imputed sbpt_final dbpt_final hba1ct_final ln_trigt_final ln_hdlt_final  wt eth eth_final sep_child 
mi impute chained (regress) sbpt_final dbpt_final hba1ct_final ln_trigt_final ln_hdlt_final wt (logit)  eth_final   (mlogit) sep_child   = sex cat_dur_ob_5_v2 cohort age_follow_up_final obese_yes tot_duration_ob auc30 auc30_adj, rseed(123) force augment add(50)

mi passive: gen sbpt_final_v2= (ln(sbpt_final))*100
mi passive: gen dbpt_final_v2= (ln(dbpt_final))*100
mi passive: gen hdlt_final_v2= ln_hdlt_final*100
mi passive: gen trigt_final_v2= ln_trigt_final*100
mi passive: gen hba1ct_final_v2= (ln(hba1ct_final))*100

save "imputed dataset_continuous", replace
use "imputed dataset_continuous", clear

***Unadjusted
*SBP
mi estimate: regress sbpt_final_v2 i.obese_yes , vce(robust)
mi estimate: regress sbpt_final_v2 i.cat_dur_ob_5_v2, vce(robust)

***DBP 
mi estimate: regress dbpt_final_v2 i.obese_yes, vce(robust)
mi estimate: regress dbpt_final_v2 i.cat_dur_ob_5_v2, vce(robust)

***HDL 
mi estimate: regress hdlt_final_v2 i.obese_yes, vce(robust)
mi estimate: regress hdlt_final_v2 i.cat_dur_ob_5_v2, vce(robust)

***hbA1c 
mi estimate: regress hba1ct_final_v2 i.obese_yes, vce(robust)
mi estimate: regress hba1ct_final_v2 i.cat_dur_ob_5_v2, vce(robust)

replace cat_dur_ob_5_v2=. if obese_yes==0
mi estimate: regress sbpt_final_v2 cat_dur_ob_5_v2, vce(robust)
mi estimate: regress dbpt_final_v2 cat_dur_ob_5_v2, vce(robust)
mi estimate: regress hdlt_final_v2 cat_dur_ob_5_v2, vce(robust)
mi estimate: regress hba1ct_final_v2 cat_dur_ob_5_v2, vce(robust)



***Adjusted for COVARS ONLY
***SBP 
mi estimate, saving(miestfile_sbp_ob_yes) esample(misample_sbp_ob_yes): regress sbpt_final_v2 i.obese_yes sex i.cohort age_follow_up_final eth_final wt i.sep_child, vce(robust)
mimrgns using miestfile_sbp_ob_yes , esample(misample_sbp_ob_yes) cmdmargins dydx(obese_yes)  vsquish post
parmest, format(estimate min95 max95 %8.2f p %8.1e) saving(sbp_ob_yes_dastaset.dta)
*parmtest exports the coefficients from each model into new dataset, whihc i then append - SEE "revised figs with coef of infant weight change at different centiles of efw vars_v4.do"
mi estimate, saving(miestfile_sbp_ob_cat) esample(misample_sbp_ob_cat): regress sbpt_final_v2 i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child, vce(robust)
mimrgns using miestfile_sbp_ob_cat , esample(misample_sbp_ob_cat) cmdmargins dydx(cat_dur_ob_5_v2)  vsquish post
parmest, format(estimate min95 max95 %8.2f p %8.1e) saving(sbp_ob_cat_dastaset.dta)


***DBP 
mi estimate, saving(miestfile_dbp_ob_yes) esample(misample_dbp_ob_yes): regress dbpt_final_v2 i.obese_yes sex i.cohort age_follow_up_final eth_final wt i.sep_child, vce(robust)
mimrgns using miestfile_dbp_ob_yes , esample(misample_dbp_ob_yes) cmdmargins dydx(obese_yes)  vsquish post
parmest, format(estimate min95 max95 %8.2f p %8.1e) saving(dbp_ob_yes_dastaset.dta)
*parmtest exports the coefficients from each model into new dataset, whihc i then append - SEE "revised figs with coef of infant weight change at different centiles of efw vars_v4.do"
mi estimate, saving(miestfile_dbp_ob_cat) esample(misample_dbp_ob_cat): regress dbpt_final_v2 i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child, vce(robust)
mimrgns using miestfile_dbp_ob_cat , esample(misample_dbp_ob_cat) cmdmargins dydx(cat_dur_ob_5_v2)  vsquish post
parmest, format(estimate min95 max95 %8.2f p %8.1e) saving(dbp_ob_cat_dastaset.dta)


***HDL 
mi estimate, saving(miestfile_hdl_ob_yes) esample(misample_hdl_ob_yes): regress hdlt_final_v2 i.obese_yes sex i.cohort age_follow_up_final eth_final wt i.sep_child, vce(robust)
mimrgns using miestfile_hdl_ob_yes , esample(misample_hdl_ob_yes) cmdmargins dydx(obese_yes)  vsquish post
parmest, format(estimate min95 max95 %8.2f p %8.1e) saving(hdl_ob_yes_dastaset.dta)
*parmtest exports the coefficients from each model into new dataset, whihc i then append - SEE "revised figs with coef of infant weight change at different centiles of efw vars_v4.do"
mi estimate, saving(miestfile_hdl_ob_cat) esample(misample_hdl_ob_cat): regress hdlt_final_v2 i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child, vce(robust)
mimrgns using miestfile_hdl_ob_cat , esample(misample_hdl_ob_cat) cmdmargins dydx(cat_dur_ob_5_v2)  vsquish post
parmest, format(estimate min95 max95 %8.2f p %8.1e) saving(hdl_ob_cat_dastaset.dta)


***hbA1c 
mi estimate, saving(miestfile_hba1c_ob_yes) esample(misample_hba1c_ob_yes): regress hba1ct_final_v2 i.obese_yes sex i.cohort age_follow_up_final eth_final wt i.sep_child, vce(robust)
mimrgns using miestfile_hba1c_ob_yes , esample(misample_hba1c_ob_yes) cmdmargins dydx(obese_yes)  vsquish post
parmest, format(estimate min95 max95 %8.2f p %8.1e) saving(hba1c_ob_yes_dastaset.dta)
*parmtest exports the coefficients from each model into new dataset, whihc i then append - SEE "revised figs with coef of infant weight change at different centiles of efw vars_v4.do"
mi estimate, saving(miestfile_hba1c_ob_cat) esample(misample_hba1c_ob_cat): regress hba1ct_final_v2 i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child, vce(robust)
mimrgns using miestfile_hba1c_ob_cat , esample(misample_hba1c_ob_cat) cmdmargins dydx(cat_dur_ob_5_v2)  vsquish post
parmest, format(estimate min95 max95 %8.2f p %8.1e) saving(hba1c_ob_cat_dastaset.dta)


***Adjusted for COVARS AND SEVERITY
***SBP 
mi estimate, saving(miestfile_sbp_ob_yes_auc) esample(misample_sbp_ob_yes_auc): regress sbpt_final_v2 i.obese_yes sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)
mimrgns using miestfile_sbp_ob_yes_auc , esample(misample_sbp_ob_yes_auc) cmdmargins dydx(obese_yes)  vsquish post
parmest, format(estimate min95 max95 %8.2f p %8.1e) saving(sbp_ob_yes_dastaset_auc.dta)
*parmtest exports the coefficients from each model into new dataset, whihc i then append - SEE "revised figs with coef of infant weight change at different centiles of efw vars_v4.do"
mi estimate, saving(miestfile_sbp_ob_cat_auc) esample(misample_sbp_ob_cat_auc): regress sbpt_final_v2 i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)
mimrgns using miestfile_sbp_ob_cat_auc , esample(misample_sbp_ob_cat_auc) cmdmargins dydx(cat_dur_ob_5_v2)  vsquish post
parmest, format(estimate min95 max95 %8.2f p %8.1e) saving(sbp_ob_cat_dastaset_auc.dta)


***DBP 
mi estimate, saving(miestfile_dbp_ob_yes_auc) esample(misample_dbp_ob_yes_auc): regress dbpt_final_v2 i.obese_yes sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)
mimrgns using miestfile_dbp_ob_yes_auc , esample(misample_dbp_ob_yes_auc) cmdmargins dydx(obese_yes)  vsquish post
parmest, format(estimate min95 max95 %8.2f p %8.1e) saving(dbp_ob_yes_dastaset_auc.dta)
*parmtest exports the coefficients from each model into new dataset, whihc i then append - SEE "revised figs with coef of infant weight change at different centiles of efw vars_v4.do"
mi estimate, saving(miestfile_dbp_ob_cat_auc) esample(misample_dbp_ob_cat_auc): regress dbpt_final_v2 i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)
mimrgns using miestfile_dbp_ob_cat_auc , esample(misample_dbp_ob_cat_auc) cmdmargins dydx(cat_dur_ob_5_v2)  vsquish post
parmest, format(estimate min95 max95 %8.2f p %8.1e) saving(dbp_ob_cat_dastaset_auc.dta)


***HDL 
mi estimate, saving(miestfile_hdl_ob_yes_auc) esample(misample_hdl_ob_yes_auc): regress hdlt_final_v2 i.obese_yes sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)
mimrgns using miestfile_hdl_ob_yes_auc , esample(misample_hdl_ob_yes_auc) cmdmargins dydx(obese_yes)  vsquish post
parmest, format(estimate min95 max95 %8.2f p %8.1e) saving(hdl_ob_yes_dastaset_auc.dta)
*parmtest exports the coefficients from each model into new dataset, whihc i then append - SEE "revised figs with coef of infant weight change at different centiles of efw vars_v4.do"
mi estimate, saving(miestfile_hdl_ob_cat_auc) esample(misample_hdl_ob_cat_auc): regress hdlt_final_v2 i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)
mimrgns using miestfile_hdl_ob_cat_auc , esample(misample_hdl_ob_cat_auc) cmdmargins dydx(cat_dur_ob_5_v2)  vsquish post
parmest, format(estimate min95 max95 %8.2f p %8.1e) saving(hdl_ob_cat_dastaset_auc.dta)


***hbA1c 
mi estimate, saving(miestfile_hba1c_ob_yes_auc) esample(misample_hba1c_ob_yes_auc): regress hba1ct_final_v2 i.obese_yes sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)
mimrgns using miestfile_hba1c_ob_yes_auc , esample(misample_hba1c_ob_yes_auc) cmdmargins dydx(obese_yes)  vsquish post
parmest, format(estimate min95 max95 %8.2f p %8.1e) saving(hba1c_ob_yes_dastaset_auc.dta)
*parmtest exports the coefficients from each model into new dataset, whihc i then append - SEE "revised figs with coef of infant weight change at different centiles of efw vars_v4.do"
mi estimate, saving(miestfile_hba1c_ob_cat_auc) esample(misample_hba1c_ob_cat_auc): regress hba1ct_final_v2 i.cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)
mimrgns using miestfile_hba1c_ob_cat_auc , esample(misample_hba1c_ob_cat_auc) cmdmargins dydx(cat_dur_ob_5_v2)  vsquish post
parmest, format(estimate min95 max95 %8.2f p %8.1e) saving(hba1c_ob_cat_dastaset_auc.dta)

***linear trend
replace cat_dur_ob_5_v2=. if obese_yes==0
mi estimate: regress sbpt_final_v2 cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child, vce(robust)
mi estimate: regress dbpt_final_v2 cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child, vce(robust)
mi estimate: regress hdlt_final_v2 cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child, vce(robust)
mi estimate: regress trigt_final_v2 cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child, vce(robust)
mi estimate: regress hba1ct_final_v2 cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child, vce(robust)
mi estimate: regress sbpt_final_v2 cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)
mi estimate: regress dbpt_final_v2 cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)
mi estimate: regress hdlt_final_v2 cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)
mi estimate: regress trigt_final_v2 cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)
mi estimate: regress hba1ct_final_v2 cat_dur_ob_5_v2 sex i.cohort age_follow_up_final eth_final wt i.sep_child auc30_adj, vce(robust)


log close


**********************Categorical outcome variables*****************************
*see separae do file 'redoing based on imputed data_cat only.do'


  

