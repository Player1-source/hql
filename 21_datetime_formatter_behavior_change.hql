-- =============================================================================
-- 21. Datetime Formatter Behavior Change
-- Hive 4.0 Migration Notes:
--   * BREAKING CHANGE: Hive 4.0 uses java.time.format.DateTimeFormatter instead
--     of java.text.SimpleDateFormat. This means STRICTER date validation.
--   * Invalid dates like '2023-13-01' (month 13) now return NULL instead of
--     rolling over to the next year.
--   * Invalid dates like '2023-02-30' now return NULL instead of adjusting.
--   * The property hive.datetime.formatter=DATETIME is the new default.
--   * To revert to legacy lenient behavior (not recommended):
--     SET hive.datetime.formatter=SIMPLE;
-- =============================================================================

-- Hive 4.0 default: strict datetime parsing
-- SET hive.datetime.formatter=DATETIME;  -- This is now the default

-- EXAMPLE 1: Invalid month (13) - Returns NULL in Hive 4.0 (was lenient in 2/3)
SELECT unix_timestamp('2023-13-01', 'yyyy-MM-dd') AS invalid_month_result;
-- Hive 2/3: would roll over to 2024-01-01
-- Hive 4.0: returns NULL

-- EXAMPLE 2: Invalid day (Feb 30) - Returns NULL in Hive 4.0
SELECT cast('2023-02-30' AS DATE) AS invalid_day_result;
-- Hive 2/3: would adjust to 2023-03-02
-- Hive 4.0: returns NULL

-- EXAMPLE 3: Valid date parsing still works the same
SELECT from_unixtime(unix_timestamp('01-12-2023 15:30', 'dd-MM-yyyy HH:mm')) AS parsed_datetime;
-- Both versions: '2023-12-01 15:30:00'

-- EXAMPLE 4: Use valid dates for reliable behavior across versions
SELECT unix_timestamp('2023-12-01', 'yyyy-MM-dd') AS valid_date_result;
SELECT cast('2023-02-28' AS DATE) AS valid_feb_date;
