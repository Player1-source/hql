SELECT customer_id, sale_date,
SUM(amount) OVER (PARTITION BY customer_id ORDER BY sale_date
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total,
RANK() OVER (PARTITION BY sale_date ORDER BY amount DESC) AS daily_rank
FROM sales;