
# M1. Foundations and Architectures

## OLTP and OLAP

Online Transaction Processing (*OLTP*) describes systems built to process many small, fast, concurrent operations that run an organization's day-to-day applications. There usually is high concurrency, low latency, and commonly uses *ACID transactions*. Examples include PostgreSQL, MySQL, and SQL Server.

Online Analytical Processing (*OLAP*) describes systems designed to analyze large volumes of historical data for reporting, business intelligence, and decision making. Priritize fast, complex, and read-heavy queries, such as aggregations, trends, and comparisons across time, products, or locations rather than frequent record-level updates. Typical examples include *data warehouses*, BI semantic models, Snowflake, and BigQuery.

## Data architectures


### Databases

A *database* is the system that runs the day-to-day application correctly. A relational database represents this with tables, connected by keys and relationships.

### Data warehouses

A *warehouse* is a clean, historical analytical copy of data, designed for answering business questions. It's optimized for reading and aggregating large amounts of data.

### Data Lakes/Lakehouses/Fabric

A *data lake* is a sclalable, inexpensive storage where you can keep data in many original forms ("land first, trasform later" approach). It's flexible and low cost storage at scale. Without documentation, validation, access controls, and lifecycle rules, it becomes a data swamp (difficult to find or trust).

A *lakehouse* tries to combine a lake's flexibility with a warehouse's reliability and analytical performance. The physical files can remain in object storage, often as Parquet files, but instead of treating them as unmanaged files, it provides managed, queryable tables with schemas, transaction rules, history, and performance features. 

*Microsoft Fabric* is a SaaS platform that puts major data workloads into one Microsoft environment. It includes *OneLake* as a storage and integrates data engineering, warehousing, Power BI, and AI-oriented workloads. Instead of configuring several unrelated products, teams can work within a more integrated platform. Can host a lakehouse and medallion pipeline.

### Delta Lake 

A *Delta lake* is a reliable layer for tables stored in data lake. Adds a transaction log and table rules around the Parquet files, so the data lake can behave more like a database table. Often used with Spark and medallion implementations. It's capabilities are ACID transactions, schema enforcement, and time travel. 

A lakehouse is the achitecture, the delta lake is one technology used to build it.

### Data Mesh

A *Data Mesh* is an organization operating model: data should be owned by the business domains that understand it best. In a large company, one centralized data team often becomes a bottleneck because it must understand finance, sales, operations, marketing, and engineering at once. Data Mesh moves responsibility closer to each domain. Each domain publishes data products, and datasets are usable by other teams. Data Mesh can use a lakehouse, Delta lake, or Microsoft Fabric; it's not a replacement for them.

### Data Fabric

Data Fabric is a connected layer that helps an organization find, integrate, govern and use data distributed across many systems.

Imagine that the hotel company keeps data in PostgreSQL, Salesforce, a cloud lakehouse, SaaS finance software, and an old on-premises database. Rather than copying all data immediately into one place, a data-fabric approach focuses on shared metadata, catalogues, lineage, access policies, data quality, and integration across those locations.

A Data Mesh distributes ownership by domain, whereas a Data Fabric connects and govern data across technical boundaries. They can be used together: domains owns data products in a mesh, while fabric-style metadata and governance make those products discoverable and interoperable.

## The V's of big data

The V's are a way to describe why some data problems become difficult enough to need distributed storage, Spark, streaming systems, data lakes, or stronger governance. 

- **Volume**: how much data exists, one machine may not have enough storage or processing capacity. 
- **Velocity**: how quickly data arrives and must be processed, near-real-time pipelines may be needed.  
- **Variety**: how many formats and structures data has. Flexible storage and schema handling, often a data lake or lakehouse.
- **Veracity**: how trustworthy and accurate data is. Validating, cleaning, lineage, monitoring, and quality rules.
- **Value**:  Whether data produces a useful outcome. Start from a business decision, not from collecting data for its own sake.


## Medallion architecture