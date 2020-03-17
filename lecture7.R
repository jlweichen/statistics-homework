load('~/Documents/biostats/OS.R')
library(leaps)
#standard
library(survival)
#better
library(flexsurv)
#please compare the 6 survival models by AIC and calculate the survival mean and
#the restricted survival means.
#based on Hodi data

# splitting the OS data by group
gp100 = OS[OS[,3]==3,1:2]
lpi = OS[OS[,3]==2, 1:2]
gplp = OS[OS[,3]==1, 1:2]

fshy <- flexsurvreg(Surv(Time, Dead)~1, data = gplp, dist = "weibull")
plot(fshy)

gplpVgp = OS[OS[,3]!=2,]
plot(survfit(Surv(Time, Dead)~Group, data = gplpVgp), col=2)
     
survdiff(Surv(Time, Dead)~Group, data = gplpVgp)
#p val is 2*10-4 low, may be underpowered
# this is a rank test

fshy <- survreg(Surv(Time, Dead)~1, data = gplp, dist = "weibull")
extractAIC(fshy)
#this used a Weibull distribution
# which uses two parameters

fshy <- survreg(Surv(Time, Dead)~1, data=gplp, dist = "lognormal")
extractAIC(fshy)
# this one is better than Weibull has lower value

# now using the flexsurv library
fshy <- flexsurvreg(Surv(Time, Dead)~1, data=gplp, dist = "gengamma")
extractAIC(fshy)

fshy <- flexsurvreg(Surv(Time, Dead)~1, data=gplp, dist = "genF")
extractAIC(fshy)
# generalized F fits best

fshy <- flexsurvreg(Surv(Time, Dead)~1, data=gplp, dist = "gompertz")
extractAIC(fshy)
