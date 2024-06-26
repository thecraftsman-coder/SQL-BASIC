-- Create Customers table
CREATE TABLE Customers (
    customer_id INTEGER PRIMARY KEY,
    name VARCHAR(n),
    address VARCHAR(m)
);

-- Create Products table
CREATE TABLE Products (
    product_id INTEGER PRIMARY KEY,
    name VARCHAR,
    price DECIMAL CHECK (price > 0)
);

-- Create Orders table
CREATE TABLE Orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER,
    product_id INTEGER,
    quantity INTEGER,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);
