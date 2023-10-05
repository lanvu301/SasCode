*Import data;
libname w1 "/home/u63353591/sasuser.v94/STAT3130";

proc import datafile="/home/u63353591/sasuser.v94/STAT3130/MLS2022.xlsx"
	dbms=xlsx out=w1.mls replace;
	sheet="STAT3130";
	getnames=YES;

data mlsAgeGroup;
set w1.mls;
if age<23 then ageGr='Young';
else if age <28 then ageGr='Prime';
else ageGr='Veteran';
*Visualization of the dataset;
PROC SGPLOT DATA=mlsAgeGroup;
   VBOX Gls / GROUP=ageGr;
   
PROC SGPLOT DATA=mlsAgeGroup;
histogram Gls;

PROC SGPLOT DATA=mlsAgeGroup;
vbar ageGr / datalabel;

proc sgplot data=mlsAgeGroup;
  /* Use the VBAR statement to create the bar chart */
  vbar  squad/
    datalabel;
    
    
  /* Optional: Customize the appearance of the chart */
  title 'Bar Chart of Category Variable'; /* Chart title */
  xaxis display=(nolabel); /* Hide the x-axis labels */
  yaxis grid; /* Add a grid to the y-axis */
*Hypothesis 1, one way anova;	
proc anova data=w1.mls;
	class Squad;
	model Gls=Squad;
	means Squad/lsd tukey;	
	proc sgplot data=w1.mls;
  histogram gls / group=squad;
  
  proc sgplot data=w1.mls;
	hbox gls/category=squad;
	

*Hypothesis 2, multiply reg;	
	proc reg data=mlsAgeGroup;
	model Gls=PrgC PrgP PrgR xG/cli clm r;
	id Gls;

proc corr data=mlsAgeGroup plot=scatter;
  var Gls PrgC PrgR PrgP xG;
  
 
*Hypothesis 3, non-parametric test;	
proc npar1way data=mlsAgeGroup wilcoxon;
	var PrgC ; 
	class ageGr;

proc npar1way data=mlsAgeGroup wilcoxon;
	var Gls ; 
	class ageGr;
