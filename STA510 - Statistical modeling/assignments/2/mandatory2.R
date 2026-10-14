# ---
# title: "STA510 - Mandatory Assignment 2"
# author: "Tommaso Facchin"
# ---

rm(list=ls())
set.seed(42)

# Problem 1

## a)
f <- function(t) {
  exp(-t / 2) / (1 + t^2)
}

n <- 10000

U <- runif(n, min = 0, max = 2)
I_CMC <- 2 * mean(f(U))

cat("\n\n1.a) Crude Monte Carlo:", I_CMC)



curve(
  f(x),
  from = 0,
  to = 2,
  n = 500,
  xlab = "t",
  ylab = "f(t)",
  main = "f(t) = exp(-t/2) / (1 + t^2)",
  col = "blue",
  lwd = 2
)

grid()

## c)

m <- 5000
U <- runif(m, min = 0, max = 2)
U_AT <- 2 - U

I_AT <- 2 * mean((f(U) + f(U_AT)) / 2)

cat("\n\n1.c) Antithetic Monte Carlo:", I_AT)


## d)

g <- function(t) {
  exp(-t / 2) / (2 * (1 - exp(-1)))
}

t <- seq(0, 2, length.out = 500)

plot(
  t, f(t),
  type = "l",
  col = "blue",
  lwd = 2,
  ylim = range(f(t), g(t)),
  xlab = "t",
  ylab = "Function value",
  main = "Comparison of f(t) and g(t)"
)

lines(t, g(t), col = "red", lwd = 2)

legend(
  "topright",
  legend = c("f(t)", "g(t)"),
  col = c("blue", "red"),
  lwd = 2
)

grid()


## f)

U_IS <- runif(n, min = 0, max = 1)

T_IS <- -2 * log(1 - U_IS * (1 - exp(-1)))

I_IS <- mean(f(T_IS) / g(T_IS))

cat("\n\n1.f) Importance sampling:", I_IS)



## g)

B <- 1000

est_CMC <- numeric(B)
est_AT  <- numeric(B)
est_IS  <- numeric(B)

for (b in seq_len(B)) {
  
  # CMC
  U_CMC <- runif(n, min = 0, max = 2)
  est_CMC[b] <- 2 * mean(f(U_CMC))
  
  # Antithetic
  U_AT <- runif(n / 2, min = 0, max = 2)
  est_AT[b] <- mean(f(U_AT) + f(2 - U_AT))
  
  # Importance sampling
  U_IS <- runif(n)
  T_IS <- -2 * log(1 - U_IS * (1 - exp(-1)))
  est_IS[b] <- mean(f(T_IS) / g(T_IS))
}

results <- data.frame(
  Method = c("CMC", "Antithetic", "Importance sampling"),
  Mean = c(mean(est_CMC), mean(est_AT), mean(est_IS)),
  SD = c(sd(est_CMC), sd(est_AT), sd(est_IS))
)

results$Variance_reduction_percent <-
  100 * (1 - results$SD^2 / results$SD[1]^2)

cat("\n\n1.g)")
print(results, digits = 6, row.names = FALSE)



# Problem 2
## b)

failure_times <- 0

while (tail(failure_times, 1) <= 60) {
  next_failure <- tail(failure_times, 1) + rweibull(1, shape = 2, scale = 6)
  failure_times <- c(failure_times, next_failure)
}

failure_times <- failure_times[failure_times <= 60]
n_failures <- length(failure_times) - 1

plot(
  c(failure_times, 60),
  c(0:n_failures, n_failures),
  type = "s",
  xlab = "Time (months)",
  ylab = "N(t)",
  main = "Renewal process"
)

cat("\n\n2.b) Number of failures:", n_failures)

## c)

B <- 5000

N60 <- replicate(B, {
  time <- 0
  failures <- 0
  
  repeat {
    time <- time + rweibull(1, shape = 2, scale = 6)
    
    if (time > 60) break
    
    failures <- failures + 1
  }
  
  failures
})

cat("\n\n2.c) Expected number of failures:", mean(N60))
cat("\nP(N(60) >= 15):", mean(N60 >= 15))



## e)

intensity <- function(t) {
  3 + 2 * cos(pi * t / 6)
}

curve(
  intensity(x),
  from = 0,
  to = 36,
  xlab = "Time (months)",
  ylab = "lambda(t)",
  main = "Seasonal failure rate",
  col = "blue",
  lwd = 2
)

time <- 0
failure_times <- numeric(0)

repeat {
  time <- time + rexp(1, rate = 5)
  
  if (time > 36) break
  
  if (runif(1) <= intensity(time) / 5) {
    failure_times <- c(failure_times, time)
  }
}

n_failures <- length(failure_times)

plot(
  c(0, failure_times, 36),
  c(0, seq_len(n_failures), n_failures),
  type = "s",
  xlab = "Time (months)",
  ylab = "N(t)",
  main = "NHPP over 36 months",
  col = "blue",
  lwd = 2
)

cat("\n\n2.e) Number of failures:", n_failures)
cat("\nThe failure rate is highest in january and lowest in june")


## f)
N36 <- numeric(B)
N3 <- numeric(B)

for (b in seq_len(B)) {
  time <- 0
  
  repeat {
    time <- time + rexp(1, rate = 5)
    
    if (time > 36) break
    
    if (runif(1) <= intensity(time) / 5) {
      N36[b] <- N36[b] + 1
      
      if (time <= 3) {
        N3[b] <- N3[b] + 1
      }
    }
  }
}

cat("\n\n2.f) Estimated E[N(36)]:", mean(N36), " (close to 108)")
cat("\nEstimated P(N(36) > 120):", mean(N36 > 120))
cat("\nEstimated E[N(3)]:", mean(N3))





# Problem 3

## a)

rain <- c(3.1, 7.2, 5.4, 12.0, 8.8, 4.3, 9.6, 6.1, 11.2, 2.9,
          7.5, 14.1, 5.0, 9.3, 6.8, 10.4, 3.7, 8.1, 13.5, 4.6,
          6.3, 11.8, 7.9, 5.5, 9.0, 12.7, 4.1, 8.4, 6.6, 10.1,
          3.4, 7.0, 5.8, 13.2, 9.7, 6.2, 11.5, 4.8, 8.9, 7.3)

n <- length(rain)
B <- 2000

boot_means <- replicate(B, {
  boot_sample <- sample(rain, size = n, replace = TRUE)
  mean(boot_sample)
})

boot_sd <- sd(boot_means)
boot_ci <- quantile(boot_means, probs = c(0.025, 0.975))

x_bar <- mean(rain)
se <- x_bar / sqrt(n)
clt_ci <- x_bar + c(-1, 1) * qnorm(0.975) * se


cat("\n\n3.a) Sample mean:", x_bar)
cat("\nBootstrap standard deviation:", boot_sd)
cat("\nBootstrap 95% CI:", boot_ci)
cat("\nCLT CI:", clt_ci)
cat("\nThe bootstrap CI is narrower than the CI interval from the first assignment.")


## b)

boot_medians <- replicate(B, {
  boot_sample <- sample(rain, size = n, replace = TRUE)
  median(boot_sample)
})

median_sd <- sd(boot_medians)
median_ci <- quantile(boot_medians, probs = c(0.025, 0.975))

cat("\n\n3.b) Sample median:", median(rain))
cat("\nBootstrap standard deviation:", median_sd)
cat("\nBootstrap 95% CI:", median_ci)
cat("\nMean CI width:", diff(boot_ci))
cat("\nMedian CI width:", diff(median_ci))
cat("\nThe bootstrap CI for the median is wider that the one for the mean, so there's more incertanty.")