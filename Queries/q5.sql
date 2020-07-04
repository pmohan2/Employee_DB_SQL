SELECT departments.dept_name, COUNT(departments.dept_name) as noe FROM dept_emp
INNER JOIN departments ON dept_emp.dept_no = departments.dept_no
GROUP BY dept_name
ORDER BY dept_name;