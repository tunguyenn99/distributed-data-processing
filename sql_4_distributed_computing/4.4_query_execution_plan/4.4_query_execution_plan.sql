/*
🔍 EXPLAIN – Phân tích kế hoạch thực thi truy vấn trong Trino

Câu lệnh EXPLAIN cho phép bạn xem **kế hoạch mà Trino sẽ sử dụng để chạy truy vấn**, 
giúp hiểu rõ các bước xử lý và tối ưu hóa hiệu suất truy vấn.

✅ Những phần chính trong kế hoạch EXPLAIN của Trino:

1. **Fragment (Stage)** – Mỗi fragment đại diện cho một giai đoạn (stage) được thực thi song song.  
   ➤ Việc **trao đổi dữ liệu (Exchange)** giữa các fragment thể hiện có **data shuffle**.

2. **Task** – Là một đơn vị xử lý trong từng node, bao gồm các bước như:
   - **Scan**: Đọc dữ liệu từ bảng.
   - **Filter**: Lọc dòng theo điều kiện (nếu có).
   - **Join**: Thực hiện nối hai bảng dựa trên khóa (`orderkey`).
   - **Project**: Chọn cột đầu ra (ở đây là `orderkey` và `total_price_wo_tax`).
   - **Aggregate**: Tổng hợp theo `GROUP BY`.
   - **Exchange**: Di chuyển dữ liệu giữa các node (sử dụng hàm băm trên `orderkey`).

3. **Hash/Join Distribution** – Dòng mô tả `distribution = PARTITIONED` hay `REPLICATED` cho biết đó là Hash Join hay Broadcast Join.

💡 Khi đọc EXPLAIN:
- **Đọc từ dưới lên trên**: Fragment dưới cùng thường là nơi dữ liệu được đọc và xử lý trước.
- **Tìm dấu hiệu Exchange** → biểu hiện của wide transformation.
- **Kiểm tra Estimates** → để xem số dòng & kích thước dữ liệu Trino dự đoán.

Dưới đây là truy vấn dùng EXPLAIN để xem kế hoạch thực thi.

📌 Sau khi chạy câu lệnh trên, bạn có thể copy kết quả EXPLAIN vào một file hoặc dán vào Trino UI (localhost:8080) → Live Plan để xem sơ đồ trực quan.
*/

USE tpch.tiny;

EXPLAIN
SELECT
  o.orderkey,
  SUM(l.extendedprice * (1 - l.discount)) AS total_price_wo_tax
FROM
  lineitem l
JOIN
  orders o ON l.orderkey = o.orderkey
GROUP BY
  o.orderkey;
