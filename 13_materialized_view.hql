-- =============================================================================
-- 13. Materialized Views
-- Hive 4.0 Migration Notes:
--   * BUILD IMMEDIATE is the default and can be omitted.
--   * REFRESH COMPLETE in CREATE syntax is optional (defines default refresh mode).
--   * Use ALTER MATERIALIZED VIEW ... REBUILD to refresh the view.
--   * Hive 4.0 supports incremental rebuild for materialized views when the
--     source tables are ACID (which is now the default for managed tables).
--   * Materialized views can be stored in Iceberg format for better performance.
--   * The optimizer can automatically rewrite queries to use materialized views.
-- =============================================================================

-- CREATE: BUILD IMMEDIATE is the default, STORED AS ORC is recommended
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_daily_sales
STORED AS ORC
AS
SELECT sale_date, SUM(amount) AS total_sales
FROM sales
GROUP BY sale_date;

-- Refresh the materialized view (Hive 4.0 preferred syntax)
ALTER MATERIALIZED VIEW mv_daily_sales REBUILD;

-- Enable automatic query rewriting to use materialized views
SET hive.materializedview.rewriting=true;
