-- Creating tables for PH-EmployeeDB
CREATE TABLE departments (
     dept_no VARCHAR(4) NOT NULL,
     dept_name VARCHAR(40) NOT NULL,
     PRIMARY KEY (dept_no),
     UNIQUE (dept_name)
);

CREATE TABLE employees (
	 emp_no INT NOT NULL,
     birth_date DATE NOT NULL,
     first_name VARCHAR NOT NULL,
     last_name VARCHAR NOT NULL,
     gender VARCHAR NOT NULL,
     hire_date DATE NOT NULL,
     PRIMARY KEY (emp_no)
);


CREATE TABLE dept_manager (
	dept_no VARCHAR(4) NOT NULL,
	emp_no INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no)
);

CREATE TABLE titles (
  emp_no INT NOT NULL,
  title VARCHAR NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no, title, from_date)
);

CREATE TABLE dept_emp (
  emp_no INT NOT NULL,
  dept_no VARCHAR(4) NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
  PRIMARY KEY (emp_no, dept_no)
);

COMMIT;

SELECT * FROM titles

SELECT * FROM departments

SELECT * FROM employees

SELECT * FROM dept_emp

SELECT * FROM dept_manager

SELECT * FROM salaries


SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31';

-- Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');


-- Retirement eligibility
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31')


SELECT * FROM retirement_info;

DROP TABLE retirement_info;

-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;

-- Joining departments and dept_manager tables
SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;

-- Joining retirement_info and dept_emp tables
SELECT retirement_info.emp_no,
	retirement_info.first_name,
retirement_info.last_name,
	dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;

SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');


Select * from current_emp;

-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

select * from current_emp;

SELECT * FROM salaries
ORDER BY to_date DESC;

SELECT e.emp_no, e.first_name, e.last_name, e.gender, s.salary, de.to_date
INTO ret_emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (de.to_date = '9999-01-01');

-- List of managers per department
SELECT  dm.dept_no, d.dept_name, dm.emp_no, ce.last_name, ce.first_name, dm.from_date, dm.to_date
INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);
		
SELECT ce.emp_no, ce.first_name, ce.last_name, d.dept_name	
-- INTO dept_info
FROM current_emp as ce
INNER JOIN dept_emp AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no);


SELECT e.emp_no, e.first_name, e.last_name, d.dept_name
INTO sales_info
FROM employees as e
INNER JOIN Dept_Emp as de
ON (e.emp_no = de.emp_no)
INNER JOIN Departments as d
ON (de.dept_no = d.dept_no)
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (de.to_date = '9999-01-01')
AND (d.dept_name = 'Sales');

select * from sales_info

SELECT e.emp_no, e.first_name, e.last_name, d.dept_name
INTO mentors_info
FROM employees as e
INNER JOIN Dept_Emp as de
ON (e.emp_no = de.emp_no)
INNER JOIN Departments as d
ON (de.dept_no = d.dept_no)
WHERE d.dept_name IN ('Sales', 'Development')
AND (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (de.to_date = '9999-01-01');

select * from mentors_info


--------------------------------------------------------------------

--TECHNICAL ANALYSIS DELIVERABLE 1.1
--NUMBER OF TITLES RETIRING
SELECT COUNT(ti.title), ti.title
INTO NUMBER_TITLES_RETIRING
FROM ret_emp_info as rei
INNER JOIN titles as ti
ON (rei.emp_no = ti.emp_no)
GROUP BY ti.title
ORDER BY COUNT;

--NUMBER OF TITLES RETIRING
SELECT * FROM NUMBER_TITLES_RETIRING

--NUMBER OF TITLES RETIRING
SELECT COUNT(title)
FROM NUMBER_TITLES_RETIRING;
---------------------------------------------------------------------

--TECHNICAL ANALYSIS DELIVERABLE 1.2
--NUMBER OF CURRENT EMPLOYEES WITH EACH TITLE
SELECT COUNT(e.emp_no), ti.title
INTO NUMBER_EMP_TITLES
FROM employees as e
INNER JOIN titles as ti
ON (e.emp_no = ti.emp_no)
INNER JOIN dept_emp as de
ON e.emp_no = de.emp_no
AND (de.to_date = '9999-01-01')
GROUP BY ti.title
ORDER BY COUNT;

--NUMBER OF EMPLOYEES WITH EACH TITLES
SELECT * FROM NUMBER_EMP_TITLES;

---------------------------------------------------------------------------

--TECHNICAL ANALYSIS DELIVERABLE 1.3
--QUERY LIST OF CURRENT EMPLOYEES BORN BETWEEN JAN 1, 1952 AND DEC 31, 1955

--CREATING A TABLE WITH EMPLOYEES RETIRING WITH THEIR TITLES AND SALARIES
SELECT e.emp_no, ti.title, ti.from_date, s.salary,
--COMBINING FIRST NAMES AND LAST NAMES OF EMPLOYEES INTO FULL NAME
e.first_name || ' ' || e.last_name AS FULLNAME
INTO retiring_emp_with_title
FROM employees as e
INNER JOIN titles as ti
ON (e.emp_no = ti.emp_no)
INNER JOIN Salaries as s
ON (e.emp_no = s.emp_no)
--This additional inner join ensures that the employee is currently employed
--The to_date from salaries and to_date from dept_emp is not the same
INNER JOIN dept_emp as de
ON (e.emp_no= de.emp_no)
AND (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (de.to_date = '9999-01-01');

--RETIRING EMPLOYEES WITH THEIR TITLES
SELECT * FROM retiring_emp_with_title

--NUMBER OF RETIRING EMPLOYEES WITH TITLES
SELECT COUNT(emp_no)
FROM retiring_emp_with_title;

--CHECKING DUPLICATES BASED ON EMPLOYEE NUMBER
SELECT * FROM
  (SELECT *, count(*)
   OVER
    (PARTITION BY emp_no)
    AS count
  FROM retiring_emp_with_title) tableWithCount
  WHERE tableWithCount.count > 1;

--PARTITION THE DATE TO SHOW ONLY THE MOST RECENT TITLE PER EMPLOYEE
SELECT emp_no, fullname, from_date, salary, title
INTO retiring_employees
FROM (SELECT emp_no, fullname, from_date, salary, title,
  ROW_NUMBER() OVER
 (PARTITION BY (emp_no) ORDER BY from_date DESC) RN
 FROM retiring_emp_with_title) tmp WHERE RN = 1
ORDER BY emp_no;
	 
--LIST OF CURRENT EMPLOYEES BORN BETWEEN JAN 1, 1952 TO DEC 31, 1955
SELECT* FROM retiring_employees

--NUMBER OF RETIRING EMPLOYEES
SELECT COUNT(emp_no)
FROM retiring_employees;

--RE-CHECKING DUPLICATES BASED ON EMPLOYEE NUMBER
SELECT * FROM
  (SELECT *, count(*)
   OVER
    (PARTITION BY emp_no)
    AS count
  FROM retiring_employees) tableWithCount
  WHERE tableWithCount.count > 1;
--NO DUPLICATES FOUND WHICH IS GOOD
--------------------------------------------------------------------

--Technical Analysis Deliverable 2
--MENTORSHIP ELIGIBILITY
--CREATING A TABLE WITH EMPLOYEES SUITABLE FOR MENTORSHIP
--The table indicates the titles that each eligible employee held and the duration of the title
SELECT e.emp_no, ti.title,
--COMBINING FIRST NAMES AND LAST NAMES OF EMPLOYEES INTO FULL NAME
e.first_name || ' ' || e.last_name AS FULLNAME,
--COMBINING FROM DATE AND TO DATE INTO A SINGLE COLUMN
ti.from_date || ' and ' || ti.to_date AS FROM_DATE_AND_To_DATE
INTO mentors_with_title
FROM employees as e
INNER JOIN titles as ti
ON (e.emp_no = ti.emp_no)
INNER JOIN Dept_Emp as de
ON (e.emp_no = de.emp_no)
AND (birth_date BETWEEN '1965-01-01' AND '1965-12-31')
AND (de.to_date = '9999-01-01');

--Checking duplicates based on mentors and their titles
-- Each mentor may have held different titles during their career
SELECT * FROM
  (SELECT *, count(*)
   OVER
    (PARTITION BY emp_no)
    AS count
  FROM mentors_with_title) tableWithCount
  WHERE tableWithCount.count > 1;
  
SELECT * FROM mentors_with_title

-- Number of mentors_with_title
SELECT COUNT(FULLNAME)
FROM mentors_with_title;

-- Partition the data to show only most recent title per mentor to get actual number of mentors
SELECT emp_no, fullname, title, from_date_and_to_date
INTO mentors_total
FROM (SELECT emp_no, fullname, title, from_date_and_to_date,
  ROW_NUMBER() OVER
 (PARTITION BY (emp_no) ORDER BY from_date_and_to_date DESC) RN
 FROM mentors_with_title) tmp WHERE RN = 1
ORDER BY emp_no;

SELECT * FROM MENTORS_TOTAL

-- Number of mentors
SELECT COUNT(FULLNAME)
FROM MENTORS_TOTAL;

-----------------------------------------------------------------------------------------------------