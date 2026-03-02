CREATE TABLE nested_data (
    id INT,
    attributes MAP<STRING, STRING>,
    tags ARRAY<STRING>,
    address STRUCT<street:STRING, city:STRING>
) STORED AS ORC;

SELECT id, attributes['country'], tags[0], address.city FROM nested_data;