# clear all variables
rm(list=ls())


### Integrate cos(x) from 0 to  1.5
### Compare crude MC and antithetic

a <- 0
b <- 1.5
Nsim <- 10000

# Crude MC
x <- runif(Nsim,a,b)
intcMC <- (b-a)*mean(cos(x))
intcMC

# Antithetic
x1 <- runif(Nsim/2,a,b)
x2 <- a+b-x1
x <- c(x1,x2)
intaMC <- (b-a)*mean(cos(x))

# Check the correlation
cor(x1,x2)
cor(cos(x1),cos(x2))


nrep <- 1000
intcMCvec <- numeric(nrep)
intaMCvec <- numeric(nrep)
for(i in 1:nrep){
  x <- runif(Nsim,a,b)
  intcMCvec[i] <- (b-a)*mean(cos(x)) # crude MC result
  x1 <- runif(Nsim/2,a,b)
  x2 <- a+b-x1
  x <- c(x1,x2)
  intaMCvec[i] <- (b-a)*mean(cos(x)) # antitetic MC result
}
# Estimated standard deviations
sd(intcMCvec)
sd(intaMCvec)

# Checking the mean
mean(intcMCvec)
mean(intaMCvec)
# Exact
sin(b)-sin(a)



### Integrate cos(x) from a to  b
### Compare crude MC and antithetic

estcosint <- function(a,b,Nsim=10000,nrep=1000){
  intcMCvec <- numeric(nrep)
  intaMCvec <- numeric(nrep)
  for(i in 1:nrep){
    x <- runif(Nsim,a,b)
    intcMCvec[i] <- (b-a)*mean(cos(x)) # crude MC result
    x1 <- runif(Nsim/2,a,b)
    x2 <- a+b-x1
    x <- c(x1,x2)
    intaMCvec[i] <- (b-a)*mean(cos(x)) # antithetic MC result
  }
  type <- c("Crude MC","Antithetic MC","Exact")
  meanint <- round(c(mean(intcMCvec),mean(intaMCvec),sin(b)-sin(a)),6)
  sd <- round(c(sd(intcMCvec),sd(intaMCvec),0),6)
  print(rbind(type,meanint,sd))
}

# Antithetic is far more efficient as long as the function is monotonic:
estcosint(a=0,b=1)
estcosint(a=0,b=1.5)
estcosint(a=0,b=pi)

# Antithetic does not work when the function is not monotonic:
curve(cos(x),0,2*pi)
estcosint(a=0,b=5)
estcosint(a=0,b=2*pi)



# page 7
### Integrate sqrt(x)exp(-4x) from 0 to infinity
# Ordinary MC
Nsim <- 10000
x <- rexp(Nsim,rate=4)
mean(sqrt(x))/4
# Antitetic
U <- runif(Nsim/2)
x <- c(-1/4*log(U),-1/4*log(1-U))
mean(sqrt(x))/4

# Compare standard deviation of the two approaches

Nsim=10000
nrep=1000
intoMCvec <- numeric(nrep)
intaMCvec <- numeric(nrep)
for(i in 1:nrep){
  x <- rexp(Nsim,rate=4)
  intoMCvec[i] <- mean(sqrt(x))/4 # ordinary MC result
  U <- runif(Nsim/2)
  x <- c(-1/4*log(U),-1/4*log(1-U))
  intaMCvec[i] <- mean(sqrt(x))/4 # antithetic MC result
}
type <- c("Ordinary MC","Antithetic MC")
meanint <- round(c(mean(intoMCvec),mean(intaMCvec)),6)
sd <- round(c(sd(intoMCvec),sd(intaMCvec)),6)
rbind(type,meanint,sd)

#Check the correlation
U <- runif(Nsim/2)
cor(-1/4*log(U),-1/4*log(1-U))






# page 10
### Integrate cos(x) from -1.5 to  1.5 with importance sampling
# modfied integrand
igr <- function(x){return((x<=1.5 & x>=-1.5)*cos(x))}
x.grid <- seq(from=-2,to=2,length.out = 1000)
par(mfrow=c(1,2))
plot(x.grid,igr(x.grid),type="l")
plot(x.grid,igr(x.grid)/dnorm(x.grid),type="l")




# Importance MC
Nsim <- 10000
x <- rnorm(Nsim)
wts <- igr(x)/dnorm(x)
intiMC <- mean(wts)
intiMC
trueVal <- 2*sin(3/2)

par(mfrow=c(1,2))
plot(wts,type="l")
lines(c(0,Nsim),c(trueVal,trueVal),type="l",col="red")
plot(1:Nsim,cumsum(wts)/(1:Nsim),type="l")
# true value
lines(c(0,Nsim),c(trueVal,trueVal),type="l",col="red")


# page 12
### Integrate exp(-x)/(1+x^2) from 0 to 3 with importance sampling
gx <- function(x)
  exp(-x)/(1+x^2)


#Numerical integration reference
ref<-integrate(gx,0,3)



# Using standard exponential as importance distribution
Nsim <- 10000
x <- rexp(Nsim)
intiMC <- mean(gx(x)*(x<3)/dexp(x))
intiMC

# Using f(x)=exp(-x)/(1-exp(-3)) defined on [0,3] as importance function
fxtrexp <- function(x)
  exp(-x)/(1-exp(-3))

u <- runif(Nsim)
x <- -log(1-u*(1-exp(-3)))
intiMC2 <- mean(gx(x)/fxtrexp(x))
intiMC2

# Using f(x)=exp(-x)/(1-exp(-3)) and antitetic variables
u <- runif(Nsim/2)
x <- c(-log(1-u*(1-exp(-3))),-log(1-(1-u)*(1-exp(-3))))
intiMC3 <- mean(gx(x)/fxtrexp(x))
intiMC3


# Using U[0,3] as importance distribution (i.e. crude MC)
intcMC <- mean(3*gx(runif(Nsim,0,3)))
intcMC



### Plot of the function and the importance functions
par(mfrow=c(1,1))
curve(gx,0,3,lwd=2,xlim=c(0,4),ylim=c(0,1.05))
curve(dexp,0,4,col="red",add=T,lwd=2)
curve(fxtrexp,0,3,col="blue",add=T,lwd=2)
curve(dunif(x,0,3),0,3,col="green",add=T,lwd=2)
legend("topright",lty=1,col=c("black","red","blue","green"),
       legend=c("exp(-x)/(1+x^2)","standard exponential",
              "truncated exponential","uniform"),lwd=2)


### Comparing the approaches

Nsim=10000
nrep=1000
intcMCvec <- numeric(nrep)
intiMCvec <- numeric(nrep)
intiMC2vec <- numeric(nrep)
intiMC3vec <- numeric(nrep)
for(i in 1:nrep){
  intcMCvec[i] <- mean(3*gx(runif(Nsim,0,3)))
  x <- rexp(Nsim)
  intiMCvec[i] <- mean(gx(x)*(x<3)/dexp(x))
  u <- runif(Nsim)
  x <- -log(1-u*(1-exp(-3)))
  intiMC2vec[i] <- mean(gx(x)/fxtrexp(x))
  u <- runif(Nsim/2)
  x <- c(-log(1-u*(1-exp(-3))),-log(1-(1-u)*(1-exp(-3))))
  intiMC3vec[i] <- mean(gx(x)/fxtrexp(x))
}
type <- c("Ordinary MC","Importance 1","Importance 2","Importance 2 & antitetic")
meanint <- round(c(mean(intcMCvec),mean(intiMCvec),mean(intiMC2vec),mean(intiMC3vec)),6)
sd <- round(c(sd(intcMCvec),sd(intiMCvec),sd(intiMC2vec),sd(intiMC3vec)),6)
rbind(type,meanint,sd)
















### Integrate cos(x) from 0 to  1.5 with control variable
# Plot g(x) and the control variable h(x)
gx <- function(x)
  1.5*cos(x)
curve(gx,0,1.5,ylim=c(0,1.5))
hx <- function(x)
  1.5-x
curve(hx,0,1.5,col="red",add=T)
# Expectation and variance of h(X) when X is uniform[0,1.5]
Ehx <- 1.5-(2/6)*1.5^2
Ehx2 <- (1.5^3-3*1.5^2/2+1.5^3/3)*2/3
Varhx <- Ehx2-Ehx^2
# First simulation to find cov(cos(x),h(x)) and 
Nsim <- 10000
U <- runif(Nsim,0,1.5)
cov(gx(U),hx(U))
c <- - cov(gx(U),hx(U))/Varhx
c
cor(gx(U),hx(U))
cor(gx(U),hx(U))^2

U <- runif(Nsim,0,1.5)
intest <- mean(gx(U))+c*(mean(hx(U))-Ehx)
intest


### Compare control variable with crude MC and antithetic

Nsim=10000
nrep=1000
intcMCvec <- numeric(nrep)
intaMCvec <- numeric(nrep)
intcvMCvec <- numeric(nrep)
for(i in 1:nrep){
  x <- runif(Nsim,0,1.5)
  intcMCvec[i] <- 1.5*mean(cos(x)) # crude MC result
  x1 <- runif(Nsim/2,0,1.5)
  x2 <- 1.5-x1
  x <- c(x1,x2)
  intaMCvec[i] <- 1.5*mean(cos(x)) # antitetic MC result
  U <- runif(Nsim,0,1.5)
  intcvMCvec[i] <- mean(gx(U))+c*(mean(hx(U))-Ehx) # control variable
}
type <- c("Ordinary MC","Antithetic MC","Control variable","Exact")
meanint <- round(c(mean(intcMCvec),mean(intaMCvec),mean(intcvMCvec),sin(1.5)),6)
sd <- round(c(sd(intcMCvec),sd(intaMCvec),sd(intcvMCvec),0),6)
rbind(type,meanint,sd)



# Theoretical relative reduction in variance
cor(gx(U),hx(U))^2
# Estimated relative reduction in variance
(var(intcMCvec)-var(intcvMCvec))/var(intcMCvec)

### Compare importance variable with crude, antithetic and control

Nsim=10000
nrep=100
intiMCvec <- numeric(nrep)
for(i in 1:nrep){
  x <- rtriang(Nsim,a=0,b=1.5,c=0)
  intiMCvec[i] <- mean(cos(x)/dtriang(x,a=0,b=1.5,c=0)) # importance
}
type <- c("Ordinary MC","Antithetic MC","Control variable","Importance","Exact")
meanint <- round(c(mean(intcMCvec),mean(intaMCvec),mean(intcvMCvec),mean(intiMCvec),sin(1.5)),6)
sd <- round(c(sd(intcMCvec),sd(intaMCvec),sd(intcvMCvec),sd(intiMCvec),0),6)
rbind(type,meanint,sd)
