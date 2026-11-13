# Foglio A4 per l'esame STA510

Cosa scrivere sull'unico foglio A4 ammesso. Va scritto **a mano**, direttamente sul foglio: niente stampe né fotocopie.
È un file di lavoro: lo aggiorniamo man mano che studi.

Legenda priorità: 🔴 sempre all'esame · 🟠 spesso · 🟢 se avanza spazio

---

## ❌ Da NON scrivere (è già nel formulario `tablesformulas.pdf`)

- pmf/pdf, E e Var di tutte le distribuzioni (§1–2) e il diagramma delle relazioni
- Algoritmo MH con α generale, definizioni di RWMH, independence sampler e Gibbs (§9)
- Regole per riconoscere le distribuzioni dal log-kernel: Normale, Esponenziale, Gamma, Beta, Inversa Gamma, Normale multivariata (§10)
- Formula di trasformazione g(y) = f(w(y))·|w′(y)| (§4)
- Combinazioni lineari, E e Var di somme (§4)
- MLE: Var(θ̂) ≈ 1/J(θ̂) e normalità asintotica (§5)
- Teorema del limite centrale, regole del logaritmo, derivate e integrali, funzione Gamma

---

## 🔴 1. Bootstrap

- Ciclo: `boot[i] <- stimatore(sample(data, size=length(data), replace=TRUE))`
- bias = mean(boot) − θ̂ · SE = sd(boot) · **MSE = var(boot) + bias²**
- Stima corretta per il bias: 2θ̂ − mean(boot)
- IC normale: θ̂ ± z₀.₉₇₅·sd(boot), con z = 1.96 (95%) e 1.645 (90%)
- IC percentile: (q₀.₀₂₅, q₀.₉₇₅) dei valori bootstrap
- IC basic: (2θ̂ − q₀.₉₇₅, 2θ̂ − q₀.₀₂₅)
- ⚠ R: `replace=FALSE`, `size=nrep`, `mean` al posto dello stimatore, `sd` al posto di `var` nell'MSE, segno −, `1-quantile`

## 🔴 2. Integrazione Monte Carlo

- Crude: I = ∫h(x)f(x)dx = E[h(X)] ⇒ Î = (1/n)Σh(Xᵢ), con Xᵢ ∼ f
- Su (a,b) con l'uniforme: Î = (b−a)·mean(h(Uᵢ)), con Uᵢ ∼ U(a,b)
- SE = sd(h(X))/√n · IC = Î ± 1.96·SE
- Importance sampling: Î = mean(h(Xᵢ)/f(Xᵢ)), con Xᵢ ∼ f e l'indicatore del dominio
  - funziona se f ha code più pesanti di h · ⚠ il rapporto rovesciato f/h è sbagliato
- Antitetiche: U e 1−U, su U(a,b) si usano x e **a+b−x**
  - riducono la varianza se h è monotona (correlazione negativa)
- Stima di π: 4·mean(U₁² + U₂² ≤ 1)

## 🟠 2b. Teorema del limite centrale: come si usa (l'enunciato è nel formulario)

- Risposta tipo: "X₁..Xₙ i.i.d., finite μ, σ² ⇒ by the CLT, for large n: **X̄ ≈ N(μ, σ²/n)**". μ e σ² si calcolano da f (h22 1f)
- Probabilità approssimata: P(X̄ < a) ≈ Φ((a − μ)/(σ/√n))  (v23 2c)
- Dimensione del campione per un margine m al 95%: 1.96·σ/√n ≤ m ⇒ **n ≥ (1.96·σ/m)²**, arrotonda per eccesso (h25 1c)
- Intervallo di confidenza: X̄ ± z·σ/√n, con z = 1.96 (95%), 1.645 (90%), 2.576 (99%)  (v25 1d)
- ⚠ la varianza di X̄ è σ²/n, non σ²

## 🔴 3. Accept-reject

- c = max f(x)/g(x), con g che copre il supporto di f
- Algoritmo: (1) X ∼ g (2) U ∼ U(0,1) (3) se U ≤ f(X)/(c·g(X)) accetta, altrimenti torna a (1)
- P(accettazione) = 1/c · numero atteso di iterazioni = c ⇒ un c più piccolo è meglio
- ⚠ R: denominatore senza g(x) o senza c

## 🔴 4. Inversione e cdf utili

- Algoritmo: (1) U ∼ U(0,1) (2) X = F⁻¹(U). Usare U o 1−U va bene uguale
- Esponenziale (scala β): F = 1 − e^(−x/β), F⁻¹(u) = −β·ln(1−u), che equivale a −β·ln u
- Weibull (formulario): F = 1 − e^(−αx^β), F⁻¹(u) = (−ln(1−u)/α)^(1/β)
- Pareto(a,b): F = 1 − (a/x)^b, F⁻¹(u) = a·(1−u)^(−1/b)
- Assenza di memoria: P(X > s+t | X > s) = P(X > t)
- ⚠ R: `runif(n,2,4)` al posto di U(0,1), esponente sbagliato

## 🔴 5. MCMC (solo quello che manca nel formulario)

- In scala log si calcola log α = min(0, log g(θ*) − log g(θ_{t−1})), poi si accetta se log U < log α
- Proposta su log θ: log θ* = log θ_{t−1} + ε, con ε ∼ N(0,σ²)
  - α = min(1, g(θ*)·θ* / (g(θ_{t−1})·θ_{t−1})), dove θ*/θ_{t−1} è lo Jacobiano
- Independence sampler con proposta Gamma centrata sull'MLE: si sceglie shape·scale = θ̂ e shape·scale² ≈ Var(θ̂)
- Riconoscerlo dal codice:
  - RW: `rnorm(1, mean=x[t-1])`
  - indep.: la proposta non usa `x[t-1]`, compaiono pesi `wt.old`/`wt.star`
  - Gibbs: nessun passo di accettazione
- Se si rifiuta: x[t] = x[t−1]
- Diagnostica:
  - acceptance rate troppo alto ⇒ passi piccoli · troppo basso ⇒ passi grandi
  - ESS basso ⇒ alta autocorrelazione
  - burn-in per eliminare la fase iniziale · thinning per ridurre l'autocorrelazione
  - trace plot: deve "mescolare" bene e restare stabile
- Gibbs efficiente: aggiornare a blocchi i parametri correlati, riparametrizzare, usare condizionate standard

## 🟠 6. Processi stocastici

- Poisson omogeneo: N(t) ∼ Poisson(λt), E = Var = λt; tempi tra arrivi ∼ Exp(rate λ)
- Simulazione:
  - (a) `cumsum(rexp(·, λ))` fino a T
  - (b) N ∼ Poisson(λT), poi tempi = `sort(runif(N, 0, T))`
- Poisson non omogeneo: Λ(t) = ∫₀ᵗ λ(s)ds, N(t) ∼ Poisson(Λ(t))
- Thinning: si simula un processo omogeneo con λ_max ≥ max λ(t) e si tiene il tempo t con probabilità λ(t)/λ_max
- Random walk ±1 con P(+1) = p, partendo da 0: E(X_t) = t(2p−1), Var(X_t) = 4tp(1−p). Con p = 0.5 la media è 0 e Var = t
  - ⚠ conta bene i passi: se il codice parte da `x[1]=0`, x[T] ha T−1 passi
- Proprietà di Markov: il futuro dipende solo dallo stato presente

## 🟠 7. MLE e stimatori

- Passi: L(θ) = Πf(xᵢ) → ℓ = log L → ℓ′(θ) = 0 → controlla ℓ″ < 0
- Bias = E(θ̂) − θ · MSE = Var + bias² · tra due stimatori è migliore quello con MSE più basso

## 🔴 7b. Schemi degli algoritmi a parole

(Mancano gli algoritmi MCMC, cioè Metropolis-Hastings e Gibbs: sono già scritti nel §9 del formulario.)

Regole: passi numerati · ogni variabile con la sua distribuzione e i parametri · formule esplicite · costanti calcolate · "ripeti n volte" · risultato finale.

- **Inversione:** 1) Uᵢ ∼ U(0,1) i.i.d., i = 1..n  2) Xᵢ = F⁻¹(Uᵢ) = [formula]  ⇒ X₁..Xₙ ∼ f
  - **Risposta completa da scrivere (inversione):**
    ```
    CDF:  F(x) = ∫_{a}^{x} f(t) dt = ...        (or: "using F(x) from (b)")
    Inverse: set u = F(x), solve for x  ⇒  F⁻¹(u) = ...
             check: F⁻¹(0) = lower end, F⁻¹(1) = upper end of support
    Algorithm (inverse transform), n = 10000:
      1. Simulate U₁,…,Uₙ i.i.d. ~ U(0,1).
      2. Compute Xᵢ = F⁻¹(Uᵢ) = ...   (numbers plugged in)
      3. Then X₁,…,Xₙ are i.i.d. with density f.
    Why: P(F⁻¹(U) ≤ x) = P(U ≤ F(x)) = F(x).
    ```
  - Varianti:
    - **funzione di più v.c.** (es. S = min(X₁,X₂,X₃)): simula ogni Xⱼ con la propria U, poi Sᵢ = g(X₁ᵢ,…)
    - **solo U(0,1) e N(0,1)**: usa una trasformazione (lognormale = e^(μ+σZ), χ²₂ = Z₁² + Z₂²)
    - **discreta**: X = min{x : F(x) ≥ U}
    - **F non invertibile**: "F⁻¹ has no closed form → use accept-reject"
      - come riconoscerlo: dopo aver tolto gli strati, x compare ancora in 2 termini di tipo diverso (x − cos x, x·eˣ, x + log x, polinomio di grado ≥ 3, Φ della Normale)
- **Accept-reject:** c = max f/g = [valore]. 1) X ∼ g  2) U ∼ U(0,1)  3) se U ≤ f(X)/(c·g(X)) accetta X, altrimenti torna a 1). Ripeti fino ad avere n valori accettati
  - **Risposta completa da scrivere (accept-reject):**
    ```
    Proposal: g(x) = ...  (support covers f, easy to simulate)
    Ratio: f(x)/g(x) = ... (simplify) → max at x = ... (f'=0 or endpoint)
           c = max f/g = ...   (check c ≥ 1)
    Algorithm (accept-reject):
      1. Simulate X ~ g.
      2. Simulate U ~ U(0,1), independent of X.
      3. If U ≤ f(X)/(c g(X)) = ... (simplified), accept X; else go to 1.
    Efficiency: P(accept) = 1/c, expected tries = c → smaller c is better.
    ```
  - Esempi: v24 6x(1−x) con U(0,1) → c = 1.5 · v25 20x(1−x)³ con Beta(2,2) → c = 10/3 · v26 (1+sin x)/(π+2) con U(0,π) → c = 2π/(π+2)
- **MC crude:** scrivi I = E_f[h(X)]  1) X₁..Xₙ ∼ f  2) Î = (1/n)Σh(Xᵢ)  3) SE = s_h/√n
- **Importance sampling:** scegli f con supporto ⊇ quello di h (es. Gamma). 1) Xᵢ ∼ f  2) Î = (1/n)Σ h(Xᵢ)/f(Xᵢ)
- **Antitetiche:** 1) U₁..U_{n/2} ∼ U(0,1)  2) Î = (1/n)Σ[h(Uᵢ) + h(1−Uᵢ)]  (su (a,b): xᵢ e a+b−xᵢ)
- **Bootstrap:** 1) per b = 1..B: x*_b = n estrazioni con reimmissione da x₁..xₙ  2) θ̂*_b = stimatore(x*_b)  3) da θ̂*₁..θ̂*_B: bias, SE, IC
- **Poisson omogeneo su [0,T]:** 1) t = 0  2) t ← t + E con E ∼ Exp(rate λ)  3) se t < T registra l'evento e torna a 2), altrimenti fermati
- **Poisson non omogeneo (thinning):** λ_max ≥ max λ(t). 1) simula un processo omogeneo con λ_max su [0,T]  2) per ogni tempo tᵢ: U ∼ U(0,1), tieni tᵢ se U ≤ λ(tᵢ)/λ_max
- **Stimare una probabilità per simulazione:** ripeti n volte la simulazione, P̂ = (numero di volte in cui l'evento si verifica)/n

## 🟢 8. Codice R che potrebbe uscire (mai uscito finora)

- Catena di Markov: `prob=P[state,]` (riga dello stato corrente) · stazionaria π = πP con `%*%`
- Mistura: w = U < p, Y = w·X₁ + (1−w)·X₂ (non p·X₁ + (1−p)·X₂)
- Test di permutazione: `replace=FALSE` è **corretto**
- `rmvnorm`: `sigma` è la matrice di covarianza · Cholesky `t(chol(Σ))`
- AR(1): stazionario se |φ| < 1

## 🟢 9. Funzioni R: parametrizzazione

- `rnorm(n, mean, sd)`: sd, non varianza · `rexp(n, rate)` · `rgamma(n, shape, rate)`: il 3º argomento senza nome è il rate, `scale=` va scritto esplicitamente
- `dgamma(..., log=TRUE)` restituisce il log della densità

---

## Da aggiungere / dubbi

- (vuoto: aggiungi qui mentre studi)

## Registro aggiornamenti

- 2026-11-12: prima versione, basata sull'analisi dei temi h22–v26 e sul formulario.
- 2026-11-12: aggiunta la sezione 7b con gli schemi degli algoritmi a parole.
- 2026-11-12: aggiunti gli schemi di risposta completi per inversione e accept-reject (7b) e la sezione 2b sul teorema del limite centrale.
