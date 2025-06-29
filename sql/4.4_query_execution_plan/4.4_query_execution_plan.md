# 4.4. Phân tích chiến lược thực thi - Execution Plan

Chạy câu SQL `4.4.1_query_optimize.sql`

```sql
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
```

Trả ra kết quả

```yml
Trino version: 422
Fragment 0 [tpch:orders:15000]
      Output layout: [orderkey, sum]
    Output partitioning: SINGLE []
    Output[columnNames = [orderkey, total_price_wo_tax]]
    │   Layout: [orderkey:bigint, sum:double]
    │   Estimates: {rows: 15000 (263.67kB), cpu: 0, memory: 0B, network: 0B}
    │   total_price_wo_tax := sum
    └─ Aggregate[type =  (STREAMING), keys = [orderkey]]
       │   Layout: [orderkey:bigint, sum:double]
       │   Estimates: {rows: 15000 (263.67kB), cpu: 1.03M, memory: 263.67kB, network: 0B}
       │   sum := sum("expr")
       └─ Project[]
          │   Layout: [expr:double, orderkey:bigint]
          │   Estimates: {rows: 60175 (1.03MB), cpu: 1.03M, memory: 0B, network: 0B}
          │   expr := ("extendedprice" * (1E0 - "discount"))
          └─ InnerJoin[criteria = ("orderkey" = "orderkey_1"), hash = [$hashvalue, $hashvalue_3], distribution = PARTITIONED]
             │   Layout: [orderkey:bigint, extendedprice:double, discount:double]
             │   Estimates: {rows: 60175 (1.55MB), cpu: 3.87M, memory: 263.67kB, network: 0B}
             │   Distribution: PARTITIONED
             │   dynamicFilterAssignments = {orderkey_1 -> #df_347}
             ├─ ScanFilterProject[table = tpch:tiny:lineitem, dynamicFilters = {"orderkey" = #df_347}]
             │      Layout: [orderkey:bigint, extendedprice:double, discount:double, $hashvalue:bigint]
             │      Estimates: {rows: 60175 (2.07MB), cpu: 1.55M, memory: 0B, network: 0B}/{rows: 60175 (2.07MB), cpu: 1.55M, memory: 0B, network: 0B}/{rows: 60175 (2.07MB), cpu: 2.07M, memory: 0B, network: 0B}
             │      $hashvalue := combine_hash(bigint '0', COALESCE("$operator$hash_code"("orderkey"), 0))
             │      orderkey := tpch:orderkey
             │      extendedprice := tpch:extendedprice
             │      discount := tpch:discount
             └─ LocalExchange[partitioning = SINGLE]
                │   Layout: [orderkey_1:bigint, $hashvalue_3:bigint]
                │   Estimates: {rows: 15000 (263.67kB), cpu: 0, memory: 0B, network: 0B}
                └─ ScanProject[table = tpch:tiny:orders]
                       Layout: [orderkey_1:bigint, $hashvalue_4:bigint]
                       Estimates: {rows: 15000 (263.67kB), cpu: 131.84k, memory: 0B, network: 0B}/{rows: 15000 (263.67kB), cpu: 263.67k, memory: 0B, network: 0B}
                       $hashvalue_4 := combine_hash(bigint '0', COALESCE("$operator$hash_code"("orderkey_1"), 0))
                       orderkey_1 := tpch:orderkey
                       tpch:orderstatus
                           :: [[F], [O], [P]]
```                           

---

## 📦 Fragment 0 – Xử lý chính (JOIN, tính toán, tổng hợp)

### 1. `ScanProject[tpch:tiny:orders]`
- **Mô tả**: Quét bảng `orders`, giữ lại cột `orderkey`, tạo thêm giá trị băm `$hashvalue_4`.
- **Estimate**: 15,000 dòng (~263KB).
- **Mục đích**: Dữ liệu đầu vào để thực hiện JOIN với `lineitem`.

### 2. `LocalExchange[partitioning = SINGLE]`
- Gom dữ liệu từ `orders` thành một nhóm (partition) nội bộ để gửi lên JOIN.
- **Không phát tán dữ liệu qua mạng**, xử lý gọn trong cùng node.

### 3. `ScanFilterProject[tpch:tiny:lineitem]`
- **Mô tả**: Đọc bảng `lineitem` với các cột `orderkey`, `extendedprice`, `discount`.
- Áp dụng **dynamic filter**: chỉ giữ các dòng `lineitem` có `orderkey` xuất hiện trong `orders`.
- **Mục tiêu**: Giảm khối lượng dữ liệu trước khi JOIN.

### 4. `InnerJoin[criteria = (orderkey = orderkey_1), distribution = PARTITIONED]`
- **Loại JOIN**: **Hash Join**.
- **Phân phối**: `PARTITIONED` – cả hai bảng được hash theo `orderkey`, sau đó gửi dữ liệu đến các node phù hợp.
- **Tính chất**: Đây là **wide transformation** → có trao đổi dữ liệu giữa các node.

### 5. `Project`
- Tính biểu thức:  
  ```sql
  extendedprice * (1 - discount)
  ```
- Gán kết quả vào alias tạm `expr`.

### 6. `Aggregate[type = STREAMING]`
- **Thao tác**: `GROUP BY orderkey`, sau đó `SUM(expr)`.
- **Kết quả**:  
  ```sql
  total_price_wo_tax := SUM(expr)
  ```

### 7. `Output`
- Cột đầu ra: `orderkey`, `total_price_wo_tax`
- **Output partitioning: SINGLE []** → Gom tất cả dữ liệu vào một node để trả kết quả về CLI/UI.

---

## 📊 Tóm tắt kiến thức rút ra

| Thành phần              | Ý nghĩa                                                                 |
|-------------------------|-------------------------------------------------------------------------|
| `PARTITIONED JOIN`      | Thể hiện đây là **Hash Join**, cần shuffle dữ liệu giữa các node.       |
| `Dynamic Filter`        | Tối ưu giúp giảm lượng dữ liệu cần xử lý trước khi JOIN.                |
| `STREAMING Aggregate`   | Tổng hợp dòng dữ liệu trong quá trình stream, tiết kiệm bộ nhớ.         |
| `LocalExchange`         | Gom dữ liệu trong node nội bộ, tránh truyền mạng không cần thiết.       |
| `Estimates`             | Thông tin dự đoán số dòng, CPU, dung lượng bộ nhớ trong mỗi bước.      |

---

## 💡 Mẹo kiểm tra nhanh JOIN loại nào:
- `distribution = PARTITIONED` → **Hash Join**
- `distribution = REPLICATED` → **Broadcast Join**

---

# ⚙️ Gợi ý tối ưu hóa khi phân tích Query Plan trong Trino

Khi bạn sử dụng `EXPLAIN` để phân tích kế hoạch thực thi truy vấn, dưới đây là những điểm **cốt lõi cần lưu ý để tối ưu hiệu suất**:

---

## ✅ 1. Giảm lượng dữ liệu cần đọc
- Cố gắng **lọc dữ liệu càng sớm càng tốt** (sử dụng `WHERE`).
- Áp dụng **partitioning**, **bucketing** hoặc **file format columnar** (chi tiết sẽ trình bày trong chương tiếp theo).

---

## ✅ 2. Giảm lượng dữ liệu cần trao đổi giữa các stage (Exchange)
- **Tránh `SELECT *`**, thay vào đó **chỉ chọn những cột thực sự cần thiết**.
- Tận dụng **định dạng cột tối ưu** (column-oriented formats như Parquet, ORC).
- Exchange càng ít → truy vấn càng nhanh và ít tốn chi phí mạng.

---

## ✅ 3. Ưu tiên Broadcast Join thay cho Hash Join (nếu có thể)
- Kiểm tra xem bảng nào **nhỏ hơn đáng kể** (thường là dimension table).
- Nếu phù hợp, hãy **ép sử dụng Broadcast Join** bằng cách tăng ngưỡng cấu hình:

```sql
SET SESSION join_max_broadcast_table_size = '100MB';
```

- Broadcast Join giúp **tránh shuffle bảng lớn**, từ đó **giảm thời gian và chi phí đáng kể**.

---

👉 *Việc hiểu và điều chỉnh kế hoạch thực thi là kỹ năng quan trọng để tăng tốc độ truy vấn trong các hệ thống dữ liệu phân tán như Trino.*