USE retail_db;
CREATE TABLE sales (
    sale_id BIGINT,
    customer_id INT,
    product_id INT,
    quantity INT,
    amount DECIMAL(12,2)
)
PARTITIONED BY (sale_date DATE)
CLUSTERED BY (customer_id) INTO 8 BUCKETS
STORED AS ORC;

SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;