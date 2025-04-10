<template>
    <div>
      <!-- 搜索和操作 -->
      <div class="bg-white rounded-lg shadow-sm mb-4">
        <div class="p-4 border-b border-gray-100">
          <div class="flex flex-wrap gap-3">
            <div class="relative flex-1 min-w-[200px]">
              <input
                v-model="searchQuery"
                type="text"
                placeholder="搜索用户名、姓名、邮箱..."
                class="w-full pl-8 pr-3 py-2 border border-gray-300 rounded-md text-sm focus:outline-none focus:ring-1 focus:ring-blue-500 focus:border-blue-500"
              />
              <div class="absolute inset-y-0 left-0 pl-2 flex items-center pointer-events-none">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                </svg>
              </div>
            </div>
            
            <div class="w-40">
              <select 
                v-model="roleFilter"
                class="w-full py-2 pl-3 pr-8 border border-gray-300 rounded-md text-sm focus:outline-none focus:ring-1 focus:ring-blue-500 focus:border-blue-500"
              >
                <option value="">所有角色</option>
                <option value="admin">管理员</option>
                <option value="manager">经理</option>
                <option value="staff">普通员工</option>
              </select>
            </div>
            
            <div class="w-40">
              <select 
                v-model="statusFilter"
                class="w-full py-2 pl-3 pr-8 border border-gray-300 rounded-md text-sm focus:outline-none focus:ring-1 focus:ring-blue-500 focus:border-blue-500"
              >
                <option value="">所有状态</option>
                <option value="active">活跃</option>
                <option value="inactive">未激活</option>
                <option value="locked">已锁定</option>
              </select>
            </div>
            
            <button 
              @click="searchUsers"
              class="px-4 py-2 bg-blue-600 text-white text-sm rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2"
            >
              搜索
            </button>
            
            <button 
              @click="showCreateUserModal = true"
              class="px-4 py-2 bg-green-600 text-white text-sm rounded-md hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-green-500 focus:ring-offset-2 ml-auto"
            >
              新增用户
            </button>
          </div>
        </div>
      </div>
      
      <!-- 用户列表 -->
      <div class="bg-white rounded-lg shadow-sm">
        <div class="overflow-x-auto">
          <table class="min-w-full divide-y divide-gray-200">
            <thead class="bg-gray-50">
              <tr>
                <th scope="col" class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  用户
                </th>
                <th scope="col" class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  角色
                </th>
                <th scope="col" class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  联系方式
                </th>
                <th scope="col" class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  状态
                </th>
                <th scope="col" class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  最后登录
                </th>
                <th scope="col" class="px-4 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">
                  操作
                </th>
              </tr>
            </thead>
            <tbody class="bg-white divide-y divide-gray-200">
              <tr v-for="user in filteredUsers" :key="user.id">
                <td class="px-4 py-3 whitespace-nowrap">
                  <div class="flex items-center">
                    <div class="h-8 w-8 rounded-full bg-gray-200 flex items-center justify-center text-gray-600 font-medium">
                      {{ user.name.charAt(0) }}
                    </div>
                    <div class="ml-3">
                      <div class="text-sm font-medium text-gray-900">{{ user.name }}</div>
                      <div class="text-xs text-gray-500">{{ user.username }}</div>
                    </div>
                  </div>
                </td>
                <td class="px-4 py-3 whitespace-nowrap">
                  <div class="text-sm text-gray-900">{{ getRoleText(user.role) }}</div>
                </td>
                <td class="px-4 py-3 whitespace-nowrap">
                  <div class="text-sm text-gray-900">{{ user.email }}</div>
                  <div class="text-xs text-gray-500">{{ user.phone }}</div>
                </td>
                <td class="px-4 py-3 whitespace-nowrap">
                  <span 
                    class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full"
                    :class="{
                      'bg-green-100 text-green-800': user.status === 'active',
                      'bg-yellow-100 text-yellow-800': user.status === 'inactive',
                      'bg-red-100 text-red-800': user.status === 'locked'
                    }"
                  >
                    {{ getStatusText(user.status) }}
                  </span>
                </td>
                <td class="px-4 py-3 whitespace-nowrap">
                  <div class="text-sm text-gray-900">{{ user.lastLogin }}</div>
                </td>
                <td class="px-4 py-3 whitespace-nowrap text-right text-sm font-medium">
                  <button @click="editUser(user)" class="text-blue-600 hover:text-blue-900 mr-2">编辑</button>
                  <button v-if="user.status === 'active'" @click="lockUser(user)" class="text-yellow-600 hover:text-yellow-900 mr-2">锁定</button>
                  <button v-else-if="user.status === 'locked'" @click="unlockUser(user)" class="text-green-600 hover:text-green-900 mr-2">解锁</button>
                  <button v-if="user.status === 'inactive'" @click="activateUser(user)" class="text-green-600 hover:text-green-900 mr-2">激活</button>
                  <button @click="resetPassword(user)" class="text-blue-600 hover:text-blue-900 mr-2">重置密码</button>
                  <button @click="deleteUser(user)" class="text-red-600 hover:text-red-900">删除</button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
        
        <!-- 分页 -->
        <div class="bg-white px-4 py-3 flex items-center justify-between border-t border-gray-200 sm:px-6">
          <div class="flex-1 flex justify-between sm:hidden">
            <button class="relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50">
              上一页
            </button>
            <button class="ml-3 relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50">
              下一页
            </button>
          </div>
          <div class="hidden sm:flex-1 sm:flex sm:items-center sm:justify-between">
            <div>
              <p class="text-sm text-gray-700">
                显示 <span class="font-medium">1</span> 到 <span class="font-medium">10</span> 条，共 <span class="font-medium">{{ users.length }}</span> 条结果
              </p>
            </div>
            <div>
              <nav class="relative z-0 inline-flex rounded-md shadow-sm -space-x-px" aria-label="Pagination">
                <button class="relative inline-flex items-center px-2 py-2 rounded-l-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50">
                  <span class="sr-only">上一页</span>
                  <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                    <path fill-rule="evenodd" d="M12.707 5.293a1 1 0 010 1.414L9.414 10l3.293 3.293a1 1 0 01-1.414 1.414l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 0z" clip-rule="evenodd" />
                  </svg>
                </button>
                <button class="relative inline-flex items-center px-4 py-2 border border-gray-300 bg-white text-sm font-medium text-gray-700 hover:bg-gray-50">
                  1
                </button>
                <button class="relative inline-flex items-center px-4 py-2 border border-gray-300 bg-white text-sm font-medium text-gray-700 hover:bg-gray-50">
                  2
                </button>
                <button class="relative inline-flex items-center px-4 py-2 border border-gray-300 bg-white text-sm font-medium text-gray-700 hover:bg-gray-50">
                  3
                </button>
                <button class="relative inline-flex items-center px-2 py-2 rounded-r-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50">
                  <span class="sr-only">下一页</span>
                  <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                    <path fill-rule="evenodd" d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" clip-rule="evenodd" />
                  </svg>
                </button>
              </nav>
            </div>
          </div>
        </div>
      </div>
      
      <!-- 创建用户模态框 (简化版) -->
      <div v-if="showCreateUserModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
        <div class="bg-white rounded-lg shadow-xl max-w-md w-full p-6">
          <div class="flex justify-between items-center mb-4">
            <h3 class="text-lg font-medium text-gray-900">新增用户</h3>
            <button @click="showCreateUserModal = false" class="text-gray-500 hover:text-gray-700">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
          </div>
          <div class="space-y-4">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">用户名</label>
              <input 
                v-model="newUser.username" 
                type="text" 
                class="w-full px-3 py-2 border border-gray-300 rounded-md text-sm focus:outline-none focus:ring-1 focus:ring-blue-500 focus:border-blue-500"
                placeholder="输入用户名"
              />
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">姓名</label>
              <input 
                v-model="newUser.name" 
                type="text" 
                class="w-full px-3 py-2 border border-gray-300 rounded-md text-sm focus:outline-none focus:ring-1 focus:ring-blue-500 focus:border-blue-500"
                placeholder="输入姓名"
              />
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">邮箱</label>
              <input 
                v-model="newUser.email" 
                type="email" 
                class="w-full px-3 py-2 border border-gray-300 rounded-md text-sm focus:outline-none focus:ring-1 focus:ring-blue-500 focus:border-blue-500"
                placeholder="输入邮箱"
              />
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">手机号</label>
              <input 
                v-model="newUser.phone" 
                type="text" 
                class="w-full px-3 py-2 border border-gray-300 rounded-md text-sm focus:outline-none focus:ring-1 focus:ring-blue-500 focus:border-blue-500"
                placeholder="输入手机号"
              />
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">角色</label>
              <select 
                v-model="newUser.role"
                class="w-full px-3 py-2 border border-gray-300 rounded-md text-sm focus:outline-none focus:ring-1 focus:ring-blue-500 focus:border-blue-500"
              >
                <option value="admin">管理员</option>
                <option value="manager">经理</option>
                <option value="staff">普通员工</option>
              </select>
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">密码</label>
              <input 
                v-model="newUser.password" 
                type="password" 
                class="w-full px-3 py-2 border border-gray-300 rounded-md text-sm focus:outline-none focus:ring-1 focus:ring-blue-500 focus:border-blue-500"
                placeholder="输入密码"
              />
            </div>
          </div>
          <div class="mt-6 flex justify-end space-x-3">
            <button 
              @click="showCreateUserModal = false"
              class="px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
            >
              取消
            </button>
            <button 
              @click="createUser"
              class="px-4 py-2 bg-blue-600 text-white text-sm font-medium rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
            >
              创建
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
  const roleFilter = ref('');
  const statusFilter = ref('');
  const users = ref([]);
  const showCreateUserModal = ref(false);
  const newUser = ref({
    username: '',
    name: '',
    email: '',
    phone: '',
    role: 'staff',
    password: ''
  });
  
  // 模拟数据
  onMounted(() => {
    // 模拟API调用获取用户数据
    users.value = [
      { 
        id: 1, 
        username: 'admin', 
        name: '系统管理员', 
        email: 'admin@example.com', 
        phone: '13800138000', 
        role: 'admin', 
        status: 'active', 
        lastLogin: '2023-05-10 08:30:15' 
      },
      { 
        id: 2, 
        username: 'zhangsan', 
        name: '张三', 
        email: 'zhangsan@example.com', 
        phone: '13900139001', 
        role: 'manager', 
        status: 'active', 
        lastLogin: '2023-05-09 17:45:22' 
      },
      { 
        id: 3, 
        username: 'lisi', 
        name: '李四', 
        email: 'lisi@example.com', 
        phone: '13700137002', 
        role: 'staff', 
        status: 'active', 
        lastLogin: '2023-05-10 09:12:33' 
      },
      { 
        id: 4, 
        username: 'wangwu', 
        name: '王五', 
        email: 'wangwu@example.com', 
        phone: '13600136003', 
        role: 'staff', 
        status: 'locked', 
        lastLogin: '2023-05-08 14:20:45' 
      },
      { 
        id: 5, 
        username: 'zhaoliu', 
        name: '赵六', 
        email: 'zhaoliu@example.com', 
        phone: '13500135004', 
        role: 'staff', 
        status: 'inactive', 
        lastLogin: '未登录' 
      }
    ];
  });
  
  // 计算属性
  const filteredUsers = computed(() => {
    let result = [...users.value];
    
    // 搜索过滤
    if (searchQuery.value) {
      const query = searchQuery.value.toLowerCase();
      result = result.filter(user => 
        user.username.toLowerCase().includes(query) || 
        user.name.toLowerCase().includes(query) ||
        user.email.toLowerCase().includes(query) ||
        user.phone.includes(query)
      );
    }
    
    // 角色过滤
    if (roleFilter.value) {
      result = result.filter(user => user.role === roleFilter.value);
    }
    
    // 状态过滤
    if (statusFilter.value) {
      result = result.filter(user => user.status === statusFilter.value);
    }
    
    return result;
  });
  
  // 方法
  function searchUsers() {
    // 实际应用中可能需要调用API
    console.log('搜索用户:', searchQuery.value, roleFilter.value, statusFilter.value);
  }
  
  function editUser(user) {
    // 实际应用中应打开编辑模态框
    console.log('编辑用户:', user);
  }
  
  function lockUser(user) {
    // 实际应用中应显示确认对话框
    if (confirm(`确定要锁定用户 "${user.name}" 吗？`)) {
      // 模拟锁定操作
      user.status = 'locked';
    }
  }
  
  function unlockUser(user) {
    // 实际应用中应显示确认对话框
    if (confirm(`确定要解锁用户 "${user.name}" 吗？`)) {
      // 模拟解锁操作
      user.status = 'active';
    }
  }
  
  function activateUser(user) {
    // 实际应用中应显示确认对话框
    if (confirm(`确定要激活用户 "${user.name}" 吗？`)) {
      // 模拟激活操作
      user.status = 'active';
    }
  }
  
  function resetPassword(user) {
    // 实际应用中应显示确认对话框
    if (confirm(`确定要重置用户 "${user.name}" 的密码吗？`)) {
      // 模拟重置密码操作
      alert(`密码已重置为: 123456`);
    }
  }
  
  function deleteUser(user) {
    // 实际应用中应显示确认对话框
    if (confirm(`确定要删除用户 "${user.name}" 吗？`)) {
      // 模拟删除操作
      users.value = users.value.filter(u => u.id !== user.id);
    }
  }
  
  function getRoleText(role) {
    switch (role) {
      case 'admin': return '管理员';
      case 'manager': return '经理';
      case 'staff': return '普通员工';
      default: return '未知';
    }
  }
  
  function getStatusText(status) {
    switch (status) {
      case 'active': return '活跃';
      case 'inactive': return '未激活';
      case 'locked': return '已锁定';
      default: return '未知';
    }
  }
  
  function createUser() {
    // 模拟创建用户
    const newUserObj = {
      id: users.value.length + 1,
      username: newUser.value.username,
      name: newUser.value.name,
      email: newUser.value.email,
      phone: newUser.value.phone,
      role: newUser.value.role,
      status: 'active',
      lastLogin: '未登录'
    };
    
    users.value.push(newUserObj);
    
    // 重置表单
    newUser.value = {
      username: '',
      name: '',
      email: '',
      phone: '',
      role: 'staff',
      password: ''
    };
    
    // 关闭模态框
    showCreateUserModal.value = false;
  }
  </script>