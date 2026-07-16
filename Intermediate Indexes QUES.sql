CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(120),
    product_name VARCHAR(100),
    category VARCHAR(50),
    quantity INT,
    unit_price NUMERIC(10,2),
    order_date DATE,
    delivery_date DATE,
    city VARCHAR(50),
    payment_method VARCHAR(30),
    order_status VARCHAR(20)
)
(1011,'Ayushman S')
INSERT INTO orders VALUES
(1001,'Ankit Rai','ankit.rai1001@gmail.com','Laptop','Electronics',1,65000,'2024-01-05','2024-01-09','Lucknow','UPI','Delivered'),
(1002,'Priya Sharma','priya1002@gmail.com','Mouse','Electronics',2,850,'2024-01-08','2024-01-11','Delhi','Card','Delivered'),
(1003,'Rahul Verma','rahul1003@gmail.com','Office Chair','Furniture',1,7200,'2024-01-09','2024-01-15','Noida','COD','Shipped'),
(1004,'Neha Gupta','neha1004@gmail.com','Keyboard','Electronics',1,1800,'2024-01-12','2024-01-16','Mumbai','UPI','Delivered'),
(1005,'Amit Singh','amit1005@gmail.com','Dining Table','Furniture',1,15500,'2024-01-15','2024-01-22','Pune','Card','Pending'),
(1006,'Sneha Patel','sneha1006@gmail.com','Monitor','Electronics',2,13500,'2024-01-18','2024-01-23','Lucknow','UPI','Delivered'),
(1007,'Karan Jain','karan1007@gmail.com','Notebook','Stationery',10,120,'2024-01-19','2024-01-20','Jaipur','COD','Delivered'),
(1008,'Divya Rai','divya1008@gmail.com','Desk Lamp','Home Decor',3,950,'2024-01-21','2024-01-25','Kanpur','Card','Cancelled'),
(1009,'Mohit Kumar','mohit1009@gmail.com','Bookshelf','Furniture',1,8400,'2024-01-22','2024-01-28','Delhi','UPI','Delivered'),
(1010,'Riya Singh','riya1010@gmail.com','Headphones','Electronics',1,3100,'2024-01-25','2024-01-28','Lucknow','Net Banking','Shipped');

Q-1
Create index idx_order_date 
on orders(order_date)

select * from orders
where order_date >  '2024-01-15'

Q-2 
insert into orders
values
(1013,'Mohit Kumar','mohit1009@gmail.com','Bookshelf','Furniture',1,8400,'2024-01-22','2024-01-28','Delhi','UPI','Delivered'),
(1014,'Riya Singh','riya1010@gmail.com','Headphones','Electronics',1,3100,'2024-01-25','2024-01-28','Lucknow','Net Banking','Shipped');
select * from orders

create unique index idx_email 
on orders (email)

select * from orders
where email = 'riya1010@gmail.com'

----ERROR:  could not create unique index "idx_email"
Key (email)=(mohit1009@gmail.com) is duplicated. 

SQL state: 23505
Detail: Key (email)=(mohit1009@gmail.com) is duplicated.--------

Q-3
create index idx_city 
on orders(city)

select * from orders
where city = 'Lucknow'

Q-4 --before create index
select * from orders
where city = 'Lucknow'

----explain analyze
Seq Scan on orders  (cost=0.00..35.50 rows=10 width=...)
  Filter: (city = 'Lucknow')
Execution Time: ...

-----after creatin index
create index idx_city 
on orders(city)

select * from orders
where city = 'Lucknow'

----explain analyze
Index Scan using idx_city on orders  (cost=0.29..8.50 rows=10 width=...)
  Index Cond: (city = 'Lucknow')
Execution Time: ...

Q-5
create index ind_category 
on orders(category) 

select * from orders
where category = 'Electronics'

Q-6
drop index idx_city
Q-7
create index idx_city_category
on orders(city,category)

select * from orders
where city = 'Lucknow' and category = 'Electronics'

Q-8
---if we talk about only one col in composite index, unlees the col is leading or pointer column 
---then postgre sql wouldn't use the composite index.

Q-9
create index idx_status_date 
on orders(order_status,order_date)

select * from orders
where order_date >  '2024-01-15'

Q-10
create index idx_order_status
on orders(order_status)

select * from orders
where order_status = 'Delivered'

Q-11
---Before create index
select * from orders
where order_status = 'Delivered'

----after create index---
create index idx_order_status
on orders(order_status)

select * from orders
where order_status = 'Delivered'

Q-12
create index idx_order_status
on orders(order_status)

select * from orders
where order_status = 'Cancelled'
--- so yes, PostgreSQL will use the partial index for order_status is cancelled

Q-13
create index idx_customer_name
on orders(lower(customer_name))

select Lower(customer_name)
from orders

Q-14----before create functional index
select * from orders
where lower(customer_name) = lower('Ankit Rai')

Seq Scan on customers (cost=0.00..35.50 rows=1 ...)
Filter: (lower(customer_name) = 'ankit rai')
Execution Time: 1.234 ms


----After create functional index

Index Scan using idx_lower_customer_name on customers (cost=0.29..8.50 rows=1 ...)
Index Cond: (lower(customer_name) = 'ankit rai')
Execution Time: 0.123 ms

create index idx_customer_name
on orders (lower(customer_name)) 

select Lower(customer_name)
from orders

Q-15
create index idx_category_city
on orders(category,city)

select * from orders
where category = 'Furniture'
---for only furniture
ERROR:  syntax error at or near "select"
LINE 4: select * from orders
        ^ 
----for city and category----
select * from orders
where category = 'Furniture' and city = 'Delhi'

Q-16 ---before index---
select * from orders
where city = 'Delhi'

create index idx_city
on orders(city)

---after index---
select * from orders
where city = 'Delhi'

-----Explain analyze
Cost, Row, Time

Q-17
create index idx_city_date_status
on orders (city,order_date,order_status)

select * from orders
where city = 'Delhi'
and order_date = '24-01-15'
and order_status = 'Cancelled'

Q-18
----Do not indexes are customer_name, product_name, quantity, unit_price, delivery_date, 
---payment_method — because they either have low selectivity, are rarely used in filters,
---or add unnecessary overhead.

Q-19
select indexname, indexdef
from
    pg_indexes
where
    tablename = 'orders'
-------indexes are------
"orders_pkey" -----unique index
"idx_order_date"----btree index
"idx_category"--------btree index
"idx_city_category"----Composite index
"idx_status_date"--------composite index
"idx_order_status"-----partial index
"idx_customer_name"-----btree index
"idx_category_city"-----composite index
"idx_city"----btree index
"idx_city_date_status"----composite index


Q-20
---Redundents are----
---except unique index, each indexes redundency is present. 

-----.🧠 Rule of Thumb
Drop indexes that duplicate the leading column of a composite index.

Keep indexes that serve unique constraints, frequent single‑column filters, or special cases (partial/expression).

Too many indexes slow down writes (INSERT/UPDATE/DELETE), so trimming redundant ones improves performance.
---------------------------------------------------------------------------------------------------------------

📘 20 Intermediate Index Practice Questions (Easy → Hard)
🟡 Easy (1–6)
Create a B-Tree Index on order_date and retrieve all orders placed after 2024-01-15.
Create a Unique Index on the email column and verify that duplicate emails cannot be inserted.
Create an index on city and retrieve all orders placed from Lucknow.
Compare the execution plan before and after creating the city index using EXPLAIN ANALYZE.
Create an index on category and retrieve all Electronics orders.
Drop the index created on city.
🟠 Medium (7–14)
Create a Composite Index on (city, category) and retrieve Electronics orders from Lucknow.
Run a query filtering only by category. Does PostgreSQL use the composite index?
Create another composite index on (order_status, order_date) and retrieve all Delivered orders after 2024-01-15.
Create a Partial Index only for orders whose order_status = 'Delivered'.
Verify whether PostgreSQL uses the partial index when retrieving Delivered orders.
Retrieve Cancelled orders. Does PostgreSQL use the partial index?
Create an Expression Index on LOWER(customer_name).
Search for "ANKIT RAI" using LOWER(customer_name) and compare the execution plan before and after creating the functional index.
🔴 Hard (15–20)
Create indexes on both category and (category, city). Compare which index PostgreSQL chooses for:
filtering by category only
filtering by category and city
Compare a Full Table Scan and an Index Scan for retrieving orders from Delhi using EXPLAIN ANALYZE.
Suppose users frequently search using city, order_status, and order_date. Design the most appropriate index and explain your reasoning.
Identify which columns should not be indexed in this table and justify your decision.
List every index created on the orders table and identify its type (B-Tree, Unique, Composite, Partial, Expression).
After creating all indexes, determine which ones are redundant or unnecessary and explain whether any can be safely removed without affecting common query performance.