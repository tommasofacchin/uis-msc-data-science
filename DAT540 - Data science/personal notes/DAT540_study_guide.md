# DAT540 — Study Guide (short version)

**Exam:** 3 h, 40 multiple-choice questions, 1 point each, 0 if wrong or blank (no penalty, so **always answer**). **No aids allowed.**
**Sources:** 25H (with solutions), 23H (with answers), 22H resit, 2022 MCQ sample.

**Topic weight (approx., from 25H):** Pandas ~15 questions · Python basics ~10 · NumPy ~7 · ML theory ~6 · Plotting ~2

---

## 1. Python basics
| Question type | Answer |
|---|---|
| Which is immutable? | **tuple** (also str, int). list/dict/set are mutable |
| `set("zzyxx")` | `{'x','y','z'}` (duplicates removed) |
| `d['missing']` | **KeyError** |
| `list(zip([1,2],[3,4],[5,6,7]))` | `[(1,3,5),(2,4,6)]` (stops at the shortest) |
| `a.append(b)` vs `a.extend(b)` | append adds b as **one nested element**; extend adds its elements one by one |
| `b = a` (list) | same object: changing one changes the other |
| `list(range(5,-1))` | `[]` |
| `try/except/else/finally` | `else` runs only if there was **no** exception; `finally` **always** runs |
| `global x` inside a nested function | changes the **global** x, not the enclosing function's x |
| Round to 3 decimals | `f"{x:.3f}"` and `"{:.3f}".format(x)` (plain `f"{x}"` does **not** round) |
| `int('12.e2')`, `float('abc')` | **ValueError** |
| File modes | `'r'` read, `'w'` overwrite, `'a'` append; `'rw'` is invalid |

## 2. NumPy
| Question type | Answer |
|---|---|
| `.size` / `.shape` / `len()` | total number of elements / tuple of dims / length of the first dim |
| `np.identity(n)` | ones on the diagonal, zeros elsewhere |
| `arr[[0,2],[1,2]]` | picks the pairs (0,1),(2,2) → **1D** `[20, 90]` |
| `arr[[True,False,True]]` | rows 0 and 2 |
| `axis=0` / `axis=1` | per **column** / per **row**. `[[1,2,3],[4,5,6],[7,8,9]].sum(axis=1)` = `[6,15,24]` |
| Broadcasting (2,3)+(3,) | the vector is added to **every row** |
| Swap first & last axis of shape (2,3,4) | `transpose(2,1,0)` **and** `np.swapaxes(arr,0,2)` |
| `transpose(2,0,1)` on (5,2,4) | (4,5,2) |
| `arr.reshape(...)` alone | does **not** change arr (you must reassign it) |
| `np.stack` vs `np.concatenate` | stack adds a **new** axis; concatenate joins along an existing one |
| `a.dot(b)`, `a @ b`, `np.dot(a,b)` | all the same |

## 3. Pandas
| Question type | Answer |
|---|---|
| Series with index a,b,c | `pd.Series([..], index=[..])` **and** `pd.Series({'a':..})` |
| Sort by index / by values | `sort_index()` / `sort_values()` (no `df.sort()`) |
| Keep all rows of the left df, NaN if no match | `how='left'` |
| `df.mean()` (per column) | same as `df.apply(np.mean)`; `mean(axis=1)` is per row |
| `groupby(['Region','Team']).sum()` | MultiIndex Region→Team (the order of the list = the index order) |
| `groupby(lambda x: ...)` | groups by the **index**, not by the values |
| `read_csv(header=None)` | the file has no header; every row is data |
| `drop_duplicates(subset=[c], keep='first')` | keeps the first occurrence |
| Map values | `.map({..})`, `.replace({..})`, `.apply(lambda)` → **all** work |
| `pd.cut` / `pd.qcut` | equal-**width** bins / equal-**count** bins (quantiles) |
| `get_dummies` | one-hot encoding |
| `loc` / `iloc` | label (end **included**) / position (end excluded) |
| JSON / pickle | `pd.read_json()` / `df.to_pickle()` |
| `date_range(start, periods=5, freq='D')` | 5 consecutive days, the output shows `freq='D'` |
| `shift(2)` / `shift(-2)` | values forward / **backward**; with `freq=` the index moves instead |
| `rolling(3).mean()` | moving average of the last 3 values (smoothing) |
| `resample('M').mean()` | monthly aggregation |
| `tz_localize` / `tz_convert` | assign a timezone / convert between timezones |

## 4. Plotting
- `add_subplot(2,2,i)` → a **2×2 grid**
- Distribution of one numeric variable → **histogram**
- Relationship between two numeric variables → scatter; spread per category → `sns.boxplot`
- `sns.heatmap(df.corr(), annot=True)` → correlation map
- Stacked bar → total height = **sum** of the segments
- `sns.FacetGrid(df, col='cat').map(plt.hist, 'num')` → one histogram per category

## 5. ML theory
| Question type | Answer |
|---|---|
| Unsupervised example | clustering (e.g. grouping customers by spending) |
| Classification / regression | discrete output / continuous output |
| Overfitting | **low train error, high test error** |
| High bias (underfitting) | poor results on **both** train and test |
| L2 / Ridge | penalizes large weights to reduce overfitting |
| Hidden-layer activations | Sigmoid, ReLU, tanh |
| Backpropagation | computes the gradient of the loss and updates the weights |
| Binary output layer | 1 neuron + sigmoid |
| `.fit(X, y)` | trains the model |

## 6. Exam tricks

### Patterns in the answer keys (23H + 25H)
| Option type | How often it was correct | What to do |
|---|---|---|
| **"All of the options" / "All above"** | **6 out of 7** times | If you can confirm that 2 of the snippets work, pick "All" |
| **Combinations** ("1&3", "A&B", "A and B and D") | very often (25H Q4, Q9, Q16, Q34) | Test **each** snippet on its own, then pick the combination that matches |
| **"None of the options"** | **almost never** (0 out of ~10 in 23H) | Pick it only if you have **ruled out** every other option |
| **"Error" / "Raises ..."** | correct only when there is a real bug | Look for: a missing dict key → KeyError, `tuple[0] = x` → TypeError, a function's local variable used outside it → NameError |

### Distractors that are almost right
- **Brackets and dimensions:** `[20, 90]` vs `[[20, 90]]`, `[67 58]` vs `[[67 58]]`. Fancy indexing with 2 lists gives a **1D** result; boolean indexing on rows keeps it **2D**.
- **Missing details in the output:** two `DatetimeIndex` options can be identical except for `freq='D'`. The correct one shows it.
- **Fake methods:** `df.sort()`, `df.top()`, `df.read()`, `pd.load_json()`, `df.save_pickle()`, `list.push()`, `shift(window=3)`, `resample('monthly').average()`, `open(..., 'rw')`.
- **Same name, different parameter:** `sort_index()` vs `sort_index(axis=1)`, `shift(-2)` vs `shift(-2, freq='H')`, `groupby(['A','B'])` vs `groupby(['B','A'])`, `cut` vs `qcut`, `keep='first'` vs `keep='last'`.
- **Character counting:** check whether **spaces** and **upper/lower case** are counted separately (`'E'` ≠ `'e'`).

### When two answers both seem right, pick the "standard" one
- Monthly mean → `df.resample('M').mean()` (not `groupby(dt.to_period)`)
- Binary classification output → **1 neuron + sigmoid** (inputs = number of numeric features)
- Read a file → `with open("f", "r") as f: f.read()`

### Method for code questions
1. Write down every variable's value **line by line**. Don't guess the output from memory.
2. **NumPy:** sketch the matrix; `axis=0` = down the columns, `axis=1` = across the rows.
3. **try/except:** no exception → `else`; then `finally` **always** runs.
4. **Scope:** `global` → the module-level variable; a reassigned tuple doesn't change outside the function, but a modified list or dict does.
5. **Slicing:** apply chained `[ ][ ][::2]` operations one at a time, left to right.

### Time
- 3 h for 40 questions ≈ **4 min each**. Do the theory questions first (≈30 s each), then the code-tracing ones.
- Blank answers score 0, the same as wrong ones, so **never leave an answer blank**.
