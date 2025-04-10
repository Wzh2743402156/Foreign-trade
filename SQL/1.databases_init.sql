CREATE DATABASE foreign_trade_database;
USE foreign_trade_database;

-- 1. Products 表
CREATE TABLE Products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    factory_id INT,
    shop_id INT,
    name VARCHAR(255),
    tag JSON,
    package_id INT,
    status INT,
    code VARCHAR(100),
    specification VARCHAR(255),
    remark TEXT
);

-- 2. Packages 表
CREATE TABLE Packages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    num INT,
    tag JSON,
    status INT,
    log_id INT
);

-- 3. Users 表
CREATE TABLE Users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    account VARCHAR(100) UNIQUE,
    password VARCHAR(255),
    factory_id INT,
    shop_id INT,
    permission INT,
    create_date DATETIME,
    update_date DATETIME
);

-- 4. Shops 表
CREATE TABLE Shops (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    location VARCHAR(255),
    create_date DATETIME,
    update_date DATETIME,
    remark TEXT
);

-- 5. Factories 表
CREATE TABLE Factories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    location VARCHAR(255),
    create_date DATETIME,
    update_date DATETIME,
    remark TEXT
);

-- 6. Tag 表
CREATE TABLE Tags (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    factory_id INT,
    shop_id INT,
    inbound INT DEFAULT 0,
    outbound INT DEFAULT 0,
    stock INT DEFAULT 0,
    date DATE
);

-- 7. TagLogs 表
CREATE TABLE TagLogs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tag_id INT NOT NULL,
    date DATE NOT NULL,
    inbound INT DEFAULT 0,
    outbound INT DEFAULT 0,
    stock INT DEFAULT 0,
    UNIQUE KEY(tag_id, date)
);

-- 8. Alert 表
CREATE TABLE Alert (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tag_id INT,
    alert_low INT,
    alert_high INT
);

-- 9. Logs 表
CREATE TABLE Logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    action_type ENUM('inbound_factory', 'outbound_factory', 'inbound_shop', 'outbound_shop') NOT NULL COMMENT '操作类型',
    operator VARCHAR(100) COMMENT '操作人',
    log_date DATETIME NOT NULL COMMENT '操作日期',
    product_id INT DEFAULT NULL COMMENT '关联商品',
    package_id INT DEFAULT NULL COMMENT '关联包裹',
    remark TEXT
);