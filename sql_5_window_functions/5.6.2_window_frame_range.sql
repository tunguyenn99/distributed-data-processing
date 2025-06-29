-- 5.6.2 Window Frame with RANGE – trung bình các dòng có total_quantity gần nhau

USE tpch.tiny;

SELECT
  supplier_name,
  order_year,
  total_quantity,
  total_price,
  ROUND(
    AVG(total_price) OVER (
      PARTITION BY supplier_name
      ORDER BY total_price
      RANGE BETWEEN 20 PRECEDING AND 20 FOLLOWING
    ),
    2
  ) AS avg_total_price_wi_20_quantity
FROM (
  SELECT
    n.name AS supplier_name,
    YEAR(o.orderdate) AS order_year,
    SUM(l.quantity) AS total_quantity,
    ROUND(SUM(o.totalprice) / 100000, 2) AS total_price
  FROM lineitem l
  JOIN orders o ON l.orderkey = o.orderkey
  JOIN supplier s ON l.suppkey = s.suppkey
  JOIN nation n ON s.nationkey = n.nationkey
  GROUP BY n.name, YEAR(o.orderdate)
);