-- Modernized for Apache Hive 4.2.0
-- Source version inferred: Hive 2.x (cross-version compatible window function syntax)
-- Applied changes: Added modernization header; syntax fully compatible with 4.2.0
-- Iceberg recommendation: No (read-only analytical query)

-- =============================================================================
-- 05: Window Functions
-- =============================================================================
-- Window functions are fully supported in Hive 4.2.0 with Tez execution.
-- Vectorized execution (enabled by default) improves window function performance.
-- =============================================================================

SELECT customer_id,
       sale_date,
       SUM(amount) OVER (
           PARTITION BY customer_id
           ORDER BY sale_date
           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS running_total,
       RANK() OVER (
           PARTITION BY sale_date
           ORDER BY amount DESC
       ) AS daily_rank
FROM sales;

-- =============================================================================
-- Verification Steps
-- =============================================================================
-- EXPLAIN ANALYZE
--   SELECT customer_id, sale_date,
--     SUM(amount) OVER (PARTITION BY customer_id ORDER BY sale_date
--       ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total,
--     RANK() OVER (PARTITION BY sale_date ORDER BY amount DESC) AS daily_rank
--   FROM sales;
--   -> Confirm: Tez execution plan with vectorized window operators
-- =============================================================================
