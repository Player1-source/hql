-- Modernized for Apache Hive 4.2.0
-- Source version inferred: Hive <=2.x (legacy GROUP BY ... WITH ROLLUP/CUBE syntax)
-- Applied changes: Replaced deprecated WITH ROLLUP/CUBE with ANSI SQL GROUP BY ROLLUP()/CUBE() syntax
-- Iceberg recommendation: No (read-only analytical aggregation query)

-- =============================================================================
-- 11: Analytics Aggregation — CUBE and ROLLUP
-- =============================================================================
-- BREAKING CHANGE (Hive 4.2.0):
--   - Legacy syntax: GROUP BY col1, col2 WITH ROLLUP  (deprecated)
--   - Modern syntax: GROUP BY ROLLUP(col1, col2)      (ANSI SQL standard)
--   - Same applies to CUBE
--   - The old WITH ROLLUP/CUBE syntax may produce warnings or errors in strict mode
-- =============================================================================

-- ROLLUP: hierarchical aggregation (product_id + sale_date -> product_id -> grand total)
SELECT product_id, sale_date, SUM(amount) AS total_amount
FROM sales
GROUP BY ROLLUP(product_id, sale_date);

-- CUBE: all-combination aggregation (all subsets of {product_id, sale_date})
SELECT product_id, sale_date, SUM(amount) AS total_amount
FROM sales
GROUP BY CUBE(product_id, sale_date);

-- =============================================================================
-- Verification Steps
-- =============================================================================
-- EXPLAIN
--   SELECT product_id, sale_date, SUM(amount) AS total_amount
--   FROM sales GROUP BY ROLLUP(product_id, sale_date);
--   -> Confirm: Tez plan with GROUPING SETS operator
-- EXPLAIN
--   SELECT product_id, sale_date, SUM(amount) AS total_amount
--   FROM sales GROUP BY CUBE(product_id, sale_date);
--   -> Confirm: Tez plan with GROUPING SETS operator covering all subsets
-- =============================================================================
