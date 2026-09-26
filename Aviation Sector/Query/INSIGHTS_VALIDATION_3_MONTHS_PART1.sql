-- =========================================================================
-- AVIATION OPERATIONAL PERFORMANCE ANALYSIS
-- =========================================================================
create database flight_aviation;
show tables;

-- CHECK SCHEMA 
describe flights;

-- =========================================================================
-- INSIGHT 1: AVIATION OPERATIONAL OVERVIEW
-- =========================================================================
SELECT 'Total Flights' AS metric, FORMAT(COUNT(*), 0) AS value
FROM flights
UNION ALL
SELECT 'Distinct Airlines',
       CAST(COUNT(DISTINCT reporting_airline) AS CHAR)
FROM flights
UNION ALL
SELECT 'Distinct Airports',
       CAST((SELECT COUNT(*) FROM (
            SELECT origin AS ap FROM flights
            UNION
            SELECT dest FROM flights) t) AS CHAR)
UNION ALL
SELECT 'Distinct Routes',
       FORMAT(COUNT(DISTINCT CONCAT(origin, '|', dest)), 0)
FROM flights
UNION ALL
SELECT '15+ Min Delayed Flights',
       FORMAT(SUM(CASE WHEN dep_delay >= 15 THEN 1 ELSE 0 END), 0)
FROM flights
UNION ALL
SELECT '15+ Min Delay Rate %',
       CONCAT(ROUND(SUM(CASE WHEN dep_delay >= 15 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2), '%')
FROM flights
UNION ALL
SELECT 'Cancelled Flights',
       FORMAT(SUM(cancelled), 0)
FROM flights
UNION ALL
SELECT 'Cancellation Rate %',
       CONCAT(ROUND(SUM(cancelled) / COUNT(*) * 100, 2), '%')
FROM flights
UNION ALL
SELECT 'Diverted Flights',
       FORMAT(SUM(diverted), 0)
FROM flights
UNION ALL
SELECT 'Diversion Rate %',
       CONCAT(ROUND(SUM(diverted) / COUNT(*) * 100, 2), '%')
FROM flights
UNION ALL
SELECT 'Severely Delayed Flights (60+ min)',
       FORMAT(SUM(CASE WHEN dep_delay >= 60 THEN 1 ELSE 0 END), 0)
FROM flights
UNION ALL
SELECT 'Severe Delay Rate %',
       CONCAT(ROUND(SUM(CASE WHEN dep_delay >= 60 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2), '%')
FROM flights;

-- =========================================================================
-- INSIGHT 2: AIRLINE DELAY PERFORMANCE
-- Objective: Rank airlines by 15+ minute delay rate.
-- =========================================================================
WITH airline_metrics AS (
    SELECT
        reporting_airline,
        COUNT(*) AS total_flights,
        SUM(CASE WHEN dep_delay >= 15 THEN 1 ELSE 0 END) AS delayed_15_flights
    FROM flights
    GROUP BY reporting_airline
)
SELECT
    reporting_airline,
    total_flights,
    delayed_15_flights,
    ROUND(delayed_15_flights / total_flights * 100, 2) AS delay_rate_pct,
    RANK() OVER (ORDER BY delayed_15_flights / total_flights DESC) AS worst_rank,
    RANK() OVER (ORDER BY delayed_15_flights / total_flights ASC)  AS best_rank
FROM airline_metrics
ORDER BY delay_rate_pct DESC;


-- =========================================================================
-- INSIGHT 3: AIRLINE CANCELLATION PERFORMANCE
-- Objective: Rank airlines by cancellation rate and compute share of cancellations.
-- =========================================================================
WITH airline_cancel AS (
    SELECT
        reporting_airline,
        COUNT(*)            AS total_flights,
        SUM(cancelled)      AS cancelled_flights
    FROM flights
    GROUP BY reporting_airline
),
total_network AS (
    SELECT SUM(cancelled) AS total_cancellations FROM airline_cancel
)
SELECT
    ac.reporting_airline,
    ac.total_flights,
    ac.cancelled_flights,
    ROUND(ac.cancelled_flights / ac.total_flights * 100, 2) AS cancellation_rate_pct,
    ROUND(ac.cancelled_flights / tn.total_cancellations * 100, 2) AS cancellation_share_pct,
    RANK() OVER (ORDER BY ac.cancelled_flights / ac.total_flights DESC) AS worst_rank,
    RANK() OVER (ORDER BY ac.cancelled_flights / ac.total_flights ASC)  AS best_rank
FROM airline_cancel ac
CROSS JOIN total_network tn
ORDER BY cancellation_rate_pct DESC;


-- =========================================================================
-- INSIGHT 4: AIRPORT CANCELLATION PERFORMANCE
-- Objective: Top 15 airports by cancellation rate (min 1,000 flights).
-- =========================================================================

WITH airport_metrics AS (
    SELECT
        origin,
        COUNT(*)        AS total_flights,
        SUM(cancelled)  AS cancelled_flights,
        ROUND(SUM(cancelled) / COUNT(*) * 100, 2) AS cancellation_rate_pct
    FROM flights
    GROUP BY origin
    HAVING COUNT(*) >= 1000
),
network_avg AS (
    SELECT ROUND(SUM(cancelled) / COUNT(*) * 100, 2) AS avg_rate FROM flights
)
SELECT
    am.origin,
    am.total_flights,
    am.cancelled_flights,
    am.cancellation_rate_pct,
    na.avg_rate AS network_cancellation_rate_pct,
    ROUND(am.cancellation_rate_pct - na.avg_rate, 2) AS vs_network_pct,
    RANK() OVER (ORDER BY am.cancellation_rate_pct DESC) AS cancel_rank
FROM airport_metrics am
CROSS JOIN network_avg na
ORDER BY am.cancellation_rate_pct DESC
LIMIT 15;


-- =========================================================================
-- INSIGHT 5: AIRPORT TRAFFIC VS DELAY RATE (Quadrant Segmentation)
-- Objective: Segment airports into High/Low Traffic × High/Low Delay.
-- =========================================================================

WITH airport_metrics AS (
    SELECT
        origin,
        COUNT(*) AS total_flights,
        SUM(CASE WHEN dep_delay >= 15 THEN 1 ELSE 0 END) AS delayed_flights,
        ROUND(SUM(CASE WHEN dep_delay >= 15 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS delay_rate_pct
    FROM flights
    GROUP BY origin
    HAVING COUNT(*) >= 1000
),
traffic_median AS (
    SELECT AVG(total_flights) AS m FROM (
        SELECT total_flights,
               ROW_NUMBER() OVER (ORDER BY total_flights) AS rn,
               COUNT(*) OVER () AS cnt
        FROM airport_metrics
    ) x WHERE rn IN (FLOOR((cnt+1)/2), CEIL((cnt+1)/2))
),
delay_median AS (
    SELECT AVG(delay_rate_pct) AS m FROM (
        SELECT delay_rate_pct,
               ROW_NUMBER() OVER (ORDER BY delay_rate_pct) AS rn,
               COUNT(*) OVER () AS cnt
        FROM airport_metrics
    ) x WHERE rn IN (FLOOR((cnt+1)/2), CEIL((cnt+1)/2))
),
segmented AS (
    SELECT
        am.origin,
        am.total_flights,
        am.delay_rate_pct,
        tm.m AS traffic_median,
        dm.m AS delay_median,
        CASE
            WHEN am.total_flights >= tm.m AND am.delay_rate_pct >= dm.m THEN 'High Traffic / High Delay'
            WHEN am.total_flights >= tm.m AND am.delay_rate_pct <  dm.m THEN 'High Traffic / Low Delay'
            WHEN am.total_flights <  tm.m AND am.delay_rate_pct >= dm.m THEN 'Low Traffic / High Delay'
            ELSE 'Low Traffic / Low Delay'
        END AS airport_segment
    FROM airport_metrics am
    CROSS JOIN traffic_median tm
    CROSS JOIN delay_median dm
)
SELECT
    origin,
    total_flights,
    delay_rate_pct,
    airport_segment,
    RANK() OVER (PARTITION BY airport_segment ORDER BY delay_rate_pct DESC, total_flights DESC) AS rank_in_segment
FROM segmented
WHERE airport_segment = 'High Traffic / High Delay'
ORDER BY delay_rate_pct DESC, total_flights DESC
LIMIT 15;


-- =========================================================================
-- INSIGHT 5B: Segment Size Summary (quadrant counts)
-- =========================================================================

WITH airport_metrics AS (
    SELECT
        origin,
        COUNT(*) AS total_flights,
        ROUND(SUM(CASE WHEN dep_delay >= 15 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS delay_rate_pct
    FROM flights
    GROUP BY origin
    HAVING COUNT(*) >= 1000
),
traffic_median AS (
    SELECT AVG(total_flights) AS m FROM (
        SELECT total_flights,
               ROW_NUMBER() OVER (ORDER BY total_flights) AS rn,
               COUNT(*) OVER () AS cnt
        FROM airport_metrics
    ) x WHERE rn IN (FLOOR((cnt+1)/2), CEIL((cnt+1)/2))
),
delay_median AS (
    SELECT AVG(delay_rate_pct) AS m FROM (
        SELECT delay_rate_pct,
               ROW_NUMBER() OVER (ORDER BY delay_rate_pct) AS rn,
               COUNT(*) OVER () AS cnt
        FROM airport_metrics
    ) x WHERE rn IN (FLOOR((cnt+1)/2), CEIL((cnt+1)/2))
),
segmented AS (
    SELECT
        am.origin,
        CASE
            WHEN am.total_flights >= tm.m AND am.delay_rate_pct >= dm.m THEN 'High Traffic / High Delay'
            WHEN am.total_flights >= tm.m AND am.delay_rate_pct <  dm.m THEN 'High Traffic / Low Delay'
            WHEN am.total_flights <  tm.m AND am.delay_rate_pct >= dm.m THEN 'Low Traffic / High Delay'
            ELSE 'Low Traffic / Low Delay'
        END AS airport_segment
    FROM airport_metrics am
    CROSS JOIN traffic_median tm
    CROSS JOIN delay_median dm
)
SELECT airport_segment, COUNT(*) AS airport_count
FROM segmented
GROUP BY airport_segment
ORDER BY airport_count DESC;


-- =========================================================================
-- INSIGHT 6: BUSIEST DEPARTURE AIRPORTS
-- Objective: Top 15 departure airports + traffic share + cumulative share.
-- =========================================================================

WITH departures AS (
    SELECT origin, COUNT(*) AS total_departures
    FROM flights
    GROUP BY origin
),
total_flights AS (
    SELECT COUNT(*) AS grand_total FROM flights
)
SELECT
    d.origin,
    d.total_departures,
    ROUND(d.total_departures / tf.grand_total * 100, 2) AS traffic_share_pct,
    ROUND(SUM(d.total_departures / tf.grand_total * 100)
          OVER (ORDER BY d.total_departures DESC), 2) AS cumulative_share_pct,
    RANK() OVER (ORDER BY d.total_departures DESC) AS rank_no
FROM departures d
CROSS JOIN total_flights tf
ORDER BY d.total_departures DESC
LIMIT 15;


-- =========================================================================
-- INSIGHT 7: BUSIEST DESTINATION AIRPORTS
-- Objective: Top 15 destination airports + departure vs arrival comparison.
-- =========================================================================

WITH arrivals AS (
    SELECT dest, COUNT(*) AS total_arrivals
    FROM flights
    GROUP BY dest
),
departures AS (
    SELECT origin, COUNT(*) AS total_departures
    FROM flights
    GROUP BY origin
),
flow AS (
    SELECT
        COALESCE(a.dest, d.origin) AS airport,
        COALESCE(d.total_departures, 0)  AS total_departures,
        COALESCE(a.total_arrivals, 0)    AS total_arrivals,
        COALESCE(a.total_arrivals, 0) - COALESCE(d.total_departures, 0) AS flow_difference
    FROM arrivals a
    LEFT JOIN departures d ON a.dest = d.origin
    UNION
    SELECT
        d.origin,
        d.total_departures,
        0,
        -d.total_departures
    FROM departures d
    WHERE d.origin NOT IN (SELECT dest FROM arrivals)
)
SELECT
    airport,
    total_departures,
    total_arrivals,
    (total_departures + total_arrivals) AS total_activity,
    flow_difference,
    RANK() OVER (ORDER BY (total_departures + total_arrivals) DESC) AS activity_rank
FROM flow
ORDER BY total_activity DESC
LIMIT 15;


-- =========================================================================
-- INSIGHT 8: ROUTE-LEVEL FLIGHT VOLUME
-- Objective: Top 15 routes by flight volume.
-- =========================================================================

WITH route_volume AS (
    SELECT
        CONCAT(origin, ' → ', dest) AS route,
        COUNT(*) AS total_flights
    FROM flights
    GROUP BY origin, dest
),
total_flights AS (
    SELECT COUNT(*) AS grand_total FROM flights
)
SELECT
    rv.route,
    rv.total_flights,
    ROUND(rv.total_flights / tf.grand_total * 100, 4) AS traffic_share_pct,
    RANK() OVER (ORDER BY rv.total_flights DESC) AS rank_no
FROM route_volume rv
CROSS JOIN total_flights tf
ORDER BY rv.total_flights DESC
LIMIT 15;


-- =========================================================================
-- INSIGHT 9: ROUTE DELAY PERFORMANCE
-- Objective: Top 15 routes with highest delay rate (min 100 flights).
-- =========================================================================

WITH route_delay AS (
    SELECT
        CONCAT(origin, ' → ', dest) AS route,
        COUNT(*) AS total_flights,
        SUM(CASE WHEN dep_delay >= 15 THEN 1 ELSE 0 END) AS delayed_flights,
        ROUND(SUM(CASE WHEN dep_delay >= 15 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS delay_rate_pct
    FROM flights
    GROUP BY origin, dest
    HAVING COUNT(*) >= 100
)
SELECT
    route,
    total_flights,
    delayed_flights,
    delay_rate_pct,
    RANK() OVER (ORDER BY delay_rate_pct DESC) AS delay_rank
FROM route_delay
ORDER BY delay_rate_pct DESC
LIMIT 15;


-- =========================================================================
-- INSIGHT 10: ROUTE VOLUME VS DELAY RATE (Priority Routes)
-- Objective: Identify routes with both high traffic AND high delay.
-- =========================================================================

WITH route_metrics AS (
    SELECT
        CONCAT(origin, ' → ', dest) AS route,
        COUNT(*) AS total_flights,
        SUM(CASE WHEN dep_delay >= 15 THEN 1 ELSE 0 END) AS delayed_flights,
        ROUND(SUM(CASE WHEN dep_delay >= 15 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS delay_rate_pct
    FROM flights
    GROUP BY origin, dest
    HAVING COUNT(*) >= 100
),
traffic_median AS (
    SELECT AVG(total_flights) AS m FROM (
        SELECT total_flights,
               ROW_NUMBER() OVER (ORDER BY total_flights) AS rn,
               COUNT(*) OVER () AS cnt
        FROM route_metrics
    ) x WHERE rn IN (FLOOR((cnt+1)/2), CEIL((cnt+1)/2))
),
delay_median AS (
    SELECT AVG(delay_rate_pct) AS m FROM (
        SELECT delay_rate_pct,
               ROW_NUMBER() OVER (ORDER BY delay_rate_pct) AS rn,
               COUNT(*) OVER () AS cnt
        FROM route_metrics
    ) x WHERE rn IN (FLOOR((cnt+1)/2), CEIL((cnt+1)/2))
),
segmented AS (
    SELECT
        rm.route,
        rm.total_flights,
        rm.delayed_flights,
        rm.delay_rate_pct,
        CASE
            WHEN rm.total_flights >= tm.m AND rm.delay_rate_pct >= dm.m THEN 'High Traffic / High Delay'
            WHEN rm.total_flights >= tm.m AND rm.delay_rate_pct <  dm.m THEN 'High Traffic / Low Delay'
            WHEN rm.total_flights <  tm.m AND rm.delay_rate_pct >= dm.m THEN 'Low Traffic / High Delay'
            ELSE 'Low Traffic / Low Delay'
        END AS route_segment
    FROM route_metrics rm
    CROSS JOIN traffic_median tm
    CROSS JOIN delay_median dm
)
SELECT
    route,
    total_flights,
    delayed_flights,
    delay_rate_pct,
    route_segment,
    RANK() OVER (PARTITION BY route_segment ORDER BY delay_rate_pct DESC, total_flights DESC) AS rank_in_segment
FROM segmented
WHERE route_segment = 'High Traffic / High Delay'
ORDER BY delay_rate_pct DESC, total_flights DESC
LIMIT 15;


-- =========================================================================
-- INSIGHT 10B: Route Segment Size Summary
-- =========================================================================

WITH route_metrics AS (
    SELECT
        CONCAT(origin, ' → ', dest) AS route,
        COUNT(*) AS total_flights,
        ROUND(SUM(CASE WHEN dep_delay >= 15 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS delay_rate_pct
    FROM flights
    GROUP BY origin, dest
    HAVING COUNT(*) >= 100
),
traffic_median AS (
    SELECT AVG(total_flights) AS m FROM (
        SELECT total_flights,
               ROW_NUMBER() OVER (ORDER BY total_flights) AS rn,
               COUNT(*) OVER () AS cnt
        FROM route_metrics
    ) x WHERE rn IN (FLOOR((cnt+1)/2), CEIL((cnt+1)/2))
),
delay_median AS (
    SELECT AVG(delay_rate_pct) AS m FROM (
        SELECT delay_rate_pct,
               ROW_NUMBER() OVER (ORDER BY delay_rate_pct) AS rn,
               COUNT(*) OVER () AS cnt
        FROM route_metrics
    ) x WHERE rn IN (FLOOR((cnt+1)/2), CEIL((cnt+1)/2))
),
segmented AS (
    SELECT
        rm.route,
        CASE
            WHEN rm.total_flights >= tm.m AND rm.delay_rate_pct >= dm.m THEN 'High Traffic / High Delay'
            WHEN rm.total_flights >= tm.m AND rm.delay_rate_pct <  dm.m THEN 'High Traffic / Low Delay'
            WHEN rm.total_flights <  tm.m AND rm.delay_rate_pct >= dm.m THEN 'Low Traffic / High Delay'
            ELSE 'Low Traffic / Low Delay'
        END AS route_segment
    FROM route_metrics rm
    CROSS JOIN traffic_median tm
    CROSS JOIN delay_median dm
)
SELECT route_segment, COUNT(*) AS route_count
FROM segmented
GROUP BY route_segment
ORDER BY route_count DESC;
