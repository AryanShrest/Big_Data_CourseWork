# Sample Database Queries — route_fare_reliability

Database: Supabase (PostgreSQL)
Table: `route_fare_reliability` (25 rows)

All queries below use parameterised execution in the actual notebook (via `psycopg2` with `%s` placeholders) — the raw SQL shown here is for documentation/report purposes.

---

## Query 1: Routes with above-average disruption rate (least reliable, worst first)

```sql
SELECT route, avg_fare, reliability_score
FROM route_fare_reliability
WHERE reliability_score > 0.01
ORDER BY reliability_score DESC;
```

**Result:**

| route | avg_fare | reliability_score |
|---|---|---|
| 1 | 1.80 | 0.0256 |
| 5 | 1.80 | 0.0202 |
| 3 | 1.80 | 0.0157 |
| 2 | 1.80 | 0.0116 |

---

## Query 2: Average fare and reliability grouped by fare band

```sql
SELECT
    CASE WHEN avg_fare < 2 THEN 'Standard' ELSE 'Premium' END AS fare_band,
    COUNT(*) AS route_count,
    AVG(reliability_score) AS avg_reliability
FROM route_fare_reliability
GROUP BY fare_band;
```

**Result:**

| fare_band | route_count | avg_reliability |
|---|---|---|
| Standard | 20 | 0.0046 |
| Premium | 5 | 0.0000 |

(The GBP2.20 routes -- SB4, SB5, SB6, X12 -- plus route A1 at GBP7.58, fall into "Premium" under this `< 2` cutoff. All 5 Premium routes have zero recorded disruptions, while every disruption in the dataset comes from a Standard-fare route -- though this is more likely explained by Premium routes running far fewer trips, giving less opportunity for a disruption to be logged, rather than fare itself driving reliability.)

---

## Query 3: Total trips and disruptions across the network

```sql
SELECT
    SUM(trip_count) AS total_trips,
    SUM(disruption_count) AS total_disruptions,
    ROUND(SUM(disruption_count)::numeric / SUM(trip_count), 5) AS network_reliability_score
FROM route_fare_reliability;
```

**Result:**

| total_trips | total_disruptions | network_reliability_score |
|---|---|---|
| 8,651 | 53 | 0.00613 |

---

## Query 4: Correlation-relevant extremes — highest fare vs. highest disruption route

```sql
(SELECT route, avg_fare, 'highest_fare' AS category FROM route_fare_reliability ORDER BY avg_fare DESC LIMIT 1)
UNION ALL
(SELECT route, disruption_count, 'highest_disruptions' AS category FROM route_fare_reliability ORDER BY disruption_count DESC LIMIT 1);
```

**Result:**

| route | value | category |
|---|---|---|
| A1 | 7.58 | highest_fare |
| 1 | 22 | highest_disruptions |

Notably, the route with the highest fare (A1) has **zero** recorded disruptions, while the route with the most disruptions (route 1) is priced at the standard GBP1.80 rate — consistent with this project's overall finding that fare does not predict reliability for this operator's network.
