******************************************************************************** 
****          OIL DISCOVERIES, DEMOCRACY AND STATE CAPACITY                 ****
********************************************************************************

clear
set more off
capture log close

/***************************************
			* placebo *
			   * polity *
		Selected Case studies
			   			   
* Treatment: discovery ASPO			   
* Outcome variable: polity_01 POLIITY IV
* Predictors: lrgdpepc PWT 8.1
			  hc  PWT 8.1
			  totalrents(1970(1)19??) WB  
			  minva(1970(1)19??) UNCTAD
			  agrva(1970(1)19??) UNCTAD
			  manufacturing(1970(1)19??) UNCTAD
			  HostLev COW
			  open_pwt PWT 8.1
			  averaged outcome
* Nested allopt
			  	  
****************************************/




/***********************
** Brazil 76 - 1975  **
***********************

clear all

use data/oildiscomplete, clear

tsset country_id year

quietly log using output\brazil\placebo\polity\bra_pol01.log, replace

***  Brazil - polity_01 ***

****!!! no Switzerland !!!****

drop if treataspo==1 & country_id!=76

*drop if developing==0

foreach country of numlist 4 51	70 90 104 112 192 203 232 233 268 296 328 332 384 408 417 428 440 498 499 558 626 688 690 703 705 706 762 807 ///
64 132 174 212 226 231 262 324 422 450 624 659 662 670 678 740 854 ///
591 ///
50 72 84 116 242 352 368 426 462 470 480 508 516 716 748 800 {
drop if country_id==`country'
}

tempname resmat
        foreach placebo of numlist 76 56 100 108 140 144 180 188 196 204 214 222 246 270 288 300 320 340 372 376 388 392 400 404 410 418 430 442 454 466 478 496 504 524 554 562 600 608 616 620 646 686 694 702 710 724 752 768 834 858 894 {
		synth polity_01 lrgdpepc hc totalrents(1970(1)1974) manufacturing(1970(1)1974) agrva(1970(1)1974) minva(1970(1)1974) open_pwt HostLev brameanpol(1974), trunit(`placebo') trperiod(1975) mspeperiod(1965(1)1974) xperiod(1965(1)1974) resultsperiod(1965(1)2014)  keep(output\brazil\placebo\polity\bra`placebo', replace)  nested allopt  
		matrix `resmat' = nullmat(`resmat') \ e(RMSPE)
        local names `"`names' `"`placebo'"'"'
        }
        mat colnames `resmat' = "RMSPE"
        mat rownames `resmat' = `names'
        matlist `resmat' , row("Treated Unit")

		
clear

foreach placebo of numlist 76 56 100 108 140 144 180 188 196 204 214 222 246 270 288 300 320 340 372 376 388 392 400 404 410 418 430 442 454 466 478 496 504 524 554 562 600 608 616 620 646 686 694 702 710 724 752 768 834 858 894 {
use output\brazil\placebo\polity\bra`placebo'
drop _Co_Number _W_Weight
drop if _time==.
save output\brazil\placebo\polity\bra`placebo',replace
clear
}

*/
use data/placebo, clear


foreach code of numlist 76 56 100 108 140 144 180 188 196 204 214 222 246 270 288 300 320 340 372 376 388 392 400 404 410 418 430 442 454 466 478 496 504 524 554 562 600 608 616 620 646 686 694 702 710 724 752  768 834 858 894 {
merge 1:1 _time using output\brazil\placebo\polity\bra`code'
rename _Y_treated _Y_treated`code'
rename _Y_synthetic _Y_synthetic`code'
drop _merge
}


foreach code of numlist 76 56 100 108 140 144 180 188 196 204 214 222 246 270 288 300 320 340 372 376 388 392 400 404 410 418 430 442 454 466 478 496 504 524 554 562 600 608 616 620 646 686 694 702 710 724 752  768 834 858 894 {
gen gap`code'= _Y_treated`code'- _Y_synthetic`code'
}

drop if _time<1965

save figures\placebo\placebo\placebobra_pol01, replace

*graph twoway (line gap* _time, sort) (line gap76 _time, sort  lwidth(thick) lcolor(black)), xline(1975, lpattern(dash)) yline(0, lpattern(dash)) legend(off)

*graph save figures\placebo\placebobra_pol01, replace

keep gap*

xpose, clear v

rename (v1	v2	v3	v4	v5	v6	v7	v8	v9	v10	v11	v12	v13	v14	v15	v16	v17	v18	v19	v20	v21	v22	v23	v24	v25	v26	v27	v28	v29	v30	v31	v32	v33	v34	v35	v36	v37	v38	v39	v40	v41	v42	v43	v44	v45	v46	v47	v48	v49	v50 _varname) (t_10	t_9	t_8	t_7	t_6	t_5	t_4	t_3	t_2	t_1	t0	t1	t2	t3	t4	t5	t6	t7	t8	t9	t10	t11	t12	t13	t14	t15	t16	t17	t18	t19	t20	t21	t22	t23	t24	t25	t26	t27	t28	t29	t30	t31	t32	t33	t34	t35	t36	t37	t38	t39 country)

gen gap2_10=t_10^2

gen gap2_9=t_9^2

gen gap2_8=t_8^2

gen gap2_7=t_7^2

gen gap2_6=t_6^2

gen gap2_5=t_5^2

gen gap2_4=t_4^2

gen gap2_3=t_3^2

gen gap2_2=t_2^2

gen gap2_1=t_1^2

egen mspe=rowmean(gap2_*) 

gen rmspe=sqrt(mspe)

order country mspe rmspe

keep country t* mspe rmspe

drop if rmspe>0.1

export excel figures\placebo\placebo, first(var) sheet(brazil) sheetrep

drop mspe rmspe t_10-t0

export excel figures\placebo\placebo, first(var) sheet(brazil2) sheetrep

*quietly log close


/**************************
** Cameroon 120 - 1977  **
**************************

use data/oildiscomplete, clear

tsset country_id year

quietly log using output\cameroon\placebo\polity\cam_pol01.log, replace

***  Cameroon - polity_01 ***

****!!! no Jordan, Mali, Switzerland, nepal !!!****


drop if treataspo==1 & country_id!=120

*drop if developing==0

foreach country of numlist 4 51	70 90 104 112 192 203 232 233 268 296 328 332 384 408 417 428 440 498 499 558 626 688 690 703 705 706 762 807 ///
64 132 174 212 226 231 262 324 422 450 624 659 662 670 678 740 854 ///
591 ///
50 84 116 242 352 368 462 470 480 508 516 716 748 800 {
drop if country_id==`country'
}

tempname resmat
        foreach placebo of numlist 120 72 388 426 56 100 108 140 144 180 188 196 204 214 222 246 270 288 300 320 340 372 376 392 400 404 410 418 430 442 454 478 496 504 554 562 600 608 616 620 646 686 694 702 710 724 752  768 834 858 894 {
		synth polity_01 lrgdpepc hc totalrents(1970(1)1976) manufacturing(1970(1)1976) agrva(1970(1)1976) minva(1970(1)1976) open_pwt HostLev cammeanpol(1976) , trunit(`placebo') trperiod(1977) mspeperiod(1967(1)1976) xperiod(1967(1)1976) resultsperiod(1967(1)2014)  keep(output\cameroon\placebo\polity\cam`placebo', replace)  nested allopt  
		matrix `resmat' = nullmat(`resmat') \ e(RMSPE)
        local names `"`names' `"`placebo'"'"'
        }
        mat colnames `resmat' = "RMSPE"
        mat rownames `resmat' = `names'
        matlist `resmat' , row("Treated Unit")

		
clear

foreach placebo of numlist 120 72 388 426 56 100 108 140 144 180 188 196 204 214 222 246 270 288 300 320 340 372 376 392 404 410 418 430 442 454 478 496 504  554 562 600 608 616 620 646 686 694 702 710 724 752 768 834 858 894 {
use output\cameroon\placebo\polity\cam`placebo'
drop _Co_Number _W_Weight
drop if _time==.
save output\cameroon\placebo\polity\cam`placebo',replace
clear
}

*/
use data/placebo, clear


foreach code of numlist 120 72 388 426 56 100 108 140 144 180 188 196 204 214 222 246 270 288 300 320 340 372 376 392 404 410 418 430 442 454 478 496 504 554 562 600 608 616 620 646 686 694 702 710 724 752 768 834 858 894 {
merge 1:1 _time using output\cameroon\placebo\polity\cam`code'
rename _Y_treated _Y_treated`code'
rename _Y_synthetic _Y_synthetic`code'
drop _merge
}


foreach code of numlist 120 72 388 426 56 100 108 140 144 180 188 196 204 214 222 246 270 288 300 320 340 372 376 392 404 410 418 430 442 454  478 496 504  554 562 600 608 616 620 646 686 694 702 710 724 752 768 834 858 894 {
gen gap`code'= _Y_treated`code'- _Y_synthetic`code'
}

drop if _time<1967

save figures\placebo\placebo\placebocam_pol01, replace

*graph twoway (line gap* _time, sort) (line gap120 _time, sort  lwidth(thick) lcolor(black)), xline(1977, lpattern(dash)) yline(0, lpattern(dash)) legend(off)

*graph save figures\placebo\placebocam_pol01, replace

keep gap*

xpose, clear v

rename (v1	v2	v3	v4	v5	v6	v7	v8	v9	v10	v11	v12	v13	v14	v15	v16	v17	v18	v19	v20	v21	v22	v23	v24	v25	v26	v27	v28	v29	v30	v31	v32	v33	v34	v35	v36	v37	v38	v39	v40	v41	v42	v43	v44	v45	v46	v47	v48 _varname) (t_10	t_9	t_8	t_7	t_6	t_5	t_4	t_3	t_2	t_1	t0	t1	t2	t3	t4	t5	t6	t7	t8	t9	t10	t11	t12	t13	t14	t15	t16	t17	t18	t19	t20	t21	t22	t23	t24	t25	t26	t27	t28	t29	t30	t31	t32	t33	t34	t35	t36	t37 country)

gen gap2_10=t_10^2

gen gap2_9=t_9^2

gen gap2_8=t_8^2

gen gap2_7=t_7^2

gen gap2_6=t_6^2

gen gap2_5=t_5^2

gen gap2_4=t_4^2

gen gap2_3=t_3^2

gen gap2_2=t_2^2

gen gap2_1=t_1^2

egen mspe=rowmean(gap2_*) 

gen rmspe=sqrt(mspe)

order country mspe rmspe

keep country t* mspe rmspe

drop if rmspe>0.1

export excel figures\placebo\placebo, first(var) sheet(cameroon) sheetrep

drop mspe rmspe t_10-t0

export excel figures\placebo\placebo, first(var) sheet(cameroon2) sheetrep

*quietly log close

/*

/**************************
** Chad 148 - 1977  **
**************************

use data/oildiscomplete, clear

tsset country_id year

quietly log using output\chad\placebo\polity\cha_pol01.log, replace

***  Cahad - polity_01 ***

drop if treataspo==1 & country_id!=148

*drop if developing==0

foreach country of numlist 4 51	70 90 104 112 192 203 232 233 268 296 328 332 384 408 417 428 440 498 499 558 626 688 690 703 705 706 762 807 ///
591 ///
132 174 212 226 262 422 624 659 662 670 678 706 740 50 84 116 242 352 368 462 470 480 508 516 716 748 800 {
drop if country_id==`country'
}

*** !!!!! hc is missing !!!!! ***

tempname resmat
        foreach placebo of numlist 148 64 72 231 324 388 426 450 854 56 100 108 140 144 180 188 196 204 214 222 246 270 288 300 320 340 372 376 392 400 404 410 418 430 442 454 466 478 496 504 524 554 562 600 608 616 620 646 686 694 702 710 724 752 756 768 834 858 894 {
		synth polity_01 lrgdpepc totalrents(1970(1)1976) manufacturing(1970(1)1976) agrva(1970(1)1976) minva(1970(1)1976) open_pwt HostLev chameanpol(1976) , trunit(`placebo') trperiod(1977) mspeperiod(1967(1)1976) xperiod(1967(1)1976) resultsperiod(1967(1)2014)  keep(output\chad\placebo\polity\cha`placebo', replace)  nested allopt 
		matrix `resmat' = nullmat(`resmat') \ e(RMSPE)
        local names `"`names' `"`placebo'"'"'
        }
        mat colnames `resmat' = "RMSPE"
        mat rownames `resmat' = `names'
        matlist `resmat' , row("Treated Unit")

		
clear

foreach placebo of numlist 148 64 72 231 324  388 426 450 854 56 100 108 140 144 180 188 196 204 214 222 246 270 288 300 320 340 372 376 392 400 404 410 418 430 442 454 466 478 496 504 524 554 562 600 608 616 620 646 686 694 702 710 724 752 756 768 834 858 894 {
use output\chad\placebo\polity\cha`placebo'
drop _Co_Number _W_Weight
drop if _time==.
save output\chad\placebo\polity\cha`placebo',replace
clear
}

*/
use data/placebo, clear


foreach code of numlist 148 64 72 231 324 388 426 450 854 56 100 108 140 144 180 188 196 204 214 222 246 270 288 300 320 340 372 376 392 400 404 410 418 430 442 454 466 478 496 504 524 554 562 600 608 616 620 646 686 694 702 710 724 752 756 768 834 858 894 {
merge 1:1 _time using output\chad\placebo\polity\cha`code'
rename _Y_treated _Y_treated`code'
rename _Y_synthetic _Y_synthetic`code'
drop _merge
}


foreach code of numlist 148 64 72 231 324 388 426 450 854 56 100 108 140 144 180 188 196 204 214 222 246 270 288 300 320 340 372 376 392 400 404 410 418 430 442 454 466 478 496 504 524 554 562 600 608 616 620 646 686 694 702 710 724 752 756 768 834 858 894 {
gen gap`code'= _Y_treated`code'- _Y_synthetic`code'
}

drop if _time<1967

save figures\placebo\placebo\placebocha_pol01, replace

*graph twoway (line gap* _time, sort) (line gap148 _time, sort  lwidth(thick) lcolor(black)), xline(1977, lpattern(dash)) yline(0, lpattern(dash)) legend(off)

*graph save figures\placebo\placebocha_pol01, replace


keep gap*

xpose, clear v

rename (v1	v2	v3	v4	v5	v6	v7	v8	v9	v10	v11	v12	v13	v14	v15	v16	v17	v18	v19	v20	v21	v22	v23	v24	v25	v26	v27	v28	v29	v30	v31	v32	v33	v34	v35	v36	v37	v38	v39	v40	v41	v42	v43	v44	v45	v46	v47	v48 _varname) (t_10	t_9	t_8	t_7	t_6	t_5	t_4	t_3	t_2	t_1	t0	t1	t2	t3	t4	t5	t6	t7	t8	t9	t10	t11	t12	t13	t14	t15	t16	t17	t18	t19	t20	t21	t22	t23	t24	t25	t26	t27	t28	t29	t30	t31	t32	t33	t34	t35	t36	t37 country)

gen gap2_10=t_10^2

gen gap2_9=t_9^2

gen gap2_8=t_8^2

gen gap2_7=t_7^2

gen gap2_6=t_6^2

gen gap2_5=t_5^2

gen gap2_4=t_4^2

gen gap2_3=t_3^2

gen gap2_2=t_2^2

gen gap2_1=t_1^2

egen mspe=rowmean(gap2_*) 

gen rmspe=sqrt(mspe)

order country mspe rmspe

keep country t* mspe rmspe

drop if rmspe>0.1

export excel figures\placebo\placebo, first(var) sheet(chad) sheetrep

drop mspe rmspe t_10-t0

export excel figures\placebo\placebo, first(var) sheet(chad2) sheetrep

*quietly log close



/**************************
** Colombia 170 - 1992  **
**************************

use data/oildiscomplete, clear

tsset country_id year

quietly log using output\colombia\placebo\polity\col_pol01.log, replace

***  Colombia - polity_01 ***

***!!!!no botswana !!!!****

drop if treataspo==1 & country_id!=170

*drop if developing==0

foreach country of numlist 4 90 104 192 296 328 332 384 408 558 626 690 706 ///
64 70 112 132 174 212 226 231 262 268 324 422 450 499 624 659 662 670 678 740 807 854 ///
51 84 116 233 232 352 368 417 428 440 462 470 498 516 688 703 705 762 {
drop if country_id==`country'
}

tempname resmat
        foreach placebo of numlist 170 50  203 242 388 426 480 508 591 716 748 800 56 100 108 140 144 180 188 196 204 214 222 246 270 288 300 320 340 372 376 392 400 404 410 418 430 442 454 466 478 496 504 524 554 562 600 608 616 620 646 686 694 702 710 724 752 756 768 834 858 894 {
		synth polity_01 lrgdpepc hc totalrents manufacturing agrva minva open_pwt HostLev colmeanpol(1991), trunit(`placebo') trperiod(1992) mspeperiod(1982(1)1991) xperiod(1982(1)1991) resultsperiod(1982(1)2014)  keep(output\colombia\placebo\polity\col`placebo', replace)  nested allopt 
		matrix `resmat' = nullmat(`resmat') \ e(RMSPE)
        local names `"`names' `"`placebo'"'"'
        }
        mat colnames `resmat' = "RMSPE"
        mat rownames `resmat' = `names'
        matlist `resmat' , row("Treated Unit")

		
clear

foreach placebo of numlist 170 50  203 242 388 426 480 508 591 716 748 56 100 108 140 144 180 188 196 204 214 222 246 270 288 300 320 340 372 376 392 400 404 410 418 430 442 454 466 478 496 504 524 554 562 600 608 616 620 646 686 694 702 710 724 752 756 768 834 858 894 {
use output\colombia\placebo\polity\col`placebo'
drop _Co_Number _W_Weight
drop if _time==.
save output\colombia\placebo\polity\col`placebo',replace
clear
}

*/
use data/placebo, clear


foreach code of numlist 170 50 203 242 388 426 480 508 591 716 748 56 100 108 140 144 180 188 196 204 214 222 246 270 288 300 320 340 372 376 392 400 404 410 418 430 442 454 466 478 496 504 524 554 562 600 608 616 620 646 686 694 702 710 724 752 756 768 834 858 894 {
merge 1:1 _time using output\colombia\placebo\polity\col`code'
rename _Y_treated _Y_treated`code'
rename _Y_synthetic _Y_synthetic`code'
drop _merge
}

drop if _time<1982

foreach code of numlist 170 50  203 242 388 426 480 508 591 716 748 56 100 108 140 144 180 188 196 204 214 222 246 270 288 300 320 340 372 376 392 400 404 410 418 430 442 454 466 478 496 504 524 554 562 600 608 616 620 646 686 694 702 710 724 752 756 768 834 858 894 {
gen gap`code'= _Y_treated`code'- _Y_synthetic`code'
}

save figures\placebo\placebo\placebocol_pol01, replace

*graph twoway (line gap* _time, sort) (line gap170 _time, sort  lwidth(thick) lcolor(black)), xline(1992, lpattern(dash)) yline(0, lpattern(dash)) legend(off)

*graph save figures\placebo\placebocol_pol01, replace

keep gap*

xpose, clear v

rename (v1	v2	v3	v4	v5	v6	v7	v8	v9	v10	v11	v12	v13	v14	v15	v16	v17	v18	v19	v20	v21	v22	v23	v24	v25	v26	v27	v28	v29	v30	v31	v32	v33	_varname) (t_10	t_9	t_8	t_7	t_6	t_5	t_4	t_3	t_2	t_1	t0	t1	t2	t3	t4	t5	t6	t7	t8	t9	t10	t11	t12	t13	t14	t15	t16	t17	t18	t19	t20	t21	t22	country)

gen gap2_10=t_10^2

gen gap2_9=t_9^2

gen gap2_8=t_8^2

gen gap2_7=t_7^2

gen gap2_6=t_6^2

gen gap2_5=t_5^2

gen gap2_4=t_4^2

gen gap2_3=t_3^2

gen gap2_2=t_2^2

gen gap2_1=t_1^2

egen mspe=rowmean(gap2_*) 

gen rmspe=sqrt(mspe)

order country mspe rmspe

keep country t* mspe rmspe

drop if rmspe>0.1

export excel figures\placebo\placebo, first(var) sheet(colombia) sheetrep

drop mspe rmspe t_10-t0

export excel figures\placebo\placebo, first(var) sheet(colombia2) sheetrep

*quietly log close



/******************************
** Congo (Rep.) 178 - 1984  **
******************************

use data/oildiscomplete, clear

tsset country_id year

quietly log using output\congo\placebo\polity\con_pol01.log, replace

***  Congo - polity_01 ***

****!!! no Switzerland no nepal!!!****


drop if treataspo==1 & country_id!=178

*drop if developing==0

foreach country of numlist 4 51 70 90 104 112 192 203 232 233 268 296 328 332 384 408 417 428 440 498 499 558 626 688 690 703 705 706 762 807 /// 
64 132 174 212 226 231 262 324 422 450 624 659 662 670 678 740 854 ///
84 116 352 368 462 470 508 516 800 {
drop if country_id==`country'
}

tempname resmat
        foreach placebo of numlist 178 50 72 242 388 426 480 591 716 748 56 100 108 140 144 180 188 196 204 214 222 246 270 288 300 320 340 372 376 392 400 404 410 418 430 442 454 466 478 496 504 554 562 600 608 616 620 646 686 694 702 710 724 752 768 834 858 894 {
		synth polity_01 lrgdpepc hc totalrents manufacturing agrva minva open_pwt HostLev conmeanpol(1983), trunit(`placebo') trperiod(1984) mspeperiod(1974(1)1983) xperiod(1974(1)1983) resultsperiod(1974(1)2014)  keep(output\congo\placebo\polity\con`placebo', replace) nested
		matrix `resmat' = nullmat(`resmat') \ e(RMSPE)
        local names `"`names' `"`placebo'"'"'
        }
        mat colnames `resmat' = "RMSPE"
        mat rownames `resmat' = `names'
        matlist `resmat' , row("Treated Unit")

		
clear

foreach placebo of numlist 178 50 72 242 388 426 480 591 716 748 56 100 108 140 144 180 188 196 204 214 222 246 270 288 300 320 340 372 376 392 400 404 410 418 430 442 454 466 478 496 504  554 562 600 608 616 620 646 686 694 702 710 724 752  768 834 858 894 {
use output\congo\placebo\polity\con`placebo'
drop _Co_Number _W_Weight
drop if _time==.
save output\congo\placebo\polity\con`placebo',replace
clear
}

*/
use data/placebo, clear


foreach code of numlist 178 50 72 242 388 426 480 591 716 748 56 100 108 140 144 180 188 196 204 214 222 246 270 288 300 320 340 372 376 392 400 404 410 418 430 442 454 466 478 496 504 554 562 600 608 616 620 646 686 694 702 710 724 752  768 834 858 894 {
merge 1:1 _time using output\congo\placebo\polity\con`code'
rename _Y_treated _Y_treated`code'
rename _Y_synthetic _Y_synthetic`code'
drop _merge
}


foreach code of numlist 178 50 72 242 388 426 480 591 716 748 56 100 108 140 144 180 188 196 204 214 222 246 270 288 300 320 340 372 376 392 400 404 410 418 430 442 454 466 478 496 504 554 562 600 608 616 620 646 686 694 702 710 724 752  768 834 858 894 {
gen gap`code'= _Y_treated`code'- _Y_synthetic`code'
}

drop if _time<1974

save figures\placebo\placebo\placebocon_pol01, replace

*graph twoway (line gap* _time, sort) (line gap178 _time, sort  lwidth(thick) lcolor(black)), xline(1984, lpattern(dash)) yline(0, lpattern(dash)) legend(off)

*graph save figures\placebo\placebocon_pol01, replace

keep gap*

xpose, clear v

rename (v1	v2	v3	v4	v5	v6	v7	v8	v9	v10	v11	v12	v13	v14	v15	v16	v17	v18	v19	v20	v21	v22	v23	v24	v25	v26	v27	v28	v29	v30	v31	v32	v33	v34	v35	v36	v37	v38	v39	v40	v41 _varname) (t_10	t_9	t_8	t_7	t_6	t_5	t_4	t_3	t_2	t_1	t0	t1	t2	t3	t4	t5	t6	t7	t8	t9	t10	t11	t12	t13	t14	t15	t16	t17	t18	t19	t20	t21	t22	t23	t24	t25	t26	t27	t28	t29	t30 country)

gen gap2_10=t_10^2

gen gap2_9=t_9^2

gen gap2_8=t_8^2

gen gap2_7=t_7^2

gen gap2_6=t_6^2

gen gap2_5=t_5^2

gen gap2_4=t_4^2

gen gap2_3=t_3^2

gen gap2_2=t_2^2

gen gap2_1=t_1^2

egen mspe=rowmean(gap2_*) 

gen rmspe=sqrt(mspe)

order country mspe rmspe

keep country t* mspe rmspe

drop if rmspe>0.1

export excel figures\placebo\placebo, first(var) sheet(congo) sheetrep

drop mspe rmspe t_10-t0

export excel figures\placebo\placebo, first(var) sheet(congo2) sheetrep

*quietly log close


/******************************
**    Gabon 266 - 1985      **
******************************

use data/oildiscomplete, clear

tsset country_id year

quietly log using output\gabon\placebo\polity\gab_pol01.log, replace

***  Gabon - polity_01 ***

****!!! no Mali, switzerland!!!****


drop if treataspo==1 & country_id!=266

*drop if developing==0

foreach country of numlist 4 51 70 90 104 112 192 203 232 233 268 296 328 332 384 408 417 428 440 498 499 558 626 688 690 703 705 706 762 807 /// 
64 132 174 212 226 231 262 324 422 450 624 659 662 670 678 740 854 ///
84 116 352 368 462 470 508 516 800 {
drop if country_id==`country'
}
tempname resmat
        foreach placebo of numlist 266 50 72 242 388 426 480 591 716 748 56 100 108 140 144 180 188 196 204 214 222 246 270 288 300 320 340 372 376 392 400 404 410 418 430 442 454 478 496 504 524 554 562 600 608 616 620 646 686 694 702 710 724 752 768 834 858 894 {
		synth polity_01 lrgdpepc hc totalrents manufacturing agrva minva open_pwt HostLev gabmeanpol(1984), trunit(`placebo') trperiod(1985) mspeperiod(1975(1)1984) xperiod(1975(1)1984) resultsperiod(1975(1)2014)  keep(output\gabon\placebo\polity\gab`placebo', replace)  nested allopt   
		matrix `resmat' = nullmat(`resmat') \ e(RMSPE)
        local names `"`names' `"`placebo'"'"'
        }
        mat colnames `resmat' = "RMSPE"
        mat rownames `resmat' = `names'
        matlist `resmat' , row("Treated Unit")

		
clear

foreach placebo of numlist 266 50 72 242 388 426 480 591 716 748 56 100 108 140 144 180 188 196 204 214 222 246 270 288 300 320 340 372 376 392 400 404 410 418 430 442 454 478 496 504 524 554 562 600 608 616 620 646 686 694 702 710 724 752 768 834 858 894 {
use output\gabon\placebo\polity\gab`placebo'
drop _Co_Number _W_Weight
drop if _time==.
save output\gabon\placebo\polity\gab`placebo',replace
clear
}

*/

use data/placebo, clear


foreach code of numlist 266 50 72 242 388 426 480 591 716 748 56 100 108 140 144 180 188 196 204 214 222 246 270 288 300 320 340 372 376 392 400 404 410 418 430 442 454  478 496 504 524 554 562 600 608 616 620 646 686 694 702 710 724 752 768 834 858 894 {
merge 1:1 _time using output\gabon\placebo\polity\gab`code'
rename _Y_treated _Y_treated`code'
rename _Y_synthetic _Y_synthetic`code'
drop _merge
}


foreach code of numlist 266 50 72 242 388 426 480 591 716 748 56 100 108 140 144 180 188 196 204 214 222 246 270 288 300 320 340 372 376 392 400 404 410 418 430 442 454 478 496 504 524 554 562 600 608 616 620 646 686 694 702 710 724 752 768 834 858 894 {
gen gap`code'= _Y_treated`code'- _Y_synthetic`code'
}
drop if _time<1975

save figures\placebo\placebo\placebogab_pol01, replace

*graph twoway (line gap* _time, sort) (line gap266 _time, sort  lwidth(thick) lcolor(black)), xline(1985, lpattern(dash)) yline(0, lpattern(dash)) legend(off)

*graph save figures\placebo\placebogab_pol01, replace

keep gap*

xpose, clear v

rename (v1	v2	v3	v4	v5	v6	v7	v8	v9	v10	v11	v12	v13	v14	v15	v16	v17	v18	v19	v20	v21	v22	v23	v24	v25	v26	v27	v28	v29	v30	v31	v32	v33	v34	v35	v36	v37	v38	v39	v40 _varname) (t_10	t_9	t_8	t_7	t_6	t_5	t_4	t_3	t_2	t_1	t0	t1	t2	t3	t4	t5	t6	t7	t8	t9	t10	t11	t12	t13	t14	t15	t16	t17	t18	t19	t20	t21	t22	t23	t24	t25	t26	t27	t28	t29 country)

gen gap2_10=t_10^2

gen gap2_9=t_9^2

gen gap2_8=t_8^2

gen gap2_7=t_7^2

gen gap2_6=t_6^2

gen gap2_5=t_5^2

gen gap2_4=t_4^2

gen gap2_3=t_3^2

gen gap2_2=t_2^2

gen gap2_1=t_1^2

egen mspe=rowmean(gap2_*) 

gen rmspe=sqrt(mspe)

order country mspe rmspe

keep country t* mspe rmspe

drop if rmspe>0.1

export excel figures\placebo\placebo, first(var) sheet(gabon) sheetrep

drop mspe rmspe t_10-t0

export excel figures\placebo\placebo, first(var) sheet(gabon2) sheetrep

*quietly log close


/*****************
** India 356 - 1974  **
***********************

use data/oildiscomplete, clear

tsset country_id year

quietly log using output\india\placebo\polity\ind_pol01.log, replace

***  India - polity_01 ***

****!!! no New Zealand !!!****


drop if treataspo==1 & country_id!=356

*drop if developing==0

foreach country of numlist 4 51	70 90 104 112 192 203 232 233 268 296 328 332 384 408 417 428 440 498 499 558 626 688 690 703 705 706 762 807 ///
64 132 174 212 226 231 262 324 422 450 624 659 662 670 678 740 854 ///
591 ///
50 72 84 116 242 270 352 368 426 462 470 480 508 516 702 716 748 800 {
drop if country_id==`country'
}
tempname resmat
        foreach placebo of numlist 356 56 100 108 140 144 180 188 196 204 214 222 246 288 300 320 340 372 376 388 392 400 404 410 418 430 442 454 466 478 496 504 524 562 600 608 616 620 646 686 694 710 724 752 756 768 834 858 894 {
		synth polity_01 lrgdpepc hc totalrents(1970(1)1973) manufacturing(1970(1)1973) agrva(1970(1)1973) minva(1970(1)1973) HostLev open_pwt indmeanpol(1973), trunit(`placebo') trperiod(1974) mspeperiod(1964(1)1973) xperiod(1964(1)1973) resultsperiod(1964(1)2014)  keep(output\india\placebo\polity\ind`placebo', replace)  nested allopt 
		matrix `resmat' = nullmat(`resmat') \ e(RMSPE)
        local names `"`names' `"`placebo'"'"'
        }
        mat colnames `resmat' = "RMSPE"
        mat rownames `resmat' = `names'
        matlist `resmat' , row("Treated Unit")

		
clear

foreach placebo of numlist 356 56 100 108 140 144 180 188 196 204 214 222 246 288 300 320 340 372 376 388 392 400 404 410 418 430 442 454 466 478 496 504 524  562 600 608 616 620 646 686 694 710 724 752 756 768 834 858 894 {
use output\india\placebo\polity\ind`placebo'
drop _Co_Number _W_Weight
drop if _time==.
save output\india\placebo\polity\ind`placebo',replace
clear
}

*/
use data/placebo, clear


foreach code of numlist 356 56 100 108 140 144 180 188 196 204 214 222 246 288 300 320 340 372 376 388 392 400 404 410 418 430 442 454 466 478 496 504 524 562 600 608 616 620 646 686 694 710 724 752 756 768 834 858 894 {
merge 1:1 _time using output\india\placebo\polity\ind`code'
rename _Y_treated _Y_treated`code'
rename _Y_synthetic _Y_synthetic`code'
drop _merge
}


foreach code of numlist 356 56 100 108 140 144 180 188 196 204 214 222 246 288 300 320 340 372 376 388 392 400 404 410 418 430 442 454 466 478 496 504 524 562 600 608 616 620 646 686 694 710 724 752 756 768 834 858 894 {
gen gap`code'= _Y_treated`code'- _Y_synthetic`code'
}

drop if _time<1964

save figures\placebo\placebo\placeboind_pol01, replace

*graph twoway (line gap* _time, sort) (line gap356 _time, sort  lwidth(thick) lcolor(black)), xline(1974, lpattern(dash)) yline(0, lpattern(dash)) legend(off)

*graph save figures\placebo\placeboind_pol01, replace

keep gap*

xpose, clear v

rename (v1	v2	v3	v4	v5	v6	v7	v8	v9	v10	v11	v12	v13	v14	v15	v16	v17	v18	v19	v20	v21	v22	v23	v24	v25	v26	v27	v28	v29	v30	v31	v32	v33	v34	v35	v36	v37	v38	v39	v40	v41	v42	v43	v44	v45	v46	v47	v48	v49	v50 v51 _varname) (t_10	t_9	t_8	t_7	t_6	t_5	t_4	t_3	t_2	t_1	t0	t1	t2	t3	t4	t5	t6	t7	t8	t9	t10	t11	t12	t13	t14	t15	t16	t17	t18	t19	t20	t21	t22	t23	t24	t25	t26	t27	t28	t29	t30	t31	t32	t33	t34	t35	t36	t37	t38	t39 t40 country)

gen gap2_10=t_10^2

gen gap2_9=t_9^2

gen gap2_8=t_8^2

gen gap2_7=t_7^2

gen gap2_6=t_6^2

gen gap2_5=t_5^2

gen gap2_4=t_4^2

gen gap2_3=t_3^2

gen gap2_2=t_2^2

gen gap2_1=t_1^2

egen mspe=rowmean(gap2_*) 

gen rmspe=sqrt(mspe)

order country mspe rmspe

keep country t* mspe rmspe

drop if rmspe>0.1

export excel figures\placebo\placebo, first(var) sheet(india) sheetrep

drop mspe rmspe t_10-t0

export excel figures\placebo\placebo, first(var) sheet(india2) sheetrep

*quietly log close


/****************************
** Kazakhstan 398 - 2000  **
****************************

use data/oildiscomplete, clear

tsset country_id year

quietly log using output\kazakhstan\placebo\polity\kaz_pol01.log, replace

***  Kazakhstan - polity_01 ***

****!!! no Liberia !!!****

drop if treataspo==1 & country_id!=398

*drop if developing==0

foreach country of numlist 4 90 104 192 232 296 328 332 384 408 558 626 690 706 ///
64 70 112 132 174 212 226 231 262 268 324 422 450 499 624 659 662 670 678 740 807 854 ///
84 352 368 462 470 688 703 {
drop if country_id==`country'
}

tempname resmat
        foreach placebo of numlist 398 50 51 72 116 203 233 242 388 417 426 428 440 480 498 508 516 591 705 716 748 762 800 56 100 108 140 144 180 188 196 204 214 222 246 270 288 300 320 340 372 376 392 400 404 410 418 430 442 454 466 478 496 504 524 554 562 600 608 616 620 646 686 694 702 710 724 752 756 768 834 858 894 {
        synth polity_01 lrgdpepc hc totalrents manufacturing agrva minva open_pwt HostLev kazmeanpol(1999), trunit(`placebo') trperiod(2000) mspeperiod(1991(1)1999) xperiod(1991(1)1999) resultsperiod(1991(1)2014)  keep(output\kazakhstan\placebo\polity\kaz`placebo', replace)  nested allopt  
		matrix `resmat' = nullmat(`resmat') \ e(RMSPE)
        local names `"`names' `"`placebo'"'"'
        }
        mat colnames `resmat' = "RMSPE"
        mat rownames `resmat' = `names'
        matlist `resmat' , row("Treated Unit")

		
clear

foreach placebo of numlist 398 50 51 72 116 203 233 242 388 417 426 428 440 480 498 508 516 591 705 716 748 762 800 56 100 108 140 144 180 188 196 204 214 222 246 270 288 300 320 340 372 376 392 400 404 410 418 430 442 454 466 478 496 504 524 554 562 600 608 616 620 646 686 694 702 710 724 752 756 768 834 858 894 {
use output\kazakhstan\placebo\polity\kaz`placebo'
drop _Co_Number _W_Weight
drop if _time==.
save output\kazakhstan\placebo\polity\kaz`placebo',replace
clear
}
*/

use data/placebo, clear


foreach code of numlist 398 50 51 72 116 203 233 242 388 417 426 428 440 480 498 508 516 591 705 716 748 762 800 56 100 108 140 144 180 188 196 204 214 222 246 270 288 300 320 340 372 376 392 400 404 410 418 430 442 454 466 478 496 504 524 554 562 600 608 616 620 646 686 694 702 710 724 752 756 768 834 858 894 {
merge 1:1 _time using output\kazakhstan\placebo\polity\kaz`code'
rename _Y_treated _Y_treated`code'
rename _Y_synthetic _Y_synthetic`code'
drop _merge
}



foreach code of numlist 398 50 51 72 116 203 233 242 388 417 426 428 440 480 498 508 516 591 705 716 748 762 800 56 100 108 140 144 180 188 196 204 214 222 246 270 288 300 320 340 372 376 392 400 404 410 418 430 442 454 466 478 496 504 524 554 562 600 608 616 620 646 686 694 702 710 724 752 756 768 834 858 894 {
gen gap`code'= _Y_treated`code'- _Y_synthetic`code'
}

drop if _time<1990

save figures\placebo\placebo\placebokaz_pol01, replace

*graph twoway (line gap* _time, sort) (line gap398 _time, sort  lwidth(thick) lcolor(black)), xline(2000, lpattern(dash)) yline(0, lpattern(dash)) legend(off)

*graph save figures\placebo\placebokaz_pol01, replace

keep gap*

xpose, clear v

rename (v1	v2	v3	v4	v5	v6	v7	v8	v9	v10	v11	v12	v13	v14	v15	v16	v17	v18	v19	v20	v21	v22	v23	v24	v25 _varname) (t_10	t_9	t_8	t_7	t_6	t_5	t_4	t_3	t_2	t_1	t0	t1	t2	t3	t4	t5	t6	t7	t8	t9	t10	t11	t12	t13	t14 country)

gen gap2_10=t_10^2

gen gap2_9=t_9^2

gen gap2_8=t_8^2

gen gap2_7=t_7^2

gen gap2_6=t_6^2

gen gap2_5=t_5^2

gen gap2_4=t_4^2

gen gap2_3=t_3^2

gen gap2_2=t_2^2

gen gap2_1=t_1^2

egen mspe=rowmean(gap2_*) 

gen rmspe=sqrt(mspe)

order country mspe rmspe

keep country t* mspe rmspe

drop if rmspe>0.1

export excel figures\placebo\placebo, first(var) sheet(kazakhstan) sheetrep

drop mspe rmspe t_10-t0

export excel figures\placebo\placebo, first(var) sheet(kazakhstan2) sheetrep

*quietly log close


/**************************
** Mexico 484 - 1977  **
**************************

use data/oildiscomplete, clear

tsset country_id year

quietly log using output\mexico\placebo\polity\mex_pol01.log, replace

***  Mexico - polity_01 ***


****!!! no Mali no switzerland!!!*****

drop if treataspo==1 & country_id!=484

*drop if developing==0

foreach country of numlist 4 51	70 90 104 112 192 203 232 233 268 296 328 332 384 408 417 428 440 498 499 558 626 688 690 703 705 706 762 807 ///
64 132 174 212 226 231 262 324 422 450 624 659 662 670 678 740 854 ///
591 ///
50 84 116 242 352 368 462 470 480 508 516 716 748 800 {
drop if country_id==`country'
}
tempname resmat
        foreach placebo of numlist 484 72 388 426 56 100 108 140 144 180 188 196 204 214 222 246 270 288 300 320 340 372 376 392 400 404 410 418 430 442 454 478 496 504 524 554 562 600 608 616 620 646 686 694 702 710 724 752 768 834 858 894 {
		synth polity_01 lrgdpepc hc totalrents(1970(1)1976) manufacturing(1970(1)1976) agrva(1970(1)1976) minva(1970(1)1976) HostLev open_pwt mexmeanpol(1976), trunit(`placebo') trperiod(1977) mspeperiod(1967(1)1976) xperiod(1967(1)1976) resultsperiod(1967(1)2014)  keep(output\mexico\placebo\polity\mex_`placebo', replace)  nested allopt  
		matrix `resmat' = nullmat(`resmat') \ e(RMSPE)
        local names `"`names' `"`placebo'"'"'
        }
        mat colnames `resmat' = "RMSPE"
        mat rownames `resmat' = `names'
        matlist `resmat' , row("Treated Unit")

		
clear

foreach placebo of numlist 484 72 388 426  56 100 108 140 144 180 188 196 204 214 222 246 270 288 300 320 340 372 376 392 400 404 410 418 430 442 454 478 496 504 524 554 562 600 608 616 620 646 686 694 702 710 724 752  768 834 858 894 {
use output\mexico\placebo\polity\mex_`placebo'
drop _Co_Number _W_Weight
drop if _time==.
save output\mexico\placebo\polity\mex_`placebo',replace
clear
}
*/

use data/placebo, clear


foreach code of numlist 484 72 388 426  56 100 108 140 144 180 188 196 204 214 222 246 270 288 300 320 340 372 376 392 400 404 410 418 430 442 454 478 496 504 524 554 562 600 608 616 620 646 686 694 702 710 724 752 768 834 858 894 {
merge 1:1 _time using output\mexico\placebo\polity\mex_`code'
rename _Y_treated _Y_treated`code'
rename _Y_synthetic _Y_synthetic`code'
drop _merge
}


foreach code of numlist 484 72 388 426 56 100 108 140 144 180 188 196 204 214 222 246 270 288 300 320 340 372 376 392 400 404 410 418 430 442 454 478 496 504 524 554 562 600 608 616 620 646 686 694 702 710 724 752 768 834 858 894 {
gen gap`code'= _Y_treated`code'- _Y_synthetic`code'
}

drop if _time<1967

save figures\placebo\placebo\placebomex_pol01, replace

*graph twoway (line gap* _time, sort) (line gap484 _time, sort  lwidth(thick) lcolor(black)), xline(1977, lpattern(dash)) yline(0, lpattern(dash)) legend(off)

*graph save figures\placebo\placebomex_pol01, replace

keep gap*

xpose, clear v

rename (v1	v2	v3	v4	v5	v6	v7	v8	v9	v10	v11	v12	v13	v14	v15	v16	v17	v18	v19	v20	v21	v22	v23	v24	v25	v26	v27	v28	v29	v30	v31	v32	v33	v34	v35	v36	v37	v38	v39	v40	v41	v42	v43	v44	v45	v46	v47	v48 _varname) (t_10	t_9	t_8	t_7	t_6	t_5	t_4	t_3	t_2	t_1	t0	t1	t2	t3	t4	t5	t6	t7	t8	t9	t10	t11	t12	t13	t14	t15	t16	t17	t18	t19	t20	t21	t22	t23	t24	t25	t26	t27	t28	t29	t30	t31	t32	t33	t34	t35	t36	t37 country)

gen gap2_10=t_10^2

gen gap2_9=t_9^2

gen gap2_8=t_8^2

gen gap2_7=t_7^2

gen gap2_6=t_6^2

gen gap2_5=t_5^2

gen gap2_4=t_4^2

gen gap2_3=t_3^2

gen gap2_2=t_2^2

gen gap2_1=t_1^2

egen mspe=rowmean(gap2_*) 

gen rmspe=sqrt(mspe)

order country mspe rmspe

keep country t* mspe rmspe

drop if rmspe>0.1

export excel figures\placebo\placebo, first(var) sheet(mexico) sheetrep

drop mspe rmspe t_10-t0

export excel figures\placebo\placebo, first(var) sheet(mexico2) sheetrep

*quietly log close



/******************************
**   Sudan 729 - 1980    **
******************************

use data/oildiscomplete, clear

tsset country_id year

quietly log using output\sudan\placebo\polity\sud_pol01.log, replace

*** Sudan - polity_01 ***

drop if treataspo==1 & country_id!=729

*drop if developing==0

****!!! no Mali no switzerland!!!*****

foreach country of numlist 4 51 70 90 104 112 192 203 232 233 268 296 328 332 384 408 417 428 440 498 499 558 626 688 690 703 705 706 762 807 /// 
64 132 174 212 226 231 262 324 422 450 624 659 662 670 678 740 854 ///
591 ///
50 84 116 352 368 462 470 508 516 800 {
drop if country_id==`country'
}

tempname resmat
        foreach placebo of numlist 729 72 242 388 426 480 716 748 56 100 108 140 144 180 188 196 204 214 222 246 270 288 300 320 340 372 376 392 400 404 410 418 430 442 454 478 496 504 524 554 562 600 608 616 620 646 686 694 702 710 724 752 768 834 858 894 {
		synth polity_01 lrgdpepc hc totalrents manufacturing agrva minva open_pwt HostLev sudmeanpol(1979), trunit(`placebo') trperiod(1980) mspeperiod(1970(1)1979) xperiod(1970(1)1979) resultsperiod(1970(1)2014)  keep(output\sudan\placebo\polity\sud`placebo', replace)  nested allopt  
		matrix `resmat' = nullmat(`resmat') \ e(RMSPE)
        local names `"`names' `"`placebo'"'"'
        }
        mat colnames `resmat' = "RMSPE"
        mat rownames `resmat' = `names'
        matlist `resmat' , row("Treated Unit")

		
clear

foreach placebo of numlist 729 72 242 388 426 480 716 748 56 100 108 140 144 180 188 196 204 214 222 246 270 288 300 320 340 372 376 392 400 404 410 418 430 442 454 478 496 504 524 554 562 600 608 616 620 646 686 694 702 710 724 752 768 834 858 894 {
use output\sudan\placebo\polity\sud`placebo'
drop _Co_Number _W_Weight
drop if _time==.
save output\sudan\placebo\polity\sud`placebo',replace
clear
}

*/
use data/placebo, clear


foreach code of numlist 729 72 242 388 426 480 716 748 56 100 108 140 144 180 188 196 204 214 222 246 270 288 300 320 340 372 376 392 400 404 410 418 430 442 454  478 496 504 524 554 562 600 608 616 620 646 686 694 702 710 724 752 768 834 858 894 {
merge 1:1 _time using output\sudan\placebo\polity\sud`code'
rename _Y_treated _Y_treated`code'
rename _Y_synthetic _Y_synthetic`code'
drop _merge
}


foreach code of numlist 729 72 242 388 426 480 716 748 56 100 108 140 144 180 188 196 204 214 222 246 270 288 300 320 340 372 376 392 400 404 410 418 430 442 454   478 496 504 524 554 562 600 608 616 620 646 686 694 702 710 724 752 768 834 858 894 {
gen gap`code'= _Y_treated`code'- _Y_synthetic`code'
}

drop if _time<1970

save figures\placebo\placebo\placebosud_pol01, replace

*graph twoway (line gap* _time, sort) (line gap729 _time, sort  lwidth(thick) lcolor(black)), xline(1980, lpattern(dash)) yline(0, lpattern(dash)) legend(off)

*graph save figures\placebo\placebosud_pol01, replace

keep gap*

xpose, clear v

rename (v1	v2	v3	v4	v5	v6	v7	v8	v9	v10	v11	v12	v13	v14	v15	v16	v17	v18	v19	v20	v21	v22	v23	v24	v25	v26	v27	v28	v29	v30	v31	v32	v33	v34	v35	v36	v37	v38	v39	v40	v41	v42	v43	v44	v45 _varname) (t_10	t_9	t_8	t_7	t_6	t_5	t_4	t_3	t_2	t_1	t0	t1	t2	t3	t4	t5	t6	t7	t8	t9	t10	t11	t12	t13	t14	t15	t16	t17	t18	t19	t20	t21	t22	t23	t24	t25	t26	t27	t28	t29	t30	t31	t32	t33	t34 country)

gen gap2_10=t_10^2

gen gap2_9=t_9^2

gen gap2_8=t_8^2

gen gap2_7=t_7^2

gen gap2_6=t_6^2

gen gap2_5=t_5^2

gen gap2_4=t_4^2

gen gap2_3=t_3^2

gen gap2_2=t_2^2

gen gap2_1=t_1^2

egen mspe=rowmean(gap2_*) 

gen rmspe=sqrt(mspe)

order country mspe rmspe

keep country t* mspe rmspe

drop if rmspe>0.1

export excel figures\placebo\placebo, first(var) sheet(sudan) sheetrep

drop mspe rmspe t_10-t0

export excel figures\placebo\placebo, first(var) sheet(sudan2) sheetrep

*quietly log close




/**************************
** Tunisia 788 - 1971  **
**************************

use data/oildiscomplete, clear

tsset country_id year

quietly log using output\tunisia\placebo\polity\tun_pol01.log, replace

***  Tunisia - polity_01 ***

***!!! no new zealand !!! ***

drop if treataspo==1 & country_id!=788

*drop if developing==0

foreach country of numlist 4 51	70 90 104 112 192 203 232 233 268 296 328 332 384 408 417 428 440 498 499 558 626 688 690 703 705 706 762 807 ///
64 132 174 212 226 231 262 324 422 450 624 659 662 670 678 740 854 ///
591 ///
50 72 84 108 116 226 242 270 352 368 404 417 428 426 454 462 470 480 508 516 702 716 748 800 894 {
drop if country_id==`country'
}

tempname resmat
        foreach placebo of numlist 788  56 100 140 144 180 188 196 204 214 222 246 288 300 320 340 372 376 388 392 400 410 418 430 442 466 478 496 504 524  562 600 608 616 620 646 686 694 710 724 752 756 768 834 858 {
		synth polity_01 lrgdpepc hc open_pwt HostLev tunmeanpol(1970), trunit(`placebo') trperiod(1971) mspeperiod(1961(1)1970) xperiod(1961(1)1970) resultsperiod(1961(1)2014)  keep(output\tunisia\placebo\polity\tun`placebo', replace)  nested allopt  
		matrix `resmat' = nullmat(`resmat') \ e(RMSPE)
        local names `"`names' `"`placebo'"'"'
        }
        mat colnames `resmat' = "RMSPE"
        mat rownames `resmat' = `names'
        matlist `resmat' , row("Treated Unit")

		
clear

foreach placebo of numlist 788  56 100 140 144 180 188 196 204 214 222 246 288 300 320 340 372 376 388 392 400 410 418 430 442 466 478 496 504 524 562 600 608 616 620 646 686 694 710 724 752 756 768 834 858 {
use output\tunisia\placebo\polity\tun`placebo'
drop _Co_Number _W_Weight
drop if _time==.
save output\tunisia\placebo\polity\tun`placebo',replace
clear
}

*/
use data/placebo, clear


foreach code of numlist 788  56 100 140 144 180 188 196 204 214 222 246 288 300 320 340 372 376 388 392 400 410 418 430 442 466 478 496 504 524 562 600 608 616 620 646 686 694 710 724 752 756 768 834 858 {
merge 1:1 _time using output\tunisia\placebo\polity\tun`code'
rename _Y_treated _Y_treated`code'
rename _Y_synthetic _Y_synthetic`code'
drop _merge
}


foreach code of numlist 788  56 100 140 144 180 188 196 204 214 222 246 288 300 320 340 372 376 388 392 400 410 418 430 442 466 478 496 504 524 562 600 608 616 620 646 686 694 710 724 752 756 768 834 858 {
gen gap`code'= _Y_treated`code'- _Y_synthetic`code'
}

drop if _time<1961

save figures\placebo\placebo\placebotun_pol01, replace

*graph twoway (line gap* _time, sort) (line gap788 _time, sort  lwidth(thick) lcolor(black)), xline(1971, lpattern(dash)) yline(0, lpattern(dash)) legend(off)

*graph save figures\placebo\placebotun_pol01, replace

keep gap*

xpose, clear v

rename (v1	v2	v3	v4	v5	v6	v7	v8	v9	v10	v11	v12	v13	v14	v15	v16	v17	v18	v19	v20	v21	v22	v23	v24	v25	v26	v27	v28	v29	v30	v31	v32	v33	v34	v35	v36	v37	v38	v39	v40	v41	v42	v43	v44	v45	v46	v47	v48	v49	v50 v51 v52 v53 v54 _varname) (t_10	t_9	t_8	t_7	t_6	t_5	t_4	t_3	t_2	t_1	t0	t1	t2	t3	t4	t5	t6	t7	t8	t9	t10	t11	t12	t13	t14	t15	t16	t17	t18	t19	t20	t21	t22	t23	t24	t25	t26	t27	t28	t29	t30	t31	t32	t33	t34	t35	t36	t37	t38	t39 t40 t41 t42 t43 country)

gen gap2_10=t_10^2

gen gap2_9=t_9^2

gen gap2_8=t_8^2

gen gap2_7=t_7^2

gen gap2_6=t_6^2

gen gap2_5=t_5^2

gen gap2_4=t_4^2

gen gap2_3=t_3^2

gen gap2_2=t_2^2

gen gap2_1=t_1^2

egen mspe=rowmean(gap2_*) 

gen rmspe=sqrt(mspe)

order country mspe rmspe

keep country t* mspe rmspe

drop if rmspe>0.1

export excel figures\placebo\placebo, first(var) sheet(tunisia) sheetrep

drop mspe rmspe t_10-t0

export excel figures\placebo\placebo, first(var) sheet(tunisia2) sheetrep

*quietly log close



/***********************
** Vietnam 704 - 1975**
***********************

use data/oildiscomplete, clear 

tsset country_id year

quietly log using output\vietnam\placebo\polity\vie_pol01.log, replace

***  Vietnam - polity_01 ***

***!!! no switzerland !!! ***

drop if treataspo==1 & country_id!=704

*drop if developing==0

foreach country of numlist 4 51	70 90 104 112 192 203 232 233 268 296 328 332 384 408 417 428 440 498 499 558 626 688 690 703 705 706 762 807 ///
64 132 174 212 226 231 262 324 422 450 624 659 662 670 678 740 854 ///
591 ///
50 72 84 116 242 352 368 426 462 470 480 508 516 716 748 800 {
drop if country_id==`country'
}

tempname resmat
        foreach placebo of numlist 704 388  56 100 108 140 144 180 188 196 204 214 222 246 270 288 300 320 340 372 376 392 400 404 410 418 430 442 454 466 478 496 504 524 554 562 600 608 616 620 646 686 694 702 710 724 752  768 834 858 894 {
		synth polity_01 lrgdpepc hc totalrents(1970(1)1974) minva(1970(1)1974) open_pwt viemeanpol(1974), trunit(`placebo') trperiod(1975) mspeperiod(1965(1)1974) xperiod(1965(1)1974) resultsperiod(1965(1)2014)  keep(output\vietnam\placebo\polity\vie`placebo', replace)  nested allopt  
		matrix `resmat' = nullmat(`resmat') \ e(RMSPE)
        local names `"`names' `"`placebo'"'"'
        }
        mat colnames `resmat' = "RMSPE"
        mat rownames `resmat' = `names'
        matlist `resmat' , row("Treated Unit")

		
clear

foreach placebo of numlist 704 388  56 100 108 140 144 180 188 196 204 214 222 246 270 288 300 320 340 372 376 392 400 404 410 418 430 442 454 466 478 496 504 524 554 562 600 608 616 620 646 686 694 702 710 724 752  768 834 858 894 {
use output\vietnam\placebo\polity\vie`placebo'
drop _Co_Number _W_Weight
drop if _time==.
save output\vietnam\placebo\polity\vie`placebo',replace
clear
}

*/
use data/placebo, clear


foreach code of numlist 704 388  56 100 108 140 144 180 188 196 204 214 222 246 270 288 300 320 340 372 376 392 400 404 410 418 430 442 454 466 478 496 504 524 554 562 600 608 616 620 646 686 694 702 710 724 752  768 834 858 894 {
merge 1:1 _time using output\vietnam\placebo\polity\vie`code'
rename _Y_treated _Y_treated`code'
rename _Y_synthetic _Y_synthetic`code'
drop _merge
}


foreach code of numlist 704 388 56 100 108 140 144 180 188 196 204 214 222 246 270 288 300 320 340 372 376 392 400 404 410 418 430 442 454 466 478 496 504 524 554 562 600 608 616 620 646 686 694 702 710 724 752  768 834 858 894 {
gen gap`code'= _Y_treated`code'- _Y_synthetic`code'
}

drop if _time<1965

save figures\placebo\placebo\placebovie_pol01, replace

*graph twoway (line gap* _time, sort) (line gap704 _time, sort  lwidth(thick) lcolor(black)), xline(1975, lpattern(dash)) yline(0, lpattern(dash)) legend(off)

*graph save figures\placebo\placebovie_pol01, replace

keep gap*

xpose, clear v

rename (v1	v2	v3	v4	v5	v6	v7	v8	v9	v10	v11	v12	v13	v14	v15	v16	v17	v18	v19	v20	v21	v22	v23	v24	v25	v26	v27	v28	v29	v30	v31	v32	v33	v34	v35	v36	v37	v38	v39	v40	v41	v42	v43	v44	v45	v46	v47	v48	v49	v50 _varname) (t_10	t_9	t_8	t_7	t_6	t_5	t_4	t_3	t_2	t_1	t0	t1	t2	t3	t4	t5	t6	t7	t8	t9	t10	t11	t12	t13	t14	t15	t16	t17	t18	t19	t20	t21	t22	t23	t24	t25	t26	t27	t28	t29	t30	t31	t32	t33	t34	t35	t36	t37	t38	t39 country)

gen gap2_10=t_10^2

gen gap2_9=t_9^2

gen gap2_8=t_8^2

gen gap2_7=t_7^2

gen gap2_6=t_6^2

gen gap2_5=t_5^2

gen gap2_4=t_4^2

gen gap2_3=t_3^2

gen gap2_2=t_2^2

gen gap2_1=t_1^2

egen mspe=rowmean(gap2_*) 

gen rmspe=sqrt(mspe)

order country mspe rmspe

keep country t* mspe rmspe

drop if rmspe>0.1

export excel figures\placebo\placebo, first(var) sheet(vietnam) sheetrep

drop mspe rmspe t_10-t0

export excel figures\placebo\placebo, first(var) sheet(vietnam2) sheetrep

*quietly log close

*********
* graph *
*********

clear

import excel figures\placebo\placebo, first

preserve

drop if brazil==.

graph twoway (scatter brazil time), yline(0.1, lpattern(solid) lwidth(thin))

graph save figures\placebo\pvbrazil, replace

restore

***

preserve

drop if cameroon==.

graph twoway (scatter cameroon time), yline(0.1, lpattern(solid) lwidth(thin)) 

graph save figures\placebo\pvcameroon, replace

restore

***

preserve

drop if chad==.

graph twoway (scatter chad time), yline(0.1, lpattern(solid) lwidth(thin)) 

graph save figures\placebo\pvchad, replace

restore

***

preserve

drop if colombia==.

graph twoway (scatter colombia time), yline(0.1, lpattern(solid) lwidth(thin)) 

graph save figures\placebo\pvcolombia, replace

restore

***

preserve

drop if congo==.

graph twoway (scatter congo time), yline(0.1, lpattern(solid) lwidth(thin)) 

graph save figures\placebo\pvcongo, replace

restore

***

preserve

drop if gabon==.

graph twoway (scatter gabon time), yline(0.1, lpattern(solid) lwidth(thin)) 

graph save figures\placebo\pvgabon, replace

restore

***

preserve

drop if india==.

graph twoway (scatter india time), yline(0.1, lpattern(solid) lwidth(thin)) 

graph save figures\placebo\pvindia, replace

restore

***

preserve

drop if kazakhstan==.

graph twoway (scatter kazakhstan time), yline(0.1, lpattern(solid) lwidth(thin)) 

graph save figures\placebo\pvkazakhstan, replace

restore

***

preserve

drop if mexico==.

graph twoway (scatter mexico time), yline(0.1, lpattern(solid) lwidth(thin)) 

graph save figures\placebo\pvmexico, replace

restore

***

preserve

drop if sudan==.

graph twoway (scatter sudan time), yline(0.1, lpattern(solid) lwidth(thin)) 

graph save figures\placebo\pvsudan, replace

restore

***

preserve

drop if tunisia==.

graph twoway (scatter tunisia time), yline(0.1, lpattern(solid) lwidth(thin)) 

graph save figures\placebo\pvtunisia, replace

restore

***

preserve

drop if vietnam==.

graph twoway (scatter vietnam time), yline(0.1, lpattern(solid) lwidth(thin)) 

graph save figures\placebo\pvvietnam, replace

restore

*****************/
* Graph combine *
*****************

graph combine figures\placebo\brazil.gph figures\placebo\pvbrazil.gph, title("Brazil", size(small) color(black))
graph save figures\placebo\combbrazil.gph, replace

graph combine figures\placebo\cameroon.gph figures\placebo\pvcameroon.gph, title("Cameroon", size(small) color(black))
graph save figures\placebo\combcameroon.gph, replace

graph combine figures\placebo\chad.gph figures\placebo\pvchad.gph, title("Chad", size(small) color(black))
graph save figures\placebo\combchad.gph, replace

graph combine figures\placebo\colombia.gph figures\placebo\pvcolombia.gph, title("Colombia", size(small) color(black))
graph save figures\placebo\combcolombia.gph, replace

graph combine figures\placebo\congo.gph figures\placebo\pvcongo.gph, title("Republic of Congo", size(small) color(black))
graph save figures\placebo\combcongo.gph, replace

graph combine figures\placebo\gabon.gph figures\placebo\pvgabon.gph, title("Gabon", size(small) color(black)) 
graph save figures\placebo\combgabon.gph, replace

graph combine figures\placebo\india.gph figures\placebo\pvindia.gph, title("India", size(small) color(black)) 
graph save figures\placebo\combindia.gph, replace

graph combine figures\placebo\kazakhstan.gph figures\placebo\pvkazakhstan.gph, title("Kazakhstan", size(small) color(black)) 
graph save figures\placebo\combkazakhstan.gph, replace

graph combine figures\placebo\mexico.gph figures\placebo\pvmexico.gph, title("Mexico", size(small) color(black)) 
graph save figures\placebo\combmexico.gph, replace

graph combine figures\placebo\sudan.gph figures\placebo\pvsudan.gph, title("Sudan", size(small) color(black)) 
graph save figures\placebo\combsudan.gph, replace

graph combine figures\placebo\tunisia.gph figures\placebo\pvtunisia.gph, title("Tunisia", size(small) color(black)) 
graph save figures\placebo\combtunisia.gph, replace

graph combine figures\placebo\vietnam.gph figures\placebo\pvvietnam.gph, title("Viet Nam", size(small) color(black)) 
graph save figures\placebo\combvietnam.gph, replace

/***** combine all ***

graph combine figures\placebo\combbrazil.gph figures\placebo\combcameroon.gph figures\placebo\combchad.gph, c(1)
figures\placebo\combcolombia.gph figures\placebo\combcongo.gph figures\placebo\combgabon.gph 
figures\placebo\combindia.gph figures\placebo\combkazakhstan.gph figures\placebo\combmexico.gph figures\placebo\combsudan.gph ///
figures\placebo\combtunisia.gph  figures\placebo\combvietnam.gph, c(2)


*****
clear
