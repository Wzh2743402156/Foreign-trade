CREATE DATABASE shop_db CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

-- =====================
-- shop_db
-- =====================
USE shop_db;

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

CREATE TABLE products (
    id INT PRIMARY KEY,
    shop_id INT NOT NULL,
    factory_id INT,
    product_code VARCHAR(100),
    intl_barcode VARCHAR(100),
    name VARCHAR(100),
    category VARCHAR(100),
    spec VARCHAR(100),
    location VARCHAR(100),
    remarks TEXT,
    package_id INT DEFAULT NULL COMMENT '所属包裹 ID',
    package_status ENUM('bound', 'unbound') DEFAULT 'bound' COMMENT '包裹绑定状态',
    FOREIGN KEY (shop_id) REFERENCES shops(id)
);

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
