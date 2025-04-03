-- 创建数据库
CREATE DATABASE core_db CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE DATABASE factory_db CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE DATABASE shop_db CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

-- =====================
-- core_db
-- =====================
USE core_db;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role_id INT NOT NULL COMMENT '1=admin, 2=shop, 3=shop_staff, 4=manufacturer, 5=manufacturer_staff',
    permission VARCHAR(50) DEFAULT NULL COMMENT '可选的细粒度权限标识，如"super_admin"、"viewer"等',
    shop_id INT DEFAULT NULL,
    factory_id INT DEFAULT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- =====================
-- factory_db
-- =====================
USE factory_db;

CREATE TABLE manufacturers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    location VARCHAR(255),
    remarks TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE manufacturer_staff (
    id INT AUTO_INCREMENT PRIMARY KEY,
    manufacturer_id INT,
    name VARCHAR(100),
    position VARCHAR(100),
    remarks TEXT,
    FOREIGN KEY (manufacturer_id) REFERENCES manufacturers(id)
);

CREATE TABLE products (
    id INT PRIMARY KEY,
    manufacturer_id INT,
    product_code VARCHAR(100),
    intl_barcode VARCHAR(100),
    name VARCHAR(100),
    category VARCHAR(100),
    spec VARCHAR(100),
    location VARCHAR(100),
    remarks TEXT
);

CREATE TABLE packages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    manufacturer_id INT,
    status ENUM('packing', 'shipped', 'in_transit', 'delivered') DEFAULT 'packing',
    barcode VARCHAR(100) NOT NULL UNIQUE,
    item_count INT DEFAULT 0,
    remarks TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (manufacturer_id) REFERENCES manufacturers(id)
);

CREATE TABLE package_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    package_id INT,
    product_id INT,
    FOREIGN KEY (package_id) REFERENCES packages(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- =====================
-- shop_db
-- =====================
USE shop_db;

-- 商店基础信息
CREATE TABLE shops (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    location VARCHAR(255),
    remarks TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE shop_staff (
    id INT AUTO_INCREMENT PRIMARY KEY,
    shop_id INT,
    name VARCHAR(100),
    position VARCHAR(100),
    remarks TEXT,
    FOREIGN KEY (shop_id) REFERENCES shops(id)
);

-- 本地简化版 products 表（为了解决外键问题）
CREATE TABLE products (
    id INT PRIMARY KEY,
    shop_id INT NOT NULL,
    manufacturer_id INT,
    product_code VARCHAR(100),
    intl_barcode VARCHAR(100),
    name VARCHAR(100),
    category VARCHAR(100),
    spec VARCHAR(100),
    location VARCHAR(100),
    remarks TEXT
);

-- 入库记录
CREATE TABLE inbound_records (
    id INT AUTO_INCREMENT PRIMARY KEY,
    shop_id INT,
    product_id INT,
    date DATE,
    quantity INT,
    operator VARCHAR(100),
    remarks TEXT,
    FOREIGN KEY (shop_id) REFERENCES shops(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- 出库记录
CREATE TABLE outbound_records (
    id INT AUTO_INCREMENT PRIMARY KEY,
    shop_id INT,
    product_id INT,
    date DATE,
    quantity INT,
    operator VARCHAR(100),
    remarks TEXT,
    FOREIGN KEY (shop_id) REFERENCES shops(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- 当前库存表
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
    FOREIGN KEY (shop_id) REFERENCES shops(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- 每日商店级别统计
CREATE TABLE shop_daily_stats (
    id INT AUTO_INCREMENT PRIMARY KEY,
    shop_id INT NOT NULL,
    date DATE NOT NULL,
    total_in  INT DEFAULT 0 COMMENT '当日入库数量',
    total_out  INT DEFAULT 0 COMMENT '当日出库数量',
    stock  INT DEFAULT 0 COMMENT '当日剩余库存',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (shop_id) REFERENCES shops(id)
);

-- 每日每个商品汇总
CREATE TABLE product_summary (
    id INT AUTO_INCREMENT PRIMARY KEY,
    shop_id INT NOT NULL,
    product_id INT NOT NULL,
    summary_date DATE NOT NULL,

    product_code VARCHAR(100),
    category VARCHAR(100),
    product_name VARCHAR(100),
    spec VARCHAR(100),
    location VARCHAR(100),

    total_in INT DEFAULT 0,
    total_out INT DEFAULT 0,
    current_stock INT DEFAULT 0,

    remarks TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    UNIQUE KEY uniq_summary (shop_id, product_id, summary_date),
    FOREIGN KEY (shop_id) REFERENCES shops(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- 操作明细日志
CREATE TABLE product_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    shop_id INT NOT NULL,
    product_id INT NOT NULL,
    operation_type ENUM('inbound', 'outbound') NOT NULL,
    quantity INT NOT NULL,
    operator VARCHAR(100),
    log_date DATE NOT NULL,

    product_code VARCHAR(100),
    category VARCHAR(100),
    product_name VARCHAR(100),
    spec VARCHAR(100),
    location VARCHAR(100),
    remarks TEXT,

    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (shop_id) REFERENCES shops(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);
