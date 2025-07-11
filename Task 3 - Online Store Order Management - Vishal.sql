-- Create database
create database onlineStore;
use onlineStore;

-- Customers table
create table customers (
    customerId int primary key,
    name varchar(100),
    email varchar(100),
    phone varchar(15),
    address text);

-- Products table
create table products (
    productId int primary key,
    productName varchar(100),
    category varchar(50),
    price decimal(10,2),
    stock int);

-- Orders table
create table orders (
    orderId int primary key,
    customerId int,
    productId int,
    quantity int,
    orderDate date,
    foreign key (customerId) references customers(customerId),
    foreign key (productId) references products(productId));
    
    -- Insert customers
insert into customers values
(1, 'Rahul Sharma', 'rahul@gmail.com', '9876543210', 'Delhi'),
(2, 'Priya Verma', 'priya@yahoo.com', '9123456789', 'Mumbai'),
(3, 'Anil Kapoor', 'anil@hotmail.com', '9988776655', 'Bangalore'),
(4, 'Meena Joshi', 'meena@rediffmail.com', '9001122334', 'Chennai'),
(5, 'Arjun Mehta', 'arjun@live.com', '9445566778', 'Hyderabad');

-- Insert products
insert into products values
(101, 'Samsung Galaxy S21', 'Mobiles', 59999, 10),
(102, 'Dell XPS 13', 'Laptops', 99999, 5),
(103, 'Sony WH-1000XM5', 'Headphones', 29999, 0),
(104, 'Apple iPad Air', 'Tablets', 54999, 2),
(105, 'HP DeskJet Printer', 'Printers', 8999, 3);

-- Insert orders
insert into orders values
(1001, 1, 101, 1, '2025-01-15'),
(1002, 1, 103, 1, '2025-02-10'),
(1003, 2, 102, 1, '2025-03-05'),
(1004, 3, 104, 2, '2025-04-01'),
(1005, 4, 101, 1, '2025-06-12'),
(1006, 2, 105, 3, '2025-07-01'),
(1007, 2, 101, 1, '2025-07-10');

-- Order Management
-- Retrieve all orders placed by a specific customer
select * 
from orders 
where customerId = 1;

-- Find products that are out of stock
select * 
from products 
where stock = 0;

-- Calculate the total revenue generated per product
select 
    p.productid,
    p.productName,
    sum(o.quantity * p.price) as totalRevenue
from orders o
join products p on o.productId = p.productid
group by p.productid, p.productName;

-- Retrieve the top 5 customers by total purchase amount
select 
    c.customerId,
    c.name,
    sum(o.quantity * p.price) as totalPurchase_amount
from orders o
join customers c on o.customerId = c.customerId
join products p on o.productId = p.productId
group by c.customerId, c.name
order by totalPurchase_amount desc
limit 5;

-- Find customers who placed orders in at least two different product categories
select 
    c.customerId,
    c.name
from orders o
join customers c on o.customerId = c.customerId
join products p on o.productId = p.productId
group by c.customerId, c.name
having count(distinct p.category) >= 2;

-- Analytics
-- Find the month with the highest total sales
select 
    date_format(orderDate, '%Y-%m') as month,
    sum(o.quantity * p.price) as totalSales
from orders o
join products p on o.productId = p.productId
group by month
order by totalSales desc
limit 1;

-- Identify products with no orders in the last 6 months
select * 
from products 
where productId not in (
    select distinct productId 
    from orders 
    where orderDate >= date_sub('2025-07-11', interval 6 month));
    
-- Retrieve customers who have never placed an order
select * 
from customers 
where customerId not in (
    select distinct customerId 
    from orders);
    
-- Calculate the average order value across all orders
select 
    avg(o.quantity * p.price) as averageOrderValue
from orders o
join products p on o.productId = p.productId;