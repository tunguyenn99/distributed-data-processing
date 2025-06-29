-- 6.2.1 Loại bỏ dòng trùng theo orderkey

WITH duplicated_orders AS (
  SELECT * FROM orders
  UNION
  SELECT * FROM orders
),
ranked_orders AS (
  SELECT *, ROW_NUMBER() OVER (PARTITION BY orderkey) AS rn
  FROM duplicated_orders
)
SELECT * FROM ranked_orders
WHERE rn = 1;