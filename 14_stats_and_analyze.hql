-- Modernized for Apache Hive 4.2.0
-- Source version inferred: Hive 2.x (basic ANALYZE TABLE syntax without column-level stats)
-- Applied changes: Added column-level statistics (FOR COLUMNS); added modernization header
-- Iceberg recommendation: No (metadata operation only)

-- =============================================================================
-- 14: Statistics and ANALYZE
-- =============================================================================
-- In Hive 4.2.0:
--   - Column-level statistics significantly improve CBO query planning
--   - Auto-gather stats is enabled by default (hive.stats.autogather=true)
--   - ANALYZE TABLE ... FOR COLUMNS computes min/max/NDV/nulls per column
--   - Partition-level stats are essential for partition pruning optimization
-- =============================================================================

-- Table-level statistics
ANALYZE TABLE sales COMPUTE STATISTICS;

-- Partition-level statistics
ANALYZE TABLE sales PARTITION (sale_date) COMPUTE STATISTICS;

-- Column-level statistics (recommended for CBO optimization in 4.2.0)
ANALYZE TABLE sales COMPUTE STATISTICS FOR COLUMNS
    sale_id, customer_id, product_id, quantity, amount;

-- =============================================================================
-- Verification Steps
-- =============================================================================
-- DESCRIBE FORMATTED sales;
--   -> Confirm: Table Parameters include numRows, rawDataSize, numFiles
-- DESCRIBE FORMATTED sales PARTITION (sale_date='2023-01-01');
--   -> Confirm: Partition-level statistics present
-- DESCRIBE FORMATTED sales sale_id;
--   -> Confirm: Column statistics (min, max, NDV, num_nulls) present
-- =============================================================================
