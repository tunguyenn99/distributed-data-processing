/*
🔁 Wide Transformations trong OLAP – Khi dữ liệu cần phải di chuyển

Wide transformations là những phép biến đổi yêu cầu di chuyển dữ liệu giữa các node trong cluster. 
Chúng thường xuất hiện khi cần xử lý dữ liệu từ nhiều dòng hoặc từ nhiều bảng khác nhau, 
như JOIN hoặc GROUP BY.

✅ Đặc điểm của Wide Transformations:
- Dữ liệu phải được "shuffle" (trao đổi) giữa các node để gom các dòng liên quan về cùng một nơi xử lý.
- Phổ biến trong các phép toán như JOIN (nối bảng) và GROUP BY (nhóm và tổng hợp).
- Cơ sở dữ liệu OLAP sẽ sử dụng hàm băm (hash function) trên các cột join/group để xác định 
  dòng dữ liệu nên gửi đến node nào.
- Quá trình di chuyển dữ liệu giữa các node có thể tốn thời gian và tài nguyên → cần hạn chế nếu có thể.

💡 Ví dụ:
GROUP BY orderkey → các dòng có cùng orderkey cần được gửi về cùng một node để tính toán tổng hợp.
*/

-- Wide Transformation Example: GROUP BY gây data shuffle
SELECT
  orderpriority,
  ROUND(SUM(totalprice) / 1000, 2) AS total_price_thousands
FROM
  orders
GROUP BY
  orderpriority
ORDER BY
  orderpriority;