<template>
  <div class="notifications-page">
    
    <!-- 顶部搜索和过滤 -->
    <div class="controls-section">
      <div class="search-bar">
        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <circle cx="11" cy="11" r="8"></circle>
          <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
        </svg>
        <input 
          type="text" 
          placeholder="搜索通知..." 
          v-model="searchQuery"
        />
      </div>
      
      <div class="filter-options">
        <select v-model="categoryFilter">
          <option value="">所有类别</option>
          <option value="inventory">库存</option>
          <option value="system">系统</option>
          <option value="order">订单</option>
          <option value="finance">财务</option>
          <option value="hr">人事</option>
        </select>
        
        <select v-model="readFilter">
          <option value="">全部状态</option>
          <option value="read">已读</option>
          <option value="unread">未读</option>
        </select>
      </div>
    </div>
    
    <!-- 通知概览 -->
    <div class="overview-section" v-if="urgentMessages.length > 0">
      <h2 class="section-title">
        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"></path>
          <line x1="12" y1="9" x2="12" y2="13"></line>
          <line x1="12" y1="17" x2="12.01" y2="17"></line>
        </svg>
        紧急通知
      </h2>
      
      <div class="urgent-cards">
        <div 
          v-for="message in urgentMessages" 
          :key="message.id"
          class="urgent-card"
          :class="{ 'inventory': message.category === 'inventory', 'system': message.category === 'system', 'order': message.category === 'order' }"
          @click="viewMessage(message)"
        >
          <div class="card-icon">
            <svg v-if="message.category === 'inventory'" xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
              <rect x="8" y="3" width="8" height="6" rx="1"></rect>
              <path d="M8 9h8"></path>
              <path d="M8 12h8"></path>
              <path d="M8 15h8"></path>
            </svg>
            <svg v-else-if="message.category === 'system'" xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <rect x="2" y="3" width="20" height="14" rx="2" ry="2"></rect>
              <line x1="8" y1="21" x2="16" y2="21"></line>
              <line x1="12" y1="17" x2="12" y2="21"></line>
            </svg>
            <svg v-else-if="message.category === 'order'" xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"></path>
              <line x1="3" y1="6" x2="21" y2="6"></line>
              <path d="M16 10a4 4 0 0 1-8 0"></path>
            </svg>
            <svg v-else xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <circle cx="12" cy="12" r="10"></circle>
              <line x1="12" y1="8" x2="12" y2="12"></line>
              <line x1="12" y1="16" x2="12.01" y2="16"></line>
            </svg>
          </div>
          <div class="card-content">
            <div class="card-title">{{ message.subject }}</div>
            <div class="card-sender">{{ message.sender }}</div>
            <div class="card-preview">{{ message.content.substring(0, 60) }}{{ message.content.length > 60 ? '...' : '' }}</div>
          </div>
          <div class="card-time">{{ message.date }} {{ message.time }}</div>
        </div>
      </div>
    </div>
    
    <!-- 通知列表 -->
    <div class="messages-list">
      <div class="list-header">
        <h2 class="section-title">所有通知</h2>
        <div class="list-actions">
          <button @click="markAllAsRead" class="action-btn">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
              <polyline points="22 4 12 14.01 9 11.01"></polyline>
            </svg>
            全部标为已读
          </button>
          <button class="action-btn">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <polyline points="3 6 5 6 21 6"></polyline>
              <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
            </svg>
            清空通知
          </button>
        </div>
      </div>
      
      <div v-if="filteredMessages.length === 0" class="empty-state">
        <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1" stroke-linecap="round" stroke-linejoin="round">
          <circle cx="12" cy="12" r="10"></circle>
          <line x1="12" y1="8" x2="12" y2="12"></line>
          <line x1="12" y1="16" x2="12.01" y2="16"></line>
        </svg>
        <p>没有找到匹配的通知</p>
      </div>
      
      <div 
        v-for="message in filteredMessages" 
        :key="message.id"
        class="message-item"
        :class="{ 'unread': !message.isRead, 'urgent': message.isUrgent }"
        @click="viewMessage(message)"
      >
        <div class="message-status">
          <div class="status-indicator" :class="{ 'read': message.isRead }"></div>
          <div class="category-icon" :class="message.category">
            <svg v-if="message.category === 'inventory'" xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
              <rect x="8" y="3" width="8" height="6" rx="1"></rect>
              <path d="M8 9h8"></path>
              <path d="M8 12h8"></path>
              <path d="M8 15h8"></path>
            </svg>
            <svg v-else-if="message.category === 'system'" xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <rect x="2" y="3" width="20" height="14" rx="2" ry="2"></rect>
              <line x1="8" y1="21" x2="16" y2="21"></line>
              <line x1="12" y1="17" x2="12" y2="21"></line>
            </svg>
            <svg v-else-if="message.category === 'order'" xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"></path>
              <line x1="3" y1="6" x2="21" y2="6"></line>
              <path d="M16 10a4 4 0 0 1-8 0"></path>
            </svg>
            <svg v-else-if="message.category === 'finance'" xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <line x1="12" y1="1" x2="12" y2="23"></line>
              <path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"></path>
            </svg>
            <svg v-else-if="message.category === 'hr'" xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
              <circle cx="9" cy="7" r="4"></circle>
              <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
              <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
            </svg>
            <svg v-else xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <circle cx="12" cy="12" r="10"></circle>
              <line x1="12" y1="8" x2="12" y2="12"></line>
              <line x1="12" y1="16" x2="12.01" y2="16"></line>
            </svg>
          </div>
        </div>
        
        <div class="message-sender">{{ message.sender }}</div>
        <div class="message-content">
          <div class="message-subject">{{ message.subject }}</div>
          <div class="message-preview">{{ message.content.substring(0, 80) }}{{ message.content.length > 80 ? '...' : '' }}</div>
        </div>
        
        <div class="message-time">{{ message.date }} {{ message.time }}</div>
        
        <div class="message-actions">
          <button 
            class="action-icon" 
            @click.stop="toggleImportant(message)"
            :class="{ 'active': message.isUrgent }"
          >
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon>
            </svg>
          </button>
          
          <button 
            class="action-icon" 
            @click.stop="toggleRead(message)"
          >
            <svg v-if="message.isRead" xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
              <circle cx="12" cy="12" r="3"></circle>
            </svg>
            <svg v-else xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path>
              <line x1="1" y1="1" x2="23" y2="23"></line>
            </svg>
          </button>
        </div>
      </div>
    </div>
    
    <!-- 通知详情弹窗 -->
    <div class="notification-modal" v-if="selectedMessage" @click="closeModal">
      <div class="modal-content" @click.stop>
        <div class="modal-header">
          <h2 class="modal-title">{{ selectedMessage.subject }}</h2>
          <button class="close-button" @click="closeModal">
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <line x1="18" y1="6" x2="6" y2="18"></line>
              <line x1="6" y1="6" x2="18" y2="18"></line>
            </svg>
          </button>
        </div>
        
        <div class="modal-body">
          <div class="message-meta">
            <div class="category-badge" :class="selectedMessage.category">
              {{ getCategoryName(selectedMessage.category) }}
            </div>
            <div class="message-date">{{ selectedMessage.date }} {{ selectedMessage.time }}</div>
          </div>
          
          <div class="sender-info">
            <div class="sender-avatar">
              {{ getSenderInitial(selectedMessage.sender) }}
            </div>
            <div class="sender-details">
              <div class="sender-name">{{ selectedMessage.sender }}</div>
              <div class="sender-address">{{ getSenderEmail(selectedMessage.sender) }}</div>
            </div>
          </div>
          
          <div class="message-content-full">
            <p>{{ selectedMessage.content }}</p>
          </div>
          
          <div v-if="selectedMessage.category === 'inventory'" class="action-card inventory">
            <div class="action-card-header">
              <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                <rect x="8" y="3" width="8" height="6" rx="1"></rect>
                <path d="M8 9h8"></path>
                <path d="M8 12h8"></path>
                <path d="M8 15h8"></path>
              </svg>
              <h3>库存操作</h3>
            </div>
            <div class="action-card-content">
              <p>当前库存: <strong>8件</strong></p>
              <p>建议补货: <strong>30件</strong></p>
              <p>上次进货: <strong>2025-03-15</strong></p>
            </div>
            <div class="action-card-footer">
              <button class="primary-button">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                  <path d="M3 3v18h18"></path>
                  <path d="M18.4 9l-6-6-7 7"></path>
                </svg>
                查看库存详情
              </button>
              <button class="secondary-button">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                  <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                  <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
                </svg>
                创建采购单
              </button>
            </div>
          </div>
        </div>
        
        <div class="modal-footer">
          <button class="secondary-button" @click="closeModal">关闭</button>
          <button class="primary-button" @click="markAsRead(selectedMessage.id); closeModal();">
            标为已读
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';

// 状态
const searchQuery = ref('');
const categoryFilter = ref('');
const readFilter = ref('');
const selectedMessage = ref(null);
const messages = ref([
  { 
    id: 1, 
    date: "2025-04-01", 
    time: "08:30", 
    sender: "库存系统", 
    subject: "库存预警通知", 
    content: "库存预警：洗发水数量低于10件，请及时补充库存以确保正常销售。系统建议订购数量：30件。",
    isRead: false,
    isUrgent: true,
    category: "inventory"
  },
  { 
    id: 2, 
    date: "2025-04-02", 
    time: "14:15", 
    sender: "系统管理员", 
    subject: "系统升级通知", 
    content: "尊敬的用户，我们将于2025年4月5日凌晨2:00-4:00进行系统升级维护，期间系统将暂停服务。请提前做好相关工作安排，由此带来的不便敬请谅解。",
    isRead: true,
    isUrgent: false,
    category: "system"
  },
  { 
    id: 3, 
    date: "2025-04-03", 
    time: "09:45", 
    sender: "订单系统", 
    subject: "新订单通知", 
    content: "您有一个新的订单 #12345 已经生成，客户信息：张三，联系电话：13800138000，订单金额：¥1,299.00，请及时处理。",
    isRead: false,
    isUrgent: true,
    category: "order"
  },
  { 
    id: 4, 
    date: "2025-04-03", 
    time: "16:20", 
    sender: "财务部门", 
    subject: "月度财务报表", 
    content: "3月份财务报表已生成，销售总额：¥89,546.00，成本：¥45,230.00，毛利：¥44,316.00，毛利率：49.5%。详细报表请在财务系统中查看。",
    isRead: true,
    isUrgent: false,
    category: "finance"
  },
  { 
    id: 5, 
    date: "2025-04-04", 
    time: "10:00", 
    sender: "人力资源", 
    subject: "员工培训通知", 
    content: "定于2025年4月10日下午2:00在三楼会议室进行新系统使用培训，请相关部门人员准时参加。培训内容：库存管理新功能、订单处理流程优化。",
    isRead: false,
    isUrgent: false,
    category: "hr"
  }
]);

// 计算属性
const filteredMessages = computed(() => {
  return messages.value.filter(message => {
    // 搜索过滤
    const matchesSearch = 
      message.subject.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
      message.content.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
      message.sender.toLowerCase().includes(searchQuery.value.toLowerCase());
    
    // 类别过滤
    const matchesCategory = categoryFilter.value ? message.category === categoryFilter.value : true;
    
    // 已读/未读过滤
    const matchesReadStatus = 
      readFilter.value === 'read' ? message.isRead :
      readFilter.value === 'unread' ? !message.isRead : true;
    
    return matchesSearch && matchesCategory && matchesReadStatus;
  });
});

const urgentMessages = computed(() => {
  return messages.value.filter(message => message.isUrgent && !message.isRead);
});

// 方法
const viewMessage = (message) => {
  selectedMessage.value = message;
  markAsRead(message.id);
};

const closeModal = () => {
  selectedMessage.value = null;
};

const markAsRead = (messageId) => {
  const message = messages.value.find(msg => msg.id === messageId);
  if (message) {
    message.isRead = true;
  }
};

const markAllAsRead = () => {
  filteredMessages.value.forEach(message => {
    message.isRead = true;
  });
};

const toggleRead = (message) => {
  message.isRead = !message.isRead;
};

const toggleImportant = (message) => {
  message.isUrgent = !message.isUrgent;
};

const getCategoryName = (category) => {
  const categoryMap = {
    'inventory': '库存',
    'system': '系统',
    'order': '订单',
    'finance': '财务',
    'hr': '人事',
    'sent': '已发送'
  };
  return categoryMap[category] || '其他';
};

const getSenderInitial = (sender) => {
  return sender.charAt(0).toUpperCase();
};

const getSenderEmail = (sender) => {
  const domainMap = {
    '库存系统': 'inventory@system.com',
    '系统管理员': 'admin@system.com',
    '订单系统': 'order@system.com',
    '财务部门': 'finance@company.com',
    '人力资源': 'hr@company.com'
  };
  return domainMap[sender] || 'notification@system.com';
};

// 初始化
onMounted(() => {
  // 这里可以添加获取通知数据的逻辑
});
</script>

<style scoped>
.notifications-page {
  max-width: 1200px;
  margin: 0 auto;
}

/* 控制区域 */
.controls-section {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 24px;
  flex-wrap: wrap;
  gap: 16px;
}

.search-bar {
  position: relative;
  flex: 1;
  max-width: 400px;
}

.search-bar svg {
  position: absolute;
  left: 12px;
  top: 50%;
  transform: translateY(-50%);
  color: #64748b;
}

.search-bar input {
  width: 100%;
  padding: 10px 12px 10px 40px;
  border: 1px solid #e2e8f0;
  border-radius: 8px;
  background-color: #f8fafc;
  font-size: 14px;
  color: #334155;
  transition: all 0.2s ease;
}

.search-bar input:focus {
  outline: none;
  border-color: #3b82f6;
  background-color: #ffffff;
  box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
}

.filter-options {
  display: flex;
  gap: 12px;
}

.filter-options select {
  padding: 8px 12px;
  border: 1px solid #e2e8f0;
  border-radius: 8px;
  background-color: #f8fafc;
  font-size: 14px;
  color: #334155;
  cursor: pointer;
}

/* 紧急通知概览 */
.overview-section {
  background-color: #fff1f2;
  border-radius: 12px;
  padding: 20px;
  border: 1px solid #fecdd3;
  margin-bottom: 24px;
}

.section-title {
  font-size: 18px;
  font-weight: 600;
  color: #0f172a;
  margin: 0 0 16px;
  display: flex;
  align-items: center;
  gap: 8px;
}

.overview-section .section-title {
  color: #be123c;
}

.overview-section .section-title svg {
  color: #e11d48;
}

.urgent-cards {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 16px;
}

.urgent-card {
  background-color: white;
  border-radius: 8px;
  padding: 16px;
  display: flex;
  gap: 16px;
  cursor: pointer;
  transition: all 0.2s ease;
  border-left: 4px solid #f43f5e;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
}

.urgent-card:hover {
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
  transform: translateY(-2px);
}

.urgent-card.inventory {
  border-left-color: #0ea5e9;
}

.urgent-card.system {
  border-left-color: #8b5cf6;
}

.urgent-card.order {
  border-left-color: #f59e0b;
}

.card-icon {
  width: 40px;
  height: 40px;
  border-radius: 8px;
  background-color: #fee2e2;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #ef4444;
  flex-shrink: 0;
}

.urgent-card.inventory .card-icon {
  background-color: #e0f2fe;
  color: #0ea5e9;
}

.urgent-card.system .card-icon {
  background-color: #f3e8ff;
  color: #8b5cf6;
}

.urgent-card.order .card-icon {
  background-color: #fef3c7;
  color: #f59e0b;
}

.card-content {
  flex: 1;
  min-width: 0;
}

.card-title {
  font-weight: 600;
  color: #0f172a;
  margin-bottom: 4px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.card-sender {
  font-size: 13px;
  color: #64748b;
  margin-bottom: 8px;
}

.card-preview {
  font-size: 13px;
  color: #475569;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.card-time {
  font-size: 12px;
  color: #94a3b8;
  margin-top: 8px;
  text-align: right;
}

/* 通知列表 */
.messages-list {
  background-color: white;
  border-radius: 12px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
  overflow: hidden;
  border: 1px solid #e2e8f0;
}

.list-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16px 20px;
  border-bottom: 1px solid #e2e8f0;
}

.list-actions {
  display: flex;
  gap: 8px;
}

.action-btn {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 6px 12px;
  border-radius: 6px;
  font-size: 13px;
  background-color: #f8fafc;
  color: #64748b;
  border: 1px solid #e2e8f0;
  cursor: pointer;
  transition: all 0.2s ease;
}

.action-btn:hover {
  background-color: #f1f5f9;
  color: #334155;
}

.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 60px 20px;
  color: #94a3b8;
  text-align: center;
}

.empty-state svg {
  margin-bottom: 16px;
  color: #cbd5e1;
}

.empty-state p {
  font-size: 15px;
  margin: 0;
}

.message-item {
  display: flex;
  align-items: center;
  padding: 16px 20px;
  border-bottom: 1px solid #f1f5f9;
  cursor: pointer;
  transition: all 0.2s ease;
}

.message-item:last-child {
  border-bottom: none;
}

.message-item:hover {
  background-color: #f8fafc;
}

.message-item.unread {
  background-color: #eff6ff;
}

.message-item.unread:hover {
  background-color: #e0f2fe;
}

.message-status {
  display: flex;
  align-items: center;
  margin-right: 16px;
}

.status-indicator {
  width: 10px;
  height: 10px;
  border-radius: 50%;
  background-color: #3b82f6;
  margin-right: 8px;
}

.status-indicator.read {
  background-color: #e2e8f0;
}

.category-icon {
  width: 28px;
  height: 28px;
  border-radius: 6px;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #f1f5f9;
  color: #64748b;
}

.category-icon.inventory {
  background-color: #e0f2fe;
  color: #0ea5e9;
}

.category-icon.system {
  background-color: #f3e8ff;
  color: #8b5cf6;
}

.category-icon.order {
  background-color: #fef3c7;
  color: #f59e0b;
}

.category-icon.finance {
  background-color: #dcfce7;
  color: #10b981;
}

.category-icon.hr {
  background-color: #fae8ff;
  color: #d946ef;
}

.message-sender {
  width: 120px;
  font-weight: 500;
  color: #334155;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  margin-right: 16px;
}

.message-content {
  flex: 1;
  min-width: 0;
  margin-right: 16px;
}

.message-subject {
  font-weight: 500;
  color: #0f172a;
  margin-bottom: 4px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.message-item.unread .message-subject {
  font-weight: 600;
}

.message-preview {
  font-size: 13px;
  color: #64748b;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.message-time {
  font-size: 12px;
  color: #94a3b8;
  width: 100px;
  text-align: right;
  white-space: nowrap;
}

.message-actions {
  display: flex;
  gap: 8px;
  margin-left: 16px;
  opacity: 0;
  transition: opacity 0.2s ease;
}

.message-item:hover .message-actions {
  opacity: 1;
}

.action-icon {
  width: 32px;
  height: 32px;
  border-radius: 6px;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #f8fafc;
  color: #64748b;
  border: 1px solid #e2e8f0;
  cursor: pointer;
  transition: all 0.2s ease;
}

.action-icon:hover {
  background-color: #f1f5f9;
  color: #334155;
}

.action-icon.active {
  background-color: #fef3c7;
  color: #f59e0b;
  border-color: #fde68a;
}

/* 通知详情弹窗 */
.notification-modal {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  padding: 20px;
}

.modal-content {
  background-color: white;
  border-radius: 12px;
  width: 100%;
  max-width: 700px;
  max-height: 90vh;
  overflow-y: auto;
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
  display: flex;
  flex-direction: column;
}

.modal-header {
  padding: 20px;
  border-bottom: 1px solid #e2e8f0;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.modal-title {
  font-size: 20px;
  font-weight: 600;
  color: #0f172a;
  margin: 0;
}

.close-button {
  background: none;
  border: none;
  color: #64748b;
  cursor: pointer;
  padding: 8px;
  border-radius: 6px;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s ease;
}

.close-button:hover {
  background-color: #f1f5f9;
  color: #334155;
}

.modal-body {
  padding: 20px;
  flex: 1;
}

.message-meta {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 20px;
}

.category-badge {
  padding: 4px 10px;
  border-radius: 20px;
  font-size: 12px;
  font-weight: 500;
  color: white;
  background-color: #94a3b8;
}

.category-badge.inventory {
  background-color: #0ea5e9;
}

.category-badge.system {
  background-color: #8b5cf6;
}

.category-badge.order {
  background-color: #f59e0b;
}

.category-badge.finance {
  background-color: #10b981;
}

.category-badge.hr {
  background-color: #d946ef;
}

.sender-info {
  display: flex;
  align-items: center;
  gap: 16px;
  margin-bottom: 20px;
}

.sender-avatar {
  width: 48px;
  height: 48px;
  border-radius: 24px;
  background-color: #f1f5f9;
  color: #64748b;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 18px;
  font-weight: 600;
}

.sender-details {
  display: flex;
  flex-direction: column;
}

.sender-name {
  font-weight: 500;
  color: #334155;
  margin-bottom: 4px;
}

.sender-address {
  font-size: 13px;
  color: #64748b;
}

.message-content-full {
  color: #334155;
  line-height: 1.6;
  margin-bottom: 20px;
}

.action-card {
  margin-top: 24px;
  border-radius: 8px;
  overflow: hidden;
  border: 1px solid #e2e8f0;
}

.action-card.inventory {
  border-color: #bae6fd;
}

.action-card-header {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 16px;
  background-color: #f8fafc;
  border-bottom: 1px solid #e2e8f0;
}

.action-card.inventory .action-card-header {
  background-color: #e0f2fe;
  border-bottom-color: #bae6fd;
  color: #0369a1;
}

.action-card-header h3 {
  font-size: 16px;
  font-weight: 600;
  margin: 0;
}

.action-card-content {
  padding: 16px;
  background-color: white;
}

.action-card-content p {
  margin: 8px 0;
  font-size: 14px;
}

.action-card-footer {
  display: flex;
  gap: 12px;
  padding: 16px;
  background-color: #f8fafc;
  border-top: 1px solid #e2e8f0;
}

.action-card.inventory .action-card-footer {
  background-color: #f0f9ff;
  border-top-color: #bae6fd;
}

.modal-footer {
  padding: 16px 20px;
  border-top: 1px solid #e2e8f0;
  display: flex;
  justify-content: flex-end;
  gap: 12px;
}

.primary-button, .secondary-button {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 8px 16px;
  border-radius: 6px;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s ease;
}

.primary-button {
  background-color: #3b82f6;
  color: white;
  border: none;
}

.primary-button:hover {
  background-color: #2563eb;
}

.secondary-button {
  background-color: white;
  color: #334155;
  border: 1px solid #e2e8f0;
}

.secondary-button:hover {
  background-color: #f8fafc;
}

/* 响应式调整 */
@media (max-width: 768px) {
  .controls-section {
    flex-direction: column;
    align-items: flex-start;
  }
  
  .search-bar {
    max-width: none;
    width: 100%;
  }
  
  .filter-options {
    width: 100%;
  }
  
  .filter-options select {
    flex: 1;
  }
  
  .message-sender {
    display: none;
  }
  
  .message-time {
    width: auto;
  }
  
  .message-actions {
    opacity: 1;
  }
  
  .notification-modal {
    padding: 10px;
  }
  
  .modal-content {
    max-height: 95vh;
  }
}
</style>