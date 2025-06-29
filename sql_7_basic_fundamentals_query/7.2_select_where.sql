-- Select with various filters
USE tpch.tiny;
SELECT * FROM customer WHERE nationkey = 20 LIMIT 10;
SELECT * FROM customer WHERE nationkey = 20 AND acctbal > 1000 LIMIT 10;
SELECT * FROM customer WHERE name LIKE '%381%';