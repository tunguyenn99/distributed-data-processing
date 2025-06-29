-- 5.3 Window Ranking Functions
-- Sử dụng RANK, DENSE_RANK, ROW_NUMBER để xếp hạng trong partition

USE tpch.tiny;

SELECT
  orderkey,
  discount,
  RANK() OVER (PARTITION BY orderkey ORDER BY discount DESC) AS rnk,
  DENSE_RANK() OVER (PARTITION BY orderkey ORDER BY discount DESC) AS dense_rnk,
  ROW_NUMBER() OVER (PARTITION BY orderkey ORDER BY discount DESC) AS row_num
FROM lineitem
WHERE orderkey = 42624
LIMIT 10;