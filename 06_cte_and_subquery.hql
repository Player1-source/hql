-- =============================================================================
-- 06. CTE (Common Table Expression) and Subquery
-- Hive 4.0 Migration Notes:
--   * CTE syntax is unchanged in Hive 4.0.
--   * Hive 4.0 CBO (Cost-Based Optimizer) is enabled by default,
--     improving CTE and subquery execution plans automatically.
--   * Multiple CTEs can be chained with commas (supported since Hive 0.13).
--   * Correlated subqueries have improved support in Hive 4.0.
-- =============================================================================

WITH high_value_customers AS (
    SELECT customer_id, SUM(amount) AS total_spent
    FROM sales
    GROUP BY customer_id
    HAVING SUM(amount) > 10000
)
SELECT c.customer_id, c.first_name, c.last_name, h.total_spent
FROM customers c
INNER JOIN high_value_customers h
ON c.customer_id = h.customer_id;
