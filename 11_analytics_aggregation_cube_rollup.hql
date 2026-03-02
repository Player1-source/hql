-- =============================================================================
-- 11. Analytics Aggregation: CUBE and ROLLUP
-- Hive 4.0 Migration Notes:
--   * OLD syntax: GROUP BY x, y WITH ROLLUP / WITH CUBE
--     NEW syntax: GROUP BY ROLLUP(x, y) / GROUP BY CUBE(x, y)
--     The standard SQL form is preferred in Hive 4.0. The old form still works
--     but is deprecated and may be removed in future versions.
--   * GROUPING SETS syntax is also supported for custom aggregation levels.
--   * Use GROUPING() function to identify aggregation level of each row.
-- =============================================================================

-- ROLLUP: generates subtotals from right to left
-- Produces: (product_id, sale_date), (product_id), ()
SELECT product_id, sale_date, SUM(amount) AS total_amount,
    GROUPING(product_id) AS grp_product,
    GROUPING(sale_date) AS grp_date
FROM sales
GROUP BY ROLLUP(product_id, sale_date);

-- CUBE: generates all possible subtotal combinations
-- Produces: (product_id, sale_date), (product_id), (sale_date), ()
SELECT product_id, sale_date, SUM(amount) AS total_amount,
    GROUPING(product_id) AS grp_product,
    GROUPING(sale_date) AS grp_date
FROM sales
GROUP BY CUBE(product_id, sale_date);

-- GROUPING SETS: explicit control over aggregation levels
SELECT product_id, sale_date, SUM(amount) AS total_amount
FROM sales
GROUP BY product_id, sale_date
GROUPING SETS ((product_id, sale_date), (product_id), ());
