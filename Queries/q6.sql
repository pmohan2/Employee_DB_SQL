SELECT a.emp_no AS e1, b.emp_no AS e2 FROM 
(SELECT employees.emp_no FROM employees
INNER JOIN dept_emp ON employees.emp_no = dept_emp.emp_no
AND dept_emp.dept_no = 'd001'
AND YEAR(birth_date) = 1955
AND YEAR(to_date) = 9999) a
INNER JOIN 
(SELECT employees.emp_no FROM employees
INNER JOIN dept_emp ON employees.emp_no = dept_emp.emp_no
AND dept_emp.dept_no = 'd001'
AND YEAR(birth_date) = 1955
AND YEAR(to_date) = 9999) b 
ON a.emp_no < b.emp_no
ORDER BY  a.emp_no, b.emp_no;