/*
🔗 Hash Join – Định nghĩa & Đặc điểm nhận dạng

Hash Join là một kiểu JOIN trong hệ thống OLAP phân tán, trong đó **dữ liệu từ cả hai bảng**
sẽ được **shuffle (trao đổi) giữa các node** dựa trên giá trị khóa JOIN (join key).

✅ Khi nào xảy ra Hash Join?
- Khi **cả hai bảng đều lớn** (thường là fact-fact hoặc fact-dimension lớn).
- Khi hệ thống **không thể broadcast bảng nhỏ hơn** đến các node chứa bảng lớn hơn.

🛠 Cơ chế:
- OLAP DB áp dụng hàm băm (hash function) lên cột JOIN (`partkey`) để quyết định
  dữ liệu dòng nào sẽ được gửi đến node nào.
- Sau khi shuffle xong, JOIN được thực hiện trên từng node.

📌 Truy vấn dưới đây dùng `tpch.sf10`, nơi cả bảng `lineitem` và `part` đều đủ lớn để
kích hoạt Hash Join thay vì Broadcast Join.

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
