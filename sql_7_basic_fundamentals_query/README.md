# 📘 Chương 7 – Kỹ năng SQL Cơ Bản & Trung Cấp trong Trino

Chương này cung cấp nền tảng vững chắc cho việc sử dụng SQL trong Trino, từ cú pháp cơ bản như `SELECT`, `WHERE`, `ORDER BY` đến các chủ đề nâng cao như `JOIN`, `GROUP BY`, `CASE`, `UNION`, `CAST`, xử lý `NULL`, và cả `VIEW` & `MATERIALIZED VIEW`.

---

## 📚 Nội dung chính

| Phần | Mô tả | Lệnh hoặc chủ đề | File SQL |
|------|-------|------------------|----------|
| 7.1 | Xem cấu trúc bảng | `DESCRIBE`, `USE schema` | `7.1_use.sql` |
| 7.2 | Lọc dữ liệu | `SELECT`, `WHERE`, `LIMIT`, `ORDER BY`, `IN`, `LIKE` | `7.2_filter.sql` |
| 7.3 | Kết hợp bảng | `JOIN`: Inner, Left, Right, Full, Cross, Self Join | `7.3_joins.sql` |
| 7.4 | Tổng hợp dữ liệu | `GROUP BY`, `COUNT`, `SUM`, `AVG`, `MIN`, `MAX` | `7.4_groupby.sql` |
| 7.5 | Truy vấn lồng nhau | Sub-query (SELECT trong FROM hoặc WHERE) | `7.5_subquery.sql` |
| 7.6 | Chuyển kiểu dữ liệu & xử lý NULL | `CAST`, `COALESCE` | `7.6_cast_coalesce.sql` |
| 7.7 | Logic điều kiện | `CASE WHEN THEN ELSE END` | `7.7_case_when.sql` |
| 7.8 | Ghép bảng dọc / trừ dữ liệu | `UNION`, `UNION ALL`, `EXCEPT` | `7.8_union_except.sql` |
| 7.9 | Tạo view | `CREATE VIEW`, `CREATE MATERIALIZED VIEW` | `7.9_views.sql` |
| 7.10 | Hàm xử lý dữ liệu | String, Date/Time, Numeric functions | `7.10_functions.sql` |
| 7.11 | Tạo bảng & thao tác dữ liệu | `CREATE TABLE`, `INSERT`, `DELETE`, `DROP` | `7.11_create_table.sql` |

---

## 🛠 Các kỹ năng học được

- Lọc dữ liệu hiệu quả
- Kết hợp nhiều bảng bằng các loại JOIN khác nhau
- Tổng hợp và nhóm dữ liệu để tạo báo cáo
- Áp dụng logic điều kiện trong truy vấn
- Làm việc với dữ liệu dạng thời gian, chuỗi và số
- Tái sử dụng truy vấn phức tạp qua VIEW và MATERIALIZED VIEW
- Quản lý bảng và dữ liệu

---

## 💡 Tips hay

- Dùng `LIMIT` để xem thử dữ liệu mà không phải tải cả bảng
- Dùng `COALESCE` để xử lý giá trị NULL dễ dàng
- Khi cần viết nhiều `GROUP BY`, có thể dùng `GROUPING SETS`
- `UNION` loại bỏ dòng trùng lặp, `UNION ALL` thì không
- Trino hiện không hỗ trợ bảng tạm (temporary table)

---

👉 Chương này là viên gạch nền tảng để tiến vào các kỹ thuật nâng cao như Window Functions, CTE, hoặc phân tích OLAP.
