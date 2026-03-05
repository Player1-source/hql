-- Modernized for Apache Hive 4.2.0
-- Source version inferred: Hive 2.x (cross-version compatible complex type syntax)
-- Applied changes: Added modernization header and IF NOT EXISTS guard; syntax fully compatible with 4.2.0
-- Iceberg recommendation: No (simple schema demonstration)

-- =============================================================================
-- 08: Complex Data Types (MAP, ARRAY, STRUCT)
-- =============================================================================
-- In Hive 4.2.0:
--   - MAP, ARRAY, STRUCT types are fully supported
--   - Schema evolution for complex types is improved
--   - ORC storage handles nested types efficiently with vectorized reads
-- =============================================================================

CREATE TABLE IF NOT EXISTS nested_data (
    id INT,
    attributes MAP<STRING, STRING>,
    tags ARRAY<STRING>,
    address STRUCT<street:STRING, city:STRING>
)
STORED AS ORC;

SELECT id,
       attributes['country'] AS country,
       tags[0] AS first_tag,
       address.city AS city
FROM nested_data;

-- =============================================================================
-- Verification Steps
-- =============================================================================
-- DESCRIBE FORMATTED nested_data;
--   -> Confirm: columns with MAP, ARRAY, STRUCT types; STORED AS ORC
-- EXPLAIN
--   SELECT id, attributes['country'], tags[0], address.city FROM nested_data;
--   -> Confirm: Tez plan with vectorized map/array/struct access
-- =============================================================================
