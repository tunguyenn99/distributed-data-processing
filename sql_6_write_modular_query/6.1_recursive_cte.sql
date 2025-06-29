-- 6.1 WITH RECURSIVE – tạo chuỗi báo cáo nhân sự

SET SESSION max_recursion_depth = 12;

WITH RECURSIVE manager_chain(id, emp, path_to_top) AS (
  SELECT id, name, ARRAY[name] AS path_to_top
  FROM employee_info
  WHERE reports_to IS NULL
  UNION ALL
  SELECT ei.id, ei.name, ARRAY[ei.name] || mc.path_to_top
  FROM employee_info ei
  JOIN manager_chain mc ON ei.reports_to = mc.id
)
SELECT * FROM manager_chain;