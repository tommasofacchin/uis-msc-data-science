

# Problem 1
# Consider the experiment of flipping an unbiased coin 5 independent times.
# Let H denote the outcome “head” and T the outcome “tail”.

# a) Compute the probability of HHTHT and THHHT exactly
p_HHTHT <- (1/2)^5
p_THHHT <- (1/2)^5

p_HHTHT  
p_THHHT


# b)

n_sim <- 100000
number_of_heads <- rbinom(n_sim, size = 5, prob = 0.5)

mean(number_of_heads == 3)


# d)

set.seed(123)

flips <- matrix(
  sample(
    c(0, 1),
    size = n_sim * 5,
    replace = TRUE,
    prob = c(0.4, 0.6)
  ),
  nrow = n_sim,
  ncol = 5
)

number_of_heads <- rowSums(flips)
mean(number_of_heads == 3)

# e)

pbinom(2, size = 5, prob = 0.6, lower.tail = FALSE)


# Problem 2
# For each of the following, determine the constant c such that f(x) satisfies the 
# condition of being the probability mass function (pmf) for a discrete random variable X.

# a)

x_a <- 1:4
c_a <- sum(x_a)
f_a <- x_a / c_a

c_a
data.frame(x = x_a, f_x = f_a)
sum(f_a)


# b)

x_b <- 0:3
c_b <- 1 / sum((x_b + 1)^2)
f_b <- c_b * (x_b + 1)^2

c_b
data.frame(x = x_b, f_x = f_b)
sum(f_b)


# c)

barplot(
  height = f_a,
  names.arg = x_a,
  xlab = "x",
  ylab = "f(x)",
  main = "PMF a",
  col = "skyblue",
  ylim = c(0, 0.6)
)

barplot(
  height = f_b,
  names.arg = x_b,
  xlab = "x",
  ylab = "f(x)",
  main = "PMF b",
  col = "lightgreen",
  ylim = c(0, 0.6)
)



# Problem 3

# a)

x_a <- 1:4
c_a <- sum(x_a)
f_a <- x_a / c_a

E_X_a <- sum(x_a * f_a)
E_gX_a <- sum(x_a^3 * f_a)

E_X_a
E_gX_a


# b)

x_b <- 0:3
c_b <- 1 / sum((x_b + 1)^2)
f_b <- c_b * (x_b + 1)^2

E_X_b <- sum(x_b * f_b)
E_gX_b <- sum(x_b^3 * f_b)

E_X_b
E_gX_b
