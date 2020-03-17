data crabby;
input sat color spine count;
if color = 1 then colorcond = 1;
if color = 2 then colorcond = 1;
if color = 3 then colorcond = 2;
if color = 4 then colorcond = 2;
if spine = 1 then spinecond = 1;
if spine = 2 then spinecond = 1;
if spine = 3 then spinecond = 2;
color = color-1;
* interaction term;
interact = color* spine;
cards;
0 1 1 7
0 1 2 3
0 1 3 5
0 2 1 19
0 2 2 13
0 2 3 29
0 3 1 3
0 3 2 7
0 3 3 35
0 4 1 5
0 4 2 5
0 4 3 29
1 1 1 17
1 1 2 7
1 1 3 3
1 2 1 35
1 2 2 9
1 2 3 103
1 3 1 9
1 3 2 7
1 3 3 45
1 4 1 3
1 4 2 3
1 4 3 17
;
* just color;
proc genmod descending; 
freq count;
model sat = color /dist = bin link = logit obstats type3 lrci covb;
run;
* just spine;
proc genmod descending; 
freq count;
model sat = spine /dist = bin link = logit obstats type3 lrci covb;
run;
* this model uses continuous spine and color;
* very vanilla;
proc genmod descending;
freq count;
model sat = color spine/dist = bin link = logit obstats type3 lrci covb;
run;
* this model has the condensed spine categories;
proc genmod descending;
freq count;
model sat = color spinecond /dist = bin link = logit type3 lrci covb;
run;
* this model has the condensed color categories;
proc genmod descending;
freq count;
model sat = colorcond spine /dist = bin link = logit type3 lrci covb;
run;
* this model used the interaction term;
proc genmod descending;
freq count;
model sat = color spine interact /dist = bin link = logit type3 lrci covb;
run;
* this model has the color as a qualitative var;
proc genmod descending;
freq count;
class color;
freq count;
model sat = color spine /dist = bin link = logit type3 lrci covb;
run;
* this model has the spine as a qualitative var;
proc genmod descending;
freq count;
class spine;
model sat = color spine /dist = bin link = logit type3 lrci covb;
run;
* this model has the color and spine as a qualitative vars;
proc genmod descending;
freq count;
class spine color;
model sat = color spine /dist = bin link = logit type3 lrci;
run;
* 2 x 2 x 2 table of color and spine;
proc freq;
weight count;
tables sat*colorcond / chisq nopercent norow nocol;
tables sat*spinecond / chisq nopercent norow nocol;
tables sat*spinecond*colorcond / cmh chisq nopercent norow nocol;
tables sat*spine*color /cmh chisq nopercent norow nocol;
run;
