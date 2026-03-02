SELECT customer_id FROM sales_2023
UNION ALL
SELECT customer_id FROM sales_2024;

SELECT customer_id FROM sales_2023
UNION
SELECT customer_id FROM sales_2024;