CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    department_id INT,
    department_name VARCHAR(50),
    job_title VARCHAR(100),
    salary NUMERIC(10,2),
    hire_date DATE,
    city VARCHAR(50),
    status VARCHAR(20)
)

select * from employees

insert into employees
values
(1001,'Ankit','Sharma','ankit.sharma1001@company.com',30,'IT','Data Analyst',65000,'2022-05-18','Lucknow','Active'),
(1002,'Priya','Gupta','priya.gupta1002@company.com',20,'Finance','Accountant',58000,'2021-11-07','Delhi','Active'),
(1003,'Rahul','Verma','rahul.verma1003@company.com',40,'Sales','Sales Executive',47000,'2020-08-15','Noida','Active'),
(1004,'Sneha','Patel','sneha.patel1004@company.com',30,'IT','SQL Developer',72000,'2023-01-10','Pune','Active'),
(1005,'Amit','Kumar','amit.kumar1005@company.com',10,'HR','HR Executive',51000,'2019-06-25','Lucknow','Inactive'),
(1006,'Riya','Singh','riya.singh1006@company.com',80,'Analytics','Business Analyst',81000,'2022-09-12','Mumbai','Active'),
(1007,'Vikas','Rai','vikas.rai1007@company.com',60,'Operations','Manager',96000,'2018-12-01','Kanpur','Active'),
(1008,'Pooja','Mishra','pooja.mishra1008@company.com',70,'Support','Support Engineer',54000,'2021-03-19','Bhopal','Active'),
(1009,'Karan','Jain','karan.jain1009@company.com',30,'IT','Data Engineer',92000,'2020-11-22','Delhi','Active'),
(1010,'Neha','Yadav','neha.yadav1010@company.com',50,'Marketing','Marketing Executive',56000,'2024-02-05','Jaipur','Active')


select * from employees

-- Q1: B-Tree Index on salary
-- Before creating index: run EXPLAIN ANALYZE
EXPLAIN ANALYZE SELECT * FROM employees WHERE salary > 70000;

-- Create index
CREATE INDEX idx_salary ON employees(salary);

-- After creating index: run EXPLAIN ANALYZE
EXPLAIN ANALYZE SELECT * FROM employees WHERE salary > 70000;


-- Q2: B-Tree Index on hire_date
EXPLAIN ANALYZE SELECT * FROM employees WHERE hire_date > '2022-01-01';

CREATE INDEX idx_hire_date ON employees(hire_date);

EXPLAIN ANALYZE SELECT * FROM employees WHERE hire_date > '2022-01-01';


-- Q3: Unique Index on email
CREATE UNIQUE INDEX idx_email_unique ON employees(email);

-- Try inserting duplicate email
INSERT INTO employees (employee_id, name, email, department_id, salary)
VALUES (999, 'Test User', 'existing_email@company.com', 10, 50000);
-- This will throw error if email already exists


-- Q4: Find employee by email
EXPLAIN ANALYZE
SELECT * FROM employees WHERE email = 'existing_email@company.com';


-- Q5: Drop index on hire_date
DROP INDEX idx_hire_date;


-- Q6: Composite Index on (department_id, salary)
CREATE INDEX idx_dept_salary ON employees(department_id, salary);

EXPLAIN ANALYZE
SELECT * FROM employees WHERE department_id = 30 AND salary > 80000;


-- Q7: Query filtering only by salary after composite index
EXPLAIN ANALYZE
SELECT * FROM employees WHERE salary > 80000;
-- Observation: PostgreSQL usually does NOT use composite index here,
-- because leading column department_id is missing.


-- Q8: Partial Index for status = 'Active'
CREATE INDEX idx_status_active ON employees(status) WHERE status = 'Active';


-- Q9: Retrieve active employees
EXPLAIN ANALYZE
SELECT * FROM employees WHERE status = 'Active';


-- Q10: Retrieve inactive employees
EXPLAIN ANALYZE
SELECT * FROM employees WHERE status = 'Inactive';
-- Observation: partial index not used, because condition doesn’t match.


-- Q11: Expression (Functional) Index on LOWER(email)
CREATE INDEX idx_email_lower ON employees(LOWER(email));

EXPLAIN ANALYZE
SELECT * FROM employees WHERE LOWER(email) = LOWER('Priya.Gupta1002@Company.com');


-- Q12: Index on department_id + Composite index on (department_id, salary)
CREATE INDEX idx_dept ON employees(department_id);

-- Already created composite index in Q6: idx_dept_salary

-- Query using only department_id
EXPLAIN ANALYZE
SELECT * FROM employees WHERE department_id = 30;

-- Query using both department_id and salary
EXPLAIN ANALYZE
SELECT * FROM employees WHERE department_id = 30 AND salary > 70000;


Q-13
-- Before functional index
EXPLAIN ANALYZE
SELECT * FROM employees WHERE email = 'ankit.sharma1001@company.com';

EXPLAIN ANALYZE
SELECT * FROM employees WHERE LOWER(email) = 'ankit.sharma1001@company.com';

-- Create functional index
CREATE INDEX idx_lower_email ON employees(LOWER(email));

-- After functional index
EXPLAIN ANALYZE
SELECT * FROM employees WHERE LOWER(email) = 'ankit.sharma1001@company.com';

Q-14
-- Before index
EXPLAIN ANALYZE
SELECT * FROM employees WHERE salary > 60000;

-- Create index
CREATE INDEX idx_salary ON employees(salary);

-- After index
EXPLAIN ANALYZE
SELECT * FROM employees WHERE salary > 60000;

Q-15
CREATE INDEX idx_city ON employees(city);

EXPLAIN ANALYZE
SELECT * FROM employees WHERE city = 'Lucknow';

Q-16
CREATE INDEX idx_job_title ON employees(job_title);

EXPLAIN ANALYZE
SELECT * FROM employees WHERE job_title = 'Data Analyst';

Q-17
CREATE INDEX idx_city_dept ON employees(city, department_id);

EXPLAIN ANALYZE
SELECT * FROM employees
WHERE city = 'Delhi' AND department_id = 30;

Q-18
CREATE INDEX idx_dept_status_salary
ON employees(department_id, status, salary);

Q-19
---Decide which columns should have an index

-----employee_id → ✅ Already primary key (unique index).

---email → ✅ Unique index (enforces uniqueness, fast lookups).

---department_id → ✅ Useful for joins and filtering.

---salary → ✅ Useful for range queries.

---status → ⚖️ Low cardinality (Active/Inactive). Index only if queried often.

---city → ✅ Useful for location queries.

---job_title → ✅ Useful for role‑based queries.

---hire_date → ✅ Useful for time‑based queries (reporting, ranges).

Q-20
----Primary Key on employee_id → Automatically creates a Unique B‑Tree index.

Unique index on email → Ensures no duplicate emails, so it’s a Unique B‑Tree index.

Index on salary → Standard B‑Tree index for range queries.

Index on city → Standard B‑Tree index for filtering by location.

Index on job_title → Standard B‑Tree index for role‑based queries.

Composite index on (city, department_id) → Composite B‑Tree index covering two columns.

Composite index on (department_id, status, salary) → Another Composite B‑Tree index designed for frequent multi‑column searches.

Expression index on LOWER(email) → Expression index, because it’s built on a function rather than a raw column.

(Optional) Partial index if you created one like WHERE status = 'Inactive' → that would be a Partial index.------
--------------------------------------------------------------------------------------------------------------

---------20 - QUESTIONS ------

📘 Index Practice Questions (Easy → Hard)
Create a B-Tree Index on the salary column and retrieve all employees whose salary is greater than 70,000. Compare the execution plan before and after creating the index using EXPLAIN ANALYZE.
Create a B-Tree Index on the hire_date column and retrieve all employees hired after 2022-01-01. Compare the execution plan before and after creating the index.
Create a Unique Index on the email column. Then try inserting a new employee with an email address that already exists and observe the result.
Find an employee using their email address and verify whether PostgreSQL uses the index.
Drop the index created on the hire_date column.
Create a Composite Index on (department_id, salary) and retrieve employees whose department_id = 30 and salary > 80,000. Check the execution plan.
Run a query filtering only by salary after creating the composite index. Does PostgreSQL use the composite index? Explain your observation.
Create a Partial Index for employees whose status = 'Active'.
Retrieve all active employees and verify whether PostgreSQL uses the partial index.
Retrieve inactive employees. Does PostgreSQL use the partial index? Explain why.
Create an Expression (Functional) Index on LOWER(email) and search for an employee using a case-insensitive email lookup.
Create both an index on department_id and a composite index on (department_id, salary). Run queries using only department_id and then using both department_id and salary. Observe which index PostgreSQL chooses.
Compare the execution plans of searching by email and searching by LOWER(email) before and after creating the functional index.
Use EXPLAIN ANALYZE to compare a Full Table Scan and an Index Scan on the salary column. Compare the cost, number of rows, and execution time.
Create an index on the city column and retrieve employees from Lucknow. Check whether PostgreSQL uses the index.
Create an index on the job_title column and retrieve all employees whose job title is Data Analyst.
Create a composite index on (city, department_id) and retrieve employees from Delhi who belong to the IT department.
Determine which index you would create if users frequently search using department_id, status, and salary. Explain your choice.
Decide whether each of the following columns should have an index or not, and justify your answer: employee_id, email, department_id, salary, status, city, job_title, and hire_date.
List all indexes created on the employees table and identify the type of each index (B-Tree, Unique, Composite, Partial, or Expression).