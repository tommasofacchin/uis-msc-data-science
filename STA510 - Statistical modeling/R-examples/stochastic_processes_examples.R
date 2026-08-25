### Examples of simulation of stochastic processes

# clear all variables
rm(list=ls())



####################################################################################
### Homogeneous Poisson process (HPP)

# slow implementation but clear
plotHPPslow <- function(lambda, stoptime){
  timesto <- 0.0
  t <- 0.0
  while(TRUE){ # run while the process has not finished
    timebetween <- rexp(1,lambda) # time between events
    t <- t + timebetween # process time at last event
    if(t < stoptime){
      timesto <- c(timesto, t) # resizing vectors is very slow
    }else{
      break # done
    }
  } # end while
  Nevents <- length(timesto)
  plot(timesto,1:Nevents,type="s",xlab = "arrival time", 
       ylab = "Event number",lwd=1.5,ylim=c(0,Nevents))
  points(timesto,rep(0,Nevents),pch=21,bg="red")
}
plotHPPslow(lambda=0.05,stoptime=365)


# implementation based on simulating times between the events
plotHPP <- function(lambda,stoptime){
  expectednumber <- stoptime*lambda  # Expected number of event until stoptime
  Nsim <- 3*expectednumber  # Simulate more than the expected number to be certain to exceed stoptime
  timesbetween <- rexp(Nsim,lambda) # Simulate interarrival times
  timesto <- cumsum(timesbetween)   # Calculate arrival times
  timesto <- timesto[timesto<stoptime] # Dischard the times larger than stoptime
  Nevents <- length(timesto) # Count the number of events
  plot(timesto,1:Nevents,type="s",xlab = "arrival time", 
       ylab = "Event number",lwd=1.5,ylim=c(0,Nevents))
  points(timesto,rep(0,Nevents),pch=21,bg="red")
}
plotHPP(lambda=0.05,stoptime=365)


# implementation based on the relation to the uniform distribution
plotHPPu <- function(lambda,stoptime){
  Nevents <- rpois(1,lambda*stoptime) # total number of events
  timesto <- sort(runif(Nevents,min=0,max=stoptime)) 
  plot(timesto,1:Nevents,type="s",xlab="arrival time",
       ylab="Event number",lwd=1.5,ylim=c(0,Nevents))
  points(timesto,rep(0,Nevents),pch=21,bg="red")

}
plotHPPu(lambda=0.05,stoptime=365)



####################################################################################
### Renewal process (RP)

# Use a gamma distribution for times between events 
# (often called gamma renewal process)
plotgammaRP <- function(alpha,beta,stoptime){
  expectedtimebetween <- alpha*beta # Expected interarrival time
  print(paste("Expected time between events: ",expectedtimebetween, " with variance:",expectedtimebetween*beta))
  expectednumber <- stoptime/expectedtimebetween # Expected number of event until stoptime
  Nsim <- 3*expectednumber # Simulate more than the expected number to be certain to exceed stoptime
  timesbetween <- rgamma(Nsim,shape = alpha, scale = beta) # Simulate interarrival times
  timesto <- cumsum(timesbetween)     # Calculate arrival times
  timesto <- timesto[timesto<stoptime]  # Dischard the times larger than stoptime
  Nevents <- length(timesto)  # Count the number of events
  plot(timesto,1:Nevents,type="s",xlab = "arrival time", 
       ylab = "Event number",lwd=1.5,ylim=c(0,Nevents),
       main=paste("expectation=",expectedtimebetween, ", variance=",expectedtimebetween*beta))
  points(timesto,rep(0,Nevents),pch=21,bg="red")
}
# alpha=shape, beta=scale, expected interarrival time 6
plotgammaRP(alpha=0.2,beta=30,stoptime=365)
plotgammaRP(alpha=2,beta=3,stoptime=365)
plotgammaRP(alpha=20,beta=0.3,stoptime=365)

# Generat data from four different RPs with the
# same expected interarrival time alpha*beta=2 
# but different variances alpha*beta^2
par(mfrow=c(2,2))
plotgammaRP(alpha=0.02,beta=100,stoptime=100)
plotgammaRP(alpha=0.2,beta=10,stoptime=100)
plotgammaRP(alpha=2,beta=1,stoptime=100) # HPP
plotgammaRP(alpha=20,beta=0.1,stoptime=100)
par(mfrow=c(1,1))
# Repeat the lines above several times


# Plot the gamma distribution
curve(dgamma(x,shape = 0.02, scale = 100),xlim=c(0,4),ylim=c(0,4),
      xlab="x",ylab="f(x)")
curve(dgamma(x,shape = 0.2, scale = 10),col="red",add=T)
curve(dgamma(x,shape = 2, scale = 1),col="green",add=T)
curve(dgamma(x,shape = 20, scale = 0.1),col="blue",add=T)
legend(2.5, 4, legend=c("E(X)=2, Var(X)=200", 
                        "E(X)=2, Var(X)=20",
                        "E(X)=2, Var(X)=2",
                        "E(X)=2, Var(X)=0.2"),
       col=c("black", "red", "green", "blue"), lty=c(1,1,1,1), cex=0.8)


# Take a look to the tails of the gamma distribution
curve(dgamma(x,shape = 0.02, scale = 100),xlim=c(4,10),ylim=c(0,0.1),
      xlab="x",ylab="f(x)")
curve(dgamma(x,shape = 0.2, scale = 10),col="red",add=T)
curve(dgamma(x,shape = 2, scale = 1),col="green",add=T)
curve(dgamma(x,shape = 20, scale = 0.1),col="blue",add=T)
legend(7, 0.1, legend=c("E(X)=2, Var(X)=200", 
                        "E(X)=2, Var(X)=20",
                        "E(X)=2, Var(X)=2",
                        "E(X)=2, Var(X)=0.2"),
       col=c("black", "red", "green", "blue"), lty=c(1,1,1,1), cex=0.8)


# Take a look to the tails of the gamma distribution
curve(dgamma(x,shape = 0.02, scale = 100),xlim=c(20,40),ylim=c(0,0.001),
      xlab="x",ylab="f(x)")
curve(dgamma(x,shape = 0.2, scale = 10),col="red",add=T)
curve(dgamma(x,shape = 2, scale = 1),col="green",add=T)
curve(dgamma(x,shape = 20, scale = 0.1),col="blue",add=T,lty=2)
legend(30, 0.001, legend=c("E(X)=2, Var(X)=200", 
                        "E(X)=2, Var(X)=20",
                        "E(X)=2, Var(X)=2",
                        "E(X)=2, Var(X)=0.2"),
       col=c("black", "red", "green", "blue"), lty=c(1,1,1,1), cex=0.8)


####################################################################################
### Non-homogeneous Poisson process (NHPP)


# NHPP describing arrivals of cars 


# Function for simulating arrival times for a NHPP between a and b using thinning
simtNHPP <- function(a,b,lambdamax,lambdafunc){
  # Simple check that a not too small lambdamax is set
  if(max(lambdafunc(seq(a,b,length.out = 100)))>lambdamax)
    stop("lambdamax is smaller than max of the lambdafunction")
  # First simulate HPP with intensity lambdamax on a to b
  expectednumber <- (b-a)*lambdamax  
  Nsim <- 3*expectednumber  # Simulate more than the expected number to be certain to exceed stoptime
  timesbetween <- rexp(Nsim,lambdamax) # Simulate interarrival times
  timesto <- a+cumsum(timesbetween)   # Calculate arrival times starting at a
  timesto <- timesto[timesto<b] # Dischard the times larger than b
  Nevents <- length(timesto) # Count the number of events
  # Next do the thinning. Only keep the times where u<lambda(s)/lambdamax
  U <- runif(Nevents)
  timesto <- timesto[U<lambdafunc(timesto)/lambdamax]  
  timesto  # Return the remaining times
}

# Specify the intensity function for the traffic example
lambdatraffic <- function(t)
  200+190*sin(2*t-1)
# Plot the intensity function
tvec <- seq(0,2,by=0.01)
plot(tvec,lambdatraffic(tvec),type="l",ylim=c(0,400))

# Generate data with the traffic intensity and plot them
NHPPtimes <- simtNHPP(a=0,b=2,lambdamax=390,lambdafunc=lambdatraffic)
plot(NHPPtimes,1:length(NHPPtimes),type="s",xlab = "time", 
     ylab = "Event number",lwd=1.5)
points(NHPPtimes,rep(0,length(NHPPtimes)),pch=21,bg="red")
# Rerun the lines above several times



# Specify a different intensity function
lambdacyclic <- function(t)
  200*cos(t*2)^2
# Plot the intensity function
tvec <- seq(0,2,by=0.01)
plot(tvec,lambdacyclic(tvec),type="l",ylim=c(0,200))

# Generate and plot them
NHPPtimes <- simtNHPP(a=0,b=2,lambdamax=200,lambdafunc=lambdacyclic)
plot(NHPPtimes,1:length(NHPPtimes),type="s",xlab = "arrival time", 
     ylab = "Event number",lwd=1.5)
points(NHPPtimes,rep(0,length(NHPPtimes)),pch=21,bg="red")
# Rerun the lines above several times



# The web-page example
lambdaexp <- function(t)
  800*exp(-0.1*t)
# Plot the intensity function
tvec <- seq(0,10,by=0.01)
plot(tvec,lambdaexp(tvec),type="l",ylim=c(0,800))

# One way to verify the calculations for the number of vistors during 10 hours
# is to simulate data from the NHPP on [0,10] many times and count the number
# of arrivals each time:
Nsim <- 200
NHPPnumbers <- vector(length=Nsim)
for(i in 1:Nsim)
  NHPPnumbers[i] <- length(simtNHPP(a=0,b=10,lambdamax=800,lambdafunc=lambdaexp))
# Average
mean(NHPPnumbers)
# Estimated probability
mean(NHPPnumbers>5000)

# Exact mean
a=800
b=0.1
a/b - (a*exp(-10*b))/b

# Exact probability
1-ppois(q=5000,lambda=5056.964)









############################################################
### Simulating a queue system with infinite number of serves
### !!! Additional material - not part of the curriculum

# For given arrival and service times this function
# calculate the number of customers in the queue at any time point
calculatequeue <- function(arrivaltimes, servicetimes){
  Narrivals <- length(arrivaltimes) # Total number of arrival
  departuretimes <- sort(arrivaltimes+servicetimes) # Calculate and sort the departure times
  eventtimes <- 0 # This will be the vector for event times
  numbersinqueue <- 0 # This will be the vector for numbers in queue, updated at each event time
  currentnumber <- 0  # Keeps track of the current number of customers
  acounter <- 1  # Counter for the arrivals vector
  dcounter <- 1  # Counter for the departures vector
  while(acounter<=Narrivals){
   if(arrivaltimes[acounter]<departuretimes[dcounter]){ # If the next event is an arrival
      currentnumber <- currentnumber+1
      numbersinqueue <- c(numbersinqueue,currentnumber)
      eventtimes <- c(eventtimes,arrivaltimes[acounter])
      acounter <- acounter+1
   }
    else{  # If the next event is an departure
      currentnumber <- currentnumber-1
      numbersinqueue <- c(numbersinqueue,currentnumber)
      eventtimes <- c(eventtimes,departuretimes[dcounter])
      dcounter <- dcounter+1
    }
  }
  return(list(numbers=numbersinqueue,times=eventtimes))
}



# Shorter code to calculate the queue made by Markus Fjellheim:
calculatequeue2 <-  function(arrivaltimes,servicetimes){
  indices <-  order(c(arrivaltimes,servicetimes+arrivaltimes))
  flow <-  (indices<=length(arrivaltimes))-(indices>length(arrivaltimes))
  eventtimes <- sort(c(arrivaltimes,servicetimes+arrivaltimes))
  return(list(numbers=cumsum(flow[eventtimes<tail(arrivaltimes,1)]),times=eventtimes[eventtimes<tail(arrivaltimes,1)]))
}



# The intensity function for the bank example
lambdabank <- function(t)
  25+50*sin(t*2*pi/24)^2*t+250*sin(t*pi/24)^2
# Plot the intensity function
tvec <- seq(0,24,by=0.1)
plot(tvec,lambdabank(tvec),type="l",ylim=c(0,1200))
abline(h=1100)

# Generate and plot the number of customers in the bank system
arrivaltimes <- simtNHPP(a=0,b=24,lambdamax=1100,lambdafunc=lambdabank)
servicetimes <- rgamma(length(arrivaltimes),shape=2,scale=0.1)
novertime <- calculatequeue(arrivaltimes,servicetimes)
plot(novertime$times,novertime$numbers,type="s",xlab = "time", 
     ylab = "Number of customers in the system",lwd=1.5)

# Repeat the simulation many times and calculate the max number of customers in 
# the system each time
Nsim <- 100 # This simulation takes some time
maxvalues <- numeric(Nsim)
for(i in 1:Nsim){
  arrivaltimes <- simtNHPP(a=0,b=24,lambdamax=1100,lambdafunc=lambdabank)
  servicetimes <- rgamma(length(arrivaltimes),shape=2,scale=0.1)
  novertime <- calculatequeue(arrivaltimes,servicetimes)
  maxvalues[i] <- max(novertime$numbers)  
}
summary(maxvalues)





# Another example with the cyclic intensity function for the arrival process
# and exponentially distributed service times
lambdacyclic <- function(t)
  200*cos(t*2)^2
# Plot the intensity function
tvec <- seq(0,2,by=0.01)
plot(tvec,lambdacyclic(tvec),type="l",ylim=c(0,200))

# Generate and plot the number of customers in the system
arrivaltimes <- simtNHPP(a=0,b=2,lambdamax=200,lambdafunc=lambdacyclic)
servicetimes <- rexp(length(arrivaltimes),rate=1)
novertime <- calculatequeue(arrivaltimes,servicetimes)
plot(novertime$times,novertime$numbers,type="s",xlab = "time", 
     ylab = "Number of customers in the system",lwd=1.5, xlim=c(0,2))




