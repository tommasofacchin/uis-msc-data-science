# DAT540 — Introduction to Data Science (Fall 2026)

Course overview for exam/logistics purposes. Study material lives elsewhere in this folder (see [Sample exam questions/exam summary.md](Sample%20exam%20questions/exam%20summary.md) for topic-level review).

Note: Canvas lists the course as "DAT540-1 26H Introduction to Computer Science", but the course homepage itself states the name is **Introduction to Data Science (DAT540)** — treat "Introduction to Computer Science" as a Canvas labeling glitch.

## Facts

| | |
|---|---|
| Subject code | DAT540 |
| Semester | Autumn (Fall 2026) |
| Final grade | **Group project: 60%** + **Written exam: 40%** |

## People

| Role | Name |
|---|---|
| Lecturer | Mina Farmanbar — mina.farmanbar@uis.no |
| Teaching Assistants | TBA on Canvas |

**Communication policy:** ask questions via Canvas first. If no answer within 48 hours, email — and CC Mina Farmanbar on any email sent to a TA/SA.

## Course design & schedule

- **Lectures:** Tuesdays 08:15–10:00 @ KE D-301, and Wednesdays 10:15–12:00 @ KE E-162
- **Labs:** Wednesdays 12:15–16:00 @ KE D-302 (practice exercises)

### Weekly plan (2026)

| Week | Dates | Topic area | Notes |
|---|---|---|---|
| 34 | 17 Aug | Python basics, data structures, libraries, filesystem/OS, functions | Tue: UiS Aerospace talk 09:15; Wed: ION Racing talk 11:15 |
| 35 | 24 Aug | NumPy: ndarrays, ufuncs, RNG | |
| 36 | 31 Aug | NumPy: advanced array ops, linear algebra, broadcasting, random walk | |
| 37–39 | 7–27 Sep | Pandas: Series/DataFrame, descriptive stats, I/O, merging/reshaping, cleaning, wrangling | |
| 40 | 28 Sep | — | **No lectures, no lab** |
| 41 | 5 Oct | GroupBy, pivot tables, plotting (Matplotlib/Seaborn) | **Project group sign-up: 10 Oct** |
| 42 | 12 Oct | Time series, intro ANN classification, KMeans clustering | **Project topics announced: 17 Oct** |
| 43 | 19 Oct | ML intro: bias/variance, over/underfitting, regression, classification (KNN/ANN/SVM), clustering, CNNs (optional) | **Last lecture week.** Project groups **hard deadline: 24 Oct** |
| 44 | 26 Oct | Written exam review | Weeks 44–46: self-study / group project work |

## Assessment structure

### Written exam — 40%
Reviewed in week 44; date/format TBD via Canvas. Past papers + a study summary are in [Sample exam questions/](Sample%20exam%20questions/).

### Group project — 60%
- **Groups of 5**, sign-up via shared spreadsheet; each group assigns its own group leader (teamwork/coordination)
- You can request consultation with the project coordinator (e.g. on visualization plan, ML technique choice, features/target, metrics)
- Every group works on a distinct real-world dataset and must go through the full data-science workflow: research question → EDA/cleaning/preprocessing → model selection & training → evaluation → reporting

**Deliverables (3 components):**
1. **Notebook/code** — data exploration (initial review, cleaning, ≥3 meaningful plots, preprocessing, feature selection), model selection (justification, ≥3 models tested, clear research question), training (correct split/normalization, reported metrics), validation (appropriate metrics, tuning evidence, tested on unseen data)
2. **Written report** — max **4 pages**: structure/clarity, problem definition, method summary, results & insights, conclusion
3. **Video** — **10–12 minutes**, focused on explaining/walking through the code (not repeating the report): implementation decisions, model coding & training, interpreting outputs

Submission is online; exact week/due date to be announced on Canvas.

### Project registration & submission (Canvas announcement)

> Supersedes the deliverables above where they differ (e.g. presentation instead of video).

**Registration**
- Register your group for one of the projects in the [project list](https://stavanger.instructure.com/courses/18282/files/2348176?wrap=1) via the [registration spreadsheet](https://docs.google.com/spreadsheets/d/1cc2unvWxBzN4KUGwAJgu7yJy53xrUVjc7Mf7UT29-vU/edit?usp=sharing).
- Any of the **seven projects** can be chosen, but the **first three** are recommended — the other four are more advanced.
- A **self-proposed topic** is allowed only if **discussed with and approved by the instructor in advance**.

**Deadlines**
- Project submission: **20 November**
- Oral examination: **third week of November**

**Deliverables**
- **Jupyter Notebook** — well-documented, with the complete code and analysis.
- **Report** — research-style, using the [IEEE Conference Template](https://pt.overleaf.com/latex/templates/ieee-conference-template/grfzhhncsfqn?v=1.0). Must clearly state the **contribution of each group member**. Include a public GitHub repo link if available, otherwise submit the code together with the report.
- **PowerPoint presentation** — designed for **10 minutes**.

**Presentation**
- **10 minutes** total; **all group members must attend**.
- Each member speaks for about **2 minutes**.

**Originality & generative AI**
- The submission must be **entirely original and authored by the group** — no copying or reusing code from the internet or other sources.
- GenAI may be used for **debugging and understanding errors** only; it **must not write the project code**.
- Every member should be able to explain and defend all code, methods, analyses and results.

## Reference material already in this repo

- `DAT540 Project Guidelines.pdf` — full grading rubric for the project
- `Sample exam questions/` — past exams + solutions (22H–25H) and a study summary
- `LECTURES 26H/`, `Laboratories 26H/` — study material
