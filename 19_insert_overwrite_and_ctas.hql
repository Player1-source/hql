-- Modernized for Apache Hive 4.2.0
-- Source version inferred: Hive 2.x (CTAS without explicit storage format)
-- Applied changes: Added explicit STORED AS ORC for CTAS; added column aliases with AS keyword
-- Iceberg recommendation: No (simple aggregation table)

-- =============================================================================
-- 19: INSERT OVERWRITE and CTAS (Create Table As Select)
-- =============================================================================
-- In Hive 4.2.0:
--   - CTAS creates a managed table (ACID by default for ORC)
--   - Explicit STORED AS ORC is recommended for clarity
--   - INSERT OVERWRITE atomically replaces table/partition data
-- =============================================================================

CREATE TABLE yearly_sales
STORED AS ORC
AS
SELECT year(sale_date) AS sales_year, SUM(amount) AS total_sales
FROM sales
GROUP BY year(sale_date);

INSERT OVERWRITE TABLE yearly_sales
SELECT year(sale_date) AS sales_year, SUM(amount) AS total_sales
FROM sales
GROUP BY year(sale_date);

-- =============================================================================
-- Verification Steps
-- =============================================================================
-- DESCRIBE FORMATTED yearly_sales;
--   -> Confirm: STORED AS ORC, transactional=true (auto for managed ORC)
-- SELECT * FROM yearly_sales;
--   -> Confirm: aggregated yearly sales data
-- =============================================================================
