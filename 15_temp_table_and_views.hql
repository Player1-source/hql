-- Modernized for Apache Hive 4.2.0
-- Source version inferred: Hive 2.x (cross-version compatible temporary table and view syntax)
-- Applied changes: Added modernization header; syntax fully compatible with 4.2.0
-- Iceberg recommendation: No (session-scoped and virtual objects)

-- =============================================================================
-- 15: Temporary Tables and Views
-- =============================================================================
-- In Hive 4.2.0:
--   - Temporary tables are session-scoped and dropped on session end
--   - Views are virtual and do not store data
--   - Both are fully supported with Tez execution
-- =============================================================================

-- Session-scoped temporary table (dropped automatically when session ends)
CREATE TEMPORARY TABLE temp_sales AS
SELECT * FROM sales WHERE amount > 500;

-- Persistent view (virtual, no data stored)
CREATE VIEW IF NOT EXISTS vw_high_sales AS
SELECT * FROM sales WHERE amount > 1000;

-- =============================================================================
-- Verification Steps
-- =============================================================================
-- SELECT COUNT(*) FROM temp_sales;
--   -> Confirm: returns rows where amount > 500
-- DESCRIBE FORMATTED vw_high_sales;
--   -> Confirm: Table Type = VIRTUAL_VIEW
-- SHOW TABLES;
--   -> Confirm: temp_sales visible in current session; vw_high_sales is persistent
-- =============================================================================
