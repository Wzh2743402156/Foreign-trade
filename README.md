# 🚀 CloudStock 仓储管理系统

> 一个轻量化、高并发支持的外贸企业商品出入库解决方案

---

## 🧱 系统架构总览

| 层级 | 组件 / 模块 | 说明 |
|------|--------------|------|
| 🎨 前端展示层 | `Vue3 + Vite` | 基于模块化 UI 构建，兼容桌面浏览器与 Android WebView 嵌入式扫码操作 |
| 🤖 智能 UI 接入 | `扫码终端 / ESP32 模块` | 实现商品二维码自动采集，自动触发前端入库请求 |
| 🌐 API 网关层 | `JWT 鉴权 + 权限校验` | 用户身份认证、接口分级管理、防止接口滥用与未授权调用 |
| 🧠 应用服务层 | `Golang + Gin` | 独立部署的微服务组件，解耦业务逻辑，如：商品、标签、日志、用户等模块 |
| 🔁 消息队列层 | `Redis List 缓存` | 移动扫码数据 JSON 入队，后端通过协程异步消费写入数据库，缓解并发冲击 |
| 🧩 数据存储层 | `MySQL` | 存储核心业务数据，表结构标准化，支持软删除、时间戳、预警机制 |
| 🧮 数据可视化层 | `前端图表 / 仪表盘组件` | 展示出入库统计、库存状态与标签预警情况 |

---

## 🧾 项目简介

CloudStock 是面向中小型外贸流通企业的仓储管理系统，围绕“扫码即操作、数据即同步”理念，整合商品管理、扫码入库、库存预警、出入库日志追踪等功能，全面提升企业在实际场景下的库存效率与数据透明度。

系统采用分层架构，后端基于 Golang + Gin 框架，前端采用 Vue3 搭配 Vite，支持 Redis 异步缓存与移动端扫码操作，适用于实际场景中高并发、强追踪的出入库管理任务。

---

## 🧩 功能模块

| 模块 | 功能简介 |
|------|----------|
| 📦 商品管理 | 商品录入、库存查询、标签分类、SKU 唯一绑定 |
| 🚚 出入库操作 | 支持扫码快速出/入库，移动端扫码即触发操作 |
| 🔍 日志系统 | 所有操作全流程自动记录，确保可审计可追溯 |
| 🚨 库存预警 | 实时监控库存状态，库存低于阈值自动触发预警 |
| 📊 数据统计 | 支持按时间、标签、商品维度进行出入库统计 |

---

## 📄 文档入口

- 📘 <a href="./docs/CloudStock_PRD.pdf" download>点击下载 PRD 文档（PDF）</a>
- 📐 [📎 原型图预览（Axure 源文件）](./docs/Prototype_Preview.png)
- 💾 [📎 数据库结构设计文档](./SQL/README.md)
- 🔧 [📎 后端接口文档（Swagger/OpenAPI）](./docs/API_Document.md)

---

## 🖼️ 系统界面展示

| 页面 | 预览 |
|------|------|
| 📱 移动端扫码页面 | ![](./screenshots/mobile_scan_demo.png) |
| 🗃️ 商品管理界面 | ![](./screenshots/product_manage.png) |
| 📊 库存统计仪表盘 | ![](./screenshots/statistics_dashboard.png) |

---

## 🏗️ 技术栈概览

- **前端**：Vue3 + Vite + Axios + TailwindCSS
- **后端**：Go + Gin + GORM + Redis + MySQL
- **接口**：RESTful API + JWT 鉴权
- **部署**：Docker 容器化 + 自动化 CI/CD
- **移动端扫码支持**：兼容 Android WebView，支持 ESP32 外部扫码输入

---

## 🧭 项目结构一览

```plaintext
CloudStock/
├── frontend/           # Vue3 前端项目
├── backend/            # Gin 后端服务
├── SQL/                # 数据库结构文档
├── docs/               # 原型图、PRD、API 文档
├── screenshots/        # 系统界面展示图
└── README.md           # 项目总览文档（本文件）
```