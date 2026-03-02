CREATE TABLE json_events (event STRING);
SELECT get_json_object(event, '$.user.id') AS user_id,
get_json_object(event, '$.event_type') AS event_type
FROM json_events;