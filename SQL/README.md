# CloudStock 数据库结构说明文档

> **文件说明：**  
> 1. `databases_init.sql`  
> &emsp;用于数据库建表  
> 2. `create_and_insert.sql`  
> &emsp;用于插入 sample 数据  
> 3. `generate_sample.py`  
> &emsp;用于生成 sample 数据的 SQL 文件  

## 一、数据库表结构概览（MySQL）

### 1. `products` 商品表

| 字段名         | 类型          | 描述           |
|----------------|---------------|----------------|
| id             | BIGINT        | 商品主键       |
| name           | VARCHAR(100)  | 商品名称       |
| sku            | VARCHAR(50)   | 唯一编号       |
| description    | TEXT          | 商品描述       |
| tag_id         | BIGINT        | 所属标签 ID    |
| stock          | INT           | 当前库存数量   |
| alert_threshold| INT           | 预警阈值       |
| created_at     | DATETIME      | 创建时间       |
| updated_at     | DATETIME      | 更新时间       |
| deleted_at     | DATETIME      | 逻辑删除字段   |

### 2. `packages` 出入库记录表

| 字段名     | 类型           | 描述             |
|------------|----------------|------------------|
| id         | BIGINT         | 主键             |
| product_id | BIGINT         | 所属商品         |
| quantity   | INT            | 出/入库数量      |
| type       | ENUM('in','out')| 出入库类型      |
| operator   | VARCHAR(50)    | 操作人           |
| source     | VARCHAR(20)    | 来源渠道（如移动端） |
| note       | TEXT           | 备注信息         |
| created_at | DATETIME       | 操作时间         |

### 3. `logs` 日志表（自动记录）

| 字段名     | 类型       | 描述           |
|------------|------------|----------------|
| id         | BIGINT     | 主键           |
| package_id | BIGINT     | 关联出入库记录 |
| operation  | TEXT       | 操作内容       |
| timestamp  | DATETIME   | 操作时间       |

> 注：系统使用触发器自动生成日志，无需手动记录。

### 4. `tags` 标签表

| 字段名     | 类型         | 描述       |
|------------|--------------|------------|
| id         | BIGINT       | 标签主键   |
| name       | VARCHAR(50)  | 标签名称   |
| description| TEXT         | 标签说明   |
| created_at | DATETIME     | 创建时间   |

### 5. `alerts` 库存预警表

| 字段名        | 类型             | 描述           |
|---------------|------------------|----------------|
| id            | BIGINT           | 主键           |
| product_id    | BIGINT           | 绑定商品       |
| status        | ENUM             | 预警状态       |
| last_triggered| DATETIME         | 最近触发时间   |

## 二、Redis 队列缓存设计

为支持移动端高并发扫码出入库，系统使用 Redis 实现短时缓存与队列机制：

- 员工扫码后，前端将数据打包为 JSON 写入 Redis List（如：`scan_queue`）；
- 后台服务通过协程或定时任务批量读取队列内容，写入数据库；
- 批处理完成后自动生成对应日志，确保数据完整一致。

该机制有效降低数据库写入压力，提高扫码响应速度，保障系统在业务高峰期依然平稳运行。

## 三、数据管理与追踪机制

- 所有表支持逻辑删除（使用 `deleted_at` 字段），避免数据丢失；
- 出入库记录自动生成日志，构建数据可追溯链；
- 表间通过外键严格约束，保持数据一致性与规范性。

## 四、结构特点与可扩展性

- 数据库结构遵循二范式设计，字段职责清晰；
- 支持未来扩展如：用户权限管理、库位管理、日报统计等模块；
- 架构兼容分布式部署场景，便于横向扩容与微服务整合。
