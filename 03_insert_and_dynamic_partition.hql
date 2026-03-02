INSERT INTO TABLE sales PARTITION (sale_date)
SELECT sale_id, customer_id, product_id, quantity, amount, sale_date
FROM staging_sales;