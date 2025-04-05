<template>
    <div>
      <!-- 搜索和筛选 -->
      <div class="bg-white rounded-lg shadow-sm mb-4">
        <div class="p-4 border-b border-gray-100">
          <div class="flex flex-wrap gap-3">
            <div class="relative flex-1 min-w-[200px]">
              <input
                v-model="searchQuery"
                type="text"
                placeholder="搜索日志内容、操作人..."
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
                v-model="typeFilter"
                class="w-full py-2 pl-3 pr-8 border border-gray-300 rounded-md text-sm focus:outline-none focus:ring-1 focus:ring-blue-500 focus:border-blue-500"
              >
                <option value="">所有类型</option>
                <option value="login">登录</option>
                <option value="logout">登出</option>
                <option value="create">创建</option>
                <option value="update">更新</option>
                <option value="delete">删除</option>
                <option value="error">错误</option>
              </select>
            </div>
            
            <div class="w-40">
              <select 
                v-model="dateFilter"
                class="w-full py-2 pl-3 pr-8 border border-gray-300 rounded-md text-sm focus:outline-none focus:ring-1 focus:ring-blue-500 focus:border-blue-500"
              >
                <option value="">所有时间</option>
                <option value="today">今天</option>
                <option value="yesterday">昨天</option>
                <option value="week">本周</option>
                <option value="month">本月</option>
              </select>
            </div>
            
            <button 
              @click="searchLogs"
              class="px-4 py-2 bg-blue-600 text-white text-sm rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2"
            >
              搜索
            </button>
            
            <button 
              class="px-4 py-2 border border-gray-300 text-sm rounded-md text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 ml-auto"
            >
              导出日志
            </button>
          </div>
        </div>
      </div>
      
      <!-- 日志列表 -->
      <div class="bg-white rounded-lg shadow-sm">
        <div class="overflow-x-auto">
          <table class="min-w-full divide-y divide-gray-200">
            <thead class="bg-gray-50">
              <tr>
                <th scope="col" class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  时间
                </th>
                <th scope="col" class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  类型
                </th>
                <th scope="col" class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  操作人
                </th>
                <th scope="col" class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  IP地址
                </th>
                <th scope="col" class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  内容
                </th>
              </tr>
            </thead>
            <tbody class="bg-white divide-y divide-gray-200">
              <tr v-for="log in filteredLogs" :key="log.id">
                <td class="px-4 py-3 whitespace-nowrap">
                  <div class="text-sm text-gray-900">{{ log.timestamp }}</div>
                </td>
                <td class="px-4 py-3 whitespace-nowrap">
                  <span 
                    class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full"
                    :class="{
                      'bg-green-100 text-green-800': log.type === 'login',
                      'bg-gray-100 text-gray-800': log.type === 'logout',
                      'bg-blue-100 text-blue-800': log.type === 'create',
                      'bg-yellow-100 text-yellow-800': log.type === 'update',
                      'bg-red-100 text-red-800': log.type === 'delete' || log.type === 'error'
                    }"
                  >
                    {{ getTypeText(log.type) }}
                  </span>
                </td>
                <td class="px-4 py-3 whitespace-nowrap">
                  <div class="text-sm text-gray-900">{{ log.user }}</div>
                </td>
                <td class="px-4 py-3 whitespace-nowrap">
                  <div class="text-sm text-gray-900">{{ log.ip }}</div>
                </td>
                <td class="px-4 py-3">
                  <div class="text-sm text-gray-900 max-w-md truncate">{{ log.content }}</div>
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
                显示 <span class="font-medium">1</span> 到 <span class="font-medium">10</span> 条，共 <span class="font-medium">{{ logs.length }}</span> 条结果
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
    </div>
  </template>
  
  <script setup>
  import { ref, computed, onMounted } from 'vue';
  
  // 状态
  const searchQuery = ref('');
  const typeFilter = ref('');
  const dateFilter = ref('');
  const logs = ref([]);
  
  // 模拟数据
  onMounted(() => {
    // 模拟API调用获取日志数据
    logs.value = [
      { 
        id: 1, 
        timestamp: '2023-05-10 08:30:15', 
        type: 'login', 
        user: '管理员', 
        ip: '192.168.1.100', 
        content: '用户登录系统' 
      },
      { 
        id: 2, 
        timestamp: '2023-05-10 09:15:22', 
        type: 'create', 
        user: '管理员', 
        ip: '192.168.1.100', 
        content: '创建新商品：智能手机' 
      },
      { 
        id: 3, 
        timestamp: '2023-05-10 10:05:47', 
        type: 'update', 
        user: '库存管理员', 
        ip: '192.168.1.101', 
        content: '更新商品库存：笔记本电脑 +5' 
      },
      { 
        id: 4, 
        timestamp: '2023-05-10 11:30:08', 
        type: 'delete', 
        user: '管理员', 
        ip: '192.168.1.100', 
        content: '删除过期商品：巧克力' 
      },
      { 
        id: 5, 
        timestamp: '2023-05-10 13:45:33', 
        type: 'error', 
        user: '系统', 
        ip: '192.168.1.1', 
        content: '数据库连接错误：连接超时' 
      },
      { 
        id: 6, 
        timestamp: '2023-05-10 15:20:19', 
        type: 'update', 
        user: '库存管理员', 
        ip: '192.168.1.101', 
        content: '更新商品价格：T恤 ¥99.00 -> ¥89.00' 
      },
      { 
        id: 7, 
        timestamp: '2023-05-10 16:55:42', 
        type: 'logout', 
        user: '库存管理员', 
        ip: '192.168.1.101', 
        content: '用户登出系统' 
      },
      { 
        id: 8, 
        timestamp: '2023-05-10 17:30:05', 
        type: 'logout', 
        user: '管理员', 
        ip: '192.168.1.100', 
        content: '用户登出系统' 
      }
    ];
  });
  
  // 计算属性
  const filteredLogs = computed(() => {
    let result = [...logs.value];
    
    // 搜索过滤
    if (searchQuery.value) {
      const query = searchQuery.value.toLowerCase();
      result = result.filter(log => 
        log.content.toLowerCase().includes(query) || 
        log.user.toLowerCase().includes(query)
      );
    }
    
    // 类型过滤
    if (typeFilter.value) {
      result = result.filter(log => log.type === typeFilter.value);
    }
    
    // 日期过滤 (简化实现)
    if (dateFilter.value) {
      // 实际应用中应该根据日期范围过滤
      console.log('按日期过滤:', dateFilter.value);
    }
    
    return result;
  });
  
  // 方法
  function searchLogs() {
    // 实际应用中可能需要调用API
    console.log('搜索日志:', searchQuery.value, typeFilter.value, dateFilter.value);
  }
  
  function getTypeText(type) {
    switch (type) {
      case 'login': return '登录';
      case 'logout': return '登出';
      case 'create': return '创建';
      case 'update': return '更新';
      case 'delete': return '删除';
      case 'error': return '错误';
      default: return '未知';
    }
  }
  </script>