# DAT515 — Cloud Technologies (Fall 2026)

Course overview for exam/logistics purposes. Study material lives elsewhere in this folder.

Course website: https://dat515.github.io/#/ (source of the schedule/policy info below; run by `dat515-2026` org, separate from the official UiS course page)

## Facts

| | |
|---|---|
| Subject code | DAT515 |
| ECTS | 5 |
| Semester | Autumn (Fall 2026) |
| Language | English |
| Duration | 1 semester |
| Exam form | Report (group project: code + documentation) |
| Weight | 1/1 |
| Grading | Letter grades (A–F) |
| Official exam system | Canvas (final report) — but all lab code/CI runs through **QuickFeed**, not Canvas |

## People

| Role | Name |
|---|---|
| Course coordinator | Hein Meling |
| Study program manager | Tomasz Wiktorski |
| Head of Department | Tom Ryen |
| Laboratory Engineer | Jayachander Surbiryala |

Guest lecturers (2026): Vinay Setty (Factiverse / UiS), Shubham Mishra (UC Berkeley).

## Prerequisites

- **Required:** none
- **Recommended:** Communication Technology 1 (DAT230), Information and Software Security (DAT250), Operating Systems and Systems Programming (DAT320)

## Tools & platforms

- **Go** — main programming language for the labs
- **Docker** — containerization
- **Kubernetes (Talos)** — orchestration, own cluster setup in Lab 5
- **Terraform** — infrastructure as code (guest lecture topic)
- **REST & gRPC** — API/networking lab
- **Git + GitHub** — all submissions; personal repo `username-labs` (fork of `assignments`) or a group repo, under the `dat515-2026` GitHub org
- **QuickFeed** (https://uis.itest.run/) — automated testing/grading of labs, feedback, slip-day tracking
- **Discord** — course communication, TA lab approval (`/approve` via helpbot), support

## Lecture plan (2026, subject to change — check the site)

| Week | Date | Topic | Lecturer |
|---|---|---|---|
| 34 | Aug 17 | Introduction to Cloud Computing | Hein |
| 34 | Aug 20 | Cloud APIs and Microservices Concepts | Hein |
| 34 | Aug 20 | Introduction to Go Programming (lab) | Hein |
| 35 | Aug 24 | DevOps: Best Practices | Hein |
| 35 | Aug 25 | Virtualization and Containers | Hein |
| 35 | Aug 27 | Docker | Hein |
| 36 | Aug 31 | Serverless Computing | Hein |
| 36 | Sep 1 | Guest: Factiverse & Terraform | Vinay Setty |
| 36 | Sep 3 | Kubernetes: Container Orchestration | Hein |
| 36 | Sep 3 | Talos Lab Intro (lab) | Jayachander |
| 41 | Oct 5 | Guest: UC Berkeley (PirateShip / Smaran) | Shubham Mishra |

Lectures run in the **first half of the semester**; workload shifts to labs/project afterward.

## Lab plan & deadlines (2026)

| Lab | Topic | Grading | Approval | Submission | Deadline |
|---|---|---|---|---|---|
| 1 | Unix Basics and Command Line Tools | Pass/fail | Automatic | Individual | Aug 23 |
| 2 | Introduction to Go Programming | Pass/fail | Automatic | Individual | Aug 30 |
| 3 | Network Programming with REST and gRPC | Pass/fail | TA approval | Individual | Sep 6 |
| 4 | Getting Started with Docker | Pass/fail | TA approval | Individual | Sep 13 |
| 5 | Talos Kubernetes Cluster Setup | Pass/fail | TA approval | Individual | Sep 27 |
| 6 | Design Document for Course Project | Pass/fail | TA approval | Group | Oct 4 |
| 7 | Course Project | **A–F** | Teachers | Group | Nov 8 |
| 8 | Project Presentation Video | Pass/fail | Automatic | Group | Nov 11 |

Lab 6 approval unlocks a **project mentor** for the group. Lab 7 (the graded project) is assessed from code + report + Q&A + the Lab 8 presentation video, against a checklist in the assignment repo.

## Assessment structure

**Mandatory assignments (Labs 1–6)** must all be completed/approved to qualify to submit the final report and pass the course. Missing a deadline without slip days = course failure.

**Group project (Lab 7, graded A–F)**
- All group members get the **same grade**; must document individual contributions
- Deliverables: working cloud application, documentation (full run/setup/test instructions, install as automated as possible), and a **YouTube video ≤ 10 minutes** showcasing the project
- **No resit** — if you fail the project/assignments/presentation, you retake everything next time the course runs

**Group size:** official course description says 2–4 students; the course site's policy says groups of 2–3 (2 preferred, 3 allowed). Confirm current guidance with the teaching staff/QuickFeed before forming a group.

## Lab approval

- **Automatic**: QuickFeed approves once enough tests pass (Labs 1, 2, 8)
- **TA approval** (Labs 3–7): present and explain your solution to a TA, in person or via Discord (request with `/approve` in the helpbot — no DMs). Each group member must present individually.
- If approval is denied: 1 extra attempt per lab, max 3 extra attempts total across the course.

## Slip days

- **10-day pool**, shared across the whole course, weekends/holidays count against it
- Cannot be used on the **final mandatory deadline** for a lab
- Delays in the approval queue itself don't cost slip days

## AI use policy

- AI tools are **permitted and encouraged** as a learning/engineering aid — no disclosure required
- You must be able to explain everything you submit (design choices, code, config); don't submit anything you can't explain or that isn't yours
- **Not allowed during assessments** unless teaching staff explicitly says otherwise
- Don't feed personal/confidential/other students' data to external AI services

## Group policy notes

- Individual assignments: no joint hand-ins, no sharing solutions/code with other students
- If a group isn't functioning (unequal contribution etc.), it can be dissolved and members graded **individually** — flag issues to teaching staff early

## Signup checklist

1. Create/use a GitHub account
2. Register on QuickFeed (https://uis.itest.run/) via GitHub login, then enroll at `uis.itest.run/dat515`
3. Wait for teaching staff to confirm enrollment → get repo access under `dat515-2026`
4. (If working in a group) create the group on QuickFeed — **group/repo name can't be changed later**
5. Join the course Discord: https://discord.gg/aZnhMFMH6Z

## Working methods & workload

- 4h lectures + 4h supervised lab per week (first half of semester), plus unsupervised lab/project work
- Expected total workload incl. self-study: **~15 hours/week**
