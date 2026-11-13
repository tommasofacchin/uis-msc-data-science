# Project Ideas

Shortlist of API-based project ideas for the Medallion pipeline (Bronze → Silver → Gold). All sources are open APIs ingested in scheduled batches and accumulated over time. Ideas are ordered by score.

## 1. Public transport reliability

- **Score: 9/10.** SIRI, SIRI Lite and GTFS-RT cover all of Norway (GTFS-RT updates every 15 s), so volume is high and Spark is clearly justified. Real-time only, no history: collection must start early. The `ET-Client-Name` header, rate limits and license were not confirmed on the pages checked, and the developer portal is moving to developer.entur.no. GitHub Actions cron has a 5-minute minimum interval.

- **Source:** Entur (real-time SIRI + GTFS timetable), optionally + MET Norway weather
- **Bronze:** Daily/hourly raw real-time responses and periodic GTFS feeds, stored unchanged with endpoint, timestamp and run id.
- **Silver challenges:** Join between planned and actual times (expensive join), time zones, cancelled trips, ids that change between GTFS versions, duplicate updates for the same trip.
- **Gold:** Punctuality and average delay per line, stop and time of day, to show which lines and hours to avoid.
- **Risk:** Real-time data is not historical, so the dataset only grows through scheduled collection; the API must be polled regularly from the start.

## 2. River levels and flood risk (NVE)

- **Score: 8/10.** Real REST API with a free key, instantaneous/hourly/daily series, historical backfill and data quality problems declared by the source. Medium volume; respect per-request point caps and rate limits.

- **Source:** NVE Hydrological API (HydAPI): water stage, discharge and water temperature time series per station
- **Access:** Free API key (sent in the `X-API-Key` header) created on NVE's users page. Data under NLOD (Norwegian open government data), credit NVE where possible. Each key has a rate limit, and each request has a cap on the number of data points.
- **Resolution:** Instantaneous, hourly and daily series. Station and series metadata refresh about every 4 hours. Includes historical archives, which allows a backfill.
- **Bronze:** Daily pulls of observations per station and series (narrow time windows, as NVE recommends), plus periodic station and series metadata, stored unchanged with request parameters and run id.
- **Silver challenges:** Gaps and errors in the data ("as is", per NVE), different resolutions per series, daily values timestamped at 11:00Z, station ids made of three numbers, decommissioned stations, outliers and negative values.
- **Gold:** Flood-risk indicator per catchment and season, using the percentile endpoint as a reference for what is normal for each station.
- **Risk:** Medium volume that grows with the number of stations and the backfill depth. Respect the rate limits by polling only series that have new data.

## 3. Bike availability and weather

- **Score: 7/10.** GBFS feed updates every 10 s (NLOD license, `Client-Identifier` header required). Station status alone is small; volume comes from the downloadable anonymized trip history.

- **Source:** Bergen/Oslo Bysykkel (GBFS) + MET Norway weather API
- **Bronze:** Hourly raw station-status snapshots and weather responses, stored unchanged with endpoint, timestamp and run id.
- **Silver challenges:** Duplicate snapshots, stations that appear or disappear, temporal join between station status and weather.
- **Gold:** Average bike availability per station and hour, by rain and temperature.
- **Risk:** Small per-call volume, so several weeks of accumulation are needed.

## 4. Grocery prices in Norway

- **Score: 7/10.** Free Hobby plan (60 requests/min), useful result, can start immediately. Moderate volume and stale prices for some chains.

- **Source:** Kassalapp API (`kassal.app`): products, prices, nutrition, physical stores, price history
- **Access:** Free "Hobby" plan (all endpoints, 60 requests/min) for non-commercial use, students and hackathons. API key from the Kassalapp profile page. Caching and storing data is allowed.
- **Bronze:** Daily raw product and price responses (prices update once a day from about 09:00), stored unchanged with endpoint, page, timestamp and run id.
- **Silver challenges:** Products with several names, unit-of-measure differences (kg, l, pieces), missing prices, stale prices, duplicate EANs across chains, mapping products to categories and stores.
- **Gold:** Average and lowest price per product and chain, price changes over time, cheapest basket per chain.
- **Risk:** Rema 1000, Kiwi and Coop prices are documented as not always current (old products keep their last known price), so freshness must be handled as a quality rule. Price history is capped at 90 days, so history must be built by daily collection. Volume depends on how many products are fetched; the rate limit (60/min) bounds the daily crawl.

## 5. Job market (NAV job vacancy feed)

- **Score: 7/10.** Rich Silver (free text, status changes) and history since about 2019, but depends on getting a private token and on the rule to remove inactive ads. Would drop to about 5 if only the rotating public token is available.

- **Source:** NAV Job Vacancy Feed (`pam-stilling-feed.nav.no`, Arbeidsplassen), JSON feed of job ads
- **Access:** Every request needs a bearer token. A public token exists for experiments but rotates at irregular intervals; a private token requires registering by email with NAV and accepting the terms of use. The feed contains ads since about 2019, with expired ads marked INACTIVE.
- **Bronze:** Incremental pulls following `next_url` (with `If-Modified-Since` / ETag), storing each raw page and vacancy detail unchanged with ingestion time and run id.
- **Silver challenges:** Repeated ads, status changes (ACTIVE to INACTIVE), free-text job titles and skills to normalize, municipality and region standardization, schema differences between ads.
- **Gold:** Demand per skill, occupation and region by week, number of new vs. closed ads.
- **Risk:** The terms of use require removing ads from the service once they are marked inactive, which conflicts with keeping Bronze unchanged; this must be handled explicitly (for example, delete or mask inactive ads on a schedule) and documented in the report. Token registration takes time, so request it early.

## 6. OpenStreetMap edits

- **Score: 7/10.** High volume and a rich Silver, but bulk replication files rather than an API, and file sizes and format were not verified.

- **Source:** OpenStreetMap replication feeds (`planet.openstreetmap.org/replication/`: minute, hour and day diffs, plus changesets)
- **Access:** Open bulk files, no key, ODbL license. These are published diff files rather than a REST API, so the job downloads new files on a schedule; the file format and sizes were not checked.
- **Bronze:** Daily diff files and changeset files, stored unchanged with source file name, sequence number and run id.
- **Silver challenges:** Parsing XML diffs, create/modify/delete actions, edits that are later reverted, bot and mass-import changes, assigning edits to regions, ordering by sequence number.
- **Gold:** Edit activity per area and week, share of edits by new vs. experienced mappers, most-edited regions.
- **Risk:** Volume is high, so the date window must be limited at first. Not a REST API, so confirm that "files from a public endpoint on a schedule" fits the project's data-source requirement.

## 7. Air traffic

- **Score: 6/10.** Anonymous access gives only the latest state vectors (400 credits/day); an authenticated standard account gets 4,000 credits/day and up to 1 hour of history. A bounding box up to 25 sq° costs 1 credit per call. Enough volume for Spark if polled every few minutes, but credits cap the frequency.

- **Source:** OpenSky Network (aircraft state vectors)
- **Bronze:** Periodic raw state snapshots for a bounding box.
- **Silver challenges:** Duplicate positions, missing fields, late data, noisy sensor readings, aircraft-to-airport enrichment.
- **Gold:** Flights per airport and hour, most used routes.
- **Risk:** Anonymous access is rate limited; high volume makes it a good fit for Spark.

## 8. Earthquakes

- **Score: 6/10.** No key, up to 20,000 events per request, and `updatedafter` supports incremental ingestion of revised events; deleted events return HTTP 409. Strong "changing data" story, but low volume (USGS recommends its real-time GeoJSON feeds for automated use).

- **Source:** USGS Earthquake API
- **Bronze:** Raw event feeds per time window.
- **Silver challenges:** Events revised or deleted after publication (late-changing data), duplicate event ids, magnitude type differences, timestamp standardization.
- **Gold:** Earthquake frequency and intensity per region and week.
- **Risk:** Modest volume; handling updates (upserts/merge) is the main engineering story.

## 9. Air quality

- **Score: 5/10.** NILU API: no key mentioned, history up to one year per request, data may not be modified but can be combined; cite api.nilu.no. Feasible, but no standout feature.

- **Source:** OpenAQ or NILU Luftkvalitet
- **Bronze:** Raw measurement responses per station and period.
- **Silver challenges:** Mixed units across sensors, negative or impossible values, many nulls, inconsistent station metadata.
- **Gold:** Daily air quality index per city and comparison with threshold limits.
- **Risk:** Check API rate limits and station coverage in the chosen region.

## Quick comparison

| Idea | Score | Volume | Join/enrichment | Standout engineering topic |
|---|---|---|---|---|
| 1. Transport reliability | 9/10 | High | GTFS timetable, weather | Planned vs actual join, cancelled trips |
| 2. River levels (NVE) | 8/10 | Medium (grows with backfill) | Station metadata, percentiles | Gaps, mixed resolutions, outliers |
| 3. Bikes + weather | 7/10 | Medium (accumulated) | Weather | Temporal join, duplicates |
| 4. Grocery prices | 7/10 | Medium (accumulated) | Store and category metadata | Unit normalization, stale prices |
| 5. Job market | 7/10 | Medium–high (history since ~2019) | Region reference | Text normalization, status changes, terms vs. Bronze |
| 6. OpenStreetMap edits | 7/10 | High | Region boundaries | XML diffs, reverted edits, bots |
| 7. Air traffic | 6/10 | High | Airport reference | Noisy sensor data, performance |
| 8. Earthquakes | 6/10 | Low–medium | Region mapping | Late-arriving revisions, merge |
| 9. Air quality | 5/10 | Medium | Station metadata | Unit standardization, outliers |

Scores are a judgement on fit for this project: Spark justified by volume, richness of Silver, a real API with scheduled refresh, access risk and usefulness of Gold.

## Checks before deciding

- Estimate total data size at the end of the project (target: several GB).
- Confirm API terms of use, rate limits and whether a key is needed (store it as a GitHub Secret).
- Keep raw responses in Bronze so runs are reproducible even though the API data changes.
- Keep some already collected data as a fallback in case the API is down during the demo.
