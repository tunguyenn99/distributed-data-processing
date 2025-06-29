-- 5.1 Window Definition
-- Mỗi cửa sổ (window) được xác định bởi các dòng có cùng giá trị ở một hoặc nhiều cột

USE tpch.tiny;

SELECT
  orderkey,
  linenumber,
  extendedprice,
  ROUND(
    SUM(extendedprice) OVER (
      PARTITION BY orderkey
      ORDER BY linenumber
    ), 2
  ) AS total_extendedprice
FROM lineitem
ORDER BY orderkey, linenumber
LIMIT 20;

-- Bỏ ORDER BY sẽ khiến SUM tính tổng toàn bộ dòng trong partition