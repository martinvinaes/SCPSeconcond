use repliECVscandi.dta, replace

*TABLE TWO*
file open anyname using tab1.txt, write text replace // husk at "de"-logge variable når de skal beskrives
file write anyname  _newline  _col(0)  "\begin{table} [htbp] \centering \caption{Descriptive statistics}\begin{tabular}{l*{6}{c}}\hline\hline"
file write anyname _newline _col(0) "&Mean & Std. dev. & Minimum & Median & Maximum & n\\ \hline"
foreach x of varlist incvotet incvotet2 gr_an unem_an time year  {
su `x' if year > 1978, d
file write anyname  _newline  _col(0) (`x') "&" _col(25) %9.2f  (r(mean)) " &" _col(45) %9.2f  (r(sd)) " &" _col(65) %9.2f  (r(min)) " &"   _col(85) %9.2f  (r(p50)) " &" _col(105) %9.2f  (r(max)) " &" _col(125) %9.0f  (r(N)) " \\"
}
file write anyname _newline _col(0) "\hline\hline"
file write anyname _newline _col(0) "\end{tabular}"
file write anyname _newline _col(0) "\end{table}"
file close anyname

*TABLE THREE*
eststo  a: reg incvotet incvotet2 c.gr_an c.unem_an, vce(cluster a1)
test gr_an unem
eststo  b: reg incvotet incvotet2 c.gr_an c.unem_an c.time, vce(cluster a1)
test gr_an unem
estadd scalar p=r(p)
eststo  c: reg incvotet incvotet2 c.gr_an c.unem_an c.time i.ccode, vce(cluster a1)
test gr_an unem
estadd scalar p=r(p)
eststo  d: reg incvotet incvotet2 c.gr_an c.unem_an c.time i.a1, vce(cluster a1)
test gr_an unem
estadd scalar p=r(p)
eststo  e: reg incvotet incvotet2 c.gr_an c.unem_an c.time c.year i.a1, vce(cluster a1)
test gr_an unem
estadd scalar p=r(p)

esttab a b c d e using tab2.tex, replace keep(incvotet2 gr_an unem_an time year) se stats(p r2 N, fmt(%9.2f %9.2f %9.0f)) star("*" 0.1 ) b(%9.2f) ///
varlabel(incvotet2 "Lagged executive party vote share" gr_an "GDP growth" unem_an "Unemployment" time "Years in office" year "Election Year")

*FIGURE 2*
rename ccode Country
twoway connect incvotet year, lpattern(dash) by(Country) scheme(s1mono) lcol(black) xtitle(" ") ytitle("Support for prime minister party (pct.)" " ")
rename Country ccode




*Table S1
eststo a02: reg incvotet incvotet2 c.gr_an c.unem_an  i.a1, vce(cluster a1)
test gr_an unem
estadd scalar p=r(p)
replace time=yio
eststo  a21: reg incvotet incvotet2 c.gr_an c.unem_an c.time c.year i.a1, vce(cluster a1)
test gr_an unem
estadd scalar p=r(p)
replace year=log(year-1970)
eststo  a22: reg incvotet incvotet2 c.gr_an c.unem_an c.time c.year i.a1, vce(cluster a1)
test gr_an unem
estadd scalar p=r(p)
replace time=log(yio)
eststo  a23: reg incvotet incvotet2 c.gr_an c.unem_an c.time c.year i.a1, vce(cluster a1)
test gr_an unem
estadd scalar p=r(p)

esttab a02 a21 a22 a23 using S1.tex, replace keep(incvotet2 gr_an unem_an time year) se stats(p r2 N, fmt(%9.2f %9.2f %9.0f)) star("*" 0.1 ) b(%9.2f) ///
varlabel(incvotet2 "Lagged executive party vote share" gr_an "GDP growth" unem_an "Unemployment" time "Years in office" year "Election Year") ///
mtitles("log-lvl" "lvl-lvl" "lvl-log" "log-log")

