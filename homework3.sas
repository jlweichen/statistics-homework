/*********************************************************************
Direct Adjust SAS

A Very Simple Ad-Hoc Program Written to Direct Adjust Coronary 
Heart Disease Incidence Rates Among persons 55-72 for Biostats-1

Assumes that Coronary Heart Disease Incidence is Stratified by Age as Follows

    55 - 59 years old = Category A
    60 - 64 years old = Categroy B
    65 - 69 years old = Categroy C
    70 - 74 years old = Categroy D

Note 
     A_N = Number of 55 - 59 Year olds in population
	 A_HD = Number of 55 - 59 year olds developing heart disease in 1 year 
 
     B_N = Number of 60 - 64 Year olds in population
	 B_HD = Number of 60 - 64 year olds developing heart disease in 1 year
 
     C_N = Number of 65 - 69 Year olds in population
	 C_HD = Number of 65 - 69 year olds developing heart disease in 1 year

     D_N = Number of 70 - 74 Year olds in population
	 D_HD = Number of 75 - 79 year olds developing heart disease in 1 year

The Rates for two Groups
       Men  With SBP < 165
       Men with SBP >= 165

are adjusted to the Age Distribtution
of all Elderly New Jersey Persons in this Age Range
 


*********************************************************************/

data one;
input input Group $ 1-12 A_N 14-17 A_HD 19-20 B_N 22-25 B_HD 27-28
            C_N 30-33 C_HD 35-36 D_N 38-40 D_HD 42-43;
cards;
Men SBP<165  1830 36 1660 35 1410 36 470 15
Men SBP>=165  260  9  350 14  350 16 100  5
Wmn SBP<165  1890 13 1680 15 1380 18 350  7
Wmn SPB>=165 420   7  610 16  690 25 180  3 

Data two;
Set one;

/*
p_a is the estimated portion of 55-59 year olds with heart disease
v_p_a is the variance of p_a based on a Poisson distribution
*/
p_a = a_hd / a_n;
v_p_a = p_a / a_n;

/*
p_b is the estimated portion of 60-64 year olds with heart disease
v_p_b is the variance of p_b
*/
p_b = b_hd / b_n;
v_p_b = p_b / b_n;

/*
p_c is the estimated portion of 65-69 year olds with heart disease
v_p_c is the variance of p_c
*/
p_c = c_hd / c_n;
v_p_c = p_c / c_n;

/*
p_d is the estimated portion of 70-74 year olds with heart disease
v_p_d is the variance of p_d
*/
p_d = d_hd / d_n;
v_p_d = p_d / d_n;

/*Note the Portion of New Jersey 55 - 74 year olds in each age range is:
           55 - 59 = 0.32
           60 - 64 = 0.32
           65 - 69 = 0.28
           70 - 74 = 0.08
                                                                    */
* adj_est gives the direct age adjusted estimate;
adj_est = .32 * p_a + .32 * p_b + .28 * p_c + .08 * p_d;

* v_ad_est gives the variance of the direct age adjusted estimate;
v_ad_est = .1024 * v_p_a + .1024 * v_p_b + .0784 * v_p_c
           + .0064 * v_p_d;

* lw_95_ci and up_95_ci are lower and upper confidnece limits fot
  gives the direct age adjusted incidence;
lw_95_ci = adj_est - 1.96 * (v_ad_est)**0.5;
up_95_ci = adj_est + 1.96 * (v_ad_est)**0.5;


proc print;

var group adj_est lw_95_ci up_95_ci v_ad_est;

Title 'adjusted annual heart disease incidence in men and women, 55 - 74';
Title2 'adjusted to New Jersey population for both sexes';

run;