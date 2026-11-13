# Project Evaluation Checklist

The project is graded on a 100-point scale. The rubric rewards a working,
well-validated cloud system and sound engineering judgment.

## Required Submission Items (No Points)

All items below must be completed before the final grade is assigned:

- [ ] The approved `design.md` from Lab 6 is present.
- [ ] The complete source, tests, deployment configuration, and required scripts
      are present in the repository.
- [ ] Secrets, binary files, and irrelevant template or generated files must
      not be present in the repository.
- [ ] `report.md` contains working reproduction and verification instructions.
- [ ] `contributions.md` contains an evidence-backed self-assessment for every
      group member.
- [ ] `hours.csv` contains an accurate hour sheet for every group member.
- [ ] The required presentation video is submitted in Lab 8.
- [ ] Submitted code and configuration, including AI-assisted work, have been
      reviewed and tested and can be explained by the group.
- [ ] All group members attend the Q&A unless an exception was agreed in advance.

Unsupported claims receive no credit under the relevant rubric criterion.
Materially inaccurate contribution records or misrepresentation of working
features may be handled under the course policy. Individual grades may be
adjusted when the repository evidence and Q&A show substantially unequal
contributions or understanding.

## Graded Criteria

Features beyond the approved core scope improve a score only when they are complete, integrated, and relevant to the project.

| Criterion                                  |     Max | Strong evidence for full credit                                                                                                                                                                       | Evidence of partial achievement                                                                                                |
| ------------------------------------------ | ------: | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| **Core implementation**                    |      25 | The agreed core goals work end to end. Components form a coherent system, important failure cases are handled, and the delivered scope is demonstrated.                                               | Only part of the core flow works, components are disconnected, or robustness is weak.                                          |
| **Cloud architecture and deployment**      |      25 | The system runs in the intended cloud environment. Compute, networking, state, configuration, and service choices fit the problem and are implemented rather than merely described.                   | Deployment is partly manual or local-only, important infrastructure is missing, or cloud choices add little to the solution.   |
| **Reproducibility and automation**         |      20 | From a clean checkout, the documented commands and committed configuration reliably build, configure, deploy, verify, and remove the system. Repeated steps are sensibly automated.                   | Instructions require guesswork, hidden state, undocumented manual steps, or significant repair by the evaluator.               |
| **Verification, operations, and security** |      20 | Relevant automated tests validate important behavior. The deployed system has appropriate health, logging or monitoring evidence and risk-based security measures, all of which the group can verify. | Tests cover only trivial paths, operational behavior is difficult to observe, or relevant security risks are left unaddressed. |
| **Engineering judgment and evidence**      |      10 | The group explains important tradeoffs, validates its claims, documents material design changes and limitations, and keeps the solution focused on meaningful technical work.                         | Choices are weakly justified, claims lack evidence, limitations are hidden, or complexity is added without clear value.        |
| **Total**                                  | **100** |                                                                                                                                                                                                       |                                                                                                                                |

The rubric is project-specific in application: for example, authentication,
persistent storage, Kubernetes, microservices, performance testing, or a user
interface are assessed only when relevant to the approved scope and risks. A
simple, justified design can score higher than an unnecessarily complex one.

## Grading Scale

| Grade | Points |
| ----- | -----: |
| A     | 90–100 |
| B     |  80–89 |
| C     |  60–79 |
| D     |  50–59 |
| E     |  40–49 |
| F     |   0–39 |
