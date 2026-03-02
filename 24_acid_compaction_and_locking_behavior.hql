-- =============================================================================
-- 24. ACID Compaction and Locking Behavior
-- Hive 4.0 Migration Notes:
--   * Lockless reads: readers no longer block on writers (zero-wait readers).
--   * Optimistic concurrency control for write-write conflicts.
--   * Auto-compaction is improved with compaction pooling and prioritization.
--   * NEW: Rebalance compaction for evening out file sizes.
--   * NEW: Compaction observability via SHOW COMPACTIONS with more detail.
--   * SHOW LOCKS syntax is enhanced in Hive 4.0.
--   * All managed tables are ACID by default, so compaction applies to all of them.
-- =============================================================================

-- Insert test data
INSERT INTO transactions_acid VALUES (10, 2001, 500.00, 'CREDIT');
INSERT INTO transactions_acid VALUES (11, 2001, 300.00, 'DEBIT');

-- MINOR compaction: merges delta files only (fast)
ALTER TABLE transactions_acid COMPACT 'MINOR';

-- MAJOR compaction: merges all files into a single base file (thorough)
ALTER TABLE transactions_acid COMPACT 'MAJOR';

-- View compaction status (enhanced in Hive 4.0 with more detail)
SHOW COMPACTIONS;

-- Show current locks (enhanced in Hive 4.0)
SHOW LOCKS;

-- Hive 4.0: Compaction pooling settings for prioritization
-- SET compactor.worker.threads=4;
-- SET compactor.initiator.on=true;
