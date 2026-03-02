CREATE MATERIALIZED VIEW mv_daily_sales
BUILD IMMEDIATE
REFRESH COMPLETE
AS
SELECT sale_date, SUM(amount) total_sales
FROM sales
GROUP BY sale_date;