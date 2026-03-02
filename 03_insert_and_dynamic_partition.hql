-- =============================================================================
-- 03. Insert with Dynamic Partitioning
-- Hive 4.0 Migration Notes:
--   * The TABLE keyword in INSERT INTO TABLE is optional (always was, but
--     now INSERT INTO <table> is the preferred shorter form).
--   * Dynamic partitioning is enabled by default in Hive 4.0.
--   * The partition column (sale_date) must be the LAST column in SELECT.
--   * Hive 4.0 auto-gathers statistics after INSERT, so no manual
--     ANALYZE TABLE is needed for basic stats.
-- =============================================================================

-- Insert from staging table with dynamic partition on sale_date.
-- Changed: Removed redundant TABLE keyword (Hive 4.0 preferred style).
INSERT INTO sales PARTITION (sale_date)
SELECT sale_id, customer_id, product_id, quantity, amount, sale_date
FROM staging_sales;
