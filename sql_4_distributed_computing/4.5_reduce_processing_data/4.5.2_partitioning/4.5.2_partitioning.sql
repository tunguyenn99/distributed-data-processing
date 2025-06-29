CREATE TABLE minio.tpch.lineitem_w_encoding_w_partitioning (
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
  receiptdate date,
  receiptyear varchar(4)
) WITH (
  external_location = 's3a://tpch/lineitem_w_encoding_w_partitioning/',
  partitioned_by = ARRAY ['receiptyear'],
  format = 'PARQUET'
);

INSERT INTO minio.tpch.lineitem_w_encoding_w_partitioning
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
  COMMENT,
  commitdate,
  linestatus,
  returnflag,
  shipdate,
  receiptdate,
  CAST(YEAR(receiptdate) AS varchar(4)) AS receiptyear
FROM tpch.tiny.lineitem;