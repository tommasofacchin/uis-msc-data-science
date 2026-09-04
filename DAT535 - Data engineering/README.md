# DAT535 — Data Engineering (Fall 2026)

Course overview for exam/logistics purposes. Study material lives elsewhere in this folder.

## Facts

| | |
|---|---|
| Subject code | DAT535 |
| ECTS | 5 |
| Semester | Autumn (Fall 2026) |
| Language | English |
| Duration | 1 semester |
| Exam system | Canvas |

## People

| Role | Name | Notes |
|---|---|---|
| Lecturer / course coordinator | Tomasz Wiktorski | Adjunct Professor at UiS, Aker BP. Office KE E426, office hours by request |
| Lab engineer (responsible for labs/project) | Jayachander Surbiryala | Head Engineer, office KE D424 |
| Head of Department | Tom Ryen | |

## Course plan

Runs September–October, with some project work possibly extending into November.

**Module 1 — Foundations and Architecture**
- Data Engineering foundations and evolution
- Medallion Architecture and the Data Engineering Lifecycle
- Industrial Data Engineering (guest lectures)

**Module 2 — Data Processing with Apache Spark**
- Data Ingestion & Bronze layer
- Data Cleaning & Silver layer
- Data Aggregation & Gold layer

**Module 3 — Automation, Operations and Governance**
- Governance, Security and Compliance
- Automation, Monitoring and Reliability

### Weekly rhythm
- Lectures + group work: primarily **Fridays**
- Labs: primarily **Mondays**
- September: lecture-heavy. October: more group/project work.
- Schedule subject to adjustments — check Canvas/timetable for the current week.

### Key dates (2026)

| Date | Event |
|---|---|
| Week 38 (14–18 Sep) | Schedule adjusted — lecturer at a conference |
| 18 Sep | Guest lecture — Industrial Data Engineering |
| 25 Sep | Guest lecture — Industrial Data Engineering |
| 5–9 Oct | **Fall break** — no lectures, extra labs offered to advance projects |
| 2 Oct | Guest lecture — Equinor (Governance, Security & Compliance) |
| 16 Oct | Guest lecture — Zaptec (Automation, Monitoring & Reliability) |
| End of October | **Project presentations** (exact date depends on number of groups) |

Guest lecture series (18 Sep – 16 Oct) hosted by: Equinor, Zaptec, Lærdal Medical, Cognite, Reduzer.

## Tools & tech stack

- **Apache Spark** (incl. Spark SQL) — main processing engine
- **Medallion Architecture** (Bronze → Silver → Gold)
- Big data ecosystem referenced in the course: Hadoop, Kafka, Delta Lake, NoSQL databases
- **GitHub Actions** — used to deploy/automate the project pipeline
- **Canvas** — assignments, materials, exam submission
- **Wayground** (formerly Quizizz) — in-class quizzes/polls

## Course materials

- Main book: *Fundamentals of Data Engineering* (Reis & Housley)
- Supplementary:
  - *Data-Intensive Systems – Principles and Fundamentals using Hadoop and Spark* (Wiktorski)
  - *Designing Data-Intensive Applications* (Kleppmann)
  - *Learning Spark – Lightning-Fast Data Analysis*, 2nd ed.
- Lecture slides + materials on Canvas (full syllabus in Leganto)

## Assessment & exam structure

**Step 1 — Coursework requirements (must pass to unlock the project)**
- 3 mandatory assignments (programming + systems administration), done **individually**
- All must be passed by the deadline
- Passing them only grants access to the project **in the current semester** — no carry-over
- Mandatory lab sessions happen at assigned times/groups; report absences (illness etc.) to lab staff ASAP — alternate timing isn't guaranteed

**Step 2 — Project (graded, counts 1/1 of the final grade)**
- Done in **groups**
- Official duration: 6 weeks (course description) — slides describe project work spanning ~8 weeks including the labs that build toward it
- Grading: letter grades (A–F)
- Aids allowed: all
- Submission/exam system: Canvas
- **Oral presentation required — all group members must take part**
- No resit for the project; if you fail, you retake it the next time the course runs

**AI use disclosure**
- If you use AI tools for the assessment, you must fill in and submit the self-declaration form
- Submitting AI-generated text/work as your own = considered cheating

## Project summary

- **Goal:** build a Medallion Architecture pipeline with Spark (Bronze → Silver → Gold), deployed via GitHub Actions
- **Scope:** batch processing only — streaming/orchestration tools are optional, not required
- **Deliverables:** Spark scripts, a report, and a short presentation
- Full spec: Canvas assignment

## Prerequisites

- **Required:** Python programming
- **Recommended:** Databases (DAT220), Operating Systems & Systems Programming (DAT320), Cloud Technologies (DAT515), Bash scripting, cloud/container environment administration, SQL

## Overlap

| Course | Reduction |
|---|---|
| Data-Intensive Systems (DAT500_1) | 5 ECTS |

## Logistics notes

- Lectures (regular + guest) are optional but recommended.
- **Labs and group project work are on-campus only** — no remote participation; F2F attendance required.
