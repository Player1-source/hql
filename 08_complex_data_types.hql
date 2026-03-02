-- =============================================================================
-- 08. Complex Data Types (MAP, ARRAY, STRUCT)
-- Hive 4.0 Migration Notes:
--   * Complex data types syntax is unchanged in Hive 4.0.
--   * Managed tables with complex types are ACID by default.
--   * Hive 4.0 adds the typeof() UDF to inspect runtime types.
--   * Improved vectorized execution for complex type access.
-- =============================================================================

CREATE TABLE IF NOT EXISTS nested_data (
    id INT,
    attributes MAP<STRING, STRING>,
    tags ARRAY<STRING>,
    address STRUCT<street:STRING, city:STRING>
) STORED AS ORC;

SELECT
    id,
    attributes['country'],
    tags[0],
    address.city,
    -- NEW in Hive 4.0: typeof() UDF to inspect column types at runtime
    typeof(attributes) AS attr_type
FROM nested_data;
