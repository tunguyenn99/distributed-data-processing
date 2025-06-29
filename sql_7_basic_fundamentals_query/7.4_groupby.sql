-- Group by example
USE tpch.tiny;
SELECT orderpriority, COUNT(*) AS num_orders FROM orders GROUP BY orderpriority;