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
              placeholder="搜索商品名称、编号或条码..."
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
              v-model="categoryFilter"
              class="w-full py-2 pl-3 pr-8 border border-gray-300 rounded-md text-sm focus:outline-none focus:ring-1 focus:ring-blue-500 focus:border-blue-500"
            >
              <option value="">所有分类</option>
              <option value="电子产品">电子产品</option>
              <option value="家具">家具</option>
              <option value="服装">服装</option>
              <option value="食品">食品</option>
              <option value="玩具">玩具</option>
            </select>
          </div>
          
          <div class="w-40">
            <select 
              v-model="statusFilter"
              class="w-full py-2 pl-3 pr-8 border border-gray-300 rounded-md text-sm focus:outline-none focus:ring-1 focus:ring-blue-500 focus:border-blue-500"
            >
              <option value="">所有状态</option>
              <option value="in_stock">有库存</option>
              <option value="out_of_stock">缺货</option>
              <option value="low_stock">库存不足</option>
            </select>
          </div>
          
          <button 
            @click="searchProducts"
            class="px-4 py-2 bg-blue-600 text-white text-sm rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2"
          >
            搜索
          </button>
        </div>
      </div>
    </div>
    
    <!-- 商品列表 -->
    <div class="bg-white rounded-lg shadow-sm">
      <div class="overflow-x-auto">
        <table class="min-w-full divide-y divide-gray-200">
          <thead class="bg-gray-50">
            <tr>
              <th scope="col" class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                商品信息
              </th>
              <th scope="col" class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                分类
              </th>
              <th scope="col" class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                价格
              </th>
              <th scope="col" class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                库存
              </th>
              <th scope="col" class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                状态
              </th>
              <th scope="col" class="px-4 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">
                操作
              </th>
            </tr>
          </thead>
          <tbody class="bg-white divide-y divide-gray-200">
            <tr v-for="product in filteredProducts" :key="product.id">
              <td class="px-4 py-3 whitespace-nowrap">
                <div class="flex items-center">
                  <div class="h-10 w-10 flex-shrink-0 bg-gray-100 rounded-md overflow-hidden">
                    <img :src="product.image" :alt="product.name" class="h-full w-full object-cover" />
                  </div>
                  <div class="ml-3">
                    <div class="text-sm font-medium text-gray-900">{{ product.name }}</div>
                    <div class="text-xs text-gray-500">编号: {{ product.sku }}</div>
                  </div>
                </div>
              </td>
              <td class="px-4 py-3 whitespace-nowrap">
                <div class="text-sm text-gray-900">{{ product.category }}</div>
              </td>
              <td class="px-4 py-3 whitespace-nowrap">
                <div class="text-sm text-gray-900">¥{{ product.price.toFixed(2) }}</div>
              </td>
              <td class="px-4 py-3 whitespace-nowrap">
                <div class="text-sm text-gray-900">{{ product.stock }}</div>
              </td>
              <td class="px-4 py-3 whitespace-nowrap">
                <span 
                  class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full"
                  :class="{
                    'bg-green-100 text-green-800': product.status === 'in_stock',
                    'bg-red-100 text-red-800': product.status === 'out_of_stock',
                    'bg-yellow-100 text-yellow-800': product.status === 'low_stock'
                  }"
                >
                  {{ getStatusText(product.status) }}
                </span>
              </td>
              <td class="px-4 py-3 whitespace-nowrap text-right text-sm font-medium">
                <button class="text-blue-600 hover:text-blue-900 mr-2">查看</button>
                <button class="text-blue-600 hover:text-blue-900">编辑</button>
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
              显示 <span class="font-medium">1</span> 到 <span class="font-medium">10</span> 条，共 <span class="font-medium">{{ products.length }}</span> 条结果
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
const categoryFilter = ref('');
const statusFilter = ref('');
const products = ref([]);

// 模拟数据
onMounted(() => {
  // 模拟API调用获取商品数据
  products.value = [
    { 
      id: 1, 
      name: '智能手机', 
      sku: 'SP-001', 
      category: '电子产品', 
      price: 2999.00, 
      stock: 25, 
      status: 'in_stock',
      image: 'https://via.placeholder.com/40'
    },
    { 
      id: 2, 
      name: '笔记本电脑', 
      sku: 'LP-002', 
      category: '电子产品', 
      price: 5999.00, 
      stock: 10, 
      status: 'low_stock',
      image: 'https://via.placeholder.com/40'
    },
    { 
      id: 3, 
      name: '办公椅', 
      sku: 'FC-003', 
      category: '家具', 
      price: 599.00, 
      stock: 30, 
      status: 'in_stock',
      image: 'https://via.placeholder.com/40'
    },
    { 
      id: 4, 
      name: '书桌', 
      sku: 'FD-004', 
      category: '家具', 
      price: 899.00, 
      stock: 0, 
      status: 'out_of_stock',
      image: 'https://via.placeholder.com/40'
    },
    { 
      id: 5, 
      name: 'T恤', 
      sku: 'CT-005', 
      category: '服装', 
      price: 99.00, 
      stock: 100, 
      status: 'in_stock',
      image: 'https://via.placeholder.com/40'
    },
    { 
      id: 6, 
      name: '牛仔裤', 
      sku: 'CJ-006', 
      category: '服装', 
      price: 199.00, 
      stock: 5, 
      status: 'low_stock',
      image: 'https://via.placeholder.com/40'
    },
    { 
      id: 7, 
      name: '巧克力', 
      sku: 'FC-007', 
      category: '食品', 
      price: 15.00, 
      stock: 50, 
      status: 'in_stock',
      image: 'https://via.placeholder.com/40'
    },
    { 
      id: 8, 
      name: '玩具车', 
      sku: 'TC-008', 
      category: '玩具', 
      price: 59.00, 
      stock: 20, 
      status: 'in_stock',
      image: 'https://via.placeholder.com/40'
    }
  ];
});

// 计算属性
const filteredProducts = computed(() => {
  let result = [...products.value];
  
  // 搜索过滤
  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase();
    result = result.filter(product => 
      product.name.toLowerCase().includes(query) || 
      product.sku.toLowerCase().includes(query)
    );
  }
  
  // 分类过滤
  if (categoryFilter.value) {
    result = result.filter(product => product.category === categoryFilter.value);
  }
  
  // 状态过滤
  if (statusFilter.value) {
    result = result.filter(product => product.status === statusFilter.value);
  }
  
  return result;
});

// 方法
function searchProducts() {
  // 实际应用中可能需要调用API
  console.log('搜索商品:', searchQuery.value, categoryFilter.value, statusFilter.value);
}

function getStatusText(status) {
  switch (status) {
    case 'in_stock': return '有库存';
    case 'out_of_stock': return '缺货';
    case 'low_stock': return '库存不足';
    default: return '未知';
  }
}
</script>