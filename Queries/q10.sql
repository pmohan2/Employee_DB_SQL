With tab AS (SELECT employees.emp_no, employees.birth_date, employees.hire_date, salaries.salary, salaries.from_date, salaries.to_date FROM employees
INNER JOIN salaries ON employees.emp_no = salaries.emp_no AND YEAR(salaries.to_date) = 9999 AND YEAR(birth_date) = 1965)
SELECT a.emp_no AS h_empno, a.salary AS h_salary, a.hire_date AS h_date, b.emp_no AS l_empno, b.salary AS l_salary, b.hire_date AS l_date
FROM tab a INNER JOIN tab b ON a.salary > b.salary AND a.hire_date > b.hire_date ORDER BY a.emp_no, b.emp_no;