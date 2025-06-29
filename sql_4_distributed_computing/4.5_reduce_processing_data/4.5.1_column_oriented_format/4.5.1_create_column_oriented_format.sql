
-- =============================================================
-- So sánh hiệu quả giữa định dạng dòng (TEXTFILE) và định dạng cột (PARQUET) trong Trino
-- Mục tiêu: tạo 2 bảng giống nhau về cấu trúc nhưng khác về định dạng lưu trữ,
-- để so sánh hiệu suất truy vấn và kích thước lưu trữ.
-- =============================================================

-- Xóa schema minio.tpch nếu đã tồn tại
DROP SCHEMA IF EXISTS minio.tpch;

-- 📁 Tạo lại schema với đường dẫn tới bucket MinIO (đã được mount sẵn)
CREATE SCHEMA minio.tpch WITH (
  location = 's3a://tpch/'
);

-- =============================================================
-- BẢNG 1: Lưu theo định dạng dòng (TEXTFILE)
-- =============================================================

-- Xóa bảng nếu đã tồn tại
DROP TABLE IF EXISTS minio.tpch.lineitem_wo_encoding;

-- Tạo bảng TEXTFILE (định dạng lưu theo dòng)
CREATE TABLE minio.tpch.lineitem_wo_encoding (
  orderkey bigint,
  partkey bigint,
  suppkey bigint,
  linenumber integer,
  quantity double,
  extendedprice double,
  discount double,
  tax double,
  shipinstruct varchar(25),
  shipmode varchar(10),
  COMMENT varchar(44),
  commitdate date,
  linestatus varchar(1),
  returnflag varchar(1),
  shipdate date,
  receiptdate date
)
WITH (
  external_location = 's3a://tpch/lineitem_wo_encoding/',
  format = 'TEXTFILE'  -- định dạng dòng
);

-- Đổ dữ liệu từ bảng lineitem gốc
USE tpch.sf1;

INSERT INTO minio.tpch.lineitem_wo_encoding (
  orderkey,
  partkey,
  suppkey,
  linenumber,
  quantity,
  extendedprice,
  discount,
  tax,
  shipinstruct,
  shipmode,
  comment,
  commitdate,
  linestatus,
  returnflag,
  shipdate,
  receiptdate
)
SELECT
  orderkey,
  partkey,
  suppkey,
  linenumber,
  quantity,
  extendedprice,
  discount,
  tax,
  shipinstruct,
  shipmode,
  comment,
  commitdate,
  linestatus,
  returnflag,
  shipdate,
  receiptdate
FROM tpch.sf1.lineitem;

-- =============================================================
-- BẢNG 2: Lưu theo định dạng cột (PARQUET)
-- =============================================================

-- Xóa bảng nếu đã tồn tại
DROP TABLE IF EXISTS minio.tpch.lineitem_w_encoding;

-- Tạo bảng với định dạng PARQUET (định dạng lưu theo cột)
CREATE TABLE minio.tpch.lineitem_w_encoding (
  orderkey bigint,
  partkey bigint,
  suppkey bigint,
  linenumber integer,
  quantity double,
  extendedprice double,
  discount double,
  tax double,
  shipinstruct varchar(25),
  shipmode varchar(10),
  COMMENT varchar(44),
  commitdate date,
  linestatus varchar(1),
  returnflag varchar(1),
  shipdate date,
  receiptdate date
)
WITH (
  external_location = 's3a://tpch/lineitem_w_encoding/',
  format = 'PARQUET'  -- định dạng cột
);

-- Đổ dữ liệu giống bảng TEXTFILE
INSERT INTO minio.tpch.lineitem_w_encoding (
  orderkey,
  partkey,
  suppkey,
  linenumber,
  quantity,
  extendedprice,
  discount,
  tax,
  shipinstruct,
  shipmode,
  comment,
  commitdate,
  linestatus,
  returnflag,
  shipdate,
  receiptdate
)
SELECT
  orderkey,
  partkey,
  suppkey,
  linenumber,
  quantity,
  extendedprice,
  discount,
  tax,
  shipinstruct,
  shipmode,
  comment,
  commitdate,
  linestatus,
  returnflag,
  shipdate,
  receiptdate
FROM tpch.sf1.lineitem;


-- Sau khi chạy file này, bạn có thể kiểm tra hiệu suất truy vấn,
-- cũng như kích thước file trực tiếp trên giao diện MinIO (http://localhost:9001).
