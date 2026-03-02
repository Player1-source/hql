-- =============================================================================
-- 09. Lateral View and Explode
-- Hive 4.0 Migration Notes:
--   * LATERAL VIEW explode() syntax is unchanged.
--   * LATERAL VIEW OUTER preserves rows where the array is NULL or empty
--     (produces NULL for the exploded column). Recommended for data completeness.
--   * posexplode() is available to get both index and value.
-- =============================================================================

-- Standard explode (drops rows with NULL/empty arrays)
SELECT id, tag
FROM nested_data
LATERAL VIEW explode(tags) t AS tag;

-- OUTER keyword preserves rows with NULL or empty arrays (recommended)
SELECT id, tag
FROM nested_data
LATERAL VIEW OUTER explode(tags) t AS tag;

-- posexplode: returns position index alongside each element
SELECT id, pos, tag
FROM nested_data
LATERAL VIEW posexplode(tags) t AS pos, tag;
