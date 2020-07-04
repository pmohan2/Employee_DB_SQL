SELECT employees.emp_no, departments.dept_name, dept_emp.from_date FROM employees 
INNER JOIN dept_emp ON employees.emp_no = dept_emp.emp_no
INNER JOIN departments ON dept_emp.dept_no = departments.dept_no
WHERE YEAR(dept_emp.to_date) = 9999
ORDER BY emp_no;