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
                placeholder="搜索工厂/商店名称、地址..."
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
                <option value="factory">工厂</option>
                <option value="store">商店</option>
                <option value="warehouse">仓库</option>
              </select>
            </div>
            
            <button 
              @click="searchLocations"
              class="px-4 py-2 bg-blue-600 text-white text-sm rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2"
            >
              搜索
            </button>
            
            <button 
              @click="showCreateLocationModal = true"
              class="px-4 py-2 bg-green-600 text-white text-sm rounded-md hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-green-500 focus:ring-offset-2 ml-auto"
            >
              新增地点
            </button>
          </div>
        </div>
      </div>
      
      <!-- 地点列表 -->
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
        <div v-for="location in filteredLocations" :key="location.id" class="bg-white rounded-lg shadow-sm overflow-hidden">
          <div class="p-4 border-b border-gray-100 flex justify-between items-center">
            <div class="flex items-center">
              <div class="bg-gray-100 rounded-full p-2 mr-3">
                <svg v-if="location.type === 'factory'" xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-gray-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" />
                </svg>
                <svg v-else-if="location.type === 'store'" xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-gray-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z" />
                </svg>
                <svg v-else xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-gray-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 8h14M5 8a2 2 0 110-4h14a2 2 0 110 4M5 8v10a2 2 0 002 2h10a2 2 0 002-2V8m-9 4h4" />
                </svg>
              </div>
              <div>
                <h3 class="text-sm font-medium text-gray-900">{{ location.name }}</h3>
                <p class="text-xs text-gray-500">{{ getTypeText(location.type) }}</p>
              </div>
            </div>
            <div class="flex space-x-1">
              <button 
                @click="editLocation(location)"
                class="p-1 text-gray-500 hover:text-gray-700 rounded-full hover:bg-gray-100"
              >
                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z" />
                </svg>
              </button>
              <button 
                @click="deleteLocation(location)"
                class="p-1 text-gray-500 hover:text-red-700 rounded-full hover:bg-gray-100"
              >
                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                </svg>
              </button>
            </div>
          </div>
          <div class="p-4">
            <div class="space-y-3">
              <div>
                <div class="text-xs text-gray-500 mb-1">地址</div>
                <div class="text-sm text-gray-700">{{ location.address }}</div>
              </div>
              <div>
                <div class="text-xs text-gray-500 mb-1">联系人</div>
                <div class="text-sm text-gray-700">{{ location.contact }}</div>
              </div>
              <div>
                <div class="text-xs text-gray-500 mb-1">联系电话</div>
                <div class="text-sm text-gray-700">{{ location.phone }}</div>
              </div>
              <div class="grid grid-cols-2 gap-2">
                <div class="bg-gray-50 p-2 rounded">
                  <div class="text-xs text-gray-500 mb-1">商品数量</div>
                  <div class="text-sm font-medium">{{ location.productCount }}</div>
                </div>
                <div class="bg-gray-50 p-2 rounded">
                  <div class="text-xs text-gray-500 mb-1">库存总量</div>
                  <div class="text-sm font-medium">{{ location.stockCount }}</div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <!-- 创建地点模态框 (简化版) -->
      <div v-if="showCreateLocationModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
        <div class="bg-white rounded-lg shadow-xl max-w-md w-full p-6">
          <div class="flex justify-between items-center mb-4">
            <h3 class="text-lg font-medium text-gray-900">新增地点</h3>
            <button @click="showCreateLocationModal = false" class="text-gray-500 hover:text-gray-700">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
          </div>
          <div class="space-y-4">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">名称</label>
              <input 
                v-model="newLocation.name" 
                type="text" 
                class="w-full px-3 py-2 border border-gray-300 rounded-md text-sm focus:outline-none focus:ring-1 focus:ring-blue-500 focus:border-blue-500"
                placeholder="输入地点名称"
              />
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">类型</label>
              <select 
                v-model="newLocation.type"
                class="w-full px-3 py-2 border border-gray-300 rounded-md text-sm focus:outline-none focus:ring-1 focus:ring-blue-500 focus:border-blue-500"
              >
                <option value="factory">工厂</option>
                <option value="store">商店</option>
                <option value="warehouse">仓库</option>
              </select>
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">地址</label>
              <input 
                v-model="newLocation.address" 
                type="text" 
                class="w-full px-3 py-2 border border-gray-300 rounded-md text-sm focus:outline-none focus:ring-1 focus:ring-blue-500 focus:border-blue-500"
                placeholder="输入地址"
              />
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">联系人</label>
              <input 
                v-model="newLocation.contact" 
                type="text" 
                class="w-full px-3 py-2 border border-gray-300 rounded-md text-sm focus:outline-none focus:ring-1 focus:ring-blue-500 focus:border-blue-500"
                placeholder="输入联系人姓名"
              />
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">联系电话</label>
              <input 
                v-model="newLocation.phone" 
                type="text" 
                class="w-full px-3 py-2 border border-gray-300 rounded-md text-sm focus:outline-none focus:ring-1 focus:ring-blue-500 focus:border-blue-500"
                placeholder="输入联系电话"
              />
            </div>
          </div>
          <div class="mt-6 flex justify-end space-x-3">
            <button 
              @click="showCreateLocationModal = false"
              class="px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
            >
              取消
            </button>
            <button 
              @click="createLocation"
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
  const typeFilter = ref('');
  const locations = ref([]);
  const showCreateLocationModal = ref(false);
  const newLocation = ref({
    name: '',
    type: 'factory',
    address: '',
    contact: '',
    phone: ''
  });
  
  // 模拟数据
  onMounted(() => {
    // 模拟API调用获取地点数据
    locations.value = [
      { 
        id: 1, 
        name: '北京生产工厂', 
        type: 'factory', 
        address: '北京市顺义区某某工业园区A12号', 
        contact: '张经理', 
        phone: '010-12345678', 
        productCount: 120, 
        stockCount: 5000 
      },
      { 
        id: 2, 
        name: '上海中央仓库', 
        type: 'warehouse', 
        address: '上海市浦东新区某某物流园B5号', 
        contact: '李主管', 
        phone: '021-87654321', 
        productCount: 350, 
        stockCount: 12000 
      },
      { 
        id: 3, 
        name: '广州旗舰店', 
        type: 'store', 
        address: '广州市天河区某某商业广场C座101', 
        contact: '王店长', 
        phone: '020-55667788', 
        productCount: 80, 
        stockCount: 500 
      },
      { 
        id: 4, 
        name: '深圳南山店', 
        type: 'store', 
        address: '深圳市南山区某某购物中心2楼2088号', 
        contact: '刘店长', 
        phone: '0755-99887766', 
        productCount: 65, 
        stockCount: 320 
      },
      { 
        id: 5, 
        name: '成都配送中心', 
        type: 'warehouse', 
        address: '成都市双流区某某物流基地D区', 
        contact: '赵经理', 
        phone: '028-11223344', 
        productCount: 180, 
        stockCount: 3500 
      }
    ];
  });
  
  // 计算属性
  const filteredLocations = computed(() => {
    let result = [...locations.value];
    
    // 搜索过滤
    if (searchQuery.value) {
      const query = searchQuery.value.toLowerCase();
      result = result.filter(location => 
        location.name.toLowerCase().includes(query) || 
        location.address.toLowerCase().includes(query) ||
        location.contact.toLowerCase().includes(query)
      );
    }
    
    // 类型过滤
    if (typeFilter.value) {
      result = result.filter(location => location.type === typeFilter.value);
    }
    
    return result;
  });
  
  // 方法
  function searchLocations() {
    // 实际应用中可能需要调用API
    console.log('搜索地点:', searchQuery.value, typeFilter.value);
  }
  
  function editLocation(location) {
    // 实际应用中应打开编辑模态框
    console.log('编辑地点:', location);
  }
  
  function deleteLocation(location) {
    // 实际应用中应显示确认对话框
    console.log('删除地点:', location);
    
    if (confirm(`确定要删除地点 "${location.name}" 吗？`)) {
      // 模拟删除操作
      locations.value = locations.value.filter(l => l.id !== location.id);
    }
  }
  
  function getTypeText(type) {
    switch (type) {
      case 'factory': return '工厂';
      case 'store': return '商店';
      case 'warehouse': return '仓库';
      default: return '未知';
    }
  }
  
  function createLocation() {
    // 模拟创建地点
    const newLocationObj = {
      id: locations.value.length + 1,
      name: newLocation.value.name,
      type: newLocation.value.type,
      address: newLocation.value.address,
      contact: newLocation.value.contact,
      phone: newLocation.value.phone,
      productCount: 0,
      stockCount: 0
    };
    
    locations.value.push(newLocationObj);
    
    // 重置表单
    newLocation.value = {
      name: '',
      type: 'factory',
      address: '',
      contact: '',
      phone: ''
    };
    
    // 关闭模态框
    showCreateLocationModal.value = false;
  }
  </script>