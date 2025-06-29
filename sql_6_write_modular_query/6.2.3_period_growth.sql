-- 6.2.3 MoM growth theo customer_nation

WITH monthly_orders AS (
  SELECT
    DATE(DATE_FORMAT(o.orderdate, '%Y-%m-01')) AS ordermonth,
    n.name AS customer_nation,
    ROUND(SUM(o.totalprice) / 100000, 2) AS totalprice
  FROM orders o
  JOIN customer c ON o.custkey = c.custkey
  JOIN nation n ON c.nationkey = n.nationkey
  GROUP BY 1, 2
)
SELECT
  ordermonth,
  customer_nation,
  totalprice,
  ROUND(
    (totalprice - LAG(totalprice) OVER (PARTITION BY customer_nation ORDER BY ordermonth))
    * 100 / LAG(totalprice) OVER (PARTITION BY customer_nation ORDER BY ordermonth),
    2
  ) AS MoM_totalprice_change
FROM monthly_orders
ORDER BY customer_nation, ordermonth;