-- Modernized for Apache Hive 4.2.0
-- Source version inferred: Hive 2.x (bare ORDER BY without explicit NULL ordering)
-- Applied changes: Added explicit NULLS LAST to bare ORDER BY for deterministic behavior
-- Iceberg recommendation: No (read-only ordering query)

-- =============================================================================
-- 23: NULL Ordering Behavior
-- =============================================================================
-- IMPORTANT (Hive 4.2.0):
--   - Default NULL ordering may differ from Hive 2.x
--   - Best practice: ALWAYS specify NULLS FIRST or NULLS LAST explicitly
--   - This ensures deterministic, portable behavior across Hive versions
--   - ASC default: NULLs sort first (NULLS FIRST)
--   - DESC default: NULLs sort last (NULLS LAST)
-- =============================================================================

-- Explicit NULLS LAST for ascending order (recommended best practice)
SELECT customer_id, amount
FROM sales
ORDER BY amount ASC NULLS LAST;

-- Explicit NULLS FIRST
SELECT customer_id, amount
FROM sales
ORDER BY amount ASC NULLS FIRST;

-- Explicit NULLS LAST
SELECT customer_id, amount
FROM sales
ORDER BY amount DESC NULLS LAST;

-- =============================================================================
-- Verification Steps
-- =============================================================================
-- Run each query and verify NULL positioning:
--   -> Query 1: NULLs appear at end of ascending results
--   -> Query 2: NULLs appear at start of ascending results
--   -> Query 3: NULLs appear at end of descending results
-- =============================================================================
