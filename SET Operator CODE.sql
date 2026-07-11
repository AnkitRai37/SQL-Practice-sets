CREATE TABLE Employees_2024 (

    emp_id INT,

    emp_name VARCHAR(50),

    department VARCHAR(30),

    salary INT,

    city VARCHAR(30)

)

INSERT INTO Employees_2024 VALUES

(101,'Amit','HR',45000,'Delhi'),

(102,'Priya','IT',70000,'Mumbai'),

(103,'Rahul','Finance',55000,'Lucknow'),

(104,'Sneha','Sales',48000,'Pune'),

(105,'Karan','IT',72000,'Delhi'),

(106,'Neha','Marketing',50000,'Jaipur'),

(107,'Rohit','HR',47000,'Lucknow'),

(108,'Anjali','Finance',60000,'Delhi'),

(109,'Vikas','Sales',52000,'Mumbai'),

(110,'Pooja','IT',68000,'Pune')


CREATE TABLE Employees_2025 (

    emp_id INT,

    emp_name VARCHAR(50),

    department VARCHAR(30),

    salary INT,

    city VARCHAR(30)
)   


INSERT INTO Employees_2025 VALUES

(105,'Karan','IT',72000,'Delhi'),

(106,'Neha','Marketing',50000,'Jaipur'),

(107,'Rohit','HR',47000,'Lucknow'),

(108,'Anjali','Finance',60000,'Delhi'),

(109,'Vikas','Sales',52000,'Mumbai'),

(110,'Pooja','IT',68000,'Pune'),

(111,'Meera','Finance',65000,'Lucknow'),

(112,'Arjun','IT',73000,'Bangalore'),

(113,'Riya','HR',46000,'Delhi'),

(114,'Mohit','Sales',51000,'Mumbai')


select emp_name from Employees_2024
union all
select emp_name from Employees_2025


select emp_name from Employees_2024
union 
select emp_name from Employees_2025



select city from Employees_2024
union 
select city from Employees_2025



select department from Employees_2024
union all
select department from Employees_2025


select salary from Employees_2024
union  all                     
select salary from Employees_2025


select salary from Employees_2024
union                      
select salary from Employees_2025


select emp_name from Employees_2024
INTERSECT                     
select emp_name from Employees_2025


select emp_name from Employees_2024
except                     
select emp_name from Employees_2025

OR

select emp_name from Employees_2025
except                     
select emp_name from Employees_2024


select emp_name from Employees_2025
intersect                     
select emp_name from Employees_2024


select department from Employees_2024
intersect                    
select department from Employees_2025


select city from Employees_2024
intersect                    
select city from Employees_2025



select emp_id, emp_name  from Employees_2024
union  all                 
select emp_id, emp_name from Employees_2025


select department from Employees_2024
union                    
select department from Employees_2025



select city from Employees_2024
except                    
select city from Employees_2025



select emp_name from Employees_2024
union                    
select emp_name from Employees_2025
order by emp_name asc



select salary from Employees_2024
intersect                    
select salary from Employees_2025


select emp_name from Employees_2024
union 
select emp_name from Employees_2025
where department = 'IT'


select department from Employees_2024
except                
select department from Employees_2025


select emp_name, salary from Employees_2025
where salary > 60000
except                   
select emp_name, salary from Employees_2024
where salary > 60000


select emp_name, salary, 2024 as year from Employees_2024
union                    
select emp_name, salary, 2025 as year from Employees_2025



select emp_id, emp_name, department from Employees_2024
intersect              
select emp_id, emp_name, department from Employees_2025




Display the names of all employees from both years using UNION ALL.
Display the unique employee names from both years using UNION.
Display all cities where employees worked in either year without duplicates.
Show every department appearing in both tables, including duplicates.
Display all salaries from both tables:
First with duplicates
Then without duplicates
Find employees who worked in both 2024 and 2025 using INTERSECT.
Find employees who worked only in 2024 using EXCEPT.
Find employees who joined in 2025 only.
Find departments present in both years.
Find cities that appear in both years.
Display employee IDs and names that exist in either year.
Display all employee names from both tables in alphabetical order.
Find all unique departments across both years.
Find cities that exist in 2024 but not in 2025.
Find salaries that are common in both tables.
Find employees who are present in both years and belong to the IT department.
Find departments that disappeared in 2025.
Find employees who are new in 2025 and have a salary greater than 60,000.
Display all employees from both tables with an additional column named year indicating whether the record is from 2024 or 2025.
Find employees who are common in both years, displaying only emp_id, emp_name, and department.
