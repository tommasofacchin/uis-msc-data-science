# Project Plan: Public Transport Reliability (Entur)

Two-person plan for the DAT535 Medallion project (Bronze → Silver → Gold). Based on [Guideline.md](Guideline.md) and [ideas.md](ideas.md). Person A and Person B are placeholders for the two group members.

## Deadlines

| Date | Event |
|---|---|
| Fri 13 Nov | Presentation for the Cloud course (other course, takes time that week) |
| **Mon 16 Nov** | **Data Engineering presentation** |
| ~Thu 26 – Fri 27 Nov | Final report, about 1.5 weeks after the presentation (exact date to confirm) |

Only about 3 weeks remain before the presentation, so the pipeline must run end to end by 12 November. The report window afterwards is for evidence, performance measurements and reflection.

## 1. Project statement (draft for the check-in)

- **Build:** a batch pipeline that collects real-time public transport data from Entur (SIRI estimated timetable, optionally GTFS static timetable and MET Norway weather) and turns it into trusted datasets for analyzing punctuality.
- **Problem:** real-time data has no history and is hard to use directly (nested XML, one trip repeated in every snapshot). Nobody can answer "which lines and hours are unreliable?" from the raw feed.
- **Final outcome:** a Gold table with punctuality and average delay per line, stop and time of day, ready for a dashboard or a simple query.
- **Users:** people who plan trips in the Stavanger/Rogaland area (focus on the KOL operator, to keep the scope bounded).
- **Out of scope:** streaming, real-time dashboards, delay prediction models.

## 2. Key facts from the API test

- No key needed; `ET-Client-Name` header sent. Rate limit seen in the headers: 5 requests per minute.
- Each response is a snapshot: past stops (`RecordedCalls`, aimed vs actual) and future stops (`EstimatedCalls`, aimed vs expected).
- No history: collection must start in week 1.
- The `datasource=KOL` parameter did not filter SIRI Lite results (only 1 of 50 journeys was KOL). The correct filter is still to be found.
- Cancellation fields are not filled for every operator.

## 3. Open items to settle first

| Item | Why it matters | Owner |
|---|---|---|
| Check-in date for the 1-2 page definition, exact report date, and whether the demo is also on 16 Nov | Fixes the milestones below | Both |
| Cloud platform and storage for dev/prod | Needed for the cloud setup deliverable | Person A |
| Correct operator filter for Rogaland | Controls volume and scope | Person A |
| How long finished trips stay in the feed | Decides the polling interval (15 vs 5 minutes) | Person A |
| Entur terms: `ET-Client-Name`, license, rate limit | Needed in the report | Person A |
| Does the Spark version read XML natively, or is a package needed | Decides the Silver parsing approach | Person B |
| How `ServiceJourney` ids map to GTFS `trip_id` | Needed for the timetable join | Person B |

## 4. Work packages

### WP0: Setup (24-27 Oct)
- Create the GitHub repo, branch rules (feature branches + pull requests), folder structure.
- Separate dev and prod configuration; secrets stored as GitHub Secrets.
- Agree on the Bronze folder layout and metadata columns (source, endpoint, ingestion time, run id).

### WP1: Bronze (24-30 Oct)
- Ingestion script that calls the Entur endpoint and stores the raw response unchanged.
- GitHub Actions workflow on a schedule (start with every 15 minutes; revisit after the feed-retention test).
- Handling of failed runs, retries, duplicate ingestion and rate limit.
- Metadata and logging per run.
- Optional: periodic download of the GTFS static timetable.

### WP2: Silver (27 Oct - 12 Nov, primary focus)
- **Data understanding:** document what one record is (a trip, a stop call, a snapshot) and which fields are essential, optional or unreliable.
- **Model:** grain = one stop call of one trip on one day (key: trip id + service date + stop order); stop and line reference tables.
- **Parsing and standardization:** flatten XML, one row per stop, timestamps to UTC with the original offset kept, consistent types, UTF-8 check on stop names.
- **Deduplication:** the same trip appears in every snapshot; define which version is kept (latest per key) and keep the snapshot time.
- **Cleaning rules:** missing times, impossible delays, cancelled trips, extra journeys, schema differences between operators; decide per rule whether records are rejected, corrected or flagged.
- **Enrichment:** join with line/stop reference data (GTFS) and optionally weather.
- **Quality evidence:** counts of missing, duplicate, invalid, accepted and rejected records before and after.
- **Performance:** profile the main scans, the dedup and the join; apply only tuning backed by measurements (early filtering, partitioning by date, reducing shuffles).
- **Tests:** unit tests for the cleaning rules and schema checks, run in GitHub Actions.

### WP3: Gold (5-12 Nov)
- Delay computed in seconds (actual or expected minus aimed) with a chosen threshold for "late".
- Punctuality and average delay per line, stop and hour of day; smaller and purpose-specific compared with Silver.
- Validation: Gold totals match Silver; publish only if quality checks pass.
- A simple consumer for the demo (a query or one chart), not a full app.

### WP4: Delivery (27 Oct - 12 Nov, in parallel)
- CI: tests and checks on every pull request.
- Deployment to dev and prod; scheduled end-to-end run Bronze → Gold.
- Visibility: run status, failures, rejected records and quality results (a log table is enough).
- README with clone-and-run instructions.

### WP5: Presentation, demo and report (presentation 16 Nov, report ~26-27 Nov)
- Report 8-10 pages organized by decisions, not by chronology; evidence from the quality metrics, performance measurements and run logs.
- 10-minute presentation focused on the main decisions and lessons learned.
- Live demo plan: end-to-end run, deployment, schedule, Gold output; keep collected data as a fallback.

## 5. Task division

Silver is the main focus, so it is split between both people along a clear line: A owns getting data in and keeping the system running; B owns what the data means.

| Area | Person A (pipeline and platform) | Person B (data and analysis) |
|---|---|---|
| WP0 Setup | Repo, branches, environments, secrets | Project statement and dataset sections of the check-in |
| WP1 Bronze | **Owner.** Ingestion script, Actions schedule, storage layout, retries, metadata | Reviews PRs; helps with the feed-retention test |
| WP2 Silver | Parsing, flattening, timestamps and types, dedup, Silver tests | **Owner of the model and rules.** Data understanding, cleaning rules, quality metrics, GTFS enrichment, performance profiling |
| WP3 Gold | Publish gating, refresh and readiness signal | **Owner.** Delay measures, aggregation, validation, demo consumer |
| WP4 Delivery | **Owner.** CI, deployment, monitoring, README | Quality results visible in logs |
| WP5 Report | Bronze, architecture, delivery and reflection sections | Dataset, Silver, Gold and results sections |
| Presentation / demo | Pipeline and deployment part | Data and results part |

Rules for working together:
- Every change goes through a pull request reviewed by the other person. This is the guideline's "develop and validate" step and it also keeps both people able to explain the whole pipeline.
- A short weekly sync to compare progress with the milestones below.
- Both people must be able to answer questions about all layers in the demo.

## 6. Timeline

| Dates | Milestone |
|---|---|
| 24-27 Oct | Repo and environments ready; first Bronze ingestion running on a schedule; collection started |
| 28-30 Oct | Bronze stable with metadata and failure handling; project definition (1-2 pages) written; feed-retention test done |
| 31 Oct - 4 Nov | First Silver version (parsed, one row per stop, dedup, timestamps); data understanding documented; CI running tests |
| 5-9 Nov | Cleaning rules and quality metrics; first Gold table; scheduled run in prod |
| 10-12 Nov | Gold validated and published through the pipeline; performance profiling; GTFS enrichment only if time allows; pipeline frozen on 12 Nov |
| 13 Nov | Cloud course presentation (limited time for this project); prepare slides |
| 14-15 Nov | Demo rehearsal with a stored-data fallback; slides final |
| **16 Nov** | **Presentation (10 minutes) and demo** |
| 17-25 Nov | Report: results, quality and performance evidence, reflection; keep the pipeline running to collect more data |
| ~26-27 Nov | Final report and repository |

Scope cut for the short schedule: the first Silver and Gold use the aimed, actual and expected times already in the SIRI data. The GTFS join and weather are optional extras.

## 7. Risks

| Risk | Mitigation |
|---|---|
| Collection starts late and the dataset is too small (only about 3 weeks of data before 16 Nov) | Start Bronze by 27 Oct; use a wider area or a shorter interval if volume is low; keep collecting until the report |
| The Cloud presentation on 13 Nov takes time just before ours | Freeze the pipeline on 12 Nov and plan the slides and rehearsal for 14-15 Nov |
| Cron runs are delayed or skipped | Record run time in Bronze; make Silver tolerate gaps; document it in the report |
| API changes or is down during the demo | Keep a stored sample of collected data as a fallback |
| Feed drops finished trips quickly | Measure retention; shorten the interval if needed |
| XML parsing is slow or fiddly in Spark | Test the approach on one file early (WP2 first task) |
| GTFS join is harder than expected | Use the aimed times already in the SIRI data; treat GTFS as enrichment, not a dependency |
| Free GitHub Actions minutes run out (private repo) | Use a public repo or a longer interval; check current limits |
