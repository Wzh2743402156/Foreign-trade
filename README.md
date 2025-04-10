# 🚀 CloudStock 仓储管理系统

> 一个轻量化、高并发支持的外贸企业商品出入库解决方案

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

- 📘 [📎 PRD 文档下载（PDF）](./docs/CloudStock_PRD.pdf)
- 📐 [📎 原型图预览（Figma 链接或截图）](./docs/Prototype_Preview.png)
- 💾 [📎 数据库结构设计文档](./SQL/README.md)
- 🔧 [📎 后端接口文档（Swagger/OpenAPI）](./docs/API_Document.md)

---

## 🖼️ 系统界面展示（选图示意）

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

CloudStock/ ├── frontend/ # Vue3 项目 ├── backend/ # Gin 后端服务 ├── SQL/ # 数据库结构文档 ├── docs/ # 原型图、PRD、API 文档 ├── screenshots/ # 系统截图展示 ├── README.md # 项目总览说明

yaml
Copy
Edit

---