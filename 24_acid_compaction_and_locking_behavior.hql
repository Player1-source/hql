-- Modernized for Apache Hive 4.2.0
-- Source version inferred: Hive 2.x (manual compaction only; no auto-compaction configuration)
-- Applied changes: Added auto-compaction configuration; noted lock manager changes in 4.2.0
-- Iceberg recommendation: No (operational compaction demonstration)

-- =============================================================================
-- 24: ACID Compaction and Locking Behavior
-- =============================================================================
-- In Hive 4.2.0:
--   - Auto-compaction is available and recommended for ACID tables
--   - Manual COMPACT commands still work for on-demand compaction
--   - Lock manager behavior is improved with better deadlock detection
--   - Compaction runs asynchronously via the Compactor service
--   - MINOR compaction: merges delta files only
--   - MAJOR compaction: merges all delta + base files into a single base file
-- =============================================================================

INSERT INTO transactions_acid VALUES (10, 2001, 500.00, 'CREDIT');
INSERT INTO transactions_acid VALUES (11, 2001, 300.00, 'DEBIT');

-- Manual compaction (on-demand)
ALTER TABLE transactions_acid COMPACT 'MINOR';
ALTER TABLE transactions_acid COMPACT 'MAJOR';
SHOW COMPACTIONS;

-- Recommended: Enable auto-compaction for ACID tables in Hive 4.2.0
-- ALTER TABLE transactions_acid SET TBLPROPERTIES (
--     'compactor.initiator.on'='true',
--     'compactorthreshold.hive.compactor.delta.num.threshold'='4',
--     'compactorthreshold.hive.compactor.delta.pct.threshold'='0.1'
-- );

-- =============================================================================
-- Verification Steps
-- =============================================================================
-- SHOW COMPACTIONS;
--   -> Confirm: MINOR and MAJOR compaction requests queued or completed
-- SELECT * FROM transactions_acid WHERE account_id = 2001;
--   -> Confirm: both rows present (txn_id 10 and 11)
-- SHOW LOCKS transactions_acid;
--   -> Confirm: no stuck locks after DML operations
-- =============================================================================
