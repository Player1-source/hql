-- Modernized for Apache Hive 4.2.0
-- Source version inferred: Hive 2.x (relies on lenient SimpleDateFormat parsing for invalid dates)
-- Applied changes: Added warnings about strict java.time behavior; documented NULL results for invalid dates
-- Iceberg recommendation: No (datetime behavior demonstration)

-- =============================================================================
-- 21: Datetime Formatter Behavior Change
-- =============================================================================
-- BREAKING CHANGE (Hive 4.2.0 — strict java.time / JSR-310):
--   - Hive 4.2.0 uses java.time instead of SimpleDateFormat
--   - Invalid dates (month=13, day=30 for Feb) return NULL instead of rolling over
--   - Old behavior (Hive 2.x): '2023-13-01' silently rolled to '2024-01-01'
--   - New behavior (Hive 4.2.0): '2023-13-01' returns NULL
--   - Pattern letters follow java.time.format.DateTimeFormatter conventions
-- =============================================================================

-- WARNING: Returns NULL in Hive 4.2.0 (month 13 is invalid)
-- In Hive 2.x, this would silently roll over to 2024-01-01
SELECT unix_timestamp('2023-13-01', 'yyyy-MM-dd') AS invalid_month_result;
-- Expected result: NULL

-- WARNING: Returns NULL in Hive 4.2.0 (February 30 is invalid)
-- In Hive 2.x, this would silently roll over to 2023-03-02
SELECT cast('2023-02-30' AS DATE) AS invalid_day_result;
-- Expected result: NULL

-- This is VALID and works correctly in both Hive 2.x and 4.2.0
SELECT from_unixtime(unix_timestamp('01-12-2023 15:30', 'dd-MM-yyyy HH:mm')) AS valid_datetime_result;
-- Expected result: '2023-12-01 15:30:00'

-- =============================================================================
-- Verification Steps
-- =============================================================================
-- Run each SELECT above individually:
--   -> Query 1: Confirm NULL (invalid month 13)
--   -> Query 2: Confirm NULL (invalid day Feb 30)
--   -> Query 3: Confirm valid timestamp '2023-12-01 15:30:00'
-- =============================================================================
