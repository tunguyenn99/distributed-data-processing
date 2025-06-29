-- 6.2.2 Pivot theo orderpriority

SELECT
  DATE_FORMAT(orderdate, '%Y-%m') AS ordermonth,
  ROUND(AVG(CASE WHEN orderpriority = '1-URGENT' THEN totalprice END), 2) AS urgent_order_avg_price,
  ROUND(AVG(CASE WHEN orderpriority = '2-HIGH' THEN totalprice END), 2) AS high_order_avg_price,
  ROUND(AVG(CASE WHEN orderpriority = '3-MEDIUM' THEN totalprice END), 2) AS medium_order_avg_price,
  ROUND(AVG(CASE WHEN orderpriority = '4-NOT SPECIFIED' THEN totalprice END), 2) AS not_specified_order_avg_price,
  ROUND(AVG(CASE WHEN orderpriority = '5-LOW' THEN totalprice END), 2) AS low_order_avg_price
FROM orders
GROUP BY DATE_FORMAT(orderdate, '%Y-%m');