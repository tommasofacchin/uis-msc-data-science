rm(list=ls())

# Rain example (discrete state space S={0,1}, 0=no rain, 1=rain)
P <- matrix(c(0.6,0.4,0.3,0.7),nrow=2,ncol=2,byrow=T)
P

# 2-step transition matrix
P2 <- P%*%P
P2

# 3-step transition matrix
P3 <- P2%*%P
P3

# 4-step transition matrix
P4 <- P3%*%P
P4

# n-step transition matrix
n <- 1000
Pn <- P
for(i in 1:n){
  Pn <- Pn%*%P
}
Pn



# Simulate rain examples
set.seed(1)
T <- 500
N <- 5000
rain <- matrix(0.0,nrow = N, ncol=T)
rain[,1] <- 0 # Initial state
for(n in 1:N){
  for(i in 2:T){
    rain[n,i] <- sample(c(0,1),size=1,prob=P[rain[n,i-1]+1,])
  }
}
rain[1:6,1:6]

plot(1:T,rain[1,],type="l",xlab = "", ylim = c(0,1)) # first trajectory

meanMat <- rowMeans(rain==0)
hist(rowMeans(rain==0),xlim=c(mean(meanMat)-3*sd(meanMat),mean(meanMat)+3*sd(meanMat)),breaks=21)

df <- data.frame(stationaryProp=Pn[1,], 
                 lastStateProb=c(mean(rain[,T]==0),mean(rain[,T]==1)),
                 meanOfMean=c(mean(rowMeans(rain==0)),mean(rowMeans(rain==1))),
                 row.names=c("no rain","rain"))
df



