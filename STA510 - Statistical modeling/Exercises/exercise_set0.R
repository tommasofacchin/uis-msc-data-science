x <- runif(n=1000, 0, 1)
x

hist(x)

x > 0.5

sum(x > 0.5)

# Plot the function sin(x) over the interval x ∈ [0,2π] 
# (Hint make abcissa using “seq” and do the plotting using “plot”)

x <- seq(0, 2 * pi, length.out = 1000)

# Plot sin(x)
plot(
  x, sin(x),
  type = "l",
  main = "sin(x) from 0 to 2π",
  xlab = "x",
  ylab = "sin(x)",
  col = "blue",
  lwd = 2
)


#Write a function that solves a + bx + cx2 = 0 for x when a,b,c are input variables.

f <- function(a, b, c) {
  discriminant <- b^2 - 4 * a * c
  
  x1 <- (-b + sqrt(discriminant)) / (2 * a)
  x2 <- (-b - sqrt(discriminant)) / (2 * a)
  
  c(x1, x2)
}

f(1, 6, 9)


f2 <- function(x) {
  n <- length(x)
  x_bar <- mean(x)
  s <- sd(x)
  
  margin_error <- 1.96 * s / sqrt(n)
  
  c(
    lower = x_bar - margin_error,
    upper = x_bar + margin_error
  )
}


# Fibonacci

a <- 0
b <- 1

for (i in 1:100) {
  if (a >= 100000) {
    break
  }
  
  print(a)
  
  next_number <- a + b
  a <- b
  b <- next_number
}
  
