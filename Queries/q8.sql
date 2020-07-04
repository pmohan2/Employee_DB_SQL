SELECT departments.dept_name, COUNT(dept_manager.dept_no)-1 AS cnt FROM dept_manager
INNER JOIN departments ON dept_manager.dept_no = departments.dept_no GROUP BY dept_manager.dept_no
HAVING COUNT(dept_manager.dept_no)-1 > 1
ORDER BY departments.dept_name;