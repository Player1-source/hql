-- Modernized for Apache Hive 4.2.0
-- Source version inferred: Hive 2.x (explicit SET for tez, vectorization, and CBO — all now defaults)
-- Applied changes: Removed all redundant SET statements (Tez-only, vectorization on, CBO on by default)
-- Iceberg recommendation: No (performance tuning and query plan analysis)

-- =============================================================================
-- 20: Performance Settings and EXPLAIN
-- =============================================================================
-- BREAKING CHANGES (Hive 4.2.0):
--   - Tez is the ONLY execution engine (MapReduce and LLAP fully removed)
--   - hive.vectorized.execution.enabled = true (default)
--   - hive.cbo.enable = true (default)
--   - No need to SET these manually anymore
-- =============================================================================

-- NOTE: The following SET statements have been removed as they are now defaults in Hive 4.2.0:
--   SET hive.execution.engine=tez;                  -- Tez is the only engine
--   SET hive.vectorized.execution.enabled=true;     -- default: true
--   SET hive.cbo.enable=true;                       -- default: true

EXPLAIN ANALYZE
SELECT customer_id, SUM(amount) AS total_amount
FROM sales
GROUP BY customer_id;

-- =============================================================================
-- Verification Steps
-- =============================================================================
-- SET hive.execution.engine;
--   -> Confirm: tez (only valid value)
-- SET hive.vectorized.execution.enabled;
--   -> Confirm: true
-- SET hive.cbo.enable;
--   -> Confirm: true
-- Run the EXPLAIN ANALYZE above:
--   -> Confirm: Tez execution plan with vectorized GroupBy operator
-- =============================================================================
