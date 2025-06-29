
# 📂 4.1. Cách OLAP DB lưu trữ dữ liệu – Chia nhỏ để xử lý hiệu quả

Trong hệ thống OLAP hiện đại, dữ liệu được xử lý trên nền tảng phân tán, nghĩa là **nhiều máy (nodes) cùng tham gia lưu trữ và tính toán dữ liệu**. Hiểu được cách dữ liệu được chia nhỏ và xử lý là bước đầu tiên để **tối ưu hiệu suất truy vấn và giảm chi phí xử lý**.

---

## 🧩 Mô hình hệ thống phân tán

Hầu hết các OLAP DB (như Trino, BigQuery, Redshift…) đều là hệ thống **distributed**. Điều này có nghĩa:

### ✅ Nguyên lý cốt lõi:
1. **Chia nhỏ tập dữ liệu lớn thành các phần nhỏ (chunks)** và phân phối đều trên các node trong cluster.
2. **Xử lý dữ liệu tại chính node chứa nó**, tránh việc phải truyền tải qua mạng – giúp tiết kiệm tài nguyên và thời gian.

---

## 🔄 Ưu điểm và Cân nhắc

| Yếu tố | Mô tả |
|--------|-------|
| ⚡ Ưu điểm | Cho phép **xử lý song song (parallel processing)** trên nhiều node. |
| ⚠️ Thách thức | Tăng độ phức tạp trong việc quản lý và phối hợp các phần dữ liệu khi thực hiện JOIN hoặc AGGREGATE. |
| 🧠 Gợi ý sử dụng | **Chỉ nên dùng mô hình phân tán khi dữ liệu đủ lớn** hoặc cần tổng hợp dữ liệu khối lượng lớn. |

---

## 🗃 Ví dụ về các hệ thống lưu trữ phân tán

- **HDFS** (Hadoop Distributed File System)
- **Amazon S3**
- **Google Cloud Storage**

---

## 🚀 Mục tiêu tối ưu truy vấn trong hệ thống phân tán

Để tăng hiệu suất truy vấn, cần tuân thủ hai nguyên tắc vàng:

1. **Giảm lượng dữ liệu cần truyền giữa các node** (data shuffle).
2. **Giảm lượng dữ liệu cần xử lý tổng thể** (bằng cách lọc sớm, chỉ đọc cột cần thiết, dùng định dạng cột, v.v.).

---

👉 *Việc hiểu rõ cách dữ liệu được lưu trữ và xử lý không chỉ giúp cải thiện tốc độ truy vấn mà còn giảm chi phí xử lý đáng kể trong môi trường dữ liệu lớn.*
