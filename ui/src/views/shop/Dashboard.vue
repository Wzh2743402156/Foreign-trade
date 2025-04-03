<template>
  <div class="dashboard-header">
    <!-- 左侧系统名 -->
    <div class="logo-title">SmartStock 系统</div>

    <!-- 右侧用户信息 -->
    <div class="user-info" @click="goToProfile">
      <div class="info-text">
        <div class="username">{{ username }}</div>
        <div class="role">{{ role }}</div>
      </div>
      <img class="avatar" :src="avatarUrl" alt="avatar" />
    </div>
  </div>
  <div class="shop-dashboard">
    <aside class="sidebar">
      <ul>
        <li :class="{ active: isActive('/shop/inventory') }">
          <router-link to="/shop/inventory">库存信息</router-link>
        </li>
        <li :class="{ active: isActive('/shop/detailcheck') }">
          <router-link to="/shop/detailcheck">商品查询</router-link>
        </li>
        <li :class="{ active: isActive('/shop/notifications') }">
          <router-link to="/shop/notifications">消息通知</router-link>
        </li>
        <li :class="{ active: isActive('/shop/profile') }">
          <router-link to="/shop/profile">个人设置</router-link>
        </li>
      </ul>
    </aside>

    <main class="content">
      <router-view />
    </main>
  </div>
</template>

<script setup>
// 状态栏信息获取
import { useRouter } from 'vue-router'

const router = useRouter()
const username = '管理员'
const role = '店长' // 可从登录信息中动态获取
const avatarUrl = 'https://i.pravatar.cc/40?img=3' // 可替换成你的头像接口

const goToProfile = () => {
  router.push('/shop/profile')
}

import { useRoute } from 'vue-router'
import { defineOptions } from 'vue'

defineOptions({
  name: 'Dashboard'
})

const route = useRoute()

const isActive = (path) => {
  return route.path === path
}
</script>

<style scoped>
.body {
  font-family: 'Arial', sans-serif;
  margin: 0;
  padding: 0; 
}
/* 头部样式 */
.dashboard-header {
  background: #ffffff;
  height: 60px;
  width: auto;
  padding: 0 12px;
  border-bottom: 1px solid #eee;
  display: flex;
  justify-content: space-between;
  align-items: center;
  box-shadow: 0 2px 4px rgba(0,0,0,0.04);
}

.logo-title {
  font-size: 18px;
  font-weight: bold;
  color: #333;
  display: flex;
  align-items: center;
}

.user-info {
  display: flex;
  align-items: center;
  cursor: pointer;
  gap: 12px;
}

.info-text {
  text-align: right;
}

.username {
  font-size: 14px;
  color: #333;
  font-weight: 600;
}

.role {
  font-size: 12px;
  color: #888;
}

.avatar {
  width: 36px;
  height: 36px;
  border-radius: 50%;
  object-fit: cover;
  border: 1px solid #ddd;
}

/* 侧边栏样式 */
.shop-dashboard {
  display: flex;
}
/* sidebar 容器 */
.sidebar {
  width: 180px;
  background-color: #f9f9f9;
  border-right: 1px solid #e5e7eb;
  height: calc(100vh - 60px); /* 减去顶部 header 高度 */
  padding-top: 16px;
  box-shadow: 2px 0 5px rgba(0,0,0,0.03);
}

/* 菜单列表 */
.sidebar ul {
  list-style: none;
  padding: 0;
  margin: 0;
}

/* 每个菜单项 */
.sidebar li {
  margin: 6px 0;
}

.sidebar a {
  display: block;
  padding: 12px 20px;
  text-decoration: none;
  color: #333;
  font-size: 15px;
  border-left: 3px solid transparent;
  transition: all 0.3s ease;
  border-radius: 0 4px 4px 0;
}

.sidebar a:hover {
  background-color: #eef6f2;
  color: #2c7a7b;
}

/* 当前激活项 */
.sidebar li.active a {
  background-color: #42b983;
  color: white;
  border-left: 4px solid #2c7a7b;
  font-weight: bold;
}

</style>