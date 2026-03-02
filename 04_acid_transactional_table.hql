-- =============================================================================
-- 04. ACID Transactional Table
-- Hive 4.0 Migration Notes:
--   * ALL managed tables are ACID by default in Hive 4.0.
--     TBLPROPERTIES ('transactional'='true') is NO LONGER REQUIRED (removed below).
--   * CLUSTERED BY is NO LONGER REQUIRED for ACID tables (was mandatory in Hive 2.x).
--     Bucketing is kept here for performance optimization only.
--   * INSERT, UPDATE, DELETE, and MERGE INTO are all fully supported.
--   * Hive 4.0 supports lockless reads and optimistic concurrency control.
--   * New MERGE INTO syntax provides upsert capability (shown below).
-- =============================================================================

USE retail_db;

-- Hive 4.0: Removed TBLPROPERTIES ('transactional'='true') -- now implicit.
-- CLUSTERED BY is optional but retained for performance.
CREATE TABLE IF NOT EXISTS transactions_acid (
    txn_id BIGINT,
    account_id INT,
    txn_amount DECIMAL(12,2),
    txn_type STRING
)
CLUSTERED BY (account_id) INTO 4 BUCKETS
STORED AS ORC;

-- Standard DML operations (fully supported without extra config in Hive 4.0)
INSERT INTO transactions_acid VALUES (1, 1001, 200.50, 'DEBIT');
UPDATE transactions_acid SET txn_amount = txn_amount + 10 WHERE txn_id = 1;
DELETE FROM transactions_acid WHERE txn_id = 1;

-- NEW in Hive 4.0: MERGE INTO for upsert operations
-- MERGE INTO transactions_acid AS target
-- USING staging_transactions AS source
-- ON target.txn_id = source.txn_id
-- WHEN MATCHED THEN UPDATE SET txn_amount = source.txn_amount
-- WHEN NOT MATCHED THEN INSERT VALUES
--     (source.txn_id, source.account_id, source.txn_amount, source.txn_type);
