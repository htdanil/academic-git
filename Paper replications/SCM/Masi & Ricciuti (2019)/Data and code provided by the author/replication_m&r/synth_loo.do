******************************************************************************** 
****          OIL DISCOVERIES, DEMOCRACY AND STATE CAPACITY                 ****
********************************************************************************

clear
set more off
capture log close

/***************************************
			* synthetic control *
			   * polity *
			   
Robustness check - Excluding one control

* Treatment: discovery ASPO			   
* Outcome variable: polity_01 POLIITY IV
* Predictors: lrgdpepc PWT 8.1
			  hc  PWT 8.1
			  totalrents(1970(1)19??) WB  
			  manufacturing(1970(1)19??) UNCTAD
			  agrva(1970(1)19??) UNCTAD 
			  minva(1970(1)19??) UNCTAD
			  HostLev COW
			  open_pwt PWT 8.1
			  averaged outcome
			  
* Nested allopt
			  
****************************************/



***********************
** Brazil 76 - 1975  **
***********************

/*use data/oildiscomplete, clear

tsset country_id year

quietly log using output\brazil\synth\polity\excluding\bra_polro.log, replace

***  Brazil - polity_01 1975 ***

drop if treataspo==1 & country_id!=76

*drop if developing==0


drop if year<1965

foreach variable of varlist lrgdpepc hc totalrents manufacturing agrva minva open_pwt HostLev {
bysort country_id: egen `variable'mean = mean(`variable') if inrange(year, 1965, 1974)
gen `variable'missing=1 if `variable'mean==. & inrange(year, 1965, 1974)
bysort country_id: replace `variable'missing=`variable'missing[_n-1] if inrange(year, 1975, 2014)
}

gen ymissing=1 if polity_01==.

recode ymissing (.=0)

bysort country_id: egen ymean = mean(ymissing) 

bysort country_id: egen brameanpol=mean(polity_01) if inrange(year, 1965, 1974)

foreach variable of varlist lrgdpepcmissing hcmissing totalrentsmissing manufacturingmissing agrvamissing minvamissing open_pwtmissing HostLevmissing {
drop if `variable'==1 
}

drop if ymean!=0

*  Countries that received a positive weigth: Central African Republic 140 - Democratic Republic of Congo 180 - Morocco 504 - Portugal 620 *

synth polity_01 lrgdpepc hc totalrents manufacturing agrva minva open_pwt HostLev brameanpol, trunit(76) trperiod(1975) /*mspeperiod(1965(1)1974) xperiod(1965(1)1974) resultsperiod(1965(1)2014)*/  keep(output\brazil\synth\polity\excluding\bra_76, replace) nested allopt    


foreach code of numlist 140 180 504 620 {
preserve
drop if country_id==`code'
synth polity_01 lrgdpepc hc totalrents manufacturing agrva minva open_pwt HostLev brameanpol, trunit(76) trperiod(1975) /*mspeperiod(1965(1)1974) xperiod(1965(1)1974) resultsperiod(1965(1)2014)*/ keep(output\brazil\synth\polity\excluding\bra_`code', replace) nested allopt    
restore
}

clear 

foreach code of numlist 76 140 180 504 620 {
use output\brazil\synth\polity\excluding\bra_`code'
drop _Co_Number _W_Weight
drop if _time==.
save output\brazil\synth\polity\excluding\bra_`code',replace
clear
}


*/use data/placebo, clear


foreach code of numlist 76 140 180 504 620 {
merge 1:1 _time using output\brazil\synth\polity\excluding\bra_`code'
rename _Y_treated _Y_treated`code'
rename _Y_synthetic _Y_synthetic`code'
drop if _Y_treated`code'==.
drop if _Y_synthetic`code'==.
drop _merge
}

graph twoway (line _Y_synthetic* _time, lpattern(dot) sort) (line _Y_synthetic76 _time, lpattern(dash) sort) (line _Y_treated76 _time, sort  lwidth(thick) lcolor(black)), xline(1975, lpattern(dash)) /*legend(off)*/

graph save output\brazil\synth\polity\excluding\bra_loo, replace

*quietly log close


**************************
** Cameroon 120 - 1977  **
**************************

/*use data/oildiscomplete, clear

tsset country_id year

quietly log using output\cameroon\synth\polity\excluding\cam_pol01.log, replace

***  Cameroon - polity_01 ***

drop if treataspo==1 & country_id!=120

*drop if developing==0

drop if year<1967

foreach variable of varlist lrgdpepc hc totalrents manufacturing agrva minva open_pwt HostLev {
bysort country_id: egen `variable'mean = mean(`variable') if inrange(year, 1967, 1976)
gen `variable'missing=1 if `variable'mean==. & inrange(year, 1967, 1976)
bysort country_id: replace `variable'missing=`variable'missing[_n-1] if inrange(year, 1977, 2014)
}

gen ymissing=1 if polity_01==.

recode ymissing (.=0)

bysort country_id: egen ymean = mean(ymissing) 


bysort country_id: egen cammeanpol=mean(polity_01) if inrange(year, 1967, 1976)

foreach variable of varlist lrgdpepcmissing hcmissing totalrentsmissing manufacturingmissing agrvamissing minvamissing open_pwtmissing HostLevmissing {
drop if `variable'==1 
}

drop if ymean!=0



*  Countries that received a positive weigth: Benin 204 - Nepal 524 - Niger 562 - Paraguay 600 - Tanzania 834 - Uruguay 858 *

synth polity_01 lrgdpepc hc totalrents manufacturing agrva minva open_pwt HostLev cammeanpol , trunit(120) trperiod(1977) /*mspeperiod(1967(1)1976) xperiod(1967(1)1976) resultsperiod(1967(1)2014)*/ keep(output\cameroon\synth\polity\excluding\cam_120, replace) nested allopt    

foreach code of numlist 204 524 562 600 834 858 {
preserve
drop if country_id==`code'
synth polity_01 lrgdpepc hc totalrents manufacturing agrva minva open_pwt HostLev cammeanpol , trunit(120) trperiod(1977) /*mspeperiod(1967(1)1976) xperiod(1967(1)1976) resultsperiod(1967(1)2014)*/ keep(output\cameroon\synth\polity\excluding\cam_`code', replace) nested allopt    
restore
}

clear 

foreach code of numlist 120 204 524 562 600 834 858 {
use output\cameroon\synth\polity\excluding\cam_`code'
drop _Co_Number _W_Weight
drop if _time==.
save output\cameroon\synth\polity\excluding\cam_`code',replace
clear
}


*/use data/placebo, clear


foreach code of numlist 120 204 524 562 600 834 858 {
merge 1:1 _time using output\cameroon\synth\polity\excluding\cam_`code'
rename _Y_treated _Y_treated`code'
rename _Y_synthetic _Y_synthetic`code'
drop if _Y_treated`code'==.
drop if _Y_synthetic`code'==.
drop _merge
}

graph twoway (line _Y_synthetic* _time, lpattern(dot) sort) (line _Y_synthetic120 _time, lpattern(dash) sort) (line _Y_treated120 _time, sort  lwidth(thick) lcolor(black)), xline(1977, lpattern(dash)) /*legend(off)*/

graph save output\cameroon\synth\polity\excluding\cam_loo, replace

*quietly log close


**************************
** Chad 148 - 1977  **
**************************

/*use data/oildiscomplete, clear

tsset country_id year

quietly log using output\chad\synth\polity\excluding\cha_pol01.log, replace

***  Cahad - polity_01 ***

drop if treataspo==1 & country_id!=148

drop if year<1967

foreach variable of varlist lrgdpepc /*hc*/ totalrents manufacturing agrva minva open_pwt HostLev {
bysort country_id: egen `variable'mean = mean(`variable') if inrange(year, 1967, 1976)
gen `variable'missing=1 if `variable'mean==. & inrange(year, 1967, 1976)
bysort country_id: replace `variable'missing=`variable'missing[_n-1] if inrange(year, 1977, 2014)
}

gen ymissing=1 if polity_01==.

recode ymissing (.=0)

bysort country_id: egen ymean = mean(ymissing) 


bysort country_id: egen chameanpol=mean(polity_01) if inrange(year, 1967, 1976)

foreach variable of varlist lrgdpepcmissing /*hcmissing*/ totalrentsmissing manufacturingmissing agrvamissing minvamissing open_pwtmissing HostLevmissing {
drop if `variable'==1 
}

drop if ymean!=0


*  Countries that received a positive weigth: Buthan 64 - Ethipia 231 - Honduras 340 - Malawi 454 - Nepal 524 - Paraguay 600 - Portugal 620 *

synth polity_01 lrgdpepc totalrents manufacturing agrva minva open_pwt HostLev chameanpol , trunit(148) trperiod(1977) /*mspeperiod(1967(1)1976) xperiod(1967(1)1976) resultsperiod(1967(1)2014)*/  keep(output\chad\synth\polity\excluding\cha_148, replace) nested allopt   

foreach code of numlist 64 231 340 454 524 600 620 {
preserve
drop if country_id==`code'
synth polity_01 lrgdpepc totalrents manufacturing agrva minva open_pwt HostLev chameanpol , trunit(148) trperiod(1977) /*mspeperiod(1967(1)1976) xperiod(1967(1)1976) resultsperiod(1967(1)2014)*/  keep(output\chad\synth\polity\excluding\cha_`code', replace) nested allopt   
restore
}

clear 

foreach code of numlist 148 64 231 340 454 524 600 620 {
use output\chad\synth\polity\excluding\cha_`code'
drop _Co_Number _W_Weight
drop if _time==.
save output\chad\synth\polity\excluding\cha_`code',replace
clear
}


*/use data/placebo, clear


foreach code of numlist 148 64 231 340 454 524 600 620  {
merge 1:1 _time using output\chad\synth\polity\excluding\cha_`code'
rename _Y_treated _Y_treated`code'
rename _Y_synthetic _Y_synthetic`code'
drop if _Y_treated`code'==.
drop if _Y_synthetic`code'==.
drop _merge
}

graph twoway (line _Y_synthetic* _time, lpattern(dot) sort) (line _Y_synthetic148 _time, lpattern(dash) sort) (line _Y_treated148 _time, sort  lwidth(thick) lcolor(black)), xline(1977, lpattern(dash)) /*legend(off)*/

graph save output\chad\synth\polity\excluding\cha_loo, replace

*quietly log close


**************************
** Colombia 170 - 1992  **
**************************

/*use data/oildiscomplete, clear

tsset country_id year

quietly log using output\colombia\synth\polity\excluding\col_pol01.log, replace

***  Colombia - polity_01 ***

drop if treataspo==1 & country_id!=170

*drop if developing==0

drop if year<1982

foreach variable of varlist lrgdpepc hc totalrents manufacturing agrva minva open_pwt HostLev {
bysort country_id: egen `variable'mean = mean(`variable') if inrange(year, 1982, 1991)
gen `variable'missing=1 if `variable'mean==. & inrange(year, 1982, 1991)
bysort country_id: replace `variable'missing=`variable'missing[_n-1] if inrange(year, 1992, 2014)
}

gen ymissing=1 if polity_01==.

recode ymissing (.=0)

bysort country_id: egen ymean = mean(ymissing) 


bysort country_id: egen colmeanpol=mean(polity_01) if inrange(year, 1982, 1991)

foreach variable of varlist lrgdpepcmissing hcmissing totalrentsmissing manufacturingmissing agrvamissing minvamissing open_pwtmissing HostLevmissing {
drop if `variable'==1 
}

drop if ymean!=0


*  Countries that received a positive weigth: Nepal 524 - Spain 724 - Tanzania 834 - Zambia 894 *

synth polity_01 lrgdpepc hc totalrents manufacturing agrva minva open_pwt HostLev colmeanpol, trunit(170) trperiod(1992) /*mspeperiod(1982(1)1991) xperiod(1982(1)1991) resultsperiod(1982(1)2014)*/  keep(output\colombia\synth\polity\excluding\col_170, replace) nested allopt   

foreach code of numlist 524 724 834 894 {
preserve
drop if country_id==`code'
synth polity_01 lrgdpepc hc totalrents manufacturing agrva minva open_pwt HostLev colmeanpol, trunit(170) trperiod(1992) /*mspeperiod(1982(1)1991) xperiod(1982(1)1991) resultsperiod(1982(1)2014)*/  keep(output\colombia\synth\polity\excluding\col_`code', replace) nested allopt   
restore
}

clear 

foreach code of numlist 170 524 724 834 894  {
use output\colombia\synth\polity\excluding\col_`code'
drop _Co_Number _W_Weight
drop if _time==.
save output\colombia\synth\polity\excluding\col_`code',replace
clear
}


*/use data/placebo, clear


foreach code of numlist 170 524 724 834 894  {
merge 1:1 _time using output\colombia\synth\polity\excluding\col_`code'
rename _Y_treated _Y_treated`code'
rename _Y_synthetic _Y_synthetic`code'
drop if _Y_treated`code'==.
drop if _Y_synthetic`code'==.
drop _merge
}

drop if _time<1980

graph twoway (line _Y_synthetic* _time, lpattern(dot) sort) (line _Y_synthetic170 _time, lpattern(dash) sort) (line _Y_treated170 _time, sort  lwidth(thick) lcolor(black)), xline(1992, lpattern(dash)) /*legend(off)*/

graph save output\colombia\synth\polity\excluding\col_loo, replace

*quietly log close


******************************
** Congo (Rep.) 178 - 1984  **
******************************

/*use data/oildiscomplete, clear

tsset country_id year

quietly log using output\congo\synth\polity\excluding\con_pol01.log, replace

***  Congo - polity_01 ***

drop if treataspo==1 & country_id!=178

*drop if developing==0

drop if year<1974

foreach variable of varlist lrgdpepc hc totalrents manufacturing agrva minva open_pwt HostLev {
bysort country_id: egen `variable'mean = mean(`variable') if inrange(year, 1974, 1983)
gen `variable'missing=1 if `variable'mean==. & inrange(year, 1974, 1983)
bysort country_id: replace `variable'missing=`variable'missing[_n-1] if inrange(year, 1984, 2014)
}

gen ymissing=1 if polity_01==.

recode ymissing (.=0)

bysort country_id: egen ymean = mean(ymissing) 

bysort country_id: egen conmeanpol=mean(polity_01) if inrange(year, 1974, 1983)

foreach variable of varlist lrgdpepcmissing hcmissing totalrentsmissing manufacturingmissing agrvamissing minvamissing open_pwtmissing HostLevmissing {
drop if `variable'==1 
}

drop if ymean!=0


*  Countries that received a positive weigth: Jordan 400 - Liberia 430 - Zambia 894 *

synth polity_01 lrgdpepc hc totalrents manufacturing agrva minva open_pwt HostLev conmeanpol, trunit(178) trperiod(1984) /*mspeperiod(1974(1)1983) xperiod(1974(1)1983) resultsperiod(1974(1)2014)*/ keep(output\congo\synth\polity\excluding\con_178, replace)  nested 

foreach code of numlist 400 430 894 {
preserve
drop if country_id==`code'
synth polity_01 lrgdpepc hc totalrents manufacturing agrva minva open_pwt HostLev conmeanpol, trunit(178) trperiod(1984) /*mspeperiod(1974(1)1983) xperiod(1974(1)1983) resultsperiod(1974(1)2014)*/ keep(output\congo\synth\polity\excluding\con_`code', replace)  nested 
restore
}

clear 

foreach code of numlist 178 400 430 894 {
use output\congo\synth\polity\excluding\con_`code'
drop _Co_Number _W_Weight
drop if _time==.
save output\congo\synth\polity\excluding\con_`code',replace
clear
}


*/use data/placebo, clear


foreach code of numlist 178 400 430 894 {
merge 1:1 _time using output\congo\synth\polity\excluding\con_`code'
rename _Y_treated _Y_treated`code'
rename _Y_synthetic _Y_synthetic`code'
drop if _Y_treated`code'==.
drop if _Y_synthetic`code'==.
drop _merge
}

graph twoway (line _Y_synthetic* _time, lpattern(dot) sort) (line _Y_synthetic178 _time, lpattern(dash) sort) (line _Y_treated178 _time, sort  lwidth(thick) lcolor(black)), xline(1984, lpattern(dash)) /*legend(off)*/

graph save output\congo\synth\polity\excluding\con_loo, replace

*quietly log close



******************************
**    Gabon 266 - 1985      **
******************************

/*use data/oildiscomplete, clear

tsset country_id year

quietly log using output\gabon\synth\polity\excluding\gab_pol01.log, replace

***  Gabon - polity_01 ***

drop if treataspo==1 & country_id!=266

*drop if developing==0

*** !!!!! no allopt !!!!! ***

drop if year<1975

foreach variable of varlist lrgdpepc hc totalrents manufacturing agrva minva open_pwt HostLev {
bysort country_id: egen `variable'mean = mean(`variable') if inrange(year, 1975, 1984)
gen `variable'missing=1 if `variable'mean==. & inrange(year, 1975, 1984)
bysort country_id: replace `variable'missing=`variable'missing[_n-1] if inrange(year, 1985, 2014)
}

gen ymissing=1 if polity_01==.

recode ymissing (.=0)

bysort country_id: egen ymean = mean(ymissing) 


bysort country_id: egen gabmeanpol=mean(polity_01) if inrange(year, 1975, 1984)

foreach variable of varlist lrgdpepcmissing hcmissing totalrentsmissing manufacturingmissing agrvamissing minvamissing open_pwtmissing HostLevmissing {
drop if `variable'==1 
}

drop if ymean!=0


*  Countries that received a positive weigth: Mauritania 478 - Singapore 702 - Swaziland 748 *

synth polity_01 lrgdpepc hc totalrents manufacturing agrva minva open_pwt HostLev gabmeanpol, trunit(266) trperiod(1985) /*mspeperiod(1975(1)1984) xperiod(1975(1)1984) resultsperiod(1975(1)2014)*/ keep(output\gabon\synth\polity\excluding\gab_266, replace) nested /*allopt */   

foreach code of numlist 478 702 748 {
preserve
drop if country_id==`code'
synth polity_01 lrgdpepc hc totalrents manufacturing agrva minva open_pwt HostLev gabmeanpol, trunit(266) trperiod(1985) /*mspeperiod(1975(1)1984) xperiod(1975(1)1984) resultsperiod(1975(1)2014)*/ keep(output\gabon\synth\polity\excluding\gab_`code', replace) nested /*allopt */   
restore
}

clear 

foreach code of numlist 266 478 702 748 {
use output\gabon\synth\polity\excluding\gab_`code'
drop _Co_Number _W_Weight
drop if _time==.
save output\gabon\synth\polity\excluding\gab_`code',replace
clear
}


*/use data/placebo, clear


foreach code of numlist 266 478 702 748 {
merge 1:1 _time using output\gabon\synth\polity\excluding\gab_`code'
rename _Y_treated _Y_treated`code'
rename _Y_synthetic _Y_synthetic`code'
drop if _Y_treated`code'==.
drop if _Y_synthetic`code'==.
drop _merge
}

graph twoway (line _Y_synthetic* _time, lpattern(dot) sort) (line _Y_synthetic266 _time, lpattern(dash) sort) (line _Y_treated266 _time, sort  lwidth(thick) lcolor(black)), xline(1985, lpattern(dash)) /*legend(off)*/

graph save output\gabon\synth\polity\excluding\gab_loo, replace

*quietly log close


***********************
** India 356 - 1974  **
***********************

/*use data/oildiscomplete, clear

tsset country_id year

quietly log using output\india\synth\polity\excluding\ind_pol01.log, replace

***  India - polity_01 ***

drop if treataspo==1 & country_id!=356

*drop if developing==0

drop if year<1964

foreach variable of varlist lrgdpepc hc totalrents manufacturing agrva minva open_pwt HostLev {
bysort country_id: egen `variable'mean = mean(`variable') if inrange(year, 1964, 1973)
gen `variable'missing=1 if `variable'mean==. & inrange(year, 1964, 1973)
bysort country_id: replace `variable'missing=`variable'missing[_n-1] if inrange(year, 1974, 2014)
}

gen ymissing=1 if polity_01==.

recode ymissing (.=0)

bysort country_id: egen ymean = mean(ymissing) 


bysort country_id: egen indmeanpol=mean(polity_01) if inrange(year, 1964, 1973)

foreach variable of varlist lrgdpepcmissing hcmissing totalrentsmissing manufacturingmissing agrvamissing minvamissing open_pwtmissing HostLevmissing {
drop if `variable'==1 
}

drop if ymean!=0


*  Countries that received a positive weigth: Costa Rica 188 - Japan 392 - Laos 418 - Nepal 524 - Zambia 894 *

synth polity_01 lrgdpepc hc totalrents manufacturing agrva minva HostLev open_pwt indmeanpol, trunit(356) trperiod(1974) /*mspeperiod(1964(1)1973) xperiod(1964(1)1973) resultsperiod(1964(1)2014)*/ keep(output\india\synth\polity\excluding\ind_356, replace) nested allopt   

foreach code of numlist 188 392 418 524 894 {
preserve
drop if country_id==`code'
synth polity_01 lrgdpepc hc totalrents manufacturing agrva minva HostLev open_pwt indmeanpol, trunit(356) trperiod(1974) /*mspeperiod(1964(1)1973) xperiod(1964(1)1973) resultsperiod(1964(1)2014)*/ keep(output\india\synth\polity\excluding\ind_`code', replace) nested allopt   
restore
}

clear 

foreach code of numlist 356 188 392 418 524 894 {
use output\india\synth\polity\excluding\ind_`code'
drop _Co_Number _W_Weight
drop if _time==.
save output\india\synth\polity\excluding\ind_`code',replace
clear
}


*/use data/placebo, clear


foreach code of numlist 356 188 392 418 524 894 {
merge 1:1 _time using output\india\synth\polity\excluding\ind_`code'
rename _Y_treated _Y_treated`code'
rename _Y_synthetic _Y_synthetic`code'
drop if _Y_treated`code'==.
drop if _Y_synthetic`code'==.
drop _merge
}

graph twoway (line _Y_synthetic* _time, lpattern(dot) sort) (line _Y_synthetic356 _time, lpattern(dash) sort) (line _Y_treated356 _time, sort  lwidth(thick) lcolor(black)), xline(1974, lpattern(dash)) /*legend(off)*/

graph save output\india\synth\polity\excluding\ind_loo, replace

*quietly log close


****************************
** Kazakhstan 398 - 2000  **
****************************

/*use data/oildiscomplete, clear

tsset country_id year

quietly log using output\kazakhstan\synth\polity\excluding\kaz_pol01.log, replace

***  Kazakhstan - polity_01 ***

drop if treataspo==1 & country_id!=398

*drop if developing==0

drop if year<1991

foreach variable of varlist lrgdpepc hc totalrents manufacturing agrva minva open_pwt HostLev {
bysort country_id: egen `variable'mean = mean(`variable') if inrange(year, 1991, 1999)
gen `variable'missing=1 if `variable'mean==. & inrange(year, 1991, 1999)
bysort country_id: replace `variable'missing=`variable'missing[_n-1] if inrange(year, 2000, 2014)
}

gen ymissing=1 if polity_01==.

recode ymissing (.=0)

bysort country_id: egen ymean = mean(ymissing) 

bysort country_id: egen kazmeanpol=mean(polity_01) if inrange(year, 1991, 1999)

foreach variable of varlist lrgdpepcmissing hcmissing totalrentsmissing manufacturingmissing agrvamissing minvamissing open_pwtmissing HostLevmissing {
drop if `variable'==1 
}

drop if ymean!=0


*  Countries that received a positive weigth: Laos 418 - Liberia 430 - Singapore 702 *

synth polity_01 lrgdpepc hc totalrents manufacturing agrva minva open_pwt HostLev kazmeanpol, trunit(398) trperiod(2000)/*mspeperiod(1991(1)1999) xperiod(1991(1)1999) resultsperiod(1991(1)2014)*/ keep(output\kazakhstan\synth\polity\excluding\kaz_398, replace) nested allopt    

foreach code of numlist 418 430 702 {
preserve
drop if country_id==`code'
synth polity_01 lrgdpepc hc totalrents manufacturing agrva minva open_pwt HostLev kazmeanpol, trunit(398) trperiod(2000)/*mspeperiod(1991(1)1999) xperiod(1991(1)1999) resultsperiod(1991(1)2014)*/ keep(output\kazakhstan\synth\polity\excluding\kaz_`code', replace) nested allopt    
restore
}

clear 

foreach code of numlist 398 418 430 702 {
use output\kazakhstan\synth\polity\excluding\kaz_`code'
drop _Co_Number _W_Weight
drop if _time==.
save output\kazakhstan\synth\polity\excluding\kaz_`code',replace
clear
}


*/use data/placebo, clear

drop if _time<1990

foreach code of numlist 398 418 430 702 {
merge 1:1 _time using output\kazakhstan\synth\polity\excluding\kaz_`code'
rename _Y_treated _Y_treated`code'
rename _Y_synthetic _Y_synthetic`code'
drop if _Y_treated`code'==.
drop if _Y_synthetic`code'==.
drop _merge
}

graph twoway (line _Y_synthetic* _time, lpattern(dot) sort) (line _Y_synthetic398 _time, lpattern(dash) sort) (line _Y_treated398 _time, sort  lwidth(thick) lcolor(black)), xline(2000, lpattern(dash)) /*legend(off)*/

graph save output\kazakhstan\synth\polity\excluding\kaz_loo, replace

*quietly log close


**************************
** Mexico 484 - 1977  **
**************************

/*use data/oildiscomplete, clear

tsset country_id year

quietly log using output\mexico\synth\polity\excluding\mex_pol01.log, replace

***  Mexico - polity_01 ***

drop if treataspo==1 & country_id!=484

*drop if developing==0

drop if year<1967

foreach variable of varlist lrgdpepc hc totalrents manufacturing agrva minva open_pwt HostLev {
bysort country_id: egen `variable'mean = mean(`variable') if inrange(year, 1967, 1976)
gen `variable'missing=1 if `variable'mean==. & inrange(year, 1967, 1976)
bysort country_id: replace `variable'missing=`variable'missing[_n-1] if inrange(year, 1977, 2014)
}

gen ymissing=1 if polity_01==.

recode ymissing (.=0)

bysort country_id: egen ymean = mean(ymissing) 


bysort country_id: egen mexmeanpol=mean(polity_01) if inrange(year, 1967, 1976)

foreach variable of varlist lrgdpepcmissing hcmissing totalrentsmissing manufacturingmissing agrvamissing minvamissing open_pwtmissing HostLevmissing {
drop if `variable'==1 
}

drop if ymean!=0


*  Countries that received a positive weigth: Democratic Rep of Congo 180 - Japan 392 - Nepal 524 - Poland 616 - Togo 768 *

synth polity_01 lrgdpepc hc totalrents manufacturing agrva minva HostLev open_pwt mexmeanpol, trunit(484) trperiod(1977) /*mspeperiod(1967(1)1976) xperiod(1967(1)1976) resultsperiod(1967(1)2014)*/ keep(output\mexico\synth\polity\excluding\mex_484, replace) nested allopt    

foreach code of numlist 180 392 524 616 768 {
preserve
drop if country_id==`code'
synth polity_01 lrgdpepc hc totalrents manufacturing agrva minva HostLev open_pwt mexmeanpol, trunit(484) trperiod(1977) /*mspeperiod(1967(1)1976) xperiod(1967(1)1976) resultsperiod(1967(1)2014)*/ keep(output\mexico\synth\polity\excluding\mex_`code', replace) nested allopt    
restore
}

clear 

foreach code of numlist 484 180 392 524 616 768 {
use output\mexico\synth\polity\excluding\mex_`code'
drop _Co_Number _W_Weight
drop if _time==.
save output\mexico\synth\polity\excluding\mex_`code',replace
clear
}


*/use data/placebo, clear


foreach code of numlist 484 180 392 524 616 768 {
merge 1:1 _time using output\mexico\synth\polity\excluding\mex_`code'
rename _Y_treated _Y_treated`code'
rename _Y_synthetic _Y_synthetic`code'
drop if _Y_treated`code'==.
drop if _Y_synthetic`code'==.
drop _merge
}

graph twoway (line _Y_synthetic* _time, lpattern(dot) sort) (line _Y_synthetic484 _time, lpattern(dash) sort) (line _Y_treated484 _time, sort  lwidth(thick) lcolor(black)), xline(1977, lpattern(dash)) /*legend(off)*/

graph save output\mexico\synth\polity\excluding\mex_loo, replace

*quietly log close


******************************
**   Sudan 729 - 1980    **
******************************

/*use data/oildiscomplete, clear

tsset country_id year

quietly log using output\sudan\synth\polity\excluding\sud_pol01.log, replace

*** Sudan - polity_01 ***

drop if treataspo==1 & country_id!=729

*drop if developing==0

drop if year<1970

foreach variable of varlist lrgdpepc hc totalrents manufacturing agrva minva open_pwt HostLev {
bysort country_id: egen `variable'mean = mean(`variable') if inrange(year, 1970, 1979)
gen `variable'missing=1 if `variable'mean==. & inrange(year, 1970, 1979)
bysort country_id: replace `variable'missing=`variable'missing[_n-1] if inrange(year, 1980, 2014)
}

gen ymissing=1 if polity_01==.

recode ymissing (.=0)

bysort country_id: egen ymean = mean(ymissing) 


bysort country_id: egen sudmeanpol=mean(polity_01) if inrange(year, 1970, 1979)

foreach variable of varlist lrgdpepcmissing hcmissing totalrentsmissing manufacturingmissing agrvamissing minvamissing open_pwtmissing HostLevmissing {
drop if `variable'==1 
}

drop if ymean!=0


*  Countries that received a positive weigth: Greece 300 - Jordan 400 - Mali 466 - Tanzania 834 - Uruguay 858 *

synth polity_01 lrgdpepc hc totalrents manufacturing agrva minva open_pwt HostLev sudmeanpol, trunit(729) trperiod(1980) /*mspeperiod(1970(1)1979) xperiod(1970(1)1979) resultsperiod(1970(1)2014)*/ keep(output\sudan\synth\polity\excluding\sud_729, replace) nested allopt    

foreach code of numlist 300 400 466 834 858 {
preserve
drop if country_id==`code'
synth polity_01 lrgdpepc hc totalrents manufacturing agrva minva open_pwt HostLev sudmeanpol, trunit(729) trperiod(1980) /*mspeperiod(1970(1)1979) xperiod(1970(1)1979) resultsperiod(1970(1)2014)*/ keep(output\sudan\synth\polity\excluding\sud_`code', replace) nested allopt    
restore
}

clear 

foreach code of numlist 729 300 400 466 834 858 {
use output\sudan\synth\polity\excluding\sud_`code'
drop _Co_Number _W_Weight
drop if _time==.
save output\sudan\synth\polity\excluding\sud_`code',replace
clear
}


*/use data/placebo, clear


foreach code of numlist 729 300 400 466 834 858 {
merge 1:1 _time using output\sudan\synth\polity\excluding\sud_`code'
rename _Y_treated _Y_treated`code'
rename _Y_synthetic _Y_synthetic`code'
drop if _Y_treated`code'==.
drop if _Y_synthetic`code'==.
drop _merge
}

graph twoway (line _Y_synthetic* _time, lpattern(dot) sort) (line _Y_synthetic729 _time, lpattern(dash) sort) (line _Y_treated729 _time, sort  lwidth(thick) lcolor(black)), xline(1980, lpattern(dash)) /*legend(off)*/

graph save output\sudan\synth\polity\excluding\sud_loo, replace

*quietly log close

**************************
** Tunisia 788 - 1971  **
**************************/

/*use data/oildiscomplete, clear

tsset country_id year

quietly log using output\tunisia\synth\polity\excluding\tun_pol01.log, replace

***  Tunisia - polity_01 ***

drop if treataspo==1 & country_id!=788

*drop if developing==0
drop if year<1961

foreach variable of varlist lrgdpepc hc totalrents manufacturing agrva minva open_pwt HostLev {
bysort country_id: egen `variable'mean = mean(`variable') if inrange(year, 1961, 1970)
gen `variable'missing=1 if `variable'mean==. & inrange(year, 1961, 1970)
bysort country_id: replace `variable'missing=`variable'missing[_n-1] if inrange(year, 1971, 2014)
}

gen ymissing=1 if polity_01==.

recode ymissing (.=0)

bysort country_id: egen ymean = mean(ymissing) 


bysort country_id: egen tunmeanpol=mean(polity_01) if inrange(year, 1961, 1970)

foreach variable of varlist lrgdpepcmissing hcmissing totalrentsmissing manufacturingmissing agrvamissing minvamissing open_pwtmissing HostLevmissing {
drop if `variable'==1 
}

drop if ymean!=0


*  Countries that received a positive weigth: Jordan 400 - Mongolia 496 - Nepal 524 - Paraguay 600 *

synth polity_01 lrgdpepc hc open_pwt totalrents manufacturing agrva minva HostLev tunmeanpol, trunit(788) trperiod(1971) /*mspeperiod(1961(1)1970) xperiod(1961(1)1970) resultsperiod(1961(1)2014)*/ keep(output\tunisia\synth\polity\excluding\tun_788, replace) nested allopt    

foreach code of numlist 400 496 524 600 {
preserve
drop if country_id==`code'
synth polity_01 lrgdpepc hc open_pwt totalrents manufacturing agrva minva HostLev tunmeanpol, trunit(788) trperiod(1971) /*mspeperiod(1961(1)1970) xperiod(1961(1)1970) resultsperiod(1961(1)2014)*/ keep(output\tunisia\synth\polity\excluding\tun_`code', replace) nested allopt    
restore
}

clear 

foreach code of numlist 788 400 496 524 600 {
use output\tunisia\synth\polity\excluding\tun_`code'
drop _Co_Number _W_Weight
drop if _time==.
save output\tunisia\synth\polity\excluding\tun_`code',replace
clear
}


*/use data/placebo, clear


foreach code of numlist 788 400 496 524 600 {
merge 1:1 _time using output\tunisia\synth\polity\excluding\tun_`code'
rename _Y_treated _Y_treated`code'
rename _Y_synthetic _Y_synthetic`code'
drop if _Y_treated`code'==.
drop if _Y_synthetic`code'==.
drop _merge
}

graph twoway (line _Y_synthetic* _time, lpattern(dot) sort) (line _Y_synthetic788 _time, lpattern(dash) sort) (line _Y_treated788 _time, sort  lwidth(thick) lcolor(black)), xline(1971, lpattern(dash)) /*legend(off)*/

graph save output\tunisia\synth\polity\excluding\tun_loo, replace

*quietly log close

***********************
** Vietnam 704 - 1975**
***********************

/*use data/oildiscomplete, clear

tsset country_id year

quietly log using output\vietnam\synth\polity\excluding\vie_pol01.log, replace

***  Vietnam - polity_01 ***

drop if treataspo==1 & country_id!=704

*drop if developing==0

drop if year<1965

foreach variable of varlist lrgdpepc hc totalrents manufacturing agrva minva open_pwt HostLev {
bysort country_id: egen `variable'mean = mean(`variable') if inrange(year, 1965, 1974)
gen `variable'missing=1 if `variable'mean==. & inrange(year, 1965, 1974)
bysort country_id: replace `variable'missing=`variable'missing[_n-1] if inrange(year, 1975, 2014)
}

gen ymissing=1 if polity_01==.

recode ymissing (.=0)

bysort country_id: egen ymean = mean(ymissing) 


bysort country_id: egen viemeanpol=mean(polity_01) if inrange(year, 1965, 1975)

foreach variable of varlist lrgdpepcmissing hcmissing totalrentsmissing manufacturingmissing agrvamissing minvamissing open_pwtmissing HostLevmissing {
drop if `variable'==1 
}

drop if ymean!=0



*  Countries that received a positive weigth: Bulgaria 100 - Jordan 400 - Malawi 454 - Mali 466 Portugal 620 - Singapore 702 *

synth polity_01 lrgdpepc hc totalrents manufacturing agrva minva HostLev open_pwt viemeanpol, trunit(704) trperiod(1975) /*mspeperiod(1965(1)1974) xperiod(1965(1)1974) resultsperiod(1965(1)2014)*/ keep(output\vietnam\synth\polity\excluding\vie_704, replace) nested allopt    

foreach code of numlist 100 400 454 466 620 702 {
preserve
drop if country_id==`code'
synth polity_01 lrgdpepc hc totalrents manufacturing agrva minva HostLev open_pwt viemeanpol, trunit(704) trperiod(1975) /*mspeperiod(1965(1)1974) xperiod(1965(1)1974) resultsperiod(1965(1)2014)*/ keep(output\vietnam\synth\polity\excluding\vie_`code', replace) nested allopt    
restore
}

clear 

foreach code of numlist 704 100 400 454 466 620 702 {
use output\vietnam\synth\polity\excluding\vie_`code'
drop _Co_Number _W_Weight
drop if _time==.
save output\vietnam\synth\polity\excluding\vie_`code',replace
clear
}


*/use data/placebo, clear


foreach code of numlist 704 100 400 454 466 620 702 {
merge 1:1 _time using output\vietnam\synth\polity\excluding\vie_`code'
rename _Y_treated _Y_treated`code'
rename _Y_synthetic _Y_synthetic`code'
drop if _Y_treated`code'==.
drop if _Y_synthetic`code'==.
drop _merge
}

graph twoway (line _Y_synthetic* _time, lpattern(dot) sort) (line _Y_synthetic704 _time, lpattern(dash) sort) (line _Y_treated704 _time, sort  lwidth(thick) lcolor(black)), xline(1975, lpattern(dash)) /*legend(off)*/

graph save output\vietnam\synth\polity\excluding\vie_loo, replace

*quietly log close

*****
clear
