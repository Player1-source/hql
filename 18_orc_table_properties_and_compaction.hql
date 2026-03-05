-- Modernized for Apache Hive 4.2.0
-- Source version inferred: Hive 2.x (ZLIB compression; manual compaction only)
-- Applied changes: Changed orc.compress from ZLIB to ZSTD (4.2.0 default); noted auto-compaction
-- Iceberg recommendation: Conditional — see note below

-- =============================================================================
-- 18: ORC Table Properties and Compaction
-- =============================================================================
-- BREAKING CHANGES (Hive 4.2.0):
--   - Default ORC compression is now ZSTD (better compression ratio + speed vs ZLIB)
--   - Auto-compaction is available: set 'compactor.initiator.on'='true' at table level
--   - Manual COMPACT commands still work but are less necessary with auto-compaction
--   - For tables with heavy compaction needs, consider Iceberg v3 migration
-- =============================================================================

-- Manual compaction (still supported)
ALTER TABLE transactions_acid COMPACT 'MAJOR';
SHOW COMPACTIONS;

-- Update compression to ZSTD (Hive 4.2.0 preferred default)
ALTER TABLE sales SET TBLPROPERTIES ('orc.compress'='ZSTD');

-- Enable auto-compaction (Hive 4.2.0 feature)
ALTER TABLE transactions_acid SET TBLPROPERTIES (
    'compactor.initiator.on'='true',
    'compactorthreshold.hive.compactor.delta.num.threshold'='4',
    'compactorthreshold.hive.compactor.delta.pct.threshold'='0.1'
);

-- NOTE: For tables with frequent compaction, heavy JSON, or partition explosion,
-- consider migrating to Iceberg v3 (see Iceberg recommendation in migration report).

-- =============================================================================
-- Verification Steps
-- =============================================================================
-- SHOW TBLPROPERTIES sales;
--   -> Confirm: orc.compress = ZSTD
-- SHOW TBLPROPERTIES transactions_acid;
--   -> Confirm: compactor.initiator.on = true
-- SHOW COMPACTIONS;
--   -> Confirm: compaction request submitted for transactions_acid
-- =============================================================================
