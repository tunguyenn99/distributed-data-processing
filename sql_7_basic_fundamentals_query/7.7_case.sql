-- CASE statement
USE tpch.tiny;
SELECT orderkey, totalprice,
CASE WHEN totalprice > 100000 THEN 'high'
WHEN totalprice BETWEEN 25000 AND 100000 THEN 'medium'
ELSE 'low' END AS order_price_bucket
FROM orders;