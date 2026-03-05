-- Modernized for Apache Hive 4.2.0
-- Source version inferred: Hive 2.x/3.x (materialized view syntax)
-- Applied changes: Added STORED AS ORC explicitly; added modernization header
-- Iceberg recommendation: No (small aggregation view; no compaction concerns)

-- =============================================================================
-- 13: Materialized View
-- =============================================================================
-- In Hive 4.2.0:
--   - Materialized views support automatic query rewriting (enabled by default)
--   - BUILD IMMEDIATE and REFRESH COMPLETE remain valid syntax
--   - Materialized views are stored as managed ACID tables by default
--   - Incremental rebuild is supported for eligible views
-- =============================================================================

CREATE MATERIALIZED VIEW IF NOT EXISTS mv_daily_sales
STORED AS ORC
AS
SELECT sale_date, SUM(amount) AS total_sales
FROM sales
GROUP BY sale_date;

-- NOTE: BUILD IMMEDIATE is the default behavior; REFRESH COMPLETE removed from
-- CREATE statement as it only applies to ALTER MATERIALIZED VIEW ... REBUILD.

-- To refresh the materialized view:
-- ALTER MATERIALIZED VIEW mv_daily_sales REBUILD;

-- =============================================================================
-- Verification Steps
-- =============================================================================
-- DESCRIBE FORMATTED mv_daily_sales;
--   -> Confirm: Table Type = MATERIALIZED_VIEW, STORED AS ORC
-- SHOW TBLPROPERTIES mv_daily_sales;
--   -> Confirm: transactional=true (auto)
-- EXPLAIN
--   SELECT sale_date, SUM(amount) AS total_sales FROM sales GROUP BY sale_date;
--   -> Confirm: CBO may rewrite this query to use mv_daily_sales automatically
-- =============================================================================
