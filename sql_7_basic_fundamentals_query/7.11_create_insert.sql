-- Create, insert, delete, drop
USE minio.warehouse;
CREATE TABLE sample_table2 (sample_key bigint, sample_status varchar);
INSERT INTO sample_table2 VALUES (1, 'hello');
DELETE FROM sample_table2;
DROP TABLE sample_table2;