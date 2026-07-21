-- Create database if not exists
CREATE DATABASE IF NOT EXISTS stockdb;
USE stockdb;

-- 1. Users Table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    role VARCHAR(20) DEFAULT 'ADMIN',
    full_name VARCHAR(100) NOT NULL
);

-- 2. Products Table
CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    sku VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    min_stock INT DEFAULT 10
);

-- 3. Warehouse Stock Table
CREATE TABLE IF NOT EXISTS warehouse_stock (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    quantity INT DEFAULT 0,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- 4. Shop Stock Table
CREATE TABLE IF NOT EXISTS shop_stock (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    quantity INT DEFAULT 0,
    sold_quantity INT DEFAULT 0,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- 5. Transfers Table
CREATE TABLE IF NOT EXISTS transfers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    status VARCHAR(20) DEFAULT 'PENDING', -- PENDING, APPROVED, REJECTED
    request_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- 6. Transfer History Table
CREATE TABLE IF NOT EXISTS transfer_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    transfer_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    status VARCHAR(20) NOT NULL, -- APPROVED, REJECTED
    action_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- ---------------------------------------------------------
-- Insert Sample Data
-- ---------------------------------------------------------

-- Default Admin User (username: admin, password: adminPassword123)
-- For B.Tech projects, plain text or simple hashing is used. We will use plain text for simplicity of code.
INSERT INTO users (username, password, email, role, full_name) 
VALUES ('admin', 'admin123', 'admin@stockmanage.com', 'ADMIN', 'System Administrator')
ON DUPLICATE KEY UPDATE username=username;

-- Sample Products
INSERT INTO products (name, sku, description, category, price, min_stock) VALUES
('Dell Inspiron 15', 'DELL-INS-15', '15.6 inch laptop with Intel Core i5, 8GB RAM, 512GB SSD', 'Electronics', 55000.00, 5),
('Samsung Galaxy S23', 'SAMP-GAL-S23', 'Android smartphone with 128GB storage, Cream color', 'Electronics', 74999.00, 8),
('Logitech MX Master 3S', 'LOGI-MX-3S', 'Ergonomic wireless mouse with silent clicks', 'Accessories', 9495.00, 15),
('Ergonomic Office Chair', 'OFF-CHR-01', 'High-back mesh chair with adjustable lumbar support', 'Furniture', 12500.00, 4),
('Thermal Water Bottle', 'WAT-BTL-02', 'Stainless steel vacuum insulated flask 1L', 'Utilities', 1200.00, 20);

-- Initialize Warehouse Stock
INSERT INTO warehouse_stock (product_id, quantity) VALUES
(1, 25),
(2, 18),
(3, 40),
(4, 8),
(5, 50);

-- Initialize Shop Stock
INSERT INTO shop_stock (product_id, quantity, sold_quantity) VALUES
(1, 5, 2),
(2, 3, 1),
(3, 12, 5),
(4, 2, 0),
(5, 15, 8);

-- Sample Transfer Requests
INSERT INTO transfers (product_id, quantity, status) VALUES
(1, 5, 'PENDING'),
(3, 10, 'PENDING');
