-- =============================================================================
-- 20. Performance Settings and EXPLAIN
-- Hive 4.0 Migration Notes:
--   * hive.execution.engine=tez is now the DEFAULT (and only engine).
--     MapReduce execution support has been REMOVED.
--   * hive.vectorized.execution.enabled=true is now the DEFAULT.
--   * hive.cbo.enable=true is now the DEFAULT.
--   * All three SET commands below are NO LONGER NECESSARY (removed).
--   * EXPLAIN ANALYZE syntax is unchanged and enhanced with more detail.
--   * New: EXPLAIN CBO shows the cost-based optimizer plan.
-- =============================================================================

-- Hive 4.0: These settings are all defaults now. Shown for documentation only.
-- SET hive.execution.engine=tez;              -- DEFAULT (MapReduce removed)
-- SET hive.vectorized.execution.enabled=true; -- DEFAULT
-- SET hive.cbo.enable=true;                   -- DEFAULT

-- EXPLAIN ANALYZE: shows execution plan with runtime statistics
EXPLAIN ANALYZE
SELECT customer_id, SUM(amount) AS total_amount
FROM sales
GROUP BY customer_id;

-- NEW in Hive 4.0: EXPLAIN CBO for cost-based optimizer plan details
EXPLAIN CBO
SELECT customer_id, SUM(amount) AS total_amount
FROM sales
GROUP BY customer_id;
