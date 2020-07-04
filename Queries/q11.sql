WITH tab AS
(SELECT a.dept_name, MIN(-1 * a.salary) * -1 AS salary FROM
(SELECT departments.dept_name, dept_emp.emp_no, salaries.salary FROM dept_emp 
INNER JOIN salaries ON dept_emp.emp_no = salaries.emp_no AND dept_emp.to_date = salaries.to_date
INNER JOIN departments ON dept_emp.dept_no = departments.dept_no
WHERE YEAR(dept_emp.to_date) = 9999) a
GROUP BY a.dept_name)
SELECT tab.dept_name AS dept_name, B.emp_no AS emp_no, tab.salary AS salary FROM tab
INNER JOIN 
(SELECT departments.dept_name, dept_emp.emp_no, salaries.salary FROM dept_emp 
INNER JOIN salaries ON dept_emp.emp_no = salaries.emp_no AND dept_emp.to_date = salaries.to_date
INNER JOIN departments ON dept_emp.dept_no = departments.dept_no
WHERE YEAR(dept_emp.to_date) = 9999) as B ON tab.dept_name = B.dept_name AND tab.salary = B.salary
ORDER BY tab.dept_name;