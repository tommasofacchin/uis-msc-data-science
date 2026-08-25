# Oil reservoar production profile

# Plot a production profile
plotproductionprofile <- function(t0,ts,tp,beta,gam,tmax=0){
  if(tmax<t0+ts+tp)
    tmax <- t0+ts+tp+log(20)/gam
  declinephase <- seq(t0+ts+tp,tmax,length.out = 1000)
  tvec <- c(t0,t0+ts,t0+ts+tp,declinephase)
  xvec <- c(0,beta,beta,beta*exp(-gam*(declinephase-(t0+ts+tp))))
  plot(tvec,xvec,type="l",xlim=c(0,tmax),ylim=c(0,1.1*beta),lwd=1.5,
       xlab="time",ylab="production",main="Production profile")
}

plotproductionprofile(t0=0.75,ts=1.25,tp=5,beta=8,gam=0.25)
plotproductionprofile(t0=0.75,ts=1.25,tp=10,beta=8,gam=0.25)
plotproductionprofile(t0=0.75,ts=1.25,tp=5,beta=12,gam=0.25)
plotproductionprofile(t0=0.75,ts=1.25,tp=5,beta=8,gam=0.15)
plotproductionprofile(t0=0.75,ts=2,tp=5,beta=8,gam=0.25)
plotproductionprofile(t0=1.75,ts=3,tp=5,beta=8,gam=0.25)
lines(c(4.75,4.75),c(0,8),lty=3,lwd=0.5)
lines(c(9.75,9.75),c(0,8),lty=3,lwd=0.5)

#Calculate production volume up to time calctime
calculateproductionvolume <- function(t0,ts,tp,beta,gam,calctime){
  if(calctime<=t0)
    vol <- 0
  if(calctime>t0 & calctime<=t0+ts)
    vol <- 0.5*beta*(calctime-t0)^2/ts
  if(calctime>t0+ts & calctime<=t0+ts+tp)
    vol <- 0.5*beta*ts+beta*(calctime-(t0+ts))
  if(calctime>t0+ts+tp)
    vol <- 0.5*beta*ts+beta*tp+(beta/gam)*(1-exp(-gam*(calctime-(t0+ts+tp))))
  return(vol)
}

# Calculate time to thresholdproduction
calculatethresholdtime <- function(t0,ts,tp,beta,gam,threshold){
  if(threshold>beta)
    thresholdtime <- 0
  else
    thresholdtime <- t0+ts+tp-log(threshold/beta)/gam
  return(thresholdtime)
}



calculateproductionvolume(t0=0.75,ts=1,tp=5,beta=8,gam=0.25,calctime = 20)
calculateproductionvolume(t0=0,ts=1,tp=5,beta=8,gam=0.25,calctime = 7)

ttime <- calculatethresholdtime(t0=0.75,ts=1,tp=5,beta=8,gam=0.25,threshold = 1)
ttime
# Calculate volume up to thresholdproduction time
calculateproductionvolume(t0=0.75,ts=1,tp=5,beta=8,gam=0.25,calctime = ttime)



# Simulate many production profile and calculate some relevant statistics for each

nsim <- 10000
threshold <- 1
fiveyearvolume <- vector(length=nsim)
totvolume <- vector(length=nsim)
thresholdtime <- vector(length=nsim)
volumetothreshold <- vector(length=nsim)
for(i in 1:nsim){
  t0 <- rbeta(1,2,2)*0.25+0.75
  ts <- rbeta(1,2,2)*0.4+1.2
  tp <- rbeta(1,2,2)*2+5
  beta <- rbeta(1,2,2)+8
  gam <- rbeta(1,2,2)*0.15+0.25
  fiveyearvolume[i] <- calculateproductionvolume(t0,ts,tp,beta,gam,calctime = 5)
  totvolume[i] <- beta*(0.5*ts+tp+1/gam)
  thresholdtime[i] <- calculatethresholdtime(t0,ts,tp,beta,gam,threshold)
  volumetothreshold[i] <- calculateproductionvolume(t0,ts,tp,beta,gam,calctime = thresholdtime[i])
}


par(mfrow=c(2,2))
hist(fiveyearvolume,main="Five year production volume",xlab="Volume",probability = T)
hist(totvolume,main="Total production volume",xlab="Volume",probability = T)
hist(thresholdtime,main="Time to threshold production",xlab="time",probability = T)
hist(volumetothreshold,main="Volume to threshold production",xlab="Volume",probability = T)
par(mfrow=c(1,1))


# Some summary statistics
summary(fiveyearvolume)
summary(totvolume)
summary(thresholdtime)
summary(volumetothreshold)
round(quantile(fiveyearvolume,probs=c(0.05,0.1,0.25,0.5,0.75,0.9,0.95)),digits=2)
round(quantile(totvolume,probs=c(0.05,0.1,0.25,0.5,0.75,0.9,0.95)),digits=2)
round(quantile(thresholdtime,probs=c(0.05,0.1,0.25,0.5,0.75,0.9,0.95)),digits=2)
round(quantile(volumetothreshold,probs=c(0.05,0.1,0.25,0.5,0.75,0.9,0.95)),digits=2)

# Probability of total production volume above 80
sum(totvolume>80)/nsim

