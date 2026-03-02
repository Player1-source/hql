CREATE TABLE yearly_sales AS
SELECT year(sale_date) AS sales_year, SUM(amount) AS total_sales
FROM sales
GROUP BY year(sale_date);

INSERT OVERWRITE TABLE yearly_sales
SELECT year(sale_date), SUM(amount)
FROM sales
GROUP BY year(sale_date);