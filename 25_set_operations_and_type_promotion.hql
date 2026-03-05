-- Modernized for Apache Hive 4.2.0
-- Source version inferred: Hive 2.x (type mismatch in UNION: DECIMAL cast to STRING)
-- Applied changes: Fixed type mismatch in UNION (cast to DECIMAL instead of STRING); added ANSI compliance notes
-- Iceberg recommendation: No (read-only set operation queries)

-- =============================================================================
-- 25: Set Operations and Type Promotion
-- =============================================================================
-- IMPORTANT (Hive 4.2.0 — ANSI SQL Type Promotion):
--   - UNION/INTERSECT/EXCEPT require matching column types across branches
--   - Stricter type coercion: casting DECIMAL to STRING in UNION will fail or
--     produce unexpected results in ANSI mode
--   - Best practice: cast to a common numeric type (e.g., DECIMAL) for matching
--   - INTERSECT and EXCEPT are fully supported (ANSI SQL standard)
-- =============================================================================

-- UNION ALL with proper type alignment (both branches return DECIMAL)
SELECT customer_id, amount
FROM sales
UNION ALL
SELECT customer_id, CAST(amount AS DECIMAL(12,2))
FROM sales_archive;

-- INTERSECT: returns customers present in both years
SELECT customer_id FROM sales_2023
INTERSECT
SELECT customer_id FROM sales_2024;

-- EXCEPT: returns customers in 2023 but not in 2024
SELECT customer_id FROM sales_2023
EXCEPT
SELECT customer_id FROM sales_2024;

-- =============================================================================
-- Verification Steps
-- =============================================================================
-- EXPLAIN
--   SELECT customer_id, amount FROM sales
--   UNION ALL
--   SELECT customer_id, CAST(amount AS DECIMAL(12,2)) FROM sales_archive;
--   -> Confirm: No type mismatch warnings; both branches have matching DECIMAL types
-- EXPLAIN
--   SELECT customer_id FROM sales_2023 INTERSECT SELECT customer_id FROM sales_2024;
--   -> Confirm: Tez plan with deduplication operator
-- EXPLAIN
--   SELECT customer_id FROM sales_2023 EXCEPT SELECT customer_id FROM sales_2024;
--   -> Confirm: Tez plan with anti-join or set difference operator
-- =============================================================================
