CREATE DATABASE DQLcheckpoint
GO

USE DQLcheckpoint
GO

CREATE TABLE CUSTOMERS (
customer_id INT PRIMARY KEY NOT NULL,
name VARCHAR (255) NOT NULL,
address VARCHAR (50)
);
GO

CREATE TABLE PRODUCTS (
product_id INT PRIMARY KEY NOT NULL,
name VARCHAR (255) NOT NULL,
category VARCHAR (255) NOT NULL,
price DECIMAL (7,2) NOT NULL
);
GO


CREATE TABLE ORDERS (
order_id INT PRIMARY KEY NOT NULL,
customer_id INT FOREIGN KEY REFERENCES CUSTOMERS (customer_id),
product_id INT FOREIGN KEY REFERENCES PRODUCTS (product_id),
order_date DATE,
quantity INT,
total_amount DECIMAL (12,2)
);
GO

INSERT INTO CUSTOMERS
VALUES 
(1, 'J.K. Rowling', '123 Main St.'),
(2, 'George Orwell', '456 Market St.'),
(3, 'Agatha Christie', '789 Elm St.');
GO

INSERT INTO PRODUCTS
VALUES
(1, 'Map', 'Widget', 25.00),
(2, 'Phone', 'Gadget', 1150.00),
(3, 'Nite', 'Doohickey', 5500.00);
GO

INSERT INTO ORDERS
VALUES
(1, 1, 1, '2024-08-03', 10, 750.00),
(2, 2, 2, '2024-02-01', 5, 2300.00),
(3, 3, 1, '2024-07-13', 3, 12500.00),
(4, 4, 2, '2024-03-09', 7, 1150.00),
(5, 5, 1, '2024-04-24', 2, 500.00),
(6, 6, 3, '2024-01-21', 3, 2500.00);
GO

-- 1. Write a SQL query to retrieve the names of the customers who have placed an order for at least one widget and at least one gadget, along with the total cost of the widgets and gadgets ordered by each customer. The cost of each item should be calculated by multiplying the quantity by the price of the product.



SELECT c.name,
    SUM(CASE WHEN p.category = 'Widget' THEN o.quantity * p.price ELSE 0 END) AS total_widget_cost,
    SUM(CASE WHEN p.category = 'Gadget' THEN o.quantity * p.price ELSE 0 END) AS total_gadget_cost,
    SUM(CASE WHEN p.category IN ('Widget', 'Gadget') THEN o.quantity * p.price ELSE 0 END) AS total_cost
FROM CUSTOMERS c
JOIN ORDERS o ON c.customer_id = o.customer_id
JOIN PRODUCTS p ON o.product_id = p.product_id
GROUP BY  c.name
HAVING 
    SUM(CASE WHEN p.category = 'Widget' THEN o.quantity * p.price ELSE 0 END) > 0
    AND 
    SUM(CASE WHEN p.category = 'Gadget' THEN o.quantity * p.price ELSE 0 END) > 0;



WITH WidgetCustomers AS (
    SELECT DISTINCT o.customer_id
    FROM Orders o
    JOIN Products p ON o.product_id = p.product_id
    WHERE p.category = 'Widget'
),
GadgetCustomers AS (
    SELECT DISTINCT o.customer_id
    FROM Orders o
    JOIN Products p ON o.product_id = p.product_id
    WHERE p.category = 'Gadget'
)
SELECT DISTINCT c.name
FROM Customers c
WHERE c.customer_id IN (SELECT customer_id FROM WidgetCustomers)
  AND c.customer_id IN (SELECT customer_id FROM GadgetCustomers);



-- Write a query to retrieve the names of the customers who have placed an order for at least one widget, along with the total cost of the widgets ordered by each customer.

SELECT  c.name, SUM(o.quantity * p.price) AS total_widget_cost
FROM  CUSTOMERS c
JOIN ORDERS o ON c.customer_id = o.customer_id
JOIN PRODUCTS p ON o.product_id = p.product_id
WHERE p.category = 'Widget'
GROUP BY c.name
HAVING SUM(o.quantity * p.price) > 0;



--Write a query to retrieve the names of the customers who have placed an order for at least one gadget, along with the total cost of the gadgets ordered by each customer.
SELECT c.customer_id, c.name, SUM(o.quantity * p.price) AS total_gadget_cost
FROM CUSTOMERS c
JOIN ORDERS o ON c.customer_id = o.customer_id
JOIN PRODUCTS p ON o.product_id = p.product_id
WHERE p.category = 'Gadget'
GROUP BY c.customer_id, c.name
HAVING SUM(o.quantity) > 0;


-- Write a query to retrieve the names of the customers who have placed an order for at least one doohickey, along with the total cost of the doohickeys ordered by each customer.
SELECT c.customer_id, c.name, SUM(o.quantity * p.price) AS total_doohickey_cost
FROM CUSTOMERS c
JOIN ORDERS o ON c.customer_id = o.customer_id
JOIN PRODUCTS p ON o.product_id = p.product_id
WHERE p.category = 'doohickey'  
GROUP BY c.customer_id, c.name
HAVING SUM(o.quantity) > 0;


-- Write a query to retrieve the total number of widgets and gadgets ordered by each customer, along with the total cost of the orders.
SELECT c.customer_id, c.name, 
SUM(CASE WHEN p.category = 'Widget' THEN o.quantity ELSE 0 END) AS total_widgets_ordered, 
SUM(CASE WHEN p.category = 'Gadget' THEN o.quantity ELSE 0 END) AS total_gadgets_ordered, 
SUM(o.quantity * p.price) AS total_cost
FROM CUSTOMERS c
JOIN ORDERS o ON c.customer_id = o.customer_id
JOIN PRODUCTS p ON o.product_id = p.product_id
WHERE p.category IN ('Widget', 'Gadget')  
GROUP BY c.customer_id, c.name
ORDER BY c.customer_id;


-- Write a query to retrieve the names of the products that have been ordered by at least one customer, along with the total quantity of each product ordered.
SELECT p.name, SUM(o.quantity) AS total_quantity_ordered
FROM PRODUCTS p
JOIN ORDERS o 
ON p.product_id = o.product_id
GROUP BY p.name
ORDER BY p.name;


-- Write a query to retrieve the names of the customers who have placed the most orders, along with the total number of orders placed by each customer.
SELECT c.customer_id, c.name, COUNT(*) AS total_orders_placed
FROM CUSTOMERS c
INNER JOIN ORDERS o 
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_orders_placed DESC;


-- Write a query to retrieve the names of the products that have been ordered the most, along with the total quantity of each product ordered.
SELECT p.name, SUM(o.quantity) AS total_quantity_ordered
FROM PRODUCTS p
JOIN ORDERS o 
ON p.product_id = o.product_id
GROUP BY p.name
ORDER BY total_quantity_ordered DESC;



-- Write a query to retrieve the names of the customers who have placed an order on every day of the week, along with the total number of orders placed by each customer.
SELECT c.customer_id, c.name,
COUNT(DISTINCT DATEPART(WEEKDAY, o.order_date)) AS days_with_orders
FROM CUSTOMERS c
JOIN ORDERS o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
HAVING COUNT(DISTINCT DATEPART(WEEKDAY, o.order_date)) = 7;
