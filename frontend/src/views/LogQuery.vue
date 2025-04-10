<template>
  <div>
    <!-- 搜索和筛选 -->
    <div class="bg-white rounded-lg shadow-sm mb-4">
      <div class="p-4 border-b border-gray-100">
        <div class="flex flex-wrap gap-3">
          <!-- 搜索框 -->
          <select v-model="searchMode" class="border border-gray-300 rounded-md px-2 py-1 text-sm">
  <option value="operator">操作人</option>
  <option value="product">产品 ID</option>
  <option value="package">包裹 ID</option>
</select>

          <div class="relative flex-1 min-w-[200px]">
            
            <input v-model="searchQuery" type="text" placeholder="搜索日志内容、操作人..."
              class="w-full pl-8 pr-3 py-2 border border-gray-300 rounded-md text-sm focus:outline-none focus:ring-1 focus:ring-blue-500 focus:border-blue-500" />
            <div class="absolute inset-y-0 left-0 pl-2 flex items-center pointer-events-none">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
              </svg>
            </div>
          </div>

          <!-- 类型筛选 -->
          <div class="w-40">
            <select v-model="typeFilter"
              class="w-full py-2 pl-3 pr-8 border border-gray-300 rounded-md text-sm focus:outline-none focus:ring-1 focus:ring-blue-500 focus:border-blue-500">
              <option value="">所有类型</option>
              <option value="inbound_factory">工厂入库</option>
              <option value="outbound_factory">工厂出库</option>
              <option value="inbound_shop">商店入库</option>
              <option value="outbound_shop">商店出库</option>
            </select>
          </div>

          <!-- 时间筛选 -->
          <div class="w-40">
            <select v-model="dateFilter" @change="onDateFilterChange"
              class="w-full py-2 pl-3 pr-8 border border-gray-300 rounded-md text-sm focus:outline-none focus:ring-1 focus:ring-blue-500 focus:border-blue-500">
              <option value="">所有时间</option>
              <option value="today">今天</option>
              <option value="yesterday">昨天</option>
              <option value="week">本周</option>
              <option value="month">本月</option>
            </select>
          </div>

          <!-- 页大小下拉 -->
          <div class="w-40">
            <select v-model="pageSize" @change="goToPage(1)"
              class="w-full py-2 pl-3 pr-8 border border-gray-300 rounded-md text-sm focus:outline-none focus:ring-1 focus:ring-blue-500 focus:border-blue-500">
              <option :value="10">每页 10 条</option>
              <option :value="20">每页 20 条</option>
              <option :value="50">每页 50 条</option>
            </select>
          </div>

          <!-- 搜索按钮 -->
          <button @click="searchLogs"
            class="px-4 py-2 bg-blue-600 text-white text-sm rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2">
            搜索
          </button>
        </div>
      </div>
    </div>

    <!-- 日志表格 -->
    <div class="bg-white rounded-lg shadow-sm">
      <div class="overflow-x-auto">
        <table class="min-w-full divide-y divide-gray-200">
          <thead class="bg-gray-50">
            <tr>
              <th class="px-4 py-3 text-left text-xs font-medium text-gray-500">时间</th>
              <th class="px-4 py-3 text-left text-xs font-medium text-gray-500">类型</th>
              <th class="px-4 py-3 text-left text-xs font-medium text-gray-500">操作人</th>
              <th class="px-4 py-3 text-left text-xs font-medium text-gray-500">内容</th>
            </tr>
          </thead>
          <tbody class="bg-white divide-y divide-gray-200">
            <tr v-for="log in filteredLogs" :key="log.id">
              <td class="px-4 py-3">{{ formatDate(log.timestamp) }}</td>
              <td class="px-4 py-3">
                <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full" :class="typeClassMap[log.type]">
                  {{ getTypeText(log.type) }}
                </span>
              </td>
              <td class="px-4 py-3">{{ log.user }}</td>
              <td class="px-4 py-3 truncate">{{ log.content }}</td>
            </tr>
          </tbody>
        </table>
      </div>

      <!-- 分页控件 -->
      <div class="px-4 py-3 flex items-center justify-between border-t border-gray-200">
        <p class="text-sm text-gray-700">
          当前第 <strong>{{ currentPage }}</strong> 页，共 <strong>{{ totalPages }}</strong> 页，合计 <strong>{{ total }}</strong> 条日志
        </p>
        <div class="flex space-x-1">
          <button @click="goToPage(1)" :disabled="currentPage === 1" class="px-2 py-1 border rounded">首页</button>
          <button @click="goToPage(currentPage - 1)" :disabled="currentPage === 1" class="px-2 py-1 border rounded">上一页</button>

          <span v-if="pageRange[0] > 1">...</span>
          <button v-for="page in pageRange" :key="page" @click="goToPage(page)"
            class="px-3 py-1 border text-sm"
            :class="{ 'bg-blue-500 text-white': page === currentPage }">
            {{ page }}
          </button>
          <span v-if="pageRange[pageRange.length - 1] < totalPages">...</span>

          <button @click="goToPage(currentPage + 1)" :disabled="currentPage === totalPages" class="px-2 py-1 border rounded">下一页</button>
          <button @click="goToPage(totalPages)" :disabled="currentPage === totalPages" class="px-2 py-1 border rounded">尾页</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue';
import axios from 'axios';

const searchQuery = ref('');
const searchMode = ref('operator'); // 新增：查询模式 operator/product/package
const typeFilter = ref('');
const dateFilter = ref('');
const logs = ref([]);
const currentPage = ref(1);
const pageSize = ref(10);
const total = ref(0);

const totalPages = computed(() => Math.ceil(total.value / pageSize.value));

const filteredLogs = computed(() => logs.value.map(log => ({
  id: log.id,
  timestamp: log.log_date,
  type: log.action_type,
  user: log.operator,
  content: log.remark
})).filter(log => {
  if (!dateFilter.value) return true;
  const date = new Date(log.timestamp);
  const now = new Date();
  switch (dateFilter.value) {
    case 'today':
      return date.toDateString() === now.toDateString();
    case 'yesterday':
      const yesterday = new Date(now);
      yesterday.setDate(now.getDate() - 1);
      return date.toDateString() === yesterday.toDateString();
    case 'week': {
      const weekStart = new Date(now);
      const day = now.getDay() || 7;
      weekStart.setDate(now.getDate() - day + 1);
      const weekEnd = new Date(weekStart);
      weekEnd.setDate(weekStart.getDate() + 7);
      return date >= weekStart && date < weekEnd;
    }
    case 'month': {
      const monthStart = new Date(now.getFullYear(), now.getMonth(), 1);
      const monthEnd = new Date(now.getFullYear(), now.getMonth() + 1, 1);
      return date >= monthStart && date < monthEnd;
    }
    default:
      return true;
  }
}));

const typeClassMap = {
  inbound_factory: 'bg-blue-100 text-blue-800',
  outbound_factory: 'bg-green-100 text-green-800',
  inbound_shop: 'bg-yellow-100 text-yellow-800',
  outbound_shop: 'bg-red-100 text-red-800'
};

const pageRange = computed(() => {
  const maxVisible = 5;
  let start = Math.max(1, currentPage.value - Math.floor(maxVisible / 2));
  let end = Math.min(totalPages.value, start + maxVisible - 1);
  if (end - start < maxVisible - 1) start = Math.max(1, end - maxVisible + 1);
  const range = [];
  for (let i = start; i <= end; i++) range.push(i);
  return range;
});

function getTypeText(type) {
  const map = {
    inbound_factory: '工厂入库',
    outbound_factory: '工厂出库',
    inbound_shop: '商店入库',
    outbound_shop: '商店出库'
  };
  return map[type] || '未知';
}

function formatDate(dateStr) {
  const date = new Date(dateStr);
  const y = date.getFullYear();
  const m = String(date.getMonth() + 1).padStart(2, '0');
  const d = String(date.getDate()).padStart(2, '0');
  const h = String(date.getHours()).padStart(2, '0');
  const i = String(date.getMinutes()).padStart(2, '0');
  const s = String(date.getSeconds()).padStart(2, '0');
  return `${y}-${m}-${d} ${h}:${i}:${s}`;
}

function onDateFilterChange() {
  currentPage.value = 1;
  fetchLogs();
}

async function fetchLogs() {
  try {
    const params = {
      shop_id: 2,
      page: currentPage.value,
      limit: pageSize.value
    };

    const trimmed = searchQuery.value.trim();
    if (trimmed !== '') {
      if (searchMode.value === 'operator') {
        params.operator = trimmed;
      } else if (searchMode.value === 'product') {
        params.product_id = trimmed;
      } else if (searchMode.value === 'package') {
        params.package_id = trimmed;
      }
    }

    if (typeFilter.value) {
      params.action_type = typeFilter.value;
    }

    const response = await axios.get('http://8.130.70.249:8080/api/logs', { params });
    logs.value = response.data.data || [];
    total.value = response.data.total || 0;
  } catch (error) {
    console.error('获取日志失败:', error);
  }
}

function searchLogs() {
  currentPage.value = 1;
  fetchLogs();
}

function goToPage(page) {
  if (page < 1 || page > totalPages.value) return;
  currentPage.value = page;
  fetchLogs();
}

onMounted(fetchLogs);
watch([typeFilter, pageSize, dateFilter], fetchLogs);
</script>


<style scoped>
button:disabled {
  cursor: not-allowed;
  opacity: 0.5;
}
</style>