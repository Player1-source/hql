SELECT product_id, sale_date, SUM(amount)
FROM sales
GROUP BY product_id, sale_date
WITH ROLLUP;

SELECT product_id, sale_date, SUM(amount)
FROM sales
GROUP BY product_id, sale_date
WITH CUBE;