-- Fare vs Reliability Analysis - Database Export
-- Database: Supabase (PostgreSQL)
-- Table: route_fare_reliability
-- Generated from Notebook 03 (Join_Reliability_Supabase.ipynb)

DROP TABLE IF EXISTS route_fare_reliability;

CREATE TABLE route_fare_reliability (
    route VARCHAR(20) PRIMARY KEY,
    trip_count INT,
    avg_fare FLOAT,
    disruption_count INT,
    reliability_score FLOAT
);

-- Data (25 rows)
INSERT INTO route_fare_reliability (route, trip_count, avg_fare, disruption_count, reliability_score) VALUES ('1', 860, 1.800000, 22, 0.025581);
INSERT INTO route_fare_reliability (route, trip_count, avg_fare, disruption_count, reliability_score) VALUES ('17', 96, 1.800000, 0, 0.000000);
INSERT INTO route_fare_reliability (route, trip_count, avg_fare, disruption_count, reliability_score) VALUES ('2', 860, 1.800000, 10, 0.011628);
INSERT INTO route_fare_reliability (route, trip_count, avg_fare, disruption_count, reliability_score) VALUES ('24', 408, 1.800000, 0, 0.000000);
INSERT INTO route_fare_reliability (route, trip_count, avg_fare, disruption_count, reliability_score) VALUES ('3', 445, 1.800000, 7, 0.015730);
INSERT INTO route_fare_reliability (route, trip_count, avg_fare, disruption_count, reliability_score) VALUES ('36', 166, 1.800000, 0, 0.000000);
INSERT INTO route_fare_reliability (route, trip_count, avg_fare, disruption_count, reliability_score) VALUES ('37', 32, 1.800000, 0, 0.000000);
INSERT INTO route_fare_reliability (route, trip_count, avg_fare, disruption_count, reliability_score) VALUES ('41', 251, 1.800000, 0, 0.000000);
INSERT INTO route_fare_reliability (route, trip_count, avg_fare, disruption_count, reliability_score) VALUES ('48', 1163, 1.800000, 0, 0.000000);
INSERT INTO route_fare_reliability (route, trip_count, avg_fare, disruption_count, reliability_score) VALUES ('5', 247, 1.800000, 5, 0.020243);
INSERT INTO route_fare_reliability (route, trip_count, avg_fare, disruption_count, reliability_score) VALUES ('50', 26, 1.800000, 0, 0.000000);
INSERT INTO route_fare_reliability (route, trip_count, avg_fare, disruption_count, reliability_score) VALUES ('515', 15, 1.800000, 0, 0.000000);
INSERT INTO route_fare_reliability (route, trip_count, avg_fare, disruption_count, reliability_score) VALUES ('6', 524, 1.800000, 3, 0.005725);
INSERT INTO route_fare_reliability (route, trip_count, avg_fare, disruption_count, reliability_score) VALUES ('7', 524, 1.800000, 5, 0.009542);
INSERT INTO route_fare_reliability (route, trip_count, avg_fare, disruption_count, reliability_score) VALUES ('72', 175, 1.800000, 0, 0.000000);
INSERT INTO route_fare_reliability (route, trip_count, avg_fare, disruption_count, reliability_score) VALUES ('73', 1, 1.800000, 0, 0.000000);
INSERT INTO route_fare_reliability (route, trip_count, avg_fare, disruption_count, reliability_score) VALUES ('76', 1300, 1.800000, 0, 0.000000);
INSERT INTO route_fare_reliability (route, trip_count, avg_fare, disruption_count, reliability_score) VALUES ('8', 284, 1.800000, 1, 0.003521);
INSERT INTO route_fare_reliability (route, trip_count, avg_fare, disruption_count, reliability_score) VALUES ('A1', 1234, 7.576471, 0, 0.000000);
INSERT INTO route_fare_reliability (route, trip_count, avg_fare, disruption_count, reliability_score) VALUES ('SB2', 16, 1.800000, 0, 0.000000);
INSERT INTO route_fare_reliability (route, trip_count, avg_fare, disruption_count, reliability_score) VALUES ('SB4', 4, 2.200000, 0, 0.000000);
INSERT INTO route_fare_reliability (route, trip_count, avg_fare, disruption_count, reliability_score) VALUES ('SB5', 4, 2.200000, 0, 0.000000);
INSERT INTO route_fare_reliability (route, trip_count, avg_fare, disruption_count, reliability_score) VALUES ('SB6', 4, 2.200000, 0, 0.000000);
INSERT INTO route_fare_reliability (route, trip_count, avg_fare, disruption_count, reliability_score) VALUES ('SB7', 8, 1.800000, 0, 0.000000);
INSERT INTO route_fare_reliability (route, trip_count, avg_fare, disruption_count, reliability_score) VALUES ('X12', 4, 2.200000, 0, 0.000000);

-- Sample queries

-- Query 1: Routes with above-average reliability_score (i.e. less reliable), ordered worst first
SELECT route, avg_fare, reliability_score
FROM route_fare_reliability
WHERE reliability_score > 0.01
ORDER BY reliability_score DESC;

-- Query 2: Average fare and reliability grouped by fare band
SELECT
    CASE WHEN avg_fare < 2 THEN 'Standard' ELSE 'Premium' END AS fare_band,
    COUNT(*) AS route_count,
    AVG(reliability_score) AS avg_reliability
FROM route_fare_reliability
GROUP BY fare_band;