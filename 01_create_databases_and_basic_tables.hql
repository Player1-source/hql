-- Modernized for Apache Hive 4.2.0
-- Source version inferred: Hive 2.x (managed ORC tables required explicit transactional property)
-- Applied changes: Added modernization header; noted ACID-by-default behavior for managed ORC tables
-- Iceberg recommendation: No (simple reference tables; no compaction/partition explosion concerns)

-- =============================================================================
-- 01: Create Databases and Basic Tables
-- =============================================================================
-- IMPORTANT (Hive 4.2.0): Managed ORC tables are ACID/transactional by default.
-- No explicit TBLPROPERTIES ('transactional'='true') is needed.
-- External tables remain non-transactional and unaffected by this change.
-- =============================================================================

CREATE DATABASE IF NOT EXISTS retail_db COMMENT 'Retail analytics database';
USE retail_db;

-- Managed ORC table: automatically ACID-enabled in Hive 4.2.0
CREATE TABLE IF NOT EXISTS customers (
    customer_id INT,
    first_name STRING,
    last_name STRING,
    email STRING,
    created_date DATE
)
STORED AS ORC;

-- External table: Hive manages schema only, not the underlying data files
CREATE EXTERNAL TABLE IF NOT EXISTS ext_products (
    product_id INT,
    product_name STRING,
    category STRING,
    price DECIMAL(10,2)
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
LOCATION '/data/products/';

-- =============================================================================
-- Verification Steps
-- =============================================================================
-- DESCRIBE FORMATTED retail_db.customers;
--   -> Confirm: Table Type = MANAGED_TABLE, transactional = true (auto)
-- DESCRIBE FORMATTED retail_db.ext_products;
--   -> Confirm: Table Type = EXTERNAL_TABLE
-- SHOW TBLPROPERTIES customers;
--   -> Confirm: transactional=true is implicit for managed ORC
-- =============================================================================
