# CloudStock 仓储管理系统

> 让每一笔库存流转都有迹可循，CloudStock 打造真正适用于外贸企业的一站式出入库系统

## 1. 系统架构总览

| 层级 | 组件 / 模块 | 说明 |
|------|--------------|------|
| 前端展示层 | `Vue3 + Vite` | 基于模块化 UI 构建，兼容桌面浏览器与 Android 嵌入式扫码操作 |
| 智能 UI 接入 | `扫码终端` | 实现商品二维码自动采集，自动触发前端入库请求 |
| API 网关层 | `JWT + 权限校验` | 用户身份认证、接口分级管理、防止接口滥用与未授权调用 |
| 应用服务层 | `Golang + Gin` | 独立部署的微服务组件，解耦业务逻辑，如商品、标签、日志等模块 |
| 消息队列层 | `Redis List 缓存` | 移动扫码 JSON 入队，后端通过协程异步消费写入数据库，缓解并发冲击 |
| 数据存储层 | `MySQL` | 存储核心业务数据，表结构标准化，支持软删除、时间戳、预警机制 |
| 数据可视化层 | `图表 / 仪表盘组件` | 展示出入库统计、库存状态与标签预警情况 |

## 2. 项目简介

CloudStock 是一款面向中小型外贸企业的轻量级仓储管理系统，围绕“扫码即操作、数据即同步”理念，集成商品管理、扫码入库、库存预警、出入库日志追踪与权限控制等功能，提升库存流转效率与数据透明度。

针对传统外贸企业依赖人工 Excel 记录、流程杂乱、追溯困难等问题，CloudStock 通过系统化管理，解决库存错漏、包裹丢失、数据断层等常见痛点。系统采用 Golang + Gin 构建后端，Vue3 + Vite 实现前端交互，结合 Redis 缓存与移动端扫码操作，支持高并发、强追踪的出入库业务场景，助力企业实现精细化、可视化管理。

## 3. 功能模块

| 模块 | 功能简介 |
|------|----------|
| 商品管理 | 商品录入、库存查询、标签分类、SKU 唯一绑定 |
| 出入库操作 | 支持扫码快速出/入库，移动端扫码即触发操作 |
| 日志系统 | 所有操作全流程自动记录，确保可审计可追溯 |
| 库存预警 | 实时监控库存状态，库存低于阈值自动触发预警 |
| 数据统计 | 支持按时间、标签、商品维度进行出入库统计 |

## 4. 产品设计内容

- [点击下载 PRD 文档（PDF）](https://github.com/Wzh2743402156/Foreign-trade-UI/raw/main/Docs/CloudStock_PRD_v1.2.pdf?download=1)
- [点击跳转数据库结构设计README.md](./SQL/README.md)
- [原型图预览（Axure源文件和README.md图示）](./Docs/Axure)

## 5. 技术栈概览 & 项目介绍

### 5.1 项目名称：CloudStock 外贸出入库管理系统  
- **项目时间**：2024.03 - 进行中  
- **项目属性**：企业落地项目  
- **担任角色**：产品经理 ｜ 全栈工程师  
- **系统架构**：微服务架构 + RESTful API + JWT 鉴权 + gRPC 通信  

### 5.2 技术栈
| 前端        | 后端               | 数据通信        | 数据存储        | 部署运维               | 移动端支持         |
|-------------|--------------------|------------------|------------------|--------------------------|----------------------|
| Vue3 + Vite | Golang + Gin + gRPC | RESTful API + JWT | MySQL + Redis | Docker + K8s + DevOps | Android + WebView |

### 6. 项目亮点

- 1.构建轻量化库存 SaaS 系统，覆盖商品出入库、条码识别、库存预警、日志追踪与权限管理模块，支持 PC 与移动端扫码同步
- 2.使用 Redis 缓存与 gRPC 通信机制，接口响应速度提升 50%，整体服务延迟降低 40%
- 3.主导系统架构与数据建模，设计并开发超 20 个核心接口，支持权限控制、数据聚合与标签关联统计等复杂业务
- 4.基于 K8s 拆分微服务模块，结合 DevOps 自动化实现代码推送、版本检测与部署，交付效率提升 40%
- 5.独立撰写产品需求文档（PRD）、接口文档与部署规范文档，推动开发与交付协作效率
- 6.移动端兼容 Android WebView，集成扫码模块，支持低功耗扫码与多端数据同步能力

### 7. 项目结构一览

```plaintext
CloudStock/
├── frontend/           # Vue3 前端项目
├── backend/            # Gin 后端服务
├── SQL/                # 数据库结构文档
├── docs/               # 原型图、PRD、API 文档
├── screenshots/        # 系统界面展示图
└── README.md           # 项目总览文档（本文件）
```