-- 5.6.3 Window Frame with GROUPS – max của 3 tháng tiếp theo trong nhóm

USE tpch.tiny;

SELECT
  customer_nation,
  supplier_nation,
  order_month,
  avg_days_to_deliver,
  MIN(avg_days_to_deliver) OVER (
    PARTITION BY customer_nation
    ORDER BY order_month
    GROUPS BETWEEN 3 PRECEDING AND 1 PRECEDING
  ) AS shortest_avg_days_to_deliver_3mo
FROM (
  SELECT
    cn.name AS customer_nation,
    sn.name AS supplier_nation,
    CAST(DATE_FORMAT(o.orderdate, '%Y-%m-01') AS DATE) AS order_month,
    ROUND(AVG(DATE_DIFF('day', l.shipdate, l.receiptdate)), 2) AS avg_days_to_deliver
  FROM lineitem l
  JOIN orders o ON l.orderkey = o.orderkey
  JOIN customer c ON o.custkey = c.custkey
  JOIN supplier s ON l.suppkey = s.suppkey
  JOIN nation cn ON c.nationkey = cn.nationkey
  JOIN nation sn ON s.nationkey = sn.nationkey
  GROUP BY 1, 2, 3
);