-- 5.5 Window Value Functions – Logic flags based on comparisons

USE tpch.tiny;

SELECT
  customer_name,
  order_date,
  total_price,
  CASE
    WHEN total_price > LAG(total_price) OVER (PARTITION BY customer_name ORDER BY order_date)
    THEN TRUE ELSE FALSE END AS has_total_price_increased,
  CASE
    WHEN total_price < LEAD(total_price) OVER (PARTITION BY customer_name ORDER BY order_date)
    THEN TRUE ELSE FALSE END AS will_total_price_increase
FROM (
  SELECT
    c.name AS customer_name,
    o.orderdate AS order_date,
    SUM(o.totalprice) AS total_price
  FROM orders o
  JOIN customer c ON o.custkey = c.custkey
  GROUP BY 1, 2
)
ORDER BY customer_name, order_date
LIMIT 50;