CREATE TABLE transactions_acid (
    txn_id BIGINT,
    account_id INT,
    txn_amount DECIMAL(12,2),
    txn_type STRING
)
CLUSTERED BY (account_id) INTO 4 BUCKETS
STORED AS ORC
TBLPROPERTIES ('transactional'='true');

INSERT INTO transactions_acid VALUES (1, 1001, 200.50, 'DEBIT');
UPDATE transactions_acid SET txn_amount = txn_amount + 10 WHERE txn_id = 1;
DELETE FROM transactions_acid WHERE txn_id = 1;