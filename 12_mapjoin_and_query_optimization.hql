-- Modernized for Apache Hive 4.2.0
-- Source version inferred: Hive <=2.x (explicit MAPJOIN hint and manual SET hive.auto.convert.join)
-- Applied changes: Removed redundant SET statement; removed legacy MAPJOIN hint (auto-conversion is default)
-- Iceberg recommendation: No (read-only join query)

-- =============================================================================
-- 12: Join Optimization (formerly MapJoin)
-- =============================================================================
-- BREAKING CHANGE (Hive 4.2.0):
--   - hive.auto.convert.join = true (default) — Hive automatically converts
--     eligible joins to map joins based on table size thresholds
--   - The /*+ MAPJOIN(table) */ hint is legacy and unnecessary
--   - CBO (Cost-Based Optimizer) handles join strategy selection automatically
--   - Tez runtime optimizes shuffle joins when map join is not applicable
-- =============================================================================

-- Auto-join conversion handles optimal join strategy selection
SELECT s.sale_id, p.product_name
FROM sales s
JOIN ext_products p
ON s.product_id = p.product_id;

-- NOTE: Removed the following legacy constructs:
--   SET hive.auto.convert.join=true;    -- default in 4.2.0
--   /*+ MAPJOIN(p) */                   -- unnecessary with auto-conversion

-- =============================================================================
-- Verification Steps
-- =============================================================================
-- EXPLAIN
--   SELECT s.sale_id, p.product_name
--   FROM sales s JOIN ext_products p ON s.product_id = p.product_id;
--   -> Confirm: Tez plan shows Map Join or optimized Merge Join based on table sizes
-- SET hive.auto.convert.join;
--   -> Confirm: true
-- =============================================================================
