-- Modernized for Apache Hive 4.2.0
-- Source version inferred: Hive 2.x (backtick-escaped reserved keywords already applied)
-- Applied changes: Added modernization header; noted stricter ANSI SQL enforcement in 4.2.0
-- Iceberg recommendation: No (DDL and query demonstration)

-- =============================================================================
-- 22: Reserved Keywords and ANSI Behavior
-- =============================================================================
-- IMPORTANT (Hive 4.2.0 — ANSI SQL Enforcement):
--   - Reserved keyword list is expanded; always backtick-escape identifiers
--     that conflict with SQL keywords (user, order, group, time, date, etc.)
--   - ANSI SQL GROUP BY is enforced: all non-aggregated SELECT columns must
--     appear in the GROUP BY clause
--   - Implicit type conversions are stricter
--   - Column aliases with AS keyword are preferred for clarity
-- =============================================================================

CREATE TABLE IF NOT EXISTS keyword_test (
    `user` STRING,
    `order` STRING,
    `group` STRING
)
STORED AS ORC;

-- ANSI-compliant GROUP BY: all non-aggregated columns must be in GROUP BY
SELECT customer_id, SUM(amount) AS total_amount
FROM sales
GROUP BY customer_id;

-- =============================================================================
-- Verification Steps
-- =============================================================================
-- DESCRIBE FORMATTED keyword_test;
--   -> Confirm: columns user, order, group created successfully with backticks
-- SELECT `user`, `order`, `group` FROM keyword_test LIMIT 1;
--   -> Confirm: backtick-escaped column access works
-- EXPLAIN
--   SELECT customer_id, SUM(amount) AS total_amount FROM sales GROUP BY customer_id;
--   -> Confirm: ANSI-compliant GROUP BY accepted without errors
-- =============================================================================
