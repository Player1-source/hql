SELECT customer_id, amount FROM sales
UNION ALL
SELECT customer_id, cast(amount AS STRING) FROM sales_archive;

SELECT customer_id FROM sales_2023
INTERSECT
SELECT customer_id FROM sales_2024;

SELECT customer_id FROM sales_2023
EXCEPT
SELECT customer_id FROM sales_2024;