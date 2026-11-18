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
- Integrali del §7: ∫xⁿ, ∫1/x, ∫eᵃˣ = eᵃˣ/a, ∫x·eᵃˣ = eᵃˣ(ax−1)/a², ∫x²·eᵃˣ, **∫u′(x)·e^u(x) dx = e^u(x)**, integrazione per parti. Sul foglio solo il metodo (sezione 0)

---

## 🔴 0. Matematica (cheatsheet)

**A. Risolvere u = F(x) per x (inversione)**
- Ordine: isola il blocco con x → togli l'esponenziale con ln → togli la potenza con 1/β → dividi/moltiplica le costanti
- e^A = B ⇒ A = ln B · ln A = B ⇒ A = e^B
- x^β = c ⇒ elevo entrambi i lati a 1/β ⇒ x = c^(1/β), perché (x^β)^(1/β) = x^(β·1/β) = x (es. x² = 9 ⇒ x = 9^(1/2) = √9 = 3). Nessun ± se x ≥ 0
- (a/x)^b = c ⇒ a/x = c^(1/b) ⇒ x = a·c^(−1/b) · x^(−b) = 1/x^b · c^(1/2) = √c
- Segni: per u ∈ (0,1), ln(1−u) < 0 ⇒ −ln(1−u) > 0 (quindi la radice/potenza è ben definita)
- Esempio Weibull: 1 − e^(−αx^β) = u ⇒ e^(−αx^β) = 1−u ⇒ −αx^β = ln(1−u) ⇒ x^β = −ln(1−u)/α ⇒ x = (−ln(1−u)/α)^(1/β)

**B. Integrali (costante c, "proper density", cdf, E(X))**
- Proper density: f ≥ 0 e ∫ f = 1 sul supporto · c si trova da c·∫(…) = 1 · cdf: F(x) = ∫ₐˣ f(t)dt, controlla F(a) = 0 e F(b) = 1
- Polinomi: espandi e integra termine a termine
  - ∫₀¹ x(1−x) = 1/2 − 1/3 = 1/6 ⇒ c = 6 · F(x) = 6(x²/2 − x³/3) = x²(3 − 2x)
  - x(1−x)³ = x − 3x² + 3x³ − x⁴ ⇒ ∫₀¹ = 1/2 − 1 + 3/4 − 1/5 = 1/20 ⇒ c = 20
- Sostituzione: ∫ f(g(y))·g′(y) dy → **1)** u = g(y) (la parte "interna", spesso nell'esponente o nella parentesi) **2)** du = g′(y)dy: se manca una costante k, usa (resto)dy = du/k **3)** cambia gli estremi: y = a ⇒ u = g(a), y = x ⇒ u = g(x) **4)** integra in u e **non** riscrivere in y
  - Segnale: c'è una funzione e la sua derivata (es. αβ·y^(β−1)·e^(−αy^β)); è la regola ∫u′e^u = e^u del §7
  - Parentesi: ∫₀² (x−2)² dx, u = x−2 ⇒ ∫₋₂⁰ u² du = [u³/3]₋₂⁰ = 8/3 ⇒ k = 3/8
  - **Weibull:** u = αy^β, du = αβ·y^(β−1)dy, estremi 0 → αx^β ⇒ ∫₀^(αx^β) e^(−u)du = [−e^(−u)] = **1 − e^(−αx^β)**
  - β = 2: ∫ x·e^(−x²) dx, u = x², du = 2x dx ⇒ ½∫e^(−u)du
- Esponenziali: ∫₀ˣ λe^(−λy) dy = 1 − e^(−λx) (a = −λ nel §7) · ∫₀^∞ = 1
  - f = e^(x/4)/(4C), 0≤x≤4, C = e−1: ∫₀⁴ e^(x/4) dx con a = 1/4 ⇒ 4(e−1) = 4C ⇒ integra a 1 · E(X) con ∫x·eᵃˣ (a = 1/4): 16·[e^(x/4)·(x/4 − 1)]₀⁴ = 16 ⇒ E = 16/(4C) = 4/C
- Pareto (potenze): ∫ₐˣ b·aᵇ·t^(−b−1) dt = [−aᵇ·t^(−b)]ₐˣ = 1 − (a/x)^b
- ⚠ Errori tipici: 1/a dimenticato davanti a ∫eᵃˣ · segno di a negativo · estremi non cambiati · costante di du persa

**C. Derivate (max per c dell'accept-reject, monotonia per le antitetiche)**
- Massimo su [a,b]: risolvi h′(x) = 0, poi confronta con il valore agli estremi a e b
- Monotonia: segno di h′(x) sull'intervallo; se non cambia segno ⇒ monotona ⇒ le antitetiche funzionano
- Esempio Weibull(4,2): f = 8x·e^(−4x²), f′ = 8e^(−4x²)(1 − 8x²) = 0 ⇒ x = 1/√8 ≈ 0.35 (picco) ⇒ su [0.5, 2.5] decrescente

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
- SE = sd(h(X))/√n (versione Xᵢ ∼ f) · **SE = (b−a)·sd(h(Uᵢ))/√n** (versione uniforme) · IC = Î ± 1.96·SE
- Importance sampling: Î = mean(h(Xᵢ)/f(Xᵢ)), con Xᵢ ∼ f e l'indicatore del dominio
  - funziona se f ha code più pesanti di h · ⚠ il rapporto rovesciato f/h è sbagliato
- Antitetiche: U e 1−U, su U(a,b) si usano x e **a+b−x**
  - riducono la varianza se h è monotona (correlazione negativa)
- Stima di π: 4·mean(U₁² + U₂² ≤ 1)

## 🟠 2b. Teorema del limite centrale: come si usa (l'enunciato è nel formulario)

- Risposta tipo: "X₁..Xₙ i.i.d., finite μ, σ² ⇒ by the CLT, for large n: **X̄ ≈ N(μ, σ²/n)**". μ e σ² si calcolano da f
- Probabilità approssimata: P(X̄ < a) ≈ Φ((a − μ)/(σ/√n))
- Dimensione del campione per un margine m al 95%: 1.96·σ/√n ≤ m ⇒ **n ≥ (1.96·σ/m)²**, arrotonda per eccesso
- Intervallo di confidenza: X̄ ± z·σ/√n, con z = 1.96 (95%), 1.645 (90%), 2.576 (99%)
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
  - β = 1 ⇒ Exp(rate α) · hazard r(t) = f/(1−F) = αβ·t^(β−1): β>1 crescente (usura), β=1 costante, β<1 decrescente
  - Serie: min di Weibull(αᵢ,β) indipendenti, stesso β ⇒ Weibull(Σαᵢ, β) · parallelo: P(max ≤ t) = ΠFᵢ(t)
  - Antitetiche su Weibull(4,2) (∫ da 0.5 a 2.5): il picco è in x = 1/√8 ≈ 0.35 < 0.5, quindi su [0.5, 2.5] f è **monotona (decrescente)** ⇒ funziona (Cov(f(U),f(V)) < 0, std minore: 0.0062 vs 0.0070)
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

Scegli la riga dalla domanda:

- **"Show that the likelihood is …"** → write only L(θ) = Πᵢ f(xᵢ; θ), then simplify the product:
  - θ in every factor → θⁿ (θ⁻¹ → θ⁻ⁿ)
  - parts with only xᵢ → keep as Π(…) (= the constant c₁ in the text)
  - e^(…) in every factor → one e^(Σ…), because Π e^(aᵢ) = e^(Σaᵢ)
  - e.g. Π θ(1+3xᵢ^(1/2))e^(−θ(xᵢ+2xᵢ^(3/2))) = θⁿ · Π(1+3xᵢ^(1/2)) · e^(−θ Σ(xᵢ+2xᵢ^(3/2))) = θⁿc₁e^(−θc₂)
- **"Show / find the MLE"** → 1) L as above 2) ℓ = ln L (ln Π = Σ ln · ln θⁿ = n ln θ · ln e^a = a) 3) ℓ′(θ) = 0, solve for θ 4) check ℓ″ < 0
  - e.g. Exp scale θ: ℓ = −n ln θ − Σxᵢ/θ ⇒ θ̂ = x̄ · Pareto(a known): ℓ = n ln b + nb ln a − (b+1)Σ ln xᵢ ⇒ b̂ = n / Σ ln(xᵢ/a)
- **"Log-target / log posterior kernel"** → log L + log prior, drop constants without θ · Gamma prior (scale b): (a−1)·ln θ − θ/b
- **"Unbiased? / which estimator is better?"** → bias = E(θ̂) − θ (unbiased if 0) · MSE = Var + bias² · lower MSE = better

## 🔴 7b. Schemi degli algoritmi a parole

(Mancano gli algoritmi MCMC, cioè Metropolis-Hastings e Gibbs: sono già scritti nel §9 del formulario.)

Regole: passi numerati · ogni variabile con la sua distribuzione e i parametri · formule esplicite · costanti calcolate · "ripeti n volte" · risultato finale.

- **Inversione:** 1) Uᵢ ∼ U(0,1) i.i.d., i = 1..n  2) Xᵢ = F⁻¹(Uᵢ) = [formula]  ⇒ X₁..Xₙ ∼ f
  - **Risposta completa da scrivere (inversione):** le parentesi sono le 3 varianti (W = Weibull(α,β) · P = Pareto(a,b) · E = Exp scala β)
    ```
    CDF:  F(x) = ∫_{a}^{x} f(t) dt = ...        (or: "using F(x) from (b)")
          (W: 1 − e^(−αx^β)  |  P: 1 − (a/x)^b, x > a  |  E: 1 − e^(−x/β), x ≥ 0)
    Inverse: set u = F(x), solve for x  ⇒  F⁻¹(u) = ...
          (W: e^(−αx^β) = 1−u ⇒ −αx^β = ln(1−u) ⇒ x = ( −ln(1−u)/α )^(1/β)
           P: (a/x)^b = 1−u ⇒ a/x = (1−u)^(1/b) ⇒ x = a·(1−u)^(−1/b)
           E: e^(−x/β) = 1−u ⇒ −x/β = ln(1−u) ⇒ x = −β·ln(1−u)  ≡  −β·ln(u))
          check: F⁻¹(0) = lower end, F⁻¹(1) = upper end of support
    Algorithm (inverse transform), n = 10000:
      1. Simulate U₁,…,Uₙ i.i.d. ~ U(0,1).
      2. Compute Xᵢ = F⁻¹(Uᵢ) = ...
          (W: ( −ln(1−Uᵢ)/α )^(1/β)  |  P: a·(1−Uᵢ)^(−1/b)  |  E: −β·ln(Uᵢ))
      3. Then X₁,…,Xₙ are i.i.d. ∼ ...
          (W: Weibull(α,β)  |  P: Pareto(a,b)  |  E: Exp scala β, media β)
    Why: P(F⁻¹(U) ≤ x) = P(U ≤ F(x)) = F(x).
    ```
    - parametri simbolici (α, β, a, b): non sostituire numeri se il testo non li dà · 1−U ~ U(0,1), quindi U e 1−U vanno bene uguale
    - passaggi algebrici per risolvere u = F(x): sezione 0A
  - Varianti:
    - **funzione di più v.c.** (es. S = min(X₁,X₂,X₃)): simula ogni Xⱼ con la propria U, poi Sᵢ = g(X₁ᵢ,…)
    - **solo U(0,1) e N(0,1)**: usa una trasformazione (lognormale = e^(μ+σZ), χ²₂ = Z₁² + Z₂²)
    - **discreta**: X = min{x : F(x) ≥ U}
    - **F non invertibile**: "F⁻¹ has no closed form → use accept-reject"
      - come riconoscerlo: dopo aver tolto gli strati, x compare ancora in 2 termini di tipo diverso (x − cos x, x·eˣ, x + log x, polinomio di grado ≥ 3, Φ della Normale)
    - **quale funzione R è corretta?**: `runif(n)` su (0,1) e non (2,4) · formula F⁻¹ giusta (segno, esponente 1/b e non b, ordine delle operazioni) · U o 1−U entrambe ok
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
  - Esempi: 6x(1−x) con U(0,1) → c = 1.5 · 20x(1−x)³ con Beta(2,2) → c = 10/3 · (1+sin x)/(π+2) con U(0,π) → c = 2π/(π+2)
    - f = C·e^(−x²/2) su [−2,2], g = U(−2,2) = 1/4 ⇒ f/g = 4C·e^(−x²/2), max in x = 0 ⇒ c = 4C ≈ 1.672 ⇒ accetta se U ≤ e^(−X²/2)
  - Varianti:
    - **una sola estrazione**: "repeat { X ~ g; U ~ U(0,1); if U ≤ f(X)/(c·g(X)) return X }"
    - **quale proposta scegliere?**: calcola c per ogni g, scegli quella con **c più piccolo** (P(accetto) = 1/c più alta); g con forma simile a f
    - **il codice R è corretto?**: X da g con il supporto giusto · U nuova a ogni tentativo · test U ≤ f(X)/(c·g(X)) con c e g entrambi · ripete finché accetta · restituisce X (non U)
    - AR ≠ independence sampler: AR dà valori i.i.d. e se rifiuta riprova; l'independence sampler (MCMC, `wt.old`) dà valori dipendenti e se rifiuta ripete x[i−1]
- **MC crude:** scrivi I = E_f[h(X)]  1) X₁..Xₙ ∼ f  2) Î = (1/n)Σh(Xᵢ)  3) SE = s_h/√n
  - **Quale distribuzione?** 1) il testo la nomina ("draws from Exp/N(0,1)/Pareto…") ⇒ quella (D) · 2) intervallo finito, nessuna nominata ("crude MC") ⇒ U(a,b) (U) · 3) doppio/triplo su rettangolo ⇒ uniformi + volume (M) · 4) intervallo infinito, nessuna nominata ⇒ uniforme impossibile, cerca la densità nell'integrando: e^(−λx) su (0,∞) → Exp(rate λ) · e^(−x²/2) → N(0,1) · x^(−(b+1)) su (a,∞) → Pareto(a,b) · x^(α−1)e^(−x/β) → Gamma(α,β)
    - sempre: supporto ⊇ dominio dell'integrale; supporto più grande ⇒ ·1(a < X < b)
  - **Risposta completa da scrivere (MC crude):** le parentesi sono le 3 varianti (U = uniformi su (a,b) · D = draws da una distribuzione f data · M = integrale doppio/triplo)
    ```
    Integral: θ = ∫ g(x) dx  → riscrivilo come valore atteso
          (U: θ = (b−a)·E[g(U)], U ~ U(a,b)
           D: θ = ∫ [g(x)/f(x)]·f(x) dx = E_f[g(X)/f(X)]; se il supporto di f è più grande
              del dominio (a,b), moltiplica per l'indicatore 1(a < X < b)
           M: θ = (volume del rettangolo)·E[g(U,V,…)], U, V, … uniformi indipendenti)
    Algorithm (crude MC), n = 10000:
      1. Simulate (U: U₁,…,Uₙ ~ U(a,b) | D: X₁,…,Xₙ ~ f | M: Uᵢ ~ U(a₁,b₁), Vᵢ ~ U(a₂,b₂), indip.)
      2. Compute (U: g(Uᵢ) | D: g(Xᵢ)/f(Xᵢ) [·1(a<Xᵢ<b)] | M: g(Uᵢ,Vᵢ))
      3. Estimator:
          (U: θ̂_CMC = (b−a)/n · Σ g(Uᵢ)  with Uᵢ ~ U(a,b)
           D: θ̂_CMC = 1/n · Σ g(Xᵢ)/f(Xᵢ)  with Xᵢ ~ f
           M: θ̂_CMC = volume/n · Σ g(Uᵢ,Vᵢ))
          (g = la funzione da integrare)
    Standard error:
          (U: SE(θ̂_CMC) = (b−a)/√n · √[ 1/(n−1) · Σ (g(Uᵢ) − ḡ)² ],  ḡ = 1/n · Σ g(Uᵢ)
           D: SE(θ̂_CMC) = 1/√n · √[ 1/(n−1) · Σ (g(Xᵢ)/f(Xᵢ) − θ̂_CMC)² ]
           M: SE(θ̂_CMC) = volume/√n · √[ 1/(n−1) · Σ (g(Uᵢ,Vᵢ) − ḡ)² ],  ḡ = 1/n · Σ g(Uᵢ,Vᵢ))
          e.g. (0.5,2.5), n=10000: SE = 2/100 · √[ 1/9999 · Σ (f(Uᵢ) − f̄)² ],  f̄ = 1/n · Σ f(Uᵢ)
          R: (b−a)*sd(g(u))/sqrt(n)
    Why: law of large numbers, the sample mean → the expected value ⇒ θ̂_CMC → θ.
    ```
    - Trucco per D: scegli/riconosci f che "compare" nell'integrando (stesso e^(…)); il resto è h
    - Esempi:
      - U · ∫₀.₅²·⁵ f, f(x) = 8x·e^(−4x²) (Weibull(4,2)), k = 2 ⇒ θ̂_CMC = 2/n·Σ f(Uᵢ) · su U(−1,1): k = 2 · su U(−π/2, π/2): k = π
      - D · ∫₀^∞ e^(−2x)x^(3/2) dx, X ~ Exp(media 1/2), f = 2e^(−2x) ⇒ hᵢ = Xᵢ^(3/2)/2
      - D · ∫₀^∞ ln(1+4x²)·e^(−x/2) dx, X ~ Exp(scala 2), f = ½e^(−x/2) ⇒ hᵢ = 2·ln(1+4Xᵢ²)
      - D · ∫₋∞^∞ e^(−x²/2)cos x dx, X ~ N(0,1), f = e^(−x²/2)/√(2π) ⇒ hᵢ = √(2π)·cos Xᵢ · su (−π/2, π/2) ⇒ hᵢ = √(2π)·cos Xᵢ·1(|Xᵢ| < π/2)
      - D · ∫ₐ^∞ ln(x)/x^b dx, X ~ Pareto(a,b), f = b·aᵇ/x^(b+1) ⇒ hᵢ = Xᵢ·ln(Xᵢ)/(b·aᵇ)
      - M · area: A = ∫₋₁¹∫₋₁¹ 1(x,y) dx dy, volume = 2·2 = 4 ⇒ Â = 4/n·Σ 1(uᵢ,vᵢ) · π: 4·mean(1(Uᵢ²+Vᵢ² ≤ 1)), U,V ~ U(0,1)
      - M misto: I = ∫₁³∫₋₂²∫₀^∞ x·e^(−x²/4)·g(y,z) dx dy dz ⇒ **separa** I = I₁·I₂ (la parte in x non dipende da y, z)
        - I₁ = ∫₀^∞ x·e^(−x²/4) dx (infinito ⇒ D): X ~ N(0, σ²=2), f = e^(−x²/4)/(2√π) ⇒ hᵢ = 1(Xᵢ ≥ 0)·2√π·Xᵢ
        - I₂ = ∫₁³∫₋₂² g(y,z) dy dz (rettangolo ⇒ M): Yᵢ ~ U(−2,2), Zᵢ ~ U(1,3), area 4·2 = 8 ⇒ Î₂ = 8/n·Σ g(Yᵢ,Zᵢ)
        - Î = Î₁·Î₂ · regola: uniformi + volume solo se **tutti** gli estremi sono finiti
    - Domande collegate: **n** perché SE ≤ s₀ ⇒ n ≥ (k·s/s₀)² · **P(θ̂ < c) senza simulare**: CLT, θ̂ ≈ N(θ, SE²) ⇒ Φ((c − θ)/SE) · IC 95%: θ̂ ± 1.96·SE
- **Importance sampling:** I = ∫ h(x)dx = E_f[h(X)/f(X)], f = proposta data dal testo (Gamma, Beta, …), supporto di f ⊇ dominio di h. 1) X₁..Xₙ ∼ f  2) Î = (1/n)Σ h(Xᵢ)/f(Xᵢ)·1(Xᵢ nel dominio)  3) SE = s/√n
  - Esempio: ∫₀¹ x(1−x)³ dx con Beta(2,2), f = 6x(1−x) ⇒ h/f = (1−x)²/6 ⇒ Î = (1/n)Σ (1−Xᵢ)²/6
  - **Funziona bene?**: sì se h/f è circa costante (f con forma simile a |h|) e f ha code più pesanti di h (h/f limitato); no se h/f esplode nelle code o vicino a 0
  - **Riduce sempre la varianza?**: **no**, con f scelta male la varianza aumenta (può anche essere infinita)
  - **Quale codice R è corretto?**: divide per la densità della proposta (`dgamma` con gli stessi parametri di `rgamma`) e ha l'indicatore del dominio · ⚠ rapporto f/h rovesciato, parametri diversi tra r e d, indicatore mancante
- **Antitetiche:** ⚠ si comincia **sempre** dicendo che h è monotona (dal grafico o con h′, sezione 0C), anche se il testo non lo chiede. Coppie negativamente correlate, n valutazioni = n/2 coppie. 1) U₁..U_{n/2} ∼ U(0,1)  2) per ogni Uᵢ: Xᵢ e l'antitetica X̃ᵢ  3) Î = k·(1/n)Σᵢ[h(Xᵢ) + h(X̃ᵢ)]
  - **Risposta completa da scrivere (antitetiche):** le parentesi sono le 3 varianti, come nel MC crude (U = uniformi su (a,b) · D = draws da f per inversione · M = doppio/rettangolo)
    ```
    0. FIRST SENTENCE (always):
       "h is monotone on (a,b) [from the plot | h′(x) = ... = 0 ⇔ x = ..., outside (a,b)]
        ⇒ we can improve crude MC with antithetic pairs."
    Idea: replace independent draws with negatively correlated pairs (X, X̃),
          X̃ with the same distribution as X ⇒ estimator still unbiased, smaller variance.
    Algorithm (antithetic), n = 10000 evaluations = m = n/2 = 5000 pairs:
      1. Simulate U₁,…,U_m i.i.d.
          (U: ~ U(a,b)  |  D: ~ U(0,1)  |  M: Uᵢ ~ U(a₁,b₁), Vᵢ ~ U(a₂,b₂), indip.)
      2. Antithetic partner of each draw:
          (U: Ũᵢ = a + b − Uᵢ   [U(0,1): 1−Uᵢ · U(−c,c): −Uᵢ]
           D: Xᵢ = F⁻¹(Uᵢ),  X̃ᵢ = F⁻¹(1 − Uᵢ)
           M: (Uᵢ, Vᵢ) and (a₁+b₁−Uᵢ, a₂+b₂−Vᵢ))
      3. Estimator:
          θ̂_AT = k/n · Σᵢ₌₁^{n/2} [ h(Xᵢ) + h(X̃ᵢ) ]
          (U: k = b−a  |  D: k = 1  |  M: k = volume)
          (U, M: h = g  |  D: h = g/f [·1(a<X<b)])
      4. Only if asked, standard error: Yᵢ = [h(Xᵢ) + h(X̃ᵢ)]/2,
          SE(θ̂_AT) = k · sd(Y₁,…,Y_{n/2}) / √(n/2)
    Why it improves crude MC (same number n of evaluations of h):
      Var(Yᵢ) = σ²/2 · (1 + ρ),  σ² = Var(h(X)),  ρ = Corr(h(X), h(X̃))
      ⇒ Var(θ̂_AT) = k²σ²(1+ρ)/n   vs   Var(θ̂_CMC) = k²σ²/n
      ⇒ better iff ρ < 0, guaranteed if h is monotone on the domain
         (h′ does not change sign; X̃ is a decreasing function of X).
    ```
    - Esempio (U): ∫₀.₅²·⁵ f, f = Weibull(4,2) pdf ⇒ Ũᵢ = 3 − Uᵢ, θ̂_AT = 2/n·Σᵢ₌₁⁵⁰⁰⁰ [f(Uᵢ) + f(3−Uᵢ)] · f monotona su [0.5, 2.5] (picco in 0.35) ⇒ ρ < 0 ⇒ migliora
    - ⚠ errori tipici: n coppie invece di n/2 · SE con √n o sd sugli n valori singoli · partner 1−U usato su U(a,b) invece di a+b−U
  - Coppie (k come nel MC crude): (U(a,b): X̃ = a+b−X, k = b−a | U(−c,c): X̃ = −X | draws da f per inversione: Xᵢ = F⁻¹(Uᵢ), X̃ᵢ = F⁻¹(1−Uᵢ), h = g/f, k = 1 | 2D: (Uᵢ,Vᵢ) e (1−Uᵢ, 1−Vᵢ))
  - Exp scala β: Xᵢ = −β·ln Uᵢ, X̃ᵢ = −β·ln(1−Uᵢ) · Pareto: Xᵢ = a(1−Uᵢ)^(−1/b), X̃ᵢ = a·Uᵢ^(−1/b) · π: 4·(1/n)Σ[1(Uᵢ²+Vᵢ² ≤ 1) + 1((1−Uᵢ)²+(1−Vᵢ)² ≤ 1)]
  - **Funziona?** sì se h è **monotona** sul dominio ⇒ Cov(h(X), h(X̃)) < 0 (controlla con h′ o il grafico, sezione 0C). No se h è **pari** e X̃ = −X su intervallo simmetrico: h(X̃) = h(X), correlazione +1, varianza peggiore del crude
- **Bootstrap:** 1) per b = 1..B: x*_b = n estrazioni con reimmissione da x₁..xₙ  2) θ̂*_b = stimatore(x*_b)  3) da θ̂*₁..θ̂*_B: bias, SE, IC
  - Dalla tabella dei quantili: 95% percentile = (q₀.₀₂₅, q₀.₉₇₅) · 90% = (q₀.₀₅, q₀.₉₅) · var = sd² · MSE = var + bias²
- **Poisson omogeneo su [0,T]:** 1) t = 0  2) t ← t + E con E ∼ Exp(rate λ)  3) se t < T registra l'evento e torna a 2), altrimenti fermati
  - Es.: λ = 6 al giorno, 30 giorni ⇒ T = 30, rate 6 (oppure N ~ Poisson(180), tempi = sort(U(0,30)))
- **Poisson non omogeneo (thinning):** λ_max ≥ max λ(t). 1) simula un processo omogeneo con λ_max su [0,T]  2) per ogni tempo tᵢ: U ∼ U(0,1), tieni tᵢ se U ≤ λ(tᵢ)/λ_max
  - Costanti: λ(t) = at² + bt + c con a < 0 ⇒ max in t* = −b/(2a) (se fuori da [0,T], prendi l'estremo) · E[N(T)] = Λ(T) = ∫₀ᵀ λ(t)dt
  - Es.: λ = −30t² + 350t + 3950 ⇒ t* ≈ 5.83, λ_max ≈ 4971 · in un anno (t in mesi, 0–12): Λ(12) = −10·12³ + 175·12² + 3950·12 = 55320
- **Stimare probabilità / valori attesi per simulazione:** ripeti n volte la simulazione ⇒ P̂ = (numero di volte in cui l'evento si verifica)/n · Ê = media dei valori simulati

## 🟠 7c. Histogram vs KDE

- In common: both estimate the unknown pdf from the sample · both used to present results · both have a smoothing parameter (number of bins / bandwidth h)
- Histogram: + simple, easy to interpret · − shape changes a lot with the bins, step function · KDE: + smooth, suited for continuous distributions · − more computationally intensive, depends on h
- Large h ⇒ oversmoothing, high bias, low variance · small h ⇒ wiggly, low bias, high variance · best = bias-variance trade-off (min MISE)
- Scott rule: assumes normal data (min MISE vs a normal) ⇒ not suited for skewed / heavy-tailed distributions (Pareto)

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
- 2026-11-14: sezione 4, aggiunte le proprietà della Weibull (hazard, β=1, min in serie, antitetiche h23). Aggiunta la sezione 4b (integrali per sostituzione ed esponenziali, con h22 e Weibull) e una voce nell'elenco "Da NON scrivere". Corretto lo stesso giorno: in h23 l'integrale è su [0.5, 2.5], dove la pdf è monotona, quindi le antitetiche funzionano (prima era scritto il contrario).
- 2026-11-14: nuova sezione 0 "Matematica" (risolvere per x, integrali, derivate); la vecchia 4b e la regola dell'esponente in 7b sono state spostate lì.
- 2026-11-14: 7b, MC crude con 3 varianti (U, D, M); poi controllate tutte le varianti dei temi h22–v26 e aggiunte: AR (una estrazione, confronto proposte, codice R, v23 3a), inversione (codice R), MC (h24 g, n necessario, P via CLT), IS (esempio v25, funziona?, riduce sempre?, codice R), antitetiche (coppie per non uniformi e 2D, quando falliscono), bootstrap (90%), Poisson (costanti h24).
- 2026-11-16: 7b, aggiunto il modello di risposta completa per le antitetiche (varianti U/D/M, SE su n/2 coppie, Var con ρ, esempio h23). Aggiunto il passo 0: dire per prima cosa che h è monotona (la soluzione h23 2d comincia così).
- 2026-11-16: nuova sezione 7c, istogramma vs KDE e regola di Scott (h23 f, h24 f).
- 2026-11-16: sezione 7, aggiunte le regole sui prodotti per L(θ) e log-target = log L + log prior (h23 h, i).
- 2026-11-16: tolti dal foglio tutti i riferimenti agli esami (h23 h, v24 3a, …): restano solo gli esempi svolti. (Restano solo qui nel registro, che non va copiato sul foglio.)
