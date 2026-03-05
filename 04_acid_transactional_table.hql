-- Modernized for Apache Hive 4.2.0
-- Source version inferred: Hive 2.x (explicit TBLPROPERTIES ('transactional'='true') required)
-- Applied changes: Removed redundant transactional TBLPROPERTIES (managed ORC = ACID by default in 4.2.0)
-- Iceberg recommendation: No (small transactional table; no compaction or partition concerns)

-- =============================================================================
-- 04: ACID Transactional Table
-- =============================================================================
-- In Hive 4.2.0:
--   - ALL managed ORC tables are ACID/transactional by default
--   - No need to explicitly set TBLPROPERTIES ('transactional'='true')
--   - UPDATE and DELETE are fully supported on managed ORC tables
--   - Bucketing is still recommended for optimal ACID performance
-- =============================================================================

CREATE TABLE IF NOT EXISTS transactions_acid (
    txn_id BIGINT,
    account_id INT,
    txn_amount DECIMAL(12,2),
    txn_type STRING
)
CLUSTERED BY (account_id) INTO 4 BUCKETS
STORED AS ORC;

-- NOTE: Removed TBLPROPERTIES ('transactional'='true') — this is now the default
-- for all managed ORC tables in Hive 4.2.0.

INSERT INTO transactions_acid VALUES (1, 1001, 200.50, 'DEBIT');
UPDATE transactions_acid SET txn_amount = txn_amount + 10 WHERE txn_id = 1;
DELETE FROM transactions_acid WHERE txn_id = 1;

-- =============================================================================
-- Verification Steps
-- =============================================================================
-- DESCRIBE FORMATTED transactions_acid;
--   -> Confirm: transactional=true (implicit), Table Type = MANAGED_TABLE
-- SHOW TBLPROPERTIES transactions_acid;
--   -> Confirm: transactional=true
-- SELECT * FROM transactions_acid;
--   -> Confirm: empty after DELETE (or validate each DML step individually)
-- =============================================================================
