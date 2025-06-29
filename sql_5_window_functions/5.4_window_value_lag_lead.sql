-- 5.4 Window Value Functions – LAG and LEAD
-- So sánh dữ liệu giữa các dòng (thời gian, đơn hàng trước sau)

USE tpch.tiny;

SELECT
  ordermonth,
  total_price,
  LAG(total_price) OVER (ORDER BY ordermonth) AS prev_month_total_price,
  LAG(total_price, 2) OVER (ORDER BY ordermonth) AS prev_prev_month_total_price
FROM (
  SELECT
    date_format(orderdate, '%Y-%m') AS ordermonth,
    ROUND(SUM(totalprice) / 100000, 2) AS total_price
  FROM orders
  GROUP BY 1
)
LIMIT 24;