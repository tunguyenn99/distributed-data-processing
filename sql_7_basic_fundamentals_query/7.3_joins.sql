-- Join examples
USE tpch.tiny;
SELECT o.orderkey, l.orderkey FROM orders o JOIN lineitem l ON o.orderkey = l.orderkey LIMIT 10;