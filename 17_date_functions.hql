-- =============================================================================
-- 17. Date Functions
-- Hive 4.0 Migration Notes:
--   * current_date() function form is preferred over bare current_date.
--   * date_add(), add_months(), trunc() are unchanged.
--   * Hive 4.0 uses java.time-based date parsing (stricter validation).
--   * New/enhanced functions: date_sub(), months_between(), last_day(),
--     next_day(), extract(YEAR/MONTH/DAY FROM ...).
--   * TIMESTAMP type supports nanosecond precision in Hive 4.0.
-- =============================================================================

SELECT
    current_date() AS today,
    date_add(current_date(), 7) AS next_week,
    date_sub(current_date(), 7) AS last_week,
    add_months(current_date(), 1) AS next_month,
    trunc(current_date(), 'MM') AS month_start,
    last_day(current_date()) AS month_end,
    -- Hive 4.0: extract() function for date parts (ANSI SQL standard)
    extract(YEAR FROM current_date()) AS curr_year,
    extract(MONTH FROM current_date()) AS curr_month,
    extract(DAY FROM current_date()) AS curr_day;
