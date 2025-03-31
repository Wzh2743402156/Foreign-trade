-- 创建数据库
CREATE DATABASE core_db CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE DATABASE manufacturer_db CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE DATABASE shop_db CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

USE core_db;

-- 用户表
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role_id INT NOT NULL COMMENT '1=admin, 2=shop, 3=shop_staff, 4=manufacturer, 5=manufacturer_staff',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 权限说明（仅供参考，系统中 role_id 直接使用数字）
CREATE TABLE permissions (
    role_id INT PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL
);

-- 初始化权限（可选）
INSERT INTO permissions (role_id, role_name) VALUES
(1, 'admin'),
(2, 'shop'),
(3, 'shop_staff'),
(4, 'manufacturer'),
(5, 'manufacturer_staff');

USE manufacturer_db;

-- 厂家信息
CREATE TABLE manufacturers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    location VARCHAR(255),
    remarks TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 厂家员工
CREATE TABLE manufacturer_staff (
    id INT AUTO_INCREMENT PRIMARY KEY,
    manufacturer_id INT,
    name VARCHAR(100),
    position VARCHAR(100),
    remarks TEXT,
    FOREIGN KEY (manufacturer_id) REFERENCES manufacturers(id)
);

-- 产品信息
CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    manufacturer_id INT,
    product_code JSON, -- 自定义 JSON 信息
    intl_barcode VARCHAR(100), -- 国际运输条码
    name VARCHAR(100),
    category VARCHAR(100),
    spec VARCHAR(100),
    location VARCHAR(100),
    remarks TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (manufacturer_id) REFERENCES manufacturers(id)
);

-- 包装信息（一个包装对应多个产品）
CREATE TABLE packages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    manufacturer_id INT,
    status ENUM('packing', 'shipped', 'in_transit', 'delivered') DEFAULT 'packing',
    barcode VARCHAR(100) NOT NULL UNIQUE, -- 包装二维码
    item_count INT DEFAULT 0,
    remarks TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (manufacturer_id) REFERENCES manufacturers(id)
);

-- 包装内的商品明细
CREATE TABLE package_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    package_id INT,
    product_id INT,
    FOREIGN KEY (package_id) REFERENCES packages(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

USE shop_db;

-- 店铺信息
CREATE TABLE shops (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    location VARCHAR(255),
    remarks TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 店员信息
CREATE TABLE shop_staff (
    id INT AUTO_INCREMENT PRIMARY KEY,
    shop_id INT,
    name VARCHAR(100),
    position VARCHAR(100),
    remarks TEXT,
    FOREIGN KEY (shop_id) REFERENCES shops(id)
);

-- 入库记录（扫码入库）
CREATE TABLE inbound_records (
    id INT AUTO_INCREMENT PRIMARY KEY,
    shop_id INT,
    product_id INT,
    date DATE,
    quantity INT,
    operator VARCHAR(100),
    remarks TEXT,
    FOREIGN KEY (shop_id) REFERENCES shops(id)
);

-- 出库记录（扫码出库）
CREATE TABLE outbound_records (
    id INT AUTO_INCREMENT PRIMARY KEY,
    shop_id INT,
    product_id INT,
    date DATE,
    quantity INT,
    operator VARCHAR(100),
    remarks TEXT,
    FOREIGN KEY (shop_id) REFERENCES shops(id)
);

-- 库存信息
CREATE TABLE inventory (
    id INT AUTO_INCREMENT PRIMARY KEY,
    shop_id INT,
    product_id INT,
    current_quantity INT DEFAULT 0,
    inbound_total INT DEFAULT 0,
    outbound_total INT DEFAULT 0,
    alert_low INT DEFAULT 0,
    alert_high INT DEFAULT 99999,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (shop_id) REFERENCES shops(id)
);

