
# 📊 Chương 3 – Hiểu Dữ Liệu của Bạn: Nền tảng của Phân Tích Dữ Liệu

Trước khi viết một dòng SQL hay xây dựng báo cáo nào, bạn cần thực sự **hiểu dữ liệu** mà mình đang làm việc cùng. Chương này sẽ giúp bạn nắm được cách dữ liệu được mô hình hóa trong kho dữ liệu, cách phân biệt giữa các bảng fact và dimension, hiểu vai trò của **câu truy vấn phân tích (analytical queries)** và đặt các câu hỏi đúng để hiểu rõ hơn về dữ liệu mình có.

---

## 🧱 3.1 Hiểu quy trình nghiệp vụ (business process)

Trong kho dữ liệu (data warehouse), ta thường gặp hai loại bảng chính:

- **Dimension table**: Chứa thông tin mô tả các thực thể kinh doanh (vd: khách hàng, sản phẩm, nhà cung cấp…).
- **Fact table**: Ghi nhận các sự kiện đã xảy ra, thường liên quan đến con số (vd: đơn hàng, mặt hàng đã bán…).

Mỗi bảng fact sẽ có "granularity" (mức độ chi tiết) nhất định, ví dụ:
- Bảng `orders`: mỗi dòng là một đơn hàng.
- Bảng `lineitem`: mỗi dòng là một sản phẩm trong đơn hàng.

🧮 Ví dụ:
```sql
-- Tính tổng giá trị của đơn hàng từ bảng lineitem
SELECT
  orderkey,
  ROUND(SUM(extendedprice * (1 - discount) * (1 + tax)), 2) AS totalprice
FROM lineitem
WHERE orderkey = 1
GROUP BY orderkey;
```

> 📝 Ghi chú: Có thể xảy ra chênh lệch nhỏ do kiểu dữ liệu `double` không chính xác tuyệt đối.

---

## 📊 3.2 Analytical Queries là gì?

Là các truy vấn thực hiện **tổng hợp số liệu** từ bảng fact theo các thuộc tính từ bảng dimension, ví dụ:

- Top 10 nhà cung cấp theo doanh thu trong năm qua
- Doanh số trung bình theo quốc gia và năm
- Hiệu suất theo phân khúc khách hàng theo tháng

🎯 Cách phân tích:

1. **JOIN**: Kết hợp bảng fact với các bảng dimension để lấy thuộc tính mô tả.
2. **ROLLUP**: Nhóm dữ liệu theo các chiều phù hợp (`GROUP BY`).
3. **Chọn đúng loại cột để tổng hợp**:
   - **Additive** (cộng gộp được): `price`, `quantity`
   - **Non-additive**: `discount`, `tỉ lệ`, `distinct count`

> 🧠 Khi bài tập yêu cầu "tạo báo cáo ở mức dimension1, dimension2", tức là phải `GROUP BY` theo 2 chiều đó.

---

## 🔍 3.3 Làm quen và hiểu rõ dữ liệu

Dưới đây là những câu hỏi giúp bạn hiểu rõ dataset mình đang dùng:

| Câu hỏi | Ý nghĩa |
|--------|---------|
| **1. Dữ liệu này biểu diễn điều gì?** | Hiểu ý nghĩa và bối cảnh nghiệp vụ |
| **2. Dữ liệu đến từ đâu?** | DB hệ thống, API, upload thủ công...? |
| **3. Tần suất pipeline?** | Hàng ngày, hàng tuần? Bao lâu mới có dữ liệu? |
| **4. Có ghi đè dữ liệu không?** | Có thể truy ngược dữ liệu cũ không? |
| **5. Có caveat nào không?** | Thiếu dữ liệu, dữ liệu lệch, mùa vụ… |
| **6. Ai là người dùng dữ liệu?** | Để hiểu cách hỗ trợ, debug khi có sự cố |

Việc trả lời những câu hỏi trên sẽ giúp bạn:
- Tránh hiểu sai dữ liệu
- Giải thích được số liệu trên dashboard
- Đưa ra được phân tích chính xác và đáng tin cậy

---

## ✅ Tổng kết

Chương này đặt nền móng để bạn trở thành một Data Analyst giỏi – không chỉ viết được câu SQL đúng mà còn hiểu đúng bối cảnh và ý nghĩa phía sau con số.

> 👉 Hãy luôn "nghĩ cùng dữ liệu" trước khi "phân tích dữ liệu".
