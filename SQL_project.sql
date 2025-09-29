-- 1. Database
CREATE DATABASE IF NOT EXISTS Grocery_Store_Managment;
USE Grocery_Store_Managment;

-- 2. Supplier Table
CREATE TABLE IF NOT EXISTS supplier (
    sup_id TINYINT PRIMARY KEY,
    sup_name VARCHAR(255),
    address TEXT
);
SELECT * FROM supplier;

-- remove NULL rows if any
DELETE FROM supplier
WHERE sup_id IS NULL
  AND sup_name IS NULL
  AND address IS NULL;

-- 3. Categories Table
CREATE TABLE IF NOT EXISTS categories (
    cat_id TINYINT PRIMARY KEY,
    cat_name VARCHAR(255)
);
SELECT * FROM categories;

-- 4. Employees Table
CREATE TABLE IF NOT EXISTS Store_employees (
    emp_id TINYINT PRIMARY KEY,
    emp_name VARCHAR(255),
    hire_date VARCHAR(255)
);
SELECT * FROM Store_employees;

-- 5. Customers Table
CREATE TABLE IF NOT EXISTS customers (
    cust_id SMALLINT PRIMARY KEY,
    cust_name VARCHAR(255),
    address TEXT
);
SELECT * FROM customers;

-- 6. Products Table
CREATE TABLE IF NOT EXISTS products (
    prod_id TINYINT PRIMARY KEY,
    prod_name VARCHAR(255),
    sup_id TINYINT,
    cat_id TINYINT,
    price DECIMAL(10,2),
    FOREIGN KEY (sup_id) REFERENCES supplier(sup_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (cat_id) REFERENCES categories(cat_id)
        ON UPDATE CASCADE ON DELETE CASCADE
);
SELECT * FROM products;

-- 7. Orders Table
CREATE TABLE IF NOT EXISTS orders (
    ord_id SMALLINT PRIMARY KEY,
    cust_id SMALLINT,
    emp_id TINYINT,
    order_date VARCHAR(255),
    FOREIGN KEY (cust_id) REFERENCES customers(cust_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (emp_id) REFERENCES Store_employees(emp_id)  
        ON UPDATE CASCADE ON DELETE CASCADE
);
SELECT * FROM orders;

-- 8. Order_Details Table
CREATE TABLE IF NOT EXISTS order_details (
    ord_ID SMALLINT AUTO_INCREMENT PRIMARY KEY,
    ord_ids SMALLINT,
    prod_id TINYINT,
    quantity TINYINT,
    each_price DECIMAL(10,2),
    total_price DECIMAL(10,2),
    FOREIGN KEY (ord_id) REFERENCES orders(ord_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (prod_id) REFERENCES products(prod_id)
        ON UPDATE CASCADE ON DELETE CASCADE
);
SELECT * FROM order_details;



-- q1 --
select count(distinct(cust_id)) as total_orders
from customers;

-- q2 --
select c.cust_id,c.cust_name,count(o.ord_id) as total_orders
from customers c inner join orders o on c.cust_id = o.cust_id 
group by c.cust_id , c.cust_name 
order by total_orders desc limit 1;

-- q3 --

select c.cust_id,c.cust_name,sum(od.quantity*od.each_price) as total_purchase,
 avg(od.quantity*od.each_price) as average_purchase from customers c inner join
 orders o on c.cust_id = o.cust_id 
 join order_details od on o.ord_id = od.ord_id
 group by c.cust_id,c.cust_name 
 order by total_purchase desc;
 
 
 -- q4 --
 
 select c.cust_id,c.cust_name,sum(od.quantity*od.each_price) as total_purchase
 from customers c inner join orders o on c.cust_id = o.cust_id 
 inner join order_details od on o.ord_id = od.ord_id 
 group by c.cust_id,c.cust_name 
 order by total_purchase desc limit 5;
 
 
 -- 2. Product Performance--
 
 -- q5 --
 
 select ca.cat_id,ca.cat_name, count(p.prod_id) as total_products from categories ca
 inner join  products p on ca.cat_id = p.cat_id 
 group by cat_name,cat_id
 order by total_products desc;
 
 
 -- q6--
 select ca.cat_id,ca.cat_name,p.prod_name , avg(p.price) as Average_price from categories ca
 inner join  products p on ca.cat_id = p.cat_id 
 group by cat_name,cat_id,p.prod_name
 order by ca.cat_id asc;
 
 -- q7 --
 
 select p.prod_id,p.prod_name,sum(od.quantity) as total_quantity from products p
 inner join order_details od on p.prod_id = od.prod_id
 group by p.prod_id,p.prod_name,od.quantity
 order by total_quantity desc; 
 
 -- q8--
 
select p.prod_id,p.prod_name,sum(od.total_price) as total_collection from products p
 inner join order_details od on p.prod_id = od.prod_id
 group by p.prod_id,p.prod_name
 order by total_collection desc;
 
 -- q9 --
 select ca.cat_id, ca.cat_name, p.prod_name, s.sup_name, sum(od.quantity) as total_quantity, sum(od.total_price) as total_revenue
 from categories ca join  products p on ca.cat_id = p.cat_id
 join order_details od on od.prod_id = p.prod_id
 join supplier s on s.sup_id = p.sup_id
 group by ca.cat_id, ca.cat_name, p.prod_name, s.sup_name
 order by ca.cat_id asc, total_revenue desc;
 
 
 -- 3. Sales and Order Trends --
 
 -- q9 --
 
 select count(ord_ids) from order_details;
 
 
 -- q10 --
 
 select count(distinct(o.ord_id)) as total_orders, SUM(total_price) / COUNT(DISTINCT o.ord_id) AS avg_order_value
 from orders o join order_details od on o.ord_id = od.ord_id;
 
 
 -- q11 --
 
 select o.order_date, count(od.ord_ids) as total_orders from orders o
 join order_details od on o.ord_id = od.ord_ids
 group by o.order_date
 order by total_orders desc;
 
 -- q12 --
 
 SELECT 
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    COUNT(DISTINCT o.ord_id) AS order_volume,
    SUM(od.quantity * od.each_price) AS total_revenue
FROM orders o
JOIN order_details od ON o.ord_id = od.ord_id
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY month;
 
 
 
 
 -- q13 --
 
 
 SELECT CASE WHEN DAYOFWEEK(o.order_date) IN (1,7) THEN 'Weekend'
 ELSE 'Weekday'
 END AS day_type,
COUNT(DISTINCT o.ord_id) AS order_volume,
SUM(od.quantity * od.each_price) AS total_revenue
FROM orders o
JOIN order_details od ON o.ord_id = od.ord_id
GROUP BY day_type;
 
 
 
 

 
 -- 4️. Supplier Contrbution--
 
 -- q14--
 
 select count(*) from supplier;
 
 -- q15 --
 
 select s.sup_id, s.sup_name, count(p.prod_id) as total_products from supplier s
 join products p on p.sup_id = s.sup_id
 group by s.sup_id, s.sup_name
 order by total_products desc;
 
 
 -- q16--
 
  select s.sup_id, s.sup_name, avg(od.each_price) as average_price from supplier s
 join products p on p.sup_id = s.sup_id
 join order_details od on od.prod_id = p.prod_id
 group by s.sup_id, s.sup_name
 order by average_price desc;
 
 
 -- q17 --
 
 select s.sup_id, s.sup_name, sum(total_price) as total_revenue from supplier s
 join products p on p.sup_id = s.sup_id
 join order_details od on od.prod_id = p.prod_id
 group by s.sup_id, s.sup_name
 order by total_revenue desc limit 3;
 
 
 
 -- 5️. Employee Performance --

 -- q18 --
 
 select count(*) from store_employees;
 
 -- q19--
 
 select e.emp_id, e.emp_name, count(o.emp_id) as orders_processed from store_employees e
 join orders o on o.emp_id = e.emp_id
 group by e.emp_id, e.emp_name
 order by orders_processed desc limit 1;
 
 
 -- q20--
 
  select e.emp_id, e.emp_name, sum(total_price) as total_revenue from store_employees e
 join orders o on o.emp_id = e.emp_id
 join order_details od on od.ord_id = o.ord_id
 group by e.emp_id, e.emp_name
 order by total_revenue desc ;
 
 
 -- q21 --
 
  select e.emp_id, e.emp_name, avg(total_price) as avg_revenue from store_employees e
 join orders o on o.emp_id = e.emp_id
 join order_details od on od.ord_id = o.ord_id
 group by e.emp_id, e.emp_name
 order by avg_revenue desc ;
 
 
 -- 6️. Order Details Deep Dive --
 
 -- q22 --
 
 SELECT prod_id, SUM(quantity) AS total_quantity_sold, SUM(total_price) AS total_revenue
FROM order_details
GROUP BY prod_id
ORDER BY total_revenue DESC;
 
 
 
 -- q23 --
 
 select p.prod_id, p.prod_name, avg(od.quantity) as average_quantity from products p
 join order_details od on od.prod_id = p.prod_id
 group by p.prod_id,p.prod_name
 order by average_quantity desc;
 
 
 -- q24--
 
 SELECT p.prod_id, p.prod_name,
MIN(od.each_price) AS min_price,
MAX(od.each_price) AS max_price,
AVG(od.each_price) AS avg_price
FROM products p
JOIN order_details od ON p.prod_id = od.prod_id
GROUP BY p.prod_id, p.prod_name
ORDER BY avg_price DESC;
 
 
 
 
 
 
 
 
 