-- Modernized for Apache Hive 4.2.0
-- Source version inferred: Hive 2.x (explicit SET hive.exec.dynamic.partition and mode=nonstrict)
-- Applied changes: Removed redundant SET statements (dynamic partition enabled + nonstrict mode are defaults in 4.2.0)
-- Iceberg recommendation: No (standard partitioned/bucketed table; no excessive partition explosion observed)

-- =============================================================================
-- 02: Partitioned and Bucketed Table
-- =============================================================================
-- In Hive 4.2.0:
--   - hive.exec.dynamic.partition = true (default)
--   - hive.exec.dynamic.partition.mode = nonstrict (default)
--   - Managed ORC tables are ACID by default
--   - Bucketing enforcement is enabled by default (hive.enforce.bucketing = true)
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

-- NOTE: The following SET statements have been removed as they are now defaults in Hive 4.2.0:
--   SET hive.exec.dynamic.partition=true;            -- default: true
--   SET hive.exec.dynamic.partition.mode=nonstrict;  -- default: nonstrict

-- =============================================================================
-- Verification Steps
-- =============================================================================
-- DESCRIBE FORMATTED retail_db.sales;
--   -> Confirm: Partition columns = sale_date, Bucket columns = customer_id, Num Buckets = 8
-- SHOW TBLPROPERTIES sales;
--   -> Confirm: transactional=true (auto for managed ORC)
-- SET hive.exec.dynamic.partition;
--   -> Confirm: true
-- SET hive.exec.dynamic.partition.mode;
--   -> Confirm: nonstrict
-- =============================================================================
