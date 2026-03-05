-- Modernized for Apache Hive 4.2.0
-- Source version inferred: Hive 2.x (basic JSON parsing pattern without explicit storage format)
-- Applied changes: Added STORED AS ORC for explicit format; added IF NOT EXISTS guard
-- Iceberg recommendation: No (simple JSON parsing example)

-- =============================================================================
-- 07: JSON Parsing
-- =============================================================================
-- In Hive 4.2.0:
--   - get_json_object() remains fully supported
--   - Managed tables without explicit STORED AS default to ORC (ACID by default)
--   - For heavy JSON workloads, consider Iceberg tables with the Variant type (4.2.0)
-- =============================================================================

CREATE TABLE IF NOT EXISTS json_events (
    event STRING
)
STORED AS ORC;

SELECT get_json_object(event, '$.user.id') AS user_id,
       get_json_object(event, '$.event_type') AS event_type
FROM json_events;

-- =============================================================================
-- Verification Steps
-- =============================================================================
-- DESCRIBE FORMATTED json_events;
--   -> Confirm: STORED AS ORC, transactional=true (auto)
-- EXPLAIN
--   SELECT get_json_object(event, '$.user.id') AS user_id,
--          get_json_object(event, '$.event_type') AS event_type
--   FROM json_events;
--   -> Confirm: Tez execution plan
-- =============================================================================
