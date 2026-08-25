# STA510 – Roadmap per l'esame

Basato sull'analisi di 6 esami passati (h22, v23, h23, h24, v26, h25) e sul materiale del
corso (Lecture Notes, Exercises, R-examples). Gli argomenti sono ordinati per priorità,
in base a quanto spesso compaiono negli esami.

Legenda materiale: LN = Lecture Notes, Ex = Exercises, R = R-examples

---

## 🔴 Priorità massima (compare in QUASI OGNI esame)

### 1. Variabili casuali continue: pdf, cdf, momenti
- Verificare che f(x) sia una densità propria (integrale = 1, trovare costante c)
- Calcolare E(X), Var(X), E(g(X)) per trasformazioni g
- Derivare la cdf F(x) dalla pdf e usarla per calcolare probabilità P(X > a), P(a < X < b)
- Materiale: LN `chap2_part1`, `chap2_part2`, Ex `exercise_set0/1`

### 2. Simulazione: metodo della trasformazione inversa (inverse transform)
- Derivare F⁻¹(u) analiticamente
- Scrivere l'algoritmo a parole (non solo codice!): 1) simula U~Unif(0,1), 2) X = F⁻¹(U)
- **Trabocchetto ricorrente**: dato codice R con varie funzioni "candidate", riconoscere
  quale implementa correttamente F⁻¹(U) (occhio a errori di segno, di intervallo runif,
  o formula sbagliata) — è successo in h22, h23, h24, v23
- Distribuzioni tipiche: custom pdf, Weibull, Pareto, Exponential
- Materiale: LN `chap3_part1`, Ex `exercise_set1`

### 3. Accept-Reject (AR) method
- Scegliere una proposal g(x) e trovare la costante envelope c = max f(x)/g(x)
- Scrivere l'algoritmo (pseudocodice): proponi X~g, accetta con prob. f(X)/(c·g(X))
- Confrontare efficienza di proposal diverse (quale c è più piccolo → meno rigetti)
- Riconoscere se un'implementazione R è corretta o ha bug (confronto denominatore
  costante vs densità proposal — errore classico in h22 problema 1e)
- Materiale: LN `chap3_part2`, Ex `exercise_set1`, R `acceptance-rejection_examples.R`, `AR-example.R`

### 4. Metodi Monte Carlo per integrali
- **Crude MC**: scrivere I come E[g(X)] rispetto a una densità nota, stimatore = media di g(Xᵢ)
- **MC generalizzato** (dominio non standard, es. integrali impropri): scegliere la
  distribuzione ausiliaria giusta (Exponential, Gamma, Uniform, Normal, Laplace...)
- **Importance sampling**: scegliere proposal, capire quando funziona bene (code della
  proposal più pesanti dell'integrando) vs male
- **Antithetic variables**: costruire lo stimatore con U e 1-U (o -X e X), capire quando
  riduce la varianza (funzione monotona) e quando no
- Errore standard dello stimatore MC: sd(g(X))/√n
- Materiale: LN `chap4_part1`, `chap4_part2`, Ex `exercise_set2`, R `MC_integration_examples.R`,
  `Variance_reduction.R`, `importance_sampling.R`

### 5. Bootstrap
- Bootstrap non parametrico: ricampionare con reinserimento dai dati osservati
- Stimare bias, standard error (SE), MSE di uno stimatore
- Bias-corrected estimate
- Intervalli di confidenza bootstrap: **normal** (con SE bootstrap), **percentile**,
  **basic** — sapere le tre formule e le differenze
- Materiale: LN `chap6_part1`, `chap6_part2`, Ex `exercise_set3`, R `bootstrap_examples.R`

### 6. MCMC — Metropolis-Hastings
- Riconoscere il tipo di algoritmo da codice R:
  - **Independence sampler** (proposal non dipende dallo stato corrente, uso di pesi
    wt.old/wt.star tipo importance sampling)
  - **Random walk MH** (proposal = stato corrente + rumore simmetrico, es. rnorm(mean=x[t-1]))
- Scrivere la probabilità di accettazione α = min(1, target(x*)/target(x_{t-1}))
- Target/stationary distribution: riconoscerla dal codice
- Proposal su scala log (log(θ*) = log(θ_{t-1}) + ε) — occhio allo Jacobiano nell'accettazione
- Proposal Gamma indipendente centrata sulla MLE
- Diagnostica: traceplot, **acceptance rate** (troppo basso/alto = problema), **effective
  sample size (ESS)**, burn-in, thinning, confronto tra catene con step size diversi
- Materiale: LN `chap11_part1/2/3`, R `mcmc_1.R`, `mcmc_2.R`, `mcmc_3.R`

### 7. Statistica Bayesiana
- Costruire la funzione di verosimiglianza (likelihood) L(θ) da dati iid
- Derivare il **kernel della posteriore** ∝ likelihood × prior (in scala log!)
- Prior coniugate classiche: Gamma-Exponential, Gamma-Poisson
- Trovare media/varianza della prior e della posteriore quando è in forma standard
- Casi non coniugati → serve MCMC (RWMH o Gibbs) per campionare dalla posteriore
- **Gibbs sampler**: derivare le full conditional (es. modello Normale-Normale-LogNormale
  per μ e σ²), descrivere l'algoritmo
- Materiale: LN `bayes.pdf`, `chap12.pdf`, Ex `exercise_set5/6`

---

## 🟠 Priorità alta (compare in più esami)

### 8. Processi di Poisson
- Processo di Poisson omogeneo: distribuzione di N(t), tempi di interarrivo ~ Exponential(λ)
- Tempo del k-esimo evento ~ Gamma(k, λ)
- Processo di Poisson **non omogeneo**: intensità λ(t) variabile nel tempo
  - Interpretazione di λ(t)
  - Simulazione tramite **thinning** (accept-reject sui tempi di arrivo di un Poisson
    omogeneo con tasso λ_max)
- Calcolo di probabilità condizionate (es. P(N(0.1)=0 | N(1)=8))
- Materiale: LN `chap8.pdf`, Ex `exercise_set4`, R `rain.R`

### 9. Massima verosimiglianza (MLE)
- Costruire L(θ) e log-likelihood da un campione iid
- Derivare l'MLE analiticamente (derivata = 0)
- Verificare se è non distorto (unbiased), calcolare la sua varianza
- Determinare la dimensione campionaria n necessaria per una precisione data (margine
  di errore con livello di confidenza)
- Materiale: LN `chap6_part1`, Ex `exercise_set3`

### 10. Kernel Density Estimation (KDE) vs istogramma
- Pro/contro di istogramma vs KDE, cosa hanno in comune
- Effetto della bandwidth (bassa = overfitting/rumore, alta = oversmoothing)
- Regole automatiche di bin-width (es. regola di Scott) — quando è appropriata
- Materiale: LN `chap6_part2`, R `KDE.R`

### 11. Sistemi affidabilistici (reliability) e distribuzioni di vite
- Sistemi in serie/parallelo: S = min(X₁,...,Xₙ) o max(X₁,...,Xₙ)
- Relazione tra Exponential e Weibull (caso speciale)
- Simulare il tempo di vita di un sistema combinando distribuzioni dei componenti
- Materiale: R `robot_system.R`, `production_profile.R`

---

## 🟡 Priorità media (temi ricorrenti ma meno centrali)

### 12. Teorema del limite centrale & intervalli di confidenza
- Distribuzione approssimata di X̄ per n grande
- Costruire IC al 95% per una media/funzione della media
- **Trabocchetto classico**: riconoscere quale IC tra tante varianti scritte in R è
  corretto (stimatore giusto abbinato al giusto errore standard) — compare in h22

### 13. Simulazione di variabili multivariate / correlate
- Simulazione da normale multivariata: decomposizione di **Cholesky**
- Confronto tra metodi: Cholesky (diretto/iid) vs Gibbs sampler vs MH random walk
  per generare la stessa distribuzione target — capire pro/contro (efficienza,
  autocorrelazione, iid vs catena)
- Materiale: R `bivariate_normal.R`, `multivariate_normal_example.R`

### 14. Catene di Markov e processi stocastici
- Random walk semplice: è un processo di Markov? Perché?
- Spazio degli stati, distribuzione stazionaria (esiste o no e perché)
- Media e varianza di un random walk nel tempo
- Materiale: LN `markov_proc.pdf`, R `Markov.R`

### 15. Simulazione tramite composizione/trasformazione di distribuzioni note
- Generare Lognormal da Normal (trasformazione esponenziale)
- Generare χ² da Normal (somma di quadrati)
- Combinazioni lineari di v.a. simulate (es. Z = aX + bY) e stima di E(Z), P(Z<c) via MC
- Materiale: R `sums_mixtures_examples.R`, `inverse_transform_examples_poiss.R`

---

## 🟢 Priorità bassa (comparso una volta, ma utile per capire i concetti)

- Stima di π con metodo Monte Carlo (Buffon/cerchio) — buon esempio "facile" di stimatore MC
- Bootstrap con più tipi di intervalli confrontati insieme (normal/basic/percentile) sullo stesso dataset
- Sampling importance/MC "generalizzato" per integrali su domini infiniti con più variabili

Materiale di riferimento generale: LN `intro.pdf`, `Rintro.pdf`, formula sheet in
`formula_sheet\tablesformulas.pdf` e `tablesformulas_2.pdf` (portali all'esame se
permessi — controllare regole aggiornate, in alcuni esami è permesso un foglio A4 di
appunti scritti a mano invece delle formule).

---

## Come usare questa roadmap

1. Per ogni argomento 🔴, rifai **almeno 2 esercizi delle vecchie prove d'esame**
   (`old exams\`) senza guardare la soluzione, poi controlla con `..._solution.pdf`.
2. Scrivi a mano (non solo a mente) gli algoritmi in pseudocodice: molte domande
   d'esame chiedono esplicitamente "con parole e formule, non codice".
3. Per le domande "quale di queste funzioni R è corretta/sbagliata" (ricorrenti!):
   allenati a leggere codice R velocemente e a controllare limiti di integrazione,
   parametri di `runif`/`rnorm`/`rgamma`, e coerenza tra formula matematica e codice.
4. Per MCMC, esercitati a riconoscere al volo: independence sampler vs random walk MH
   vs Gibbs, e a valutare la qualità di una catena da traceplot + acceptance rate + ESS.
5. Ripassa le relazioni tra distribuzioni (Exponential↔Weibull↔Gamma, Normal↔Lognormal↔χ²)
   perché vengono sfruttate di continuo per semplificare la simulazione.
