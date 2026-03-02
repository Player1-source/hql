-- =============================================================================
-- 15. Temporary Tables and Views
-- Hive 4.0 Migration Notes:
--   * Temporary tables are session-scoped and dropped on session end (unchanged).
--   * Temporary tables are NOT ACID even though managed tables are ACID by default.
--   * Views syntax is unchanged. Views are logical (not materialized).
--   * Hive 4.0 supports CREATE OR REPLACE VIEW for atomic view updates.
-- =============================================================================

-- Temporary table: session-scoped, non-ACID, dropped automatically
CREATE TEMPORARY TABLE temp_sales AS
SELECT * FROM sales WHERE amount > 500;

-- Persistent view: logical query alias, no data duplication
CREATE VIEW IF NOT EXISTS vw_high_sales AS
SELECT * FROM sales WHERE amount > 1000;

-- Hive 4.0: CREATE OR REPLACE VIEW for atomic updates
-- CREATE OR REPLACE VIEW vw_high_sales AS
-- SELECT * FROM sales WHERE amount > 2000;
