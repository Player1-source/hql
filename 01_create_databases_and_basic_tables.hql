CREATE DATABASE IF NOT EXISTS retail_db COMMENT 'Retail analytics database';
USE retail_db;

CREATE TABLE customers (
    customer_id INT,
    first_name STRING,
    last_name STRING,
    email STRING,
    created_date DATE
) STORED AS ORC;

CREATE EXTERNAL TABLE ext_products (
    product_id INT,
    product_name STRING,
    category STRING,
    price DECIMAL(10,2)
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
LOCATION '/data/products/';