use repliECVdan.dta, replace


*TABLE 3*
la var stat "Electoral support, pm party"
la var gr_bnp "GDP growth"
la var unem "Unenemployment"
la var incumbency "Incumbency (years)"

file open anyname using tab3.tex, write text replace // husk at "de"-logge variable når de skal beskrives
file write anyname  _newline  _col(0)  "\begin{table} [htbp] \centering \caption{Descriptive statistics}\begin{tabular}{l*{6}{c}}\hline\hline"
file write anyname _newline _col(0) "&Mean & Std. dev. & Minimum & Median & Maximum & n\\ \hline"
foreach x of varlist stat unem gr_bnp incumbency   {
su `x' if year > 1978, d
file write anyname  _newline  _col(0) (`"`: var label `x''"') "&" _col(25) %9.2f  (r(mean)) " &" _col(45) %9.2f  (r(sd)) " &" _col(65) %9.2f  (r(min)) " &"   _col(85) %9.2f  (r(p50)) " &" _col(105) %9.2f  (r(max)) " &" _col(125) %9.0f  (r(N)) " \\"
}
file write anyname _newline _col(0) "\hline\hline"
file write anyname _newline _col(0) "\end{tabular}"
file write anyname _newline _col(0) "\end{table}"
file close anyname

*FIGURE 2*
twoway scatter stat year if year >1978, msym(O) mcolor(black) ||  line stat year if year >1978, ///
scheme(s1mono) legend(off) xtitle(" ") ytitle("Electoral support for the prime ministers party" " " ) ///
graphregion(style(none) color(gs16)) ylabel(10(10)40, angle(horizontal))  nodraw

twoway connect stat year if year >1978, lpattern(dash) scheme(s1mono) ylabel(10(10)50) lcol(black) xtitle(" ") ytitle("Support for prime minister party (pct.)" " ")


*TABLE 4*

tsset year

eststo t1a: reg stat l.stat l.gr_bnp l.unem
test l.gr_bnp l.unem
estadd scalar p=r(p)

eststo t1b: reg stat l.stat l.gr_bnp l.unem inc
test l.gr_bnp l.unem
estadd scalar p=r(p)


eststo t1c: reg stat l.gr_bnp l.unem l.stat i.id_stat inc
test l.gr_bnp l.unem
estadd scalar p=r(p)


eststo t1d: reg stat l.gr_bnp l.unem l.stat i.id_stat inc year
test l.gr_bnp l.unem
estadd scalar p=r(p)


esttab t1a t1b t1c t1d using tab4.tex, nomtitles replace keep(L.stat L.gr_bnp L.unem incumbency year) se stats(p r2 N, fmt(%9.2f %9.2f %9.0f)) star("*" 0.1 ) b(%9.2f) ///
varlabel(L.stat "Lagged executive party vote share" L.gr_bnp "GDP growth" L.unem "Unemployment" incumbency "Years in office" year "Election Year")

*TABLE S2*
tsset year

eststo a0: reg stat l.stat gr_bnp unem  i.id_stat
test gr_bnp unem
estadd scalar p=r(p)

replace inc=exp(inc)
eststo a1: reg stat gr_bnp unem l.stat i.id_stat inc 
test gr_bnp unem
estadd scalar p=r(p)

gen year2=log(year-1977)
eststo a2: reg stat gr_bnp unem l.stat i.id_stat inc year2
test gr_bnp unem
estadd scalar p=r(p)

replace inc=log(inc)
eststo a3: reg stat gr_bnp unem l.stat i.id_stat inc year
test gr_bnp unem
estadd scalar p=r(p)

esttab a0 a1 a2 a3 using tabS2.tex, replace keep(L.stat gr_bnp unem incumbency year) se stats(p r2 N, fmt(%9.2f %9.2f %9.0f)) star("*" 0.1 ) b(%9.2f) ///
varlabel(L.stat "Lagged executive party vote share" gr_bnp "GDP growth" unem "Unemployment" incumbency "Years in office" year "Election Year") ///
mtitles("lvl-lvl" "lvl-log" "log-log")


