SET hive.execution.engine=tez;
SET hive.vectorized.execution.enabled=true;
SET hive.cbo.enable=true;

EXPLAIN ANALYZE
SELECT customer_id, SUM(amount)
FROM sales
GROUP BY customer_id;