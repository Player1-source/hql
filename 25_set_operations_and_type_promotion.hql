-- =============================================================================
-- 25. Set Operations and Type Promotion
-- Hive 4.0 Migration Notes:
--   * INTERSECT and EXCEPT are fully supported (available since Hive 2.3).
--   * NEW in Hive 4.0: INTERSECT ALL and EXCEPT ALL retain duplicates.
--   * INTERSECT DISTINCT and EXCEPT DISTINCT are the explicit deduplicated forms.
--   * Type promotion: Hive 4.0 has stricter type checking across UNION branches.
--     Ensure column types are compatible or use explicit CAST.
--   * Best practice: always use explicit CAST for type mismatches.
-- =============================================================================

-- UNION ALL with explicit CAST for type mismatch (amount vs STRING)
SELECT customer_id, amount FROM sales
UNION ALL
SELECT customer_id, CAST(amount AS DECIMAL(12,2)) FROM sales_archive;

-- INTERSECT DISTINCT: customers present in both years (deduplicated)
SELECT customer_id FROM sales_2023
INTERSECT DISTINCT
SELECT customer_id FROM sales_2024;

-- EXCEPT DISTINCT: customers in 2023 but not in 2024 (deduplicated)
SELECT customer_id FROM sales_2023
EXCEPT DISTINCT
SELECT customer_id FROM sales_2024;

-- NEW in Hive 4.0: INTERSECT ALL (retains duplicates)
SELECT customer_id FROM sales_2023
INTERSECT ALL
SELECT customer_id FROM sales_2024;

-- NEW in Hive 4.0: EXCEPT ALL (retains duplicates)
SELECT customer_id FROM sales_2023
EXCEPT ALL
SELECT customer_id FROM sales_2024;
