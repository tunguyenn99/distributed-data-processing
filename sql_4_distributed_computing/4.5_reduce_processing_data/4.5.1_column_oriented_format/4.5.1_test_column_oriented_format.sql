-- ✅ Truy vấn trên bảng định dạng cột (Parquet): nhanh, đọc ít dữ liệu
SELECT
  suppkey,
  SUM(quantity) AS total_qty
FROM
  minio.tpch.lineitem_w_encoding
GROUP BY
  suppkey;

-- ⏱️ Kết quả mẫu: 2.22 giây | 6M rows | 14.5MB | 2.7M rows/s

------------------------------------------------------------

-- ❌ Truy vấn trên bảng định dạng dòng (Textfile): chậm hơn, đọc toàn bộ dòng
SELECT
  suppkey,
  SUM(quantity) AS total_qty
FROM
  minio.tpch.lineitem_wo_encoding
GROUP BY
  suppkey;

-- ⏱️ Kết quả mẫu: 10.98 giây | 6M rows | 215MB | 547K rows/s
