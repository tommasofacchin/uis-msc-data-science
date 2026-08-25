

# return a random sample uniform distributed on unit sphere
runif.sphere <- function(n,d){
  M <- matrix(rnorm(n*d), nrow=n, ncol=d)
  L <- apply(M, MARGIN=1,
             FUN = function(x){sqrt(sum(x*x))})
  D <- diag(1 /L)
  U <- D%*%M
  U
}

# Generate sample in d=2
x <- runif.sphere(200,2)
par(pty = "s")
plot(x, xlab = bquote(x[1]), ylab = bquote(x[2]) )
par(pty = "m")

mu <- colMeans(x)
points(mu[1],mu[2], col="red")

## COMPUTE TWO MEANS
require("Riemann")
myriem = wrap.sphere(x)
mean.int = as.vector(riem.mean(myriem, geometry="intrinsic")$mean)
mean.ext = as.vector(riem.mean(myriem, geometry="extrinsic")$mean)
points(mean.int[1],mean.int[2], col="blue", pch=19)
points(mean.ext[1],mean.ext[2], col="green", pch=17)


# Generate sample in d=3
require("rgl")
x <- runif.sphere(200,3)
spheres3d(0,0,0,lit=FALSE,color="white")
spheres3d(0,0,0,radius=1.01,lit=FALSE,color="black",front="lines")
spheres3d(x[,1],x[,2],x[,3],col="red",radius=0.02)
myriem = wrap.sphere(x)
mean.int = as.vector(riem.mean(myriem, geometry="intrinsic")$mean)
mean.ext = as.vector(riem.mean(myriem, geometry="extrinsic")$mean)
spheres3d(mean.int[1],mean.int[2], mean.int[3], col="blue",radius=0.02)








# generate distribution around equator
n <- 200
x <- runif.sphere(n,2)
x <- cbind(x[,1], numeric(n),x[,2])

spheres3d(0,0,0,lit=FALSE,color="white")
spheres3d(0,0,0,radius=1.01,lit=FALSE,color="black",front="lines")
spheres3d(x[,1],x[,2],x[,3],col="red",radius=0.02)
myriem = wrap.sphere(x)
mean.int = as.vector(riem.mean(myriem, geometry="intrinsic")$mean)
mean.ext = as.vector(riem.mean(myriem, geometry="extrinsic")$mean)
spheres3d(mean.int[1],mean.int[2], mean.int[3], col="blue",radius=0.02)
spheres3d(mean.ext[1],mean.ext[2], mean.ext[3], col="green",radius=0.02)


open3d()
spheres3d(rnorm(10), rnorm(10), rnorm(10), 
          radius = runif(10), color = rainbow(10))