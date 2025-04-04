<template>
  <div class="profile-page">

    <!-- 用户基本信息区域 -->
    <div class="profile-overview">
      <div class="profile-card">
        <div class="profile-header">
          <div class="avatar-container">
            <img class="avatar" :src="avatarUrl" alt="用户头像" />
            <div class="role-indicator" :class="getRoleBadgeClass">
              {{ roleText.charAt(0) }}
            </div>
          </div>
          
          <div class="user-info">
            <h2 class="user-name">{{ user.username }}</h2>
            <div class="role-tag" :class="getRoleBadgeClass">
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="role-icon">
                <path v-if="user.role_id === 1" d="M12 2a10 10 0 1 0 0 20 10 10 0 0 0 0-20z"></path>
                <path v-if="user.role_id === 1" d="M12 8v8"></path>
                <path v-if="user.role_id === 1" d="M8 12h8"></path>
                <path v-else-if="user.role_id === 2 || user.role_id === 3" d="M20 11.08V8l-6-6H6a2 2 0 0 0-2 2v16c0 1.1.9 2 2 2h6"></path>
                <path v-else-if="user.role_id === 2 || user.role_id === 3" d="M14 3v5h5M18 21v-6M15 18h6"></path>
                <path v-else d="M12.89 1.45l8 4A2 2 0 0 1 22 7.24v9.53a2 2 0 0 1-1.11 1.79l-8 4a2 2 0 0 1-1.79 0l-8-4a2 2 0 0 1-1.1-1.8V7.24a2 2 0 0 1 1.11-1.79l8-4a2 2 0 0 1 1.78 0z"></path>
                <polyline v-else points="2.32 6.16 12 11 21.68 6.16"></polyline>
              </svg>
              <span>{{ roleText }}</span>
            </div>
          </div>
          
          <div class="user-meta">
            <div class="meta-item">
              <div class="meta-label">账号ID</div>
              <div class="meta-value">{{ generateUserId() }}</div>
            </div>
            <div class="meta-item">
              <div class="meta-label">注册日期</div>
              <div class="meta-value">{{ formatDate() }}</div>
            </div>
          </div>
          
          <div class="profile-actions">
            <button class="action-btn edit-btn">
              <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
              </svg>
              <span>编辑资料</span>
            </button>
            <button class="action-btn password-btn">
              <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
              </svg>
              <span>修改密码</span>
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- 主要内容区域 -->
    <div class="profile-content">
      <!-- 账号信息区域 -->
      <div class="content-section account-info">
        <div class="section-header">
          <h3 class="section-title">
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
              <circle cx="12" cy="7" r="4"></circle>
            </svg>
            账号信息
          </h3>
        </div>
        
        <div class="info-grid">
          <div class="info-item" v-if="user.permission">
            <div class="info-icon">
              <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
              </svg>
            </div>
            <div class="info-content">
              <div class="info-label">权限级别</div>
              <div class="info-value">{{ user.permission }}</div>
            </div>
          </div>

          <div class="info-item" v-if="user.role_id === 2 || user.role_id === 3">
            <div class="info-icon">
              <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
                <polyline points="9 22 9 12 15 12 15 22"></polyline>
              </svg>
            </div>
            <div class="info-content">
              <div class="info-label">所属商店</div>
              <div class="info-value">{{ user.shop_id }}</div>
            </div>
          </div>

          <div class="info-item" v-if="user.role_id === 4 || user.role_id === 5">
            <div class="info-icon">
              <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <rect x="4" y="4" width="16" height="16" rx="2" ry="2"></rect>
                <rect x="9" y="9" width="6" height="6"></rect>
                <line x1="9" y1="1" x2="9" y2="4"></line>
                <line x1="15" y1="1" x2="15" y2="4"></line>
                <line x1="9" y1="20" x2="9" y2="23"></line>
                <line x1="15" y1="20" x2="15" y2="23"></line>
                <line x1="20" y1="9" x2="23" y2="9"></line>
                <line x1="20" y1="14" x2="23" y2="14"></line>
                <line x1="1" y1="9" x2="4" y2="9"></line>
                <line x1="1" y1="14" x2="4" y2="14"></line>
              </svg>
            </div>
            <div class="info-content">
              <div class="info-label">所属工厂</div>
              <div class="info-value">{{ user.factory_id }}</div>
            </div>
          </div>
          
          <div class="info-item">
            <div class="info-icon">
              <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <circle cx="12" cy="12" r="10"></circle>
                <polyline points="12 6 12 12 16 14"></polyline>
              </svg>
            </div>
            <div class="info-content">
              <div class="info-label">上次登录</div>
              <div class="info-value">今天 09:45</div>
            </div>
          </div>
        </div>
      </div>
      
      <!-- 活动记录区域 -->
      <div class="content-section activity-log">
        <div class="section-header">
          <h3 class="section-title">
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
              <polyline points="14 2 14 8 20 8"></polyline>
              <line x1="16" y1="13" x2="8" y2="13"></line>
              <line x1="16" y1="17" x2="8" y2="17"></line>
              <polyline points="10 9 9 9 8 9"></polyline>
            </svg>
            最近活动
          </h3>
          <button class="view-all-btn">
            查看全部
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <polyline points="9 18 15 12 9 6"></polyline>
            </svg>
          </button>
        </div>
        
        <div class="activity-list">
          <div class="activity-item">
            <div class="activity-icon login">
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"></path>
                <polyline points="10 17 15 12 10 7"></polyline>
                <line x1="15" y1="12" x2="3" y2="12"></line>
              </svg>
            </div>
            <div class="activity-content">
              <div class="activity-title">系统登录</div>
              <div class="activity-description">从 192.168.1.105 IP地址登录系统</div>
            </div>
            <div class="activity-time">今天 09:45</div>
          </div>
          
          <div class="activity-item">
            <div class="activity-icon update">
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
              </svg>
            </div>
            <div class="activity-content">
              <div class="activity-title">更新个人信息</div>
              <div class="activity-description">修改了联系方式和个人简介</div>
            </div>
            <div class="activity-time">昨天 16:30</div>
          </div>
          
          <div class="activity-item">
            <div class="activity-icon data">
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
                <polyline points="17 8 12 3 7 8"></polyline>
                <line x1="12" y1="3" x2="12" y2="15"></line>
              </svg>
            </div>
            <div class="activity-content">
              <div class="activity-title">数据导出</div>
              <div class="activity-description">导出了本月销售报表数据</div>
            </div>
            <div class="activity-time">3天前</div>
          </div>
        </div>
      </div>
      
      <!-- 安全设置区域 -->
      <div class="content-section security-settings">
        <div class="section-header">
          <h3 class="section-title">
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
              <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
            </svg>
            安全设置
          </h3>
        </div>
        
        <div class="security-items">
          <div class="security-item">
            <div class="security-info">
              <div class="security-title">登录密码</div>
              <div class="security-description">定期修改密码可以保护账号安全</div>
            </div>
            <button class="security-action">
              修改
            </button>
          </div>
          
          <div class="security-item">
            <div class="security-info">
              <div class="security-title">绑定手机</div>
              <div class="security-description">已绑定：138****8888</div>
            </div>
            <button class="security-action">
              更换
            </button>
          </div>
          
          <div class="security-item">
            <div class="security-info">
              <div class="security-title">双因素认证</div>
              <div class="security-description">未开启</div>
            </div>
            <button class="security-action">
              开启
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import axios from 'axios'

const user = ref({
  username: '',
  role_id: null,
  permission: '',
  shop_id: null,
  factory_id: null
})

const avatarUrl = 'https://i.pravatar.cc/150?img=5'

// 可选角色映射
const roleMap = {
  1: '管理员',
  2: '店长',
  3: '店员',
  4: '厂家',
  5: '厂家员工'
}

const roleText = computed(() => roleMap[user.value.role_id] || '未知角色')

// 角色徽章样式
const getRoleBadgeClass = computed(() => {
  const roleClasses = {
    1: 'admin',
    2: 'manager',
    3: 'staff',
    4: 'factory',
    5: 'factory-staff'
  }
  return roleClasses[user.value.role_id] || 'default'
})

// 生成用户ID
const generateUserId = () => {
  return `UID${Math.floor(10000 + Math.random() * 90000)}`
}

// 格式化日期
const formatDate = () => {
  const date = new Date()
  date.setMonth(date.getMonth() - 3) // 模拟3个月前注册
  return date.toLocaleDateString('zh-CN', { year: 'numeric', month: 'long', day: 'numeric' })
}

// 获取用户信息（可对接真实接口）
async function fetchUserInfo() {
  try {
    const res = await axios.get('http://localhost:8080/api/user/profile', {
      headers: {
        Authorization: 'Bearer ' + localStorage.getItem('token')
      }
    })
    console.log("Shop Profile Page res ", res.data)
    user.value = res.data.data
  } catch (error) {
    console.error('获取用户信息失败:', error)
    // 模拟数据用于展示
    user.value = {
      username: '张明',
      role_id: 2,
      permission: '完全权限',
      shop_id: 'SH10086',
      factory_id: null
    }
  }
}

onMounted(() => {
  fetchUserInfo()
})
</script>

<style scoped>
/* 基础样式 */
.profile-page {
  width: 100%;
  background-color: #f8fafc;
  font-family: 'PingFang SC', 'Microsoft YaHei', sans-serif;
  color: #1e293b;
}

/* 用户概览区域 */
.profile-overview {
  margin-bottom: 24px;
}

.profile-card {
  background-color: white;
  border-radius: 12px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
  overflow: hidden;
}

.profile-header {
  padding: 24px;
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 24px;
}

.avatar-container {
  position: relative;
}

.avatar {
  width: 100px;
  height: 100px;
  border-radius: 50%;
  object-fit: cover;
  border: 4px solid white;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.role-indicator {
  position: absolute;
  bottom: 0;
  right: 0;
  width: 30px;
  height: 30px;
  border-radius: 50%;
  background-color: #42b983;
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: bold;
  font-size: 14px;
  border: 3px solid white;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.user-info {
  flex: 1;
  min-width: 200px;
}

.user-name {
  font-size: 24px;
  font-weight: 600;
  margin: 0 0 8px;
  color: #0f172a;
}

.role-tag {
  display: inline-flex;
  align-items: center;
  padding: 6px 12px;
  border-radius: 20px;
  font-size: 14px;
  font-weight: 500;
  color: white;
  background-color: #42b983;
}

.role-icon {
  margin-right: 6px;
}

/* 角色颜色 */
.admin {
  background-color: #673AB7;
}

.manager {
  background-color: #42b983;
}

.staff {
  background-color: #4CAF50;
}

.factory {
  background-color: #FF9800;
}

.factory-staff {
  background-color: #FF5722;
}

.user-meta {
  display: flex;
  gap: 24px;
}

.meta-item {
  display: flex;
  flex-direction: column;
}

.meta-label {
  font-size: 13px;
  color: #64748b;
  margin-bottom: 4px;
}

.meta-value {
  font-size: 15px;
  font-weight: 500;
  color: #334155;
}

.profile-actions {
  display: flex;
  gap: 12px;
  margin-left: auto;
}

.action-btn {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 8px 16px;
  border-radius: 8px;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s ease;
  border: none;
}

.edit-btn {
  background-color: #42b983;
  color: white;
}

.edit-btn:hover {
  background-color: #3aa876;
}

.password-btn {
  background-color: #f1f5f9;
  color: #334155;
  border: 1px solid #e2e8f0;
}

.password-btn:hover {
  background-color: #e2e8f0;
}

/* 主要内容区域 */
.profile-content {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 24px;
  margin-bottom: 24px;
}

.content-section {
  background-color: white;
  border-radius: 12px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
  overflow: hidden;
}

.section-header {
  padding: 16px 20px;
  border-bottom: 1px solid #f1f5f9;
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.section-title {
  font-size: 16px;
  font-weight: 600;
  color: #0f172a;
  margin: 0;
  display: flex;
  align-items: center;
  gap: 8px;
}

.section-title svg {
  color: #42b983;
}

.view-all-btn {
  display: flex;
  align-items: center;
  gap: 4px;
  background: none;
  border: none;
  color: #64748b;
  font-size: 14px;
  cursor: pointer;
  transition: color 0.2s ease;
}

.view-all-btn:hover {
  color: #42b983;
}

/* 账号信息区域 */
.info-grid {
  padding: 20px;
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
  gap: 20px;
}

.info-item {
  display: flex;
  align-items: flex-start;
  gap: 12px;
}

.info-icon {
  width: 40px;
  height: 40px;
  border-radius: 8px;
  background-color: #f1f5f9;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #42b983;
}

.info-content {
  flex: 1;
}

.info-label {
  font-size: 13px;
  color: #64748b;
  margin-bottom: 4px;
}

.info-value {
  font-size: 16px;
  font-weight: 500;
  color: #334155;
}

/* 活动记录区域 */
.activity-list {
  padding: 8px 0;
}

.activity-item {
  display: flex;
  align-items: center;
  padding: 16px 20px;
  border-bottom: 1px solid #f1f5f9;
}

.activity-item:last-child {
  border-bottom: none;
}

.activity-icon {
  width: 36px;
  height: 36px;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 16px;
  color: white;
  flex-shrink: 0;
}

.login {
  background-color: #42b983;
}

.update {
  background-color: #3b82f6;
}

.data {
  background-color: #f59e0b;
}

.activity-content {
  flex: 1;
  min-width: 0;
}

.activity-title {
  font-size: 15px;
  font-weight: 500;
  color: #334155;
  margin-bottom: 4px;
}

.activity-description {
  font-size: 13px;
  color: #64748b;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.activity-time {
  font-size: 13px;
  color: #94a3b8;
  margin-left: 16px;
  white-space: nowrap;
}

/* 安全设置区域 */
.security-items {
  padding: 8px 0;
}

.security-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16px 20px;
  border-bottom: 1px solid #f1f5f9;
}

.security-item:last-child {
  border-bottom: none;
}

.security-title {
  font-size: 15px;
  font-weight: 500;
  color: #334155;
  margin-bottom: 4px;
}

.security-description {
  font-size: 13px;
  color: #64748b;
}

.security-action {
  padding: 6px 12px;
  border-radius: 6px;
  background-color: #f1f5f9;
  color: #334155;
  border: 1px solid #e2e8f0;
  font-size: 14px;
  cursor: pointer;
  transition: all 0.2s ease;
}

.security-action:hover {
  background-color: #e2e8f0;
  color: #0f172a;
}

/* 响应式调整 */
@media (max-width: 768px) {
  .profile-header {
    flex-direction: column;
    align-items: flex-start;
  }
  
  .profile-actions {
    margin-left: 0;
    width: 100%;
  }
  
  .user-meta {
    width: 100%;
    flex-wrap: wrap;
  }
  
  .profile-content {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 480px) {
  .info-grid {
    grid-template-columns: 1fr;
  }
  
  .activity-time {
    display: none;
  }
  
  .activity-description {
    white-space: normal;
  }
}
</style>