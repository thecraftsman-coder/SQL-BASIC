-- Insert records into products table
INSERT INTO products (name, price) VALUES ('Cookies', 10.0);
INSERT INTO products (name, price) VALUES ('Candy', 5.2);

-- Insert records into customers table
INSERT INTO customers (name, address) VALUES ('Ahmed', 'Tunisia');
INSERT INTO customers (name, address) VALUES ('Coulibaly', 'Senegal');
INSERT INTO customers (name, address) VALUES ('Hasan', 'Egypt');

-- Insert records into orders table
INSERT INTO orders (customerid, productid, quantity, order_date) 
VALUES (1, 2, 3, '2023-01-22');

INSERT INTO orders (customerid, productid, quantity, order_date) 
VALUES (2, 1, 10, '2023-04-14');

-- Update the quantity of the second order
UPDATE orders 
SET quantity = 6 
WHERE customerid = 2 AND productid = 1;

-- Delete the third customer
DELETE FROM customers 
WHERE name = 'Hasan' AND address = 'Egypt';

-- Delete the content of the orders table
DELETE FROM orders;

-- Drop the orders table
DROP TABLE orders;
