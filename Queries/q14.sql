WITH tab AS (SELECT * FROM titles WHERE emp_no IN (SELECT emp_no FROM titles GROUP BY emp_no HAVING COUNT(emp_no) >= 1)),
tab2 AS (SELECT a.title AS src, b.title AS dst, YEAR(b.from_date) - YEAR(a.from_date) + 1 AS years FROM tab a, tab b WHERE a.to_date = b.from_date AND a.emp_no = b.emp_no AND a.title != b.title),
tab3 AS (SELECT src, dst, AVG(years) AS years FROM tab2 GROUP BY src, dst),
tab4 AS (SELECT a.src, b.dst, a.years + b.years AS years FROM tab3 a, tab3 b WHERE a.dst = b.src AND a.src != b.dst),
tab5 AS (SELECT * FROM tab4 UNION ALL SELECT * FROM tab3),
tab6 AS (SELECT src, dst, MIN(years) AS years FROM tab5 GROUP BY src, dst),
tab7 AS (SELECT a.src, b.dst, MIN(a.years + b.years) AS years FROM tab6 a, tab4 b WHERE a.dst = b.src AND a.src != b.dst GROUP BY a.src, b.dst),
final AS (SELECT * FROM tab4 UNION ALL SELECT * FROM tab7),
final1 AS (SELECT src, dst, MIN(years) FROM final group by src, dst),
final2 AS (SELECT * FROM tab3 UNION SELECT * FROM final1)
SELECT src, dst, MIN(years) AS years FROM final2 GROUP BY src, dst ORDER BY src;