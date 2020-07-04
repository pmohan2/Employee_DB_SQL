SELECT titles.emp_no, COUNT(titles.emp_no) AS cnt FROM titles 
LEFT JOIN salaries ON titles.emp_no = salaries.emp_no AND titles.from_date = salaries.from_date 
WHERE titles.emp_no IN (SELECT emp_no FROM titles GROUP BY emp_no HAVING COUNT(emp_no) > 1)
AND salaries.salary IS NULL GROUP BY titles.emp_no ORDER BY titles.emp_no;