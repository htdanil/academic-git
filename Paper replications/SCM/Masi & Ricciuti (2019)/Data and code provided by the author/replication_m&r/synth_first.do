******************************************************************************** 
****        The Heterogeneous Effect of Oil Discoveries on Democracy        ****
********************************************************************************

clear
set more off
capture log close

/*********************************
	   * synthetic control *
	   
* 		firts discovery			 *	
			  
**********************************/



***********************
** Brazil 76 - 1965  **
***********************

use data/oildiscomplete, clear

tsset country_id year

quietly log using output\first\brazil\bra_pol01.log, replace

***  Brazil - polity_01 1965 ***

drop if treataspo==1 & country_id!=76

*drop if developing==0


drop if year<1955

foreach variable of varlist lrgdpepc hc /*totalrents manufacturing agrva minva*/ open_pwt HostLev {
bysort country_id: egen `variable'mean = mean(`variable') if inrange(year, 1955, 1964)
gen `variable'missing=1 if `variable'mean==. & inrange(year, 1955, 1964)
bysort country_id: replace `variable'missing=`variable'missing[_n-1] if inrange(year, 1965, 2014)
}

gen ymissing=1 if polity_01==.

recode ymissing (.=0)

bysort country_id: egen ymean = mean(ymissing) 

bysort country_id: egen brameanpol=mean(polity_01) if inrange(year, 1955, 1964)

foreach variable of varlist lrgdpepcmissing hcmissing /*totalrentsmissing manufacturingmissing agrvamissing minvamissing*/ open_pwtmissing HostLevmissing {
drop if `variable'==1 
}

drop if ymean!=0

tsset country_id year

synth polity_01 lrgdpepc hc /*totalrents manufacturing agrva minva*/ open_pwt HostLev brameanpol, trunit(76) trperiod(1965) /*mspeperiod(1965(1)1974) xperiod(1965(1)1974) resultsperiod(1965(1)2014)*/ fig keep(output\first\brazil\bra_pol01, replace) nested allopt    

graph save output\first\brazil\bra_pol01, replace

matrix list e(V_matrix)

use output\first\brazil\bra_pol01, clear

gen gap=_Y_treated-_Y_synthetic

graph twoway (line gap _time, sort), xline(1965, lpattern(dash)) yline(0, lpattern(dash))

graph save output\first\brazil\gapbra_pol01, replace



quietly log close


/**************************
** Cameroon 120 - 1977  ** missing
**************************

use data/oildiscomplete, clear

tsset country_id year

quietly log using output\first\cameroon\cam_pol01.log, replace

***  Cameroon - polity_01 ***

drop if treataspo==1 & country_id!=120

*drop if developing==0

drop if year<1967

foreach variable of varlist /*lrgdpepc hc totalrents manufacturing agrva minva open_pwt*/ HostLev {
bysort country_id: egen `variable'mean = mean(`variable') if inrange(year, 1967, 1976)
gen `variable'missing=1 if `variable'mean==. & inrange(year, 1967, 1976)
bysort country_id: replace `variable'missing=`variable'missing[_n-1] if inrange(year, 1977, 2014)
}

gen ymissing=1 if polity_01==.

recode ymissing (.=0)

bysort country_id: egen ymean = mean(ymissing) 


bysort country_id: egen cammeanpol=mean(polity_01) if inrange(year, 1967, 1976)

foreach variable of varlist /*lrgdpepcmissing hcmissing totalrentsmissing manufacturingmissing agrvamissing minvamissing open_pwtmissing*/ HostLevmissing {
drop if `variable'==1 
}

drop if ymean!=0


synth polity_01 /*lrgdpepc hc totalrents manufacturing agrva minva open_pwt*/ HostLev cammeanpol , trunit(120) trperiod(1977) /*mspeperiod(1967(1)1976) xperiod(1967(1)1976) resultsperiod(1967(1)2014)*/ fig keep(output\first\cameroon\cam_pol01, replace) nested allopt    

graph save output\first\cameroon\cam_pol01, replace

matrix list e(V_matrix)

use output\first\cameroon\cam_pol01, clear

gen gap=_Y_treated-_Y_synthetic

graph twoway (line gap _time, sort), xline(1977, lpattern(dash)) yline(0, lpattern(dash))

graph save output\first\cameroon\gapcam_pol01, replace

quietly log close


************************** MISSING
** Chad 148 - 1977  **
**************************

use data/oildiscomplete, clear

tsset country_id year

quietly log using output\first\chad\cha_pol01.log, replace

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

*** !!!!! hc is missing !!!!! ***

synth polity_01 lrgdpepc totalrents manufacturing agrva minva open_pwt HostLev chameanpol , trunit(148) trperiod(1977) /*mspeperiod(1967(1)1976) xperiod(1967(1)1976) resultsperiod(1967(1)2014)*/ fig keep(output\first\chad\cha_pol01, replace) nested allopt   

graph save output\first\chad\cha_pol01, replace

matrix list e(V_matrix)

use output\first\chad\cha_pol01, clear

gen gap=_Y_treated-_Y_synthetic

graph twoway (line gap _time, sort), xline(1977, lpattern(dash)) yline(0, lpattern(dash))

graph save output\first\chad\gapcha_pol01, replace

quietly log close

**************************
** Colombia 170 - 1992  ** 1918
**************************

use data/oildiscomplete, clear

tsset country_id year

quietly log using output\first\colombia\col_pol01.log, replace

***  Colombia - polity_01 ***

drop if treataspo==1 & country_id!=170

*drop if developing==0

drop if year<1982

foreach variable of varlist /*lrgdpepc hc totalrents manufacturing agrva minva open_pwt*/ HostLev {
bysort country_id: egen `variable'mean = mean(`variable') if inrange(year, 1982, 1991)
gen `variable'missing=1 if `variable'mean==. & inrange(year, 1982, 1991)
bysort country_id: replace `variable'missing=`variable'missing[_n-1] if inrange(year, 1992, 2014)
}

gen ymissing=1 if polity_01==.

recode ymissing (.=0)

bysort country_id: egen ymean = mean(ymissing) 


bysort country_id: egen colmeanpol=mean(polity_01) if inrange(year, 1982, 1991)

foreach variable of varlist /*lrgdpepcmissing hcmissing totalrentsmissing manufacturingmissing agrvamissing minvamissing open_pwtmissing*/ HostLevmissing {
drop if `variable'==1 
}

drop if ymean!=0

synth polity_01 /*lrgdpepc hc totalrents manufacturing agrva minva open_pwt*/ HostLev colmeanpol, trunit(170) trperiod(1992) /*mspeperiod(1982(1)1991) xperiod(1982(1)1991) resultsperiod(1982(1)2014)*/ fig keep(output\first\colombia\col_pol01, replace) nested allopt   

graph save output\first\colombia\col_pol01, replace

matrix list e(V_matrix)

use output\first\colombia\col_pol01, clear

gen gap=_Y_treated-_Y_synthetic

graph twoway (line gap _time, sort), xline(1992, lpattern(dash)) yline(0, lpattern(dash))

graph save output\first\colombia\gapcol_pol01, replace

quietly log close

******************************
** Congo (Rep.) 178 - 1969  **
******************************/ 

use data/oildiscomplete, clear

tsset country_id year

quietly log using output\first\congo\con_pol01.log, replace

***  Congo - polity_01 ***

drop if treataspo==1 & country_id!=178

*drop if developing==0

drop if year<1960

foreach variable of varlist lrgdpepc hc /*totalrents manufacturing agrva minva*/ open_pwt HostLev {
bysort country_id: egen `variable'mean = mean(`variable') if inrange(year, 1959, 1968)
gen `variable'missing=1 if `variable'mean==. & inrange(year, 1959, 1968)
bysort country_id: replace `variable'missing=`variable'missing[_n-1] if inrange(year, 1969, 2014)
}

gen ymissing=1 if polity_01==.

recode ymissing (.=0)

bysort country_id: egen ymean = mean(ymissing) 

bysort country_id: egen conmeanpol=mean(polity_01) if inrange(year, 1959, 1968)

foreach variable of varlist lrgdpepcmissing hcmissing /*totalrentsmissing manufacturingmissing agrvamissing minvamissing*/ open_pwtmissing HostLevmissing {
drop if `variable'==1 
}

drop if ymean!=0
synth polity_01 lrgdpepc hc /*totalrents manufacturing agrva minva*/ open_pwt HostLev conmeanpol, trunit(178) trperiod(1969) /*mspeperiod(1974(1)1983) xperiod(1974(1)1983) resultsperiod(1974(1)2014)*/ fig keep(output\first\congo\con_pol01, replace)  nested 

graph save output\first\congo\con_pol01, replace

matrix list e(V_matrix)

use output\first\congo\con_pol01, clear

gen gap=_Y_treated-_Y_synthetic

graph twoway (line gap _time, sort), xline(1969, lpattern(dash)) yline(0, lpattern(dash))

graph save output\first\congo\gapcon_pol01, replace

quietly log close


/******************************
**    Gabon 266 - 1987      **1985
******************************

use data/oildiscomplete, clear

tsset country_id year

quietly log using output\first\gabon\gab_pol01.log, replace

***  Gabon - polity_01 ***

drop if treataspo==1 & country_id!=266

*drop if developing==0

*** !!!!! no allopt !!!!! ***

drop if year<1975

foreach variable of varlist /*lrgdpepc hc totalrents manufacturing agrva minva open_pwt*/ HostLev {
bysort country_id: egen `variable'mean = mean(`variable') if inrange(year, 1975, 1984)
gen `variable'missing=1 if `variable'mean==. & inrange(year, 1975, 1984)
bysort country_id: replace `variable'missing=`variable'missing[_n-1] if inrange(year, 1985, 2014)
}

gen ymissing=1 if polity_01==.

recode ymissing (.=0)

bysort country_id: egen ymean = mean(ymissing) 


bysort country_id: egen gabmeanpol=mean(polity_01) if inrange(year, 1975, 1984)

foreach variable of varlist /*lrgdpepcmissing hcmissing totalrentsmissing manufacturingmissing agrvamissing minvamissing open_pwtmissing*/ HostLevmissing {
drop if `variable'==1 
}

drop if ymean!=0
synth polity_01 /*lrgdpepc hc totalrents manufacturing agrva minva open_pwt*/ HostLev gabmeanpol, trunit(266) trperiod(1985) /*mspeperiod(1975(1)1984) xperiod(1975(1)1984) resultsperiod(1975(1)2014)*/ fig keep(output\first\gabon\gab_pol01, replace) nested /*allopt */   

graph save output\first\gabon\gab_pol01, replace

matrix list e(V_matrix)

use output\first\gabon\gab_pol01, clear

gen gap=_Y_treated-_Y_synthetic

graph twoway (line gap _time, sort), xline(1985, lpattern(dash)) yline(0, lpattern(dash))

graph save output\first\gabon\gapgab_pol01, replace

quietly log close


***********************
** India 356 - 1953  **1953
***********************/

use data/oildiscomplete, clear

tsset country_id year

quietly log using output\first\india\ind_pol01.log, replace

***  India - polity_01 ***

drop if treataspo==1 & country_id!=356

*drop if developing==0

drop if year<1950

foreach variable of varlist lrgdpepc hc /*totalrents manufacturing agrva minva*/ open_pwt HostLev {
bysort country_id: egen `variable'mean = mean(`variable') if inrange(year, 1943, 1952)
gen `variable'missing=1 if `variable'mean==. & inrange(year, 1943, 1952)
bysort country_id: replace `variable'missing=`variable'missing[_n-1] if inrange(year, 1953, 2014)
}

gen ymissing=1 if polity_01==.

recode ymissing (.=0)

bysort country_id: egen ymean = mean(ymissing) 


bysort country_id: egen indmeanpol=mean(polity_01) if inrange(year, 1943, 1952)

foreach variable of varlist lrgdpepcmissing hcmissing /*totalrentsmissing manufacturingmissing agrvamissing minvamissing*/ open_pwtmissing HostLevmissing {
drop if `variable'==1 
}

drop if ymean!=0

synth polity_01 lrgdpepc hc /*totalrents manufacturing agrva minva*/ open_pwt HostLev indmeanpol, trunit(356) trperiod(1953) /*mspeperiod(1964(1)1973) xperiod(1964(1)1973) resultsperiod(1964(1)2014)*/ fig keep(output\first\india\ind_pol01, replace) nested allopt   

graph save output\first\india\ind_pol01, replace

matrix list e(V_matrix)

use output\first\india\ind_pol01, clear

gen gap=_Y_treated-_Y_synthetic

graph twoway (line gap _time, sort), xline(1953, lpattern(dash)) yline(0, lpattern(dash))

graph save output\first\india\gapind_pol01, replace

quietly log close


/****************************
** Kazakhstan 398 - 2000  **1961 outcome 1991
****************************

use data/oildiscomplete, clear

tsset country_id year

quietly log using output\first\kazakhstan\kaz_pol01.log, replace

***  Kazakhstan - polity_01 ***

drop if treataspo==1 & country_id!=398

*drop if developing==0

drop if year<1951

foreach variable of varlist /*lrgdpepc hc totalrents manufacturing agrva minva open_pwt*/ HostLev {
bysort country_id: egen `variable'mean = mean(`variable') if inrange(year, 1951, 1960)
gen `variable'missing=1 if `variable'mean==. & inrange(year, 1951, 1960)
bysort country_id: replace `variable'missing=`variable'missing[_n-1] if inrange(year, 1961, 2014)
}

gen ymissing=1 if polity_01==.

recode ymissing (.=0)

bysort country_id: egen ymean = mean(ymissing) 

bysort country_id: egen kazmeanpol=mean(polity_01) if inrange(year, 1951, 1960)

foreach variable of varlist /*lrgdpepcmissing hcmissing totalrentsmissing manufacturingmissing agrvamissing minvamissing open_pwtmissing*/ HostLevmissing {
drop if `variable'==1 
}

drop if ymean!=0
synth polity_01 /*lrgdpepc hc totalrents manufacturing agrva minva open_pwt*/ HostLev kazmeanpol, trunit(398) trperiod(1961)/*mspeperiod(1991(1)1999) xperiod(1991(1)1999) resultsperiod(1991(1)2014)*/ fig keep(output\first\kazakhstan\kaz_pol01, replace) nested allopt    

graph save output\first\kazakhstan\kaz_pol01, replace

matrix list e(V_matrix)

use output\first\kazakhstan\kaz_pol01, clear

gen gap=_Y_treated-_Y_synthetic

graph twoway (line gap _time, sort), xline(1961, lpattern(dash)) yline(0, lpattern(dash))

graph save output\first\kazakhstan\gapkaz_pol01, replace

quietly log close


/**************************/
** Mexico 484 - 1977  ** 1901
**************************

use data/oildiscomplete, clear

tsset country_id year

quietly log using output\first\mexico\mex_pol01.log, replace

***  Mexico - polity_01 ***

drop if treataspo==1 & country_id!=484

*drop if developing==0

drop if year<1967

foreach variable of varlist /*lrgdpepc hc totalrents manufacturing agrva minva open_pwt*/ HostLev {
bysort country_id: egen `variable'mean = mean(`variable') if inrange(year, 1967, 1976)
gen `variable'missing=1 if `variable'mean==. & inrange(year, 1967, 1976)
bysort country_id: replace `variable'missing=`variable'missing[_n-1] if inrange(year, 1977, 2014)
}

gen ymissing=1 if polity_01==.

recode ymissing (.=0)

bysort country_id: egen ymean = mean(ymissing) 


bysort country_id: egen mexmeanpol=mean(polity_01) if inrange(year, 1967, 1976)

foreach variable of varlist /*lrgdpepcmissing hcmissing totalrentsmissing manufacturingmissing agrvamissing minvamissing open_pwtmissing*/ HostLevmissing {
drop if `variable'==1 
}

drop if ymean!=0

synth polity_01 /*lrgdpepc hc totalrents manufacturing agrva minva open_pwt*/ HostLev mexmeanpol, trunit(484) trperiod(1977) /*mspeperiod(1967(1)1976) xperiod(1967(1)1976) resultsperiod(1967(1)2014)*/ fig keep(output\first\mexico\mex_pol01, replace) nested allopt    

graph save output\first\mexico\mex_pol01, replace

matrix list e(V_matrix)

use output\first\mexico\mex_pol01, clear

gen gap=_Y_treated-_Y_synthetic

graph twoway (line gap _time, sort), xline(1977, lpattern(dash)) yline(0, lpattern(dash))

graph save output\first\mexico\gapmex_pol01, replace

quietly log close



******************************/
**   Sudan 729 - 1980    ** coincide 
******************************

use data/oildiscomplete, clear

tsset country_id year

quietly log using output\first\sudan\sud_pol01.log, replace

*** Sudan - polity_01 ***

drop if treataspo==1 & country_id!=729

*drop if developing==0

drop if year<1970

foreach variable of varlist /*lrgdpepc hc totalrents manufacturing agrva minva open_pwt*/ HostLev {
bysort country_id: egen `variable'mean = mean(`variable') if inrange(year, 1970, 1979)
gen `variable'missing=1 if `variable'mean==. & inrange(year, 1970, 1979)
bysort country_id: replace `variable'missing=`variable'missing[_n-1] if inrange(year, 1980, 2014)
}

gen ymissing=1 if polity_01==.

recode ymissing (.=0)

bysort country_id: egen ymean = mean(ymissing) 


bysort country_id: egen sudmeanpol=mean(polity_01) if inrange(year, 1970, 1979)

foreach variable of varlist /*lrgdpepcmissing hcmissing totalrentsmissing manufacturingmissing agrvamissing minvamissing open_pwtmissing*/ HostLevmissing {
drop if `variable'==1 
}

drop if ymean!=0

synth polity_01 /*lrgdpepc hc totalrents manufacturing agrva minva open_pwt*/ HostLev sudmeanpol, trunit(729) trperiod(1980) /*mspeperiod(1970(1)1979) xperiod(1970(1)1979) resultsperiod(1970(1)2014)*/ fig keep(output\first\sudan\sud_pol01, replace) nested allopt    

graph save output\first\sudan\sud_pol01, replace

matrix list e(V_matrix)

use output\first\sudan\sud_pol01, clear

gen gap=_Y_treated-_Y_synthetic

graph twoway (line gap _time, sort), xline(1980, lpattern(dash)) yline(0, lpattern(dash))

graph save output\first\sudan\gapsud_pol01, replace

quietly log close


**************************
** Tunisia 788 - 1964  ** 1964
**************************

use data/oildiscomplete, clear

tsset country_id year

quietly log using output\first\tunisia\tun_pol01.log, replace

***  Tunisia - polity_01 ***

drop if treataspo==1 & country_id!=788

*drop if developing==0
drop if year<1959

foreach variable of varlist lrgdpepc hc /*totalrents manufacturing agrva minva open_pwt*/ HostLev {
bysort country_id: egen `variable'mean = mean(`variable') if inrange(year, 1954, 1963)
gen `variable'missing=1 if `variable'mean==. & inrange(year, 1954, 1963)
bysort country_id: replace `variable'missing=`variable'missing[_n-1] if inrange(year, 1964, 2014)
}

gen ymissing=1 if polity_01==.

recode ymissing (.=0)

bysort country_id: egen ymean = mean(ymissing) 


bysort country_id: egen tunmeanpol=mean(polity_01) if inrange(year, 1954, 1963)

foreach variable of varlist lrgdpepcmissing hcmissing /*totalrentsmissing manufacturingmissing agrvamissing minvamissing open_pwtmissing*/ HostLevmissing {
drop if `variable'==1 
}

drop if ymean!=0

synth polity_01 lrgdpepc hc /*open_pwt totalrents manufacturing agrva minva*/ HostLev tunmeanpol, trunit(788) trperiod(1964) /*mspeperiod(1961(1)1970) xperiod(1961(1)1970) resultsperiod(1961(1)2014)*/ fig keep(output\first\tunisia\tun_pol01, replace) nested allopt    

graph save output\first\tunisia\tun_pol01, replace

matrix list e(V_matrix)

use output\first\tunisia\tun_pol01, clear

gen gap=_Y_treated-_Y_synthetic

graph twoway (line gap _time, sort), xline(1964, lpattern(dash)) yline(0, lpattern(dash))

graph save output\first\tunisia\gaptun_pol01, replace

quietly log close


***********************
** Vietnam 704 - 1964** 1964
***********************

use data/oildiscomplete, clear

tsset country_id year

quietly log using output\first\vietnam\vie_pol01.log, replace

***  Vietnam - polity_01 ***

drop if treataspo==1 & country_id!=704

*drop if developing==0

drop if year<1954

foreach variable of varlist /*lrgdpepc hc totalrents manufacturing agrva minva open_pwt*/ HostLev {
bysort country_id: egen `variable'mean = mean(`variable') if inrange(year, 1954, 1963)
gen `variable'missing=1 if `variable'mean==. & inrange(year, 1954, 1963)
bysort country_id: replace `variable'missing=`variable'missing[_n-1] if inrange(year, 1964, 2014)
}

gen ymissing=1 if polity_01==.

recode ymissing (.=0)

bysort country_id: egen ymean = mean(ymissing) 


bysort country_id: egen viemeanpol=mean(polity_01) if inrange(year, 1954, 1963)

foreach variable of varlist /*lrgdpepcmissing hcmissing totalrentsmissing manufacturingmissing agrvamissing minvamissing open_pwtmissing*/ HostLevmissing {
drop if `variable'==1 
}

drop if ymean!=0

synth polity_01 /*lrgdpepc hc totalrents manufacturing agrva minva open_pwt*/ HostLev viemeanpol, trunit(704) trperiod(1964) /*mspeperiod(1965(1)1974) xperiod(1965(1)1974) resultsperiod(1965(1)2014)*/ fig keep(output\first\vietnam\vie_pol01, replace) nested allopt    

graph save output\first\vietnam\vie_pol01, replace

matrix list e(V_matrix)

use output\first\vietnam\vie_pol01, clear

gen gap=_Y_treated-_Y_synthetic

graph twoway (line gap _time, sort), xline(1964, lpattern(dash)) yline(0, lpattern(dash))

graph save output\first\vietnam\gapvie_pol01, replace

quietly log close

/*****************
*      NEW		*
*****************


***********************
** eqguinea 226 - 1999 ** 
***********************

use data/oildiscomplete, clear

tsset country_id year

quietly log using output\first\eqguinea\eqg_pol01.log, replace

***  eqguinea - polity_01 ***

drop if treataspo==1 & country_id!=226

*drop if developing==0

drop if year<1989

foreach variable of varlist lrgdpepc /*hc*/ totalrents manufacturing agrva minva open_pwt HostLev {
bysort country_id: egen `variable'mean = mean(`variable') if inrange(year, 1989, 1998)
gen `variable'missing=1 if `variable'mean==. & inrange(year, 1989, 1998)
bysort country_id: replace `variable'missing=`variable'missing[_n-1] if inrange(year, 1999, 2014)
}

gen ymissing=1 if polity_01==.

recode ymissing (.=0)

bysort country_id: egen ymean = mean(ymissing) 


bysort country_id: egen eqgmeanpol=mean(polity_01) if inrange(year, 1989, 1998)

foreach variable of varlist lrgdpepcmissing /*hcmissing*/ totalrentsmissing manufacturingmissing agrvamissing minvamissing open_pwtmissing HostLevmissing {
drop if `variable'==1 
}

drop if ymean!=0

synth polity_01 lrgdpepc /*hc*/ totalrents manufacturing agrva minva open_pwt HostLev eqgmeanpol, trunit(226) trperiod(1999) /*mspeperiod(1965(1)1974) xperiod(1965(1)1974) resultsperiod(1965(1)2014)*/ fig keep(output\first\eqguinea\eqg_pol01, replace) nested allopt    

graph save output\first\eqguinea\eqg_pol01, replace

matrix list e(V_matrix)

use output\first\eqguinea\eqg_pol01, clear

gen gap=_Y_treated-_Y_synthetic

graph twoway (line gap _time, sort), xline(1999, lpattern(dash)) yline(0, lpattern(dash))

graph save output\first\eqguinea\gapeqg_pol01, replace

quietly log close

***********************
** ghana 288 - 2007 ** 
***********************

use data/oildiscomplete, clear

tsset country_id year

quietly log using output\first\ghana\gha_pol01.log, replace

***  ghana - polity_01 ***

drop if treataspo==1 & country_id!=288

*drop if developing==0

drop if year<1997

foreach variable of varlist lrgdpepc hc totalrents manufacturing agrva minva open_pwt HostLev {
bysort country_id: egen `variable'mean = mean(`variable') if inrange(year, 1997, 2006)
gen `variable'missing=1 if `variable'mean==. & inrange(year, 1997, 2006)
bysort country_id: replace `variable'missing=`variable'missing[_n-1] if inrange(year, 2007, 2014)
}

gen ymissing=1 if polity_01==.

recode ymissing (.=0)

bysort country_id: egen ymean = mean(ymissing) 


bysort country_id: egen ghameanpol=mean(polity_01) if inrange(year, 1997, 2006)

foreach variable of varlist lrgdpepcmissing hcmissing totalrentsmissing manufacturingmissing agrvamissing minvamissing open_pwtmissing HostLevmissing {
drop if `variable'==1 
}

drop if ymean!=0

synth polity_01 lrgdpepc hc totalrents manufacturing agrva minva open_pwt HostLev ghameanpol, trunit(288) trperiod(2007) /*mspeperiod(1965(1)1974) xperiod(1965(1)1974) resultsperiod(1965(1)2014)*/ fig keep(output\first\ghana\gha_pol01, replace) nested allopt    

graph save output\first\ghana\gha_pol01, replace

matrix list e(V_matrix)

use output\first\ghana\gha_pol01, clear

gen gap=_Y_treated-_Y_synthetic

graph twoway (line gap _time, sort), xline(2007, lpattern(dash)) yline(0, lpattern(dash))

graph save output\first\ghana\gapgha_pol01, replace

quietly log close

***********************
** ivory 384 - 1980 ** 
***********************

use data/oildiscomplete, clear

tsset country_id year

quietly log using output\first\ivory\ivo_pol01.log, replace

***  ivory - polity_01 ***

drop if treataspo==1 & country_id!=384

*drop if developing==0

drop if year<1970

foreach variable of varlist /*lrgdpepc hc*/ totalrents manufacturing agrva minva open_pwt HostLev {
bysort country_id: egen `variable'mean = mean(`variable') if inrange(year, 1970, 1979)
gen `variable'missing=1 if `variable'mean==. & inrange(year, 1970, 1979)
bysort country_id: replace `variable'missing=`variable'missing[_n-1] if inrange(year, 1980, 2014)
}

gen ymissing=1 if polity_01==.

recode ymissing (.=0)

bysort country_id: egen ymean = mean(ymissing) 


bysort country_id: egen ivomeanpol=mean(polity_01) if inrange(year, 1970, 1979)

foreach variable of varlist /*lrgdpepcmissing hcmissing*/ totalrentsmissing manufacturingmissing agrvamissing minvamissing open_pwtmissing HostLevmissing {
drop if `variable'==1 
}

drop if ymean!=0

synth polity_01 /*lrgdpepc hc*/ totalrents manufacturing agrva minva open_pwt HostLev ivomeanpol, trunit(384) trperiod(1980) /*mspeperiod(1965(1)1974) xperiod(1965(1)1974) resultsperiod(1965(1)2014)*/ fig keep(output\first\ivory\ivo_pol01, replace) nested allopt    

graph save output\first\ivory\ivo_pol01, replace

matrix list e(V_matrix)

use output\first\ivory\ivo_pol01, clear

gen gap=_Y_treated-_Y_synthetic

graph twoway (line gap _time, sort), xline(1980, lpattern(dash)) yline(0, lpattern(dash))

graph save output\first\ivory\gapivo_pol01, replace

quietly log close

***********************
** sierra 694 - 2009 ** 
***********************

use data/oildiscomplete, clear

tsset country_id year

quietly log using output\first\sierra\sie_pol01.log, replace

***  sierra - polity_01 ***

drop if treataspo==1 & country_id!=694

*drop if developing==0

drop if year<1999

foreach variable of varlist lrgdpepc hc totalrents manufacturing agrva minva open_pwt HostLev {
bysort country_id: egen `variable'mean = mean(`variable') if inrange(year, 1999, 2008)
gen `variable'missing=1 if `variable'mean==. & inrange(year, 1999, 2008)
bysort country_id: replace `variable'missing=`variable'missing[_n-1] if inrange(year, 2009, 2014)
}

gen ymissing=1 if polity_01==.

recode ymissing (.=0)

bysort country_id: egen ymean = mean(ymissing) 


bysort country_id: egen siemeanpol=mean(polity_01) if inrange(year, 1999, 2008)

foreach variable of varlist lrgdpepcmissing hcmissing totalrentsmissing manufacturingmissing agrvamissing minvamissing open_pwtmissing HostLevmissing {
drop if `variable'==1 
}

drop if ymean!=0

synth polity_01 lrgdpepc hc totalrents manufacturing agrva minva open_pwt HostLev siemeanpol, trunit(694) trperiod(2009) /*mspeperiod(1965(1)1974) xperiod(1965(1)1974) resultsperiod(1965(1)2014)*/ fig keep(output\first\sierra\sie_pol01, replace) nested allopt    

graph save output\first\sierra\sie_pol01, replace

matrix list e(V_matrix)

use output\first\sierra\sie_pol01, clear

gen gap=_Y_treated-_Y_synthetic

graph twoway (line gap _time, sort), xline(2009, lpattern(dash)) yline(0, lpattern(dash))

graph save output\first\sierra\gapsie_pol01, replace

quietly log close


***********************
** yemen 887 - 1985 ** 
***********************

use data/oildiscomplete, clear

tsset country_id year

quietly log using output\first\yemen\yem_pol01.log, replace

***  yemen - polity_01 ***

drop if treataspo==1 & country_id!=887

*drop if developing==0

drop if year<1975

foreach variable of varlist /*lrgdpepc hc*/ totalrents manufacturing agrva minva /*open_pwt*/ HostLev {
bysort country_id: egen `variable'mean = mean(`variable') if inrange(year, 1975,1984)
gen `variable'missing=1 if `variable'mean==. & inrange(year, 1975,1984)
bysort country_id: replace `variable'missing=`variable'missing[_n-1] if inrange(year, 1985, 2014)
}

gen ymissing=1 if polity_01==.

recode ymissing (.=0)

bysort country_id: egen ymean = mean(ymissing) 


bysort country_id: egen yemmeanpol=mean(polity_01) if inrange(year, 1975,1984)

foreach variable of varlist /*lrgdpepcmissing hcmissing*/ totalrentsmissing manufacturingmissing agrvamissing minvamissing /*open_pwtmissing*/ HostLevmissing {
drop if `variable'==1 
}

drop if ymean!=0

synth polity_01 /*lrgdpepc hc*/ totalrents manufacturing agrva minva /*open_pwt*/ HostLev yemmeanpol, trunit(887) trperiod(1985) /*mspeperiod(1965(1)1974) xperiod(1965(1)1974) resultsperiod(1965(1)2014)*/ fig keep(output\first\yemen\yem_pol01, replace) nested allopt    

graph save output\first\yemen\yem_pol01, replace

matrix list e(V_matrix)

use output\first\yemen\yem_pol01, clear

gen gap=_Y_treated-_Y_synthetic

graph twoway (line gap _time, sort), xline(1985, lpattern(dash)) yline(0, lpattern(dash))

graph save output\first\yemen\gapyem_pol01, replace

quietly log close


*****
clear
