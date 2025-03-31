USE core_db;

-- 清空 permissions 表
DELETE FROM permissions;

-- 或者强制删除所有数据并重置自增主键
TRUNCATE TABLE permissions;

-- 然后再插入
INSERT INTO permissions (role_id, role_name) VALUES
(1, 'admin'),
(2, 'shop'),
(3, 'shop_staff'),
(4, 'manufacturer'),
(5, 'manufacturer_staff');


-- 插入管理员账户
INSERT INTO users (username, password, role_id) VALUES
('admin', '123456', 1),
('shop_owner', '123456', 2),
('shop_staff1', '123456', 3),
('factory_owner', '123456', 4),
('factory_worker1', '123456', 5);

USE manufacturer_db;

-- 插入厂家
INSERT INTO manufacturers (name, location, remarks) VALUES
('鸿盛电子', '深圳市宝安区', '主营智能设备'),
('丰田汽车配件', '天津市工业园', '主营汽车电子');

-- 插入厂家员工
INSERT INTO manufacturer_staff (manufacturer_id, name, position, remarks) VALUES
(1, '李工程', '仓库主管', ''),
(2, '王杰', '打包员', '');

-- 插入商品（包含 JSON 产品码与国际条码）
INSERT INTO products (manufacturer_id, product_code, intl_barcode, name, category, spec, location, remarks) VALUES
(1, '{"color":"red","batch":"A001"}', 'INTL-ABC-12345', '智能插座', '智能家居', '10A/220V', '一号仓', '热销产品'),
(1, '{"color":"blue","batch":"A002"}', 'INTL-ABC-12346', '智能开关', '智能家居', '两控', '二号仓', ''),
(2, '{"batch":"B101"}', 'INTL-CAR-99887', '汽车刹车片', '汽车零件', '碳纤维加强', '三号仓', '需特殊包装');

-- 插入包装（每个包装一个条码）
INSERT INTO packages (manufacturer_id, status, barcode, item_count, remarks) VALUES
(1, 'packing', 'PKG-0001', 2, '打包发往广州'),
(2, 'shipped', 'PKG-0002', 1, '已发出');

-- 插入包装明细（绑定产品到包装）
INSERT INTO package_items (package_id, product_id) VALUES
(1, 1),
(1, 2),
(2, 3);

USE shop_db;

-- 插入店铺
INSERT INTO shops (name, location, remarks) VALUES
('广州旗舰店', '广州市天河区体育东路123号', '主要销售智能产品'),
('成都分店', '成都市高新区软件园', '');

-- 插入店员
INSERT INTO shop_staff (shop_id, name, position, remarks) VALUES
(1, '张三', '销售', ''),
(1, '李四', '仓管', ''),
(2, '王五', '店长', '');

-- 模拟扫码入库（从包装扫码后，生成多个入库记录）
INSERT INTO inbound_records (shop_id, product_id, date, quantity, operator, remarks) VALUES
(1, 1, '2025-03-30', 1, '李四', '扫码入库'),
(1, 2, '2025-03-30', 1, '李四', '扫码入库');

-- 插入库存初始化（可结合后台处理）
INSERT INTO inventory (shop_id, product_id, current_quantity, inbound_total, outbound_total, alert_low, alert_high) VALUES
(1, 1, 1, 1, 0, 1, 100),
(1, 2, 1, 1, 0, 1, 100);

-- 模拟扫码出库
INSERT INTO outbound_records (shop_id, product_id, date, quantity, operator, remarks) VALUES
(1, 1, '2025-03-31', 1, '张三', '发货给客户');

-- 更新库存（模拟后台逻辑）
UPDATE inventory SET current_quantity = 0, outbound_total = 1 WHERE shop_id = 1 AND product_id = 1;
