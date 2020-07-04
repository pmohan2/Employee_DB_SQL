WITH tab1 AS # Table with all values
(SELECT departments.dept_name, salaries.salary FROM dept_emp
INNER JOIN salaries ON dept_emp.emp_no = salaries.emp_no AND dept_emp.to_date = salaries.to_date
INNER JOIN departments ON dept_emp.dept_no = departments.dept_no WHERE YEAR(dept_emp.to_date) = 9999),
tab2 AS #Table with 9 departments and their average 
(SELECT departments.dept_name, AVG(salaries.salary) AS average FROM dept_emp
INNER JOIN salaries ON dept_emp.emp_no = salaries.emp_no AND dept_emp.to_date = salaries.to_date
INNER JOIN departments ON dept_emp.dept_no = departments.dept_no WHERE YEAR(dept_emp.to_date) = 9999
GROUP BY departments.dept_name),
tab3 AS # Table with 9 departments and count of salaries greater than average
(SELECT tab2.dept_name, COUNT(tab2.dept_name) AS cnt1 FROM tab2
RIGHT JOIN tab1 ON tab2.dept_name = tab1.dept_name AND  tab2.average < tab1.salary WHERE tab2.average IS NOT NULL
GROUP BY tab2.dept_name),
tab4 AS # Table with 9 departments and count of all salaries
(SELECT tab1.dept_name, COUNT(tab1.dept_name) AS cnt2 FROM tab1 GROUP BY tab1.dept_name)
SELECT tab2.dept_name, (tab3.cnt1/tab4.cnt2)*100 AS above_avg_pect FROM tab2
INNER JOIN tab3 ON tab2.dept_name = tab3.dept_name INNER JOIN tab4 ON tab2.dept_name = tab4.dept_name
ORDER BY tab2.dept_name;