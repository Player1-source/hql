-- Modernized for Apache Hive 4.2.0
-- Source version inferred: Hive 2.x (dynamic partition insert pattern; depends on 02's SET statements)
-- Applied changes: Added modernization header; syntax already compatible with 4.2.0
-- Iceberg recommendation: No (standard ETL insert pattern)

-- =============================================================================
-- 03: Insert with Dynamic Partitioning
-- =============================================================================
-- In Hive 4.2.0, dynamic partitioning is enabled by default (nonstrict mode).
-- No additional SET statements are required before this insert.
-- The partition column (sale_date) must be the LAST column in the SELECT.
-- =============================================================================

INSERT INTO TABLE sales PARTITION (sale_date)
SELECT sale_id, customer_id, product_id, quantity, amount, sale_date
FROM staging_sales;

-- =============================================================================
-- Verification Steps
-- =============================================================================
-- SELECT COUNT(*) FROM sales;
--   -> Confirm: rows were inserted
-- SHOW PARTITIONS sales;
--   -> Confirm: partitions created dynamically from staging_sales.sale_date values
-- EXPLAIN INSERT INTO TABLE sales PARTITION (sale_date)
--   SELECT sale_id, customer_id, product_id, quantity, amount, sale_date
--   FROM staging_sales;
--   -> Confirm: Tez execution plan with dynamic partition writer
-- =============================================================================
