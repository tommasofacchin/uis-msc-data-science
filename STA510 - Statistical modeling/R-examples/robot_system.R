### Simulations for the robot assembly line example from the lectures

# Remove old variables:
rm(list=ls())


## Simulate times to failure for the system
gensystemfailuretimes <- function(Nsim){
  R1 <- rgamma(Nsim,shape = 16, scale = 1) # Nsim times to failure for robot 1
  R2 <- rgamma(Nsim,shape = 16, scale = 1) # Nsim times to failure  for robot 2
  R3 <- rgamma(Nsim,shape = 12, scale = 2) # Nsim times to failure  for robot 3
  A <- rlnorm(Nsim,meanlog = 2.3, sdlog = 1.1) # Nsim times to failure for other failures 
  failuretimes <- pmin(R1,R2,R3,A) # Nsim times to failure for the system
  return(failuretimes)
}
  

# First estimates of mean and sd 
ftimes <- gensystemfailuretimes(Nsim=1000)
mu1 <- mean(ftimes)
sd1 <- sd(ftimes)
mu1
sd1

#Mean with precision of one month:
e1 <- 1 # The time scale is months
n1 <- 4*sd1^2/e1^2
n1
ftimes <- gensystemfailuretimes(Nsim=n1)
mean(ftimes)
# For illustration, repeat the two last lines above several times


#Mean with precision of one day:
e2 <- 1/31 #The time scale is months
n2 <- 4*sd1^2/e2^2
n2
ftimes <- gensystemfailuretimes(Nsim=n2)
mean(ftimes)
# For illustration, repeat the two last lines above several times



# Probability of failure within one year with precision 0.01
e1 <- 0.05
n1 <- 1/e1^2
n1
ftimes <- gensystemfailuretimes(Nsim=n1)
pest <- sum(ftimes<12)/n1  # Remember that the time scale is months
pest
# For illustration, repeat the three last lines above several times


# Probability of failure within one year with precision 0.001
e2 <- 0.005
n2 <- 1/e2^2
n2
ftimes <- gensystemfailuretimes(Nsim=n2)
pest <- sum(ftimes<12)/n2  # Remember that the time scale is months
pest
# For illustration, repeat the three last lines above several times


# Illustration of various summary measures
Nsim <- 100000 
ftimes <- gensystemfailuretimes(Nsim=Nsim)
# Various summary measures
summary(ftimes)
# Standard deviation
sd(ftimes)
# Variance
var(ftimes)
#Quantiles
quantile(ftimes)
quantile(ftimes,probs = c(0,0.05,0.1,0.25,0.5,0.75,0.9,0.95,1))
# Histogram
hist(ftimes,nclass = 100, probability = T)
# Empirical cdf
plot(ecdf(ftimes))
# Density estimate
plot(density(ftimes))

# Various probabilities:
# - failure before 12 months
sum(ftimes<12)/Nsim
# - function more than 15 months
sum(ftimes>15)/Nsim
# - failure between 10 and 15 months
sum(ftimes>10 & ftimes <15)/Nsim

