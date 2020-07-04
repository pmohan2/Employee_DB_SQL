WITH table1 AS 
(SELECT titles.emp_no, departments.dept_name, DATEDIFF(titles.to_date, titles.from_date) AS duration FROM titles 
INNER JOIN dept_emp ON titles.emp_no = dept_emp.emp_no
INNER JOIN departments ON dept_emp.dept_no = departments.dept_no
WHERE title = 'Manager' AND YEAR(titles.to_date) != 9999 order by departments.dept_name)
SELECT a.emp_no, a.dept_name FROM table1 a LEFT JOIN table1 b ON a.dept_name = b.dept_name and a.duration < b.duration
WHERE b.duration IS NULL ORDER BY a.emp_no;