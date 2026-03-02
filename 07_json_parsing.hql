-- =============================================================================
-- 07. JSON Parsing
-- Hive 4.0 Migration Notes:
--   * get_json_object() remains fully supported.
--   * json_tuple() is preferred for extracting multiple fields at once
--     (more efficient than multiple get_json_object calls).
--   * Hive 4.0 also supports JsonSerDe for schema-on-read JSON tables.
--   * Consider using the OpenCSVSerde or JsonSerDe for structured JSON ingestion.
-- =============================================================================

CREATE TABLE IF NOT EXISTS json_events (event STRING);

-- Method 1: get_json_object (one field at a time)
SELECT
    get_json_object(event, '$.user.id') AS user_id,
    get_json_object(event, '$.event_type') AS event_type
FROM json_events;

-- Method 2: json_tuple (preferred for multiple fields - single pass)
SELECT jt.user_id, jt.event_type
FROM json_events
LATERAL VIEW json_tuple(event, 'user.id', 'event_type') jt
    AS user_id, event_type;
