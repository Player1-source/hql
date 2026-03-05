-- Modernized for Apache Hive 4.2.0
-- Source version inferred: Hive 2.x (implicit UNION DISTINCT via bare UNION keyword)
-- Applied changes: Made UNION DISTINCT explicit for clarity and ANSI SQL compliance
-- Iceberg recommendation: No (read-only set operation query)

-- =============================================================================
-- 10: UNION ALL and UNION DISTINCT
-- =============================================================================
-- In Hive 4.2.0:
--   - UNION (bare) is equivalent to UNION DISTINCT — deduplicates rows
--   - Best practice: always write UNION DISTINCT explicitly for clarity
--   - UNION ALL retains all rows without deduplication
-- =============================================================================

-- UNION ALL: returns all rows from both queries (no deduplication)
SELECT customer_id FROM sales_2023
UNION ALL
SELECT customer_id FROM sales_2024;

-- UNION DISTINCT: returns deduplicated rows (explicit syntax preferred in 4.2.0)
SELECT customer_id FROM sales_2023
UNION DISTINCT
SELECT customer_id FROM sales_2024;

-- =============================================================================
-- Verification Steps
-- =============================================================================
-- EXPLAIN
--   SELECT customer_id FROM sales_2023
--   UNION DISTINCT
--   SELECT customer_id FROM sales_2024;
--   -> Confirm: Tez plan includes Group By operator for deduplication
-- EXPLAIN
--   SELECT customer_id FROM sales_2023
--   UNION ALL
--   SELECT customer_id FROM sales_2024;
--   -> Confirm: Tez plan has NO Group By (simple append)
-- =============================================================================
