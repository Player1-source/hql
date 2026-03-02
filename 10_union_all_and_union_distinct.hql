-- =============================================================================
-- 10. UNION ALL and UNION DISTINCT
-- Hive 4.0 Migration Notes:
--   * UNION (without ALL) is explicitly UNION DISTINCT in Hive 4.0.
--     Both forms are supported; UNION DISTINCT is preferred for clarity.
--   * Column types must match or be implicitly castable across branches.
--   * Hive 4.0 enforces stricter type checking for UNION operations.
-- =============================================================================

-- UNION ALL: keeps all rows including duplicates
SELECT customer_id FROM sales_2023
UNION ALL
SELECT customer_id FROM sales_2024;

-- UNION DISTINCT: removes duplicates (preferred explicit form in Hive 4.0)
SELECT customer_id FROM sales_2023
UNION DISTINCT
SELECT customer_id FROM sales_2024;
