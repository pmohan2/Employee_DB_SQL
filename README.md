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
`SELECT employees.last_name, salaries.salary, salaries.from_date, salaries.to_date 
FROM employees INNER JOIN salaries ON employees.emp_no = salaries.emp_no
ORDER BY last_name, salary, from_date, to_date;`

### Problem 4

Find all employees’ current department and the start date with their employee
number and sort the result by employee number.

#### Query
`SELECT employees.emp_no, departments.dept_name, dept_emp.from_date FROM employees 
INNER JOIN dept_emp ON employees.emp_no = dept_emp.emp_no
INNER JOIN departments ON dept_emp.dept_no = departments.dept_no
WHERE YEAR(dept_emp.to_date) = 9999
ORDER BY emp_no;`

### 2.5 Problem 5, 1 point

List the number of employees in each department. Sort the result by department
name. The result of query is similar to following table:

dept_name noe
Customer Service 23580
Development 85707
...

### 2.6 Problem 6, 2 points

List pairs of employee (e 1 , e 2 ) which satisfies ALL following conditions:

1. Bothe 1 ande 2 ’s current deparmnet number is d001.
2. The year of birthdate fore 1 ande 2 is 1955.
3. Thee 1 ’s employee number is less thane 2.

Sort the result bye 1 thene 2. The result of query is similar to following table:

e1 e
10239 10367
10239 11251
...
10367 11251
10367 11554
...


### 2.7 Problem 7, 2 points

For each department, list out the manager who stayed the longest time in the
department. The list needs to exclude the current manager. Sort the result by
employ number. The result of query is similar to following table:

emp_no dept_name
110022 Marketing
110085 Finance
...

### 2.8 Problem 8, 2 points

Find out departments which has changed its manager more than once then list
out the name of the departments and the number of changes. Sort the result
by department name. The result of query is similar to following table:

dept_name cnt
Customer Service 3
...

### 2.9 Problem 9, 2 points

For each employee, find out how many times the title has been changed without
chaning of the salary. e.g. An employee promoted from Engineer to Sr. Engineer
with salaries remains 10k. Sort the result by employ number. The result of query
is similar to following table:

emp_no cnt
10004 1
10005 1
10007 1
10009 2
...

### 2.10 Problem 10, 2 points

Find out those pairs of employees (eH, eL) which satisfy ALL following condi-
tions:

1. BotheHandeLborn in 1965


2.eH’s current salary is higher thaneL’s current salary


3.eH’s hiring date is greater thaneL, which meanseHis a newer employee
thaneL.

Sort the result by employee number ofeH then employee number ofel.
Result is shown as table below:


h_empno h_salary h_date l_empno l_salary l_date
10095 80955 1986-07-15 17206 55078 1986-02-
10095 80955 1986-07-15 18617 66957 1986-06-
...

- hempno :eH’s employee number
- hsalary :eH’s current salary
- hdate :eH’s hire date
- lempno :eL’s employee number
- lsalary :eL’s current salary
- ldate :eL’s hire date

### 2.11 Problem 11, 2 points

Find the employee with highest current salary in each department. Note that
MAX function is not allowed. Sort the result by department name. Result is
shown as table below:

dept_name emp_no salary
Customer Service 18006 144866
Development 13386 144434
...

### 2.12 Problem 12, 2 points

Calculate the percentage of number of employees’ current salary is above the
department current avarage. Sort the result by department name. The result
is shown as following:

dept_name above_avg_pect
Customer Service 44.
Development 46.
...

As the figure shows, there are 51.9825 % employees in Development department
has their current salary above the average of current salary in Development
department.

### 2.13 Problem 13, 3 points

Assuming a title is a node and a promotion is an edge between nodes. e.g.
And promotion from Engineer to Senior Engineer means their is a path from
Node ’Engineer’ to Node ’Senior Engineer’. Find out pairs of node of source
and destination (src, dst) which there is no such path in the database. Sort the
result by src then dst. The result is shown as following:


src dst
Assistant Engineer Assistant Engineer
Engineer Assistant Engineer
...

The result table shows that there is no path from Assistant Engineer to Assistant
Engineer and neither Engineer to Assistant Engineer. That means there is no
one have been from Engineer and be promoted/demoted to Assistant Engineer
(no matter how many times of promotion/demotion) in the database.

### 2.14 Problem 14, 3 points

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
Sort the result by src then dst. The expected result is shown as follow:

src dst years
Assistant Engineer Engineer 7.
Assistant Engineer Manager 20.
...
Engineer Manager 12.
...

As the table shows, the average distance between node ”Assistant Engineer” and
node ”Engineer” is 7.7926. We add it with the distance between ”Engineer”
to ”Manager”, which is 12.7340, to find out the distance between ”Assistant
Engineer” to ”Manager” is 20.5266.

## 3 Offline Grader

Before downloading and using the offline grader, please pay attention to follow-
ing points:

1. The grader strictly compares the EXACTLY same result and order men-
    tioned in each problem statement.
2. The grader checks DB state on start, make sure the DB state is same as
    the state which is immediately after importing the employees database.


3. The grader takes the query run time into account, you might get partial
    or no point if the query is running too slow.
4. The score is unofficial, we will run the grader with your submission after
    project due date as the official score.

The grader only supports Windows and Mac operating system. After down-
loading the zip file, follow the instructions according to the platform.

### 3.1 Windows

1. Make sure mysql server is running on localhost.
2. Decompress the zip file, the result is a directory namedproj2-grader-win
3. Edit theproj2.cfg, set the user and password for the mysql server connec-
    tion.
4. Launch a console such as cmd or powershell, change the working directory
    toproj2-grader-win
5. Executeproj2test.exefrom console, the result should be a pass on initial
    state verification and failed on all questions.
6. Write your answer in the files inquizdirectory, each question has one file.
    e.g., writing the answer for problem 1 inq1.sql
7. Runproj2test.exeagain, grader will show the scores.

### 3.2 Mac OS X

1. Make sure Python 3 is installed at /usr/local/bin/python
2. Make sure mysql server is running on localhost.
3. Decompress the zip file, the result is a directory namedproj2test.app
4. Launch a console, change the working directory toproj2test.app/Contents/Resources.
5. Edit theproj2.cfg, set the user and password for the mysql server connec-
    tion.
6. Change the working directory toproj2test.app/Contents/MacOS
7. Executeproj2testfrom console, the result should be a pass on initial state
    verification and failed on all questions.
8. Write your answer in the files inproj2test.app/Contents/Resources/quiz
    directory, each question has one file. e.g., writing the answer for problem
    1 inq1.sql
9. Runproj2testagain, grader will show the scores.


## 4 Submission

Failure to comply with the submission specifications will incur penalties for
EACH violation.

- What to submit: A zip file has to be submitted through the ‘submitcse460’
    (if you are CSE460 student) or ‘submitcse560’ (if you are CSE560 stu-
    dent) submit script by 04/21/2020 11:59PM EST. Only zip extension will
    be accepted, pleasedon’tuse any other compression methods such as tar
    or 7zip. You can submit multiple times, note thatonlythe last submission
    will be kept on the server.
- Zip file naming: Useubitproj2(NO SPACE!) for the filename, for exam-
    ple:jsmithproj2.zip, wherejsmithis the ubit of submitter. The project
    is anINDIVIDUALproject, so everyone needs to submit ONE zip file.
- Sub-structure of zip file: On unzipping the zip file, there should be a folder
    named with your ubitubitproj2, under the folderubitproj2, there should
    be 14 SQL files, starting fromq1.sql,q2.sql... ,q14.sqlwhich correspond
    to SQL query for each problem.
