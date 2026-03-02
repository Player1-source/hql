-- =============================================================================
-- 02. Partitioned and Bucketed Table
-- Hive 4.0 Migration Notes:
--   * hive.exec.dynamic.partition=true is now the DEFAULT. No need to SET it.
--   * hive.exec.dynamic.partition.mode=nonstrict is still needed if you want
--     to allow all partition columns to be dynamic (no static partition required).
--   * CLUSTERED BY is no longer mandatory for ACID tables in Hive 4.0.
--     It is still useful for performance (bucketing improves join & sampling).
--   * Managed ORC tables are ACID by default; this table will automatically
--     support UPDATE/DELETE/MERGE without extra TBLPROPERTIES.
-- =============================================================================

USE retail_db;

CREATE TABLE IF NOT EXISTS sales (
    sale_id BIGINT,
    customer_id INT,
    product_id INT,
    quantity INT,
    amount DECIMAL(12,2)
)
PARTITIONED BY (sale_date DATE)
CLUSTERED BY (customer_id) INTO 8 BUCKETS
STORED AS ORC;

-- Hive 4.0: dynamic.partition=true is the default, so this SET is removed.
-- Keeping nonstrict mode explicitly for clarity (allows fully dynamic partitions).
SET hive.exec.dynamic.partition.mode=nonstrict;
