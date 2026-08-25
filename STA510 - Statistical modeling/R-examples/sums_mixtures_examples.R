# Remove old variables:
rm(list=ls())

########################################################################
### Examples of efficient coding for sums

# We have earlier used this code for simulating the sum of k throws of a dice:
simheads1 <- function(Nsim,k){
  nheads <- vector(length=Nsim) # Define a vector to store the number of heads in each repetition
  for(i in 1:Nsim)              # Generate the number of heads Nsim times
    nheads[i] <- sum(sample(0:1,size=k,replace=TRUE))  # Sum of heads in k throws
  return(nheads)                # Return the resulting vector
}

# A more efficient code which avoid the for-loop is given below
# We first generate a matrix with Nsim rows and k columns
# Each cell in the matrix is the outcome of one coin throw
# Use the apply function to sum the number of heads in each row
simheads2 <- function(Nsim,k){
  coinmatrix <- matrix(sample(0:1,size=Nsim*k,replace=TRUE),ncol=k) 
  nheads <- apply(coinmatrix,MARGIN = 1,FUN = sum) # The function sum is applied to each row 
  return(nheads)                # Return the resulting vector
}

# Compare execution time for the two functions
system.time(simheads1(Nsim=1000000,k=6))
system.time(simheads2(Nsim=1000000,k=6))

# Verify that both functions generate data from the correct pmf
k <- 3
Nsim <- 200000
nheadsim1 <- simheads1(Nsim=Nsim,k=k)
relfreq1 <- table(nheadsim1)/Nsim   # Calculate relative frequency for each outcome
nheadsim2 <- simheads2(Nsim=Nsim,k=k)
relfreq2 <- table(nheadsim2)/Nsim   # Calculate relative frequency for each outcome
par(mfrow=c(1,2))
barplot(relfreq1,ylab="Relative frequency",main="Using simheads1")
barplot(relfreq2,ylab="Relative frequency",main="Using simheads2")
par(mfrow=c(1,1))




########################################################################
### Example of generating a linear combination
genlinkomb <- function(Nsim){
  Y <- 10*rnorm(Nsim,mean=20,sd=10)+25*rgamma(Nsim,shape=3,scale=2)+100*rbeta(Nsim,shape1 = 2, shape2 = 2)
  Y   # Return the resulting vector
}

Nsim <- 100000
Ys <- genlinkomb(Nsim)
mean(Ys)
var(Ys)
# Probabilities
mean(Ys>200)
sum(Ys<300)/Nsim
sum(Ys<300 & Ys>200)/Nsim




########################################################################
### Simulating a mixture of normal distributions

# Simulating heights from a mixture of two height populations
# p1 is the probability of being from population 1
gennormheightmix <- function(Nsim,p1=0.5){
  u <- runif(Nsim)
  wdist <-  as.integer(u<p1) # 1 if from population 1, 0 otherwise
  X1 <- rnorm(Nsim,mean = 168,sd = 6.0)
  X2 <- rnorm(Nsim,mean = 180,sd = 6.5)
  Y <- wdist*X1+(1-wdist)*X2 
  Y
}

# Simulating the height distribution with equal amount of women and men:
Nsim <- 100000
Yh <- gennormheightmix(Nsim,p1=0.5)
hist(Yh,prob = TRUE,nclass=max(10,sqrt(Nsim)),ylim=c(0,0.07),main="Histogram of height")
lines(density(Yh))
curve(dnorm(x, mean=168, sd=6.0),from=150,to=200,add=TRUE, col='red',lty=2)
curve(dnorm(x, mean=180, sd=6.5),from=150,to=200,add=TRUE, col='blue',lty=2)
mean(Yh)
sd(Yh)

# Simulating the height distribution with 25% women:
Yh <- gennormheightmix(Nsim,p1=0.25)
hist(Yh,prob = TRUE,nclass=max(10,sqrt(Nsim)),ylim=c(0,0.07),main="Histogram of height")
lines(density(Yh))
curve(dnorm(x, mean=168, sd=6.0),from=150,to=200,add=TRUE, col='red',lty=2)
curve(dnorm(x, mean=180, sd=6.5),from=150,to=200,add=TRUE, col='blue',lty=2)
mean(Yh)
sd(Yh)



######################################################
# Simulating a general mixture of normal populations
# Notice the first two if statements which check if we give valid input parameters
gennormmix <- function(Nsim,pvec,muvec,sdvec){
  if(min(c(length(pvec),length(muvec),length(sdvec))) != 
     max(c(length(pvec),length(muvec),length(sdvec))))
    stop("Length of pvec,muvec and sdvec must be equal")
  if(sum(pvec)!=1)
    stop("pvec must sum to 1")
  m <- length(pvec) # Number of distributions
  # Determine which distribution to sample from in each simulation
  whichdist <- sample(1:m,size=Nsim,replace = TRUE,prob = pvec)
  # Simulate the mixture
  Y <- rnorm(Nsim,mean = muvec[whichdist],sd = sdvec[whichdist])
  Y
}

# Verify that we get the same as above for the height mixture:
Nsim <- 100000
pvec <- c(0.5,0.5)
muvec <- c(168,180)
sdvec <- c(6.0,6.5)
Yh <- gennormmix(Nsim,pvec=pvec,muvec=muvec,sdvec=sdvec)
hist(Yh,prob = TRUE,nclass=max(10,sqrt(Nsim)),ylim=c(0,0.07),main="Histogram of height")
lines(density(Yh))
curve(dnorm(x, mean=168, sd=6.0),from=150,to=200,add=TRUE, col='red',lty=2)
curve(dnorm(x, mean=180, sd=6.5),from=150,to=200,add=TRUE, col='blue',lty=2)
mean(Yh)
sd(Yh)



# Try a completely different mixture:
Nsim <- 100000
pvec <- c(0.25,0.25,0.5)
muvec <- c(10,20,40)
sdvec <- c(30.0,3.5,4.0)
Ym <- gennormmix(Nsim,pvec=pvec,muvec=muvec,sdvec=sdvec)
hist(Ym,prob = TRUE,nclass=max(10,sqrt(Nsim)),ylim=c(0,0.15),main="")
lines(density(Ym))
for(i in 1:length(pvec))
  curve(dnorm(x, mean=muvec[i], sd=sdvec[i]),
        from=muvec[i]-3*sdvec[i],to=muvec[i]+3*sdvec[i],add=TRUE, col=i,lty=2)
mean(Ym)
sd(Ym)
# Repeat the code above for different values of pvec, muvec and sdvec

