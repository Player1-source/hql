-- =============================================================================
-- 16. Regexp and String Functions
-- Hive 4.0 Migration Notes:
--   * regexp_extract(), upper(), substr() are unchanged in Hive 4.0.
--   * Hive 4.0 uses Java's java.util.regex engine (same as before).
--   * Additional string functions: initcap(), lpad(), rpad(), translate(),
--     replace(), char_length(), format_number().
--   * regexp_replace() fully supported for pattern-based replacements.
-- =============================================================================

SELECT
    email,
    regexp_extract(email, '^[^@]+', 0) AS username,
    upper(first_name) AS upper_first,
    substr(last_name, 1, 3) AS last_abbrev,
    -- Additional string functions available in Hive 4.0
    initcap(first_name) AS proper_first,
    char_length(email) AS email_length,
    replace(email, '@', ' [at] ') AS masked_email
FROM customers;
