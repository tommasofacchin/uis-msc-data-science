# STA510 – Guida completa per l'esame

Guida di studio costruita su: Lecture Notes del corso, formula sheet (`tablesformulas.pdf`) ed esami passati con soluzioni (h22 → v26).
Per ogni argomento trovi: **idea**, **formule chiave**, **algoritmo** (scritto come lo vuole l'esame: *"with words and formulas, not code"*), un **esempio tipo esame** e le **trappole** ricorrenti.

> I termini tecnici sono lasciati in inglese perché l'esame è in inglese.
> Le formule usano la notazione LaTeX (`$...$`): in VS Code apri l'anteprima Markdown con `Ctrl+Shift+V`.

---

## Indice

0. [Formato dell'esame e cosa c'è già nel formula sheet](#0-formato-dellesame-e-cosa-cè-già-nel-formula-sheet)
1. [Variabili casuali continue: pdf, cdf, momenti](#1-variabili-casuali-continue-pdf-cdf-momenti)
2. [Stimatori, MLE, CLT e intervalli di confidenza](#2-stimatori-mle-clt-e-intervalli-di-confidenza)
3. [Inverse transform method](#3-inverse-transform-method)
4. [Accept–Reject method](#4-acceptreject-method)
5. [Trasformazioni, somme, misture, normale multivariata](#5-trasformazioni-somme-misture-normale-multivariata)
6. [Sistemi affidabilistici (reliability)](#6-sistemi-affidabilistici-reliability)
7. [Processi di Poisson (omogenei e non omogenei)](#7-processi-di-poisson-omogenei-e-non-omogenei)
8. [Processi di Markov a tempo discreto (random walk, AR(1))](#8-processi-di-markov-a-tempo-discreto-random-walk-ar1)
9. [Monte Carlo integration](#9-monte-carlo-integration)
10. [Variance reduction: antithetic, importance sampling, control variates](#10-variance-reduction-antithetic-importance-sampling-control-variates)
11. [Bootstrap](#11-bootstrap)
12. [Density estimation: istogramma e KDE](#12-density-estimation-istogramma-e-kde)
13. [Statistica bayesiana](#13-statistica-bayesiana)
14. [MCMC: Metropolis–Hastings](#14-mcmc-metropolishastings)
15. [Gibbs sampler](#15-gibbs-sampler)
16. [Come leggere il codice R all'esame (checklist)](#16-come-leggere-il-codice-r-allesame-checklist)
17. [Cosa scrivere sul foglio A4](#17-cosa-scrivere-sul-foglio-a4)
18. [Piano di studio e mappa argomenti → esami](#18-piano-di-studio-e-mappa-argomenti--esami)

---

## 0. Formato dell'esame e cosa c'è già nel formula sheet

- **4 ore**, carta e penna. Ammessi: calcolatrice semplice + **un foglio A4 scritto a mano** (+ formula sheet allegato all'esame, "6 pages of enclosures").
- Tipicamente 2–5 problemi lunghi che mescolano argomenti (es. h25: un unico problema "pioggia a Stavanger" con distribuzione → MLE → bootstrap → Poisson → Bayes → MCMC).
- Molte domande sono **"explain with words and formulas, not code"** oppure **"which of these R functions is correct? Justify"**.

**Già presente nel formula sheet (non serve impararlo a memoria, serve saperlo usare):**

| Sezione formula sheet | Contenuto |
|---|---|
| 1–2 | pmf/pdf, E, Var di Binomial, Poisson, Geometric, NegBin, Normal, Multivariate normal, **Exponential (scala β)**, Lognormal, χ², t, **Gamma(α, β) scala**, **Weibull**, Uniform, Beta, **Pareto** |
| 3–4 | Relazioni tra distribuzioni, somme di v.a. indipendenti, $E$ e $Var$ di combinazioni lineari |
| 5 | Proprietà MLE, $Var(\hat\theta) \approx 1/J(\hat\theta)$ con $J(\theta) = -\ell''(\theta)$ |
| 6 | Hazard rate $r(t) = f(t)/(1-F(t))$ |
| 7–8 | Derivate, integrali (incl. $\int x e^{ax}dx$, integrazione per parti), logaritmi |
| 9 | **Algoritmo MH, RWMH, Independence sampler, Gibbs sampler** |
| 10 | **Regole per riconoscere distribuzioni dal log-kernel** (Normal, Exp, Gamma, Beta) |

⚠️ **Parametrizzazioni del corso** (attenzione, R a volte usa il *rate*):
- Exponential: $f(x) = \frac{1}{\beta} e^{-x/\beta}$, $E = \beta$, $Var = \beta^2$. In R: `rexp(n, rate = 1/beta)`.
- Gamma$(\alpha, \beta)$: $f(x) = \frac{1}{\beta^\alpha \Gamma(\alpha)} x^{\alpha-1} e^{-x/\beta}$, $E = \alpha\beta$, $Var = \alpha\beta^2$ (β = **scala**). In R: `rgamma(n, shape = alpha, scale = beta)`; `rgamma(n, 4, 1.4)` usa invece **rate** = 1.4!
- Weibull: $f(x) = \alpha\beta x^{\beta-1} e^{-\alpha x^\beta}$, $F(x) = 1 - e^{-\alpha x^\beta}$ ($\beta = 1$ → Exp).
- Pareto$(a, b)$: $f(x) = \frac{b a^b}{x^{b+1}}$, $x > a$, $F(x) = 1 - (a/x)^b$.

---

## 1. Variabili casuali continue: pdf, cdf, momenti

**Compare praticamente sempre come punto (a) del primo problema.** Sono punti "facili" da non perdere.

### Formule chiave
- $f$ è una **pdf propria** se (1) $f(x) \ge 0$ per ogni $x$ e (2) $\int_{-\infty}^{\infty} f(x)\,dx = 1$. **Vanno mostrate entrambe**: l'esame valuta anche la non-negatività.
- Costante di normalizzazione: se $f(x) = c\,h(x)$, allora $c = 1 / \int h(x)\,dx$.
- cdf: $F(x) = P(X \le x) = \int_{-\infty}^{x} f(t)\,dt$.
- Probabilità: $P(a < X < b) = F(b) - F(a)$, $P(X > a) = 1 - F(a)$.
- $E(X) = \int x f(x)\,dx$, $E(g(X)) = \int g(x) f(x)\,dx$, $Var(X) = E(X^2) - E(X)^2$.
- Linearità: $E(aX + b) = aE(X) + b$, $Var(aX + b) = a^2 Var(X)$, $E(X_1 + X_2) = E(X_1) + E(X_2)$ (sempre); $Var(X_1+X_2) = Var(X_1)+Var(X_2)$ solo se indipendenti.
- Probabilità condizionata: $P(X > a + s \mid X > a) = \frac{P(X > a+s)}{P(X > a)}$.
- **Memorylessness** dell'esponenziale: $P(X > a + s \mid X > a) = P(X > s) = e^{-s/\beta}$.

### Esempio (h23)
$f(x) = c\,x(1-x)$, $0 \le x \le 1$.
- $\int_0^1 x - x^2\,dx = \frac12 - \frac13 = \frac16 \Rightarrow c = 6$. Inoltre $x(1-x) \ge 0$ su $[0,1]$ ⇒ $f \ge 0$.
- $E(X) = 6\int_0^1 x^2 - x^3\,dx = 6(\frac13 - \frac14) = \frac12$.
- $E(X^2) = 6(\frac14 - \frac15) = 0.3 \Rightarrow Var(X) = 0.3 - 0.25 = 0.05$.
- $F(x) = 3x^2 - 2x^3 = x^2(3 - 2x)$, quindi $P(X > 0.5) = 1 - F(0.5) = 0.5$.

### Esempio (h25): esponenziale con β = 8
- $P(X > 12) = e^{-12/8} = e^{-1.5} \approx 0.223$.
- $P(X > 12 \mid X > 5) = P(X > 7) = e^{-7/8} \approx 0.417$ (memoryless).

### Trappole
- Dimenticare di mostrare $f(x) \ge 0$.
- Dimenticare che la cdf vale 0 a sinistra del supporto e 1 a destra (scrivila "a pezzi").
- Integrali trigonometrici (v26: $f(x) = \frac{1 + \sin x}{\pi + 2}$ su $[0, \pi]$): $\int_0^\pi \sin x\,dx = [-\cos x]_0^\pi = 2$.

---

## 2. Stimatori, MLE, CLT e intervalli di confidenza

### Definizioni
- **Stimatore** $\hat\theta$: funzione dei dati usata per stimare $\theta$.
- **Unbiased** (non distorto): $E(\hat\theta) = \theta$. **Bias** $= E(\hat\theta) - \theta$.
- **MSE** $= E[(\hat\theta - \theta)^2] = Var(\hat\theta) + \text{bias}^2$. Si confrontano stimatori tramite MSE (più piccolo = migliore).
- Per la media campionaria: $E(\bar X) = \mu$, $Var(\bar X) = \sigma^2/n$.

### MLE: ricetta in 5 passi
1. Likelihood: $L(\theta) = \prod_{i=1}^n f(x_i; \theta)$.
2. Log-likelihood: $\ell(\theta) = \sum_{i=1}^n \log f(x_i;\theta)$.
3. Derivata: $\ell'(\theta) = 0$, risolvi per $\theta$.
4. Controlla che sia un massimo: $\ell''(\hat\theta) < 0$.
5. (Se chiesto) $Var(\hat\theta) \approx 1/J(\hat\theta)$, $J = -\ell''$ (formula sheet §5).

**Esempio (h25) – Exponential con scala β:**
$L(\beta) = \beta^{-n} e^{-\frac{1}{\beta}\sum x_i}$, $\ell(\beta) = -n\log\beta - \frac{1}{\beta}\sum x_i$,
$\ell'(\beta) = -\frac{n}{\beta} + \frac{\sum x_i}{\beta^2} = 0 \Rightarrow \hat\beta = \bar x$.
Unbiased: $E(\hat\beta) = E(\bar X) = \beta$. Varianza: $Var(\hat\beta) = Var(X)/n = \beta^2/n$.

**Esempio (v25) – Pareto con $a$ noto:**
$\ell(b) = n\log b + nb\log a - (b+1)\sum \log x_i \Rightarrow \hat b = \frac{n}{\sum \log(x_i/a)}$.
Dato $E(\hat b) = \frac{n}{n-1}b$ ⇒ **distorto**. Lo stimatore $b^* = \frac{n-1}{\sum\log(x_i/a)} = \frac{n-1}{n}\hat b$ è non distorto, con $Var(b^*) = \frac{b^2}{n-2}$, e ha MSE minore di $\hat b$ ($\text{MSE}(\hat b) = \frac{(n+2)b^2}{(n-1)(n-2)}$) ⇒ $b^*$ è migliore.

### CLT e intervalli di confidenza
- Per $n$ grande: $\bar X \approx N(\mu, \sigma^2/n)$.
- IC al $(1-\alpha)$ per $\mu$: $\bar x \pm z_{\alpha/2} \cdot \frac{s}{\sqrt n}$ (con $z_{0.025} = 1.96$, $z_{0.05} = 1.645$).
- **Quanti dati/simulazioni servono** per avere $|\hat\theta - \theta| \le e$ con prob. 95%?
  $$z_{0.025}\frac{\sigma}{\sqrt n} \le e \;\Rightarrow\; n \ge \left(\frac{1.96\,\sigma}{e}\right)^2 \approx \frac{4\sigma^2}{e^2}$$
  (h25: $\sigma \approx s = 3.53$, $e = 1$ ⇒ $n \ge 4 \cdot 12.46 \approx 50$.)

### Trappole (h22, v25)
- Nei codici R di IC controlla: **stimatore e SE abbinati correttamente** (es. SE della media è `sd(x)/sqrt(n)`, non `sd(x)` né `var(x)/sqrt(n)`), e quantile giusto (`qnorm(0.975)` per un IC al 95%, **non** `qnorm(0.95)`).

### Esempio (h22 1g): stimare $\theta = E(\sqrt X)$ da un campione `x`
- `mean(sqrt(x))` ✅ **unbiased**: è la media di $Y_i = \sqrt{X_i}$, e $E(\bar Y) = E(\sqrt X)$.
- `sqrt(mean(x))` ❌ **distorto**: $\sqrt{E(X)} \ne E(\sqrt X)$ (disuguaglianza di Jensen: per $g$ concava, $g(E X) \ge E g(X)$). È solo consistente.
- `mean(sqrt(x>0))` ❌ — è la media di un'indicatrice (vale sempre 1).
- IC corretto: `point.1 ± 1.96*sd(sqrt(x))/sqrt(n)`, cioè la sd **delle $Y_i = \sqrt{X_i}$**, divisa per $\sqrt n$. Varianti con `sd(x)`, senza `/sqrt(n)` o con `/n` sono sbagliate.
- Per $n > 30$ il CLT dà $\bar X \approx N(E X, Var X/n)$ (h22 1f): giustifica con "iid + varianza finita + n grande".

---

## 3. Inverse transform method

### Idea
Se $U \sim U(0,1)$ e $F$ è una cdf continua e invertibile, allora $X = F^{-1}(U)$ ha cdf $F$.
Dimostrazione (a volte richiesta): $P(F^{-1}(U) \le x) = P(U \le F(x)) = F(x)$.

### Algoritmo (da scrivere a parole)
1. Trova la cdf $F(x)$ integrando la pdf.
2. Risolvi $F(x) = u$ rispetto a $x$ ⇒ $x = F^{-1}(u)$.
3. Per $i = 1, \dots, n$: genera $U_i \sim U(0,1)$, poni $X_i = F^{-1}(U_i)$.
4. $X_1, \dots, X_n$ sono iid con densità $f$.

### Inverse da sapere fare
| Distribuzione | $F(x)$ | $F^{-1}(u)$ |
|---|---|---|
| Exp (scala β) | $1 - e^{-x/\beta}$ | $-\beta\ln(1-u) \equiv -\beta\ln u$ |
| Weibull | $1 - e^{-\alpha x^\beta}$ | $\left(-\frac{\ln(1-u)}{\alpha}\right)^{1/\beta}$ |
| Pareto$(a,b)$ | $1 - (a/x)^b$ | $a(1-u)^{-1/b} \equiv a\,u^{-1/b}$ |
| Uniforme $[a,b]$ | $\frac{x-a}{b-a}$ | $a + (b-a)u$ |
| $f = 6x(1-x)$? | $3x^2 - 2x^3$ | cubica: non si inverte in forma chiusa ⇒ usa AR |

Nota: $1 - U \sim U(0,1)$, quindi **$\ln(1-U)$ e $\ln U$ sono entrambi corretti**.

### Caso discreto
Genera $U$, poni $X = $ il più piccolo $x_k$ tale che $F(x_k) \ge U$ (cioè $F(x_{k-1}) < U \le F(x_k)$).

### Quando NON funziona (v26)
Se $F(x) = u$ non si risolve in forma chiusa (es. $F(x) = \frac{x - \cos x + 1}{\pi + 2}$ mescola $x$ e $\cos x$) ⇒ inverse transform non adatto ⇒ si usa **Accept–Reject**.

### Trappola ricorrente: "quale funzione R è corretta?" (h22, h23, h24, v23)
Esempio h24, Pareto con $a = 4$, $b = 2$, $F^{-1}(u) = 4/\sqrt{1-u}$:
- `4/sqrt(runif(n,2,4))` ❌ — `runif` deve essere su $(0,1)$.
- `4/sqrt(runif(n))` ✅ — usa $U$ al posto di $1-U$.
- `4/sqrt(1-runif(n))` ✅
- `2/(1-runif(n)^(1/4))` ❌ — formula sbagliata.

Controlla sempre: intervallo di `runif`, esponente $1/b$ vs $b$, segno del log, parametro scala vs rate.

---

## 4. Accept–Reject method

### Idea
Vogliamo campionare da $f$ (difficile). Usiamo una proposal $g$ facile da campionare e una costante $c$ tale che $f(x) \le c\,g(x)$ per ogni $x$ (**envelope**). Proponiamo da $g$ e accettiamo con probabilità $\frac{f(Y)}{c\,g(Y)}$.

### Algoritmo
1. Genera $Y \sim g$.
2. Genera $U \sim U(0,1)$.
3. Se $U \le \frac{f(Y)}{c\,g(Y)}$ ⇒ accetta, $X = Y$. Altrimenti torna al passo 1.

### Formule chiave
- $c = \max_x \frac{f(x)}{g(x)}$ (deriva e poni = 0, oppure osserva dove è massima).
- Il supporto di $g$ deve **coprire** quello di $f$.
- Probabilità di accettazione = $1/c$; numero atteso di iterazioni per un campione = $c$ (geometrica).
- **Proposal migliore = $c$ più piccolo** (più vicino a 1) ⇒ meno rigetti.
- Funziona anche se $f$ è nota solo a meno di una costante (basta usare il kernel, la costante finisce in $c$).

### Esempi
**v24 / h23:** $f(x) = 6x(1-x)$ su $[0,1]$, proposal $U(0,1)$, $g = 1$.
$c = \max 6x(1-x) = 6 \cdot \frac14 = 1.5$ (in $x = 0.5$). Accetta se $U \le \frac{6Y(1-Y)}{1.5} = 4Y(1-Y)$. Prob. di accettazione $= 2/3$.

**v25:** $f(x) = 20x(1-x)^3$, proposal Beta(2,2) $g(x) = 6x(1-x)$.
$\frac{f}{g} = \frac{10}{3}(1-x)^2$, massima per $x \to 0$ ⇒ $c = 10/3$. Accetta se $U \le (1-Y)^2$.

**v26:** $f(x) = \frac{1+\sin x}{\pi+2}$ su $[0,\pi]$, proposal $U(0,\pi)$, $g = 1/\pi$.
$\frac{f}{g} = \frac{\pi(1+\sin x)}{\pi+2}$, max in $x = \pi/2$ ⇒ $c = \frac{2\pi}{\pi+2}$. Accetta se $U \le \frac{1+\sin Y}{2}$.

### Trappole (h22 1e)
- Nel codice: il rapporto deve essere `f(y)/(c*g(y))` con **la densità della proposal valutata in y**.
- `runif` per $Y$ sull'intervallo giusto (es. `runif(1, 0, pi)`).
- Il confronto è `u <= ratio` (accetta), non il contrario.
- **Sottigliezza h22:** $f(x) = \frac{e^{x/4}}{4C}$ su $[0,4]$, proposal $U(0,4)$, $g = 1/4$, `c <- 4*f(4)`.
  - `runif(1) < f(x)/(c*dunif(x,0,4))` ✅ corretto (prob. accettazione $1/c \approx 0.63$).
  - `runif(1) < f(x)/c` (manca $g$): il rapporto è $\frac14 \cdot \frac{f(x)}{c\,g(x)}$, ancora **proporzionale a $f$** e $\le 1$ ⇒ i campioni sono **ancora corretti**, ma si accetta 4 volte meno (inefficiente). Regola: l'AR è corretto finché la prob. di accettazione è $\propto f(y)/g(y)$ e $\le 1$; la costante influisce solo sull'efficienza.

### Scegliere tra due proposal (v23 1g)
Calcola $c_1 = \max f/g_1$ e $c_2 = \max f/g_2$: scegli quella con **c più piccolo** (meno rigetti), a parità di costo di simulazione. Una proposal con forma simile a $f$ (es. gamma troncata per una $f$ crescente come $\sqrt x$) batte l'uniforme.

### Distribuzioni troncate (v23 3a)
$f(x) = C e^{-x^2/2}$ su $[-2, 2]$ (normale troncata). Due algoritmi iid:
1. **Rejection semplice:** genera $Z \sim N(0,1)$, tieni $Z$ solo se $|Z| \le 2$ (accettazione $P(|Z| \le 2) \approx 0.954$).
2. **AR con proposal $U(-2,2)$:** $g = 1/4$, $c = \max f/g = 4C \approx 1.672$ (in $x = 0$); accetta se $U \le e^{-Y^2/2}$.

Un **independence sampler** con proposal $U(-2,2)$ (v23 3b, codice con `wt.old`/`wt.prop`) genera invece campioni **dipendenti** (catena MCMC), non iid.

---

## 5. Trasformazioni, somme, misture, normale multivariata

Quando inverse e AR non servono, si sfruttano **relazioni tra distribuzioni** (sezione 3 del formula sheet).

| Obiettivo | Come |
|---|---|
| $N(0,1)$ da uniformi (**Box–Muller**) | $Z_1 = \sqrt{-2\ln U_1}\cos(2\pi U_2)$, $Z_2 = \sqrt{-2\ln U_1}\sin(2\pi U_2)$ |
| $N(\mu,\sigma^2)$ | $X = \mu + \sigma Z$ |
| **Lognormal**$(\mu,\sigma^2)$ | $X = e^{\mu + \sigma Z}$ |
| $\chi^2_\nu$ | $\sum_{i=1}^\nu Z_i^2$ (es. $\chi^2_2 = Z_1^2 + Z_2^2$) |
| Gamma$(n, \beta)$, $n$ intero | somma di $n$ Exp(β) indipendenti |
| Beta | $X_1/(X_1+X_2)$ con $X_1 \sim$ Gamma$(\alpha)$, $X_2 \sim$ Gamma$(\beta)$ |
| Mistura $p f_1 + (1-p) f_2$ | genera $U$; se $U < p$ campiona da $f_1$, altrimenti da $f_2$ |

**Lognormale con media/varianza date (h24):** se vogliamo $E(X) = m$, $Var(X) = v$, dalle formule del formula sheet:
$$\sigma^2 = \ln\left(1 + \frac{v}{m^2}\right), \qquad \mu = \ln m - \frac{\sigma^2}{2}$$
Per $m = 1$, $v = 1$: $\sigma^2 = \ln 2$, $\mu = -\frac{\ln 2}{2}$, poi $X = e^{\mu + \sigma Z}$.

**Funzioni di v.a. via MC (h24 2c):** $Z = 5X + 3Y$. Simula $X_i, Y_i$, calcola $Z_i$, poi
$\hat E(Z) = \bar Z$, $\hat P(Z < 20) = \frac{1}{n}\#\{Z_i < 20\}$, $\hat P(40 < Z < 60) = \frac1n\#\{40 < Z_i < 60\}$.

### Normale multivariata (Cholesky)
Per $X \sim N_d(\mu, \Sigma)$:
1. Decomposizione di Cholesky $\Sigma = L L^T$ ($L$ triangolare inferiore).
2. Genera $Z = (Z_1,\dots,Z_d)$ iid $N(0,1)$.
3. $X = \mu + L Z$.

Caso bivariato con correlazione $\rho$: $X_1 = \mu_1 + \sigma_1 Z_1$, $X_2 = \mu_2 + \sigma_2(\rho Z_1 + \sqrt{1-\rho^2}Z_2)$.

**Gibbs per la normale bivariata standard** con correlazione $\rho$ (v23 5a): $X_1 \mid X_2 = x_2 \sim N(\rho x_2,\ 1-\rho^2)$ e $X_2 \mid X_1 = x_1 \sim N(\rho x_1,\ 1-\rho^2)$. Nel codice: `rnorm(1, mean=rho*x2, sd=sqrt(1-rho^2))` alternato.

**Confronto metodi** per la stessa normale bivariata (v23 5): Cholesky dà campioni **iid ed esatti** (migliore). Gibbs e RWMH danno una **catena correlata** (ESS < T, serve burn-in); il Gibbs peggiora quando $|\rho| \to 1$ (si muove a "zig-zag" lungo gli assi).

---

## 6. Sistemi affidabilistici (reliability)

- **Sistema in serie** (si guasta appena si guasta un componente): $S = \min(X_1, \dots, X_n)$, $P(S > t) = \prod P(X_i > t)$.
- **Sistema in parallelo** (si guasta quando tutti si guastano): $S = \max(X_1, \dots, X_n)$, $P(S \le t) = \prod P(X_i \le t)$.
- Sistemi misti: componi (es. $\min(X_1, \max(X_2, X_3))$).
- **Hazard rate** $r(t) = \frac{f(t)}{1 - F(t)}$ (formula sheet §6). Exp ⇒ costante; Weibull con $\beta > 1$ ⇒ crescente (usura).
- Utile: il min di Exp indipendenti con rate $\lambda_i$ è Exp con rate $\sum\lambda_i$. Il min di Weibull$(\alpha_i, \beta)$ con stesso $\beta$ è Weibull$(\sum\alpha_i, \beta)$; l'Exp è Weibull con $\beta = 1$ (hint h23).

**Simulazione (h23 1e):** per $j = 1,\dots,n$: genera $X_{1j}, X_{2j}$ da Weibull (inverse transform) e $X_{3j}$ da Exp, poni $S_j = \min(X_{1j}, X_{2j}, X_{3j})$. Poi stima $E(S)$, $P(S > t)$ ecc. con medie e frequenze relative.

---

## 7. Processi di Poisson (omogenei e non omogenei)

*(Lecture notes: `chap4_part1`; R: `stochastic_processes_examples.R`, `rain.R`)*

### Processo di Poisson omogeneo (HPP) con intensità λ
- $N(t) \sim \text{Poisson}(\lambda t)$: $E(N(t)) = Var(N(t)) = \lambda t$.
- Numeri di eventi in intervalli disgiunti sono **indipendenti**.
- **Tempi di interarrivo** $T_i \sim$ Exp con media $1/\lambda$ (iid).
- **Tempo del k-esimo evento** $S_k = T_1 + \dots + T_k \sim$ Gamma$(k, 1/\lambda)$.
- Equivalenza utile: $P(S_k > t) = P(N(t) < k)$.
- Dato $N(t) = n$, i tempi di arrivo sono distribuiti come $n$ uniformi ordinate su $[0, t]$ ⇒ $P(N(s) = 0 \mid N(t) = n) = (1 - s/t)^n$.
  (h22: $P(N(0.1) = 0 \mid N(1) = 8) = 0.9^8 \approx 0.430$.)
- Primo evento $T_1 \sim$ Exp con media $1/\lambda$, pdf $\lambda e^{-\lambda t}$; $E(T_1^2) = Var + E^2 = \frac{1}{\lambda^2} + \frac{1}{\lambda^2} = \frac{2}{\lambda^2}$ (h22 2a).

**Esempi (h24):** nascite con λ = 6/giorno.
- $P(N(1) < 3) = e^{-6}(1 + 6 + 18) = 25e^{-6} \approx 0.062$.
- "Più di 8 ore fino alla 3ª nascita": in 8 h (= 1/3 giorno) la media è $6 \cdot \frac13 = 2$, quindi $P(S_3 > 8h) = P(N(8h) < 3) = e^{-2}(1 + 2 + 2) = 5e^{-2} \approx 0.677$.

### Simulare un HPP su $[0, T]$: due modi
**Opzione 1 (interarrivi):** genera $T_1, T_2, \dots \sim$ Exp(media $1/\lambda$), somma cumulativamente, fermati quando la somma supera $T$; tieni gli arrivi $\le T$.
**Opzione 2 (condizionale):** genera $N \sim \text{Poisson}(\lambda T)$, poi $N$ valori $U(0,T)$ e **ordinali**.

**Stimare una probabilità (h25):** simula $M$ processi (es. $M = 5000$), conta $N_m(12)$, poi $\hat P(N(12) \ge 90) = \frac{1}{M}\#\{m : N_m(12) \ge 90\}$.

### Processo di Poisson non omogeneo (NHPP) con intensità λ(t)
- **Interpretazione di λ(t):** tasso istantaneo di eventi al tempo $t$; $\lambda(t)\,dt \approx P(\text{un evento in } [t, t+dt])$. Se varia ⇒ stagionalità (h25: più tempeste in inverno).
- $N(t) \sim \text{Poisson}(\Lambda(t))$ con $\Lambda(t) = \int_0^t \lambda(s)\,ds$. Numero atteso in un anno $= \int_0^{12}\lambda(t)\,dt$.
  (h24: $\lambda(t) = -30t^2 + 350t + 3950$ ⇒ $\int_0^{12} = -10\cdot 12^3 + 175\cdot 12^2 + 3950\cdot 12 = 55\,320$.)
  (h22: $\lambda(t) = 1 + t/10$ ⇒ $N(5) \sim \text{Poisson}\left(\int_0^5 1 + \frac{t}{10}\,dt\right) = \text{Poisson}(5 + 1.25) = \text{Poisson}(6.25)$.)
- **Thinning** (simulazione, è un accept–reject sui tempi):
  1. Trova $\lambda_{\max} \ge \lambda(t)$ per ogni $t \in [0, T]$ (dal grafico o derivando).
  2. Simula un HPP con intensità $\lambda_{\max}$ su $[0,T]$ ⇒ tempi $s_1, \dots, s_N$.
  3. Per ogni $s_i$ genera $U_i \sim U(0,1)$ e **tieni** $s_i$ se $U_i \le \lambda(s_i)/\lambda_{\max}$.
  4. I tempi rimasti sono un NHPP con intensità $\lambda(t)$.

### Altro (`chap4`)
- **Renewal process**: come l'HPP ma con interarrivi iid da una distribuzione qualsiasi (simula interarrivi e somma).
- Code (M/M/c ecc.) sono materiale **opzionale, fuori programma**.

---

## 8. Processi di Markov a tempo discreto (random walk, AR(1))

*(Lecture notes: `markov_proc.pdf`; R: `Markov.R`, `AR1sim.R`)*

- **Proprietà di Markov:** $P(X_{n+1} \in A \mid X_n, X_{n-1}, \dots) = P(X_{n+1} \in A \mid X_n)$, cioè il futuro dipende solo dal presente.
  - $X_{n+1} = aX_n + \varepsilon_{n+1}$ ⇒ Markov.
  - $X_{n+1} = aX_n + bX_{n-1} + \varepsilon_{n+1}$ ⇒ **non** Markov (dipende anche da ieri).
- **Distribuzione stazionaria:** la distribuzione di $X_n \mid X_1$ converge a una distribuzione fissa (con varianza finita) per $n \to \infty$.

### Random walk semplice (v26)
$X_t = X_{t-1} + Z_t$, $Z_t \in \{-1, +1\}$ con $P(Z_t = 1) = p$.
- **Spazio degli stati:** $\mathbb{Z}$ (tutti gli interi).
- Markov ✅ (il passo successivo dipende solo dalla posizione attuale).
- $E(Z) = 2p - 1$, $Var(Z) = 1 - (2p-1)^2$. Con $p = 0.5$: $E(Z) = 0$, $Var(Z) = 1$.
- Con $X_1 = 0$: $X_t = \sum Z_i$ ⇒ $E(X_t) = 0$, $Var(X_t)$ cresce **linearmente** con $t$ ⇒ **nessuna distribuzione stazionaria**.
- Con `prob = c(0.4, 0.6)`: random walk **asimmetrico con drift** verso l'alto ($E(Z) = 0.2$); la media cresce linearmente ⇒ ancora non stazionario.
- Gaussian RW: $X_n \mid X_1 = a \sim N(a, (n-1)\sigma^2)$ ⇒ non stazionario.

### AR(1)
$X_{n+1} = \mu + \phi X_n + \varepsilon_{n+1}$, $\varepsilon \sim N(0,\sigma^2)$.
Se $|\phi| < 1$ ⇒ stazionario con distribuzione $N\left(\frac{\mu}{1-\phi}, \frac{\sigma^2}{1-\phi^2}\right)$. Se $|\phi| \ge 1$ ⇒ non stazionario (con $\phi = 1$ è un random walk).

**Perché ci interessa:** gli MCMC costruiscono catene di Markov la cui distribuzione stazionaria è la distribuzione target. Le medie lungo la catena convergono (LLN), ma i campioni sono **correlati**, quindi la varianza è maggiore che con campioni iid.

---

## 9. Monte Carlo integration

*(Lecture notes: `chap6_part1`; R: `MC_integration_examples.R`)*

### Crude MC su intervallo finito
$$\theta = \int_a^b g(x)\,dx = (b-a)\,E[g(U)],\; U \sim U(a,b) \quad\Rightarrow\quad \hat\theta = \frac{b-a}{n}\sum_{i=1}^n g(U_i)$$

### MC generalizzato (dominio infinito, es. $[0,\infty)$)
Scrivi $g(x) = h(x) f(x)$ con $f$ **densità facile da campionare** sullo stesso dominio:
$$\theta = \int g(x)\,dx = \int h(x) f(x)\,dx = E_f[h(X)] \quad\Rightarrow\quad \hat\theta = \frac{1}{n}\sum h(X_i),\; X_i \overset{iid}{\sim} f$$

**Esempio (h25):** $I = \int_0^\infty \ln(1 + 4x^2) e^{-x/2}\,dx$. Con $f(x) = \frac12 e^{-x/2}$ (Exp, β = 2):
$I = \int 2\ln(1+4x^2) f(x)\,dx$ ⇒ $\hat I = \frac{1}{n}\sum 2\ln(1 + 4X_i^2)$, $X_i \sim$ Exp(β = 2).

**Passi da descrivere:** (1) riscrivi l'integrale come $E[h(X)]$; (2) genera $X_1,\dots,X_n$ iid da $f$ (es. inverse transform); (3) calcola $h(X_i)$; (4) fai la media; (5) riporta l'errore standard.

### Hit-or-miss / stima di π (v26)
$P(X^2 + Y^2 \le 1) = \pi/4$ con $X, Y \sim U(0,1)$ ⇒ $\hat\pi = 4 \cdot \frac{1}{n}\sum I(X_i^2 + Y_i^2 \le 1)$. È un crude MC con integranda indicatrice. Le versioni con ciclo `for` e vettorizzata danno lo stesso stimatore; quella vettorizzata è solo più veloce.

**Varianza di uno stimatore hit-or-miss (v23 2):** $\hat A = \frac{4}{n}\sum I_i$ con $\sum I_i \sim \text{Binomial}(n, p)$, $p = A/4$.
- $Var(\hat A) = \frac{16\,p(1-p)}{n}$ ⇒ stima con $p \approx$ `mean(indicator)`; IC: $\hat A \pm 1.96 \cdot \frac{4\,\hat\sigma_I}{\sqrt n}$ (con $\hat\sigma_I$ = `sd(indicator)`).
- **n per avere $sd(\hat A) < 0.01$:** $\frac{16p(1-p)}{n} < 10^{-4}$ ⇒ $n > 16\,p(1-p)\cdot 10^4$ (con $p = 1/6$: $n \ge 22\,223$).
- $P(\hat A < a)$ senza simulare: per CLT $\hat A \approx N\left(A, \frac{16p(1-p)}{n}\right)$ ⇒ $\Phi\left(\frac{a - A}{\sqrt{16p(1-p)/n}}\right)$.

### Integrali su tutta la retta o su intervalli, con draw normali o Laplace (v23 4, h22 3)
- $A = \int_{-\infty}^{\infty} g(x)\,dx$ con $X_i \sim N(0,1)$: $\hat A = \frac1n\sum\frac{g(X_i)}{\phi(X_i)}$ ($\phi$ = pdf normale, `dnorm`).
- $B = \int_{-\pi/2}^{\pi/2} g(x)\,dx$ con $X_i \sim N(0,1)$: aggiungi l'indicatrice ⇒ $\hat B = \frac1n\sum\frac{g(X_i)\,I(|X_i| \le \pi/2)}{\phi(X_i)}$.
- $B$ con $U_i \sim U(-\pi/2, \pi/2)$: $\hat B = \frac{\pi}{n}\sum g(U_i)$.
- Con **Laplace(0, 2)**, $p(x) = \frac{e^{-|x|/2}}{4}$: stessa formula con $p$ al posto di $\phi$. La Laplace ha **code più pesanti** della normale ⇒ pesi $g/p$ più stabili. Si simula come $X = S \cdot E$ con $E \sim$ Exp(media 2) e segno $S = \pm 1$ con prob. 1/2.
- Con Exponential(media 1/2) per $\int_0^\infty e^{-2x}h(x)\,dx$: $f(x) = 2e^{-2x}$ ⇒ $\hat A = \frac1n\sum\frac{h(X_i)}{2}$.

### Integrali multidimensionali (h24)
Stessa idea: scegli una densità congiunta (uniformi e/o normali indipendenti) che copra il dominio, scrivi l'integranda come $h \cdot f$, fai la media di $h$.

### Errore standard e precisione
$$\widehat{SE}(\hat\theta) = \frac{s_h}{\sqrt n}, \qquad s_h = \text{sd campionaria di } h(X_i)\;(\text{per crude: } (b-a)\,g(U_i))$$
IC al 95%: $\hat\theta \pm 1.96\,\widehat{SE}$. La precisione migliora solo come $1/\sqrt n$ (per dimezzare l'errore servono 4 volte più simulazioni) ⇒ motivazione per la variance reduction.

**Probabilità come integrale:** $P(X \in A) = E[I(X \in A)]$ ⇒ stima con frequenza relativa (h23: $\int_0^{2.5} f(x)\,dx$ stimato con uniformi su $[0, 2.5]$).

---

## 10. Variance reduction: antithetic, importance sampling, control variates

*(Lecture notes: `chap6_part2`; R: `Variance_reduction.R`, `importance_sampling.R`)*

### Antithetic variables (compare in quasi ogni esame!)
**Idea:** $Var\left(\frac{X_1 + X_2}{2}\right) = \frac14[Var X_1 + Var X_2 + 2Cov(X_1,X_2)]$ ⇒ se $Cov < 0$ la varianza scende.
- Se $U \sim U(0,1)$ allora $1 - U \sim U(0,1)$, negativamente correlata con $U$.
- Se $U \sim U(a,b)$: antitetico $a + b - U$.
- Per una $F$ qualsiasi: $X = F^{-1}(U)$, $Y = F^{-1}(1-U)$.
- Normale: $X = \mu + \sigma Z$, $Y = \mu - \sigma Z$.

**Stimatore** (n/2 coppie):
$$\hat\theta_{AT} = \frac{1}{n}\sum_{i=1}^{n/2}\big[h(X_i) + h(Y_i)\big]$$

**Quando funziona:** se $h$ è **monotona** sul dominio ⇒ $Cov(h(X), h(Y)) < 0$ ⇒ varianza ridotta garantita. Se $h$ **non** è monotona (es. ha un picco nel mezzo, oppure è simmetrica come $\cos x$ su un intervallo simmetrico) può non aiutare o addirittura peggiorare.

**Esempi:**
- h25: $h(x) = 2\ln(1+4x^2)$ è crescente per $x \ge 0$ ⇒ l'antitetico funziona.
- v26: l'indicatrice di $x^2 + y^2 \le 1$ è decrescente in $x$ e in $y$ ⇒ le coppie $(U, 1-U)$ aiutano.
- h23: $\int_{0.5}^{2.5}$ della pdf Weibull(4,2). Il picco è in $x = 1/\sqrt{8} \approx 0.35 < 0.5$, quindi su $[0.5, 2.5]$ la pdf è **monotona (decrescente)** ⇒ l'antitetico funziona ($U_i$ e $V_i = 3 - U_i$; std 0.0062 contro 0.0070 del crude).
- **Caso peggiore: funzione pari con antitetico simmetrico** (h22 3f, v23 4f). Su $U(-1,1)$ l'antitetico è $-U$:
  - $1 + x^3$ è **monotona** ⇒ funziona (anzi $g(U) + g(-U) = 2$ costante ⇒ varianza zero!).
  - $1 + x^4$ (o $e^{-x^2}\cos x$) è **pari** ⇒ $g(-U) = g(U)$, correlazione $+1$ ⇒ di fatto solo $n/2$ valori distinti ⇒ **peggio** del crude MC con $n$ valutazioni.

**Trappola (v24):** `x1 <- runif(Nsim/2, 1, 6); x2 <- 5 - x1` ❌ — per $U(1,6)$ l'antitetico è $1 + 6 - U = 7 - U$. Con `5 - x1` si esce dal dominio.

### Importance sampling
$$\theta = \int_A g(x)\,dx = \int_A \frac{g(x)}{f(x)} f(x)\,dx = E_f\left[\frac{g(X)}{f(X)}\right] \quad\Rightarrow\quad \hat\theta_{IS} = \frac1n\sum_{i=1}^n \frac{g(X_i)}{f(X_i)},\; X_i \sim f$$
- $Var(\hat\theta_{IS}) = \frac1n Var\left(\frac{g(X)}{f(X)}\right)$ ⇒ piccola se $g/f$ è **quasi costante**, cioè $f$ ha forma simile a $|g|$.
- Il supporto di $f$ deve coprire $A$. Se è più grande usa l'indicatrice: $\hat\theta = \frac1n\sum\frac{g(X_i)I(X_i\in A)}{f(X_i)}$.
- **Code:** i pesi $g/f$ devono restare limitati. Se $f$ ha code più leggere di $g$ (es. normale) ⇒ pesi enormi ⇒ varianza enorme. Diagnostica: guarda la distribuzione dei pesi.
- **Non** riduce sempre la varianza (v24 3b): una $f$ scelta male la **aumenta**.
- Il peso $g/f$ deve essere limitato **ovunque**, non solo nelle code: anche vicino a 0. Esempio (h22 3d–e), proposal Gamma con forma $x^{\alpha-1}e^{-2x}$ per un'integranda $e^{-2x}x^{k}$: il peso è $\propto x^{k - \alpha + 1}$. Se l'esponente è $\ge 0$ ⇒ peso limitato vicino a 0 (e quando l'esponente è 0 il peso è costante: varianza zero, IS perfetto). Se è $< 0$ ⇒ il peso esplode per $x \to 0$ ⇒ IS pessimo. Calcola sempre il rapporto $g/f$ e guarda come si comporta agli estremi.

**Esempio (v25):** $I = \int_0^1 x(1-x)^3\,dx$ con $f$ = Beta(2,2) $= 6x(1-x)$:
$\hat I_{IS} = \frac1n\sum\frac{X_i(1-X_i)^3}{6X_i(1-X_i)} = \frac1n\sum\frac{(1-X_i)^2}{6}$.

**Trappola (v24 Est2 vs Est3):**
- `mean(gx(x)*(x<6 & x>1)/dgamma(x,4,1.4))` ✅ ($g\,I/f$)
- `mean(dgamma(x,4,1.4)/(gx(x)*(x<6 & x>1)))` ❌ — rapporto invertito (e divisione per 0 fuori dal dominio).

### Control variates (*"read on your own"*, priorità bassa)
$\hat\theta_c = g(X) + c\,(h(X) - \mu)$ con $\mu = E[h(X)]$ nota. Ottimo $c^* = -\frac{Cov(g,h)}{Var(h)}$; riduzione relativa della varianza $= Cor(g,h)^2$.

---

## 11. Bootstrap

*(Lecture notes: `chap8.pdf`; R: `bootstrap_examples.R`)* — **compare quasi sempre con calcoli numerici da output R.**

### Idea
Non conosciamo $F$. Sostituiamo $F$ con la **cdf empirica** $\hat F$ dei dati (bootstrap **non parametrico**) e simuliamo da $\hat F$, cioè ricampioniamo i dati **con reinserimento**. Nel bootstrap **parametrico** si simula invece dal modello stimato $F_{\hat\theta}$.

### Algoritmo
1. Calcola $\hat\theta$ dai dati originali $x_1,\dots,x_n$.
2. Per $b = 1,\dots,B$ (es. $B \ge 2000$ per gli IC):
   - estrai $x_1^{*(b)},\dots,x_n^{*(b)}$ **con reinserimento**, **stessa taglia n**;
   - calcola $\hat\theta^{*(b)}$ con **lo stesso stimatore**.
3. La distribuzione empirica di $\hat\theta^{*(1)},\dots,\hat\theta^{*(B)}$ approssima quella di $\hat\theta$.

### Formule (impara a memoria → foglio A4)
Sia $\bar\theta^* = \frac1B\sum_b \hat\theta^{*(b)}$ e $\widehat{SE} = sd(\hat\theta^{*(b)})$.

| Quantità | Formula |
|---|---|
| Bias | $\widehat{\text{bias}} = \bar\theta^* - \hat\theta$ |
| Standard error | $\widehat{SE} = \sqrt{\frac{1}{B-1}\sum(\hat\theta^{*(b)} - \bar\theta^*)^2}$ |
| MSE | $\widehat{SE}^2 + \widehat{\text{bias}}^2$ |
| Bias-corrected | $\hat\theta - \widehat{\text{bias}} = 2\hat\theta - \bar\theta^*$ |
| IC **normale** | $\hat\theta \pm z_{\alpha/2}\,\widehat{SE}$ |
| IC **percentile** | $[\hat\theta^*_{(\alpha/2)},\; \hat\theta^*_{(1-\alpha/2)}]$ |
| IC **basic** | $[2\hat\theta - \hat\theta^*_{(1-\alpha/2)},\; 2\hat\theta - \hat\theta^*_{(\alpha/2)}]$ (quantili **scambiati**!) |

### Esempio completo (h25)
$\hat\beta = \bar x = 9.29$, $\bar\theta^* = 9.28$, $\widehat{SE} = 0.55$, quantili bootstrap: 2.5% = 8.18, 97.5% = 10.36.
- Bias $= 9.28 - 9.29 = -0.01$; bias-corrected $= 9.29 + 0.01 = 9.30$.
- MSE $= 0.55^2 + 0.01^2 \approx 0.303$.
- Normale 95%: $9.29 \pm 1.96 \cdot 0.55 = [8.21,\ 10.37]$.
- Basic 95%: $[2\cdot 9.29 - 10.36,\ 2\cdot 9.29 - 8.18] = [8.22,\ 10.40]$.
- Percentile 95%: $[8.18,\ 10.36]$.

Per un IC al **90%** usa $z = 1.645$ e i quantili 5% e 95% (v24).

**Attenzione all'output R (h22 4):** se viene dato `var(f1.hat.boot)` = 0.001027, allora $\widehat{SE} = \sqrt{0.001027} \approx 0.032$. **Non** usare la varianza come SE. Il bootstrap funziona per **qualsiasi** stimatore (anche una KDE valutata in un punto, una mediana, un quantile), non solo per la media.

### Confronto tra intervalli
- **Normale:** semplice, ma assume normalità e non-distorsione; è il meno affidabile.
- **Percentile:** non assume normalità e si adatta all'asimmetria.
- **Basic:** riflette i quantili attorno a $\hat\theta$ (approssima la distribuzione di $\hat\theta - \theta$ con quella di $\hat\theta^* - \hat\theta$).
- **BCa:** corregge bias e asimmetria, in generale il migliore (solo da citare).
- Se la distribuzione bootstrap è simmetrica e circa normale ⇒ i tre intervalli sono simili (come in h25). Se è asimmetrica ⇒ differiscono.

### Trappole nel codice (v25 2d–f)
- `sample(data, size=length(data), replace=FALSE)` ❌ — è solo una permutazione, $\hat\theta^*$ è sempre uguale.
- `sample(data, size=nrep, replace=TRUE)` dentro `for(i in 1:length(data))` ❌ — taglia e ciclo invertiti.
- `mean(sample(...))` invece di `bootFunc(sample(...))` ❌ — stimatore sbagliato.
- MSE: `var(bootEstB) + bias^2` ✅; con `-` oppure con `sd` al posto di `var` ❌.
- IC normale al 95% con `qnorm(0.95)` ❌ (è al 90%); con `var(bootEstB)` al posto di `sd` ❌.
- `1 - quantile(...)` non è nessun intervallo bootstrap ❌.

---

## 12. Density estimation: istogramma e KDE

*(Lecture notes: `chap12.pdf`; R: `KDE.R`)*

### Istogramma
$\hat f(x) = \frac{\nu_k}{nh}$ per $x \in [t_k, t_{k+1})$, dove $\nu_k$ è il numero di dati nel bin e $h$ la larghezza dei bin. È una densità propria (integra a 1).
- **Bias** cresce con $h$ (pochi bin ⇒ troppo liscio); **varianza** $\approx \frac{f(x)}{nh}$ cresce quando $h \to 0$ (troppi bin ⇒ rumoroso). È il **bias–variance tradeoff**: si sceglie $h$ minimizzando il MISE.
- **Scott's rule:** $\hat h = 3.49\,\hat\sigma\,n^{-1/3}$, derivata **assumendo dati normali**.
- **Sturges' rule:** $\hat h = \frac{\max x - \min x}{1 + \log_2 n}$ (default di R).

**h24 trappola:** Scott per una **Pareto** (molto asimmetrica, coda pesante)? **No**: la regola assume normalità; con code pesanti $\hat\sigma$ è gonfiata dagli outlier ⇒ bin troppo larghi per la zona densa vicino ad $a$.

### Kernel Density Estimation (KDE)
$$\hat f_K(x) = \frac{1}{nh}\sum_{i=1}^n K\!\left(\frac{x - X_i}{h}\right)$$
$K$ = densità simmetrica con media 0 e varianza 1 (es. $N(0,1)$); $h$ = **bandwidth**.
- $h$ piccolo ⇒ bias basso, varianza alta (curva frastagliata, **undersmoothing**).
- $h$ grande ⇒ varianza bassa, bias alto (curva troppo piatta, **oversmoothing**, nasconde le mode).
- **Rule of thumb** (normale): $\hat h = 1.06\,\hat\sigma\,n^{-1/5}$.

### Pro/contro (h23 1f)
| | Istogramma | KDE |
|---|---|---|
| Pro | semplice, robusto, nessuna ipotesi di forma | stima liscia e continua, non dipende dall'origine dei bin |
| Contro | discontinuo, dipende da larghezza **e** posizione dei bin | sbaglia vicino ai **bordi del supporto** (es. Exp in 0: mette massa sotto 0), soffre con distribuzioni lontane dalla normale/multimodali |
| **In comune** | entrambi stimatori **non parametrici** e **distorti** di $f$, con un parametro di smoothing ($h$) che regola il bias–variance tradeoff | |

Per confrontare più KDE su un grafico: quella "migliore" segue la forma dell'istogramma senza essere né frastagliata né troppo piatta, e rispetta il supporto.

---

## 13. Statistica bayesiana

*(Lecture notes: `bayes.pdf`; Exercises: set 5–6)*

### Idea
Il parametro $\theta$ è una v.a. con una **prior** $p(\theta)$. Dopo aver visto i dati:
$$\underbrace{p(\theta \mid x)}_{\text{posterior}} \propto \underbrace{L(\theta)}_{\text{likelihood}} \times \underbrace{p(\theta)}_{\text{prior}}$$
Lavoriamo con il **kernel**: possiamo buttare tutte le costanti che non dipendono da $\theta$. In scala log:
$$\log p(\theta \mid x) = \ell(\theta) + \log p(\theta) + \text{cost.}$$

### Ricetta per derivare un posterior kernel
1. Scrivi la likelihood $L(\theta) = \prod f(x_i \mid \theta)$ e semplifica (somme negli esponenti).
2. Scrivi la prior **solo con i fattori che dipendono da θ** (es. Gamma$(a, b)$ scala: $\theta^{a-1}e^{-\theta/b}$).
3. Moltiplica, raccogli le potenze di $\theta$ e gli esponenziali.
4. Passa ai log se richiesto.
5. Confronta con le **regole del formula sheet §10**:
   - $\log p = a + bx + cx^2$ ⇒ $N\left(-\frac{b}{2c}, -\frac{1}{2c}\right)$
   - $\log p = a + bx$, $x > 0$ ⇒ Exp
   - $\log p = a + b\log x + cx$, $x > 0$ ⇒ Gamma$(b+1, -1/c)$ (scala)

### Coniugate classiche (Gamma ha scala b)
| Modello | Prior | Posterior |
|---|---|---|
| $X_i \sim$ Poisson(λ) | λ ~ Gamma$(a, b)$ | Gamma$\left(a + \sum x_i,\ \frac{1}{1/b + n}\right)$ |
| $X_i \sim$ Exp con **rate** λ | λ ~ Gamma$(a, b)$ | Gamma$\left(a + n,\ \frac{1}{1/b + \sum x_i}\right)$ |
| $X_i \sim N(\mu, \sigma^2)$, σ² noto | $\mu \sim N(m_0, \sigma^2/\kappa_0)$ | $N\left(\frac{\kappa_0 m_0 + n\bar x}{\kappa_0 + n},\ \frac{\sigma^2}{\kappa_0+n}\right)$ |

Media e varianza della prior Gamma$(a, b)$: $E = ab$, $Var = ab^2$ (h23: Gamma(15, 1/20) ⇒ $E = 0.75$, $Var = 0.0375$).

### Esempio (h25): Exp con scala β e prior Gamma$(a_0, b_0)$ su β
$L(\beta) = \beta^{-n}e^{-\sum x_i/\beta}$, prior $\propto \beta^{a_0-1}e^{-\beta/b_0}$:
$$\log p(\beta \mid x) = (a_0 - n - 1)\log\beta - \frac{\beta}{b_0} - \frac{\sum x_i}{\beta} + \text{cost.}$$
Il termine $1/\beta$ **non** rientra in nessuna forma standard ⇒ non coniugata ⇒ serve **MCMC**.

### Esempio (v24): due parametri, condizionali Gamma
Posterior $\propto (ab)^n e^{-ab\sum t_i}e^{-3(a+b)}$. Per $a \mid b$: $\log p = n\log a - a(b\sum t_i + 3)$ + cost ⇒ forma $b'\log a + c'a$ ⇒ $a \mid b \sim$ Gamma$\left(n+1, \frac{1}{b\sum t_i + 3}\right)$. Per simmetria lo stesso vale per $b \mid a$ ⇒ **Gibbs sampler**.

### Trappole (h23 1i: "quale log-target è valido?")
- `log(prod(f(x)))` è matematicamente giusto ma numericamente instabile (underflow con $n$ grande): meglio `sum(log(f(x)))`.
- Prior Gamma: il log-kernel è `(a-1)*log(theta) - theta/b`; `log(theta/b)` ❌ (dovrebbe essere `theta/b` senza log).
- `dgamma(theta, shape=a, scale=b, log=TRUE)` ✅ (include costanti, ma va bene lo stesso).
- Le costanti additive nel log sono irrilevanti per MCMC (si cancellano nel rapporto).

---

## 14. MCMC: Metropolis–Hastings

*(Lecture notes: `chap11_part1/2`; R: `mcmc_1.R`, `mcmc_2.R`)*

### Perché
Vogliamo campioni dalla target $\pi(\theta) \propto g(\theta)$ conosciuta **solo a meno di una costante** (tipicamente una posterior). Costruiamo una catena di Markov con distribuzione stazionaria $\pi$: la costante si cancella nel rapporto di accettazione.

### Algoritmo MH (anche nel formula sheet §9)
1. Scegli $\theta_0$, poni $t = 1$.
2. Proponi $\theta^* \sim q(\cdot \mid \theta_{t-1})$.
3. $\alpha = \min\left(1,\ \frac{g(\theta^*)\,q(\theta_{t-1} \mid \theta^*)}{g(\theta_{t-1})\,q(\theta^* \mid \theta_{t-1})}\right)$.
4. Genera $U \sim U(0,1)$; se $U < \alpha$ poni $\theta_t = \theta^*$, altrimenti $\theta_t = \theta_{t-1}$.
5. $t \leftarrow t+1$, torna al passo 2.

**In scala log** (numericamente stabile, sempre preferito):
$$\log\alpha = \min\big(0,\ \log g(\theta^*) - \log g(\theta_{t-1}) + \log q(\theta_{t-1}\mid\theta^*) - \log q(\theta^*\mid\theta_{t-1})\big)$$

### Le tre varianti da riconoscere
| Variante | Proposal | Accettazione | Nel codice R |
|---|---|---|---|
| **Random walk MH** | $\theta^* = \theta_{t-1} + \varepsilon$, $\varepsilon \sim N(0, \sigma^2)$ (simmetrica) | $\min(1, g(\theta^*)/g(\theta_{t-1}))$ | `rnorm(1, mean = x[t-1], sd = sigma)` |
| **Independence sampler** | $q(\theta^*\mid\theta_{t-1}) = r(\theta^*)$, non dipende dallo stato | $\min\left(1, \frac{g(\theta^*)/r(\theta^*)}{g(\theta_{t-1})/r(\theta_{t-1})}\right)$ | `rnorm(1, mean = 5, ...)` fisso, pesi `wt.star / wt.old` |
| **MH generale** (asimmetrico) | es. log-normale | formula completa con $q$ | proposal su scala log |

### Proposal su scala log (parametri positivi) — h25, v26
Il RWMH su $\theta > 0$ può proporre valori negativi (rigettati), il che crea problemi vicino al bordo. Soluzione: $\log\theta^* = \log\theta_{t-1} + \varepsilon$, $\varepsilon \sim N(0,\sigma^2)$ ⇒ $\theta^* \sim$ Lognormal$(\log\theta_{t-1}, \sigma^2)$, sempre positivo.
La proposal **non è simmetrica**: $\frac{q(\theta_{t-1}\mid\theta^*)}{q(\theta^*\mid\theta_{t-1})} = \frac{\theta^*}{\theta_{t-1}}$, quindi
$$\log\alpha = \min\big(0,\ \log g(\theta^*) - \log g(\theta_{t-1}) + \log\theta^* - \log\theta_{t-1}\big)$$
**Alternativa equivalente (Jacobiano):** lavora su $\phi = \log\theta$ con target $\tilde g(\phi) = g(e^\phi)\,e^\phi$ ⇒ RWMH simmetrico su $\phi$, e alla fine trasforma indietro con $\theta = e^\phi$.

### Independence sampler con proposal Gamma centrata sulla MLE (h25 j)
Vogliamo $q$ = Gamma$(a_p, b_p)$ con media $\hat\beta$ e varianza $\hat\beta^2/n$:
$a_p b_p = \hat\beta$, $a_p b_p^2 = \hat\beta^2/n$ ⇒ $a_p = n$, $b_p = \hat\beta/n$.
$\log\alpha = \min\big(0,\ [\log g(\theta^*) - \log q(\theta^*)] - [\log g(\theta_{t-1}) - \log q(\theta_{t-1})]\big)$.
Con l'independence sampler si vuole un'accettazione **alta** (proposal ≈ target).

### Diagnostica e tuning
- **Traceplot:** deve sembrare un "bruco peloso" stazionario attorno a un livello. Trend iniziale ⇒ serve **burn-in** (scarta le prime iterazioni). Tratti piatti ⇒ troppi rigetti. Andamento lento e serpeggiante ⇒ passi troppo piccoli.
- **Acceptance rate per RWMH:** circa **20%–40%** (rule of thumb del corso).
  - $\sigma$ troppo piccolo ⇒ accettazione altissima ma la catena si muove lentamente (alta autocorrelazione).
  - $\sigma$ troppo grande ⇒ quasi tutto rigettato, catena "a gradini".
- **Effective Sample Size (ESS):** numero di campioni iid equivalenti, $ESS = \frac{T}{1 + 2\sum_k \rho_k}$. Regole: **ESS > 200**; $ESS/T < 0.01$ ⇒ problemi. IC per $E(\theta)$: $\bar\theta \pm z_{\alpha/2}\frac{sd(\theta_t)}{\sqrt{ESS}}$.
- **Geweke test** (una catena): confronta la media della prima parte con l'ultima; $Z \approx N(0,1)$ se stazionaria.
- **Gelman–Rubin** (più catene): potential scale reduction factor in $[1, 1.1)$ ⇒ convergenza.
- **Thinning:** tenere un campione ogni k per ridurre l'autocorrelazione (solo da citare).

### Media MCMC vs media iid (h22 5b)
Un RWMH ha **correlazione positiva** tra campioni consecutivi ⇒ la media di 500 iterazioni MCMC ha deviazione standard **più grande** di quella di 500 campioni iid ($ESS < 500$). Inoltre, con un valore iniziale lontano, le prime iterazioni non vengono ancora dalla target (burn-in).
**Riconoscere la target dal codice:** in h22 l'accettazione usa `dnorm(x.prop, mean=2, sd=2)` ⇒ target $N(2, 2^2)$; la proposal `x[t-1] + 3*rnorm(1)` ⇒ $N(x_{t-1}, 3^2)$, cioè RWMH.

### Esempi di giudizio (da esami)
- **h25:** RWMH con accettazione 37% e ESS ≈ 4089/20000 ⇒ ben tarato. **Ma** la proposal normale può proporre $\beta < 0$ (supporto $\beta > 0$), che vengono rigettati ⇒ meglio una proposal positiva (log-scale o Gamma).
- **h24:** catena partita da $\theta_1 = 100$ (lontanissimo dalla target), accettazione 0.67, **ESS = 15.7** su 1000 ⇒ inutilizzabile così com'è. Rimedi: burn-in, valore iniziale ragionevole, σ più grande per abbassare l'accettazione verso 20–40%, più iterazioni.
- **h24 c / v24 e:** quale preferire? Independence sampler: ottimo se $r$ approssima bene la target (code più pesanti), pessimo altrimenti. RWMH: più robusto e generale ma correlato. Gibbs con condizionali note: nessun rigetto, ma lento se i parametri sono molto correlati.

### Altri
- **MALA** (Langevin): proposal spinta verso le zone ad alta densità usando il gradiente di $\log g$; accettazione desiderata circa 50–90% (solo da citare).
- **HMC/Stan:** stato dell'arte, non in programma.

---

## 15. Gibbs sampler

*(Lecture notes: `chap11_part3`; formula sheet §9)*

### Idea
Per $\theta = (\theta^{(1)}, \theta^{(2)})$: invece di proporre tutto insieme, aggiorna un blocco alla volta campionando dalla sua **full conditional** $\pi(\theta^{(1)} \mid \theta^{(2)}, x)$. Ogni passo è un MH con accettazione = 1 (nessun rigetto).

### Algoritmo (scriverlo così)
1. Scegli valori iniziali $(\theta^{(1)}_0, \theta^{(2)}_0)$.
2. Per $t = 1,\dots,T$:
   - $\theta^{(1)}_t \sim \pi(\theta^{(1)} \mid \theta^{(2)}_{t-1}, x)$
   - $\theta^{(2)}_t \sim \pi(\theta^{(2)} \mid \theta^{(1)}_t, x)$ ← usa il valore **appena** aggiornato
3. Scarta il burn-in e usa $\{(\theta^{(1)}_t, \theta^{(2)}_t)\}$ come campione (correlato) dalla posterior.

### Come derivare una full conditional
Prendi il **joint posterior kernel** e tieni **solo i fattori che contengono quel parametro** (gli altri diventano costanti). Poi riconosci la forma con le regole del formula sheet §10.

### Esempio (v26): Normale con μ e σ²
$y_i \mid \mu,\sigma^2 \sim N(\mu,\sigma^2)$, $\mu \mid \sigma^2 \sim N(m_0, \sigma^2/\kappa_0)$, $\log\sigma^2 \sim N(0,1)$.
- Joint: $p(\mu,\sigma^2\mid y) \propto (\sigma^2)^{-\frac{n+3}{2}}\exp\left(-\frac{S(\mu) + \kappa_0(\mu - m_0)^2}{2\sigma^2} - \frac{(\log\sigma^2)^2}{2}\right)$, con $S(\mu) = \sum(y_i - \mu)^2$.
  (Fattori: $(\sigma^2)^{-n/2}$ dalla likelihood, $(\sigma^2)^{-1/2}$ dalla prior di μ, $(\sigma^2)^{-1}$ dalla lognormale.)
- $\mu \mid \sigma^2, y$: il log-kernel è quadratico in μ ⇒ $N\left(m_n, \sigma^2/\kappa_n\right)$ con $m_n = \frac{n\bar y + \kappa_0 m_0}{n + \kappa_0}$, $\kappa_n = n + \kappa_0$.
- $\sigma^2 \mid \mu, y$: $\log p = -\frac{n+3}{2}\log\sigma^2 - \frac{K(\mu)}{2\sigma^2} - \frac{(\log\sigma^2)^2}{2}$ ⇒ **non standard** (sarebbe un'inverse-gamma, ma il termine $(\log\sigma^2)^2$ lo impedisce) ⇒ passo **MH** (log-scale RW).
- Algoritmo finale = **Metropolis-within-Gibbs**: alterna μ dalla normale esatta e σ² con un passo MH.

### Riconoscere il Gibbs nel codice (v24)
Due `rgamma(...)` (o `rnorm`) in sequenza dentro il ciclo, ciascuno con parametri che dipendono dall'**altro** parametro, senza passo di accettazione ⇒ Gibbs. Nel traceplot 2D si muove a "scalini" orizzontali/verticali.

### Gibbs efficiente in alta dimensione (v25 h)
1. **Blocking:** aggiorna insieme i parametri molto correlati.
2. Usa condizionali **coniugate/standard** quando possibile, e MH solo dove serve.
3. **Riparametrizzazione** per ridurre la correlazione tra parametri.
4. Buoni valori iniziali, verifica convergenza (traceplot, ESS, più catene).

---

## 16. Come leggere il codice R all'esame (checklist)

Domande tipo "quale implementazione è corretta? Justify" valgono molti punti. Controlla nell'ordine:

1. **Distribuzione e parametri:** `rexp(n, rate)` usa il rate (= 1/β); `rgamma(n, a, b)` → il terzo argomento posizionale è il **rate**; `rnorm(n, mean, sd)` vuole la **sd**, non la varianza.
2. **Intervallo** di `runif(n, min, max)`: è quello giusto per il metodo? (inverse transform → `runif(n)` su (0,1)).
3. **Formula matematica ↔ codice:** esponenti (`^(1/b)` vs `^b`), segni, `log` vs `exp`, fattore $(b-a)$ nel crude MC.
4. **Rapporti invertiti:** IS `g/f` (non `f/g`), AR `f/(c*g)`, MH `target(new)/target(old)`.
5. **Antitetici:** per $U(a,b)$ deve essere `a + b - u`.
6. **Bootstrap:** `replace = TRUE`, `size = length(data)`, ciclo su `1:B`, stesso stimatore.
7. **MSE / IC:** `var` vs `sd`, `+` vs `-`, `qnorm(0.975)` per il 95%.
8. **MCMC:** la proposal dipende da `x[t-1]`? (RW) / fissa? (independence) / si aggiornano blocchi da condizionali? (Gibbs). Il vincolo del supporto è gestito? Si confronta `runif(1) < alpha`?
9. **Vettorizzato vs ciclo:** stesso risultato, diversa velocità (non è un errore).

---

## 17. Cosa scrivere sul foglio A4

Il formula sheet copre già distribuzioni, MLE, algoritmi MH/Gibbs e regole di riconoscimento. **Sul foglio A4 metti quello che manca:**

- **Inverse transform:** passi + inverse di Exp, Weibull, Pareto; nota "$1-U \equiv U$".
- **AR:** passi, $c = \max f/g$, P(accetto) $= 1/c$, E(iterazioni) $= c$.
- **Box–Muller**, lognormale da media/var: $\sigma^2 = \ln(1 + v/m^2)$, $\mu = \ln m - \sigma^2/2$; Cholesky $X = \mu + LZ$.
- **MC:** $\hat\theta = \frac{b-a}{n}\sum g(U_i)$, generalizzato $\frac1n\sum h(X_i)$, $SE = s/\sqrt n$, $n \ge (1.96\sigma/e)^2$.
- **Antitetico:** stimatore, "funziona se h è monotona", $U(a,b) \to a+b-U$, normale $\mu \pm \sigma Z$.
- **IS:** $\frac1n\sum g(X_i)/f(X_i)$, "f simile a g, code più pesanti, supporto che copre A".
- **Bootstrap:** tabella completa (bias, SE, MSE, bias-corrected, IC normale/percentile/basic) + quantili $z$: 1.645 (90%), 1.96 (95%), 2.326 (98%), 2.576 (99%).
- **Poisson:** $N(t)\sim$ Poi(λt), interarrivi Exp(1/λ), $S_k \sim$ Gamma(k, 1/λ), $P(S_k > t) = P(N(t) < k)$, due metodi di simulazione, thinning, $\Lambda(t) = \int\lambda$.
- **Markov:** RW: $E = t(2p-1)$, $Var = t(1-(2p-1)^2)$ ⇒ non stazionario; AR(1) stazionario $N(\mu/(1-\phi), \sigma^2/(1-\phi^2))$ se $|\phi|<1$.
- **Density estimation:** Scott $3.49\,s\,n^{-1/3}$, Sturges, KDE $1.06\,s\,n^{-1/5}$, formula KDE, bias–variance.
- **MCMC:** log-α con proposal lognormale ($+\log\theta^* - \log\theta_{t-1}$), independence Gamma$(n, \hat\theta/n)$, accettazione RWMH 20–40%, ESS > 200, ESS/T < 0.01 = problema, Geweke, Gelman–Rubin < 1.1.
- **Coniugate:** Gamma–Poisson, Gamma–Exp(rate), Normal–Normal (formule della tabella §13).

---

## 18. Piano di studio e mappa argomenti → esami

### Mappa (dagli esami letti)
| Argomento | Esami in cui compare |
|---|---|
| pdf / cdf / momenti | h23, v24, h24, v25, h25, v26 — **sempre** |
| Inverse transform (+ codice R) | h22, v23, h23, h24, v25, h25 |
| Accept–Reject | h22, v24, v25, v26 |
| MC integration + **antithetic** | h22, v23, h23, v24, h24, h25, v26 |
| Importance sampling | h22, v24, v25 |
| CLT, IC, stimatori unbiased (codice R) | h22, v23, v25 |
| MLE, bias, varianza, n necessario | v25, h25 (likelihood anche in h23) |
| Bootstrap (calcoli + codice) | h22, v24, v25, h25 |
| Processo di Poisson HPP/NHPP | h22, v24, h24, h25 |
| Random walk / Markov / stazionarietà | v26 |
| Istogramma / KDE | h23, h24 |
| Trasformazioni (lognormal, χ²) / sistemi | h23, h24 |
| Normale bivariata: Gibbs vs RWMH vs Cholesky | v23 |
| Bayes: posterior kernel | h23, v24, v25, h25, v26 |
| MCMC (RWMH, independence, diagnostica) | h22, v23, h23, v24, h24, h25 |
| Gibbs sampler | v23, v24, v25, v26 |

### Piano consigliato (circa 10 giorni; comprimi se l'esame è prima)
| Giorno | Argomenti (sezioni) | Pratica |
|---|---|---|
| 1 | §1, §2 | Problema 1 di h23, v24, v25; MLE di h25 e v25 |
| 2 | §3, §4, §5 | Inverse/AR di h24, v25, v26 + codici R di h24 |
| 3 | §9, §10 | Integrali di h23, v24, h25 (antithetic + IS), π di v26, h22 Problem 3, v23 Problem 2 e 4 |
| 4 | §11, §12 | Bootstrap h25 (calcoli a mano!), v24, v25 (codice); KDE h23 |
| 5 | §6, §7, §8 | Poisson h24 e h25, random walk v26, sistemi h23 |
| 6 | §13 | Posterior kernel di h23, v24, v25, h25, v26 |
| 7 | §14, §15 | MCMC h24 (4a–d), h25 (h–j), Gibbs v24/v25/v26 |
| 8 | Esame completo a tempo | **v26** (4 ore, senza soluzioni), poi correggi |
| 9 | Esame completo a tempo | **h25**, poi correggi; ripassa i punti deboli |
| 10 | Foglio A4 + ripasso | Scrivi a mano il foglio A4 (§17); rileggi le trappole §16 |

### Consigli finali
- **Scrivi gli algoritmi in passi numerati** con formule: è esattamente il formato richiesto.
- **Giustifica sempre** ("Reason your answer!"): molti punti vanno al *perché* (es. "h è monotona ⇒ Cov < 0 ⇒ varianza ridotta").
- Per i punti numerici (bootstrap, Poisson, probabilità) scrivi prima la formula, poi i numeri: anche con un errore di calcolo prendi punti parziali.
- Se un sotto-punto ti blocca, spesso il successivo dà il risultato ("show that…"): usalo e vai avanti.

---

*Materiale di riferimento nel repo:* `Lecture Notes/` (capitoli citati sopra), `R-examples/`, `Exercises/` + `Solutions/`, `old exams/`, `formula_sheet/tablesformulas.pdf`. Le note HTML per singolo argomento sono in `personal notes/topic-*.html`.
