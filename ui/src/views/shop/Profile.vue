<template>
    <div class="profile-container">
      <div class="profile-header">
        <div class="header-content">
          <h1 class="title">个人中心</h1>
          <p class="subtitle">查看和管理您的个人信息</p>
        </div>
        <div class="header-decoration"></div>
      </div>
  
      <div class="profile-content">
        <div class="profile-card">
          <div class="card-header">
            <div class="avatar-wrapper">
              <img class="avatar" :src="avatarUrl" alt="头像" />
              <div class="avatar-badge" :class="getRoleBadgeClass">
                {{ roleText.charAt(0) }}
              </div>
            </div>
            <div class="user-headline">
              <h2 class="username">{{ user.username }}</h2>
              <div class="role-badge" :class="getRoleBadgeClass">
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
          </div>
  
          <div class="card-divider"></div>
  
          <div class="info-section">
            <div class="info-grid">
              <div class="info-item" v-if="user.permission">
                <div class="info-icon">
                  <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                  </svg>
                </div>
                <div class="info-content">
                  <div class="info-label">权限</div>
                  <div class="info-value">{{ user.permission }}</div>
                </div>
              </div>
  
              <div class="info-item" v-if="user.role_id === 2 || user.role_id === 3">
                <div class="info-icon">
                  <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
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
                  <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
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
                  <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                    <circle cx="12" cy="7" r="4"></circle>
                  </svg>
                </div>
                <div class="info-content">
                  <div class="info-label">账号ID</div>
                  <div class="info-value">{{ generateUserId() }}</div>
                </div>
              </div>
  
              <div class="info-item">
                <div class="info-icon">
                  <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                    <line x1="16" y1="2" x2="16" y2="6"></line>
                    <line x1="8" y1="2" x2="8" y2="6"></line>
                    <line x1="3" y1="10" x2="21" y2="10"></line>
                  </svg>
                </div>
                <div class="info-content">
                  <div class="info-label">注册日期</div>
                  <div class="info-value">{{ formatDate() }}</div>
                </div>
              </div>
            </div>
          </div>
  
          <div class="card-actions">
            <button class="action-button edit-button">
              <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
              </svg>
              <span>编辑资料</span>
            </button>
            <button class="action-button password-button">
              <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
              </svg>
              <span>修改密码</span>
            </button>
          </div>
        </div>
  
        <div class="activity-card">
          <h3 class="card-title">最近活动</h3>
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
                <div class="activity-time">今天 09:45</div>
              </div>
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
                <div class="activity-time">昨天 16:30</div>
              </div>
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
                <div class="activity-time">3天前</div>
              </div>
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
  
  const avatarUrl = 'https://i.pravatar.cc/100?img=5'
  
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
  .profile-container {
    min-height: 100vh;
    background-color: #f5f7fa;
    padding: 0;
    font-family: 'PingFang SC', 'Microsoft YaHei', sans-serif;
  }
  
  /* 头部区域 */
  .profile-header {
    background: linear-gradient(135deg, #4CAF50, #2E7D32);
    color: white;
    padding: 40px 40px 100px;
    position: relative;
    overflow: hidden;
  }
  
  .header-content {
    position: relative;
    z-index: 2;
  }
  
  .header-decoration {
    position: absolute;
    top: -50px;
    right: -50px;
    width: 300px;
    height: 300px;
    border-radius: 50%;
    background: rgba(255, 255, 255, 0.1);
    z-index: 1;
  }
  
  .header-decoration::before {
    content: '';
    position: absolute;
    top: 50px;
    left: -100px;
    width: 200px;
    height: 200px;
    border-radius: 50%;
    background: rgba(255, 255, 255, 0.05);
  }
  
  .title {
    font-size: 28px;
    font-weight: 600;
    margin: 0;
    letter-spacing: 0.5px;
  }
  
  .subtitle {
    font-size: 16px;
    font-weight: 400;
    margin-top: 8px;
    opacity: 0.9;
  }
  
  /* 内容区域 */
  .profile-content {
    max-width: 1000px;
    margin: -60px auto 40px;
    padding: 0 20px;
    display: grid;
    grid-template-columns: 2fr 1fr;
    gap: 24px;
  }
  
  @media (max-width: 768px) {
    .profile-content {
      grid-template-columns: 1fr;
    }
  }
  
  /* 卡片样式 */
  .profile-card, .activity-card {
    background: white;
    border-radius: 12px;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
    overflow: hidden;
  }
  
  /* 个人信息卡片 */
  .card-header {
    padding: 30px;
    display: flex;
    align-items: center;
  }
  
  .avatar-wrapper {
    position: relative;
    margin-right: 24px;
  }
  
  .avatar {
    width: 100px;
    height: 100px;
    border-radius: 50%;
    object-fit: cover;
    border: 4px solid white;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
  }
  
  .avatar-badge {
    position: absolute;
    bottom: 0;
    right: 0;
    width: 30px;
    height: 30px;
    border-radius: 50%;
    background-color: #4CAF50;
    color: white;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: bold;
    font-size: 14px;
    border: 2px solid white;
  }
  
  .user-headline {
    flex: 1;
  }
  
  .username {
    font-size: 24px;
    font-weight: 600;
    margin: 0 0 8px;
    color: #2c3e50;
  }
  
  .role-badge {
    display: inline-flex;
    align-items: center;
    padding: 6px 12px;
    border-radius: 20px;
    font-size: 14px;
    font-weight: 500;
    color: white;
    background-color: #4CAF50;
  }
  
  .role-icon {
    margin-right: 6px;
  }
  
  /* 角色颜色 */
  .admin {
    background-color: #673AB7;
  }
  
  .manager {
    background-color: #2196F3;
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
  
  .card-divider {
    height: 1px;
    background-color: #f0f0f0;
    margin: 0 30px;
  }
  
  /* 信息区域 */
  .info-section {
    padding: 30px;
  }
  
  .info-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
    gap: 24px;
  }
  
  .info-item {
    display: flex;
    align-items: flex-start;
  }
  
  .info-icon {
    width: 36px;
    height: 36px;
    border-radius: 8px;
    background-color: #f5f7fa;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-right: 12px;
    color: #4CAF50;
  }
  
  .info-content {
    flex: 1;
  }
  
  .info-label {
    font-size: 14px;
    color: #94a3b8;
    margin-bottom: 4px;
  }
  
  .info-value {
    font-size: 16px;
    font-weight: 500;
    color: #334155;
  }
  
  /* 操作按钮 */
  .card-actions {
    padding: 20px 30px 30px;
    display: flex;
    gap: 16px;
  }
  
  .action-button {
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 10px 20px;
    border-radius: 8px;
    font-size: 15px;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.2s ease;
    border: none;
  }
  
  .action-button svg {
    margin-right: 8px;
  }
  
  .edit-button {
    background-color: #4CAF50;
    color: white;
    flex: 1;
  }
  
  .edit-button:hover {
    background-color: #388E3C;
  }
  
  .password-button {
    background-color: #f8fafc;
    color: #475569;
    border: 1px solid #e2e8f0;
    flex: 1;
  }
  
  .password-button:hover {
    background-color: #f1f5f9;
  }
  
  /* 活动卡片 */
  .activity-card {
    padding: 24px;
  }
  
  .card-title {
    font-size: 18px;
    font-weight: 600;
    color: #334155;
    margin: 0 0 20px;
  }
  
  .activity-list {
    display: flex;
    flex-direction: column;
    gap: 16px;
  }
  
  .activity-item {
    display: flex;
    align-items: center;
    padding-bottom: 16px;
    border-bottom: 1px solid #f1f5f9;
  }
  
  .activity-item:last-child {
    border-bottom: none;
    padding-bottom: 0;
  }
  
  .activity-icon {
    width: 32px;
    height: 32px;
    border-radius: 8px;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-right: 12px;
    color: white;
  }
  
  .login {
    background-color: #3B82F6;
  }
  
  .update {
    background-color: #10B981;
  }
  
  .data {
    background-color: #F59E0B;
  }
  
  .activity-content {
    flex: 1;
  }
  
  .activity-title {
    font-size: 15px;
    font-weight: 500;
    color: #334155;
    margin-bottom: 4px;
  }
  
  .activity-time {
    font-size: 13px;
    color: #94a3b8;
  }
  
  /* 响应式调整 */
  @media (max-width: 640px) {
    .profile-header {
      padding: 30px 20px 80px;
    }
    
    .card-header {
      flex-direction: column;
      text-align: center;
    }
    
    .avatar-wrapper {
      margin-right: 0;
      margin-bottom: 20px;
    }
    
    .info-grid {
      grid-template-columns: 1fr;
    }
    
    .card-actions {
      flex-direction: column;
    }
  }
  </style>