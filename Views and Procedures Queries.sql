-- Customers
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(50),
    City VARCHAR(50),
    Status VARCHAR(20)
);

INSERT INTO Customers VALUES
(101, 'Ramesh', 'Lucknow', 'Active'),
(102, 'Priya', 'Delhi', 'Active'),
(103, 'Ankit', 'Lucknow', 'Inactive'),
(104, 'Neha', 'Mumbai', 'Active'),
(105, 'Suresh', 'Lucknow', 'Active');
drop table Customers

-- Employees
CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(50),
    Department VARCHAR(50),
    Salary DECIMAL(10,2),
    Status VARCHAR(20)
);

INSERT INTO Employees VALUES
(201, 'Amit', 'IT', 60000, 'Active'),
(202, 'Rohit', 'HR', 45000, 'Active'),
(203, 'Sneha', 'Finance', 70000, 'Active'),
(204, 'Meena', 'IT', 52000, 'Inactive'),
(205, 'Arjun', 'Sales', 48000, 'Active');


-- Products
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50),
    CategoryID INT,
    Price DECIMAL(10,2)
);

INSERT INTO Products VALUES
(301, 'Laptop', 1, 55000),
(302, 'Mouse', 1, 800),
(303, 'Chair', 2, 1500),
(304, 'Phone', 1, 25000),
(305, 'Desk', 2, 5000);


-- Orders
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    Amount DECIMAL(10,2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

INSERT INTO Orders VALUES
(401, 101, '2025-01-15', 60000),
(402, 102, '2025-03-20', 25000),
(403, 105, '2024-11-05', 1500),
(404, 104, '2025-07-10', 5000),
(405, 103, '2025-09-12', 800);


-- OrderDetails
CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    UnitPrice DECIMAL(10,2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO OrderDetails VALUES
(501, 401, 301, 1, 55000),
(502, 401, 302, 2, 800),
(503, 402, 304, 1, 25000),
(504, 403, 303, 1, 1500),
(505, 404, 305, 1, 5000),
(506, 405, 302, 1, 800);

drop view all_customers

create or replace view all_customers as
select * from Customers 
where City = 'Lucknow'
select * from all_customers


create view Emp_active as
select * from Employees
where Status = 'Active'
select * from Emp_active


create view Prod_price as
select * from Products
where Price > 5000
select * from Prod_price


create procedure add_customer(in P_CustomerID int,in P_Name text, in P_City text,in  P_Status text)
language plpgsql
as $$
begin
insert into Customers ( CustomerID,  Name, City,  Status)
values (P_CustomerID, P_Name, P_City, P_Status);
end;
$$;
 CALL add_customer(107, 'Amit', 'Amritsar', 'Inactive');

DROP PROCEDURE add_customer


create procedure update_status (in P_CustomerID int, in P_Status text)
language plpgsql
as $$
begin
update Customers
set Status =p_status
where CustomerID = p_customerid;
end;
$$;
DROP PROCEDURE update_status
call update_status(101, 'Inactive')


create view Customer_order as
select c.CustomerID, c.Name, o.OrderID
from Customers c join orders o
on c.CustomerID = o.CustomerID
select * from Customer_order


create view each_dept_count_emp as
select EmpID,count(EmpID) as no_of_Customer, Empname, Department
from Employees
group by EmpID
select * from each_dept_count_emp


create view product_with_category_id as
select ProductID, ProductName, CategoryID
from Products
where CategoryID = 1
select * from product_with_category_id

 
create procedure add_emp (in p_empId int,in p_empName text,in p_dept text,in p_salary int ,in p_status text)
language plpgsql
as $$
Begin
insert into Employees( EmpId, EmpName, Department, Salary, Status)
values( p_empId ,p_empName , p_dept ,p_salary , p_status );
end;
$$;
call add_emp (214, 'Atul Singh', 'HR', 70000, 'Active')


create procedure productprice_by_productid (in p_Product_iD int, in p_Price int)
language plpgsql
as $$
begin
update Products
set Price = p_price
where ProductID = p_product_id;
end;
$$;
call productprice_by_productid(306, 3)
drop procedure productprice_by_productid


create view show_all_order as
select OrderID, OrderDate, extract(year from OrderDate) as year
from Orders
where extract(year from OrderDate)  = '2025'
select * from show_all_order
drop view show_all_order


create view product_with_sold_quantity as
select p.ProductID, p.ProductName, od.Quantity
from Products p join OrderDetails od
on p.ProductID = od.ProductID
select * from product_with_sold_quantity


create  view show_emp as
select Empid, EmpName, Department, Status
from Employees
where Department = 'IT' and Status = 'Active'
select * from show_emp


create  view show_emp_total_order_amount as
select c.CustomerID, c.Name, sum(o.Amount) as total_order_amount
from Customers c join orders o
on c.CustomerID = o.CustomerID
group by c.CustomerID
select * from show_emp_total_order_amount


create view emp_with_less_sal as
select EmpID, EmpName, Salary
from Employees
where Salary < 50000
select * from emp_with_less_sal


create procedure add_one_order (in p_orderId int,in p_CustomerID int,in p_orderDate Date,in p_amount int)
language plpgsql
as $$
begin
insert into orders (orderId, CustomerID, orderDate, amount)
values (p_orderId, p_CustomerID, p_orderDate, p_amount);
end;
$$;
call add_one_order(407, 107, '2025-05-05', 64000)  ^
drop procedure add_one_order


CREATE procedure Delete_customer (in p_CustomerID INT )
language plpgsql
as $$
begin
delete from  Customers
where CustomerID  =  P_CustomerID;
end;
$$;
call delete_customer(101)


create procedure update_emp_dept(in p_EmpId int,in p_Department text)
language plpgsql
as $$
begin
update  Employees
set EmpID = p_EmpID
where Department  =  P_Department;
end;
$$;
call update_emp_dept(208,'Finance' )


create procedure delete_orderdetail (in p_OrderDetailID int)
language plpgsql
as $$
begin
delete from OrderDetails
where OrderDetailID = p_orderdetailid;
end;
$$;
call delete_orderdetail(505)


create procedure add_newproduct (in p_ProductId int,in p_ProductName text,in p_CategoryId int,in p_Price int)
language plpgsql
as $$
begin
insert into Products(ProductID, ProductName, CategoryID, Price)
values(p_ProductId, p_ProductName, p_CategoryId, p_Price);
end;
$$;
call add_newproduct(306, 'Mobile', 3, 17000)
select * from Products



🟢 Basic (Views + Procedures)
View: Show all customers from Lucknow.

View: Show employees who are marked as Active.

View: Show products with price greater than 5,000.

Procedure: Insert a new customer into the Customers table (parameters: custId, name, city, status).

Procedure: Update a customer’s status to Inactive by CustomerID.

🟡 Intermediate (Views + Procedures)
View: Show customer names with their order IDs (join Customers + Orders).

View: Show each department and the count of employees in it.

View: Show products belonging to category 1 (IT products).

Procedure: Insert a new employee into the Employees table (parameters: empId, empName, dept, salary, status).

Procedure: Update product price by ProductID.

🔴 Advanced Views
View: Show all orders placed in 2025 (filter by year).

View: Show each product with its total quantity sold (join Products + OrderDetails).

View: Show employees in IT department who are Active.

View: Show customers and their total order amount (join Customers + Orders).

View: Show employees whose salary is less than 50,000.

🔴 Advanced Procedures
Procedure: Insert a new order into Orders (parameters: orderId, custId, orderDate, amount).

Procedure: Delete a customer by CustomerID.

Procedure: Update an employee’s department (parameters: empId, newDept).

Procedure: Delete an order detail by OrderDetailID.

Procedure: Insert a new product into Products (parameters: productId, productName, categoryId, price).