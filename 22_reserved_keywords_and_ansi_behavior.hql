-- =============================================================================
-- 22. Reserved Keywords and ANSI SQL Behavior
-- Hive 4.0 Migration Notes:
--   * Hive 4.0 enforces ANSI SQL reserved keywords more strictly.
--   * More words are reserved: user, order, group, date, time, timestamp,
--     position, result, role, default, etc.
--   * Always use backticks (`) to escape reserved words used as identifiers.
--   * SET hive.support.sql11.reserved.keywords=true is now the DEFAULT.
--   * Best practice: avoid using reserved words as column/table names entirely.
-- =============================================================================

-- Reserved keywords must be backtick-escaped when used as identifiers
CREATE TABLE IF NOT EXISTS keyword_test (
    `user` STRING,
    `order` STRING,
    `group` STRING,
    `date` STRING,
    `position` STRING
) STORED AS ORC;

-- Querying with backtick-escaped columns
SELECT `user`, `order`, `group` FROM keyword_test;

-- Non-reserved identifiers work without backticks
SELECT customer_id, SUM(amount) AS total_amount
FROM sales
GROUP BY customer_id;
