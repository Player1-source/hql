-- =============================================================================
-- 05. Window Functions
-- Hive 4.0 Migration Notes:
--   * Window functions syntax is unchanged in Hive 4.0.
--   * Performance: vectorized execution is now enabled by default,
--     accelerating window function processing on ORC/Parquet data.
--   * Additional window functions available: PERCENT_RANK(), CUME_DIST(),
--     NTILE(), NTH_VALUE(), FIRST_VALUE(), LAST_VALUE().
-- =============================================================================

SELECT
    customer_id,
    sale_date,
    amount,
    SUM(amount) OVER (
        PARTITION BY customer_id
        ORDER BY sale_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total,
    RANK() OVER (
        PARTITION BY sale_date
        ORDER BY amount DESC
    ) AS daily_rank,
    -- Additional window functions available in Hive 4.0
    PERCENT_RANK() OVER (
        PARTITION BY sale_date
        ORDER BY amount DESC
    ) AS pct_rank,
    NTILE(4) OVER (
        PARTITION BY sale_date
        ORDER BY amount DESC
    ) AS quartile
FROM sales;
