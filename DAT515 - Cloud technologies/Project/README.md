# Lab 7: Course Project

| Lab 7:           | Course Project             |
| ---------------- | -------------------------- |
| Subject:         | DAT515 Cloud Computing     |
| Deadline:        | **November 8, 2026 23:59** |
| Expected effort: | 30-40 hours                |
| Grading:         | A-F                        |
| Submission:      | Group                      |

## Table of Contents

- [Table of Contents](#table-of-contents)
- [Required Deliverables](#required-deliverables)
  - [1. Approved Design (design.md)](#1-approved-design-designmd)
  - [2. Codebase](#2-codebase)
  - [3. Reproducibility Report (report.md)](#3-reproducibility-report-reportmd)
  - [4. Contribution Records](#4-contribution-records)
- [Sanity Pre-checks](#sanity-pre-checks)
- [5. Q\&A Session](#5-qa-session)

The course project is a practical application of the cloud concepts covered in
the course. Choose a scope that fits your group and prioritize a small, working,
reproducible system over a long list of partially implemented features.

The teachers grade the technical work using the [project evaluation
checklist](checklist.md). The report, repository, Q&A, and the presentation video
submitted in [Lab 8](https://github.com/dat515-2026/assignments/tree/main/8youtube)
provide the evidence used in that assessment.

## Required Deliverables

### 1. Approved Design (design.md)

The approved `design.md` from Lab 6 remains part of the project requirements;
summarize material changes from the plan in `report.md`.
You should not update the design document after approval.

### 2. Codebase

Submit all source code, infrastructure configuration, tests, and scripts needed
to build and deploy the system. **Keep the repository focused:** remove unused
starter files, generated artifacts, abandoned experiments, and template text.
**Do not commit** binary files, credentials or other secrets.

The implementation should deliver the core goals agreed with your mentor and
demonstrate meaningful cloud deployment or operations work. Optional features
help only when they are complete, integrated, and verified.

### 3. Reproducibility Report (report.md)

Use the provided `report.md` template to give an evaluator a short path from a
clean checkout to a verified deployment. Include only information needed to:

- identify the delivered scope and any material changes from `design.md`;
- configure, build, test, deploy, verify, and use the system with exact commands;
- find evidence for important claims; and
- understand known limitations or actual troubleshooting advice.

Do not duplicate general background or architecture already explained in
`design.md`. Remove all template instructions and examples before submission.

### 4. Contribution Records

Complete `contributions.md` and `hours.csv`. These are required accountability
records and do not earn points. Contributions must identify concrete outcomes
and link to commits, pull requests, files, or other verifiable evidence. Keep the
hour sheet accurate and in the supplied CSV format so it can be checked
consistently across groups. Use the same full name in both files. If a member's
Git author name is different, record that identity in their self-assessment.

The submission must accurately represent what works. Every group member is
responsible for reviewing and understanding submitted code and configuration,
including work produced with AI assistance. See the [course
policy](https://dat515.github.io/#/policy) for the rules on collaboration and generative
models.

## Sanity Pre-checks

Each push runs lenient QuickFeed checks for missing or unchanged templates,
basic report content, valid hour records, and the presence of implementation,
deployment, and test artifacts. These checks help the group and TA find obvious
omissions; they do not determine the project grade or prove that a feature works.

When Git history is available, the checks also compare recent commit identities
and dates with `hours.csv`. Identity mismatches or commits newer than a member's
latest hour entry are printed as **signals only** and never fail the test. Review
the records when a signal is reasonable, and disregard it when pair work, Git
configuration, or another documented circumstance explains the difference.

## 5. Q&A Session

The Q&A lasts approximately 15 minutes and all group members must attend. Time
and place will be announced on Discord. Each member must be able to demonstrate
their own contribution and explain the main system design, deployment, and
verification choices. Remote participation requires advance agreement with the
teaching staff. The presentation video is submitted separately in
[Lab 8](https://github.com/dat515-2026/assignments/tree/main/8youtube), three 
days after the project deadline.
