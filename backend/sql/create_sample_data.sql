INSERT INTO core_db.users (username, password, role_id, created_at, updated_at) VALUES ('user1', '123456', 4, '2025-02-10 00:00:00', '2025-02-10 00:00:00');
INSERT INTO core_db.users (username, password, role_id, created_at, updated_at) VALUES ('user2', '123456', 5, '2025-03-23 00:00:00', '2025-03-23 00:00:00');
INSERT INTO core_db.users (username, password, role_id, created_at, updated_at) VALUES ('user3', '123456', 2, '2025-03-12 00:00:00', '2025-03-12 00:00:00');
INSERT INTO core_db.users (username, password, role_id, created_at, updated_at) VALUES ('user4', '123456', 4, '2025-02-26 00:00:00', '2025-02-26 00:00:00');
INSERT INTO core_db.users (username, password, role_id, created_at, updated_at) VALUES ('user5', '123456', 5, '2025-02-03 00:00:00', '2025-02-03 00:00:00');
INSERT INTO core_db.users (username, password, role_id, created_at, updated_at) VALUES ('user6', '123456', 1, '2025-03-12 00:00:00', '2025-03-12 00:00:00');
INSERT INTO core_db.users (username, password, role_id, created_at, updated_at) VALUES ('user7', '123456', 1, '2025-01-12 00:00:00', '2025-01-12 00:00:00');
INSERT INTO core_db.users (username, password, role_id, created_at, updated_at) VALUES ('user8', '123456', 4, '2025-03-27 00:00:00', '2025-03-27 00:00:00');
INSERT INTO core_db.users (username, password, role_id, created_at, updated_at) VALUES ('user9', '123456', 1, '2025-03-20 00:00:00', '2025-03-20 00:00:00');
INSERT INTO core_db.users (username, password, role_id, created_at, updated_at) VALUES ('user10', '123456', 4, '2025-02-12 00:00:00', '2025-02-12 00:00:00');
INSERT INTO core_db.users (username, password, role_id, created_at, updated_at) VALUES ('user11', '123456', 2, '2025-02-11 00:00:00', '2025-02-11 00:00:00');
INSERT INTO core_db.users (username, password, role_id, created_at, updated_at) VALUES ('user12', '123456', 1, '2025-01-25 00:00:00', '2025-01-25 00:00:00');
INSERT INTO core_db.users (username, password, role_id, created_at, updated_at) VALUES ('user13', '123456', 5, '2025-01-29 00:00:00', '2025-01-29 00:00:00');
INSERT INTO core_db.users (username, password, role_id, created_at, updated_at) VALUES ('user14', '123456', 2, '2025-01-19 00:00:00', '2025-01-19 00:00:00');
INSERT INTO core_db.users (username, password, role_id, created_at, updated_at) VALUES ('user15', '123456', 5, '2025-02-27 00:00:00', '2025-02-27 00:00:00');
INSERT INTO core_db.users (username, password, role_id, created_at, updated_at) VALUES ('user16', '123456', 1, '2025-01-11 00:00:00', '2025-01-11 00:00:00');
INSERT INTO core_db.users (username, password, role_id, created_at, updated_at) VALUES ('user17', '123456', 3, '2025-03-07 00:00:00', '2025-03-07 00:00:00');
INSERT INTO core_db.users (username, password, role_id, created_at, updated_at) VALUES ('user18', '123456', 4, '2025-01-14 00:00:00', '2025-01-14 00:00:00');
INSERT INTO core_db.users (username, password, role_id, created_at, updated_at) VALUES ('user19', '123456', 3, '2025-03-12 00:00:00', '2025-03-12 00:00:00');
INSERT INTO core_db.users (username, password, role_id, created_at, updated_at) VALUES ('user20', '123456', 3, '2025-01-16 00:00:00', '2025-01-16 00:00:00');
INSERT INTO core_db.users (username, password, role_id, created_at, updated_at) VALUES ('user21', '123456', 5, '2025-02-12 00:00:00', '2025-02-12 00:00:00');
INSERT INTO core_db.users (username, password, role_id, created_at, updated_at) VALUES ('user22', '123456', 5, '2025-01-27 00:00:00', '2025-01-27 00:00:00');
INSERT INTO core_db.users (username, password, role_id, created_at, updated_at) VALUES ('user23', '123456', 5, '2025-03-12 00:00:00', '2025-03-12 00:00:00');
INSERT INTO core_db.users (username, password, role_id, created_at, updated_at) VALUES ('user24', '123456', 5, '2025-02-06 00:00:00', '2025-02-06 00:00:00');
INSERT INTO core_db.users (username, password, role_id, created_at, updated_at) VALUES ('user25', '123456', 4, '2025-01-12 00:00:00', '2025-01-12 00:00:00');
INSERT INTO core_db.users (username, password, role_id, created_at, updated_at) VALUES ('user26', '123456', 5, '2025-02-19 00:00:00', '2025-02-19 00:00:00');
INSERT INTO core_db.users (username, password, role_id, created_at, updated_at) VALUES ('user27', '123456', 3, '2025-03-15 00:00:00', '2025-03-15 00:00:00');
INSERT INTO core_db.users (username, password, role_id, created_at, updated_at) VALUES ('user28', '123456', 2, '2025-02-07 00:00:00', '2025-02-07 00:00:00');
INSERT INTO core_db.users (username, password, role_id, created_at, updated_at) VALUES ('user29', '123456', 2, '2025-01-25 00:00:00', '2025-01-25 00:00:00');
INSERT INTO core_db.users (username, password, role_id, created_at, updated_at) VALUES ('user30', '123456', 2, '2025-01-05 00:00:00', '2025-01-05 00:00:00');
INSERT IGNORE INTO permissions (role_id, role_name) VALUES
(1, 'admin'),
(2, 'shop'),
(3, 'shop_staff'),
(4, 'manufacturer'),
(5, 'manufacturer_staff');

INSERT INTO manufacturer_db.manufacturers (name, location, remarks) VALUES ('厂家1', '位置1', '备注1');
INSERT INTO manufacturer_db.manufacturers (name, location, remarks) VALUES ('厂家2', '位置2', '备注2');
INSERT INTO manufacturer_db.manufacturers (name, location, remarks) VALUES ('厂家3', '位置3', '备注3');
INSERT INTO manufacturer_db.manufacturers (name, location, remarks) VALUES ('厂家4', '位置4', '备注4');
INSERT INTO manufacturer_db.manufacturers (name, location, remarks) VALUES ('厂家5', '位置5', '备注5');
INSERT INTO manufacturer_db.manufacturers (name, location, remarks) VALUES ('厂家6', '位置6', '备注6');
INSERT INTO manufacturer_db.manufacturers (name, location, remarks) VALUES ('厂家7', '位置7', '备注7');
INSERT INTO manufacturer_db.manufacturers (name, location, remarks) VALUES ('厂家8', '位置8', '备注8');
INSERT INTO manufacturer_db.manufacturers (name, location, remarks) VALUES ('厂家9', '位置9', '备注9');
INSERT INTO manufacturer_db.manufacturers (name, location, remarks) VALUES ('厂家10', '位置10', '备注10');
INSERT INTO manufacturer_db.manufacturers (name, location, remarks) VALUES ('厂家11', '位置11', '备注11');
INSERT INTO manufacturer_db.manufacturers (name, location, remarks) VALUES ('厂家12', '位置12', '备注12');
INSERT INTO manufacturer_db.manufacturers (name, location, remarks) VALUES ('厂家13', '位置13', '备注13');
INSERT INTO manufacturer_db.manufacturers (name, location, remarks) VALUES ('厂家14', '位置14', '备注14');
INSERT INTO manufacturer_db.manufacturers (name, location, remarks) VALUES ('厂家15', '位置15', '备注15');
INSERT INTO manufacturer_db.manufacturers (name, location, remarks) VALUES ('厂家16', '位置16', '备注16');
INSERT INTO manufacturer_db.manufacturers (name, location, remarks) VALUES ('厂家17', '位置17', '备注17');
INSERT INTO manufacturer_db.manufacturers (name, location, remarks) VALUES ('厂家18', '位置18', '备注18');
INSERT INTO manufacturer_db.manufacturers (name, location, remarks) VALUES ('厂家19', '位置19', '备注19');
INSERT INTO manufacturer_db.manufacturers (name, location, remarks) VALUES ('厂家20', '位置20', '备注20');
INSERT INTO manufacturer_db.manufacturers (name, location, remarks) VALUES ('厂家21', '位置21', '备注21');
INSERT INTO manufacturer_db.manufacturers (name, location, remarks) VALUES ('厂家22', '位置22', '备注22');
INSERT INTO manufacturer_db.manufacturers (name, location, remarks) VALUES ('厂家23', '位置23', '备注23');
INSERT INTO manufacturer_db.manufacturers (name, location, remarks) VALUES ('厂家24', '位置24', '备注24');
INSERT INTO manufacturer_db.manufacturers (name, location, remarks) VALUES ('厂家25', '位置25', '备注25');
INSERT INTO manufacturer_db.manufacturers (name, location, remarks) VALUES ('厂家26', '位置26', '备注26');
INSERT INTO manufacturer_db.manufacturers (name, location, remarks) VALUES ('厂家27', '位置27', '备注27');
INSERT INTO manufacturer_db.manufacturers (name, location, remarks) VALUES ('厂家28', '位置28', '备注28');
INSERT INTO manufacturer_db.manufacturers (name, location, remarks) VALUES ('厂家29', '位置29', '备注29');
INSERT INTO manufacturer_db.manufacturers (name, location, remarks) VALUES ('厂家30', '位置30', '备注30');
INSERT INTO manufacturer_db.manufacturer_staff (manufacturer_id, name, position, remarks) VALUES (2, '员工1', '职位1', '备注1');
INSERT INTO manufacturer_db.manufacturer_staff (manufacturer_id, name, position, remarks) VALUES (3, '员工2', '职位2', '备注2');
INSERT INTO manufacturer_db.manufacturer_staff (manufacturer_id, name, position, remarks) VALUES (4, '员工3', '职位3', '备注3');
INSERT INTO manufacturer_db.manufacturer_staff (manufacturer_id, name, position, remarks) VALUES (5, '员工4', '职位4', '备注4');
INSERT INTO manufacturer_db.manufacturer_staff (manufacturer_id, name, position, remarks) VALUES (6, '员工5', '职位5', '备注5');
INSERT INTO manufacturer_db.manufacturer_staff (manufacturer_id, name, position, remarks) VALUES (7, '员工6', '职位6', '备注6');
INSERT INTO manufacturer_db.manufacturer_staff (manufacturer_id, name, position, remarks) VALUES (8, '员工7', '职位7', '备注7');
INSERT INTO manufacturer_db.manufacturer_staff (manufacturer_id, name, position, remarks) VALUES (9, '员工8', '职位8', '备注8');
INSERT INTO manufacturer_db.manufacturer_staff (manufacturer_id, name, position, remarks) VALUES (10, '员工9', '职位9', '备注9');
INSERT INTO manufacturer_db.manufacturer_staff (manufacturer_id, name, position, remarks) VALUES (1, '员工10', '职位10', '备注10');
INSERT INTO manufacturer_db.manufacturer_staff (manufacturer_id, name, position, remarks) VALUES (2, '员工11', '职位11', '备注11');
INSERT INTO manufacturer_db.manufacturer_staff (manufacturer_id, name, position, remarks) VALUES (3, '员工12', '职位12', '备注12');
INSERT INTO manufacturer_db.manufacturer_staff (manufacturer_id, name, position, remarks) VALUES (4, '员工13', '职位13', '备注13');
INSERT INTO manufacturer_db.manufacturer_staff (manufacturer_id, name, position, remarks) VALUES (5, '员工14', '职位14', '备注14');
INSERT INTO manufacturer_db.manufacturer_staff (manufacturer_id, name, position, remarks) VALUES (6, '员工15', '职位15', '备注15');
INSERT INTO manufacturer_db.manufacturer_staff (manufacturer_id, name, position, remarks) VALUES (7, '员工16', '职位16', '备注16');
INSERT INTO manufacturer_db.manufacturer_staff (manufacturer_id, name, position, remarks) VALUES (8, '员工17', '职位17', '备注17');
INSERT INTO manufacturer_db.manufacturer_staff (manufacturer_id, name, position, remarks) VALUES (9, '员工18', '职位18', '备注18');
INSERT INTO manufacturer_db.manufacturer_staff (manufacturer_id, name, position, remarks) VALUES (10, '员工19', '职位19', '备注19');
INSERT INTO manufacturer_db.manufacturer_staff (manufacturer_id, name, position, remarks) VALUES (1, '员工20', '职位20', '备注20');
INSERT INTO manufacturer_db.manufacturer_staff (manufacturer_id, name, position, remarks) VALUES (2, '员工21', '职位21', '备注21');
INSERT INTO manufacturer_db.manufacturer_staff (manufacturer_id, name, position, remarks) VALUES (3, '员工22', '职位22', '备注22');
INSERT INTO manufacturer_db.manufacturer_staff (manufacturer_id, name, position, remarks) VALUES (4, '员工23', '职位23', '备注23');
INSERT INTO manufacturer_db.manufacturer_staff (manufacturer_id, name, position, remarks) VALUES (5, '员工24', '职位24', '备注24');
INSERT INTO manufacturer_db.manufacturer_staff (manufacturer_id, name, position, remarks) VALUES (6, '员工25', '职位25', '备注25');
INSERT INTO manufacturer_db.manufacturer_staff (manufacturer_id, name, position, remarks) VALUES (7, '员工26', '职位26', '备注26');
INSERT INTO manufacturer_db.manufacturer_staff (manufacturer_id, name, position, remarks) VALUES (8, '员工27', '职位27', '备注27');
INSERT INTO manufacturer_db.manufacturer_staff (manufacturer_id, name, position, remarks) VALUES (9, '员工28', '职位28', '备注28');
INSERT INTO manufacturer_db.manufacturer_staff (manufacturer_id, name, position, remarks) VALUES (10, '员工29', '职位29', '备注29');
INSERT INTO manufacturer_db.manufacturer_staff (manufacturer_id, name, position, remarks) VALUES (1, '员工30', '职位30', '备注30');
INSERT INTO manufacturer_db.products (manufacturer_id, product_code, intl_barcode, name, category, spec, location, remarks) VALUES (2, '{"code":"P001"}', 'INTL001', '产品1', '类别1', '规格1', '库位1', '备注1');
INSERT INTO manufacturer_db.products (manufacturer_id, product_code, intl_barcode, name, category, spec, location, remarks) VALUES (3, '{"code":"P002"}', 'INTL002', '产品2', '类别2', '规格2', '库位2', '备注2');
INSERT INTO manufacturer_db.products (manufacturer_id, product_code, intl_barcode, name, category, spec, location, remarks) VALUES (4, '{"code":"P003"}', 'INTL003', '产品3', '类别3', '规格3', '库位3', '备注3');
INSERT INTO manufacturer_db.products (manufacturer_id, product_code, intl_barcode, name, category, spec, location, remarks) VALUES (5, '{"code":"P004"}', 'INTL004', '产品4', '类别4', '规格4', '库位4', '备注4');
INSERT INTO manufacturer_db.products (manufacturer_id, product_code, intl_barcode, name, category, spec, location, remarks) VALUES (6, '{"code":"P005"}', 'INTL005', '产品5', '类别0', '规格5', '库位5', '备注5');
INSERT INTO manufacturer_db.products (manufacturer_id, product_code, intl_barcode, name, category, spec, location, remarks) VALUES (7, '{"code":"P006"}', 'INTL006', '产品6', '类别1', '规格6', '库位6', '备注6');
INSERT INTO manufacturer_db.products (manufacturer_id, product_code, intl_barcode, name, category, spec, location, remarks) VALUES (8, '{"code":"P007"}', 'INTL007', '产品7', '类别2', '规格7', '库位7', '备注7');
INSERT INTO manufacturer_db.products (manufacturer_id, product_code, intl_barcode, name, category, spec, location, remarks) VALUES (9, '{"code":"P008"}', 'INTL008', '产品8', '类别3', '规格8', '库位8', '备注8');
INSERT INTO manufacturer_db.products (manufacturer_id, product_code, intl_barcode, name, category, spec, location, remarks) VALUES (10, '{"code":"P009"}', 'INTL009', '产品9', '类别4', '规格9', '库位9', '备注9');
INSERT INTO manufacturer_db.products (manufacturer_id, product_code, intl_barcode, name, category, spec, location, remarks) VALUES (1, '{"code":"P010"}', 'INTL010', '产品10', '类别0', '规格10', '库位10', '备注10');
INSERT INTO manufacturer_db.products (manufacturer_id, product_code, intl_barcode, name, category, spec, location, remarks) VALUES (2, '{"code":"P011"}', 'INTL011', '产品11', '类别1', '规格11', '库位11', '备注11');
INSERT INTO manufacturer_db.products (manufacturer_id, product_code, intl_barcode, name, category, spec, location, remarks) VALUES (3, '{"code":"P012"}', 'INTL012', '产品12', '类别2', '规格12', '库位12', '备注12');
INSERT INTO manufacturer_db.products (manufacturer_id, product_code, intl_barcode, name, category, spec, location, remarks) VALUES (4, '{"code":"P013"}', 'INTL013', '产品13', '类别3', '规格13', '库位13', '备注13');
INSERT INTO manufacturer_db.products (manufacturer_id, product_code, intl_barcode, name, category, spec, location, remarks) VALUES (5, '{"code":"P014"}', 'INTL014', '产品14', '类别4', '规格14', '库位14', '备注14');
INSERT INTO manufacturer_db.products (manufacturer_id, product_code, intl_barcode, name, category, spec, location, remarks) VALUES (6, '{"code":"P015"}', 'INTL015', '产品15', '类别0', '规格15', '库位15', '备注15');
INSERT INTO manufacturer_db.products (manufacturer_id, product_code, intl_barcode, name, category, spec, location, remarks) VALUES (7, '{"code":"P016"}', 'INTL016', '产品16', '类别1', '规格16', '库位16', '备注16');
INSERT INTO manufacturer_db.products (manufacturer_id, product_code, intl_barcode, name, category, spec, location, remarks) VALUES (8, '{"code":"P017"}', 'INTL017', '产品17', '类别2', '规格17', '库位17', '备注17');
INSERT INTO manufacturer_db.products (manufacturer_id, product_code, intl_barcode, name, category, spec, location, remarks) VALUES (9, '{"code":"P018"}', 'INTL018', '产品18', '类别3', '规格18', '库位18', '备注18');
INSERT INTO manufacturer_db.products (manufacturer_id, product_code, intl_barcode, name, category, spec, location, remarks) VALUES (10, '{"code":"P019"}', 'INTL019', '产品19', '类别4', '规格19', '库位19', '备注19');
INSERT INTO manufacturer_db.products (manufacturer_id, product_code, intl_barcode, name, category, spec, location, remarks) VALUES (1, '{"code":"P020"}', 'INTL020', '产品20', '类别0', '规格20', '库位20', '备注20');
INSERT INTO manufacturer_db.products (manufacturer_id, product_code, intl_barcode, name, category, spec, location, remarks) VALUES (2, '{"code":"P021"}', 'INTL021', '产品21', '类别1', '规格21', '库位21', '备注21');
INSERT INTO manufacturer_db.products (manufacturer_id, product_code, intl_barcode, name, category, spec, location, remarks) VALUES (3, '{"code":"P022"}', 'INTL022', '产品22', '类别2', '规格22', '库位22', '备注22');
INSERT INTO manufacturer_db.products (manufacturer_id, product_code, intl_barcode, name, category, spec, location, remarks) VALUES (4, '{"code":"P023"}', 'INTL023', '产品23', '类别3', '规格23', '库位23', '备注23');
INSERT INTO manufacturer_db.products (manufacturer_id, product_code, intl_barcode, name, category, spec, location, remarks) VALUES (5, '{"code":"P024"}', 'INTL024', '产品24', '类别4', '规格24', '库位24', '备注24');
INSERT INTO manufacturer_db.products (manufacturer_id, product_code, intl_barcode, name, category, spec, location, remarks) VALUES (6, '{"code":"P025"}', 'INTL025', '产品25', '类别0', '规格25', '库位25', '备注25');
INSERT INTO manufacturer_db.products (manufacturer_id, product_code, intl_barcode, name, category, spec, location, remarks) VALUES (7, '{"code":"P026"}', 'INTL026', '产品26', '类别1', '规格26', '库位26', '备注26');
INSERT INTO manufacturer_db.products (manufacturer_id, product_code, intl_barcode, name, category, spec, location, remarks) VALUES (8, '{"code":"P027"}', 'INTL027', '产品27', '类别2', '规格27', '库位27', '备注27');
INSERT INTO manufacturer_db.products (manufacturer_id, product_code, intl_barcode, name, category, spec, location, remarks) VALUES (9, '{"code":"P028"}', 'INTL028', '产品28', '类别3', '规格28', '库位28', '备注28');
INSERT INTO manufacturer_db.products (manufacturer_id, product_code, intl_barcode, name, category, spec, location, remarks) VALUES (10, '{"code":"P029"}', 'INTL029', '产品29', '类别4', '规格29', '库位29', '备注29');
INSERT INTO manufacturer_db.products (manufacturer_id, product_code, intl_barcode, name, category, spec, location, remarks) VALUES (1, '{"code":"P030"}', 'INTL030', '产品30', '类别0', '规格30', '库位30', '备注30');
INSERT INTO manufacturer_db.packages (manufacturer_id, status, barcode, item_count, remarks) VALUES (2, 'in_transit', 'PKG001', 8, '备注1');
INSERT INTO manufacturer_db.packages (manufacturer_id, status, barcode, item_count, remarks) VALUES (3, 'packing', 'PKG002', 2, '备注2');
INSERT INTO manufacturer_db.packages (manufacturer_id, status, barcode, item_count, remarks) VALUES (4, 'shipped', 'PKG003', 3, '备注3');
INSERT INTO manufacturer_db.packages (manufacturer_id, status, barcode, item_count, remarks) VALUES (5, 'packing', 'PKG004', 2, '备注4');
INSERT INTO manufacturer_db.packages (manufacturer_id, status, barcode, item_count, remarks) VALUES (6, 'delivered', 'PKG005', 9, '备注5');
INSERT INTO manufacturer_db.packages (manufacturer_id, status, barcode, item_count, remarks) VALUES (7, 'in_transit', 'PKG006', 9, '备注6');
INSERT INTO manufacturer_db.packages (manufacturer_id, status, barcode, item_count, remarks) VALUES (8, 'shipped', 'PKG007', 4, '备注7');
INSERT INTO manufacturer_db.packages (manufacturer_id, status, barcode, item_count, remarks) VALUES (9, 'delivered', 'PKG008', 10, '备注8');
INSERT INTO manufacturer_db.packages (manufacturer_id, status, barcode, item_count, remarks) VALUES (10, 'in_transit', 'PKG009', 8, '备注9');
INSERT INTO manufacturer_db.packages (manufacturer_id, status, barcode, item_count, remarks) VALUES (1, 'delivered', 'PKG010', 6, '备注10');
INSERT INTO manufacturer_db.packages (manufacturer_id, status, barcode, item_count, remarks) VALUES (2, 'packing', 'PKG011', 6, '备注11');
INSERT INTO manufacturer_db.packages (manufacturer_id, status, barcode, item_count, remarks) VALUES (3, 'packing', 'PKG012', 8, '备注12');
INSERT INTO manufacturer_db.packages (manufacturer_id, status, barcode, item_count, remarks) VALUES (4, 'in_transit', 'PKG013', 4, '备注13');
INSERT INTO manufacturer_db.packages (manufacturer_id, status, barcode, item_count, remarks) VALUES (5, 'shipped', 'PKG014', 1, '备注14');
INSERT INTO manufacturer_db.packages (manufacturer_id, status, barcode, item_count, remarks) VALUES (6, 'in_transit', 'PKG015', 2, '备注15');
INSERT INTO manufacturer_db.packages (manufacturer_id, status, barcode, item_count, remarks) VALUES (7, 'shipped', 'PKG016', 6, '备注16');
INSERT INTO manufacturer_db.packages (manufacturer_id, status, barcode, item_count, remarks) VALUES (8, 'shipped', 'PKG017', 6, '备注17');
INSERT INTO manufacturer_db.packages (manufacturer_id, status, barcode, item_count, remarks) VALUES (9, 'delivered', 'PKG018', 1, '备注18');
INSERT INTO manufacturer_db.packages (manufacturer_id, status, barcode, item_count, remarks) VALUES (10, 'packing', 'PKG019', 3, '备注19');
INSERT INTO manufacturer_db.packages (manufacturer_id, status, barcode, item_count, remarks) VALUES (1, 'shipped', 'PKG020', 1, '备注20');
INSERT INTO manufacturer_db.packages (manufacturer_id, status, barcode, item_count, remarks) VALUES (2, 'packing', 'PKG021', 1, '备注21');
INSERT INTO manufacturer_db.packages (manufacturer_id, status, barcode, item_count, remarks) VALUES (3, 'packing', 'PKG022', 4, '备注22');
INSERT INTO manufacturer_db.packages (manufacturer_id, status, barcode, item_count, remarks) VALUES (4, 'packing', 'PKG023', 7, '备注23');
INSERT INTO manufacturer_db.packages (manufacturer_id, status, barcode, item_count, remarks) VALUES (5, 'packing', 'PKG024', 6, '备注24');
INSERT INTO manufacturer_db.packages (manufacturer_id, status, barcode, item_count, remarks) VALUES (6, 'packing', 'PKG025', 1, '备注25');
INSERT INTO manufacturer_db.packages (manufacturer_id, status, barcode, item_count, remarks) VALUES (7, 'packing', 'PKG026', 4, '备注26');
INSERT INTO manufacturer_db.packages (manufacturer_id, status, barcode, item_count, remarks) VALUES (8, 'shipped', 'PKG027', 2, '备注27');
INSERT INTO manufacturer_db.packages (manufacturer_id, status, barcode, item_count, remarks) VALUES (9, 'delivered', 'PKG028', 4, '备注28');
INSERT INTO manufacturer_db.packages (manufacturer_id, status, barcode, item_count, remarks) VALUES (10, 'packing', 'PKG029', 1, '备注29');
INSERT INTO manufacturer_db.packages (manufacturer_id, status, barcode, item_count, remarks) VALUES (1, 'delivered', 'PKG030', 10, '备注30');
INSERT INTO manufacturer_db.package_items (package_id, product_id) VALUES (2, 2);
INSERT INTO manufacturer_db.package_items (package_id, product_id) VALUES (3, 3);
INSERT INTO manufacturer_db.package_items (package_id, product_id) VALUES (4, 4);
INSERT INTO manufacturer_db.package_items (package_id, product_id) VALUES (5, 5);
INSERT INTO manufacturer_db.package_items (package_id, product_id) VALUES (6, 6);
INSERT INTO manufacturer_db.package_items (package_id, product_id) VALUES (7, 7);
INSERT INTO manufacturer_db.package_items (package_id, product_id) VALUES (8, 8);
INSERT INTO manufacturer_db.package_items (package_id, product_id) VALUES (9, 9);
INSERT INTO manufacturer_db.package_items (package_id, product_id) VALUES (10, 10);
INSERT INTO manufacturer_db.package_items (package_id, product_id) VALUES (1, 11);
INSERT INTO manufacturer_db.package_items (package_id, product_id) VALUES (2, 12);
INSERT INTO manufacturer_db.package_items (package_id, product_id) VALUES (3, 13);
INSERT INTO manufacturer_db.package_items (package_id, product_id) VALUES (4, 14);
INSERT INTO manufacturer_db.package_items (package_id, product_id) VALUES (5, 15);
INSERT INTO manufacturer_db.package_items (package_id, product_id) VALUES (6, 16);
INSERT INTO manufacturer_db.package_items (package_id, product_id) VALUES (7, 17);
INSERT INTO manufacturer_db.package_items (package_id, product_id) VALUES (8, 18);
INSERT INTO manufacturer_db.package_items (package_id, product_id) VALUES (9, 19);
INSERT INTO manufacturer_db.package_items (package_id, product_id) VALUES (10, 20);
INSERT INTO manufacturer_db.package_items (package_id, product_id) VALUES (1, 21);
INSERT INTO manufacturer_db.package_items (package_id, product_id) VALUES (2, 22);
INSERT INTO manufacturer_db.package_items (package_id, product_id) VALUES (3, 23);
INSERT INTO manufacturer_db.package_items (package_id, product_id) VALUES (4, 24);
INSERT INTO manufacturer_db.package_items (package_id, product_id) VALUES (5, 25);
INSERT INTO manufacturer_db.package_items (package_id, product_id) VALUES (6, 26);
INSERT INTO manufacturer_db.package_items (package_id, product_id) VALUES (7, 27);
INSERT INTO manufacturer_db.package_items (package_id, product_id) VALUES (8, 28);
INSERT INTO manufacturer_db.package_items (package_id, product_id) VALUES (9, 29);
INSERT INTO manufacturer_db.package_items (package_id, product_id) VALUES (10, 30);
INSERT INTO manufacturer_db.package_items (package_id, product_id) VALUES (1, 1);
INSERT INTO shop_db.shops (name, location, remarks) VALUES ('门店1', '地址1', '备注1');
INSERT INTO shop_db.shops (name, location, remarks) VALUES ('门店2', '地址2', '备注2');
INSERT INTO shop_db.shops (name, location, remarks) VALUES ('门店3', '地址3', '备注3');
INSERT INTO shop_db.shops (name, location, remarks) VALUES ('门店4', '地址4', '备注4');
INSERT INTO shop_db.shops (name, location, remarks) VALUES ('门店5', '地址5', '备注5');
INSERT INTO shop_db.shops (name, location, remarks) VALUES ('门店6', '地址6', '备注6');
INSERT INTO shop_db.shops (name, location, remarks) VALUES ('门店7', '地址7', '备注7');
INSERT INTO shop_db.shops (name, location, remarks) VALUES ('门店8', '地址8', '备注8');
INSERT INTO shop_db.shops (name, location, remarks) VALUES ('门店9', '地址9', '备注9');
INSERT INTO shop_db.shops (name, location, remarks) VALUES ('门店10', '地址10', '备注10');
INSERT INTO shop_db.shops (name, location, remarks) VALUES ('门店11', '地址11', '备注11');
INSERT INTO shop_db.shops (name, location, remarks) VALUES ('门店12', '地址12', '备注12');
INSERT INTO shop_db.shops (name, location, remarks) VALUES ('门店13', '地址13', '备注13');
INSERT INTO shop_db.shops (name, location, remarks) VALUES ('门店14', '地址14', '备注14');
INSERT INTO shop_db.shops (name, location, remarks) VALUES ('门店15', '地址15', '备注15');
INSERT INTO shop_db.shops (name, location, remarks) VALUES ('门店16', '地址16', '备注16');
INSERT INTO shop_db.shops (name, location, remarks) VALUES ('门店17', '地址17', '备注17');
INSERT INTO shop_db.shops (name, location, remarks) VALUES ('门店18', '地址18', '备注18');
INSERT INTO shop_db.shops (name, location, remarks) VALUES ('门店19', '地址19', '备注19');
INSERT INTO shop_db.shops (name, location, remarks) VALUES ('门店20', '地址20', '备注20');
INSERT INTO shop_db.shops (name, location, remarks) VALUES ('门店21', '地址21', '备注21');
INSERT INTO shop_db.shops (name, location, remarks) VALUES ('门店22', '地址22', '备注22');
INSERT INTO shop_db.shops (name, location, remarks) VALUES ('门店23', '地址23', '备注23');
INSERT INTO shop_db.shops (name, location, remarks) VALUES ('门店24', '地址24', '备注24');
INSERT INTO shop_db.shops (name, location, remarks) VALUES ('门店25', '地址25', '备注25');
INSERT INTO shop_db.shops (name, location, remarks) VALUES ('门店26', '地址26', '备注26');
INSERT INTO shop_db.shops (name, location, remarks) VALUES ('门店27', '地址27', '备注27');
INSERT INTO shop_db.shops (name, location, remarks) VALUES ('门店28', '地址28', '备注28');
INSERT INTO shop_db.shops (name, location, remarks) VALUES ('门店29', '地址29', '备注29');
INSERT INTO shop_db.shops (name, location, remarks) VALUES ('门店30', '地址30', '备注30');
INSERT INTO shop_db.shop_staff (shop_id, name, position, remarks) VALUES (2, '店员1', '职位1', '备注1');
INSERT INTO shop_db.shop_staff (shop_id, name, position, remarks) VALUES (3, '店员2', '职位2', '备注2');
INSERT INTO shop_db.shop_staff (shop_id, name, position, remarks) VALUES (4, '店员3', '职位3', '备注3');
INSERT INTO shop_db.shop_staff (shop_id, name, position, remarks) VALUES (5, '店员4', '职位4', '备注4');
INSERT INTO shop_db.shop_staff (shop_id, name, position, remarks) VALUES (6, '店员5', '职位5', '备注5');
INSERT INTO shop_db.shop_staff (shop_id, name, position, remarks) VALUES (7, '店员6', '职位6', '备注6');
INSERT INTO shop_db.shop_staff (shop_id, name, position, remarks) VALUES (8, '店员7', '职位7', '备注7');
INSERT INTO shop_db.shop_staff (shop_id, name, position, remarks) VALUES (9, '店员8', '职位8', '备注8');
INSERT INTO shop_db.shop_staff (shop_id, name, position, remarks) VALUES (10, '店员9', '职位9', '备注9');
INSERT INTO shop_db.shop_staff (shop_id, name, position, remarks) VALUES (1, '店员10', '职位10', '备注10');
INSERT INTO shop_db.shop_staff (shop_id, name, position, remarks) VALUES (2, '店员11', '职位11', '备注11');
INSERT INTO shop_db.shop_staff (shop_id, name, position, remarks) VALUES (3, '店员12', '职位12', '备注12');
INSERT INTO shop_db.shop_staff (shop_id, name, position, remarks) VALUES (4, '店员13', '职位13', '备注13');
INSERT INTO shop_db.shop_staff (shop_id, name, position, remarks) VALUES (5, '店员14', '职位14', '备注14');
INSERT INTO shop_db.shop_staff (shop_id, name, position, remarks) VALUES (6, '店员15', '职位15', '备注15');
INSERT INTO shop_db.shop_staff (shop_id, name, position, remarks) VALUES (7, '店员16', '职位16', '备注16');
INSERT INTO shop_db.shop_staff (shop_id, name, position, remarks) VALUES (8, '店员17', '职位17', '备注17');
INSERT INTO shop_db.shop_staff (shop_id, name, position, remarks) VALUES (9, '店员18', '职位18', '备注18');
INSERT INTO shop_db.shop_staff (shop_id, name, position, remarks) VALUES (10, '店员19', '职位19', '备注19');
INSERT INTO shop_db.shop_staff (shop_id, name, position, remarks) VALUES (1, '店员20', '职位20', '备注20');
INSERT INTO shop_db.shop_staff (shop_id, name, position, remarks) VALUES (2, '店员21', '职位21', '备注21');
INSERT INTO shop_db.shop_staff (shop_id, name, position, remarks) VALUES (3, '店员22', '职位22', '备注22');
INSERT INTO shop_db.shop_staff (shop_id, name, position, remarks) VALUES (4, '店员23', '职位23', '备注23');
INSERT INTO shop_db.shop_staff (shop_id, name, position, remarks) VALUES (5, '店员24', '职位24', '备注24');
INSERT INTO shop_db.shop_staff (shop_id, name, position, remarks) VALUES (6, '店员25', '职位25', '备注25');
INSERT INTO shop_db.shop_staff (shop_id, name, position, remarks) VALUES (7, '店员26', '职位26', '备注26');
INSERT INTO shop_db.shop_staff (shop_id, name, position, remarks) VALUES (8, '店员27', '职位27', '备注27');
INSERT INTO shop_db.shop_staff (shop_id, name, position, remarks) VALUES (9, '店员28', '职位28', '备注28');
INSERT INTO shop_db.shop_staff (shop_id, name, position, remarks) VALUES (10, '店员29', '职位29', '备注29');
INSERT INTO shop_db.shop_staff (shop_id, name, position, remarks) VALUES (1, '店员30', '职位30', '备注30');
INSERT INTO shop_db.inbound_records (shop_id, product_id, date, quantity, operator, remarks) VALUES (2, 2, '2025-03-04', 43, '张三1', '入库备注1');
INSERT INTO shop_db.inbound_records (shop_id, product_id, date, quantity, operator, remarks) VALUES (3, 3, '2025-03-03', 38, '张三2', '入库备注2');
INSERT INTO shop_db.inbound_records (shop_id, product_id, date, quantity, operator, remarks) VALUES (4, 4, '2025-03-03', 92, '张三3', '入库备注3');
INSERT INTO shop_db.inbound_records (shop_id, product_id, date, quantity, operator, remarks) VALUES (5, 5, '2025-03-10', 54, '张三4', '入库备注4');
INSERT INTO shop_db.inbound_records (shop_id, product_id, date, quantity, operator, remarks) VALUES (6, 6, '2025-03-14', 33, '张三5', '入库备注5');
INSERT INTO shop_db.inbound_records (shop_id, product_id, date, quantity, operator, remarks) VALUES (7, 7, '2025-03-02', 74, '张三6', '入库备注6');
INSERT INTO shop_db.inbound_records (shop_id, product_id, date, quantity, operator, remarks) VALUES (8, 8, '2025-03-15', 15, '张三7', '入库备注7');
INSERT INTO shop_db.inbound_records (shop_id, product_id, date, quantity, operator, remarks) VALUES (9, 9, '2025-03-20', 22, '张三8', '入库备注8');
INSERT INTO shop_db.inbound_records (shop_id, product_id, date, quantity, operator, remarks) VALUES (10, 10, '2025-03-23', 60, '张三9', '入库备注9');
INSERT INTO shop_db.inbound_records (shop_id, product_id, date, quantity, operator, remarks) VALUES (1, 11, '2025-03-07', 43, '张三10', '入库备注10');
INSERT INTO shop_db.inbound_records (shop_id, product_id, date, quantity, operator, remarks) VALUES (2, 12, '2025-03-12', 70, '张三11', '入库备注11');
INSERT INTO shop_db.inbound_records (shop_id, product_id, date, quantity, operator, remarks) VALUES (3, 13, '2025-03-27', 82, '张三12', '入库备注12');
INSERT INTO shop_db.inbound_records (shop_id, product_id, date, quantity, operator, remarks) VALUES (4, 14, '2025-03-06', 99, '张三13', '入库备注13');
INSERT INTO shop_db.inbound_records (shop_id, product_id, date, quantity, operator, remarks) VALUES (5, 15, '2025-03-22', 36, '张三14', '入库备注14');
INSERT INTO shop_db.inbound_records (shop_id, product_id, date, quantity, operator, remarks) VALUES (6, 16, '2025-03-25', 17, '张三15', '入库备注15');
INSERT INTO shop_db.inbound_records (shop_id, product_id, date, quantity, operator, remarks) VALUES (7, 17, '2025-03-26', 96, '张三16', '入库备注16');
INSERT INTO shop_db.inbound_records (shop_id, product_id, date, quantity, operator, remarks) VALUES (8, 18, '2025-03-06', 30, '张三17', '入库备注17');
INSERT INTO shop_db.inbound_records (shop_id, product_id, date, quantity, operator, remarks) VALUES (9, 19, '2025-03-11', 77, '张三18', '入库备注18');
INSERT INTO shop_db.inbound_records (shop_id, product_id, date, quantity, operator, remarks) VALUES (10, 20, '2025-03-09', 25, '张三19', '入库备注19');
INSERT INTO shop_db.inbound_records (shop_id, product_id, date, quantity, operator, remarks) VALUES (1, 21, '2025-03-20', 66, '张三20', '入库备注20');
INSERT INTO shop_db.inbound_records (shop_id, product_id, date, quantity, operator, remarks) VALUES (2, 22, '2025-03-22', 32, '张三21', '入库备注21');
INSERT INTO shop_db.inbound_records (shop_id, product_id, date, quantity, operator, remarks) VALUES (3, 23, '2025-03-01', 70, '张三22', '入库备注22');
INSERT INTO shop_db.inbound_records (shop_id, product_id, date, quantity, operator, remarks) VALUES (4, 24, '2025-03-22', 62, '张三23', '入库备注23');
INSERT INTO shop_db.inbound_records (shop_id, product_id, date, quantity, operator, remarks) VALUES (5, 25, '2025-03-19', 75, '张三24', '入库备注24');
INSERT INTO shop_db.inbound_records (shop_id, product_id, date, quantity, operator, remarks) VALUES (6, 26, '2025-03-10', 93, '张三25', '入库备注25');
INSERT INTO shop_db.inbound_records (shop_id, product_id, date, quantity, operator, remarks) VALUES (7, 27, '2025-03-12', 59, '张三26', '入库备注26');
INSERT INTO shop_db.inbound_records (shop_id, product_id, date, quantity, operator, remarks) VALUES (8, 28, '2025-03-27', 94, '张三27', '入库备注27');
INSERT INTO shop_db.inbound_records (shop_id, product_id, date, quantity, operator, remarks) VALUES (9, 29, '2025-03-09', 29, '张三28', '入库备注28');
INSERT INTO shop_db.inbound_records (shop_id, product_id, date, quantity, operator, remarks) VALUES (10, 30, '2025-03-18', 98, '张三29', '入库备注29');
INSERT INTO shop_db.inbound_records (shop_id, product_id, date, quantity, operator, remarks) VALUES (1, 1, '2025-03-01', 68, '张三30', '入库备注30');
INSERT INTO shop_db.outbound_records (shop_id, product_id, date, quantity, operator, remarks) VALUES (2, 2, '2025-03-24', 10, '李四1', '出库备注1');
INSERT INTO shop_db.outbound_records (shop_id, product_id, date, quantity, operator, remarks) VALUES (3, 3, '2025-03-11', 7, '李四2', '出库备注2');
INSERT INTO shop_db.outbound_records (shop_id, product_id, date, quantity, operator, remarks) VALUES (4, 4, '2025-03-18', 22, '李四3', '出库备注3');
INSERT INTO shop_db.outbound_records (shop_id, product_id, date, quantity, operator, remarks) VALUES (5, 5, '2025-03-05', 20, '李四4', '出库备注4');
INSERT INTO shop_db.outbound_records (shop_id, product_id, date, quantity, operator, remarks) VALUES (6, 6, '2025-03-25', 35, '李四5', '出库备注5');
INSERT INTO shop_db.outbound_records (shop_id, product_id, date, quantity, operator, remarks) VALUES (7, 7, '2025-03-12', 44, '李四6', '出库备注6');
INSERT INTO shop_db.outbound_records (shop_id, product_id, date, quantity, operator, remarks) VALUES (8, 8, '2025-03-10', 48, '李四7', '出库备注7');
INSERT INTO shop_db.outbound_records (shop_id, product_id, date, quantity, operator, remarks) VALUES (9, 9, '2025-03-12', 42, '李四8', '出库备注8');
INSERT INTO shop_db.outbound_records (shop_id, product_id, date, quantity, operator, remarks) VALUES (10, 10, '2025-03-21', 44, '李四9', '出库备注9');
INSERT INTO shop_db.outbound_records (shop_id, product_id, date, quantity, operator, remarks) VALUES (1, 11, '2025-03-05', 50, '李四10', '出库备注10');
INSERT INTO shop_db.outbound_records (shop_id, product_id, date, quantity, operator, remarks) VALUES (2, 12, '2025-03-10', 29, '李四11', '出库备注11');
INSERT INTO shop_db.outbound_records (shop_id, product_id, date, quantity, operator, remarks) VALUES (3, 13, '2025-03-24', 31, '李四12', '出库备注12');
INSERT INTO shop_db.outbound_records (shop_id, product_id, date, quantity, operator, remarks) VALUES (4, 14, '2025-03-27', 46, '李四13', '出库备注13');
INSERT INTO shop_db.outbound_records (shop_id, product_id, date, quantity, operator, remarks) VALUES (5, 15, '2025-03-03', 5, '李四14', '出库备注14');
INSERT INTO shop_db.outbound_records (shop_id, product_id, date, quantity, operator, remarks) VALUES (6, 16, '2025-03-20', 17, '李四15', '出库备注15');
INSERT INTO shop_db.outbound_records (shop_id, product_id, date, quantity, operator, remarks) VALUES (7, 17, '2025-03-23', 26, '李四16', '出库备注16');
INSERT INTO shop_db.outbound_records (shop_id, product_id, date, quantity, operator, remarks) VALUES (8, 18, '2025-03-06', 20, '李四17', '出库备注17');
INSERT INTO shop_db.outbound_records (shop_id, product_id, date, quantity, operator, remarks) VALUES (9, 19, '2025-03-08', 45, '李四18', '出库备注18');
INSERT INTO shop_db.outbound_records (shop_id, product_id, date, quantity, operator, remarks) VALUES (10, 20, '2025-03-15', 29, '李四19', '出库备注19');
INSERT INTO shop_db.outbound_records (shop_id, product_id, date, quantity, operator, remarks) VALUES (1, 21, '2025-03-23', 48, '李四20', '出库备注20');
INSERT INTO shop_db.outbound_records (shop_id, product_id, date, quantity, operator, remarks) VALUES (2, 22, '2025-03-19', 31, '李四21', '出库备注21');
INSERT INTO shop_db.outbound_records (shop_id, product_id, date, quantity, operator, remarks) VALUES (3, 23, '2025-03-02', 30, '李四22', '出库备注22');
INSERT INTO shop_db.outbound_records (shop_id, product_id, date, quantity, operator, remarks) VALUES (4, 24, '2025-03-28', 49, '李四23', '出库备注23');
INSERT INTO shop_db.outbound_records (shop_id, product_id, date, quantity, operator, remarks) VALUES (5, 25, '2025-03-19', 31, '李四24', '出库备注24');
INSERT INTO shop_db.outbound_records (shop_id, product_id, date, quantity, operator, remarks) VALUES (6, 26, '2025-03-25', 47, '李四25', '出库备注25');
INSERT INTO shop_db.outbound_records (shop_id, product_id, date, quantity, operator, remarks) VALUES (7, 27, '2025-03-23', 7, '李四26', '出库备注26');
INSERT INTO shop_db.outbound_records (shop_id, product_id, date, quantity, operator, remarks) VALUES (8, 28, '2025-03-06', 33, '李四27', '出库备注27');
INSERT INTO shop_db.outbound_records (shop_id, product_id, date, quantity, operator, remarks) VALUES (9, 29, '2025-03-03', 21, '李四28', '出库备注28');
INSERT INTO shop_db.outbound_records (shop_id, product_id, date, quantity, operator, remarks) VALUES (10, 30, '2025-03-23', 15, '李四29', '出库备注29');
INSERT INTO shop_db.outbound_records (shop_id, product_id, date, quantity, operator, remarks) VALUES (1, 1, '2025-03-15', 38, '李四30', '出库备注30');
INSERT INTO shop_db.inventory (shop_id, product_id, current_quantity, inbound_total, outbound_total, alert_low, alert_high) VALUES (2, 2, 34, 112, 78, 10, 999);
INSERT INTO shop_db.inventory (shop_id, product_id, current_quantity, inbound_total, outbound_total, alert_low, alert_high) VALUES (3, 3, 63, 121, 58, 10, 999);
INSERT INTO shop_db.inventory (shop_id, product_id, current_quantity, inbound_total, outbound_total, alert_low, alert_high) VALUES (4, 4, 126, 146, 20, 10, 999);
INSERT INTO shop_db.inventory (shop_id, product_id, current_quantity, inbound_total, outbound_total, alert_low, alert_high) VALUES (5, 5, 3, 54, 51, 10, 999);
INSERT INTO shop_db.inventory (shop_id, product_id, current_quantity, inbound_total, outbound_total, alert_low, alert_high) VALUES (6, 6, 52, 91, 39, 10, 999);
INSERT INTO shop_db.inventory (shop_id, product_id, current_quantity, inbound_total, outbound_total, alert_low, alert_high) VALUES (7, 7, 86, 109, 23, 10, 999);
INSERT INTO shop_db.inventory (shop_id, product_id, current_quantity, inbound_total, outbound_total, alert_low, alert_high) VALUES (8, 8, 71, 103, 32, 10, 999);
INSERT INTO shop_db.inventory (shop_id, product_id, current_quantity, inbound_total, outbound_total, alert_low, alert_high) VALUES (9, 9, 60, 120, 60, 10, 999);
INSERT INTO shop_db.inventory (shop_id, product_id, current_quantity, inbound_total, outbound_total, alert_low, alert_high) VALUES (10, 10, -13, 60, 73, 10, 999);
INSERT INTO shop_db.inventory (shop_id, product_id, current_quantity, inbound_total, outbound_total, alert_low, alert_high) VALUES (1, 11, 114, 142, 28, 10, 999);
INSERT INTO shop_db.inventory (shop_id, product_id, current_quantity, inbound_total, outbound_total, alert_low, alert_high) VALUES (2, 12, 6, 51, 45, 10, 999);
INSERT INTO shop_db.inventory (shop_id, product_id, current_quantity, inbound_total, outbound_total, alert_low, alert_high) VALUES (3, 13, 90, 136, 46, 10, 999);
INSERT INTO shop_db.inventory (shop_id, product_id, current_quantity, inbound_total, outbound_total, alert_low, alert_high) VALUES (4, 14, 70, 90, 20, 10, 999);
INSERT INTO shop_db.inventory (shop_id, product_id, current_quantity, inbound_total, outbound_total, alert_low, alert_high) VALUES (5, 15, 57, 77, 20, 10, 999);
INSERT INTO shop_db.inventory (shop_id, product_id, current_quantity, inbound_total, outbound_total, alert_low, alert_high) VALUES (6, 16, 73, 141, 68, 10, 999);
INSERT INTO shop_db.inventory (shop_id, product_id, current_quantity, inbound_total, outbound_total, alert_low, alert_high) VALUES (7, 17, -22, 50, 72, 10, 999);
INSERT INTO shop_db.inventory (shop_id, product_id, current_quantity, inbound_total, outbound_total, alert_low, alert_high) VALUES (8, 18, 83, 136, 53, 10, 999);
INSERT INTO shop_db.inventory (shop_id, product_id, current_quantity, inbound_total, outbound_total, alert_low, alert_high) VALUES (9, 19, 102, 128, 26, 10, 999);
INSERT INTO shop_db.inventory (shop_id, product_id, current_quantity, inbound_total, outbound_total, alert_low, alert_high) VALUES (10, 20, 47, 74, 27, 10, 999);
INSERT INTO shop_db.inventory (shop_id, product_id, current_quantity, inbound_total, outbound_total, alert_low, alert_high) VALUES (1, 21, 66, 127, 61, 10, 999);
INSERT INTO shop_db.inventory (shop_id, product_id, current_quantity, inbound_total, outbound_total, alert_low, alert_high) VALUES (2, 22, 0, 75, 75, 10, 999);
INSERT INTO shop_db.inventory (shop_id, product_id, current_quantity, inbound_total, outbound_total, alert_low, alert_high) VALUES (3, 23, 51, 88, 37, 10, 999);
INSERT INTO shop_db.inventory (shop_id, product_id, current_quantity, inbound_total, outbound_total, alert_low, alert_high) VALUES (4, 24, 107, 138, 31, 10, 999);
INSERT INTO shop_db.inventory (shop_id, product_id, current_quantity, inbound_total, outbound_total, alert_low, alert_high) VALUES (5, 25, 12, 62, 50, 10, 999);
INSERT INTO shop_db.inventory (shop_id, product_id, current_quantity, inbound_total, outbound_total, alert_low, alert_high) VALUES (6, 26, 40, 100, 60, 10, 999);
INSERT INTO shop_db.inventory (shop_id, product_id, current_quantity, inbound_total, outbound_total, alert_low, alert_high) VALUES (7, 27, 39, 60, 21, 10, 999);
INSERT INTO shop_db.inventory (shop_id, product_id, current_quantity, inbound_total, outbound_total, alert_low, alert_high) VALUES (8, 28, 7, 85, 78, 10, 999);
INSERT INTO shop_db.inventory (shop_id, product_id, current_quantity, inbound_total, outbound_total, alert_low, alert_high) VALUES (9, 29, 36, 107, 71, 10, 999);
INSERT INTO shop_db.inventory (shop_id, product_id, current_quantity, inbound_total, outbound_total, alert_low, alert_high) VALUES (10, 30, -11, 64, 75, 10, 999);
INSERT INTO shop_db.inventory (shop_id, product_id, current_quantity, inbound_total, outbound_total, alert_low, alert_high) VALUES (1, 1, 54, 82, 28, 10, 999);

INSERT INTO shop_daily_stats (shop_id, date, total_in, total_out, stock)
VALUES
(1, '2025-03-01', 19, 10, 119),
(1, '2025-03-02', 17, 7, 129),
(1, '2025-03-03', 14, 12, 131),
(1, '2025-03-04', 21, 17, 135),
(1, '2025-03-05', 20, 19, 136),
(1, '2025-03-06', 12, 25, 123),
(1, '2025-03-07', 28, 7, 144),
(1, '2025-03-08', 29, 19, 154),
(1, '2025-03-09', 30, 18, 166),
(1, '2025-03-10', 20, 5, 181),
(1, '2025-03-11', 11, 7, 185),
(1, '2025-03-12', 10, 22, 173),
(1, '2025-03-13', 24, 9, 188),
(1, '2025-03-14', 23, 16, 195),
(1, '2025-03-15', 11, 12, 194),
(1, '2025-03-16', 22, 22, 194),
(1, '2025-03-17', 19, 12, 201),
(1, '2025-03-18', 20, 14, 207),
(1, '2025-03-19', 18, 14, 211),
(1, '2025-03-20', 22, 17, 216),
(1, '2025-03-21', 19, 13, 222),
(1, '2025-03-22', 27, 24, 225),
(1, '2025-03-23', 26, 10, 241),
(1, '2025-03-24', 30, 5, 266),
(1, '2025-03-25', 26, 11, 281),
(1, '2025-03-26', 13, 6, 288),
(1, '2025-03-27', 11, 9, 290),
(1, '2025-03-28', 12, 14, 288),
(1, '2025-03-29', 17, 15, 290),
(1, '2025-03-30', 27, 24, 293),
(1, '2025-03-31', 11, 8, 296),
(1, '2025-04-01', 12, 24, 284),
(1, '2025-04-02', 21, 22, 283),
(1, '2025-04-03', 14, 12, 285),
(1, '2025-04-04', 17, 20, 282),
(1, '2025-04-05', 24, 13, 293),
(1, '2025-04-06', 15, 8, 300),
(1, '2025-04-07', 14, 17, 297),
(1, '2025-04-08', 26, 9, 314),
(1, '2025-04-09', 28, 23, 319),
(1, '2025-04-10', 14, 12, 321),
(1, '2025-04-11', 29, 23, 327),
(1, '2025-04-12', 14, 24, 317),
(1, '2025-04-13', 29, 17, 329),
(1, '2025-04-14', 24, 9, 344),
(1, '2025-04-15', 26, 20, 350),
(1, '2025-04-16', 27, 17, 360),
(1, '2025-04-17', 29, 14, 375),
(1, '2025-04-18', 21, 17, 379),
(1, '2025-04-19', 27, 6, 400),
(2, '2025-03-01', 18, 7, 131),
(2, '2025-03-02', 18, 21, 128),
(2, '2025-03-03', 29, 8, 149),
(2, '2025-03-04', 29, 13, 165),
(2, '2025-03-05', 22, 14, 173),
(2, '2025-03-06', 30, 9, 194),
(2, '2025-03-07', 14, 14, 194),
(2, '2025-03-08', 15, 15, 194),
(2, '2025-03-09', 22, 10, 206),
(2, '2025-03-10', 25, 8, 223),
(2, '2025-03-11', 10, 19, 214),
(2, '2025-03-12', 15, 9, 220),
(2, '2025-03-13', 30, 22, 228),
(2, '2025-03-14', 16, 13, 231),
(2, '2025-03-15', 21, 22, 230),
(2, '2025-03-16', 10, 24, 216),
(2, '2025-03-17', 20, 10, 226),
(2, '2025-03-18', 17, 15, 228),
(2, '2025-03-19', 29, 8, 249),
(2, '2025-03-20', 26, 23, 252),
(2, '2025-03-21', 20, 9, 263),
(2, '2025-03-22', 30, 20, 273),
(2, '2025-03-23', 13, 17, 269),
(2, '2025-03-24', 14, 12, 271),
(2, '2025-03-25', 13, 22, 262),
(2, '2025-03-26', 17, 12, 267),
(2, '2025-03-27', 17, 15, 269),
(2, '2025-03-28', 10, 19, 260),
(2, '2025-03-29', 28, 20, 268),
(2, '2025-03-30', 20, 12, 276),
(2, '2025-03-31', 11, 8, 279),
(2, '2025-04-01', 28, 21, 286),
(2, '2025-04-02', 21, 24, 283),
(2, '2025-04-03', 16, 23, 276),
(2, '2025-04-04', 24, 18, 282),
(2, '2025-04-05', 12, 16, 278),
(2, '2025-04-06', 29, 13, 294),
(2, '2025-04-07', 10, 18, 286),
(2, '2025-04-08', 10, 23, 273),
(2, '2025-04-09', 12, 15, 270),
(2, '2025-04-10', 25, 22, 273),
(2, '2025-04-11', 13, 22, 264),
(2, '2025-04-12', 11, 10, 265),
(2, '2025-04-13', 27, 21, 271),
(2, '2025-04-14', 20, 9, 282),
(2, '2025-04-15', 19, 25, 276),
(2, '2025-04-16', 28, 19, 285),
(2, '2025-04-17', 13, 18, 280),
(2, '2025-04-18', 24, 10, 294),
(2, '2025-04-19', 18, 12, 300);