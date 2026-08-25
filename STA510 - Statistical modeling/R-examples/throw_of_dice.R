### Illustration of sum/averages of many throws of a dice

# Remove old variables:
rm(list=ls())

## Function to simulate the sum of k throws of a dice
sumdice <- function(Nsim,k){
  dsum <- vector(length=Nsim) # Vector to store the sum of k dice throw in each repetition
  for(i in 1:Nsim)              # Generate the number of heads Nsim times
    dsum[i] <- sum(sample(1:6,size=k,replace=TRUE))  # Simulate the sum of k throws
  return(dsum)                # Return the resulting vector
}

sumdice(Nsim=20,k=2)
sumdice(Nsim=20,k=50)
# Average
sumdice(Nsim=20,k=50)/50


# Function to plot the histogram of the sum of k throws repeated Nsim times
plotdicesums <- function(Nsim=10000,k){
  dicesums <- sumdice(Nsim=Nsim,k=k)
  relfreq <- table(dicesums)/Nsim   # Calculate relative frequency for each outcome
  barplot(relfreq,ylab="Relative frequency", main = paste("Sum of k =",k,"throws"))
}

# Repeat for different values of k
par(mfrow=c(2,3)) # Make a 2x3 display of plots
plotdicesums(Nsim=100000,k=1)
plotdicesums(Nsim=100000,k=2)
plotdicesums(Nsim=100000,k=3)
plotdicesums(Nsim=100000,k=5)
plotdicesums(Nsim=100000,k=10)
plotdicesums(Nsim=100000,k=50)


# Function to plot the histogram of the average of k throws repeated Nsim times
plotdiceaverages <- function(Nsim=10000,k){
  diceaverages <- sumdice(Nsim=Nsim,k=k)/k   # This gives us averages
  hist(diceaverages, prob = TRUE,breaks=seq(0.5,6.5,length.out=6*k+1),
       xlab="Average",main=paste("Average of k =",k,"throws"))
}

# Repeat for different values of k
par(mfrow=c(2,3)) # Make a 2x3 display of plots
plotdiceaverages(Nsim=100000,k=1)
plotdiceaverages(Nsim=100000,k=2)
plotdiceaverages(Nsim=100000,k=3)
plotdiceaverages(Nsim=100000,k=5)
plotdiceaverages(Nsim=100000,k=10)
plotdiceaverages(Nsim=100000,k=5000)
par(mfrow=c(1,1))  # Set back to a 1x1 display



# Simulate the probability of a sum larger than 200 when k=50:
nsim <- 1000000
dsums <- sumdice(Nsim=nsim,k=50)
sum(dsums>200)/nsim
# Calculating the probability based on SGT (see lecture notes):
1-pnorm(200,mean=50*3.5,sd=sqrt(50*2.92))


