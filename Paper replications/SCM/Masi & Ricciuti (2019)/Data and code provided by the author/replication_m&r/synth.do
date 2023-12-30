******************************************************************************** 
****        The Heterogeneous Effect of Oil Discoveries on Democracy        ****
********************************************************************************

clear
set more off
capture log close

/***************************************
	   * synthetic control *
			   * polity *
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

use data/oildiscomplete, clear

tsset country_id year

quietly log using output\brazil\synth\polity\bra_pol01.log, replace

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


synth polity_01 lrgdpepc hc totalrents manufacturing agrva minva open_pwt HostLev brameanpol, trunit(76) trperiod(1975) /*mspeperiod(1965(1)1974) xperiod(1965(1)1974) resultsperiod(1965(1)2014)*/ fig keep(output\brazil\synth\polity\bra_pol01, replace) nested allopt    

graph save output\brazil\synth\polity\bra_pol01, replace

matrix list e(V_matrix)

use output\brazil\synth\polity\bra_pol01, clear

gen gap=_Y_treated-_Y_synthetic

graph twoway (line gap _time, sort), xline(1975, lpattern(dash)) yline(0, lpattern(dash))

graph save output\brazil\synth\polity\gapbra_pol01, replace



quietly log close


**************************
** Cameroon 120 - 1977  **
**************************

use data/oildiscomplete, clear

tsset country_id year

quietly log using output\cameroon\synth\polity\cam_pol01.log, replace

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


synth polity_01 lrgdpepc hc totalrents manufacturing agrva minva open_pwt HostLev cammeanpol , trunit(120) trperiod(1977) /*mspeperiod(1967(1)1976) xperiod(1967(1)1976) resultsperiod(1967(1)2014)*/ fig keep(output\cameroon\synth\polity\cam_pol01, replace) nested allopt    

graph save output\cameroon\synth\polity\cam_pol01, replace

matrix list e(V_matrix)

use output\cameroon\synth\polity\cam_pol01, clear

gen gap=_Y_treated-_Y_synthetic

graph twoway (line gap _time, sort), xline(1977, lpattern(dash)) yline(0, lpattern(dash))

graph save output\cameroon\synth\polity\gapcam_pol01, replace

quietly log close


**************************
** Chad 148 - 1977  **
**************************

use data/oildiscomplete, clear

tsset country_id year

quietly log using output\chad\synth\polity\cha_pol01.log, replace

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

synth polity_01 lrgdpepc totalrents manufacturing agrva minva open_pwt HostLev chameanpol , trunit(148) trperiod(1977) /*mspeperiod(1967(1)1976) xperiod(1967(1)1976) resultsperiod(1967(1)2014)*/ fig keep(output\chad\synth\polity\cha_pol01, replace) nested allopt   

graph save output\chad\synth\polity\cha_pol01, replace

matrix list e(V_matrix)

use output\chad\synth\polity\cha_pol01, clear

gen gap=_Y_treated-_Y_synthetic

graph twoway (line gap _time, sort), xline(1977, lpattern(dash)) yline(0, lpattern(dash))

graph save output\chad\synth\polity\gapcha_pol01, replace

quietly log close

**************************
** Colombia 170 - 1992  **
**************************

use data/oildiscomplete, clear

tsset country_id year

quietly log using output\colombia\synth\polity\col_pol01.log, replace

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

synth polity_01 lrgdpepc hc totalrents manufacturing agrva minva open_pwt HostLev colmeanpol, trunit(170) trperiod(1992) /*mspeperiod(1982(1)1991) xperiod(1982(1)1991) resultsperiod(1982(1)2014)*/ fig keep(output\colombia\synth\polity\col_pol01, replace) nested allopt   

graph save output\colombia\synth\polity\col_pol01, replace

matrix list e(V_matrix)

use output\colombia\synth\polity\col_pol01, clear

gen gap=_Y_treated-_Y_synthetic

graph twoway (line gap _time, sort), xline(1992, lpattern(dash)) yline(0, lpattern(dash))

graph save output\colombia\synth\polity\gapcol_pol01, replace

quietly log close

******************************
** Congo (Rep.) 178 - 1984  **
******************************

use data/oildiscomplete, clear

tsset country_id year

quietly log using output\congo\synth\polity\con_pol01.log, replace

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
synth polity_01 lrgdpepc hc totalrents manufacturing agrva minva open_pwt HostLev conmeanpol, trunit(178) trperiod(1984) /*mspeperiod(1974(1)1983) xperiod(1974(1)1983) resultsperiod(1974(1)2014)*/ fig keep(output\congo\synth\polity\con_pol01, replace)  nested 

graph save output\congo\synth\polity\con_pol01, replace

matrix list e(V_matrix)

use output\congo\synth\polity\con_pol01, clear

gen gap=_Y_treated-_Y_synthetic

graph twoway (line gap _time, sort), xline(1984, lpattern(dash)) yline(0, lpattern(dash))

graph save output\congo\synth\polity\gapcon_pol01, replace

quietly log close


******************************
**    Gabon 266 - 1985      **
******************************

use data/oildiscomplete, clear

tsset country_id year

quietly log using output\gabon\synth\polity\gab_pol01.log, replace

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
synth polity_01 lrgdpepc hc totalrents manufacturing agrva minva open_pwt HostLev gabmeanpol, trunit(266) trperiod(1985) /*mspeperiod(1975(1)1984) xperiod(1975(1)1984) resultsperiod(1975(1)2014)*/ fig keep(output\gabon\synth\polity\gab_pol01, replace) nested /*allopt */   

graph save output\gabon\synth\polity\gab_pol01, replace

matrix list e(V_matrix)

use output\gabon\synth\polity\gab_pol01, clear

gen gap=_Y_treated-_Y_synthetic

graph twoway (line gap _time, sort), xline(1985, lpattern(dash)) yline(0, lpattern(dash))

graph save output\gabon\synth\polity\gapgab_pol01, replace

quietly log close


***********************
** India 356 - 1974  **
***********************

use data/oildiscomplete, clear

tsset country_id year

quietly log using output\india\synth\polity\ind_pol01.log, replace

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

synth polity_01 lrgdpepc hc totalrents manufacturing agrva minva HostLev open_pwt indmeanpol, trunit(356) trperiod(1974) /*mspeperiod(1964(1)1973) xperiod(1964(1)1973) resultsperiod(1964(1)2014)*/ fig keep(output\india\synth\polity\ind_pol01, replace) nested allopt   

graph save output\india\synth\polity\ind_pol01, replace

matrix list e(V_matrix)

use output\india\synth\polity\ind_pol01, clear

gen gap=_Y_treated-_Y_synthetic

graph twoway (line gap _time, sort), xline(1974, lpattern(dash)) yline(0, lpattern(dash))

graph save output\india\synth\polity\gapind_pol01, replace

quietly log close


****************************
** Kazakhstan 398 - 2000  **
****************************

use data/oildiscomplete, clear

tsset country_id year

quietly log using output\kazakhstan\synth\polity\kaz_pol01.log, replace

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
synth polity_01 lrgdpepc hc totalrents manufacturing agrva minva open_pwt HostLev kazmeanpol, trunit(398) trperiod(2000)/*mspeperiod(1991(1)1999) xperiod(1991(1)1999) resultsperiod(1991(1)2014)*/ fig keep(output\kazakhstan\synth\polity\kaz_pol01, replace) nested allopt    

graph save output\kazakhstan\synth\polity\kaz_pol01, replace

matrix list e(V_matrix)

use output\kazakhstan\synth\polity\kaz_pol01, clear

gen gap=_Y_treated-_Y_synthetic

graph twoway (line gap _time, sort), xline(2000, lpattern(dash)) yline(0, lpattern(dash))

graph save output\kazakhstan\synth\polity\gapkaz_pol01, replace

quietly log close


**************************
** Mexico 484 - 1977  **
**************************

use data/oildiscomplete, clear

tsset country_id year

quietly log using output\mexico\synth\polity\mex_pol01.log, replace

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

synth polity_01 lrgdpepc hc totalrents manufacturing agrva minva HostLev open_pwt mexmeanpol, trunit(484) trperiod(1977) /*mspeperiod(1967(1)1976) xperiod(1967(1)1976) resultsperiod(1967(1)2014)*/ fig keep(output\mexico\synth\polity\mex_pol01, replace) nested allopt    

graph save output\mexico\synth\polity\mex_pol01, replace

matrix list e(V_matrix)

use output\mexico\synth\polity\mex_pol01, clear

gen gap=_Y_treated-_Y_synthetic

graph twoway (line gap _time, sort), xline(1977, lpattern(dash)) yline(0, lpattern(dash))

graph save output\mexico\synth\polity\gapmex_pol01, replace

quietly log close



******************************
**   Sudan 729 - 1980    **
******************************

use data/oildiscomplete, clear

tsset country_id year

quietly log using output\sudan\synth\polity\sud_pol01.log, replace

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

synth polity_01 lrgdpepc hc totalrents manufacturing agrva minva open_pwt HostLev sudmeanpol, trunit(729) trperiod(1980) /*mspeperiod(1970(1)1979) xperiod(1970(1)1979) resultsperiod(1970(1)2014)*/ fig keep(output\sudan\synth\polity\sud_pol01, replace) nested allopt    

graph save output\sudan\synth\polity\sud_pol01, replace

matrix list e(V_matrix)

use output\sudan\synth\polity\sud_pol01, clear

gen gap=_Y_treated-_Y_synthetic

graph twoway (line gap _time, sort), xline(1980, lpattern(dash)) yline(0, lpattern(dash))

graph save output\sudan\synth\polity\gapsud_pol01, replace

quietly log close


**************************
** Tunisia 788 - 1971  **
**************************

use data/oildiscomplete, clear

tsset country_id year

quietly log using output\tunisia\synth\polity\tun_pol01.log, replace

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

synth polity_01 lrgdpepc hc open_pwt totalrents manufacturing agrva minva HostLev tunmeanpol, trunit(788) trperiod(1971) /*mspeperiod(1961(1)1970) xperiod(1961(1)1970) resultsperiod(1961(1)2014)*/ fig keep(output\tunisia\synth\polity\tun_pol01, replace) nested allopt    

graph save output\tunisia\synth\polity\tun_pol01, replace

matrix list e(V_matrix)

use output\tunisia\synth\polity\tun_pol01, clear

gen gap=_Y_treated-_Y_synthetic

graph twoway (line gap _time, sort), xline(1971, lpattern(dash)) yline(0, lpattern(dash))

graph save output\tunisia\synth\polity\gaptun_pol01, replace

quietly log close


***********************
** Vietnam 704 - 1975**
***********************

use data/oildiscomplete, clear

tsset country_id year

quietly log using output\vietnam\synth\polity\vie_pol01.log, replace

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

synth polity_01 lrgdpepc hc totalrents manufacturing agrva minva HostLev open_pwt viemeanpol, trunit(704) trperiod(1975) /*mspeperiod(1965(1)1974) xperiod(1965(1)1974) resultsperiod(1965(1)2014)*/ fig keep(output\vietnam\synth\polity\vie_pol01, replace) nested allopt    

graph save output\vietnam\synth\polity\vie_pol01, replace

matrix list e(V_matrix)

use output\vietnam\synth\polity\vie_pol01, clear

gen gap=_Y_treated-_Y_synthetic

graph twoway (line gap _time, sort), xline(1975, lpattern(dash)) yline(0, lpattern(dash))

graph save output\vietnam\synth\polity\gapvie_pol01, replace

quietly log close

******************************
**   Pakistan 586 - 1983    **
******************************

use data/oildiscomplete, clear

tsset country_id year

quietly log using output\pakistan\synth\polity\pak_pol01.log, replace

***  Pakistan - polity_01 ***

drop if treataspo==1 & country_id!=586

drop if year<1973

foreach variable of varlist lrgdpepc hc totalrents manufacturing agrva minva open_pwt HostLev {
bysort country_id: egen `variable'mean = mean(`variable') if inrange(year, 1973, 1982)
gen `variable'missing=1 if `variable'mean==. & inrange(year, 1973, 1982)
bysort country_id: replace `variable'missing=`variable'missing[_n-1] if inrange(year, 1983, 2014)
}

gen ymissing=1 if polity_01==.

recode ymissing (.=0)

bysort country_id: egen ymean = mean(ymissing) 


bysort country_id: egen pakmeanpol=mean(polity_01) if inrange(year, 1973, 1982)

foreach variable of varlist lrgdpepcmissing hcmissing totalrentsmissing manufacturingmissing agrvamissing minvamissing open_pwtmissing HostLevmissing {
drop if `variable'==1 
}

drop if ymean!=0

synth polity_01 lrgdpepc hc totalrents manufacturing agrva minva HostLev open_pwt pakmeanpol, trunit(586) trperiod(1983) /*mspeperiod(1965(1)1974) xperiod(1965(1)1974) resultsperiod(1965(1)2014)*/ fig keep(output\pakistan\synth\polity\pak_pol01, replace) nested allopt    

graph save output\pakistan\synth\polity\pak_pol01, replace

matrix list e(V_matrix)

use output\pakistan\synth\polity\pak_pol01, clear

gen gap=_Y_treated-_Y_synthetic

graph twoway (line gap _time, sort), xline(1983, lpattern(dash)) yline(0, lpattern(dash))

graph save output\pakistan\synth\polity\gappak_pol01, replace

quietly log close

**************************
** Malaysia 458 - 1973  **
**************************

use data/oildiscomplete, clear

tsset country_id year

quietly log using output\malaysia\synth\polity\mal_pol01.log, replace

***  Malaysia - polity_01 ***

drop if treataspo==1 & country_id!=458

drop if year<1963

foreach variable of varlist lrgdpepc hc totalrents manufacturing agrva minva open_pwt HostLev {
bysort country_id: egen `variable'mean = mean(`variable') if inrange(year, 1963, 1972)
gen `variable'missing=1 if `variable'mean==. & inrange(year, 1963, 1972)
bysort country_id: replace `variable'missing=`variable'missing[_n-1] if inrange(year, 1973, 2014)
}

gen ymissing=1 if polity_01==.

recode ymissing (.=0)

bysort country_id: egen ymean = mean(ymissing) 


bysort country_id: egen malmeanpol=mean(polity_01) if inrange(year, 1963, 1972)

foreach variable of varlist lrgdpepcmissing hcmissing totalrentsmissing manufacturingmissing agrvamissing minvamissing open_pwtmissing HostLevmissing {
drop if `variable'==1 
}

drop if ymean!=0

synth polity_01 lrgdpepc hc totalrents manufacturing agrva minva HostLev open_pwt malmeanpol, trunit(458) trperiod(1973) /*mspeperiod(1965(1)1974) xperiod(1965(1)1974) resultsperiod(1965(1)2014)*/ fig keep(output\malaysia\synth\polity\mal_pol01, replace) nested allopt    

graph save output\malaysia\synth\polity\mal_pol01, replace

matrix list e(V_matrix)

use output\malaysia\synth\polity\mal_pol01, clear

gen gap=_Y_treated-_Y_synthetic

graph twoway (line gap _time, sort), xline(1973, lpattern(dash)) yline(0, lpattern(dash))

graph save output\malaysia\synth\polity\gapmal_pol01, replace

quietly log close


******************************
**   Thailand 764 - 1981    **
******************************/

use data/oildiscomplete, clear

tsset country_id year

quietly log using output\thailand\synth\polity\tha_pol01.log, replace

*** Thailand - polity_01 ***

drop if treataspo==1 & country_id!=764

*drop if developing==0

drop if year<1971

foreach variable of varlist lrgdpepc hc totalrents manufacturing agrva minva open_pwt HostLev {
bysort country_id: egen `variable'mean = mean(`variable') if inrange(year, 1971, 1980)
gen `variable'missing=1 if `variable'mean==. & inrange(year, 1971, 1980)
bysort country_id: replace `variable'missing=`variable'missing[_n-1] if inrange(year, 1981, 2014)
}

gen ymissing=1 if polity_01==.

recode ymissing (.=0)

bysort country_id: egen ymean = mean(ymissing) 


bysort country_id: egen thameanpol=mean(polity_01) if inrange(year, 1971, 1980)

foreach variable of varlist lrgdpepcmissing hcmissing totalrentsmissing manufacturingmissing agrvamissing minvamissing open_pwtmissing HostLevmissing {
drop if `variable'==1 
}

drop if ymean!=0

synth polity_01 lrgdpepc hc totalrents manufacturing agrva minva HostLev open_pwt thameanpol, trunit(764) trperiod(1981) /*mspeperiod(1965(1)1974) xperiod(1965(1)1974) resultsperiod(1965(1)2014)*/ fig keep(output\thailand\synth\polity\tha_pol01, replace) nested allopt    

graph save output\thailand\synth\polity\tha_pol01, replace

matrix list e(V_matrix)

use output\thailand\synth\polity\tha_pol01, clear

gen gap=_Y_treated-_Y_synthetic

graph twoway (line gap _time, sort), xline(1981, lpattern(dash)) yline(0, lpattern(dash))

graph save output\thailand\synth\polity\gaptha_pol01, replace

quietly log close


*****
clear
