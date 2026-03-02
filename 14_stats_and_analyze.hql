-- =============================================================================
-- 14. Table Statistics and ANALYZE
-- Hive 4.0 Migration Notes:
--   * hive.stats.autogather=true is now the DEFAULT. Statistics are automatically
--     gathered on INSERT/LOAD operations (no need for manual ANALYZE for basic stats).
--   * Column-level statistics (FOR COLUMNS) are important for CBO optimization.
--   * ANALYZE TABLE ... COMPUTE STATISTICS FOR COLUMNS is recommended.
--   * hive.stats.column.autogather=true can be set to auto-gather column stats.
-- =============================================================================

-- Basic table-level statistics (auto-gathered in Hive 4.0, manual run is optional)
ANALYZE TABLE sales COMPUTE STATISTICS;

-- Partition-level statistics
ANALYZE TABLE sales PARTITION (sale_date) COMPUTE STATISTICS;

-- Column-level statistics (recommended for CBO in Hive 4.0)
ANALYZE TABLE sales COMPUTE STATISTICS FOR COLUMNS
    sale_id, customer_id, product_id, quantity, amount;

-- Enable auto-gather of column statistics (Hive 4.0)
SET hive.stats.column.autogather=true;
