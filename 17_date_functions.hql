-- Modernized for Apache Hive 4.2.0
-- Source version inferred: Hive 2.x (cross-version compatible date function syntax)
-- Applied changes: Added modernization header; noted strict java.time behavior
-- Iceberg recommendation: No (read-only date computation query)

-- =============================================================================
-- 17: Date Functions
-- =============================================================================
-- IMPORTANT (Hive 4.2.0 — strict java.time):
--   - All date/timestamp parsing uses java.time (JSR-310) instead of SimpleDateFormat
--   - Invalid dates (e.g., month=13, day=32) return NULL instead of silently rolling over
--   - current_date returns DATE type; current_timestamp returns TIMESTAMP type
--   - date_add, add_months, trunc remain fully supported
-- =============================================================================

SELECT current_date AS today,
       date_add(current_date, 7) AS next_week,
       add_months(current_date, 1) AS next_month,
       trunc(current_date, 'MM') AS month_start;

-- =============================================================================
-- Verification Steps
-- =============================================================================
-- Run the SELECT above and verify:
--   -> today: returns current date
--   -> next_week: returns date + 7 days
--   -> next_month: returns date + 1 month
--   -> month_start: returns first day of current month
-- =============================================================================
