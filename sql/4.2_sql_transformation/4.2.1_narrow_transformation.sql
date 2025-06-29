/*
🔄 Narrow Transformations trong OLAP – Xử lý phân tán hiệu quả

Trong hệ thống cơ sở dữ liệu OLAP phân tán, narrow transformations là những phép biến đổi 
không yêu cầu truyền dữ liệu giữa các node trong cluster. Đây là một trong những kỹ thuật then chốt 
giúp tối ưu hóa hiệu suất truy vấn trong môi trường phân tán.

✅ Đặc điểm của Narrow Transformations:
- Dữ liệu được xử lý tại chính node chứa dữ liệu đó, hoàn toàn không cần gửi sang node khác.
- Mỗi dòng dữ liệu được xử lý độc lập — không phụ thuộc vào các dòng khác.
- Thích hợp với các phép toán theo từng hàng (row-level operations) như tính toán, chuẩn hóa, làm sạch dữ liệu.
*/

USE tpch.tiny;

SELECT
  orderkey,
  linenumber,
  ROUND(
    extendedprice * (1 - discount) * (1 + tax),
    2
  ) AS totalprice
FROM
  lineitem
LIMIT 10;
