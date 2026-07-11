CREATE TABLE employees (

    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    dept_id INT,
    man_id INT,
    salary INT,
    join_date DATE

)


INSERT INTO employees VALUES

(1,'Amit',10,NULL,90000,'2020-01-10'),
(2,'Ravi',10,1,60000,'2021-03-15'),
(3,'Neha',20,NULL,85000,'2019-07-20'),
(4,'Priya',20,3,70000,'2022-02-12'),
(5,'Arjun',30,NULL,95000,'2018-11-05'),
(6,'Meera',30,5,65000,'2021-09-10'),
(7,'Kunal',10,1,55000,'2023-04-18'),
(8,'Divya',20,3,72000,'2024-01-25')

CREATE TABLE departments (

dept_id INT PRIMARY KEY,
dept_name VARCHAR(50)

);


INSERT INTO departments VALUES

(10,'IT'),
(20,'HR'),
(30,'Finance')

CREATE TABLE customers (

cust_id INT PRIMARY KEY,
cust_name VARCHAR(50),
city VARCHAR(50)

);


INSERT INTO customers VALUES

(101,'Rahul','Delhi'),
(102,'Sneha','Mumbai'),
(103,'Karan','Pune'),
(104,'Anita','Delhi');

CREATE TABLE orders (

order_id INT PRIMARY KEY,
cust_id INT,
order_date DATE,
amount INT

);


INSERT INTO orders VALUES

(1,101,'2026-01-01',5000),
(2,102,'2026-01-03',7000),
(3,101,'2026-01-05',3000),
(4,103,'2026-01-07',9000),
(5,104,'2026-01-10',4000),
(6,102,'2026-01-12',8000),
(7,103,'2026-01-15',6000);

CREATE TABLE products (

prod_id INT PRIMARY KEY,
prod_name VARCHAR(50),
category VARCHAR(50),
price INT

);


INSERT INTO products VALUES

(1,'Laptop','Electronics',60000),
(2,'Phone','Electronics',30000),
(3,'Chair','Furniture',8000),
(4,'Desk','Furniture',15000),
(5,'Tablet','Electronics',25000);

with emp_salary as
(
select emp_id, emp_name, salary
from employees
where salary > 70000
)
select emp_id, emp_name, salary
from emp_salary


with avg_salary as
(
select emp_id,  emp_name, avg(salary) as avg_emp_salary
from employees
group by emp_id
)
select *
from avg_salary

with total_emp as
(
select count(emp_id) as countemp, dept_id
from employees
group by dept_id
)
select * from total_emp

with high_salary as
(
select emp_name, max(salary) as max_sal_emp
from employees
group by emp_id
order by salary desc
)
select *
from high_salary

WITH total_sales AS
(
    SELECT SUM(amount) AS total_amount
    FROM orders
)

SELECT *
FROM total_sales;

WITH emp_data AS
(
    SELECT emp_name,
           dept_id,
           salary
    FROM employees
)

SELECT
    e.emp_name,
    d.dept_name,
    e.salary
FROM emp_data e
JOIN departments d
ON e.dept_id = d.dept_id;

WITH delhi_customers AS
(
    SELECT *
    FROM customers
    WHERE city = 'Delhi'
)
SELECT
    c.cust_name,
    o.order_id,
    o.order_date,
    o.amount
FROM delhi_customers c
JOIN orders o
ON c.cust_id = o.cust_id;


WITH dept_avg AS
(
    SELECT
        dept_id,
        AVG(salary) AS avg_salary
    FROM employees
    GROUP BY dept_id
)
SELECT
    e.emp_name,
    e.salary,
    d.avg_salary
FROM employees e
JOIN dept_avg d
ON e.dept_id = d.dept_id
WHERE e.salary > d.avg_salary;

with total_sales_per_customer as
(
select cust_id, sum(amount) 
as total_purchase
from orders 
group by cust_id
)
select c.cust_name, tspc.total_purchase
from customers c
join total_sales_per_customer as tspc
on c.cust_id = tspc.cust_id

with dept_high_avg_sal as
(
select dept_id, avg(salary) as dept_avg_salary
from employees 
group by dept_id
)
select d.dept_name , dh.dept_avg_salary
from departments d
join dept_high_avg_sal as dh
on d.dept_id = dh.dept_id

with ttotal_monthly_sales as
(
select to_char(order_date, 'month') as month_from_order,
sum(amount) as total_sales
from orders
group by to_char(order_date, 'month')
)
select * from ttotal_monthly_sales

with emp_sal_rank as
(
select emp_name, salary, dept_id,
rank() over(partition by dept_id order by salary desc) as rank
from employees
)
select * from emp_sal_rank

with avg_cust_spent as
(
select cust_id, sum(amount) as total_spent
from orders
group by cust_id
)
select c.cust_name, acs.total_spent
from customers c 
join avg_cust_spent as acs
on c.cust_id = acs.cust_id
where acs.total_spent >
(
select avg(total_spent) 
from avg_cust_spent
)

with sec_high_sal as
(
select emp_id, emp_name, dept_id, salary,
rank() over(partition by dept_id order by salary desc) as emp_rank
from employees
)
select * from sec_high_sal
where emp_rank = 2


with dept_payroll as
(
select dept_id, sum(salary) as total_salary
from employees
group by dept_id
),
max_dept_payroll as (
select dept_id, total_salary
from dept_payroll
where total_salary = 
(select max(total_salary) as dept_max_sal
from dept_payroll))
select d.dept_name, m.total_salary
from departments d 
join max_dept_payroll m on d.dept_id = m.dept_id


with dept_max_sal as 
(
select dept_id, emp_name, salary, 
rank() over(partition by dept_id order by salary desc) as sal_rank
from employees
)
select * from dept_max_sal dms
join departments d 
on d.dept_id = dms.dept_id
where dms.sal_rank <= 3
order by d.dept_name, dms.sal_rank 


________________________for ques 17, you need to create the
                        new table and relation between product
						and order_named as order_item_________


CREATE TABLE order_items (
    order_id INT,
    prod_id INT,
    quantity INT,
    PRIMARY KEY (order_id, prod_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (prod_id) REFERENCES products(prod_id)
)


INSERT INTO order_items VALUES
(1,1,1),  -- Rahul bought Laptop (Electronics)
(2,2,1),  -- Sneha bought Phone (Electronics)
(3,3,2),  -- Rahul bought Chairs (Furniture)
(4,5,1),  -- Karan bought Tablet (Electronics)
(5,4,1),  -- Anita bought Desk (Furniture)
(6,2,1),  -- Sneha bought Phone (Electronics)
(7,3,1);  -- Karan bought Chair (Furniture)		


with customer_order as
(
select distinct cust_id
from orders
),
electronic_customer as
(
select distinct o.cust_id
from orders o 
join order_items oi
on o.order_id = oi.order_id
join products p
on oi.prod_id = p.prod_id
where p.category = 'Electronics'
)
select c.cust_id, c.cust_name
from customers c 
join customer_order co
on c.cust_id = co.cust_id
where c.cust_id not in ( select cust_id from electronic_customer)


with recursive numbers as 
(
    -- Anchor member: start with 1
    select 1 as n
    union all
    -- Recursive member: keep adding 1 until 20
    select n + 1
    from numbers
    where n < 20
)
select n
from numbers;


with dept_avg as
(
select dept_id, avg(salary) as dept_avg_sal
from employees
group by dept_id
)
, emp_with_avg as 
(
select e.emp_name, d.dept_name, e.salary,
da.dept_avg_sal
from employees e
join departments d 
on e.dept_id = d.dept_id
join dept_avg da
on e.dept_id = da.dept_id
)
select emp_name, dept_name, salary,
dept_avg_sal,
(salary - dept_avg_sal) as salary_difference
from emp_with_avg
order by dept_name, emp_name





















🟢 Beginner Level (1–7)
Create a CTE to display all employees having salary greater than 70000.
 
Using a CTE, find the average salary of all employees.

Create a CTE that shows total employees in each department.
Expected: department_id | employee_count

Use a CTE to find the highest salary employee.

Create a CTE to calculate total sales from orders.

Using a CTE and JOIN, display: employee_name, department_name, salary.

Create a CTE that filters customers from Delhi and display their orders.

🟡 Intermediate Level (8–14)
Using CTE, find employees earning above their department average salary.
Hint: Step 1: Calculate department average; Step 2: Compare employee salary.

Create a CTE to find total sales per customer.
Output: customer_name | total_purchase

Using CTE, find the department with the highest average salary.

Create a CTE to calculate monthly sales.
Output: month | total_sales

Using CTE + Window Function, rank employees by salary inside each department.
Output: emp_name | salary | rank

Using CTE, find customers who spent more than average customer spending.

Create a CTE to find the second highest salary.

🔴 Advanced Interview Level (15–20)
Using multiple CTEs: Find the top-performing department based on total employee salary.
Steps:

CTE 1: Calculate department payroll

CTE 2: Find maximum payroll department

Using CTE + Window Function: Find top 3 highest-paid employees from each department.
Output: department | employee | salary | rank

Using CTE: Find customers who placed orders but never purchased Electronics products.

Create a recursive CTE to generate numbers from 1 to 20.

Using multiple CTEs: Create an employee salary report.
Output: employee_name | department | salary | department_average_salary | salary_difference

(Real Interview Question ⭐) You have employee hierarchy:
Amit → Ravi → Kunal
Using Recursive CTE find: Employee | Manager | Level
Example: Amit NULL 1; Ravi Amit 2; Kunal Ravi 3



with recursive emp_hierarchy as 
(
select emp_id, emp_name as employee,
man_id, null::VARCHAR as manager,
1 as level
from employees
where man_id is null
union all
select e.emp_id, e.emp_name, e.man_id,
eh.employee as manager, 
eh.level + 1 as level
from employees e
join emp_hierarchy eh
on e.man_id = eh.emp_id
)
select employee, manager, level
from emp_hierarchy
order by level;



