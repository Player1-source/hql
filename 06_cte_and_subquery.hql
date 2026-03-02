WITH high_value_customers AS (
    SELECT customer_id, SUM(amount) total_spent
    FROM sales
    GROUP BY customer_id
    HAVING SUM(amount) > 10000
)
SELECT * FROM customers c
JOIN high_value_customers h
ON c.customer_id = h.customer_id;