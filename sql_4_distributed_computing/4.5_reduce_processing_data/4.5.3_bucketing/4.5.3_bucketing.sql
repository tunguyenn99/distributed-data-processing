DROP TABLE IF EXISTS minio.tpch.lineitem_w_encoding_w_bucketing;

CREATE TABLE minio.tpch.lineitem_w_encoding_w_bucketing (
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
) WITH (
  external_location = 's3a://tpch/lineitem_w_encoding_w_bucketing/',
  format = 'PARQUET',
  bucket_count = 75,
  bucketed_by = ARRAY ['quantity']
);

USE tpch.tiny;

INSERT INTO minio.tpch.lineitem_w_encoding_w_bucketing (
  orderkey, partkey, suppkey, linenumber,
  quantity, extendedprice, discount, tax,
  shipinstruct, shipmode, COMMENT, commitdate,
  linestatus, returnflag, shipdate, receiptdate
)
SELECT
  orderkey, partkey, suppkey, linenumber,
  quantity, extendedprice, discount, tax,
  shipinstruct, shipmode, comment, commitdate,
  linestatus, returnflag, shipdate, receiptdate
FROM tpch.tiny.lineitem;

-- Truy vấn bảng gốc (không bucket):
EXPLAIN ANALYZE
SELECT * FROM tpch.tiny.lineitem
WHERE quantity BETWEEN 30 AND 45;

-- Truy vấn bảng có bucketing:
EXPLAIN ANALYZE
SELECT * FROM minio.tpch.lineitem_w_encoding_w_bucketing
WHERE quantity BETWEEN 30 AND 45;