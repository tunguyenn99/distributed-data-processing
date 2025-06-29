-- 6.2.4 GROUP BY nhiều tổ hợp trong 1 truy vấn

WITH monthly_cust_nation_orders AS (
  SELECT
    DATE_FORMAT(o.orderdate, '%Y-%m') AS ordermonth,
    n.name AS customer_nation,
    totalprice
  FROM orders o
  JOIN customer c ON o.custkey = c.custkey
  JOIN nation n ON c.nationkey = n.nationkey
)
SELECT
  ordermonth,
  customer_nation,
  ROUND(SUM(totalprice) / 100000, 2) AS totalprice
FROM monthly_cust_nation_orders
GROUP BY GROUPING SETS (
  (ordermonth),
  (customer_nation),
  (ordermonth, customer_nation)
);