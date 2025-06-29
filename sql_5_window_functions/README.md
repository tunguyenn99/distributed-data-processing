# 🪟 Chương 5 – Window Functions trong Trino SQL

Window function là công cụ cực kỳ mạnh trong phân tích dữ liệu với SQL, cho phép bạn thực hiện tổng hợp, xếp hạng, so sánh giữa các dòng mà **vẫn giữ lại toàn bộ dữ liệu gốc**.

---

## 📚 Cấu trúc chương

| Phần | Nội dung chính | File SQL |
|------|----------------|----------|
| 5.1 | Giới thiệu window + định nghĩa cửa sổ | `5.1_window_definition.sql` |
| 5.2 | Aggregate trong cửa sổ (SUM, AVG, COUNT...) | `5.2_window_aggregate.sql` |
| 5.3 | Ranking (RANK, DENSE_RANK, ROW_NUMBER) | `5.3_window_ranking.sql` |
| 5.4 | So sánh giữa dòng (LAG, LEAD) | `5.4_window_value_lag_lead.sql` |
| 5.5 | Tính biến động & cờ boolean | `5.5_window_value_flags.sql` |
| 5.6.1 | Window frame với ROWS | `5.6.1_window_frame_rows.sql` |
| 5.6.2 | Window frame với RANGE | `5.6.2_window_frame_range.sql` |
| 5.6.3 | Window frame với GROUPS | `5.6.3_window_frame_groups.sql` |

---

## 🧠 Window là gì?

Là **tập hợp các dòng liên quan đến dòng hiện tại**, xác định bởi:
- `PARTITION BY`: nhóm dữ liệu thành các cửa sổ
- `ORDER BY`: sắp xếp dòng trong từng cửa sổ
- `OVER (...)`: định nghĩa cửa sổ cho function

---

## 🔧 Ứng dụng chính

| Mục tiêu | Hàm sử dụng |
|----------|-------------|
| Tính tích luỹ | `SUM() OVER(...)` |
| Xếp hạng | `RANK()`, `DENSE_RANK()`, `ROW_NUMBER()` |
| So sánh dòng trước/sau | `LAG()`, `LEAD()` |
| Cờ logic | `CASE WHEN ... THEN TRUE` |
| Frame linh hoạt | `ROWS`, `RANGE`, `GROUPS` |

---

## 🧪 Ví dụ thực tế

- Tổng doanh thu theo tháng và phần trăm thay đổi
- Xếp hạng đơn hàng theo giá trị cho mỗi khách hàng
- So sánh chi tiêu theo ngày của từng khách
- Tạo cờ `has_increased`, `will_increase` để hỗ trợ dự báo
- Phân tích biến động theo tháng với sliding window linh hoạt

---

## ⚠️ Lưu ý

- `ORDER BY` trong `OVER()` là **bắt buộc** nếu bạn cần tính thứ tự, chạy tích luỹ, hoặc dùng `LAG/LEAD`
- Window function không làm gộp dữ liệu → giữ nguyên số dòng gốc
- Window frame (`ROWS`, `RANGE`, `GROUPS`) giúp bạn tùy chỉnh phạm vi dòng tham chiếu trong tính toán

---

👉 Đây là công cụ không thể thiếu trong phân tích dữ liệu hiện đại, đặc biệt với Trino và các hệ OLAP.