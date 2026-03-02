-- =============================================================================
-- 23. NULL Ordering Behavior
-- Hive 4.0 Migration Notes:
--   * BREAKING CHANGE: Default NULL ordering now follows SQL standard.
--     - ASC  -> NULLS LAST  (Hive 2/3 had NULLS FIRST for ASC)
--     - DESC -> NULLS FIRST (unchanged)
--   * Queries relying on the old default (NULLS FIRST for ASC) will produce
--     different results in Hive 4.0. Add explicit NULLS FIRST/LAST to be safe.
--   * Best practice: ALWAYS specify NULLS FIRST or NULLS LAST explicitly
--     to ensure consistent behavior across Hive versions.
-- =============================================================================

-- Default ORDER BY ASC: NULLS LAST in Hive 4.0 (was NULLS FIRST in Hive 2/3)
SELECT customer_id, amount FROM sales ORDER BY amount;

-- Explicit NULLS FIRST: NULLs appear at the top (override default for ASC)
SELECT customer_id, amount FROM sales ORDER BY amount ASC NULLS FIRST;

-- Explicit NULLS LAST: NULLs appear at the bottom (this is now the ASC default)
SELECT customer_id, amount FROM sales ORDER BY amount ASC NULLS LAST;

-- DESC with NULLS LAST: push NULLs to the bottom in descending order
SELECT customer_id, amount FROM sales ORDER BY amount DESC NULLS LAST;
