CREATE TEMPORARY TABLE temp_sales AS
SELECT * FROM sales WHERE amount > 500;

CREATE VIEW vw_high_sales AS
SELECT * FROM sales WHERE amount > 1000;