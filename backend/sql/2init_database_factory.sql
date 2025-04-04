CREATE DATABASE factory_db CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

-- =====================
-- factory_db
-- =====================
USE factory_db;

CREATE TABLE factories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    location VARCHAR(255),
    remarks TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE factory_staff (
    id INT AUTO_INCREMENT PRIMARY KEY,
    factory_id INT,
    name VARCHAR(100),
    position VARCHAR(100),
    remarks TEXT,
    FOREIGN KEY (factory_id) REFERENCES factories(id)
);

CREATE TABLE products (
    id INT PRIMARY KEY,
    factory_id INT,
    product_code VARCHAR(100),
    intl_barcode VARCHAR(100),
    name VARCHAR(100),
    category VARCHAR(100),
    spec VARCHAR(100),
    location VARCHAR(100),
    remarks TEXT,
    package_id INT DEFAULT NULL COMMENT '所属包裹 ID',
    package_status ENUM('bound', 'unbound') DEFAULT 'unbound' COMMENT '包裹绑定状态',
    status ENUM('in_stock', 'outbound') DEFAULT 'in_stock' COMMENT '商品状态：在库 / 已出库',
    FOREIGN KEY (factory_id) REFERENCES factories(id)
);

CREATE TABLE packages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    factory_id INT,
    status ENUM('packing', 'shipped', 'in_transit', 'delivered') DEFAULT 'packing',
    barcode VARCHAR(100) NOT NULL UNIQUE,
    item_count INT DEFAULT 0,
    remarks TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (factory_id) REFERENCES factories(id)
);
