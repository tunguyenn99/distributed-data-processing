
# ⚙️ Chương 4 – Tối ưu xử lý dữ liệu trong hệ thống OLAP

Chương này hướng dẫn bạn cách các hệ thống OLAP như **Trino** xử lý dữ liệu phân tán,  
và cách bạn có thể **viết truy vấn hiệu quả hơn, tiết kiệm thời gian và chi phí xử lý**.

---

## 🎯 Mục tiêu chương 4

- Hiểu cách dữ liệu được lưu trữ & xử lý trong hệ thống phân tán
- Phân biệt giữa Narrow và Wide Transformation
- Sử dụng định dạng cột (column-oriented) để tăng tốc truy vấn
- Tối ưu bằng Partitioning và Bucketing
- Đọc và phân tích `EXPLAIN PLAN` để hiểu cách Trino thực thi truy vấn

---

## 📦 4.1 – OLAP lưu trữ dữ liệu thành các khối nhỏ

- Dữ liệu lớn được chia nhỏ (chunk) và phân phối đều giữa các node
- Mỗi node xử lý độc lập → tránh truyền dữ liệu tốn kém qua mạng
- Hệ thống phân tán rất mạnh với dữ liệu lớn, nhưng cần quản lý cẩn thận

---

## 🔄 4.2 – Narrow vs Wide Transformation

- **Narrow**: không cần truyền dữ liệu giữa các node (ví dụ: phép tính theo dòng)
- **Wide**: cần truyền dữ liệu để thực hiện `JOIN`, `GROUP BY` → tốn tài nguyên
- Tối ưu bằng cách:
  - **lọc sớm (early filter)**
  - **chỉ đọc các cột cần thiết**
  - **dùng Broadcast join khi có thể**

---

## 🧠 4.3 – Hash Join vs Broadcast Join

| Loại join | Đặc điểm |
|-----------|----------|
| Hash Join | Chia nhỏ cả 2 bảng, truyền qua mạng → tốn kém |
| Broadcast Join | Gửi bảng nhỏ (dimension) tới các node chứa bảng lớn (fact) → rất nhanh nếu dimension nhỏ |

> 📌 Trino sẽ tự chọn loại join phù hợp, nhưng bạn có thể cấu hình ngưỡng `join_max_broadcast_table_size`.

---

## 🔍 4.4 – Đọc và hiểu kế hoạch truy vấn (EXPLAIN)

- Sử dụng `EXPLAIN` hoặc `EXPLAIN ANALYZE` để xem:
  - Các giai đoạn (fragments)
  - Các bước xử lý: `Scan`, `Join`, `Aggregate`, `Exchange`, v.v.
- Đọc từ dưới lên để hiểu trình tự thực thi
- Sử dụng Trino UI (`localhost:8080`) để xem trực quan

---

## 📊 4.5 – Giảm dữ liệu cần xử lý

### 4.5.1 – Column-oriented format
- Dùng định dạng như **Parquet** hoặc **ORC**
- Chỉ đọc các cột cần thiết (column pruning)
- Hỗ trợ nén dữ liệu tốt hơn → tăng tốc truy vấn

### 4.5.2 – Partitioning
- Lưu dữ liệu thành thư mục theo giá trị cột (`receiptyear=1994/`)
- Truy vấn có `WHERE` trên cột partition sẽ tự động **bỏ qua thư mục không liên quan**
- Tối ưu khi cột có ít giá trị (low cardinality)

### 4.5.3 – Bucketing
- Chia bảng thành nhiều bucket theo hàm băm của một cột
- Phù hợp với cột có nhiều giá trị (high cardinality) như `quantity`
- Giúp giảm dữ liệu quét trong truy vấn lọc theo bucket

---

## 🧪 So sánh hiệu suất thực tế

| Truy vấn | Input | Thời gian | Định dạng |
|---------|--------|-----------|-----------|
| GROUP BY suppkey (TEXTFILE) | 6M rows, 215MB | 10.98s | Dòng |
| GROUP BY suppkey (PARQUET) | 6M rows, 14.5MB | 2.22s | Cột |
| Filter partitioned | 9.5K rows | 1s | Partition |
| Filter bucketed | 21K rows | 1.5s | Bucket |

---

## 🧠 Tổng kết

> Viết truy vấn hiệu quả không chỉ nằm ở SQL logic, mà còn nằm ở **cách dữ liệu được lưu trữ, phân phối và tổ chức**.  
> Chương này cung cấp kiến thức nền tảng để bạn tối ưu hóa truy vấn SQL trong các hệ thống OLAP hiện đại như Trino.

👉 *Tiếp tục với chương 5 để tìm hiểu Window Functions và các ứng dụng nâng cao!*
