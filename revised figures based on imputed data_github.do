***revised figures based on imputed data
cd "C:\Users\pstn4\Dropbox\PLOS Med"


***SBP
use "sbp_ob_yes_dastaset", clear
append using "sbp_ob_cat_dastaset"
append using "sbp_ob_yes_dastaset_auc"
append using "sbp_ob_cat_dastaset_auc"

gen model=0 if _n<9
replace model=1 if _n>8
sort model
bys model: gen n=_n
reshape wide parm estimate stderr dof t p min95 max95, i(n) j(model)
replace n=n+1 if _n>2
clonevar n_minus= n
replace n_minus=n-0.1
clonevar n_plus=n 
replace n_plus=n+0.1

twoway scatter estimate0 n_minus, mfcolor(gs7) mlcolor(gs7)   || scatter estimate1 n_plus, mfcolor(gs13) mlcolor(gs13)  || rcap min950 max950 n_minus, lcolor(gs7)  || rcap min951 max951 n_plus, lcolor(gs13) ///
xlabel(1 "Never Obese (ref)" 2 "Ever Obese" 4 "Never Obese (ref)" 5 "Obese<5 years" 6 "Obese 5-10 years" 7 "Obese 10-15 years" 8 "Obese 15-20 years" 9 "Obese 20-30 years", angle(50) labsize(small) ) ///
graphregion(color(white) ) ylabel(0 (5) 30, format(%12.0f) labsize(small) nogrid) yline(0, lcolor(black)   lpattern(dash)) legend(on order(- "{bf:model 1}" - - - - - - - "{bf:model 2}")  rows(1) pos(7) ring(100) nobox  region(style(none)) )   xline(3, lcolor(black*0.5) lpattern(dash)) ytitle("Percentage difference in SBP", size(small)) ///
saving("sbp_mut_adj_imput.gph", replace)  


***DBP
use "dbp_ob_yes_dastaset", clear
append using "dbp_ob_cat_dastaset"
append using "dbp_ob_yes_dastaset_auc"
append using "dbp_ob_cat_dastaset_auc"

gen model=0 if _n<9
replace model=1 if _n>8
sort model
bys model: gen n=_n
reshape wide parm estimate stderr dof t p min95 max95, i(n) j(model)
replace n=n+1 if _n>2
clonevar n_minus= n
replace n_minus=n-0.1
clonevar n_plus=n 
replace n_plus=n+0.1

twoway scatter estimate0 n_minus, mfcolor(gs7) mlcolor(gs7)   || scatter estimate1 n_plus, mfcolor(gs13) mlcolor(gs13)  || rcap min950 max950 n_minus, lcolor(gs7)  || rcap min951 max951 n_plus, lcolor(gs13) ///
xlabel(1 "Never Obese (ref)" 2 "Ever Obese" 4 "Never Obese (ref)" 5 "Obese<5 years" 6 "Obese 5-10 years" 7 "Obese 10-15 years" 8 "Obese 15-20 years" 9 "Obese 20-30 years", angle(50) labsize(small) ) ///
graphregion(color(white) )  ylabel(0 (5) 30, format(%12.0f) labsize(small) nogrid) yline(0, lcolor(black)  lpattern(dash)) legend(on order(- "{bf:model 1}" - - - - - - - "{bf:model 2}")  rows(1) pos(7) ring(100) nobox  region(style(none)) )   xline(3, lcolor(black*0.5) lpattern(dash)) ytitle("Percentage difference in DBP", size(small))   ///
saving("dbp_mut_adj_imput.gph", replace)  


***HDL
use "hdl_ob_yes_dastaset", clear
append using "hdl_ob_cat_dastaset"
append using "hdl_ob_yes_dastaset_auc"
append using "hdl_ob_cat_dastaset_auc"

gen model=0 if _n<9
replace model=1 if _n>8
sort model
bys model: gen n=_n
reshape wide parm estimate stderr dof t p min95 max95, i(n) j(model)
replace n=n+1 if _n>2
clonevar n_minus= n
replace n_minus=n-0.1
clonevar n_plus=n 
replace n_plus=n+0.1

twoway scatter estimate0 n_minus, mfcolor(gs7) mlcolor(gs7)   || scatter estimate1 n_plus, mfcolor(gs13) mlcolor(gs13)  || rcap min950 max950 n_minus, lcolor(gs7)  || rcap min951 max951 n_plus, lcolor(gs13) ///
xlabel(1 "Never Obese (ref)" 2 "Ever Obese" 4 "Never Obese (ref)" 5 "Obese<5 years" 6 "Obese 5-10 years" 7 "Obese 10-15 years" 8 "Obese 15-20 years" 9 "Obese 20-30 years", angle(50) labsize(small) ) ///
graphregion(color(white) )  ylabel(0 (5) -30, format(%12.0f) labsize(small) nogrid) yline(0, lcolor(black)  lpattern(dash)) legend(on order(- "{bf:model 1}" - - - - - - - "{bf:model 2}")  rows(1) pos(7) ring(100) nobox  region(style(none)) )   xline(3, lcolor(black*0.5) lpattern(dash)) ytitle("Percentage difference in HDL", size(small))   ///
saving("hdl_mut_adj_imput.gph", replace)  


***HbA1c
use "hba1c_ob_yes_dastaset", clear
append using "hba1c_ob_cat_dastaset"
append using "hba1c_ob_yes_dastaset_auc"
append using "hba1c_ob_cat_dastaset_auc"

gen model=0 if _n<9
replace model=1 if _n>8
sort model
bys model: gen n=_n
reshape wide parm estimate stderr dof t p min95 max95, i(n) j(model)
replace n=n+1 if _n>2
clonevar n_minus= n
replace n_minus=n-0.1
clonevar n_plus=n 
replace n_plus=n+0.1

twoway scatter estimate0 n_minus, mfcolor(gs7) mlcolor(gs7)   || scatter estimate1 n_plus, mfcolor(gs13) mlcolor(gs13)  || rcap min950 max950 n_minus, lcolor(gs7)  || rcap min951 max951 n_plus, lcolor(gs13) ///
xlabel(1 "Never Obese (ref)" 2 "Ever Obese" 4 "Never Obese (ref)" 5 "Obese<5 years" 6 "Obese 5-10 years" 7 "Obese 10-15 years" 8 "Obese 15-20 years" 9 "Obese 20-30 years", angle(50) labsize(small) ) ///
graphregion(color(white) )  ylabel(0 (5) 30, format(%12.0f) labsize(small) nogrid) yline(0, lcolor(black) lpattern(dash)) legend(on order(- "{bf:model 1}" - - - - "{bf:model 2}")  rows(1) pos(7) ring(100) nobox  region(style(none)) )   xline(3, lcolor(black*0.5) lpattern(dash)) ytitle("Percentage difference in HbA1c", size(small))   ///
saving("hba1c_mut_adj_imput.gph", replace)  


***Hypertension
use "hyp_ob_yes_dataset", clear
append using "hyp_ob_cat_dataset"
append using "hyp_ob_yes_dataset_auc"
append using "hyp_ob_cat_dataset_auc"
replace estimate=exp(estimate)
replace min95=exp(min95)
replace max95=exp(max95)

gen model=0 if _n<9
replace model=1 if _n>8
sort model
bys model: gen n=_n
reshape wide parm estimate stderr dof t p min95 max95, i(n) j(model)
replace n=n+1 if _n>2
clonevar n_minus= n
replace n_minus=n-0.1
clonevar n_plus=n 
replace n_plus=n+0.1

twoway scatter estimate0 n_minus, mfcolor(gs7) mlcolor(gs7)   || scatter estimate1 n_plus, mfcolor(gs13) mlcolor(gs13)  || rcap min950 max950 n_minus, lcolor(gs7)  || rcap min951 max951 n_plus, lcolor(gs13) ///
xlabel(1 "Never Obese (ref)" 2 "Ever Obese" 4 "Never Obese (ref)" 5 "Obese<5 years" 6 "Obese 5-10 years" 7 "Obese 10-15 years" 8 "Obese 15-20 years" 9 "Obese 20-30 years", angle(50) labsize(small) ) ///
graphregion(color(white) )   ylabel(1 (1) 4, format(%12.0f) labsize(small) nogrid) yline(1, lcolor(black) lpattern(dash)) legend(on order(- "{bf:model 1}" - - - - "{bf:model 2}")  rows(1) pos(7) ring(100) nobox  region(style(none)) )   xline(3, lcolor(black*0.5) lpattern(dash)) ytitle("Risk ratio for hypertension", size(small))  ///
saving("hypertension_mut_adj_imput.gph", replace)  


***Low HDL
use "low_hdl_ob_yes_dataset", clear
append using "low_hdl_ob_cat_dataset"
append using "low_hdl_ob_yes_dataset_auc"
append using "low_hdl_ob_cat_dataset_auc"
replace estimate=exp(estimate)
replace min95=exp(min95)
replace max95=exp(max95)

gen model=0 if _n<9
replace model=1 if _n>8
sort model
bys model: gen n=_n
reshape wide parm estimate stderr dof t p min95 max95, i(n) j(model)
replace n=n+1 if _n>2
clonevar n_minus= n
replace n_minus=n-0.1
clonevar n_plus=n 
replace n_plus=n+0.1

twoway scatter estimate0 n_minus, mfcolor(gs7) mlcolor(gs7)   || scatter estimate1 n_plus, mfcolor(gs13) mlcolor(gs13)  || rcap min950 max950 n_minus, lcolor(gs7)  || rcap min951 max951 n_plus, lcolor(gs13) ///
xlabel(1 "Never Obese (ref)" 2 "Ever Obese" 4 "Never Obese (ref)" 5 "Obese<5 years" 6 "Obese 5-10 years" 7 "Obese 10-15 years" 8 "Obese 15-20 years" 9 "Obese 20-30 years", angle(50) labsize(small) ) ///
graphregion(color(white) )  ylabel(1 (1) 4, format(%12.0f) labsize(small) nogrid) yline(1, lcolor(black) lpattern(dash)) legend(on order(- "{bf:model 1}" - - - - "{bf:model 2}")  rows(1) pos(7) ring(100) nobox  region(style(none)) )   xline(3, lcolor(black*0.5) lpattern(dash)) ytitle("Risk ratio for low HDL-C", size(small))  ///
saving("low_hdl_mut_adj_imput.gph", replace)  


***High HbA1c
use "high_hba1c_ob_yes_dataset", clear
append using "high_hba1c_ob_cat_dataset"
append using "high_hba1c_ob_yes_dataset_auc"
append using "high_hba1c_ob_cat_dataset_auc"
replace estimate=exp(estimate)
replace min95=exp(min95)
replace max95=exp(max95)

gen model=0 if _n<9
replace model=1 if _n>8
sort model
bys model: gen n=_n
reshape wide parm estimate stderr dof t p min95 max95, i(n) j(model)
replace n=n+1 if _n>2
clonevar n_minus= n
replace n_minus=n-0.1
clonevar n_plus=n 
replace n_plus=n+0.1

twoway scatter estimate0 n_minus, mfcolor(gs7) mlcolor(gs7)   || scatter estimate1 n_plus, mfcolor(gs13) mlcolor(gs13)  || rcap min950 max950 n_minus, lcolor(gs7)  || rcap min951 max951 n_plus, lcolor(gs13) ///
xlabel(1 "Never Obese (ref)" 2 "Ever Obese" 4 "Never Obese (ref)" 5 "Obese<5 years" 6 "Obese 5-10 years" 7 "Obese 10-15 years" 8 "Obese 15-20 years" 9 "Obese 20-30 years", angle(50) labsize(small) ) ///
graphregion(color(white) )  ylabel(1 (1) 6, format(%12.0f) labsize(small) nogrid) yline(1, lcolor(black) lpattern(dash)) legend(on order(- "{bf:model 1}" - - - - "{bf:model 2}")  rows(1) pos(7) ring(100) nobox  region(style(none)) )   xline(3, lcolor(black*0.5) lpattern(dash)) ytitle("Risk ratio for elevated HbA1c", size(small))  ///
saving("high_hba1c_mut_adj_imput.gph", replace)  



***Graph combine for paper
graph combine "hba1c_mut_adj_imput.gph" "high_hba1c_mut_adj_imput.gph", graphregion(color(white))  altshrink saving("fig2 paper_imput.gph", replace)
graph export "fig2 paper_imput.tif"
//graph combine "C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\sbp_mut_adj_v2.gph" "C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\dbp_mut_adj_v2.gph" "C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\hdl_mut_adj_v2.gph" "C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\trig_mut_adj_v2.gph", graphregion(color(white)) iscale(*0.5) saving("C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\fig3 paper.gph", replace)
//graph export "C:\Users\pstn4\OneDrive - Loughborough University (1)\LBORO WORK\MHO work\Data\1946 biomedical\time_severity_obese\figs\coefplot\fig3 paper.tif"
graph combine "sbp_mut_adj_imput.gph" "dbp_mut_adj_imput.gph" "hdl_mut_adj_imput.gph", graphregion(color(white)) altshrink  saving("fig3 paper_no_trig_imput.gph", replace)
graph export "fig3 paper_no_trig_imput.tif", replace

graph combine "hypertension_mut_adj_imput.gph" "low_hdl_mut_adj_imput.gph", graphregion(color(white)) altshrink  saving("fig4 paper_no_trig_imput.gph", replace)
graph export "fig4 paper_no_trig_imput.tif", replace


