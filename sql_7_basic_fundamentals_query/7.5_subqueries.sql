-- Subqueries example
USE tpch.tiny;
SELECT n.name AS nation_name, s.quantity AS supplied_items_quantity, c.quantity AS purchased_items_quantity
FROM nation n
LEFT JOIN (...)
LEFT JOIN (...);