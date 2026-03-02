SET hive.auto.convert.join=true;
SELECT /*+ MAPJOIN(p) */ s.sale_id, p.product_name
FROM sales s
JOIN ext_products p
ON s.product_id = p.product_id;