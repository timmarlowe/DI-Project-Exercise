clear
clear matrix
set memory 2g

set scheme s1color, permanently

* Set directory *
cd "C:\Users\Tim\Documents\DI Project\"

* Read in file *
do NFWBS_PUF.do
save CFPB_survey.dta, replace

*Exploratory *
summarize FWBscore, detail
hist FWBscore
*Bottom quartile at score of 48 and below, top quartile at score of 65 and above

*Checking these two scaled scores for differences in means across multiple indicators
graph bar (mean) FWBscore FSscore, over(PPGENDER)
graph bar (mean) FWBscore FSscore, over(PPETHM)
graph bar (mean) FWBscore FSscore, over(agecat)
graph bar (mean) FWBscore FSscore, over(PPEDUC)
graph bar (mean) FWBscore FSscore, over(fpl)

*FWB appears to be more sensitive than FS to demographic differences

*Links to income
twoway (hist FWBscore if fpl == 1, percent fcolor(edkblue) lcolor(gray) bin(40)) ///
(hist FWBscore if fpl >1, percent fcolor(none) lcolor(black) bin(40)), ///
legend(order(1 "Under Federal Poverty Line" 2 "Above Federal Poverty Line")) ///
ytitle("% of Group", size(small)) xtitle("Scaled Score", size(small)) ///
title("Financial Well-Being Scaled Score by Federal Poverty Status", size(med))

*But which financial skills do link to higher Financial well-being?
reg FWBscore KHscore
reg FWBscore FSscore

egen FSscorecat = cut(FSscore), group(50) label

graph bar (mean) FWBscore, over(FSscorecat)

foreach v of varlist FS1_1 FS1_2 FS1_3 FS1_4 FS1_5 FS1_6 FS1_7 FS2_1 FS2_2 FS2_3 {
	svy: reg FWBscore `v' if `v' != -1
}

*Seems like fs1_1 and fs1_7 are the most highly linked to fwbscore
foreach v of varlist FS1_1 FS1_2 FS1_3 FS1_4 FS1_5 FS1_6 FS1_7 {
	twoway (hist FWBscore if `v' <=3 & `v' != -1, percent fcolor(edkblue) lcolor(gray)) ///
	(hist FWBscore if `v' >3 & `v' != -1, percent fcolor(none) lcolor(black)), ///
	legend(order(1 "<=3" 2 ">3")) title(`v')
	graph save `v', replace
}

twoway (hist FWBscore if FS1_1 <=3 & FS1_1 != -1, percent fcolor(edkblue) lcolor(gray)) ///
	(hist FWBscore if FS1_1 >3 & FS1_1 != -1, percent fcolor(none) lcolor(black)), ///
	legend(order(1 "Not at All to Somewhat" 2 "Very Well to Completely")) ///
	xtitle("Financial Well-Being Scale Score", size(small)) ytitle("% of Respondents", size(small)) ///
	title("I know how to get myself to follow through on my financial intentions", size(small))
graph save FS1_1, replace

twoway (hist FWBscore if FS1_7 <=3 & FS1_7 != -1, percent fcolor(edkblue) lcolor(gray)) ///
	(hist FWBscore if FS1_7 >3 & FS1_7 != -1, percent fcolor(none) lcolor(black)), ///
	legend(order(1 "Not at All to Somewhat" 2 "Very Well to Completely")) ///
	xtitle("Financial Well-Being Scale Score", size(small)) ytitle("% of Respondents", size(small)) ///
	title("I know how to make myself save", size(small))	
graph save FS1_7, replace

grc1leg FS1_1.gph FS1_7.gph, ///
ycommon title("Financial Well-Being Scale Score by Financial Skills Question Responses", size(medsmall))
graph export fscombined.png, replace

twoway (hist FWBscore if fpl == 1, percent fcolor(edkblue) lcolor(gray) bin(40)) ///
(hist FWBscore if fpl >1, percent fcolor(none) lcolor(black) bin(40)), ///
legend(order(1 "Under Federal Poverty Line" 2 "Above Federal Poverty Line")) ///
ytitle("% of Group", size(small)) xtitle("Scaled Score", size(small)) ///
title("Financial Well-Being Scaled Score by Federal Poverty Status", size(med))
