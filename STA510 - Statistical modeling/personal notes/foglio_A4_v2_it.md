# Foglio A4 per l'esame STA510 — v2 (una sezione per argomento)

Va scritto **a mano** sull'unico foglio A4 ammesso. Priorità: 🔴 sempre all'esame · 🟠 spesso · 🟢 se avanza spazio

**Come si usa:** leggi la domanda → trova le parole nella tabella → vai alla sezione → copia la "Risposta da scrivere" e sostituisci i numeri.

| Se la domanda dice… | Sezione |
|---|---|
| "find c / proper density / show that F(x) = … / P(a < X < b) / E(X)" | 0B |
| "generate / simulate n random variables … inverse transform" · "simulate S = min(X₁,X₂,X₃)" · "estimate P(Z < …) / E(Z) by simulation" | 1 Inversione |
| "accept-reject / rejection" · "proposal g" · "which proposal is better?" · F non invertibile | 2 Accept-reject |
| "estimate the integral … crude Monte Carlo" · "MC estimator based on draws from …" · "standard error" · "based on the R output, point estimate and 95% CI" · "how many simulations so that SD < …" | 3 MC crude |
| "importance sampling" · "importance function / proposal f" | 4 Importance sampling |
| "improve … using antithetic variables" · "will the std be more or less?" | 5 Antitetiche |
| "bootstrap" · "bias / MSE / bias-corrected" · "bootstrap interval" | 6 Bootstrap |
| "for large n / approximately / CLT" · "how many measurements to be 95% sure" | 7 CLT |
| "show that the likelihood …" · "MLE" · "unbiased?" · "which estimator is better?" | 8 Likelihood |
| "Bayesian approach / prior" · "show that the (log-)posterior kernel is …" · "conditional posterior" · "valid log-target?" · "E and Var of the prior" | 9 Bayes |
| "which MCMC algorithm is this?" · "proposal / acceptance probability" · trace plot, acceptance rate, ESS · "describe the Gibbs sampler" | 10 MCMC |
| "Poisson process / events per day" · "thinning / non-homogeneous" · "random walk" · "Markov?" · "which process does this R code simulate?" | 11 Processi |
| "histogram vs kernel density estimate / KDE / bandwidth / Scott rule" | 12 KDE |
| codice R da giudicare (parametri di `rgamma`, `rnorm`, …) | 13 R |

---

## ❌ Da NON scrivere (è già nel formulario `tablesformulas.pdf`)

- pmf/pdf, E e Var di tutte le distribuzioni (§1–2) e il diagramma delle relazioni
- Algoritmo MH con α generale, definizioni di RWMH, independence sampler e Gibbs (§9)
- Regole per riconoscere le distribuzioni dal log-kernel (§10)
- Formula di trasformazione g(y) = f(w(y))·|w′(y)|, combinazioni lineari, E e Var di somme (§4)
- MLE: Var(θ̂) ≈ 1/J(θ̂) e normalità asintotica (§5)
- Teorema del limite centrale (enunciato), regole del logaritmo, derivate, funzione Gamma
- Integrali del §7: ∫xⁿ, ∫1/x, ∫eᵃˣ = eᵃˣ/a, ∫x·eᵃˣ = eᵃˣ(ax−1)/a², ∫x²·eᵃˣ, ∫u′(x)·e^u(x) dx = e^u(x), integrazione per parti

---

## 🔴 0. Matematica

**A. Risolvere u = F(x) per x** (serve in 1 Inversione)
- Ordine: isola il blocco con x → togli l'esponenziale con ln → togli la potenza con 1/β → dividi/moltiplica le costanti
- e^A = B ⇒ A = ln B · ln A = B ⇒ A = e^B
- x^β = c ⇒ x = c^(1/β) (es. x² = 9 ⇒ x = 9^(1/2) = 3). Nessun ± se x ≥ 0
- (a/x)^b = c ⇒ a/x = c^(1/b) ⇒ x = a·c^(−1/b) · ricorda: x^(−b) = 1/x^b, c^(1/2) = √c
- Per u ∈ (0,1): ln(1−u) < 0 ⇒ −ln(1−u) > 0
- Esempio Weibull: 1 − e^(−αx^β) = u ⇒ e^(−αx^β) = 1−u ⇒ −αx^β = ln(1−u) ⇒ x = (−ln(1−u)/α)^(1/β)

**B. Densità: costante c, cdf, probabilità, E(X)**
- Proper density: f ≥ 0 e ∫ f = 1 sul supporto · c si trova da c·∫(…) = 1
- cdf: F(x) = ∫ₐˣ f(t)dt, controlla F(a) = 0 e F(b) = 1 · P(X > a) = 1 − F(a) · P(a < X < b) = F(b) − F(a)
- Polinomi: espandi e integra termine a termine
  - ∫₀¹ x(1−x) = 1/2 − 1/3 = 1/6 ⇒ c = 6 · F(x) = 6(x²/2 − x³/3) = x²(3 − 2x)
  - x(1−x)³ = x − 3x² + 3x³ − x⁴ ⇒ ∫₀¹ = 1/2 − 1 + 3/4 − 1/5 = 1/20 ⇒ c = 20
- Sostituzione ∫ f(g(y))·g′(y) dy: **1)** u = g(y) (la parte "interna": esponente o parentesi) **2)** du = g′(y)dy, se manca una costante k usa (resto)dy = du/k **3)** cambia gli estremi **4)** integra in u, non tornare in y
  - Segnale: c'è una funzione e la sua derivata (es. αβ·y^(β−1)·e^(−αy^β))
  - ∫₀² (x−2)² dx, u = x−2 ⇒ ∫₋₂⁰ u² du = 8/3 ⇒ k = 3/8
  - Weibull: u = αy^β, du = αβ·y^(β−1)dy, estremi 0 → αx^β ⇒ ∫₀^(αx^β) e^(−u)du = **1 − e^(−αx^β)**
  - ∫ x·e^(−x²) dx, u = x², du = 2x dx ⇒ ½∫e^(−u)du
- Esponenziali: ∫₀ˣ λe^(−λy) dy = 1 − e^(−λx) · ∫₀^∞ = 1
  - f = e^(x/4)/(4C), 0≤x≤4, C = e−1: ∫₀⁴ e^(x/4) dx = 4(e−1) = 4C ⇒ integra a 1 · E(X) = 16·[e^(x/4)(x/4 − 1)]₀⁴/(4C) = 4/C
- Pareto: ∫ₐˣ b·aᵇ·t^(−b−1) dt = 1 − (a/x)^b
- ⚠ 1/a dimenticato davanti a ∫eᵃˣ · segno di a negativo · estremi non cambiati · costante di du persa

**C. Derivate** (serve per c in 2 Accept-reject e per la monotonia in 5 Antitetiche)
- Massimo su [a,b]: risolvi h′(x) = 0, poi confronta con h(a) e h(b)
- Monotonia: h′(x) = 0 ⇔ x = … ; se il punto è **fuori** da (a,b) ⇒ h′ ha segno costante ⇒ h monotona
- Esempio Weibull(4,2): f = 8x·e^(−4x²), f′ = 8e^(−4x²)(1 − 8x²) = 0 ⇒ x = 1/√8 ≈ 0.35 ⇒ su [0.5, 2.5] decrescente

---

## 🔴 1. Inversione (inverse transform)

**Risposta da scrivere** (parentesi: W = Weibull(α,β) · P = Pareto(a,b) · E = Exp con scala β)
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
- Lascia i parametri simbolici (α, β, a, b) se il testo non dà numeri · U o 1−U vanno bene uguale (1−U ~ U(0,1))
- Algebra per risolvere u = F(x): 0A

**Varianti**
- **"Simulate S = min(X₁,X₂,X₃)"** (funzione di più variabili): ripeti per i = 1..n:
  ```
  1. U₁ᵢ, U₂ᵢ, U₃ᵢ ~ U(0,1) independent (one U for each X)
  2. X₁ᵢ = F₁⁻¹(U₁ᵢ), X₂ᵢ = F₂⁻¹(U₂ᵢ), X₃ᵢ = F₃⁻¹(U₃ᵢ)
  3. Sᵢ = min(X₁ᵢ, X₂ᵢ, X₃ᵢ)   ⇒ S₁,…,Sₙ
  ```
  - Exp con media 1/λ = Weibull(α = λ, β = 1) ⇒ X = −(1/λ)·ln(1−U). ⚠ se β è già la forma della Weibull, per l'Exp scrivi 1/λ, non β
- **"Estimate P(Z < c) / E(Z) by simulation"**: simula Z₁..Zₙ come sopra ⇒ P̂ = (numero di Zᵢ < c)/n · Ê = media degli Zᵢ
- **Solo U(0,1) e N(0,1)**: lognormale = e^(μ+σZ) · χ²₂ = Z₁² + Z₂²
- **F non invertibile** ⇒ "F⁻¹ has no closed form → use accept-reject" (sezione 2). Segnale: x resta in 2 termini di tipo diverso (x − cos x, x·eˣ, x + log x, polinomio di grado ≥ 3, Φ)
- **"Which R function is correct?"**: `runif(n)` su (0,1), non (2,4) · F⁻¹ giusta (segno, esponente 1/b e non b, ordine delle operazioni) · U o 1−U entrambe ok

**"Given that it has already … (s), find P(total > c)"**
- Exp ⇒ assenza di memoria: P(X > c | X > s) = P(X > c − s) = e^(−(c−s)/β) · altre distribuzioni: P(X > c)/P(X > s)

---

## 🔴 2. Accept-reject

**Risposta da scrivere**
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
**Esempi svolti**
- 6x(1−x) con U(0,1) → c = 1.5 · 20x(1−x)³ con Beta(2,2) → c = 10/3 · (1+sin x)/(π+2) con U(0,π) → c = 2π/(π+2)
- f = C·e^(−x²/2) su [−2,2], g = 1/4 ⇒ f/g = 4C·e^(−x²/2), max in 0 ⇒ c = 4C ≈ 1.672 ⇒ accept if U ≤ e^(−X²/2)

**Varianti**
- **Una sola estrazione**: "repeat { X ~ g; U ~ U(0,1); if U ≤ f(X)/(c·g(X)) return X }"
- **"Which proposal is better?"**: calcola c per ogni g, scegli il **c più piccolo** (P(accept) = 1/c più alta); g con forma simile a f
- **"Is the R code correct?"**: X da g con il supporto giusto · U nuova a ogni tentativo · test U ≤ f(X)/(c·g(X)) con c e g · ripete finché accetta · restituisce X (non U)
- AR ≠ independence sampler: AR dà valori i.i.d. e se rifiuta riprova; l'independence sampler (MCMC, `wt.old`) dà valori dipendenti e se rifiuta ripete x[i−1]

⚠ denominatore senza g(x) o senza c

---

## 🔴 3. MC crude (integrali)

**Quale distribuzione usare?**
1. Il testo la nomina ("draws from Exp / N(0,1) / Pareto…") ⇒ quella → **D**
2. Intervallo finito, nessuna nominata ⇒ U(a,b) → **U**
3. Doppio/triplo su rettangolo ⇒ uniformi + volume → **M**
4. Intervallo infinito, nessuna nominata ⇒ cerca la densità nell'integrando: e^(−λx) su (0,∞) → Exp(rate λ) · e^(−x²/2) → N(0,1) · x^(−(b+1)) su (a,∞) → Pareto(a,b) · x^(α−1)e^(−x/β) → Gamma(α,β) → **D**
- Sempre: supporto ⊇ dominio dell'integrale; se il supporto è più grande ⇒ ·1(a < X < b)
- **f nel caso D** = densità della distribuzione nominata: se il testo la scrive, copiala; altrimenti formulario "Some continuous distributions" con i suoi parametri sostituiti. N(μ,σ²): 1° numero = μ, 2° = σ² ⇒ N(0,1): f(x) = e^(−x²/2)/√(2π)

**Risposta da scrivere** (g = funzione da integrare)
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
**"Based on the R output, give a point estimate and approx. 95% CI"** (R stampa `mean(...)` e `sd(...)` dei valori simulati)
```
k = quello che moltiplica la media nello stimatore (U: b−a · D: 1 · M: area/volume)
Stima puntuale:  θ̂ = k · mean
SE            :  SE = k · sd / √n          (n = numero di simulazioni nel codice)
95% CI        :  θ̂ ± 1.96 · SE             (90%: 1.645 · 99%: 2.576)
```
- Esempio: Â = 4/n·Σ 1(uᵢ,vᵢ), n = 10⁶, mean = 0.166846, sd = 0.3728385
  ⇒ Â = 4·0.166846 = **0.6674** · SE = 4·0.3728385/√10⁶ = 0.00149 · CI = 0.6674 ± 1.96·0.00149 = **[0.6645, 0.6703]**
- Ignora mediana e quantili dell'indicatore (valgono 0/1, inutili)
- **"It can be shown that Σ … ~ [distribuzione]. How many simulations so that SD(θ̂) < s₀?"** ⚠ usa la distribuzione del testo, NON la sd di R (con la sd di R viene un n diverso ✗)
  1. Y = Σ … ~ [distribuzione del testo] ⇒ Var(Y) dal formulario (con n dentro)
  2. θ̂ = k·Y/n ⇒ SD(θ̂) = (k/n)·√Var(Y)
  3. SD(θ̂) < s₀ ⇒ risolvi per n, arrotonda per eccesso
  Var(Y): Binomial(n,p) → n·p(1−p) · Poisson(nλ) → nλ · Gamma(n,β) → nβ² · se il testo dà un singolo valore Xᵢ ~ D: SD(θ̂) = k·√Var(D)/√n
  Esempio (Binomiale): k = 4, p = 1/6 ⇒ SD(Y) = √(5n/36), SD(Â) = 4·√(5/36)/√n < 0.01 ⇒ n > 16·(5/36)/0.0001 = 22222.2 ⇒ **n = 22223**

**Esempi svolti**
- U · ∫₀.₅²·⁵ f, f = 8x·e^(−4x²) ⇒ θ̂ = 2/n·Σ f(Uᵢ), SE = 2/100·√[1/9999·Σ(f(Uᵢ) − f̄)²] · su U(−1,1): k = 2 · su U(−π/2, π/2): k = π
- D · ∫₀^∞ e^(−2x)x^(3/2) dx, X ~ Exp(media 1/2), f = 2e^(−2x) ⇒ hᵢ = Xᵢ^(3/2)/2
- D · ∫₀^∞ ln(1+4x²)·e^(−x/2) dx, X ~ Exp(scala 2), f = ½e^(−x/2) ⇒ hᵢ = 2·ln(1+4Xᵢ²)
- D · ∫₋∞^∞ e^(−x²/2)cos x dx, X ~ N(0,1) ⇒ hᵢ = √(2π)·cos Xᵢ · solo su (−π/2, π/2) ⇒ hᵢ = √(2π)·cos Xᵢ·1(|Xᵢ| < π/2)
- D · ∫ₐ^∞ ln(x)/x^b dx, X ~ Pareto(a,b), f = b·aᵇ/x^(b+1) ⇒ hᵢ = Xᵢ·ln(Xᵢ)/(b·aᵇ)
- M · area ∫₋₁¹∫₋₁¹ 1(x,y) dx dy ⇒ Â = 4/n·Σ 1(Uᵢ,Vᵢ) · π ≈ 4·mean(1(Uᵢ²+Vᵢ² ≤ 1)), U,V ~ U(0,1)
- M misto: ∫₁³∫₋₂²∫₀^∞ x·e^(−x²/4)·g(y,z) dx dy dz ⇒ **separa** I = I₁·I₂
  - I₁ = ∫₀^∞ x·e^(−x²/4) dx (infinito ⇒ D): X ~ N(0, σ²=2) ⇒ hᵢ = 1(Xᵢ ≥ 0)·2√π·Xᵢ
  - I₂ = ∫₁³∫₋₂² g(y,z) dy dz (rettangolo ⇒ M): Yᵢ ~ U(−2,2), Zᵢ ~ U(1,3), area 8 ⇒ Î₂ = 8/n·Σ g(Yᵢ,Zᵢ)
  - uniformi + volume solo se **tutti** gli estremi sono finiti

**Domande collegate**
- "How large n so that SE ≤ s₀?" ⇒ n ≥ (k·s/s₀)², arrotonda per eccesso · k = moltiplicatore della media (U: b−a · D: 1 · M: area) · s: **se il testo dà una distribuzione, usa quella (ricetta sopra)**; solo altrimenti s = `sd(...)` stampata da R
- **"For n = …, calculate (approximately) P(θ̂ < c) without using the simulation results"** ⚠ la risposta è una probabilità, NON un intervallo · non usare NIENTE dell'output di R
  1. CLT: θ̂ è una somma ⇒ θ̂ ≈ Normale
  2. E(θ̂) = (k/n)·E(Y), E(Y) dal formulario (Binomial: np)
  3. SD(θ̂) = (k/n)·√Var(Y) (come nella ricetta "how many simulations"), con l'n del testo
  4. P(θ̂ < c) ≈ Φ((c − E(θ̂))/SD(θ̂)) → tabella normale standard   (P(θ̂ > c) = 1 − Φ(…))
  Esempio: n = 1000, c = 0.67 ⇒ E(Â) = (4/n)·(n/6) = 2/3 · SD(Â) = 4·√(5/36)/√1000 = 0.04714 ⇒ Φ((0.67 − 2/3)/0.04714) = Φ(0.0707) ≈ **0.5279**
  Φ(z) senza tabella (calcolatrice): **Φ(z) ≈ 1/(1 + e^(−1.6·z − 0.07·z³))** · Φ(−z) = 1 − Φ(z) · es. z = 0.0707 → 0.528
- **"Which algorithm has been implemented? Write the estimator."** (codice con `runif` + `k*mean(...)`) ⇒ "Crude MC" + stimatore, es. π̂ = 4/n · Σ 1(Xᵢ² + Yᵢ² ≤ 1), Xᵢ, Yᵢ ~ U(0,1)
- **"Do both R functions return a correct estimate?"** (stesso k, stessa condizione, stesse distribuzioni) ⇒ "Both correct, same estimator; one is a loop, the other vectorized ⇒ the vectorized one is faster." · "How can we improve it?" ⇒ antitetiche (sez. 5)

---

## 🔴 4. Importance sampling

**Risposta da scrivere**
```
θ = ∫ h(x) dx = ∫ [h(x)/f(x)]·f(x) dx = E_f[h(X)/f(X)],  f = given proposal, support of f ⊇ domain of h
Algorithm, n = 10000:
  1. Simulate X₁,…,Xₙ ~ f.
  2. θ̂_IS = 1/n · Σ h(Xᵢ)/f(Xᵢ) · 1(Xᵢ in the domain)
  3. SE = sd(h(Xᵢ)/f(Xᵢ)) / √n   (only if asked)
```
- Esempio: ∫₀¹ x(1−x)³ dx con Beta(2,2), f = 6x(1−x) ⇒ h/f = (1−x)²/6 ⇒ θ̂ = 1/n·Σ(1−Xᵢ)²/6
- **f** = densità della proposta nominata: formulario con i suoi parametri sostituiti (Gamma(α,β): f = x^(α−1)e^(−x/β) / (Γ(α)·β^α), α = shape, β = scale; i valori di Γ li dà il testo) — vedi "f nel caso D", sezione 3
- **"Does it work well?"**: yes if h/f ≈ constant (f shaped like |h|) and f has heavier tails than h (h/f bounded); no if h/f explodes in the tails or near 0 · h/f **costante** ⇒ "perfect (variance-free) estimator, variance 0" · h/f ∝ x (lineare) ⇒ "works well"
- **"Does it always reduce the variance?"**: **no**, a bad f can increase it (even infinite)
- **"Which R code is correct?"**: divide by the proposal density (`dgamma` with the same parameters as `rgamma`) and include the domain indicator
- ⚠ ratio upside down (f/h) · different parameters in r… and d… · missing indicator

---

## 🔴 5. Antitetiche

**Risposta da scrivere** (parentesi: U = uniformi su (a,b) · D = draws da f per inversione · M = doppio/rettangolo)
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
**Esempi svolti**
- U · ∫₀.₅²·⁵ f, f = Weibull(4,2) pdf: picco in 0.35 < 0.5 ⇒ f decrescente ⇒ Ũᵢ = 3 − Uᵢ, θ̂_AT = 2/n·Σᵢ₌₁⁵⁰⁰⁰ [f(Uᵢ) + f(3−Uᵢ)] ⇒ std minore (0.0062 vs 0.0070)
- D · Exp scala β: Xᵢ = −β·ln Uᵢ, X̃ᵢ = −β·ln(1−Uᵢ) · Pareto: Xᵢ = a(1−Uᵢ)^(−1/b), X̃ᵢ = a·Uᵢ^(−1/b)
- M · π: 4·(1/n)Σ[1(Uᵢ²+Vᵢ² ≤ 1) + 1((1−Uᵢ)²+(1−Vᵢ)² ≤ 1)]

**"Does it work?"**
- Sì se h è **monotona** sul dominio (controlla con h′: 0C, o dal grafico)
- No se h è **pari** (cos x, x², e^(−x²)) e X̃ = −X su intervallo simmetrico: h(X̃) = h(X), correlazione +1, varianza peggiore del crude
- Non monotona ⇒ "not guaranteed, since h is not monotone on the interval"

⚠ n coppie invece di n/2 · SE con √n · 1−U usato su U(a,b) invece di a+b−U

---

## 🔴 6. Bootstrap

**Risposta da scrivere**
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
- Dalla tabella dei quantili: var = sd²
- **"Is the R code correct?"**: `sample(data, size=length(data), replace=TRUE)` dentro il ciclo, poi lo stimatore
- ⚠ `replace=FALSE` · `size=nrep` · `mean` al posto dello stimatore · `sd` al posto di `var` nell'MSE · segno − sbagliato · `1-quantile`

---

## 🟠 7. CLT (l'enunciato è nel formulario)

- **Risposta da scrivere:** "X₁..Xₙ i.i.d. with finite μ, σ² ⇒ by the CLT, for large n: **X̄ ≈ N(μ, σ²/n)**". μ e σ² si calcolano da f
- **"P(X̄ < a) approximately"** ⇒ Φ((a − μ)/(σ/√n))
- **"How many measurements to be 95% sure the error is at most m?"** ⇒ 1.96·σ/√n ≤ m ⇒ **n ≥ (1.96·σ/m)²**, arrotonda per eccesso
- **Confidence interval** ⇒ X̄ ± z·σ/√n, z = 1.96 (95%), 1.645 (90%), 2.576 (99%)
- ⚠ Var(X̄) = σ²/n, non σ²

---

## 🟠 8. Likelihood, MLE, stimatori

- **"Show that the likelihood is …"** (spesso con costanti c₁, c₂ date: sono solo **nomi** per il prodotto e la somma che escono, non vanno calcolate) → write L(θ) = Πᵢ f(xᵢ; θ), then simplify the product:
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

## 🔴 9. Bayes: prior, posterior, condizionate

**"Show that the posterior / log-posterior kernel is …"** — risposta da scrivere:
```
p(θ | x) ∝ L(θ) · p(θ)          (log: log p(θ|x) = log L(θ) + log p(θ) + const)
1. Likelihood: L(θ) = Πᵢ f(xᵢ | θ), simplify (section 8)
2. Prior: write p(θ), drop the constants without θ
     Gamma(a, scale b): θ^(a−1)·e^(−θ/b)          Exp(rate λ): e^(−λθ)
     N(m, s²): e^(−(θ−m)²/(2s²))                  flat: 1(θ > 0)
     log σ² ~ N(0,1) (σ² ~ logN(0,1)): (σ²)⁻¹·e^(−(log σ²)²/2)
3. Multiply L·p, collect the same powers of θ and the exponents ⇒ the kernel in the text
```
- Exp scala θ, prior Gamma(a₀, b₀): θ⁻ⁿe^(−Σxᵢ/θ) · θ^(a₀−1)e^(−θ/b₀) ⇒ log = (a₀−n−1)·log θ − θ/b₀ − Σxᵢ/θ
- Exp(rate ab), a, b ~ Exp(3): (ab)ⁿe^(−abΣtᵢ) · 9e^(−3a−3b) ∝ (ab)ⁿ·e^(−abΣtᵢ)·e^(−3(a+b))
- Pareto(a,b), prior 1(a,b > 0): Π 1(a < xᵢ) = 1(a < min xᵢ) ⇒ bⁿa^(nb)/(Πxᵢ)^(b+1) · 1(a < x₍₁₎)·1(a,b > 0)
- Normale yᵢ ~ N(μ,σ²): L ∝ (σ²)^(−n/2)·e^(−S(μ)/(2σ²)), S(μ) = Σ(yᵢ−μ)² · prior μ|σ² ~ N(m₀, σ²/κ₀): (σ²)^(−1/2)·e^(−κ₀(μ−m₀)²/(2σ²))
  ⇒ joint (μ, σ²), con prior σ² ~ logN(0,1): potenze −n/2 −1/2 −1 = −(n+3)/2; gli esponenti si sommano ⇒ (σ²)^(−(n+3)/2)·e^(−[S(μ)+κ₀(μ−m₀)²]/(2σ²) − (log σ²)²/2)

**"Find the conditional posterior θ₁ | θ₂, x"** — risposta da scrivere:
```
1. From the joint posterior keep only the factors with θ₁ (everything else is a constant).
2. Take the log and write it as  a + b·log θ₁ + c·θ₁   or   a + b·θ₁ + c·θ₁².
3. Match (formulario §10 / hint in the text):
     a + b·log x + c·x   ⇒  x ~ Gamma(shape b+1, scale −1/c)
     a + b·x + c·x²      ⇒  x ~ N(mean −b/(2c), var −1/(2c))
     a + b·log x + c·log(1−x), 0<x<1 ⇒ x ~ Beta(b+1, c+1)   (non nel formulario)
4. No standard form (e.g. an extra (log σ²)² term) ⇒ "not a standard distribution, we cannot
   sample directly → use a Metropolis-Hastings step for it".
```
- log p(a | b, t) = n·log a − (bΣtᵢ + 3)·a ⇒ a | b, t ~ Gamma(n+1, 1/(bΣtᵢ + 3)) · stessa prior ⇒ b | a uguale con a al posto di b
- Pareto b | a, x ∝ bⁿ·e^(−b(Σln xᵢ − n ln a)) ⇒ Gamma(n+1, 1/(Σln xᵢ − n ln a)) · a | b, x ∝ a^(nb)·1(0 < a < x₍₁₎)
- Distribuzione Ψ definita nel testo ("show a | b ∝ Ψ(a | nb+1, x*)") ⇒ scrivi la tua condizionata (a^(nb)·1(0<a<x₍₁₎)) accanto alla sua densità e fai combaciare: esponente = α−1 ⇒ α = nb+1 · estremo dell'indicatore = β ⇒ β = x₍₁₎
- μ | σ², y ~ N(mₙ, σ²/κₙ), κₙ = n + κ₀, mₙ = (nȳ + κ₀m₀)/(n + κ₀)
- μ | σ², y: espandi, tieni solo i termini con μ: c = −(n+κ₀)/(2σ²) (coeff. di μ²), b = (nȳ+κ₀m₀)/σ² (coeff. di μ) ⇒ media −b/(2c) = mₙ, var −1/(2c) = σ²/κₙ
- σ² | μ, y: log p = −(n+3)/2·log σ² − K(μ)/(2σ²) − (log σ²)²/2, K(μ) = S(μ)+κ₀(μ−m₀)² ⇒ senza l'ultimo termine sarebbe una Inverse-Gamma; con esso non è standard ⇒ passo MH

**"Which R functions are valid log-target kernels?"**
- Valida se = log L + log prior a meno di costanti: `log(prod(f(x,θ)))` ok · `dgamma(θ, shape=a, scale=b, log=TRUE)` ok · (a−1)·log θ − θ/b ok
- ⚠ errore tipico: − log(θ/b) al posto di − θ/b · parametri del prior diversi da quelli del testo

**"E and Var of the prior"** → formulario (§1–2). Gamma(a, scale b): E = ab, Var = ab² (⚠ se b è rate: a/b, a/b²)

---

## 🔴 10. MCMC (definizioni nel formulario §9)

**"Which (MCMC) algorithm is this? Why?"** (dal codice) — trova l'indizio, copia la frase (tipo + proposta + α):
- **RWMH** — indizio: la proposta usa lo stato precedente: `rnorm(1, mean=x[t-1], sd=σ)` oppure `x[t-1] + σ*rnorm(1)` (2-dim: `x[,i-1] + rnorm(2)`), poi `alpha` + `runif` ⇒ "Random walk MH: the proposal θ* ~ N(θ_{t−1}, σ²) (σ = sd in the code; 2-dim: N(x_{t−1}, σ²I)) depends on the previous state and is symmetric, so α = min(1, g(θ*)/g(θ_{t−1}))"
- **Independence MH** — indizio: la proposta NON usa lo stato precedente (`rnorm(1, mean=5, sd=σ)`, `runif(1,-2,2)`) + pesi `wt.star/wt.old` ⇒ "Independence MH: the proposal θ* ~ r = N(5, σ²) does not depend on θ_{t−1}; weights w = g/r, α = min(1, w(θ*)/w(θ_{t−1}))"
- **Gibbs** — indizio: una componente alla volta, da una distribuzione con nome che usa l'altra componente (`rnorm(1, mean=rho*x2, …)`, `rgamma(1, …lambda[2]…)`), NIENTE `alpha`, NIENTE `runif` ⇒ "Gibbs sampler: each component is updated from its conditional distribution p(x₁|x₂), p(x₂|x₁); every draw is accepted"
- **iid (non MCMC)** — indizio: `chol(Σ)` e `x[,i] <- L %*% rnorm(2)`, nessuna estrazione usa la precedente ⇒ "iid simulation: xᵢ = L·z, z ~ N(0, I), LLᵀ = Σ ⇒ uncorrelated samples"
- **Target** (se chiesto): la funzione dentro `alpha` (`dnorm(·, mean=2, sd=2)` ⇒ N(2, 2²); `gx`/`lpost` ⇒ g) · `if(thetaStar>=1 & …)` ⇒ le proposte fuori dal supporto vengono rifiutate

**"Write down a proposal / derive the acceptance probability"** — scegli il caso dalla domanda (g = target kernel, θ* = proposta, θ_{t−1} = stato attuale):

**Caso A — la domanda dice "random walk" / "RWMH" / "write down a proposal for RWMH"**
```
Proposal:  θ* = θ_{t−1} + ε,  ε ~ N(0, σ²)   i.e.  θ* ~ N(θ_{t−1}, σ²)
           (symmetric proposal ⇒ q cancels — scrivila solo se chiedono α / perché α ha questa forma)
log α = min(0, log g(θ*) − log g(θ_{t−1}))
```

**Caso B — la domanda dice "log-scale proposal" / "log θ* = log θ_{t−1} + ε" / "lognormal" / θ > 0**
```
Proposal:  log θ* = log θ_{t−1} + ε,  ε ~ N(0, σ²)
           ⇒ θ* ~ Lognormal(log θ_{t−1}, σ²)  (only positive values, NOT symmetric)
log α = min(0, log g(θ*) − log g(θ_{t−1}) + log θ* − log θ_{t−1})
           (the extra term log θ* − log θ_{t−1} comes from the non-symmetric q)
```

**Caso C — la domanda dice "independent proposal" / "Gamma proposal centred near the MLE"**
```
Proposal:  θ* ~ Gamma(a_p, b_p), does NOT depend on θ_{t−1}
           mean = MLE:  a_p·b_p = θ̂     variance:  a_p·b_p² = Var(θ̂)
           (e.g. Var(θ̂) = θ̂²/n ⇒ a_p = n, b_p = θ̂/n)
log α = min(0, log g(θ*) − log q(θ*) − log g(θ_{t−1}) + log q(θ_{t−1}))
           (q = Gamma(a_p, b_p) density)
```

**Sempre, alla fine di ogni caso** (accept step):
```
Draw U ~ U(0,1): if log U < log α accept, θ_t = θ*;  otherwise θ_t = θ_{t−1}.
```
- Se la domanda non rientra in A, B o C, usa la formula generale: log α = min(0, log g(θ*) + log q(θ_{t−1}|θ*) − log g(θ_{t−1}) − log q(θ*|θ_{t−1}))
- **"Why is the RWMH not suitable?"**: θ > 0 ma la proposta normale può dare valori negativi ⇒ vanno rifiutati (α = 0), si rompe la simmetria e il mixing peggiora vicino a 0 ⇒ usa la proposta log-scale o una proposta solo positiva

**Performance: trace plot, acceptance rate, ESS**
- **"Difference between these plots?"** → first sentence: "The plots use different proposal variances σ²." Then one line per plot:
  - slow waves, moves slowly across the support ⇒ small σ²: (almost) all accepted but tiny steps, high autocorrelation
  - dense, fills the band, good mixing ⇒ good σ²
  - flat stretches, few points, stays still ⇒ large σ²: most proposals rejected, low acceptance
- σ piccolo ⇒ acceptance altissima, la catena si muove lentamente, ESS basso
- σ grande ⇒ pochi accettati, tratti piatti, acceptance bassa
- buono ⇒ RWMH con acceptance **20%–40%** e ESS alto · altri controlli: Geweke, Gelman-Rubin
- valore iniziale lontano ⇒ togli il burn-in (prime 100–200) o scegli un valore iniziale migliore · thinning riduce l'autocorrelazione
- **"Average of MCMC vs iid?"** ⇒ varianza più grande, perché i campioni sono autocorrelati positivamente
- **"Which algorithm do you prefer? Why?"** ⇒ dal migliore al peggiore: **iid** (uncorrelated samples) · **Gibbs** (conditionals known, no rejections) o **independence MH** con buona proposta (almost uncorrelated, high acceptance) · **RWMH** ultimo (correlated samples, only 20–40% accepted, rejects proposals outside the support) ⇒ risposta = il migliore tra quelli mostrati + il suo motivo

**"Describe the Gibbs sampler"** — risposta da scrivere:
```
State θ = (θ₁, θ₂). Choose initial values θ⁽⁰⁾ = (θ₁⁽⁰⁾, θ₂⁽⁰⁾). For t = 1, …, N:
  1. Draw θ₁⁽ᵗ⁾ ~ p(θ₁ | θ₂⁽ᵗ⁻¹⁾, x)     (its conditional posterior, e.g. Gamma(…))
  2. Draw θ₂⁽ᵗ⁾ ~ p(θ₂ | θ₁⁽ᵗ⁾, x)
  If a conditional is not standard, replace that draw with an MH step.
Output θ⁽¹⁾, …, θ⁽ᴺ⁾ (discard the burn-in).
```
- **"Three points for an efficient Gibbs sampler"**: blocks as large as possible (multivariate rather than many univariate updates) · keep strongly dependent variables in the same block (blocks as independent as possible) · if a block has no closed-form conditional, use efficient low-dimensional Metropolis updates

---

## 🟠 11. Processi stocastici

**Poisson omogeneo** — N(t) ~ Poisson(λt), E = Var = λt, tempi tra arrivi ~ Exp(rate λ)
```
Simulate on [0,T]:  1. t = 0   2. t ← t + E, E ~ Exp(rate λ)   3. if t < T record the event and go to 2, else stop
(or: N ~ Poisson(λT), then event times = sort(U₁,…,U_N), Uᵢ ~ U(0,T))
```
- Es.: λ = 6 al giorno, 30 giorni ⇒ T = 30, rate 6 (oppure N ~ Poisson(180))
- Codice R: `cumsum(rexp(·, λ))` fino a T, oppure `sort(runif(N, 0, T))`

**Poisson non omogeneo (thinning)** — Λ(t) = ∫₀ᵗ λ(s)ds, N(t) ~ Poisson(Λ(t))
```
λ_max ≥ max λ(t) on [0,T]
1. Simulate a homogeneous Poisson process with rate λ_max on [0,T] → times t₁, t₂, …
2. For each tᵢ: U ~ U(0,1), keep tᵢ if U ≤ λ(tᵢ)/λ_max
```
- λ(t) = at² + bt + c con a < 0 ⇒ max in t* = −b/(2a) (fuori da [0,T] ⇒ estremo) · E[N(T)] = Λ(T) = ∫₀ᵀ λ(t)dt
- Es.: λ = −30t² + 350t + 3950 ⇒ t* ≈ 5.83, λ_max ≈ 4971 · Λ(12) = −10·12³ + 175·12² + 3950·12 = 55320

**Random walk** ±1 con P(+1) = p, da 0: E(X_t) = t(2p−1), Var(X_t) = 4tp(1−p); p = 0.5 ⇒ E = 0, Var = t
- ⚠ se il codice parte da `x[1]=0`, x[T] ha T−1 passi
- Proprietà di Markov: il futuro dipende solo dallo stato presente

---

## 🟠 12. Histogram vs KDE

- In common: both estimate the unknown pdf from the sample · both used to present results · both have a smoothing parameter (number of bins / bandwidth h)
- Histogram: + simple, easy to interpret · − shape changes a lot with the bins, step function · KDE: + smooth, suited for continuous distributions · − more computationally intensive, depends on h
- Large h ⇒ oversmoothing, high bias, low variance · small h ⇒ wiggly, low bias, high variance · best = bias-variance trade-off (min MISE)
- Scott rule: assumes normal data (min MISE vs a normal) ⇒ not suited for skewed / heavy-tailed distributions (Pareto)

---

## 🟢 13. R

- `rnorm(n, mean, sd)`: sd, non varianza · `rexp(n, rate)` · `rgamma(n, shape, rate)`: il 3º argomento senza nome è il rate, `scale=` va scritto · `dgamma(..., log=TRUE)` = log della densità
- Catena di Markov: `prob=P[state,]` (riga dello stato corrente) · stazionaria π = πP con `%*%`
- Mistura: w = U < p, Y = w·X₁ + (1−w)·X₂ (non p·X₁ + (1−p)·X₂)
- Test di permutazione: `replace=FALSE` è **corretto**
- `rmvnorm`: `sigma` = matrice di covarianza · Cholesky `t(chol(Σ))` · AR(1) stazionario se |φ| < 1

---

**⚠ Scale vs rate (Gamma, Exp)** — guarda se il testo dice "scale" o "rate": stessa distribuzione, scale = 1/rate
- Il formulario usa la **scale** β: Gamma f = x^(α−1)e^(−x/β) / (Γ(α)β^α) · Exp f = (1/β)e^(−x/β)
- Il testo dà la **scale** ⇒ β = quel numero · il testo dà il **rate** ⇒ β = 1/rate (Exp(rate λ): f = λe^(−λx))
- Es. "rate 2" ⇒ β = 1/2 ⇒ e^(−2x) ✓ · usando β = 2 ⇒ e^(−x/2) ✗

**⚠ Supporto vs dominio** — **dominio** = intervallo dell'integrale (estremi di ∫ₐᵇ) · **supporto** = valori che la distribuzione f da cui simuli può generare (scritto accanto a f, es. "x > 0")
- supporto = dominio ⇒ niente indicatore · supporto **più grande** ⇒ moltiplica per 1(a < Xᵢ < b) · supporto **più piccolo** ⇒ quella f è sbagliata (non copre una parte dell'integrale)
- Es. ∫₁⁶ con Gamma (0,∞) ⇒ ·1(1 < Xᵢ < 6) · ∫₀¹ con Beta(2,2) [0,1] ⇒ niente · ∫₀⁴ con U(0,2) ✗
