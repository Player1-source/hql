-- Modernized for Apache Hive 4.2.0
-- Source version inferred: Hive 2.x (cross-version compatible LATERAL VIEW syntax)
-- Applied changes: Added modernization header; syntax fully compatible with 4.2.0
-- Iceberg recommendation: No (read-only analytical query)

-- =============================================================================
-- 09: Lateral View Explode
-- =============================================================================
-- LATERAL VIEW explode() is fully supported in Hive 4.2.0.
-- Vectorized execution improves explode performance on large arrays.
-- =============================================================================

SELECT id, tag
FROM nested_data
LATERAL VIEW explode(tags) t AS tag;

-- =============================================================================
-- Verification Steps
-- =============================================================================
-- EXPLAIN
--   SELECT id, tag FROM nested_data LATERAL VIEW explode(tags) t AS tag;
--   -> Confirm: Tez plan with UDTF operator for explode
-- =============================================================================
