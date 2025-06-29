/*
📡 Broadcast Join – Định nghĩa & Đặc điểm nhận dạng

Broadcast Join là một kỹ thuật tối ưu JOIN trong hệ thống OLAP phân tán, khi:
- Một bảng là **bảng nhỏ (dimension)**.
- Một bảng là **bảng lớn (fact)**.

✅ Cách hoạt động:
- OLAP DB **gửi toàn bộ bảng nhỏ (ở đây là `part`) đến tất cả các node**
  chứa dữ liệu của bảng lớn (`lineitem`).
- Bảng dimension được **giữ trong bộ nhớ (RAM)** của từng node.
- JOIN được thực hiện **cục bộ**, tránh việc shuffle dữ liệu lớn qua mạng.

💡 Ưu điểm:
- Tránh truyền bảng fact qua mạng → **hiệu suất cao hơn nhiều so với Hash Join**.
- Tự động được chọn nếu bảng nhỏ < `join_max_broadcast_table_size`.

📌 Truy vấn dưới đây sử dụng Broadcast Join vì `part` nhỏ hơn `lineitem`.

💡 Bạn có thể xác thực loại JOIN được dùng bằng cách chạy lệnh EXPLAIN trước truy vấn.
Trong Trino, nếu thấy distribution = PARTITIONED, đó là Hash Join; nếu là REPLICATED, thì là Broadcast Join.

EXPLAIN SELECT ......

*/

USE tpch.sf10;
SELECT
  p.name AS part_name,
  p.partkey,
  l.linenumber,
  ROUND(l.extendedprice * (1 - l.discount), 2) AS total_price_wo_tax
FROM
  lineitem l
JOIN
  part p ON l.partkey = p.partkey;
