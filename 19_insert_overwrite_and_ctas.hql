-- =============================================================================
-- 19. INSERT OVERWRITE and CTAS (Create Table As Select)
-- Hive 4.0 Migration Notes:
--   * CTAS-created tables are ACID by default (managed ORC tables).
--   * INSERT OVERWRITE syntax is unchanged.
--   * For CTAS with specific storage format, use STORED AS explicitly.
--   * INSERT OVERWRITE on ACID tables performs atomic replacement.
--   * Hive 4.0: extract(YEAR FROM ...) preferred over year() function.
-- =============================================================================

-- CTAS: Creates a managed ACID table by default in Hive 4.0
CREATE TABLE yearly_sales
STORED AS ORC
AS
SELECT extract(YEAR FROM sale_date) AS sales_year, SUM(amount) AS total_sales
FROM sales
GROUP BY extract(YEAR FROM sale_date);

-- INSERT OVERWRITE: atomic replacement of table contents
INSERT OVERWRITE TABLE yearly_sales
SELECT extract(YEAR FROM sale_date), SUM(amount)
FROM sales
GROUP BY extract(YEAR FROM sale_date);
