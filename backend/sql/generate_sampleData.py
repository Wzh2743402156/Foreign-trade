from datetime import datetime
import random

# ========== core_db users ==========
core_users_sql = ["USE core_db;", "DELETE FROM users;"]
user_roles = [
    (1, "admin1", 1, None, None),
    (2, "shop_owner1", 2, 1, None),
    (3, "shop_staff1", 3, 1, None),
    (4, "shop_owner2", 2, 2, None),
    (5, "shop_staff2", 3, 2, None),
    (6, "factory_owner1", 4, None, 1),
    (7, "factory_staff1", 5, None, 1),
    (8, "factory_owner2", 4, None, 2),
    (9, "factory_staff2", 5, None, 2),
]
for uid, name, role, shop, factory in user_roles:
    core_users_sql.append(
        f"INSERT INTO users (id, username, password, role_id, shop_id, factory_id) VALUES "
        f"({uid}, '{name}', '123456', {role}, {shop if shop else 'NULL'}, {factory if factory else 'NULL'});"
    )

# ========== factory_db products ==========
factory_sql = ["USE factory_db;", "DELETE FROM products;", "DELETE FROM factories;"]
factory_sql.append("INSERT INTO factories (id, name, location, remarks) VALUES "
                   "(1, '华南工厂', '深圳', '自动生成'),"
                   "(2, '华北工厂', '北京', '自动生成');")

for i in range(1, 201):
    factory_id = 1 if i <= 100 else 2
    code = f"CODE-{1000 + i}"
    barcode = f"6920000{i:06d}"
    name = f"产品{i}"
    category = "电子" if i % 2 == 0 else "机械"
    spec = "7cm*7cm"
    location = f"仓库{'A' if i % 2 == 0 else 'B'}"
    remarks = "自动生成"
    factory_sql.append(
        f"INSERT INTO products (id, factory_id, product_code, intl_barcode, name, category, spec, location, remarks, package_id, package_status) "
        f"VALUES ({i}, {factory_id}, '{code}', '{barcode}', '{name}', '{category}', '{spec}', '{location}', '{remarks}', NULL, 'unbound');"
    )

# ========== shop_db products + inventory ==========
shop_sql = [
    "USE shop_db;",
    "DELETE FROM products;",
    "DELETE FROM shops;",
    "DELETE FROM inventory;"  # 删除旧库存记录
]

shop_sql.append("INSERT INTO shops (id, name, location, remarks) VALUES "
                "(1, '深圳旗舰店', '深圳', '自动生成'),"
                "(2, '北京直营店', '北京', '自动生成');")

for i in range(1, 201):
    shop_id = 1 if i <= 100 else 2
    factory_id = 1 if i <= 100 else 2
    code = f"CODE-{1000 + i}"
    barcode = f"6920000{i:06d}"
    name = f"产品{i}"
    category = "电子" if i % 2 == 0 else "机械"
    spec = "7cm*7cm"
    location = f"货架{i % 10}"
    remarks = "同步工厂"

    # 插入产品信息
    shop_sql.append(
        f"INSERT INTO products (id, shop_id, factory_id, product_code, intl_barcode, name, category, spec, location, remarks, package_id, package_status, status) "
        f"VALUES ({i}, {shop_id}, {factory_id}, '{code}', '{barcode}', '{name}', '{category}', '{spec}', '{location}', '{remarks}', NULL, 'bound', 'in_stock');"
    )

    # 插入库存记录，初始库存10，已出库0
    shop_sql.append(
        f"INSERT INTO inventory (shop_id, product_id, current_quantity, outbound_total) "
        f"VALUES ({shop_id}, {i}, 10, 0);"
    )

# 保存 SQL 脚本
import os

core_path = "./4insert_core_data.sql"
factory_path = "./5insert_factory_data.sql"
shop_path = "./6insert_shop_data.sql"

with open(core_path, "w", encoding="utf-8") as f:
    f.write("\n".join(core_users_sql))

with open(factory_path, "w", encoding="utf-8") as f:
    f.write("\n".join(factory_sql))

with open(shop_path, "w", encoding="utf-8") as f:
    f.write("\n".join(shop_sql))

(core_path, factory_path, shop_path)
