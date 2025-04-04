-- 创建数据库
CREATE DATABASE core_db CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

-- =====================
-- core_db
-- =====================
USE core_db;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role_id INT NOT NULL COMMENT '1=admin, 2=shop, 3=shop_staff, 4=factory, 5=factory_staff',
    permission VARCHAR(50) DEFAULT NULL COMMENT '可选的细粒度权限标识，如"super_admin"、"viewer"等',
    shop_id INT DEFAULT NULL,
    factory_id INT DEFAULT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
