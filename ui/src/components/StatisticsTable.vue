<template>
  <div>
    <div v-if="!tableData || tableData.length === 0" class="flex justify-center items-center h-40 text-gray-500">
      <div class="flex flex-col items-center">
        <svg xmlns="http://www.w3.org/2000/svg" class="h-12 w-12 text-gray-300 mb-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 10h18M3 14h18m-9-4v8m-7 0h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v8a2 2 0 002 2z" />
        </svg>
        <p>暂无数据</p>
      </div>
    </div>
    
    <div v-else>
      <!-- 表格内容 -->
      <div class="overflow-x-auto">
        <table class="min-w-full divide-y divide-gray-200">
          <thead class="bg-gray-50">
            <tr>
              <th scope="col" class="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                {{ periodLabel }}
              </th>
              <th scope="col" class="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                入库
              </th>
              <th scope="col" class="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                出库
              </th>
              <th scope="col" class="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                库存
              </th>
            </tr>
          </thead>
          <tbody class="bg-white divide-y divide-gray-200">
            <tr v-for="(item, index) in paginatedData" :key="index" 
                :class="[
                  index % 2 === 0 ? 'bg-white hover:bg-blue-50' : 'bg-gray-50 hover:bg-blue-50',
                  'transition-colors duration-150'
                ]">
              <td class="px-3 py-2 whitespace-nowrap text-sm font-medium text-gray-900">
                {{ item.period }}
              </td>
              <td class="px-3 py-2 whitespace-nowrap text-sm">
                <span class="inline-flex items-center text-green-600">
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-3 w-3 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 11l5-5m0 0l5 5m-5-5v12" />
                  </svg>
                  {{ formatNumber(item.inbound) }}
                </span>
              </td>
              <td class="px-3 py-2 whitespace-nowrap text-sm">
                <span class="inline-flex items-center text-red-600">
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-3 w-3 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 13l-5 5m0 0l-5-5m5 5V6" />
                  </svg>
                  {{ formatNumber(item.outbound) }}
                </span>
              </td>
              <td class="px-3 py-2 whitespace-nowrap text-sm font-medium text-blue-600">
                {{ formatNumber(item.inventory) }}
              </td>
            </tr>
          </tbody>
          <tfoot class="bg-gray-50">
            <tr>
              <td class="px-3 py-2 whitespace-nowrap text-sm font-medium text-gray-900">
                合计
              </td>
              <td class="px-3 py-2 whitespace-nowrap text-sm font-medium text-green-600">
                {{ formatNumber(totalInbound) }}
              </td>
              <td class="px-3 py-2 whitespace-nowrap text-sm font-medium text-red-600">
                {{ formatNumber(totalOutbound) }}
              </td>
              <td class="px-3 py-2 whitespace-nowrap text-sm font-medium text-blue-600">
                {{ tableData.length > 0 ? formatNumber(tableData[tableData.length - 1].inventory) : 0 }}
              </td>
            </tr>
          </tfoot>
        </table>
      </div>
      
      <!-- 分页控制器 -->
      <div v-if="totalPages > 1" class="flex justify-between items-center mt-3 px-1">
        <button 
          @click="prevPage" 
          class="flex items-center justify-center w-7 h-7 rounded-full text-gray-500 hover:bg-gray-100 disabled:opacity-40 disabled:cursor-not-allowed"
          :disabled="currentPage === 1"
          title="上一页"
        >
          <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
          </svg>
        </button>
        
        <div class="flex items-center space-x-1">
          <button 
            v-for="page in displayedPageNumbers" 
            :key="page" 
            @click="goToPage(page)"
            class="flex items-center justify-center w-6 h-6 rounded-full text-xs font-medium"
            :class="page === currentPage 
              ? 'bg-blue-100 text-blue-600' 
              : 'text-gray-500 hover:bg-gray-100'"
          >
            {{ page }}
          </button>
        </div>
        
        <button 
          @click="nextPage" 
          class="flex items-center justify-center w-7 h-7 rounded-full text-gray-500 hover:bg-gray-100 disabled:opacity-40 disabled:cursor-not-allowed"
          :disabled="currentPage === totalPages"
          title="下一页"
        >
          <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
          </svg>
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed, ref, watch } from 'vue';

// 定义props
const props = defineProps({
  tableData: {
    type: Array,
    required: true,
    default: () => []
  },
  timeRange: {
    type: String,
    default: 'daily'
  }
});

// 状态变量
const currentPage = ref(1);

// 根据时间范围确定每页显示数量
const itemsPerPage = computed(() => {
  switch (props.timeRange) {
    case 'daily':
      return 7;
    case 'monthly':
      return 6;
    case 'quarterly':
      return 4;
    case 'yearly':
      return 6;
    default:
      return 7;
  }
});

// 根据时间范围确定周期标签
const periodLabel = computed(() => {
  switch (props.timeRange) {
    case 'daily':
      return '日期';
    case 'monthly':
      return '月份';
    case 'quarterly':
      return '季度';
    case 'yearly':
      return '年份';
    default:
      return '周期';
  }
});

// 计算总页数
const totalPages = computed(() => {
  return Math.ceil(props.tableData.length / itemsPerPage.value);
});

// 计算当前页显示的数据
const paginatedData = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage.value;
  const end = start + itemsPerPage.value;
  return props.tableData.slice(start, end);
});

// 计算要显示的页码
const displayedPageNumbers = computed(() => {
  const pages = [];
  const maxVisiblePages = 5; // 最多显示5个页码
  
  if (totalPages.value <= maxVisiblePages) {
    // 如果总页数小于等于最大可见页数，显示所有页码
    for (let i = 1; i <= totalPages.value; i++) {
      pages.push(i);
    }
  } else {
    // 否则，显示当前页附近的页码
    let startPage = Math.max(1, currentPage.value - Math.floor(maxVisiblePages / 2));
    let endPage = startPage + maxVisiblePages - 1;
    
    if (endPage > totalPages.value) {
      endPage = totalPages.value;
      startPage = Math.max(1, endPage - maxVisiblePages + 1);
    }
    
    for (let i = startPage; i <= endPage; i++) {
      pages.push(i);
    }
  }
  
  return pages;
});

// 计算总入库量
const totalInbound = computed(() => {
  return props.tableData.reduce((sum, item) => sum + item.inbound, 0);
});

// 计算总出库量
const totalOutbound = computed(() => {
  return props.tableData.reduce((sum, item) => sum + item.outbound, 0);
});

// 分页控制
const nextPage = () => {
  if (currentPage.value < totalPages.value) {
    currentPage.value++;
  }
};

const prevPage = () => {
  if (currentPage.value > 1) {
    currentPage.value--;
  }
};

const goToPage = (page) => {
  currentPage.value = page;
};

// 当时间范围或数据变化时，重置到第一页
watch([() => props.timeRange, () => props.tableData], () => {
  currentPage.value = 1;
});

// 格式化数字
const formatNumber = (num) => {
  return new Intl.NumberFormat('zh-CN').format(num);
};
</script>