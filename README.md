# 📦 CloudStock 仓储管理系统

基于 **Gin + GORM + Vue3** 构建的现代化出入库管理系统，支持条码识别、权限分级、库存预警、可视化分析。

---

## 项目目录

- [项目介绍](#项目介绍)
- [功能模块](#功能模块)
- [数据库表结构](#数据库表结构)
- [接口示例](#接口示例)
- [运行方式](#运行方式)

---

## 项目介绍

CloudStock 致力于提供一套高效、轻量级的出入库与库存管理方案，适用于小型工厂、门店连锁、电商仓库等场景。

---

## 功能模块

- ✅ 用户登录 / 权限管理（支持多角色）
- ✅ 出库入库明细登记
- ✅ 条码管理（支持标准条形码与二维码）
- ✅ 实时库存统计 & 预警
- ✅ 可视化报表：折线图 / 柱状图
- ✅ 店铺权限隔离 & 管理员后台

---

## 数据库表结构

### 1. `users` 用户表
| 字段名 | 类型 | 说明 |
|--------|------|------|
| id | int | 主键 |
| username | varchar | 登录名 |
| password | varchar | 密码（加密） |
| role_id | int | 权限角色（1=admin，2=shop等） |
| shop_id | int | 所属门店（可选） |

### 2. `products` 商品表
| 字段名 | 类型 | 说明 |
|--------|------|------|
| id | int | 主键 |
| name | varchar | 商品名称 |
| barcode | varchar | 条码（唯一） |
| description | text | 说明 |
| unit | varchar | 单位（如箱、瓶） |

### 3. `inbound_records` 入库明细
| 字段名 | 类型 | 说明 |
|--------|------|------|
| id | int | 主键 |
| product_id | int | 商品ID |
| quantity | int | 入库数量 |
| created_at | datetime | 入库时间 |
| operator_id | int | 操作人ID |

### 4. `outbound_records` 出库明细
| 字段名 | 类型 | 说明 |
|--------|------|------|
| id | int | 主键 |
| product_id | int | 商品ID |
| quantity | int | 出库数量 |
| created_at | datetime | 出库时间 |
| operator_id | int | 操作人ID |

### 5. `inventory` 实时库存表
| 字段名 | 类型 | 说明 |
|--------|------|------|
| id | int | 主键 |
| product_id | int | 商品ID |
| current_quantity | int | 当前库存 |

---

## 接口示例

```bash
POST /api/login
{
  "username": "admin",
  "password": "123456"
}
```

返回：

```json
{
  "success": true,
  "message": "登录成功",
  "data": {
    "user_id": 1,
    "token": "xxxx"
  }
}
```

---

## 运行方式

### 后端启动

```bash
cd backend
go mod tidy
go run main.go
```

### 前端启动

```bash
cd frontend
npm install
npm run dev
```
