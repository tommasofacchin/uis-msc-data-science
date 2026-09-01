# DAT540 — Exam Study Guide

> Based on all available past exams: 25H, 23H (+ answers), 22H resit, 21H, sample MCQ 2022.
> Exam format: 40 multiple-choice questions, 1 point each, 0 for wrong/unattempted, no aids allowed.

---

## 1. PYTHON BASICS

### Types and mutability
- **Mutable**: `list`, `dict`, `set` → modified in-place, passed by reference into functions.
- **Immutable**: `tuple`, `str`, `int`, `float`, `frozenset` → **Tuple is the classic answer to "which of these is immutable"**.
- Watch out: a tuple containing a list → the inner list stays mutable (`tuple[0].append(x)` works), but **reassigning** `tuple[0] = x` raises `TypeError: 'tuple' object does not support item assignment`.
- `a = b` on lists → **same object in memory** (alias, not a copy). Modifying `a` also modifies `b`. Use `.copy()` for an independent copy.
- Inside a function: modifying a **list/dict** passed as an argument **modifies the original** (mutable); **reassigning a tuple** inside the function does **NOT** modify the original (immutable → new local binding).

### Slicing (lists, strings, arrays)
- `s[start:stop:step]`. `s[::-1]` → reverses. `s[::-3]` → every 3rd element starting from the end, then `[::-1]` reverses it again.
- Strings: `s[6:][-7:-2]` → chained slices, applied in sequence.
- `list(range(5, -1))` → **empty `[]`** (range without a negative step doesn't count down).

### Set / List / Tuple / Dict
- `set("zzyxx")` → `{'x','y','z'}` (removes duplicates, order not guaranteed).
- `set.add()` on an element already present → **no effect**, no error (no duplicates in sets).
- `dict.values()` → values only; `dict.items()` → (k,v) pairs; `dict.keys()` → keys only.
- `[i[1] for i in d.items()]` ≡ `d.values()` ≡ `list(map(lambda x: x[1], d.items()))` → **all equivalent**.
- Accessing a missing key `dict['x']` → **KeyError** (not None, not empty string).
- `list1.extend(list2)` → merges elements of list2 into list1 (flat). `list1.append(list2)` → adds list2 as **a single element** (nested list). To merge lists: `+`, `extend()`, or `[*a, *b]`.
- `zip(a, b, c)` → stops at the **shortest** list. `list(zip([1,2],[3,4],[5,6,7]))` → `[(1,3,5),(2,4,6)]`.
- List comprehension with `if`: `[x for x in data if cond]` — valid syntax only with a single `if` (no `else` unless using the ternary form `[x if cond else y for x in data]`).

### Try/Except/Else/Finally
- `try` → if **no exception**: runs `else`, then always `finally`.
- `try` → if an exception occurs: runs the first matching `except`, then always `finally`. `else` is **skipped**.
- `finally` **always runs**, even after a `return` inside try/except.
- Order of exceptions matters: a generic `except` placed before a specific one "steals" the exception.

### Scope: global / local / nonlocal
- A variable modified inside a function without `global`/`nonlocal` → creates a **new local variable**, doesn't touch the outer one.
- `global x` inside a nested function (`inner()` inside `outer()`) modifies the **global** variable, not `outer()`'s own variable. Classic example: global `x=5`, `outer()` creates a local `x=10`, `inner()` with `global x; x=15` modifies the global → inside `outer` it still prints 10 (its own local x), outside it prints 15 (the modified global).
- Local variables (e.g. inside a `for`/list comprehension within a function) are not accessible outside the function.

### Useful string operations
- `str.title()`, `str.isupper()`, `str.istitle()`, `'sep'.join(list)`.
- Formatting: `f"{x:.3f}"` and `"{:.3f}".format(x)` are **equivalent** for rounding to 3 decimals. `f"{x}"` alone **does not round**.
- Palindrome check: `s == s[::-1]` (standard and reliable method).

### File I/O
- Read-only opening: `open("file.txt", "r")`, then `.read()`. Mode `"w"` **truncates/overwrites** the file (not suitable for reading). `"a"` = append. `"rw"` is **not a valid mode**.
- Always use `with open(...) as f:` for automatic closing.
- `next(csv_data)` before `csv.reader()` → **skips the first row (header)**.
- `d = list(csv.reader(csv_data))` → **not a writable "live" view of the file** (it's just a plain Python list in memory).

### Casting / common errors
- `int('12.e2')` → **ValueError** (int() doesn't accept scientific notation in a string).
- `float("abc") + 10` → **ValueError**, not TypeError.

---

## 2. NUMPY

### Creation and basic properties
- `np.identity(n)` / `np.eye(n)` → identity matrix (1s on the diagonal, 0s elsewhere) — **not random values**.
- `.size` = total number of elements (product of dimensions). `.shape` = tuple of dimensions. `len(arr)` = length of the **first dimension** only.
- `np.arange()` → evenly spaced values (like `range()` but as an array). `np.random.rand(4,3)` → shape `(4,3)`.
- dtype: with unspecified, heterogeneous arrays → **`object`**; with an explicit `np.uint8`, it stays `uint8` (doesn't upcast to float).

### Indexing and slicing
- Fancy indexing with lists of row/column indices: `arr[[0,2],[1,2]]` → **takes pairs (0,1) and (2,2)**, result is 1D `[val, val]`, NOT a 2D block.
- `arr[[True, False, True]]` → **boolean indexing on rows**, selects only rows marked True.
- Chained indexing `arr[[1,4,2]][:, [0,4,2]]` → first selects rows (in that order!), then columns (in that order!) — the result order follows the order of the given indices.
- `arr[0][2][::2]` on nested lists → applied in sequence: first indexing, then slicing on the resulting list/string.

### Shape / reshape / transpose
- `.reshape()` **doesn't modify in place** unless reassigned (`arr.reshape(10,10)` alone doesn't change `arr.shape`; you need `arr = arr.reshape(...)`).
- `.transpose(axes)`: reorders axes according to the given tuple. E.g. shape `(5,2,4)`, `.transpose(2,0,1)` → new shape `(4,5,2)` (takes the axis indicated at each position).
- `arr.swapaxes(i,j)` swaps two specific axes; equivalent to `transpose` with those two axes swapped and the rest fixed.
- `np.transpose(x)` on a 2D matrix = classic transpose (rows↔columns).

### Aggregate operations (axis)
- `axis=0` → operates **down the rows, per column** (result has as many entries as columns). `axis=1` → operates **across the columns, per row** (result has as many entries as rows).
- `arr.sum(axis=1)` on a 3x3 matrix → sum of each row.
- `np.stack((a,b))` → adds a **new dimension**, result is `[[a],[b]]` (2 separate arrays stacked). `np.concatenate` (default axis=0) → joins along an **existing** dimension **without adding a new one**.
- Broadcasting: array shape (2,3) + array shape (3,) → the row vector is added to **every row** of the matrix (broadcasting valid if trailing dimensions match or one is 1).
- Broadcasting with `/`: array (3,2) divided by array (2,) → divides each row element-wise.

### Sorting / searching
- `np.sort(arr)` → **ascending**, returns a new array (doesn't modify in place unless using `arr.sort()`).
- `np.sort(arr)[::-1]` → descending.
- `.argsort()` → returns the **indices** that would sort the array (used to reorder other linked columns, e.g. `arr[col.argsort()]`).
- `np.count_nonzero(A==0)` counts the True values (elements satisfying the condition) — **equivalent to `np.sum(A==0)`** and to a nested loop with `sum(x==0 for row in A for x in row)`.

### Dot product / linear algebra
- Dot product: `a.dot(b)` ≡ `a @ b` ≡ `np.dot(a,b)` — **all equivalent**.

---

## 3. PANDAS

### Creation and basic access
- `pd.Series([10,20,30], index=['a','b','c'])` ≡ `pd.Series({'a':10,'b':20,'c':30})` — **both valid**. `pd.DataFrame(...)` with an index does not create a Series.
- Label-based access: `s['a']` works if that's the index label. Label-based slicing is **inclusive of both endpoints** (unlike positional slicing).
- `df.head()`, `df.tail()` — there is no `.top()` or `.read().head()`.

### Sorting
- `df.sort_index()` → sorts by **index** (rows). `df.sort_values()` → sorts by the **values** of a column. There is no generic `df.sort()` in modern pandas.

### Merge / Join
- `how='inner'` → only matching keys. `how='outer'` → all keys, NaN where missing. `how='left'` → all rows from the left + matches from the right (NaN if absent). `how='right'` → the symmetric case.
- "All rows from df_left, with NaN if there's no match in df_right" → **`how='left'`**.
- `pd.merge(df1, df2)` without `on` → automatically merges on columns **with the same name**; default `how='inner'`.
- Horizontal join of two DataFrames with aligned indices: `pd.concat([a,b], axis=1)`, `a.join(b)`, `a.combine_first(b)` → **all valid**, depending on the case.

### Data selection / cleaning
- `df.dropna(subset=['a','b'])` → drops rows with NaN **in those specific columns**.
- `df.drop_duplicates(subset=['Name'], keep='first')` → keeps the **first occurrence**, removes later duplicates (`keep='last'` does the opposite).
- `pd.read_csv('file.csv', header=None)` → tells pandas the file **has no header row**, all rows are treated as data (columns numbered 0,1,2...).
- `pd.read_csv('file.csv', nrows=5)` → reads only the first 5 rows (more efficient than `.head()` on a huge file).
- Value mapping: `df['col'].map({...})`, `.replace({...})`, `.apply(lambda x: ...)` → **often all equivalent** for simple cases.
- `pd.cut(df['x'], bins=3)` → **equal-width** bins on the values. `pd.qcut(df['x'], q=3)` → bins with an **equal number of observations** (quantiles). Explicit bins: `pd.cut(df['x'], bins=[0,50,70,100])`.
- `pd.get_dummies()` → **One-Hot Encoding**.

### GroupBy
- `df.groupby(['Region','Team']).sum()` → groups by **combinations of both columns** (multi-index), different from `groupby('Region')['Points'].sum()` which groups by Region only.
- The order of columns in `groupby([...])` determines the order of the resulting multi-index.
- `groupby(lambda x: ...)` **groups by index** (applies the function to the index values, not the column values).
- `.describe()` on a numeric group → count, mean, std, min, **quartiles**, max — all reported together.

### Apply / functions on Series/DataFrame
- `.apply(f)`, `.map(f)` on a Series → valid. `.applymap(f)` → for DataFrame element-wise (on a Series it is **not valid/doesn't exist** in recent versions — this is the "wrong" function in trick questions).
- `df.pipe(np.sum)` on a DataFrame → result is a **pandas Series** (sum per column), not a DataFrame or an ndarray.
- `df.mean()` (default axis=0, per column) ≡ `df.apply(np.mean)` → **equivalent**; `df.mean(axis=1)` is different (per row).

### Time series (datetime)
- `pd.date_range(start=..., periods=5, freq='D')` → 5 consecutive daily dates, `dtype='datetime64[ns]', freq='D'` **included in the output**.
- `.shift(n)` → shifts values **forward** by n periods (not the dates); `.shift(-n)` → **backward**. With `freq='H'` it shifts the time index itself instead of just the values.
- `.rolling(window=3).mean()` → moving average: average of the **last 3 consecutive observations** (sliding window), to smooth short-term fluctuations.
- `.resample('M').mean()` → re-aggregates by frequency (e.g. monthly) and computes the mean — the standard recommended method (preferable to `groupby(dt.to_period())`, though both can work).
- `tz_convert()` → converts an **already localized** timestamp from one timezone to another. `tz_localize()` → assigns a timezone to a naive timestamp.
- `df.to_pickle()` → saves a DataFrame in pickle format. `pd.read_json()` → converts a JSON string into a pandas object.

### Advanced indexing
- `df.loc[]` → by **label** (label-based, includes the upper bound in slicing). `df.iloc[]` → by **integer position** (excludes the upper bound, like normal Python slicing).

---

## 4. VISUALIZATION (Matplotlib / Seaborn)

- `fig.add_subplot(2,2,i)` for i=1..4 → **2×2** grid (4 plots arranged like a square), not stacked vertically.
- `plt.hist(data, bins=N, color=..., edgecolor=...)` → histogram; to change **which variable is displayed**, just change the column passed as data (not the styling parameters).
- `plt.scatter(x, y)` → relationship between two numeric variables; to change which variables are compared, swap the x/y arguments.
- **Histogram** → distribution of **a single numeric variable** (standard answer, not scatter/bar/stacked bar).
- `sns.boxplot(x='cat', y='num', data=df)` → boxplot showing the **spread (distribution)** of the numeric variable for each category.
- `sns.heatmap(df.corr(), annot=True, cmap='coolwarm')` → correlation map. A **positive** correlation → as one variable increases, the other tends to increase too (usually a warm/red color toward 1; do NOT tie a specific color to "positive" without checking the scale).
- `df.groupby('cat')[[...]].plot(kind='bar', stacked=True)` → stacked bars: the **total bar height** is the sum of the values (not the average); each colored segment is a different attribute.
- `sns.FacetGrid(df, col='CategoryX')` + `g.map(plt.hist, 'Variable')` → **separate histograms for each category value** (one per column). The correct parameter is `col=` on the categorical variable, mapping `plt.hist` onto the numeric variable.
- `add_patch()` → adds **geometric shapes** (rectangles, circles) to a plot, not lines/histograms.

---

## 5. MACHINE LEARNING (theory)

### Supervised vs Unsupervised
- **Supervised**: learns from **labeled** data (e.g. classification, regression).
- **Unsupervised**: no labels, e.g. **clustering** ("grouping customers by spending habits" = unsupervised).
- Classification = **discrete/categorical** output; Regression = **continuous** output.

### Overfitting / Underfitting / Bias-Variance
- **Overfitting**: **low** training error, **high** test error (the model "memorized" instead of generalizing). Overly jagged/complex decision boundary.
- **Underfitting / High bias**: training error and test error are **both high** (model too simple, low variance but high bias). Decision boundary too simple (e.g. linear on non-linear data).
- Good fit: both training and test error low, "reasonable" curve (neither too simple nor too jagged).
- **Train-test split**: separates data into two sets to train the model on one and evaluate it on the other (to avoid overly optimistic/overfit evaluations).

### Regularization
- **L2 (Ridge)**: penalizes **large weights** to reduce overfitting (doesn't remove outliers, doesn't normalize features).

### Neural networks
- Activation functions **in hidden layers**: **Sigmoid, ReLU, tanh** (not MSE, which is a loss function, not "linear" for hidden layers).
- **Backpropagation**: computes the **gradient of the loss function** and updates the weights (doesn't initialize weights, doesn't normalize input).
- Output layer for **binary** classification: **1 single neuron with Sigmoid** is the standard approach (Softmax typically requires more neurons, one per class).
- Number of output neurons for multi-class classification with **K distinct classes** = K neurons (e.g. 2 classes "good"/"bad" with a one-hot-ish approach → **2 output neurons**; number of input neurons = number of numeric features used, e.g. 6 numeric columns → 6 input neurons).

### Scikit-learn
- `.fit(X, y)` → **trains the model** on the input data (doesn't transform, doesn't evaluate, doesn't select features).

---

## 6. RECURRING TRICKS TO REMEMBER

1. **"All of the options" / "None of the options"** show up frequently as the correct answer — don't dismiss them upfront, evaluate every single alternative.
2. When multiple code snippets (A, B, C…) seem to do the same thing, the answer is often **a combination** ("A and B", "B and C") — read every line of code carefully, paying attention to variable names and parameters.
3. Watch for **case-sensitivity** in method names (`applymap` vs `apply` vs `map`) and parameters that look plausible but are wrong (e.g. `df('cn')` instead of `df['cn']` — not valid).
4. Many NumPy questions test the difference between **axis=0 and axis=1** — mentally sketching the matrix always helps.
5. Questions on `try/except/else/finally` → always trace execution line by line, **finally always runs**.
6. When code uses `global` inside nested functions, the keyword always refers to the **global** variable, never to the enclosing (intermediate) function's variable.

---

## Practical exam notes
- 40 MCQ questions, 1 point each, **0 points for a wrong or unanswered question** (no negative penalty beyond zero).
- No support material allowed (double-check the specific rules for the current year though — they changed between 22H "all aids allowed" and 23H/25H "no aids").
- Confirmed recurring topics across recent exams: Python basics (lists/tuples/dicts/sets, scope, try-except), NumPy (indexing, axis, reshape/transpose, sorting), Pandas (merge, groupby, datetime/resample/rolling, apply/map), Matplotlib/Seaborn (histograms, scatter, boxplot, heatmap, FacetGrid), ML theory (bias-variance, overfitting, regularization, basic neural networks).
