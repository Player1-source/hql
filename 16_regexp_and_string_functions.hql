SELECT email,
regexp_extract(email, '^[^@]+', 0) AS username,
upper(first_name),
substr(last_name,1,3)
FROM customers;