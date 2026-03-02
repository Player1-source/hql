CREATE TABLE keyword_test (
    `user` STRING,
    `order` STRING,
    `group` STRING
) STORED AS ORC;

SELECT customer_id, SUM(amount)
FROM sales
GROUP BY customer_id;