-- =============================================================================
-- 18. ORC Table Properties and Compaction
-- Hive 4.0 Migration Notes:
--   * Default ORC compression changed from ZLIB to ZSTD in Hive 4.0.
--     ZSTD offers better compression ratios and faster decompression.
--   * ALTER TABLE ... COMPACT syntax is unchanged.
--   * Hive 4.0 supports OPTIMIZE TABLE syntax for compaction (Iceberg-style).
--   * Auto-compaction is improved with compaction pooling and prioritization.
--   * Rebalance compaction is new in Hive 4.0 for evening out file sizes.
-- =============================================================================

-- Trigger major compaction
ALTER TABLE transactions_acid COMPACT 'MAJOR';
SHOW COMPACTIONS;

-- Hive 4.0: Default compression is now ZSTD (changed from ZLIB).
-- Update existing tables to use ZSTD for better performance.
ALTER TABLE sales SET TBLPROPERTIES ('orc.compress'='ZSTD');

-- ORC stripe and bloom filter settings for optimization
ALTER TABLE sales SET TBLPROPERTIES (
    'orc.stripe.size'='67108864',
    'orc.bloom.filter.columns'='customer_id,product_id'
);
