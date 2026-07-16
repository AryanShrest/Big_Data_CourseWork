# Fare vs Reliability Relationship Analysis

**Module:** ST5011CEM — Big Data Programming Project
**Dataset:** Bus Open Data Service (BODS) — First Bus, Bristol
**Business stakeholder:** Transport Authority / Bus Operator — monitoring whether fare pricing relates to service reliability

## Project Overview

This project builds a predictive analytics pipeline examining the relationship between bus fares and service reliability for First Bus's Bristol network, using BODS Timetables, Fares, and Disruptions data. The pipeline covers ingestion, PySpark-based cleaning and large-scale transformation, PostgreSQL storage, exploratory data analysis, and a 3-model regression comparison (implemented in both scikit-learn and PySpark MLlib).

## Notebook Index 

|Notebook|Purpose|
|-|-|
|`01\_Parsing\_Timetables\_Fares\_Disruptions.ipynb`|Parses raw XML (TransXChange/NeTEx) into flat CSV; loads Disruptions from the BODS data catalogue export|
|`02\_PySpark\_Load\_Clean\_Partition.ipynb`|Loads flattened data into PySpark, cleans (filters/deduplicates), repartitions (8 partitions), caches|
|`03\_Join\_Reliability\_Supabase.ipynb`|Aggregates to route level, joins all 3 datasets, engineers `reliability\_score`, stores in Supabase (PostgreSQL)|
|`04\_ML\_Regression\_Models.ipynb`|Compares 3 regression models (scikit-learn): Linear Regression, Random Forest, Gradient Boosting|
|`05\_PySpark\_EDA\_Visualizations.ipynb`|PySpark `.describe()`, statistical profiling, PySpark SQL broadcast join, matplotlib/seaborn visualizations|
|`06\_Distributed\_Computing\_Concepts.ipynb`|Demonstrates lazy evaluation, DAG execution, stage metrics, and explains the persistence strategy used|
|`07\_PySpark\_MLlib\_Models.ipynb`|Same 3-model comparison implemented natively in PySpark MLlib (VectorAssembler, Pipeline, CrossValidator)|

## Setup Instructions

### 1\. Install dependencies

```bash
pip install -r requirements.txt
```

### 2\. Get the raw data

Download the following from [data.bus-data.dft.gov.uk](https://data.bus-data.dft.gov.uk/):

* **Timetables** — filter: Geographical area = Bristol, Publisher = First Bus, Status = Active
* **Fares** — filter: Publisher = First Bus
* **Disruptions data catalogue** — from the main downloads page, filtered to "West of England"

Unzip into this folder structure (same directory as the notebooks):

```
timetables/
fares/
catalogue/
```

### 3\. Configure your database credentials

```bash
cp .env.example .env
```

Edit `.env` and fill in your own Supabase (PostgreSQL) project credentials. **Never commit `.env`** — it is already excluded via `.gitignore`.

### 4\. Run the notebooks in order

Open Jupyter Lab from this folder and run notebooks `01` through `07` sequentially. Each notebook's markdown cells note its dependencies on previous notebooks' outputs.

## Big Data Scale

* Raw Timetables data: **518,888 rows** after flattening to stop-time level
* After PySpark cleaning (null filtering, deduplication): **295,222 rows**
* Both figures exceed the 100,000-record threshold without requiring synthetic augmentation

## Key Finding

Across both the scikit-learn and PySpark MLlib model comparisons, **average fare showed very limited predictive power over route reliability** (feature importance \~0.9%). Route length (stop count) and service frequency (trip count) were substantially stronger predictors. This is discussed further in the accompanying technical report's Results and Critical Reflection sections.

## Database

Data is stored in a Supabase-hosted PostgreSQL database (`route\_fare\_reliability` table). Schema and sample queries are included in `03\_Join\_Reliability\_Supabase.ipynb`. A schema diagram and sample query screenshots are included in the technical report's appendix.

## Technologies Used

* **PySpark** — large-scale data cleaning, partitioning, caching, SQL joins, MLlib
* **Pandas** — initial XML parsing and small-scale aggregation (justified per-stage in the technical report)
* **PostgreSQL (Supabase)** — relational storage, parameterised queries
* **scikit-learn / PySpark MLlib** — regression model comparison
* **matplotlib / seaborn** — visualizations

## Author

\[Aaryan Shrestha] — \[240624]

