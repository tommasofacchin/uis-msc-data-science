# STA510 exam A4 sheet — v2 (one section per topic)

Write it **by hand** on the single A4 sheet allowed. Priority: 🔴 always on the exam · 🟠 often · 🟢 if there is space left

**How to use it:** read the question → find its words in the table → go to the section → copy the "Answer to write" and plug in the numbers.

| If the question says… | Section |
|---|---|
| "find c / proper density / show that F(x) = … / P(a < X < b) / E(X)" | 0B |
| "generate / simulate n random variables … inverse transform" · "simulate S = min(X₁,X₂,X₃)" · "estimate P(Z < …) / E(Z) by simulation" | 1 Inversion |
| "accept-reject / rejection" · "proposal g" · "which proposal is better?" · F not invertible | 2 Accept-reject |
| "estimate the integral … crude Monte Carlo" · "MC estimator based on draws from …" · "standard error" · "based on the R output, point estimate and 95% CI" · "how many simulations so that SD < …" | 3 Crude MC |
| "importance sampling" · "importance function / proposal f" | 4 Importance sampling |
| "improve … using antithetic variables" · "will the std be more or less?" | 5 Antithetic |
| "bootstrap" · "bias / MSE / bias-corrected" · "bootstrap interval" | 6 Bootstrap |
| "for large n / approximately / CLT" · "how many measurements to be 95% sure" | 7 CLT |
| "show that the likelihood …" · "MLE" · "unbiased?" · "which estimator is better?" | 8 Likelihood |
| "Bayesian approach / prior" · "show that the (log-)posterior kernel is …" · "conditional posterior" · "valid log-target?" · "E and Var of the prior" | 9 Bayes |
| "which MCMC algorithm is this?" · "proposal / acceptance probability" · trace plot, acceptance rate, ESS · "describe the Gibbs sampler" | 10 MCMC |
| "Poisson process / events per day" · "thinning / non-homogeneous" · "random walk" · "Markov?" · "which process does this R code simulate?" | 11 Processes |
| "histogram vs kernel density estimate / KDE / bandwidth / Scott rule" | 12 KDE |
| R code to judge (parameters of `rgamma`, `rnorm`, …) | 13 R |

---

## ❌ Do NOT write (already in the formula sheet `tablesformulas.pdf`)

- pmf/pdf, E and Var of all distributions (§1–2) and the relationship diagram
- MH algorithm with general α, definitions of RWMH, independence sampler and Gibbs (§9)
- Rules to recognise distributions from the log-kernel (§10)
- Transformation formula g(y) = f(w(y))·|w′(y)|, linear combinations, E and Var of sums (§4)
- MLE: Var(θ̂) ≈ 1/J(θ̂) and asymptotic normality (§5)
- Central limit theorem (statement), logarithm rules, derivatives, Gamma function
- Integrals of §7: ∫xⁿ, ∫1/x, ∫eᵃˣ = eᵃˣ/a, ∫x·eᵃˣ = eᵃˣ(ax−1)/a², ∫x²·eᵃˣ, ∫u′(x)·e^u(x) dx = e^u(x), integration by parts

---

## 🔴 0. Maths

**A. Solve u = F(x) for x** (needed in 1 Inversion)
- Order: isolate the block with x → remove the exponential with ln → remove the power with 1/β → divide/multiply the constants
- e^A = B ⇒ A = ln B · ln A = B ⇒ A = e^B
- x^β = c ⇒ x = c^(1/β) (e.g. x² = 9 ⇒ x = 9^(1/2) = 3). No ± if x ≥ 0
- (a/x)^b = c ⇒ a/x = c^(1/b) ⇒ x = a·c^(−1/b) · remember: x^(−b) = 1/x^b, c^(1/2) = √c
- For u ∈ (0,1): ln(1−u) < 0 ⇒ −ln(1−u) > 0
- Weibull example: 1 − e^(−αx^β) = u ⇒ e^(−αx^β) = 1−u ⇒ −αx^β = ln(1−u) ⇒ x = (−ln(1−u)/α)^(1/β)

**B. Densities: constant c, cdf, probabilities, E(X)**
- Proper density: f ≥ 0 and ∫ f = 1 on the support · find c from c·∫(…) = 1
- cdf: F(x) = ∫ₐˣ f(t)dt, check F(a) = 0 and F(b) = 1 · P(X > a) = 1 − F(a) · P(a < X < b) = F(b) − F(a)
- Polynomials: expand and integrate term by term
  - ∫₀¹ x(1−x) = 1/2 − 1/3 = 1/6 ⇒ c = 6 · F(x) = 6(x²/2 − x³/3) = x²(3 − 2x)
  - x(1−x)³ = x − 3x² + 3x³ − x⁴ ⇒ ∫₀¹ = 1/2 − 1 + 3/4 − 1/5 = 1/20 ⇒ c = 20
- ∫₀² (x−2)² dx = [(x−2)³/3]₀² = 0 − (−8/3) = 8/3 ⇒ k = 3/8
- Weibull cdf (formula sheet §7, ∫u′eᵘ = eᵘ with u = −αy^β): ∫₀ˣ αβ·y^(β−1)·e^(−αy^β) dy = [−e^(−αy^β)]₀ˣ = **1 − e^(−αx^β)**
- sin: f = (1+sin x)/(π+2) on [0,π]: ∫₀^π (1+sin x) dx = π + [−cos x]₀^π = π + 2 ⇒ proper · F(x) = (x − cos x + 1)/(π+2)
- Exponentials: ∫₀ˣ λe^(−λy) dy = 1 − e^(−λx) · ∫₀^∞ = 1
  - f = e^(x/4)/(4C), 0≤x≤4, C = e−1: ∫₀⁴ e^(x/4) dx = 4(e−1) = 4C ⇒ integrates to 1 · E(X) = 16·[e^(x/4)(x/4 − 1)]₀⁴/(4C) = 4/C
- Pareto: ∫ₐˣ b·aᵇ·t^(−b−1) dt = 1 − (a/x)^b
- ⚠ forgotten 1/a in front of ∫eᵃˣ · negative sign of a

**C. Derivatives** (needed for c in 2 Accept-reject and for monotonicity in 5 Antithetic)
- Maximum on [a,b]: solve h′(x) = 0, then compare with h(a) and h(b)
- Monotonicity: h′(x) = 0 ⇔ x = … ; if the point is **outside** (a,b) ⇒ h′ has constant sign ⇒ h monotone
- Weibull(4,2) example: f = 8x·e^(−4x²), f′ = 8e^(−4x²)(1 − 8x²) = 0 ⇒ x = 1/√8 ≈ 0.35 ⇒ decreasing on [0.5, 2.5]

**D. Rules NOT in the formula sheet** (the rest of derivatives/integrals/logs is in §7–8)
- ∫sin x dx = −cos x · ∫cos x dx = sin x · (sin x)′ = cos x · (cos x)′ = −sin x · cos 0 = 1, cos π = −1, sin 0 = sin π = 0
- ∫(x−a)ⁿ dx = (x−a)ⁿ⁺¹/(n+1) · e⁰ = 1, ln 1 = 0
- eᵃ·eᵇ = e^(a+b) ⇒ Π e^(aᵢ) = e^(Σaᵢ) · ln Π = Σ ln
- x^(−b) = 1/xᵇ · (xᵃ)ᵇ = x^(ab) · xᵃ·xᵇ = x^(a+b) · x^(1/2) = √x

---

## 🔴 1. Inversion (inverse transform)

**Answer to write** (brackets: W = Weibull(α,β) · P = Pareto(a,b) · E = Exp with scale β)
```
CDF:  F(x) = ∫_{a}^{x} f(t) dt = ...        (or use F(x) derived earlier)
      (W: 1 − e^(−αx^β)  |  P: 1 − (a/x)^b, x > a  |  E: 1 − e^(−x/β), x ≥ 0)
Inverse: set u = F(x), solve for x  ⇒  F⁻¹(u) = ...
      (W: e^(−αx^β) = 1−u ⇒ −αx^β = ln(1−u) ⇒ x = ( −ln(1−u)/α )^(1/β)
       P: (a/x)^b = 1−u ⇒ a/x = (1−u)^(1/b) ⇒ x = a·(1−u)^(−1/b)
       E: e^(−x/β) = 1−u ⇒ −x/β = ln(1−u) ⇒ x = −β·ln(1−u))
Algorithm (inverse transform), n = 10000:
  1. Simulate U₁,…,Uₙ i.i.d. ~ U(0,1).
  2. Compute Xᵢ = F⁻¹(Uᵢ) = ...
      (W: ( −ln(1−Uᵢ)/α )^(1/β)  |  P: a·(1−Uᵢ)^(−1/b)  |  E: −β·ln(1−Uᵢ))
  3. Then X₁,…,Xₙ are i.i.d. ~ f.
Why: P(F⁻¹(U) ≤ x) = P(U ≤ F(x)) = F(x).
```
- Keep the parameters symbolic (α, β, a, b) if the text gives no numbers · U or 1−U both work (1−U ~ U(0,1))
- Algebra to solve u = F(x): 0A

**Variants**
- **"Simulate S = min(X₁,X₂,X₃)"** (function of several variables): repeat for i = 1..n:
  ```
  1. U₁ᵢ, U₂ᵢ, U₃ᵢ ~ U(0,1) independent (one U for each X)
  2. X₁ᵢ = F₁⁻¹(U₁ᵢ), X₂ᵢ = F₂⁻¹(U₂ᵢ), X₃ᵢ = F₃⁻¹(U₃ᵢ)
  3. Sᵢ = min(X₁ᵢ, X₂ᵢ, X₃ᵢ)   ⇒ S₁,…,Sₙ
  ```
  - Exp with mean 1/λ = Weibull(α = λ, β = 1) ⇒ X = −(1/λ)·ln(1−U). ⚠ if β is already the Weibull shape, write the Exp scale as 1/λ, not β
- **"Estimate P(Z < c) / E(Z) by simulation"**: simulate Z₁..Zₙ as above ⇒ P̂ = (number of Zᵢ < c)/n · Ê = mean of the Zᵢ
- **Only U(0,1) and N(0,1)**: lognormal = e^(μ+σZ) · χ²₂ = Z₁² + Z₂²
- **F not invertible** ⇒ "F⁻¹ has no closed form → use accept-reject" (section 2). Signal: x stays in 2 terms of different type (x − cos x, x·eˣ, x + log x, polynomial of degree ≥ 3, Φ)
- **"Which R function is correct?"**: `runif(n)` on (0,1), not (2,4) · correct F⁻¹ (sign, exponent 1/b and not b, order of operations) · U or 1−U both fine

**"Given that it has already … (s), find P(total > c)"**
- Exp ⇒ memoryless: P(X > c | X > s) = P(X > c − s) = e^(−(c−s)/β) · other distributions: P(X > c)/P(X > s)

---

## 🔴 2. Accept-reject

**Answer to write**
```
Proposal: g(x) = ...  (text names it → that · finite [a,b] → U(a,b), g = 1/(b−a) · (0,∞) → Exp · ℝ → N(0,1)/Cauchy; g > 0 where f > 0, f/g bounded)
Ratio: f(x)/g(x) = ... (simplify) → max at x = ... ((f/g)′ = 0 or endpoint; g uniform ⇒ f/g = (b−a)·f, max of f)
       c = max f/g = ...   (check c ≥ 1)
Algorithm (accept-reject):
  1. Simulate X ~ g.
  2. Simulate U ~ U(0,1), independent of X.
  3. If U ≤ f(X)/(c g(X)) = ... (simplified), accept X; else go to 1.
  Repeat until n values are accepted.
Efficiency: P(accept) = 1/c, expected tries = c → smaller c is better.
```
**Worked examples**
- 6x(1−x) with U(0,1) → c = 1.5 · 20x(1−x)³ with Beta(2,2) → c = 10/3 · (1+sin x)/(π+2) with U(0,π) → c = 2π/(π+2)
- f = C·e^(−x²/2) on [−2,2], g = 1/4 ⇒ f/g = 4C·e^(−x²/2), max at 0 ⇒ c = 4C ≈ 1.672 ⇒ accept if U ≤ e^(−X²/2)

**Variants**
- **A single draw**: "repeat { X ~ g; U ~ U(0,1); if U ≤ f(X)/(c·g(X)) return X }"
- **"Which proposal is better?"**: compute c for each g, choose the **smallest c** (P(accept) = 1/c highest); g shaped like f
- **"Is the R code correct?"**: X from g with the right support · new U at every attempt · test U ≤ f(X)/(c·g(X)) with both c and g · repeats until it accepts · returns X (not U)
- AR ≠ independence sampler: AR gives i.i.d. values and retries on rejection; the independence sampler (MCMC, `wt.old`) gives dependent values and repeats x[i−1] on rejection

⚠ denominator without g(x) or without c

---

## 🔴 3. Crude MC (integrals)

**Which distribution to use?**
1. The text names it ("draws from Exp / N(0,1) / Pareto…") ⇒ that one → **D**
2. Finite interval, none named ⇒ U(a,b) → **U**
3. Double/triple integral on a rectangle ⇒ uniforms + volume → **M**
4. Infinite interval, none named ⇒ look for the density inside the integrand: e^(−λx) on (0,∞) → Exp(rate λ) · e^(−x²/2) → N(0,1) · x^(−(b+1)) on (a,∞) → Pareto(a,b) · x^(α−1)e^(−x/β) → Gamma(α,β) → **D**
- Always: support ⊇ domain of the integral; if the support is larger ⇒ ·1(a < X < b)
- **f in case D** = density of the named distribution: if the text writes it, copy it; otherwise formula sheet "Some continuous distributions" with its parameters plugged in. N(μ,σ²): 1st number = μ, 2nd = σ² ⇒ N(0,1): f(x) = e^(−x²/2)/√(2π)

**Answer to write** (g = function to integrate)
```
Integral: θ = ∫ g(x) dx  → write it as an expectation
      (U: θ = (b−a)·E[g(U)], U ~ U(a,b)
       D: θ = ∫ [g(x)/f(x)]·f(x) dx = E_f[g(X)/f(X)]  [·1(a < X < b) when f can give values outside (a,b)]
       M: θ = volume·E[g(U,V,…)], U, V, … independent uniforms)
Algorithm (crude MC), n = 10000:
  1. Simulate (U: U₁,…,Uₙ ~ U(a,b) | D: X₁,…,Xₙ ~ f | M: Uᵢ ~ U(a₁,b₁), Vᵢ ~ U(a₂,b₂))
  2. Compute (U: g(Uᵢ) | D: g(Xᵢ)/f(Xᵢ) [·1(a<Xᵢ<b)] | M: g(Uᵢ,Vᵢ))
  3. Estimator:
      (U: θ̂_CMC = (b−a)/n · Σ g(Uᵢ)
       D: θ̂_CMC = 1/n · Σ g(Xᵢ)/f(Xᵢ)
       M: θ̂_CMC = volume/n · Σ g(Uᵢ,Vᵢ))
Standard error (only if asked):
      (U: SE = (b−a)/√n · √[ 1/(n−1) · Σ (g(Uᵢ) − ḡ)² ],  ḡ = 1/n · Σ g(Uᵢ)
       D: SE = 1/√n · √[ 1/(n−1) · Σ (g(Xᵢ)/f(Xᵢ) − θ̂_CMC)² ]
       M: SE = volume/√n · √[ 1/(n−1) · Σ (g(Uᵢ,Vᵢ) − ḡ)² ])
Why: law of large numbers ⇒ θ̂_CMC → θ.
```
**"Based on the R output, give a point estimate and approx. 95% CI"** (R prints `mean(...)` and `sd(...)` of the simulated values)
```
k = what multiplies the mean in the estimator (U: b−a · D: 1 · M: area/volume)
Point estimate:  θ̂ = k · mean
SE            :  SE = k · sd / √n          (n = number of simulations in the code)
95% CI        :  θ̂ ± 1.96 · SE             (90%: 1.645 · 99%: 2.576)
```
- Example: Â = 4/n·Σ 1(uᵢ,vᵢ), n = 10⁶, mean = 0.166846, sd = 0.3728385
  ⇒ Â = 4·0.166846 = **0.6674** · SE = 4·0.3728385/√10⁶ = 0.00149 · CI = 0.6674 ± 1.96·0.00149 = **[0.6645, 0.6703]**
- Ignore median and quantiles of the indicator (they are 0/1, useless)
- **"It can be shown that Σ … ~ [distribution]. How many simulations so that SD(θ̂) < s₀?"** ⚠ use the distribution from the text, NOT sd from R (sd from R gives a different n ✗)
  1. Y = Σ … ~ [distribution from the text] ⇒ Var(Y) from the formula sheet (with n inside)
  2. θ̂ = k·Y/n ⇒ SD(θ̂) = (k/n)·√Var(Y)
  3. SD(θ̂) < s₀ ⇒ solve for n, round up
  Var(Y): Binomial(n,p) → n·p(1−p) · Poisson(nλ) → nλ · Gamma(n,β) → nβ² · if the text gives one value Xᵢ ~ D instead: SD(θ̂) = k·√Var(D)/√n
  Example (Binomial): k = 4, p = 1/6 ⇒ SD(Y) = √(5n/36), SD(Â) = 4·√(5/36)/√n < 0.01 ⇒ n > 16·(5/36)/0.0001 = 22222.2 ⇒ **n = 22223**

**Worked examples**
- U · ∫₀.₅²·⁵ f, f = 8x·e^(−4x²) ⇒ θ̂ = 2/n·Σ f(Uᵢ), SE = 2/100·√[1/9999·Σ(f(Uᵢ) − f̄)²] · on U(−1,1): k = 2 · on U(−π/2, π/2): k = π
- D · ∫₀^∞ e^(−2x)x^(3/2) dx, X ~ Exp(mean 1/2), f = 2e^(−2x) ⇒ hᵢ = Xᵢ^(3/2)/2
- D · ∫₀^∞ ln(1+4x²)·e^(−x/2) dx, X ~ Exp(scale 2), f = ½e^(−x/2) ⇒ hᵢ = 2·ln(1+4Xᵢ²)
- D · ∫₋∞^∞ e^(−x²/2)cos x dx, X ~ N(0,1) ⇒ hᵢ = √(2π)·cos Xᵢ · only on (−π/2, π/2) ⇒ hᵢ = √(2π)·cos Xᵢ·1(|Xᵢ| < π/2)
- D · ∫ₐ^∞ ln(x)/x^b dx, X ~ Pareto(a,b), f = b·aᵇ/x^(b+1) ⇒ hᵢ = Xᵢ·ln(Xᵢ)/(b·aᵇ)
- M · area ∫₋₁¹∫₋₁¹ 1(x,y) dx dy ⇒ Â = 4/n·Σ 1(Uᵢ,Vᵢ) · π ≈ 4·mean(1(Uᵢ²+Vᵢ² ≤ 1)), U,V ~ U(0,1)
- Mixed M: ∫₁³∫₋₂²∫₀^∞ x·e^(−x²/4)·g(y,z) dx dy dz ⇒ **split** I = I₁·I₂
  - I₁ = ∫₀^∞ x·e^(−x²/4) dx (infinite ⇒ D): X ~ N(0, σ²=2) ⇒ hᵢ = 1(Xᵢ ≥ 0)·2√π·Xᵢ
  - I₂ = ∫₁³∫₋₂² g(y,z) dy dz (rectangle ⇒ M): Yᵢ ~ U(−2,2), Zᵢ ~ U(1,3), area 8 ⇒ Î₂ = 8/n·Σ g(Yᵢ,Zᵢ)
  - uniforms + volume only if **all** limits are finite

**Related questions**
- "How large n so that SE ≤ s₀?" ⇒ n ≥ (k·s/s₀)², round up · k = multiplier of the mean (U: b−a · D: 1 · M: area) · s: **if the text gives a distribution, use it (recipe above)**; only otherwise s = `sd(...)` printed by R
- **"For n = …, calculate (approximately) P(θ̂ < c) without using the simulation results"** ⚠ the answer is a probability, NOT an interval · use NOTHING from the R output
  1. CLT: θ̂ is a sum ⇒ θ̂ ≈ Normal
  2. E(θ̂) = (k/n)·E(Y), E(Y) from the formula sheet (Binomial: np)
  3. SD(θ̂) = (k/n)·√Var(Y) (same as the "how many simulations" recipe), with the n from the text
  4. P(θ̂ < c) ≈ Φ((c − E(θ̂))/SD(θ̂)) → standard normal table   (P(θ̂ > c) = 1 − Φ(…))
  Example: n = 1000, c = 0.67 ⇒ E(Â) = (4/n)·(n/6) = 2/3 · SD(Â) = 4·√(5/36)/√1000 = 0.04714 ⇒ Φ((0.67 − 2/3)/0.04714) = Φ(0.0707) ≈ **0.5279**
  Φ(z) without table (calculator): **Φ(z) ≈ 1/(1 + e^(−1.6·z − 0.07·z³))** · Φ(−z) = 1 − Φ(z) · e.g. z = 0.0707 → 0.528

---

## 🔴 4. Importance sampling

**Answer to write**
```
θ = ∫ h(x) dx = ∫ [h(x)/f(x)]·f(x) dx = E_f[h(X)/f(X)],  f = given proposal, support of f ⊇ domain of h
Algorithm, n = 10000:
  1. Simulate X₁,…,Xₙ ~ f.
  2. θ̂_IS = 1/n · Σ h(Xᵢ)/f(Xᵢ) · 1(Xᵢ in the domain)
  3. SE = sd(h(Xᵢ)/f(Xᵢ)) / √n   (only if asked)
```
- Example: ∫₀¹ x(1−x)³ dx with Beta(2,2), f = 6x(1−x) ⇒ h/f = (1−x)²/6 ⇒ θ̂ = 1/n·Σ(1−Xᵢ)²/6
- **f** = density of the named proposal: formula sheet with its parameters plugged in (Gamma(α,β): f = x^(α−1)e^(−x/β) / (Γ(α)·β^α), α = shape, β = scale; Γ values are given in the text) — see "f in case D", section 3
- **"Does it work well?"**: yes if h/f ≈ constant (f shaped like |h|) and f has heavier tails than h (h/f bounded); no if h/f explodes in the tails or near 0 · h/f **constant** ⇒ "perfect (variance-free) estimator, variance 0" · h/f ∝ x (linear) ⇒ "works well"
- **"Does it always reduce the variance?"**: **no**, a bad f can increase it (even infinite)
- **"Which R code is correct?"**: divide by the proposal density (`dgamma` with the same parameters as `rgamma`) and include the domain indicator
- ⚠ ratio upside down (f/h) · different parameters in r… and d… · missing indicator

---

## 🔴 5. Antithetic variables

**Answer to write** (brackets: U = uniforms on (a,b) · D = draws from f by inversion · M = double/rectangle)
```
0. FIRST SENTENCE (always):
   "h is monotone on (a,b) [from the plot | h′(x) = ... = 0 ⇔ x = ..., outside (a,b)]
    ⇒ we can improve crude MC with antithetic pairs."
Algorithm (antithetic), n = 10000 evaluations = n/2 = 5000 pairs:
  1. Simulate U₁,…,U_{n/2} i.i.d.
      (U: ~ U(a,b)  |  D: ~ U(0,1)  |  M: Uᵢ ~ U(a₁,b₁), Vᵢ ~ U(a₂,b₂))
  2. Antithetic partner of each draw:
      (U: Ũᵢ = a + b − Uᵢ   [U(0,1): 1−Uᵢ · U(−c,c): −Uᵢ]
       D: Xᵢ = F⁻¹(Uᵢ),  X̃ᵢ = F⁻¹(1 − Uᵢ)
       M: (Uᵢ, Vᵢ) and (a₁+b₁−Uᵢ, a₂+b₂−Vᵢ))
  3. Estimator:
      θ̂_AT = k/n · Σᵢ₌₁^{n/2} [ h(Xᵢ) + h(X̃ᵢ) ]
      (U: k = b−a  |  D: k = 1  |  M: k = volume)   (U, M: h = g  |  D: h = g/f)
  4. Only if asked, SE: Yᵢ = [h(Xᵢ) + h(X̃ᵢ)]/2,  SE(θ̂_AT) = k · sd(Y₁,…,Y_{n/2}) / √(n/2)
"More or less std than crude?" → LESS:
  h monotone ⇒ Cov(h(X), h(X̃)) < 0 ⇒ Var(θ̂_AT) = k²σ²(1+ρ)/n < k²σ²/n = Var(θ̂_CMC)
```
**Worked examples**
- U · ∫₀.₅²·⁵ f, f = Weibull(4,2) pdf: peak at 0.35 < 0.5 ⇒ f decreasing ⇒ Ũᵢ = 3 − Uᵢ, θ̂_AT = 2/n·Σᵢ₌₁⁵⁰⁰⁰ [f(Uᵢ) + f(3−Uᵢ)] ⇒ smaller std (0.0062 vs 0.0070)
- D · Exp scale β: Xᵢ = −β·ln Uᵢ, X̃ᵢ = −β·ln(1−Uᵢ) · Pareto: Xᵢ = a(1−Uᵢ)^(−1/b), X̃ᵢ = a·Uᵢ^(−1/b)
- M · π: 4·(1/n)Σ[1(Uᵢ²+Vᵢ² ≤ 1) + 1((1−Uᵢ)²+(1−Vᵢ)² ≤ 1)]

**"Does it work?"**
- Yes if h is **monotone** on the domain (check with h′: 0C, or from the plot)
- No if h is **even** (cos x, x², e^(−x²)) and X̃ = −X on a symmetric interval: h(X̃) = h(X), correlation +1, variance worse than crude
- Not monotone ⇒ "not guaranteed, since h is not monotone on the interval"

⚠ n pairs instead of n/2 · SE with √n · 1−U used on U(a,b) instead of a+b−U

---

## 🔴 6. Bootstrap

**Answer to write**
```
Algorithm (non-parametric bootstrap), B samples:
  1. For b = 1,…,B: draw x*_b = n values from x₁,…,xₙ with replacement.
  2. Compute θ̂*_b = estimator(x*_b).
  3. From θ̂*₁,…,θ̂*_B:
     bias = mean(θ̂*) − θ̂        SE = sd(θ̂*)        MSE = var(θ̂*) + bias²
     bias-corrected estimate = θ̂ − bias = 2θ̂ − mean(θ̂*)
     95% normal:     θ̂ ± 1.96·sd(θ̂*)        (90%: 1.645)
     95% percentile: (q₀.₀₂₅, q₀.₉₇₅) of θ̂*  (90%: q₀.₀₅, q₀.₉₅)
     95% basic:      (2θ̂ − q₀.₉₇₅, 2θ̂ − q₀.₀₂₅)
```
- From the quantile table: var = sd²
- **"Is the R code correct?"**: `sample(data, size=length(data), replace=TRUE)` inside the loop, then the estimator
- ⚠ `replace=FALSE` · `size=nrep` · `mean` instead of the estimator · `sd` instead of `var` in the MSE · wrong sign − · `1-quantile`

---

## 🟠 7. CLT (the statement is in the formula sheet)

- **Answer to write:** "X₁..Xₙ i.i.d. with finite μ, σ² ⇒ by the CLT, for large n: **X̄ ≈ N(μ, σ²/n)**". Compute μ and σ² from f
- **"P(X̄ < a) approximately"** ⇒ Φ((a − μ)/(σ/√n))
- **"How many measurements to be 95% sure the error is at most m?"** ⇒ 1.96·σ/√n ≤ m ⇒ **n ≥ (1.96·σ/m)²**, round up
- **Confidence interval** ⇒ X̄ ± z·σ/√n, z = 1.96 (95%), 1.645 (90%), 2.576 (99%)
- ⚠ Var(X̄) = σ²/n, not σ²

---

## 🟠 8. Likelihood, MLE, estimators

- **"Show that the likelihood is …"** (often with given constants c₁, c₂: they are only **names** for the product and the sum that come out, do not compute them) → write L(θ) = Πᵢ f(xᵢ; θ), then simplify the product:
  - Π(A·B·C) = ΠA · ΠB · ΠC (each piece separately) · Σ(θ·bᵢ) = θ·Σbᵢ (θ out of the sum)
  - θ in every factor → θⁿ (θ⁻¹ → θ⁻ⁿ)
  - parts with only xᵢ → Πᵢ(…) → it is **c₁**
  - e^(…) in every factor → one e^(Σ…), because Π e^(aᵢ) = e^(Σaᵢ) → the Σ is **c₂**
  - e.g. with c₁ = Π(1+3xᵢ^(1/2)), c₂ = Σ(xᵢ+2xᵢ^(3/2)):
    L(θ) = Π θ(1+3xᵢ^(1/2))e^(−θ(xᵢ+2xᵢ^(3/2))) = θⁿ · Π(1+3xᵢ^(1/2)) · e^(−θ Σ(xᵢ+2xᵢ^(3/2))) = θⁿ · c₁ · e^(−θc₂)
- **"Show / find the MLE"** → 1) L as above 2) ℓ = ln L (ln Π = Σ ln · ln θⁿ = n ln θ · ln e^a = a) 3) ℓ′(θ) = 0, solve for θ 4) check ℓ″ < 0
  - e.g. Exp scale θ: ℓ = −n ln θ − Σxᵢ/θ ⇒ θ̂ = x̄ · Pareto (a known): ℓ = n ln b + nb ln a − (b+1)Σ ln xᵢ ⇒ b̂ = n / Σ ln(xᵢ/a)
- **"Unbiased? / which estimator is better?"** → bias = E(θ̂) − θ (unbiased if 0) · MSE = Var + bias² · lower MSE = better

---

## 🔴 9. Bayes: prior, posterior, conditionals

**"Show that the posterior / log-posterior kernel is …"** — answer to write:
```
p(θ | x) ∝ L(θ) · p(θ)          (log: log p(θ|x) = log L(θ) + log p(θ) + const)
1. Likelihood: L(θ) = Πᵢ f(xᵢ | θ), simplify (section 8)
2. Prior: write p(θ), drop the constants without θ
     Gamma(a, scale b): θ^(a−1)·e^(−θ/b)          Exp(rate λ): e^(−λθ)
     N(m, s²): e^(−(θ−m)²/(2s²))                  flat: 1(θ > 0)
     log σ² ~ N(0,1) (σ² ~ logN(0,1)): (σ²)⁻¹·e^(−(log σ²)²/2)
3. Multiply L·p, collect the same powers of θ and the exponents ⇒ the kernel in the text
```
- Exp scale θ, prior Gamma(a₀, b₀): θ⁻ⁿe^(−Σxᵢ/θ) · θ^(a₀−1)e^(−θ/b₀) ⇒ log = (a₀−n−1)·log θ − θ/b₀ − Σxᵢ/θ
- Exp(rate ab), a, b ~ Exp(3): (ab)ⁿe^(−abΣtᵢ) · 9e^(−3a−3b) ∝ (ab)ⁿ·e^(−abΣtᵢ)·e^(−3(a+b))
- Pareto(a,b), prior 1(a,b > 0): Π 1(a < xᵢ) = 1(a < min xᵢ) ⇒ bⁿa^(nb)/(Πxᵢ)^(b+1) · 1(a < x₍₁₎)·1(a,b > 0)
- Normal yᵢ ~ N(μ,σ²): L ∝ (σ²)^(−n/2)·e^(−S(μ)/(2σ²)), S(μ) = Σ(yᵢ−μ)² · prior μ|σ² ~ N(m₀, σ²/κ₀): (σ²)^(−1/2)·e^(−κ₀(μ−m₀)²/(2σ²))
  ⇒ joint (μ, σ²), with prior σ² ~ logN(0,1): powers −n/2 −1/2 −1 = −(n+3)/2; exponents add ⇒ (σ²)^(−(n+3)/2)·e^(−[S(μ)+κ₀(μ−m₀)²]/(2σ²) − (log σ²)²/2)

**"Find the conditional posterior θ₁ | θ₂, x"** — answer to write:
```
1. From the joint posterior keep only the factors with θ₁ (everything else is a constant).
2. Take the log and write it as  a + b·log θ₁ + c·θ₁   or   a + b·θ₁ + c·θ₁².
3. Match (formula sheet §10 / hint in the text):
     a + b·log x + c·x   ⇒  x ~ Gamma(shape b+1, scale −1/c)
     a + b·x + c·x²      ⇒  x ~ N(mean −b/(2c), var −1/(2c))
     a + b·log x + c·log(1−x), 0<x<1 ⇒ x ~ Beta(b+1, c+1)   (not in formula sheet)
4. No standard form (e.g. an extra (log σ²)² term) ⇒ "not a standard distribution, we cannot
   sample directly → use a Metropolis-Hastings step for it".
```
- log p(a | b, t) = n·log a − (bΣtᵢ + 3)·a ⇒ a | b, t ~ Gamma(n+1, 1/(bΣtᵢ + 3)) · same prior ⇒ b | a is the same with a in place of b
- Pareto b | a, x ∝ bⁿ·e^(−b(Σln xᵢ − n ln a)) ⇒ Gamma(n+1, 1/(Σln xᵢ − n ln a)) · a | b, x ∝ a^(nb)·1(0 < a < x₍₁₎)
- Distribution Ψ defined in the text ("show a | b ∝ Ψ(a | nb+1, x*)") ⇒ write your conditional (a^(nb)·1(0<a<x₍₁₎)) next to its density and match the pieces: exponent = α−1 ⇒ α = nb+1 · indicator bound = β ⇒ β = x₍₁₎
- μ | σ², y ~ N(mₙ, σ²/κₙ), κₙ = n + κ₀, mₙ = (nȳ + κ₀m₀)/(n + κ₀)
- μ | σ², y: expand, keep only terms with μ: c = −(n+κ₀)/(2σ²) (coeff. of μ²), b = (nȳ+κ₀m₀)/σ² (coeff. of μ) ⇒ mean −b/(2c) = mₙ, var −1/(2c) = σ²/κₙ
- σ² | μ, y: log p = −(n+3)/2·log σ² − K(μ)/(2σ²) − (log σ²)²/2, K(μ) = S(μ)+κ₀(μ−m₀)² ⇒ without the last term it would be an Inverse-Gamma; with it, not standard ⇒ MH step

**"Which R functions are valid log-target kernels?"**
- Valid if = log L + log prior up to constants: `log(prod(f(x,θ)))` ok · `dgamma(θ, shape=a, scale=b, log=TRUE)` ok · (a−1)·log θ − θ/b ok
- ⚠ typical error: − log(θ/b) instead of − θ/b · prior parameters different from those in the text

**"E and Var of the prior"** → formula sheet (§1–2). Gamma(a, scale b): E = ab, Var = ab² (⚠ if b is a rate: a/b, a/b²)

---

## 🔴 10. MCMC (definitions in the formula sheet §9)

**"Which (MCMC) algorithm is this? Why?"** (from the code) — find the clue, copy the sentence (type + proposal + α):
- **RWMH** — clue: the proposal uses the previous state: `rnorm(1, mean=x[t-1], sd=σ)` or `x[t-1] + σ*rnorm(1)` (2-dim: `x[,i-1] + rnorm(2)`), then `alpha` + `runif` ⇒ "Random walk MH: the proposal θ* ~ N(θ_{t−1}, σ²) (σ = sd in the code; 2-dim: N(x_{t−1}, σ²I)) depends on the previous state and is symmetric, so α = min(1, g(θ*)/g(θ_{t−1}))"
- **Independence MH** — clue: the proposal does NOT use the previous state (`rnorm(1, mean=5, sd=σ)`, `runif(1,-2,2)`) + weights `wt.star/wt.old` ⇒ "Independence MH: the proposal θ* ~ r = N(5, σ²) does not depend on θ_{t−1}; weights w = g/r, α = min(1, w(θ*)/w(θ_{t−1}))"
- **Gibbs** — clue: one component at a time, drawn from a named distribution that uses the other component (`rnorm(1, mean=rho*x2, …)`, `rgamma(1, …lambda[2]…)`), NO `alpha`, NO `runif` ⇒ "Gibbs sampler: each component is updated from its conditional distribution p(x₁|x₂), p(x₂|x₁); every draw is accepted"
- **iid (not MCMC)** — clue: `chol(Σ)` and `x[,i] <- L %*% rnorm(2)`, no draw uses the previous one ⇒ "iid simulation: xᵢ = L·z, z ~ N(0, I), LLᵀ = Σ ⇒ uncorrelated samples"
- **Target** (if asked): the function inside `alpha` (`dnorm(·, mean=2, sd=2)` ⇒ N(2, 2²); `gx`/`lpost` ⇒ g) · `if(thetaStar>=1 & …)` ⇒ proposals outside the support are rejected

**"Write down a proposal / derive the acceptance probability"** — choose the case from the question (g = target kernel, θ* = proposal, θ_{t−1} = current state):

**Case A — the question says "random walk" / "RWMH" / "write down a proposal for RWMH"**
```
Proposal:  θ* = θ_{t−1} + ε,  ε ~ N(0, σ²)   i.e.  θ* ~ N(θ_{t−1}, σ²)
           (symmetric proposal ⇒ q cancels — write it only if they ask for α / why α has this form)
log α = min(0, log g(θ*) − log g(θ_{t−1}))
```

**Case B — the question says "log-scale proposal" / "log θ* = log θ_{t−1} + ε" / "lognormal" / θ > 0**
```
Proposal:  log θ* = log θ_{t−1} + ε,  ε ~ N(0, σ²)
           ⇒ θ* ~ Lognormal(log θ_{t−1}, σ²)  (only positive values, NOT symmetric)
log α = min(0, log g(θ*) − log g(θ_{t−1}) + log θ* − log θ_{t−1})
           (the extra term log θ* − log θ_{t−1} comes from the non-symmetric q)
```

**Case C — the question says "independent proposal" / "Gamma proposal centred near the MLE"**
```
Proposal:  θ* ~ Gamma(a_p, b_p), does NOT depend on θ_{t−1}
           mean = MLE:  a_p·b_p = θ̂     variance:  a_p·b_p² = Var(θ̂)
           (e.g. Var(θ̂) = θ̂²/n ⇒ a_p = n, b_p = θ̂/n)
log α = min(0, log g(θ*) − log q(θ*) − log g(θ_{t−1}) + log q(θ_{t−1}))
           (q = Gamma(a_p, b_p) density)
```

**Always, at the end of every case** (accept step):
```
Draw U ~ U(0,1): if log U < log α accept, θ_t = θ*;  otherwise θ_t = θ_{t−1}.
```
- If the question fits none of A, B, C, use the general formula: log α = min(0, log g(θ*) + log q(θ_{t−1}|θ*) − log g(θ_{t−1}) − log q(θ*|θ_{t−1}))
- **"Why is the RWMH not suitable?"**: θ > 0 but the normal proposal can give negative values ⇒ they must be rejected (α = 0), symmetry breaks and mixing gets worse near 0 ⇒ use the log-scale proposal or a positive-only proposal

**Performance: trace plot, acceptance rate, ESS**
- **"Difference between these plots?"** → first sentence: "The plots use different proposal variances σ²." Then one line per plot:
  - slow waves, moves slowly across the support ⇒ small σ²: (almost) all accepted but tiny steps, high autocorrelation
  - dense, fills the band, good mixing ⇒ good σ²
  - flat stretches, few points, stays still ⇒ large σ²: most proposals rejected, low acceptance
- small σ ⇒ very high acceptance, the chain moves slowly, low ESS
- large σ ⇒ few accepted, flat stretches, low acceptance
- good ⇒ RWMH with acceptance **20%–40%** and high ESS · other checks: Geweke, Gelman-Rubin
- starting value far away ⇒ remove the burn-in (first 100–200) or choose a better starting value · thinning reduces autocorrelation
- **"Average of MCMC vs iid?"** ⇒ larger variance, because the samples are positively autocorrelated
- **"Which algorithm do you prefer? Why?"** ⇒ best → worst: **iid** (uncorrelated samples) · **Gibbs** (conditionals known, no rejections) or **independence MH** with a good proposal (almost uncorrelated, high acceptance) · **RWMH** last (correlated samples, only 20–40% accepted, rejects proposals outside the support) ⇒ answer = the best algorithm among those shown + its reason

**"Describe the Gibbs sampler"** — answer to write:
```
State θ = (θ₁, θ₂). Choose initial values θ⁽⁰⁾ = (θ₁⁽⁰⁾, θ₂⁽⁰⁾). For t = 1, …, N:
  1. Draw θ₁⁽ᵗ⁾ ~ p(θ₁ | θ₂⁽ᵗ⁻¹⁾, x)     (its conditional posterior, e.g. Gamma(…))
  2. Draw θ₂⁽ᵗ⁾ ~ p(θ₂ | θ₁⁽ᵗ⁾, x)
  If a conditional is not standard, replace that draw with an MH step.
Output θ⁽¹⁾, …, θ⁽ᴺ⁾ (discard the burn-in).
```
- **"Three points for an efficient Gibbs sampler"**: blocks as large as possible (multivariate rather than many univariate updates) · keep strongly dependent variables in the same block (blocks as independent as possible) · if a block has no closed-form conditional, use efficient low-dimensional Metropolis updates

---

## 🟠 11. Stochastic processes

**Homogeneous Poisson** — N(t) ~ Poisson(λt), E = Var = λt, inter-arrival times ~ Exp(rate λ)
```
Simulate on [0,T]:  1. t = 0   2. t ← t + E, E ~ Exp(rate λ)   3. if t < T record the event and go to 2, else stop
(or: N ~ Poisson(λT), then event times = sort(U₁,…,U_N), Uᵢ ~ U(0,T))
```
- E.g.: λ = 6 per day, 30 days ⇒ T = 30, rate 6 (or N ~ Poisson(180))
- R code: `cumsum(rexp(·, λ))` up to T, or `sort(runif(N, 0, T))`

**Non-homogeneous Poisson (thinning)** — Λ(t) = ∫₀ᵗ λ(s)ds, N(t) ~ Poisson(Λ(t))
```
λ_max ≥ max λ(t) on [0,T]
1. Simulate a homogeneous Poisson process with rate λ_max on [0,T] → times t₁, t₂, …
2. For each tᵢ: U ~ U(0,1), keep tᵢ if U ≤ λ(tᵢ)/λ_max
```
- λ(t) = at² + bt + c with a < 0 ⇒ max at t* = −b/(2a) (outside [0,T] ⇒ endpoint) · E[N(T)] = Λ(T) = ∫₀ᵀ λ(t)dt
- E.g.: λ = −30t² + 350t + 3950 ⇒ t* ≈ 5.83, λ_max ≈ 4971 · Λ(12) = −10·12³ + 175·12² + 3950·12 = 55320

**Random walk** ±1 with P(+1) = p, from 0: E(X_t) = t(2p−1), Var(X_t) = 4tp(1−p); p = 0.5 ⇒ E = 0, Var = t
- ⚠ if the code starts from `x[1]=0`, x[T] has T−1 steps
- Markov property: the future depends only on the present state

---

## 🟠 12. Histogram vs KDE

- In common: both estimate the unknown pdf from the sample · both used to present results · both have a smoothing parameter (number of bins / bandwidth h)
- Histogram: + simple, easy to interpret · − shape changes a lot with the bins, step function · KDE: + smooth, suited for continuous distributions · − more computationally intensive, depends on h
- Large h ⇒ oversmoothing, high bias, low variance · small h ⇒ wiggly, low bias, high variance · best = bias-variance trade-off (min MISE)
- Scott rule: assumes normal data (min MISE vs a normal) ⇒ not suited for skewed / heavy-tailed distributions (Pareto)

---

## 🟢 13. R

- `rnorm(n, mean, sd)`: sd, not variance · `rexp(n, rate)` · `rgamma(n, shape, rate)`: the 3rd unnamed argument is the rate, `scale=` must be written explicitly · `dgamma(..., log=TRUE)` = log of the density
- Markov chain: `prob=P[state,]` (row of the current state) · stationary π = πP with `%*%`
- Mixture: w = U < p, Y = w·X₁ + (1−w)·X₂ (not p·X₁ + (1−p)·X₂)
- Permutation test: `replace=FALSE` is **correct**
- `rmvnorm`: `sigma` = covariance matrix · Cholesky `t(chol(Σ))` · AR(1) stationary if |φ| < 1

---

**⚠ Scale vs rate (Gamma, Exp)** — check whether the text says "scale" or "rate": same distribution, scale = 1/rate
- The formula sheet uses the **scale** β: Gamma f = x^(α−1)e^(−x/β) / (Γ(α)β^α) · Exp f = (1/β)e^(−x/β)
- Text gives the **scale** ⇒ β = that number · text gives the **rate** ⇒ β = 1/rate (Exp(rate λ): f = λe^(−λx))
- E.g. "rate 2" ⇒ β = 1/2 ⇒ e^(−2x) ✓ · using β = 2 ⇒ e^(−x/2) ✗

**⚠ Support vs domain** — **domain** = interval of the integral (limits of ∫ₐᵇ) · **support** = values the distribution f you simulate from can generate (written next to f, e.g. "x > 0")
- support = domain ⇒ no indicator · support **larger** ⇒ multiply by 1(a < Xᵢ < b) · support **smaller** ⇒ that f is wrong (never covers part of the integral)
- E.g. ∫₁⁶ with Gamma (0,∞) ⇒ ·1(1 < Xᵢ < 6) · ∫₀¹ with Beta(2,2) [0,1] ⇒ nothing · ∫₀⁴ with U(0,2) ✗
