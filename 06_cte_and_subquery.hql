-- Modernized for Apache Hive 4.2.0
-- Source version inferred: Hive 2.x (missing AS keyword for column alias)
-- Applied changes: Added explicit AS keyword for column alias (ANSI SQL compliance); expanded SELECT list
-- Iceberg recommendation: No (read-only analytical query)

-- =============================================================================
-- 06: CTE and Subquery
-- =============================================================================
-- In Hive 4.2.0, ANSI SQL compliance is stricter.
-- Column aliases should use the explicit AS keyword for clarity and compliance.
-- CTE (WITH clause) scoping and optimization are improved.
-- =============================================================================

WITH high_value_customers AS (
    SELECT customer_id, SUM(amount) AS total_spent
    FROM sales
    GROUP BY customer_id
    HAVING SUM(amount) > 10000
)
SELECT c.customer_id,
       c.first_name,
       c.last_name,
       c.email,
       h.total_spent
FROM customers c
JOIN high_value_customers h
ON c.customer_id = h.customer_id;

-- =============================================================================
-- Verification Steps
-- =============================================================================
-- EXPLAIN
--   WITH high_value_customers AS (
--       SELECT customer_id, SUM(amount) AS total_spent
--       FROM sales GROUP BY customer_id HAVING SUM(amount) > 10000
--   )
--   SELECT c.customer_id, c.first_name, c.last_name, c.email, h.total_spent
--   FROM customers c JOIN high_value_customers h ON c.customer_id = h.customer_id;
--   -> Confirm: CTE is materialized or inlined efficiently by CBO
-- =============================================================================
