## CSE 560 Data Models and Query Language
### Company DB - SQL Query

## 1 Project Setup

## 1.1 MySQL

This project ONLY use MySQL (version 8.0.13) as the canonical database. To
download MySQL community server, please go to https://downloads.mysql.com/archives/community/.

## 1.2 Database: Employees

Follow the steps below to install the project database

1. Download the GitHub Repository:https://github.com/datacharmer/test_db
2. Launch command line console, change the working directory to your downloaded repository
3. Type following command:
    `mysql < employees.sql`
    or
    `mysql -u YOURMYSQLUSERNAME -p < employees.sql`
    This will initialize your database.
4. To verify installation, run following commands:
    `mysql -t < testemployeesmd5.sql`
    or
    `mysql -u YOURMYSQLUSERNAME -p < testemployeesmd5.sql`


### Problem 1

Find all employees’ employee number, birth date, gender. Sort the result by
employee number. 

#### Query
`SELECT emp_no, birth_date, gender FROM employees ORDER BY emp_no;`

### Problem 2

Find all female employees and sort the result by employee number.

#### Query
`SELECT * FROM employees WHERE gender = 'F' ORDER BY emp_no;`

### Problem 3

Find all employees’ last name with their salaries in different periods. Sort the
result by last name, salary, fromdate, then todate.

#### Query
```
SELECT employees.last_name, salaries.salary, salaries.from_date, salaries.to_date
FROM employees INNER JOIN salaries ON employees.emp_no = salaries.emp_no
ORDER BY last_name, salary, from_date, to_date;
```

### Problem 4

Find all employees’ current department and the start date with their employee
number and sort the result by employee number.

#### Query
```
SELECT employees.emp_no, departments.dept_name, dept_emp.from_date FROM employees 
INNER JOIN dept_emp ON employees.emp_no = dept_emp.emp_no
INNER JOIN departments ON dept_emp.dept_no = departments.dept_no
WHERE YEAR(dept_emp.to_date) = 9999
ORDER BY emp_no;
```

### Problem 5

List the number of employees in each department. Sort the result by department
name.

#### Query
```
SELECT departments.dept_name, COUNT(departments.dept_name) as noe FROM dept_emp
INNER JOIN departments ON dept_emp.dept_no = departments.dept_no
GROUP BY dept_name ORDER BY dept_name;
```

### Problem 6

List pairs of employee (e1 , e2 ) which satisfies ALL following conditions:

1. Both e1 and e2 ’s current deparmnet number is d001.
2. The year of birthdate for e1 and e2 is 1955.
3. The e1’s employee number is less than e2.

Sort the result by e1 then e2.

#### Query
```
SELECT a.emp_no AS e1, b.emp_no AS e2 FROM 
(SELECT employees.emp_no FROM employees
INNER JOIN dept_emp ON employees.emp_no = dept_emp.emp_no
AND dept_emp.dept_no = 'd001'
AND YEAR(birth_date) = 1955
AND YEAR(to_date) = 9999) a
INNER JOIN 
(SELECT employees.emp_no FROM employees
INNER JOIN dept_emp ON employees.emp_no = dept_emp.emp_no
AND dept_emp.dept_no = 'd001' AND YEAR(birth_date) = 1955 AND YEAR(to_date) = 9999) b 
ON a.emp_no < b.emp_no ORDER BY  a.emp_no, b.emp_no;
```

### Problem 7

For each department, list out the manager who stayed the longest time in the
department. The list needs to exclude the current manager. Sort the result by
employ number.

#### Query
```
WITH table1 AS 
(SELECT titles.emp_no, departments.dept_name, DATEDIFF(titles.to_date, titles.from_date) AS duration FROM titles 
INNER JOIN dept_emp ON titles.emp_no = dept_emp.emp_no
INNER JOIN departments ON dept_emp.dept_no = departments.dept_no
WHERE title = 'Manager' AND YEAR(titles.to_date) != 9999 order by departments.dept_name)
SELECT a.emp_no, a.dept_name FROM table1 a LEFT JOIN table1 b ON a.dept_name = b.dept_name and a.duration < b.duration
WHERE b.duration IS NULL ORDER BY a.emp_no;
```

### Problem 8

Find out departments which has changed its manager more than once then list
out the name of the departments and the number of changes. Sort the result
by department name.

#### Query
```
SELECT departments.dept_name, COUNT(dept_manager.dept_no)-1 AS cnt FROM dept_manager
INNER JOIN departments ON dept_manager.dept_no = departments.dept_no GROUP BY dept_manager.dept_no
HAVING COUNT(dept_manager.dept_no)-1 > 1
ORDER BY departments.dept_name;
```

### Problem 9

For each employee, find out how many times the title has been changed without
chaning of the salary. e.g. An employee promoted from Engineer to Sr. Engineer
with salaries remains 10k. Sort the result by employ number.

#### Query 
```
SELECT titles.emp_no, COUNT(titles.emp_no) AS cnt FROM titles 
LEFT JOIN salaries ON titles.emp_no = salaries.emp_no AND titles.from_date = salaries.from_date 
WHERE titles.emp_no IN (SELECT emp_no FROM titles GROUP BY emp_no HAVING COUNT(emp_no) > 1)
AND salaries.salary IS NULL GROUP BY titles.emp_no ORDER BY titles.emp_no;
```

### Problem 10

Find out those pairs of employees (eH, eL) which satisfy ALL following conditions:

1. Both eH and eL born in 1965

2. eH’s current salary is higher than eL’s current salary

3. eH’s hiring date is greater than eL, which means eH is a newer employee
than eL.

Sort the result by employee number of eH then employee number of eL.

- hempno :eH’s employee number
- hsalary :eH’s current salary
- hdate :eH’s hire date
- lempno :eL’s employee number
- lsalary :eL’s current salary
- ldate :eL’s hire date

#### Query
```
With tab AS (SELECT employees.emp_no, employees.birth_date, employees.hire_date, salaries.salary, salaries.from_date, salaries.to_date FROM employees
INNER JOIN salaries ON employees.emp_no = salaries.emp_no AND YEAR(salaries.to_date) = 9999 AND YEAR(birth_date) = 1965)
SELECT a.emp_no AS h_empno, a.salary AS h_salary, a.hire_date AS h_date, b.emp_no AS l_empno, b.salary AS l_salary, b.hire_date AS l_date
FROM tab a INNER JOIN tab b ON a.salary > b.salary AND a.hire_date > b.hire_date ORDER BY a.emp_no, b.emp_no;
```

### Problem 11

Find the employee with highest current salary in each department. Note that
MAX function is not allowed. Sort the result by department name.

#### Query
```
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
```

### Problem 12

Calculate the percentage of number of employees’ current salary is above the
department current avarage. Sort the result by department name.

#### Query
```
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
```

### Problem 13

Assuming a title is a node and a promotion is an edge between nodes. For example 
promotion from Engineer to Senior Engineer means their is a path from
Node ’Engineer’ to Node ’Senior Engineer’. Find out pairs of node of source
and destination (src, dst) which there is no such path in the database. Sort the
result by src then dst. 

#### Query
```
WITH tab AS (SELECT DISTINCT a.title AS src, b.title AS dst FROM titles a, titles b WHERE a.emp_no = b.emp_no AND a.from_date < b.from_date AND a.title != b.title),
tab1 AS (SELECT DISTINCT a.src, b.dst FROM (SELECT DISTINCT a.src, b.dst FROM tab a, tab b WHERE a.dst = b.src) a, 
(SELECT DISTINCT a.src, b.dst FROM tab a, tab b WHERE a.dst = b.src) b WHERE a.dst = b.src),
final AS (SELECT * FROM tab UNION SELECT * FROM tab1),
temp1 AS (SELECT a.title AS src, b.title AS dst FROM (SELECT DISTINCT src as title FROM tab) a, (SELECT DISTINCT src as title FROM tab) b),
temp_fin AS (SELECT * From temp1 UNION ALL SELECT * FROM final)
SELECT src, dst FROM temp_fin GROUP BY src, dst HAVING COUNT(*)= 1 ORDER BY src, dst;
```

### Problem 14, 3 points

Continued from problem 13, assumeing we treat the years from beginning of a
title until promotion as the distance between nodes. e.g. An employee started as
an Assistant Engineer from 1950-01-01 to 1955-12-31 then be promoted to En-
gineer on 1955-12-31. Then there is an edge between node ”Assistant Engineer”
to ”Engineer” with distance 6.
Calculate the average distance of all possible pair of titles and ordered by
source node. To simplify the problem, there is no need to consider months and
date when calculating the distance. Only year is required for calculating the
distance. Besides, we can assume the distances of any given pair is less than
100.
Sort the result by src then dst. 

#### Query
```
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
```
