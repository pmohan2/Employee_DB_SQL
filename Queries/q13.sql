WITH tab AS (SELECT DISTINCT a.title AS src, b.title AS dst FROM titles a, titles b WHERE a.emp_no = b.emp_no AND a.from_date < b.from_date AND a.title != b.title),
tab1 AS (SELECT DISTINCT a.src, b.dst FROM (SELECT DISTINCT a.src, b.dst FROM tab a, tab b WHERE a.dst = b.src) a, 
(SELECT DISTINCT a.src, b.dst FROM tab a, tab b WHERE a.dst = b.src) b WHERE a.dst = b.src),
final AS (SELECT * FROM tab UNION SELECT * FROM tab1),
temp1 AS (SELECT a.title AS src, b.title AS dst FROM (SELECT DISTINCT src as title FROM tab) a, (SELECT DISTINCT src as title FROM tab) b),
temp_fin AS (SELECT * From temp1 UNION ALL SELECT * FROM final)
SELECT src, dst FROM temp_fin GROUP BY src, dst HAVING COUNT(*)= 1 ORDER BY src, dst;