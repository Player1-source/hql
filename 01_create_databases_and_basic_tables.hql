-- =============================================================================
-- 01. Create Databases and Basic Tables
-- Hive 4.0 Migration Notes:
--   * All managed tables are ACID/transactional by default in Hive 4.0.
--     No need for explicit TBLPROPERTIES ('transactional'='true').
--   * Managed ORC tables automatically support INSERT/UPDATE/DELETE/MERGE.
--   * External tables remain non-transactional (unchanged behavior).
--   * IF NOT EXISTS is still recommended for idempotent DDL.
--   * DATABASE properties now support cloud object-store paths (s3a://, gs://, abfs://).
-- =============================================================================

CREATE DATABASE IF NOT EXISTS retail_db
    COMMENT 'Retail analytics database';

USE retail_db;

-- Managed table: automatically ACID in Hive 4.0 (ORC is the default format).
-- Supports full DML (INSERT, UPDATE, DELETE, MERGE) without any extra config.
CREATE TABLE IF NOT EXISTS customers (
    customer_id INT,
    first_name STRING,
    last_name STRING,
    email STRING,
    created_date DATE
)
STORED AS ORC;

-- External table: NOT transactional. Hive manages schema only, not the data files.
-- ROW FORMAT DELIMITED is still valid for text/CSV-based external tables.
CREATE EXTERNAL TABLE IF NOT EXISTS ext_products (
    product_id INT,
    product_name STRING,
    category STRING,
    price DECIMAL(10,2)
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/data/products/';
