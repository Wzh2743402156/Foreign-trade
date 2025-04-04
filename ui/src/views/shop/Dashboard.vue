<template>
  <div class="dashboard-layout">
    <!-- 顶部导航栏 -->
    <header class="dashboard-header">
      <div class="header-left">
        <div class="logo-title">
          <span>SmartStock 系统</span>
        </div>
      </div>

      <div class="header-right">
        <div class="notification-indicator" @click="goToNotifications">
          <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path>
            <path d="M13.73 21a2 2 0 0 1-3.46 0"></path>
          </svg>
          <span class="badge" v-if="unreadNotifications > 0">{{ unreadNotifications }}</span>
        </div>
        
        <div class="user-info" @click="goToProfile">
          <div class="info-text">
            <div class="username">{{ username }}</div>
            <div class="role">{{ role }}</div>
          </div>
          <div class="avatar-container">
            <img class="avatar" :src="avatarUrl" alt="avatar" />
            <div class="status-indicator online"></div>
          </div>
        </div>
      </div>
    </header>

    <div class="shop-dashboard">
      <!-- 侧边栏 -->
      <aside class="sidebar">
        <ul class="nav-list">
          <li :class="{ active: isActive('/shop/inventory') }">
            <router-link to="/shop/inventory">
              <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="nav-icon">
                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                <rect x="8" y="3" width="8" height="6" rx="1"></rect>
                <path d="M8 9h8"></path>
                <path d="M8 12h8"></path>
                <path d="M8 15h8"></path>
              </svg>
              <span>库存信息</span>
            </router-link>
          </li>
          
          <li :class="{ active: isActive('/shop/detailcheck') }">
            <router-link to="/shop/detailcheck">
              <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="nav-icon">
                <circle cx="11" cy="11" r="8"></circle>
                <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
              </svg>
              <span>商品查询</span>
            </router-link>
          </li>
          
          <li :class="{ active: isActive('/shop/notifications') }">
            <router-link to="/shop/notifications">
              <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="nav-icon">
                <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path>
                <path d="M13.73 21a2 2 0 0 1-3.46 0"></path>
              </svg>
              <span>消息通知</span>
              <span class="nav-badge" v-if="unreadNotifications > 0">{{ unreadNotifications }}</span>
            </router-link>
          </li>
          
          <li :class="{ active: isActive('/shop/profile') }">
            <router-link to="/shop/profile">
              <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="nav-icon">
                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                <circle cx="12" cy="7" r="4"></circle>
              </svg>
              <span>个人设置</span>
            </router-link>
          </li>
        </ul>
        
        <div class="sidebar-footer">
          <button class="logout-button" @click="logout">
            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path>
              <polyline points="16 17 21 12 16 7"></polyline>
              <line x1="21" y1="12" x2="9" y2="12"></line>
            </svg>
            <span>退出登录</span>
          </button>
        </div>
      </aside>

      <!-- 主内容区域 -->
      <main class="content">
        <router-view />
      </main>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter, useRoute } from 'vue-router'

const router = useRouter()
const route = useRoute()

// 用户信息
const username = '管理员'
const role = '店长' // 可从登录信息中动态获取
const avatarUrl = 'https://i.pravatar.cc/40?img=3' // 可替换成你的头像接口

// 未读通知数量
const unreadNotifications = ref(3)

// 导航方法
const goToProfile = () => {
  router.push('/shop/profile')
}

const goToNotifications = () => {
  router.push('/shop/notifications')
}

const isActive = (path) => {
  return route.path === path
}

const logout = () => {
  // 实现登出逻辑
  localStorage.removeItem('token')
  router.push('/login')
}

// 组件选项
defineOptions({
  name: 'Dashboard'
})
</script>

<style scoped>
html, body, #app {
  height: 100vh;
  margin: 0;
  padding: 0;
  overflow: hidden;
}

/* 基础样式 */
.dashboard-layout {
  height: 100%;
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  background-color: #f8fafc;
  font-family: 'PingFang SC', 'Microsoft YaHei', sans-serif;
  overflow: hidden;
}

/* 顶部导航栏 */
.dashboard-header {
  height: 60px;
  background-color: #ffffff;
  border-bottom: 1px solid #e2e8f0;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0 20px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
  position: sticky;
  top: 0;
  z-index: 100;
}

.header-left {
  display: flex;
  align-items: center;
}

.logo-title {
  display: flex;
  align-items: center;
  gap: 10px;
  font-size: 18px;
  font-weight: 600;
  color: #0f172a;
}

.header-right {
  display: flex;
  align-items: center;
  gap: 20px;
}

.notification-indicator {
  position: relative;
  color: #64748b;
  cursor: pointer;
  padding: 8px;
  border-radius: 6px;
  transition: all 0.2s ease;
}

.notification-indicator:hover {
  background-color: #f1f5f9;
  color: #334155;
}

.badge {
  position: absolute;
  top: 0;
  right: 0;
  background-color: #ef4444;
  color: white;
  font-size: 10px;
  font-weight: 600;
  height: 16px;
  min-width: 16px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 8px;
  padding: 0 4px;
  border: 2px solid #ffffff;
}

.user-info {
  display: flex;
  align-items: center;
  gap: 12px;
  cursor: pointer;
  padding: 6px 10px;
  border-radius: 8px;
  transition: all 0.2s ease;
}

.user-info:hover {
  background-color: #f1f5f9;
}

.info-text {
  text-align: right;
}

.username {
  font-size: 14px;
  font-weight: 600;
  color: #334155;
}

.role {
  font-size: 12px;
  color: #64748b;
}

.avatar-container {
  position: relative;
}

.avatar {
  width: 36px;
  height: 36px;
  border-radius: 50%;
  object-fit: cover;
  border: 2px solid #f8fafc;
}

.status-indicator {
  position: absolute;
  bottom: 0;
  right: 0;
  width: 10px;
  height: 10px;
  border-radius: 50%;
  border: 2px solid #ffffff;
}

.status-indicator.online {
  background-color: #42b983;
}

/* 主体布局 */
.shop-dashboard {
  display: flex;
  flex: 1;
  height: calc(100vh - 80px);
  overflow: hidden;
}

/* 侧边栏 */
.sidebar {
  width: 220px;
  background-color: #ffffff;
  border-right: 1px solid #e2e8f0;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  height: calc(100vh - 60px);
  box-shadow: 2px 0 5px rgba(0,0,0,0.03);
}

.nav-list {
  list-style: none;
  padding: 16px 0;
  margin: 0;
}

.nav-list li {
  margin: 4px 12px;
}

.nav-list a {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px 16px;
  text-decoration: none;
  color: #334155;
  font-size: 15px;
  border-radius: 8px;
  transition: all 0.2s ease;
  position: relative;
}

.nav-list a:hover {
  background-color: #eef6f2;
  color: #2c7a7b;
}

.nav-list li.active a {
  background-color: #42b983;
  color: white;
  font-weight: 500;
}

.nav-icon {
  flex-shrink: 0;
}

.nav-badge {
  position: absolute;
  right: 12px;
  top: 50%;
  transform: translateY(-50%);
  background-color: #ef4444;
  color: white;
  font-size: 10px;
  font-weight: 600;
  height: 18px;
  min-width: 18px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 9px;
  padding: 0 5px;
}

.sidebar-footer {
  padding: 16px;
  border-top: 1px solid #f1f5f9;
  margin-top: auto;
}

.logout-button {
  display: flex;
  align-items: center;
  gap: 10px;
  width: 100%;
  padding: 12px;
  border-radius: 8px;
  background-color: #f1f5f9;
  color: #64748b;
  border: none;
  cursor: pointer;
  transition: all 0.2s ease;
  font-size: 14px;
}

.logout-button:hover {
  background-color: #fee2e2;
  color: #ef4444;
}

/* 主内容区域 */
.content {
  flex: 1;
  padding: 20px;
  overflow-y: auto;
  background-color: #f8fafc;
  height: calc(100vh - 80px);
}

/* 响应式调整 */
@media (max-width: 768px) {
  .sidebar {
    width: 70px;
    overflow: hidden;
  }
  
  .nav-list a span {
    display: none;
  }
  
  .nav-list a {
    justify-content: center;
    padding: 12px;
  }
  
  .nav-badge {
    top: 8px;
    right: 8px;
    transform: none;
  }
  
  .logout-button span {
    display: none;
  }
  
  .logout-button {
    justify-content: center;
  }
  
  .content {
    padding: 16px;
  }
  
  .info-text {
    display: none;
  }
}
</style>