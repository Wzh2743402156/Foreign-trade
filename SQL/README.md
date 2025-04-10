# CloudStock 数据库结构说明文档

> **文件说明：**  
> 1. `databases_init.sql` : &emsp;用于数据库建表
>
> 2. `create_and_insert.sql` : 用于插入 sample 数据
>
> 3. `generate_sample.py`: 用于生成 sample 数据的 SQL 文件

## 一、数据库表结构概览（MySQL）

### 1. `Products` 商品信息表

| 字段名         | 类型           | 描述         |
|----------------|----------------|--------------|
| id             | INT, PK        | 商品主键     |
| factory_id     | INT            | 所属工厂     |
| shop_id        | INT            | 所属门店     |
| name           | VARCHAR(255)   | 商品名称     |
| tag            | JSON           | 商品标签     |
| package_id     | INT            | 关联包裹     |
| status         | INT            | 状态码       |
| code           | VARCHAR(100)   | 商品编码     |
| specification  | VARCHAR(255)   | 商品规格     |
| remark         | TEXT           | 备注         |

### 2. `Packages` 包裹信息表

| 字段名     | 类型         | 描述         |
|------------|--------------|--------------|
| id         | INT, PK      | 包裹主键     |
| num        | INT          | 包裹数量     |
| tag        | JSON         | 标签绑定     |
| status     | INT          | 当前状态     |
| log_id     | INT          | 对应日志ID   |

### 3. `Users` 用户表

| 字段名       | 类型           | 描述         |
|--------------|----------------|--------------|
| id           | INT, PK        | 用户主键     |
| name         | VARCHAR(100)   | 用户姓名     |
| account      | VARCHAR(100)   | 登录账号     |
| password     | VARCHAR(255)   | 密码（加密） |
| factory_id   | INT            | 所属工厂     |
| shop_id      | INT            | 所属门店     |
| permission   | INT            | 权限等级     |
| create_date  | DATETIME       | 创建时间     |
| update_date  | DATETIME       | 更新时间     |

### 4. `Shops` 门店表

| 字段名       | 类型           | 描述         |
|--------------|----------------|--------------|
| id           | INT, PK        | 门店主键     |
| name         | VARCHAR(100)   | 门店名称     |
| location     | VARCHAR(255)   | 地址         |
| create_date  | DATETIME       | 创建时间     |
| update_date  | DATETIME       | 更新时间     |
| remark       | TEXT           | 备注         |

### 5. `Factories` 工厂表

| 字段名       | 类型           | 描述         |
|--------------|----------------|--------------|
| id           | INT, PK        | 工厂主键     |
| name         | VARCHAR(100)   | 工厂名称     |
| location     | VARCHAR(255)   | 地址         |
| create_date  | DATETIME       | 创建时间     |
| update_date  | DATETIME       | 更新时间     |
| remark       | TEXT           | 备注         |

### 6. `Tags` 标签表

| 字段名     | 类型         | 描述             |
|------------|--------------|------------------|
| id         | INT, PK      | 标签主键         |
| name       | VARCHAR(100) | 标签名称         |
| factory_id | INT          | 所属工厂         |
| shop_id    | INT          | 所属门店         |
| inbound    | INT          | 入库累计         |
| outbound   | INT          | 出库累计         |
| stock      | INT          | 当前库存         |
| date       | DATE         | 数据对应日期     |

### 7. `TagLogs` 标签日记录表

| 字段名     | 类型       | 描述           |
|------------|------------|----------------|
| id         | INT, PK    | 主键           |
| tag_id     | INT        | 所属标签       |
| date       | DATE       | 记录日期       |
| inbound    | INT        | 入库数量       |
| outbound   | INT        | 出库数量       |
| stock      | INT        | 当前库存       |

> 唯一约束：`(tag_id, date)` 保证每日一条记录

### 8. `Alert` 库存预警表

| 字段名     | 类型       | 描述         |
|------------|------------|--------------|
| id         | INT, PK    | 主键         |
| tag_id     | INT        | 所属标签     |
| alert_low  | INT        | 下限预警阈值 |
| alert_high | INT        | 上限预警阈值 |

### 9. `Logs` 操作日志表

| 字段名      | 类型            | 描述               |
|-------------|-----------------|--------------------|
| id          | INT, PK         | 主键               |
| action_type | ENUM(...)       | 操作类型（出/入库）|
| operator    | VARCHAR(100)    | 操作人             |
| log_date    | DATETIME        | 操作时间           |
| product_id  | INT             | 关联商品           |
| package_id  | INT             | 关联包裹           |
| remark      | TEXT            | 备注说明           |

> `action_type` 枚举类型包括：`inbound_factory`, `outbound_factory`, `inbound_shop`, `outbound_shop`

## 二、Redis 队列缓存设计

为支持移动端高并发扫码出入库，系统使用 Redis 实现短时缓存与队列机制：

- 员工扫码后，前端将数据打包为 JSON 写入 Redis List（如：`scan_queue`）
- 后台服务通过协程或定时任务批量读取队列内容，写入数据库
- 批处理完成后自动生成对应日志，确保数据完整一致

注：该机制有效降低数据库写入压力，提高扫码响应速度，保障系统在业务高峰期依然平稳运行

## 三、数据管理与追踪机制

- 所有表支持逻辑删除（使用 `deleted_at` 字段），避免数据丢失
- 出入库记录自动生成日志，构建数据可追溯链
- 表间通过外键严格约束，保持数据一致性与规范性

## 四、结构特点与可扩展性

- 数据库结构遵循二范式设计，字段职责清晰
- 支持未来扩展如：用户权限管理、库位管理、日报统计等模块
- 架构兼容分布式部署场景，便于横向扩容与微服务整合
