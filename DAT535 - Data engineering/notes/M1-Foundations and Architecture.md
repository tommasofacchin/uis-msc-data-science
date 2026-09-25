
# M1. Foundations and Architectures

## OLTP and OLAP

Online Transaction Processing (*OLTP*) describes systems built to process many small, fast, concurrent operations that run an organization's day-to-day applications. There usually is high concurrency, low latency, and commonly uses *ACID transactions*. Examples include PostgreSQL, MySQL, and SQL Server.

Online Analytical Processing (*OLAP*) describes systems designed to analyze large volumes of historical data for reporting, business intelligence, and decision making. Priritize fast, complex, and read-heavy queries, such as aggregations, trends, and comparisons across time, products, or locations rather than frequent record-level updates. Typical examples include data warehouses, BI semantic models, Snowflake, and BigQuery.

## Data architectures


Databases
Data warehouses
Data Lakes/Lakehouses/Fabric
Delta Lake 
Data Mesh
Data Fabric