-- UPVC Company Database Setup
CREATE DATABASE IF NOT EXISTS upvc_company;
USE upvc_company;

-- Customers table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50) NOT NULL,
    city VARCHAR(50),
    customer_type VARCHAR(20)
);

-- Orders table
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    product_type VARCHAR(50),
    quantity INT,
    amount DECIMAL(10,2),
    status VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Campaigns table
CREATE TABLE campaigns (
    campaign_id INT PRIMARY KEY,
    platform VARCHAR(30),
    start_date DATE,
    spend DECIMAL(10,2),
    leads_generated INT
);

-- Insert customers
INSERT INTO customers VALUES
(101, 'Rahul Sharma', 'Pune', 'Retail'),
(102, 'Priya Desai', 'Mumbai', 'Builder'),
(103, 'Amit Patel', 'Delhi', 'Dealer'),
(104, 'Sneha Joshi', 'Pune', 'Retail'),
(105, 'Vikram Singh', 'Bangalore', 'Builder'),
(106, 'Neha Kapoor', 'Mumbai', 'Retail');

-- Insert orders
INSERT INTO orders VALUES
(1, 101, '2024-01-05', 'Window', 4, 48000, 'Completed'),
(2, 101, '2024-01-20', 'Door', 2, 35000, 'Completed'),
(3, 102, '2024-01-10', 'Window', 20, 240000, 'Completed'),
(4, 103, '2024-02-01', 'Window', 10, 120000, 'Pending'),
(5, 104, '2024-02-15', 'Door', 1, 18000, 'Completed'),
(6, 102, '2024-03-01', 'Door', 15, 210000, 'Completed'),
(7, 105, '2024-03-10', 'Window', 30, 360000, 'Pending'),
(8, 101, '2024-04-05', 'Window', 3, 36000, 'Completed'),
(9, 106, '2024-04-12', 'Door', 2, 38000, 'Cancelled'),
(10, 103, '2024-04-20', 'Window', 8, 96000, 'Completed');

-- Insert campaigns
INSERT INTO campaigns VALUES
(1, 'Facebook', '2024-01-01', 15000, 120),
(2, 'Instagram', '2024-01-15', 22000, 180),
(3, 'IndiaMART', '2024-02-01', 30000, 250),
(4, 'Facebook', '2024-03-01', 18000, 95);
