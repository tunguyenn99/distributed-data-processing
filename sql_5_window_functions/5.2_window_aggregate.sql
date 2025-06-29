-- 5.2 Window Aggregate Functions
-- Tính các phép tổng hợp nhưng vẫn giữ nguyên từng dòng

USE tpch.tiny;

SELECT
  c.name AS customer_name,
  o.orderdate,
  SUM(o.totalprice) AS total_price,
  ROUND(
    SUM(SUM(o.totalprice)) OVER (
      PARTITION BY o.custkey
      ORDER BY o.orderdate
    ), 2
  ) AS cumulative_sum_total_price
FROM orders o
JOIN customer c ON o.custkey = c.custkey
GROUP BY c.name, o.custkey, o.orderdate
ORDER BY o.custkey, o.orderdate
LIMIT 20;