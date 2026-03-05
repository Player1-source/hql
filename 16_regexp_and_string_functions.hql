-- Modernized for Apache Hive 4.2.0
-- Source version inferred: Hive 2.x (cross-version compatible string function syntax)
-- Applied changes: Added modernization header; syntax fully compatible with 4.2.0
-- Iceberg recommendation: No (read-only string processing query)

-- =============================================================================
-- 16: Regexp and String Functions
-- =============================================================================
-- In Hive 4.2.0:
--   - regexp_extract, upper, substr remain fully supported
--   - Enhanced regexp functions available: regexp_replace with backreferences
--   - All string functions are vectorized for ORC tables
-- =============================================================================

SELECT email,
       regexp_extract(email, '^[^@]+', 0) AS username,
       upper(first_name) AS upper_first_name,
       substr(last_name, 1, 3) AS last_name_prefix
FROM customers;

-- =============================================================================
-- Verification Steps
-- =============================================================================
-- EXPLAIN
--   SELECT email, regexp_extract(email, '^[^@]+', 0) AS username,
--          upper(first_name), substr(last_name, 1, 3) FROM customers;
--   -> Confirm: Tez plan with vectorized string UDF evaluation
-- =============================================================================
