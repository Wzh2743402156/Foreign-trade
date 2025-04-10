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
                placeholder="搜索包裹编号、收件人..."
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
                v-model="statusFilter"
                class="w-full py-2 pl-3 pr-8 border border-gray-300 rounded-md text-sm focus:outline-none focus:ring-1 focus:ring-blue-500 focus:border-blue-500"
              >
                <option value="">所有状态</option>
                <option value="pending">待处理</option>
                <option value="processing">处理中</option>
                <option value="shipped">已发货</option>
                <option value="delivered">已送达</option>
                <option value="returned">已退回</option>
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
              @click="searchPackages"
              class="px-4 py-2 bg-blue-600 text-white text-sm rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2"
            >
              搜索
            </button>
            
            <button 
              class="px-4 py-2 bg-green-600 text-white text-sm rounded-md hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-green-500 focus:ring-offset-2 ml-auto"
            >
              新建包裹
            </button>
          </div>
        </div>
      </div>
      
      <!-- 包裹列表 -->
      <div class="bg-white rounded-lg shadow-sm">
        <div class="overflow-x-auto">
          <table class="min-w-full divide-y divide-gray-200">
            <thead class="bg-gray-50">
              <tr>
                <th scope="col" class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  包裹编号
                </th>
                <th scope="col" class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  收件人
                </th>
                <th scope="col" class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  创建时间
                </th>
                <th scope="col" class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  状态
                </th>
                <th scope="col" class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  物品数量
                </th>
                <th scope="col" class="px-4 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">
                  操作
                </th>
              </tr>
            </thead>
            <tbody class="bg-white divide-y divide-gray-200">
              <tr v-for="pkg in filteredPackages" :key="pkg.id">
                <td class="px-4 py-3 whitespace-nowrap">
                  <div class="text-sm font-medium text-gray-900">{{ pkg.trackingNumber }}</div>
                </td>
                <td class="px-4 py-3 whitespace-nowrap">
                  <div class="text-sm text-gray-900">{{ pkg.recipient }}</div>
                  <div class="text-xs text-gray-500">{{ pkg.address }}</div>
                </td>
                <td class="px-4 py-3 whitespace-nowrap">
                  <div class="text-sm text-gray-900">{{ pkg.createdAt }}</div>
                </td>
                <td class="px-4 py-3 whitespace-nowrap">
                  <span 
                    class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full"
                    :class="{
                      'bg-yellow-100 text-yellow-800': pkg.status === 'pending',
                      'bg-blue-100 text-blue-800': pkg.status === 'processing',
                      'bg-purple-100 text-purple-800': pkg.status === 'shipped',
                      'bg-green-100 text-green-800': pkg.status === 'delivered',
                      'bg-red-100 text-red-800': pkg.status === 'returned'
                    }"
                  >
                    {{ getStatusText(pkg.status) }}
                  </span>
                </td>
                <td class="px-4 py-3 whitespace-nowrap">
                  <div class="text-sm text-gray-900">{{ pkg.itemCount }}</div>
                </td>
                <td class="px-4 py-3 whitespace-nowrap text-right text-sm font-medium">
                  <button class="text-blue-600 hover:text-blue-900 mr-2">查看</button>
                  <button class="text-blue-600 hover:text-blue-900 mr-2">编辑</button>
                  <button class="text-red-600 hover:text-red-900">删除</button>
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
                显示 <span class="font-medium">1</span> 到 <span class="font-medium">10</span> 条，共 <span class="font-medium">{{ packages.length }}</span> 条结果
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
  const statusFilter = ref('');
  const dateFilter = ref('');
  const packages = ref([]);
  
  // 模拟数据
  onMounted(() => {
    // 模拟API调用获取包裹数据
    packages.value = [
      { 
        id: 1, 
        trackingNumber: 'PKG-20230501-001', 
        recipient: '张三', 
        address: '北京市朝阳区某某街道123号', 
        createdAt: '2023-05-01', 
        status: 'delivered', 
        itemCount: 3 
      },
      { 
        id: 2, 
        trackingNumber: 'PKG-20230502-002', 
        recipient: '李四', 
        address: '上海市浦东新区某某路456号', 
        createdAt: '2023-05-02', 
        status: 'shipped', 
        itemCount: 1 
      },
      { 
        id: 3, 
        trackingNumber: 'PKG-20230503-003', 
        recipient: '王五', 
        address: '广州市天河区某某大道789号', 
        createdAt: '2023-05-03', 
        status: 'processing', 
        itemCount: 2 
      },
      { 
        id: 4, 
        trackingNumber: 'PKG-20230504-004', 
        recipient: '赵六', 
        address: '深圳市南山区某某街101号', 
        createdAt: '2023-05-04', 
        status: 'pending', 
        itemCount: 5 
      },
      { 
        id: 5, 
        trackingNumber: 'PKG-20230505-005', 
        recipient: '钱七', 
        address: '成都市武侯区某某路202号', 
        createdAt: '2023-05-05', 
        status: 'returned', 
        itemCount: 1 
      }
    ];
  });
  
  // 计算属性
  const filteredPackages = computed(() => {
    let result = [...packages.value];
    
    // 搜索过滤
    if (searchQuery.value) {
      const query = searchQuery.value.toLowerCase();
      result = result.filter(pkg => 
        pkg.trackingNumber.toLowerCase().includes(query) || 
        pkg.recipient.toLowerCase().includes(query) ||
        pkg.address.toLowerCase().includes(query)
      );
    }
    
    // 状态过滤
    if (statusFilter.value) {
      result = result.filter(pkg => pkg.status === statusFilter.value);
    }
    
    // 日期过滤 (简化实现)
    if (dateFilter.value) {
      // 实际应用中应该根据日期范围过滤
      console.log('按日期过滤:', dateFilter.value);
    }
    
    return result;
  });
  
  // 方法
  function searchPackages() {
    // 实际应用中可能需要调用API
    console.log('搜索包裹:', searchQuery.value, statusFilter.value, dateFilter.value);
  }
  
  function getStatusText(status) {
    switch (status) {
      case 'pending': return '待处理';
      case 'processing': return '处理中';
      case 'shipped': return '已发货';
      case 'delivered': return '已送达';
      case 'returned': return '已退回';
      default: return '未知';
    }
  }
  </script>